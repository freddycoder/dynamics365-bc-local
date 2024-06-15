page 50103 "API Dimension"
{
    APIGroup = 'extension';
    APIPublisher = 'freddycoder';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'apiDimension';
    DelayedInsert = true;
    EntityName = 'defaultDimension';
    EntitySetName = 'defaultDimensions';
    PageType = API;
    SourceTable = "Default Dimension";

    layout
    {
        area(content)
        {
            repeater(Fields)
            {
                field(tableId; Rec."Table ID")
                {
                    Caption = 'Table ID';
                }

                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }

                field(dimensionCode; Rec."Dimension Code")
                {
                    Caption = 'Dimension Code';
                }

                field(dimensionCodeValue; Rec."Dimension Value Code")
                {
                    Caption = 'Dimension Code Value';
                }
            }
        }
    }
}