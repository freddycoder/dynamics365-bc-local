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
    begin
        Base64Text := Base64.ToBase64(Text);

        Base64Text := EncodeUrl(Base64Text);

        exit(Base64Text);
    end;

    procedure EncodeUrl(Text: Text): Text
    var
        Base64Text: Text;
    begin
        Base64Text := Text.Replace('+', '-');
        Base64Text := Base64Text.Replace('/', '_');
        Base64Text := Base64Text.Replace('=', '');

        exit(Base64Text);
    end;

    procedure Computext5sha256(Cert: Record "Isolated Certificate"; SignatureKey: Codeunit "Signature Key"): Text
    var
        CertificateManagment: Codeunit "Certificate Management";
        CryptographyManagement: Codeunit "Cryptography Management";
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
        certRawData: Text;
        certHash: Text;
        certHashBase64: Text;
        x5t: Text;
    begin
        CertificateManagment.GetCertPrivateKey(Cert, SignatureKey);

        certRawData := CertificateManagment.GetRawCertDataAsBase64String(Cert);

        certHash := CryptographyManagement.GenerateHashAsBase64String(certRawData, 2);

        x5t := EncodeUrl(certHash);

        exit(x5t);
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
        RSA: Codeunit RSACryptoServiceProvider;
        SignatureKey: Codeunit "Signature Key";
        HashAlgorithm: Enum "Hash Algorithm";
        x5t: Text;
        b64: Codeunit "Base64 Convert";
        outStream: OutStream;
        inStream: InStream;
        tempBlob: Codeunit "Temp Blob";
        TypeHelper: Codeunit "Type Helper";
    begin
        JwtHeader.Add('alg', 'RS256');
        JwtHeader.Add('typ', 'JWT');

        if ApiSetup."x5t#S256" = '' then
            x5t := Computext5sha256(Cert, SignatureKey)
        else
            x5t := ApiSetup."x5t#S256";

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

        JwtSignature := CreateJwtSignature(JwtTokenText, Cert);

        JwtTokenText := JwtTokenText + '.' + JwtSignature;

        exit(JwtTokenText);
    end;

    procedure CreateJwtSignature(JwtTokenText: Text; Cert: Record "Isolated Certificate"): Text
    var
        TempBlob: Codeunit "Temp Blob";
        JwtSignature: Text;
        JwtSignatureBase64: Text;
        CryptographyManagement: Codeunit "Cryptography Management";
        CertificateManagement: Codeunit "Certificate Management";
        HashAlgorithm: Enum "Hash Algorithm";
        OutStream: OutStream;
        InStream: InStream;
        SignKey: Codeunit "Signature Key";
    begin
        OutStream := TempBlob.CreateOutStream();
        CertificateManagement.GetCertPrivateKey(Cert, SignKey);
        CryptographyManagement.SignData(JwtTokenText, SignKey, HashAlgorithm::SHA256, OutStream);
        InStream := TempBlob.CreateInStream();
        InStream.ReadText(JwtSignature);
        JwtSignatureBase64 := EncodeUrlBase64(JwtSignature);
        exit(JwtSignatureBase64);
    end;
}