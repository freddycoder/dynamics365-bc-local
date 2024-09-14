page 50132 "EAPI Setup Page"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "EAPI Setup";
    CardPageId = "EAPI Setup Page";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'The code of the EAPI setup.';
                    ShowMandatory = true;
                }
                field("API URL"; Rec."API URL")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if Rec."API URL".EndsWith('/') then
                            Rec."API URL" := Rec."API URL".Substring(0, StrLen(Rec."API URL") - 1);
                    end;
                }
                field("Client Id"; Rec."Client Id")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Audiance"; Rec."Audiance")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Scope"; Rec."Scope")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field("Edit Client Certificate"; editCert)
                {
                    ApplicationArea = All;
                }
                field("Client Certificate Base64"; certificateContent)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Editable = editCert;

                    trigger OnValidate()
                    var
                        outStream: OutStream;
                        x509Certificate: Codeunit X509Certificate2;
                    begin
                        Rec."Client Certificate Base64".CreateOutStream(outStream);
                        outStream.WriteText(certificateContent);

                        ClearCertificateHashes();
                    end;
                }
                field("Client Certificate Password"; Rec."Client Certificate Password")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field("x5t#S256"; Rec."x5t#S256")
                {
                    ApplicationArea = All;
                }
                field("Authentication Method"; Rec."Authentication Method")
                {
                    ApplicationArea = All;
                }
                field("API Token"; Rec."API Token")
                {
                    ApplicationArea = All;
                }
                field("Token valid until"; Rec."Token valid until")
                {
                    ApplicationArea = All;
                }
            }

            group("Hash informations")
            {
                field("MD5"; MD5)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SHA1"; SHA1)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SHA256"; SHA256)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("xt5sha256"; xt5tS256)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SHA512"; SHA512)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("MD5 Base64"; MD5Base64)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SHA1 Base64"; SHA1Base64)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SHA256 Base64"; SHA256Base64)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("xt5sha256 Base64"; xt5tS256Base64)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SHA512 Base64"; SHA512Base64)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Refresh token")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Refresh;
                Enabled = true;
                trigger OnAction()
                begin
                    Rec.GetAuthenticationToken(true);
                end;
            }

            action("Test connection")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = TestDatabase;
                Enabled = true;
                trigger OnAction()
                var
                    HttpClient: HttpClient;
                    Resp: HttpResponseMessage;
                begin
                    HttpClient.Get(Rec."API URL" + '/Erablieres', Resp);
                    Message(Resp.ReasonPhrase);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalculateCertificateHashes();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CalculateCertificateHashes();
        exit(true);
    end;

    procedure CalculateCertificateHashes()
    var
        X509Certificate2: Codeunit X509Certificate2;
        PrivateKey: Text;
        SignKey: Codeunit "Signature Key";
        CertMgmnt: Codeunit "Certificate Management";
        Crypto: Codeunit "Cryptography Management";
        HttpUtils: Codeunit "HttpAuthUtils";
        certData: Text;
    // MD5, SHA1, SHA256, SHA384, and SHA512
    begin
        Rec.CalcFields("Client Certificate Base64");
        if (Rec."Client Certificate Base64".HasValue()) then begin

            certData := Rec.GetCertificateBase64();

            PrivateKey := X509Certificate2.GetCertificatePrivateKey(certData, Rec."Client Certificate Password");

            MD5 := Crypto.GenerateHash(certData, 0);
            SHA1 := Crypto.GenerateHash(certData, 1);
            SHA256 := Crypto.GenerateHash(certData, 2);
            xt5tS256 := HttpUtils.Computext5sha256(certData);
            SHA384 := Crypto.GenerateHash(certData, 3);
            SHA512 := Crypto.GenerateHash(certData, 4);

            MD5Base64 := Crypto.GenerateHashAsBase64String(certData, 0);
            SHA1Base64 := Crypto.GenerateHashAsBase64String(certData, 1);
            SHA256Base64 := Crypto.GenerateHashAsBase64String(certData, 2);
            xt5tS256Base64 := HttpUtils.Computext5sha256(certData);
            SHA384Base64 := Crypto.GenerateHashAsBase64String(certData, 3);
            SHA512Base64 := Crypto.GenerateHashAsBase64String(certData, 4);
        end
        else
            ClearCertificateHashes();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        certificateContent := Rec.GetCertificateBase64();
        CalculateCertificateHashes();
    end;

    local procedure ClearCertificateHashes()
    begin
        MD5 := '';
        SHA1 := '';
        SHA256 := '';
        xt5tS256 := '';
        SHA384 := '';
        SHA512 := '';

        MD5Base64 := '';
        SHA1Base64 := '';
        SHA256Base64 := '';
        xt5tS256Base64 := '';
        SHA384Base64 := '';
        SHA512Base64 := '';
    end;

    var
        certificateContent: Text;
        editCert: Boolean;

        MD5: Text;
        SHA1: Text;
        SHA256: Text;
        xt5tS256: Text;
        SHA384: Text;
        SHA512: Text;

        MD5Base64: Text;
        SHA1Base64: Text;
        SHA256Base64: Text;
        xt5tS256Base64: Text;
        SHA384Base64: Text;
        SHA512Base64: Text;
}