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

                field("Invoice Customer"; Rec."Invoice Customer")
                {
                    ApplicationArea = All;
                    TableRelation = "Customer";

                    trigger OnValidate()
                    var
                        Customer: Record "Customer";
                    begin
                        if Rec."Invoice Customer" = '' then
                            exit;

                        if not Customer.Get(Rec."Invoice Customer") then
                            Error('Customer not found');

                        Rec."Invoice Contact" := Customer."Primary Contact No.";
                    end;
                }

                field("Invoice Contact"; Rec."Invoice Contact")
                {
                    ApplicationArea = All;
                    TableRelation = "Contact";

                    trigger OnValidate()
                    var
                        Contact: Record "Contact";
                    begin
                        if Rec."Invoice Contact" = '' then
                            exit;

                        if not Contact.Get(Rec."Invoice Contact") then
                            Error('Contact not found');

                        Rec."Invoice Customer" := Contact."Company No.";
                    end;
                }
            }
        }
    }
}