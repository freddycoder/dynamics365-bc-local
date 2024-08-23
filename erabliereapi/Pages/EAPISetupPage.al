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
                field("Client Certificate"; Rec."Client Certificate")
                {
                    ApplicationArea = All;
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
        Cert: Record "Isolated Certificate";
        SignKey: Codeunit "Signature Key";
        CertMgmnt: Codeunit "Certificate Management";
        Crypto: Codeunit "Cryptography Management";
        HttpUtils: Codeunit "HttpAuthUtils";
        certData: Text;
    // MD5, SHA1, SHA256, SHA384, and SHA512
    begin
        if (Rec."Client Certificate" <> '') and (Cert.Get(Rec."Client Certificate")) then begin

            certData := CertMgmnt.GetRawCertDataAsBase64String(Cert);
            CertMgmnt.GetCertPrivateKey(Cert, SignKey);

            MD5 := Crypto.GenerateHash(certData, 0);
            SHA1 := Crypto.GenerateHash(certData, 1);
            SHA256 := Crypto.GenerateHash(certData, 2);
            xt5tS256 := HttpUtils.Computext5sha256(Cert, SignKey);
            SHA384 := Crypto.GenerateHash(certData, 3);
            SHA512 := Crypto.GenerateHash(certData, 4);

            MD5Base64 := Crypto.GenerateHashAsBase64String(certData, 0);
            SHA1Base64 := Crypto.GenerateHashAsBase64String(certData, 1);
            SHA256Base64 := Crypto.GenerateHashAsBase64String(certData, 2);
            xt5tS256Base64 := HttpUtils.Computext5sha256(Cert, SignKey);
            SHA384Base64 := Crypto.GenerateHashAsBase64String(certData, 3);
            SHA512Base64 := Crypto.GenerateHashAsBase64String(certData, 4);
        end;
    end;

    var
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