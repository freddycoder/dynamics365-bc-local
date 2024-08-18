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
        field(12; "Scope"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Client Secret"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(16; "Client Certificate"; Text[150])
        {
            DataClassification = CustomerContent;
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