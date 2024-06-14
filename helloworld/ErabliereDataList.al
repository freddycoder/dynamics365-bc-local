page 50102 "ErabliereData List"
{
    // Specify that this page will be a list page.
    PageType = List;

    // The page will be part of the "Lists" group of search results.
    UsageCategory = Lists;

    // The data of this page is taken from the "Reward" table.
    SourceTable = ErabliereDataTable;

    // The "CardPageId" is set to the Reward Card previously created.
    // This will allow users to open records from the list in the "Reward Card" page.
    CardPageId = "ErabliereData Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // The repeater will show the fields in the order they are defined in the table.
                // The fields are shown in the order they are defined in the table.
                // The fields are shown in the order they are defined in the table.
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }

                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }

                field(Capacity; Rec.Capacity)
                {
                    ApplicationArea = All;
                }

                field("Sensor Id"; Rec.SensorId)
                {
                    ApplicationArea = All;
                }

                field("Sensor Type"; Rec.SensorType)
                {
                    ApplicationArea = All;
                }

                field("Sensor Value"; Rec.SensorValue)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}