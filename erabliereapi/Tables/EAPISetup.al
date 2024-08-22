table 50125 "EAPI Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(5; "API URL"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Client Id"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Audiance"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(13; "ErabliereAPI Client Id"; Text[39])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Scope"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Client Secret"; Text[150])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (Rec."Client Certificate" = '') and (Rec."Client Secret" <> '') then
                    Rec."Authentication Method" := Rec."Authentication Method"::"Client Secret";
            end;
        }
        field(16; "x5t#S256"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(17; "Client Certificate"; Text[150])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                CertificateManagement: Codeunit "Certificate Management";
                Cert: Record "Isolated Certificate";
            begin
                if (Rec."Client Certificate" = '') and (Rec."Client Secret" = '') and Cert.FindFirst() then
                    Rec."Client Certificate" := Cert.Code;
            end;
        }
        field(18; "Client Certificate Password"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(19; "Authentication Method"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Client Secret","Client Certificate";
        }
        field(20; "API Token"; Blob)
        {
            DataClassification = SystemMetadata;
        }
        field(25; "Token valid until"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        ApiWebservice: Codeunit "Api Web Service";

    procedure GetAuthenticationToken(ForceRenewal: Boolean): Text
    begin
        exit(ApiWebservice.GetFreshAuthenticationToken(Rec, Rec."Token valid until"));
    end;
}