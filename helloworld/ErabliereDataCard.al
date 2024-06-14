page 50101 "ErabliereData Card"
{
    // The page will be of type "Card" and will render as a card.
    PageType = Card;

    // The page will be part of the "Tasks" group of search results.
    UsageCategory = Tasks;

    // The source table shows data from the "Reward" table.
    SourceTable = ErabliereDataTable;

    // The layout describes the visual parts on the page.
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    // ApplicationArea sets the application area that 
                    // applies to the page field and action controls. 
                    // Setting the property to All means that the control 
                    // will always appear in the user interface.
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