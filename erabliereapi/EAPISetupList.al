page 50134 "EAPI Setup List"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "EAPI Setup";
    CardPageId = "EAPI Setup List";

    layout
    {
        area(content)
        {
            repeater("EAPI Setup")
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'The code of the EAPI setup.';
                }

                field("API URL"; Rec."API URL")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}