page 50102 "Erabliere List"
{
    // Specify that this page will be a list page.
    PageType = List;

    // The page will be part of the "Lists" group of search results.
    UsageCategory = Lists;

    // The data of this page is taken from the "Reward" table.
    SourceTable = Erablieres;

    // The "CardPageId" is set to the Reward Card previously created.
    // This will allow users to open records from the list in the "Reward Card" page.
    CardPageId = "Erabliere Card";

    layout
    {
        area(content)
        {
            repeater(Erabliere)
            {
                field("Erabliere ID"; Rec."Erabliere ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifie the ID of the Erabliere.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}