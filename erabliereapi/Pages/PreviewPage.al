page 50100 PreviewPage
{
    Caption = 'Preview Page';
    UsageCategory = None;
    SourceTable = Preview;

    Layout
    {
        area(Content)
        {
            repeater(Preview)
            {
                field("No."; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Item number';
                }

                field("Item"; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Item identifier';
                }

                field("Error"; Rec.Error)
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }

                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area("Processing")
        {
            Description = 'Create invoices';
            ToolTip = 'Create invoices for all items';

            action("Create Invoices")
            {
                Promoted = true;
                ApplicationArea = All;
                Caption = 'Create';
                Image = NewSalesInvoice;

                trigger OnAction()
                var
                    Count: Integer;
                    i: Integer;
                    createEAPIInvoice: Codeunit CreateEAPIInvoice;
                    invoices: Page "Sales Invoice List";
                begin
                    if createEAPIInvoice.CreateSalesInvoiceWorkflow(false) then begin
                        if Dialog.Confirm('Do you want to oepn the invoices page?') then begin
                            invoices.Run();
                        end;
                        Close();
                    end;
                end;
            }
        }

        // area(Promoted)
        // {
        //     actionref("Create Invoice")
        //     {

        //     }
        // }
    }
}
