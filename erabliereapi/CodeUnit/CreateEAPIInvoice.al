codeunit 50102 CreateEAPIInvoice
{
    procedure CreateSalesInvoiceWorkflow(Preview: Boolean): Boolean
    var
        ErablieresRec: Record "Erablieres";
        Customers: Record Customer;
        Count: Integer;
        i: Integer;
        Dialog: Codeunit "DynDialog";
    begin
        i := 1;
        if ErablieresRec.FindSet() then begin
            Count := ErablieresRec.Count();
            Dialog.Open(Count);
            repeat begin
                Dialog.UpdateName(i, ErablieresRec.Description);
                if ErablieresRec."Invoice Customer" <> '' then begin
                    Dialog.UpdateDescription(i, 'Creating invoice for customer ' + ErablieresRec."Invoice Contact" + ' ' + Customers.Name + '.');
                    CreateSalesInvoice(Dialog, ErablieresRec."Invoice Customer", Preview, i);
                end
                else
                    Dialog.UpdateError(i, 'No customer for ' + ErablieresRec.Description + ', no invoice created.');
                Sleep(100);
                i += 1;
            end until ErablieresRec.Next() = 0;
            if Preview then
                Dialog.DisplayAsPreviewPage();
            exit(true);
        end
        else
            Dialog.PrettyMessage('Without Erablieres, no invoice can be created');

        exit(false);
    end;

    local procedure CreateSalesInvoice(var Dialog: Codeunit DynDialog; CustomerNo: Code[20]; Preview: Boolean; i: Integer)
    var
        SalesHeader: Record "Sales Header";
        Series: Record "No. Series";
        SalesLine: Record "Sales Line";
        NoSeries: Record "No. Series";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        Customer: Record Customer;
        InvoiceNo: Code[20];
    begin
        // Initialize a new Sales Invoice header
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."Posting Date" := WorkDate();
        SalesHeader."Sell-to Customer No." := CustomerNo;
        SalesHeader."No. Series" := 'S-INV';
        if Preview then begin
            // validate the Sell-to Customer No. field
            if not Customer.Get(SalesHeader."Sell-to Customer No.") then begin
                Dialog.UpdateError(i, 'Customer ' + SalesHeader."Sell-to Customer No." + ' does not exist.');
            end;
        end;
        if not Preview then begin
            SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesHeader."No. Series", SalesHeader."Posting Date", true);
            SalesHeader.Insert(true);

            // Initialize a new Sales Invoice line
            SalesLine.Init();
            SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
            SalesLine."Document No." := SalesHeader."No.";
            SalesLine.Type := SalesLine.Type::Item;
            SalesLine.Insert(true);
        end;
    end;
}