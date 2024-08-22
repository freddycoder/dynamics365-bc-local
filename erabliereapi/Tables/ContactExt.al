tableextension 50100 ContactExt extends Contact
{
    fields
    {
        field(50100; "ErabliereAPI Account Type"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(50101; "ErabliereAPI Stripe ID"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(50102; "ErabliereAPI Ext. Account Url"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(50103; "ErabliereAPI Creation Time"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50104; "ErabliereAPI Last Update Time"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50105; "ErabliereAPI Unique Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key("EAPI Unique Name"; "ErabliereAPI Unique Name")
        {

        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}