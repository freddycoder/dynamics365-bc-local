pageextension 50102 SalesInvoiceListExt extends "Sales Invoice List"
{
    actions
    {
        addlast("&Invoice")
        {
            action("Delete All")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Delete All';
                ToolTip = 'Delete all invoices';
                Image = Delete;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    if Dialog.Confirm('Are you sure you want to delete every invoice?') then begin
                        SalesHeader.Reset();
                        while SalesHeader.FindSet() do
                            SalesHeader.Delete();
                    end;
                end;
            }
        }
    }
}