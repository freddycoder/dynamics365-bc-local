codeunit 50148 HttpAuthUtils
{
    procedure GetCertificate(CertificateCode: Text[20]; Password: Text[20]): Record "Isolated Certificate"
    var
        IsolatedCertificat: Record "Isolated Certificate";
        CertificateManagment: Codeunit "Certificate Management";
        SignatureKey: Codeunit "Signature Key";
    begin
        if not IsolatedCertificat.Get(CertificateCode) then
            Error('ErabliereAPI.GetCertificate::Error: Certificate not found');

        exit(IsolatedCertificat);
    end;

    procedure EncodeUrlBase64(JsonObject: JsonObject): Text
    var
        JsonText: Text;
        JsonBase64: Text;
        Base64: Codeunit "Base64 Convert";
    begin
        JsonObject.WriteTo(JsonText);
        exit(EncodeUrlBase64(JsonText));
    end;

    procedure EncodeUrlBase64(Text: Text): Text
    var
        JsonText: Text;
        Base64Text: Text;
        Base64: Codeunit "Base64 Convert";

        Base64PadCharacter: Text[1];
        Base64Character62: Text[1];
        Base64Character63: Text[1];
        Base64UrlCharacter62: Text[1];
        Base64UrlCharacter63: Text[1];

        ArrayToken: List of [Text];
    begin
        Base64PadCharacter := '=';
        Base64Character62 := '+';
        Base64Character63 := '/';
        Base64UrlCharacter62 := '-';
        Base64UrlCharacter63 := '_';

        Base64Text := Base64.ToBase64(Text);

        ArrayToken := Base64Text.Split(Base64PadCharacter);
        Base64Text := ArrayToken.Get(1);
        Base64Text := Base64Text.Replace(Base64Character62, Base64UrlCharacter62);
        Base64Text := Base64Text.Replace(Base64Character63, Base64UrlCharacter63);

        exit(Base64Text);
    end;

    procedure ComputeClientAssertion(ApiSetup: Record "EAPI Setup"; Cert: Record "Isolated Certificate"): Text
    var
        JwtHeader: JsonObject;
        JwtPayload: JsonObject;
        JwtSignature: Text;

        JwtToken: JsonToken;
        JwtHeaderBase64: Text;
        JwtPayloadBase64: Text;
        JwtTokenText: Text;

        Utils: Codeunit "Utils";
        CertificateManagment: Codeunit "Certificate Management";
        CryptographyManagement: Codeunit "Cryptography Management";
        SignatureKey: Codeunit "Signature Key";
        HashAlgorithm: Enum "Hash Algorithm";

        certHash: Text;
        x5t: Text;
        HashAlgorithmType: Option HMACMD5,HMACSHA1,HMACSHA256,HMACSHA384,HMACSHA512;
    begin
        CertificateManagment.GetCertPrivateKey(Cert, SignatureKey);

        JwtHeader.Add('alg', 'RS256');
        JwtHeader.Add('typ', 'JWT');
        certHash := CryptographyManagement.GenerateHash(CertificateManagment.GetRawCertDataAsBase64String(Cert), HashAlgorithmType::HMACSHA256);
        x5t := EncodeUrlBase64(certHash);
        JwtHeader.Add('x5t#S256', x5t);

        JwtHeaderBase64 := EncodeUrlBase64(JwtHeader);

        JwtPayload.Add('aud', ApiSetup.Audiance);
        JwtPayload.Add('iss', ApiSetup."Client Id");
        JwtPayload.Add('exp', Utils.GetUnixTimestamp() + 60);
        JwtPayload.Add('jti', Format(CreateGuid()).Replace('{', '').Replace('}', ''));
        JwtPayload.Add('nbf', Utils.GetUnixTimestamp());
        JwtPayload.Add('sub', ApiSetup."Client Id");

        JwtPayloadBase64 := EncodeUrlBase64(JwtPayload);

        JwtTokenText := JwtHeaderBase64 + '.' + JwtPayloadBase64;

        JwtSignature := CreateJwtSignature(JwtTokenText, SignatureKey);

        JwtTokenText := JwtTokenText + '.' + JwtSignature;

        exit(JwtTokenText);
    end;

    procedure CreateJwtSignature(JwtTokenText: Text; SignKey: Codeunit "Signature Key"): Text
    var
        TempBlob: Codeunit "Temp Blob";
        JwtSignature: Text;
        JwtTokenBase64: Text;
        JwtSignatureBase64: Text;
        CryptographyManagement: Codeunit "Cryptography Management";
        HashAlgorithm: Enum "Hash Algorithm";
        OutStream: OutStream;
        InStream: InStream;
        TypeHelper: Codeunit "Type Helper";
    begin
        OutStream := TempBlob.CreateOutStream();
        CryptographyManagement.SignData(JwtTokenText, SignKey, HashAlgorithm::SHA256, OutStream);
        InStream := TempBlob.CreateInStream();
        JwtSignature := TypeHelper.ReadAsTextWithSeparator(InStream, '');
        JwtSignatureBase64 := EncodeUrlBase64(JwtSignature);
        exit(JwtSignatureBase64);
    end;
}