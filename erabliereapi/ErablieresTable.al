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

        // The "Description" field can contain a string 
        // with up to 250 characters.
        field(2; Description; Text[250])
        {
            // This property specified that 
            // this field cannot be left empty.
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