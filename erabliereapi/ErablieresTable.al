table 50100 Erablieres
{
    DataClassification = ToBeClassified;

    fields
    {
        // The "Erabliere ID" field represents the unique identifier 
        // of the reward and can contain up to 30 Code characters. 
        field(1; "Erabliere ID"; Code[39])
        {
            DataClassification = ToBeClassified;
        }

        field(2; Description; Text[250])
        {
            NotBlank = true;
        }

        field(3; Duration; Duration)
        {
            DataClassification = ToBeClassified;
        }

        field(4; DurationText; Text[25])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Utils: Codeunit "Utils";
            begin
                Duration := Utils.ParseISODuration(DurationText);
            end;
        }

        field(5; "Invoice Contact"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(6; "Invoice Customer"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(7; "Last Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // The field "Reward ID" is used as the primary key of this table.
        key(PK; "Erabliere ID")
        {
            // Create a clustered index from this key.
            Clustered = true;
        }
    }
}