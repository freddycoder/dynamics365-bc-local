page 50101 "Erabliere Card"
{
    PageType = Card;
    UsageCategory = Tasks;
    SourceTable = Erablieres;

    layout
    {
        area(content)
        {
            group(Erabliere)
            {
                field("Erabliere Id"; Rec."Erabliere ID")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field("Duration"; Rec.Duration)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Duration Text"; Rec.DurationText)
                {
                    ApplicationArea = All;
                    ToolTip = 'A duration writen as text. Ex: PT1H30M';
                }
            }
        }
    }
}