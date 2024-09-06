pageextension 50103 MyExtension extends "Contact Card"
{
    layout
    {
        addafter(General)
        {
            group("ErabliereAPI")
            {
                field("ErabliereAPI Unique Name"; Rec."ErabliereAPI Unique Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifie the unique name of the contact in ErabliereAPI.';
                }

                field("ErabliereAPI Account Type"; Rec."ErabliereAPI Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifie the account type of the contact in ErabliereAPI.';
                }

                field("ErabliereAPI Stripe ID"; Rec."ErabliereAPI Stripe ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifie the stripe ID of the contact in ErabliereAPI.';
                }

                field("ErabliereAPI Ext. Account Url"; Rec."ErabliereAPI Ext. Account Url")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifie the external account URL of the contact in ErabliereAPI.';
                }

                field("ErabliereAPI Creation Time"; Rec."ErabliereAPI Creation Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifie the creation time of the contact in ErabliereAPI.';
                }

                field("ErabliereAPI Last Update Time"; Rec."ErabliereAPI Last Update Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifie the last update time of the contact in ErabliereAPI.';
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}