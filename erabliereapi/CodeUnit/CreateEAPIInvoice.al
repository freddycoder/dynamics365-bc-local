codeunit 50102 CreateEAPIInvoice
{
    procedure CreateSalesInvoices(Preview: Boolean): Boolean
    var
        ErablieresRec: Record "Erablieres";
        Customers: Record Customer;
        Count: Integer;
        i: Integer;
        Dialog: Codeunit "DynDialog";
    begin
        i := 0;
        if ErablieresRec.FindSet() then begin

            if Customers.FindSet() then begin
                repeat
                    ErablieresRec.SetFilter("Invoice Customer", Customers."No.");
                    Count := ErablieresRec.Count;
                    if Count > 0 then
                        i += 1;
                until Customers.Next = 0;
            end
            else begin
                Dialog.PrettyMessage('No customers found');
                exit(false);
            end;

            if i = 0 then begin
                Dialog.PrettyMessage('No Erablieres found for any customer');
                exit(false);
            end;

            Dialog.Open(i);
            i := 1;

            Customers.Reset();

            if Customers.FindSet() then begin
                repeat
                    ErablieresRec.SetFilter("Invoice Customer", Customers."No.");
                    Count := ErablieresRec.Count;
                    if Count > 0 then begin
                        Dialog.UpdateName(i, Customers.Name);
                        Dialog.UpdateDescription(i, 'Erablieres: ' + Format(Count));
                        if (Customers."No." = '') then begin
                            Dialog.UpdateError(i, 'Customer No. is empty');
                        end
                        else
                            CreateSalesInvoice(Dialog, Customers, Preview, i, Count);
                        i += 1;
                    end;
                until Customers.Next = 0;
            end;

            if Preview then
                Dialog.DisplayAsPreviewPage();

            exit(true);
        end
        else
            Dialog.PrettyMessage('Without Erablieres, no invoice can be created');

        exit(false);
    end;

    local procedure CreateSalesInvoice(var Dialog: Codeunit DynDialog; var Customer: Record Customer; Preview: Boolean; i: Integer; CountErabliere: Integer)
    var
        SalesHeader: Record "Sales Header";
        Series: Record "No. Series";
        SalesLine: Record "Sales Line";
        NoSeries: Record "No. Series";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        InvoiceNo: Code[20];
    begin
        // Initialize a new Sales Invoice header
        SalesHeader.Init();
        SalesHeader."No. Series" := 'S-INV';
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."Posting Date" := WorkDate();
        SalesHeader."Due Date" := WorkDate() + 30;
        SalesHeader."Sell-to Customer No." := Customer."No.";
        SalesHeader."Sell-to Customer Name" := Customer.Name;
        SalesHeader."Sell-to Address" := Customer.Address;
        SalesHeader."Sell-to City" := Customer.City;
        SalesHeader."Sell-to Post Code" := Customer."Post Code";
        SalesHeader."Sell-to Country/Region Code" := Customer."Country/Region Code";
        SalesHeader."Sell-to Contact" := Customer.Contact;
        SalesHeader."Sell-to Contact No." := Customer."Primary Contact No.";
        SalesHeader."Sell-to Phone No." := Customer."Phone No.";
        SalesHeader."Sell-to E-Mail" := Customer."E-Mail";
        SalesHeader."Bill-to Customer No." := Customer."No.";
        SalesHeader."Bill-to Name" := Customer.Name;
        SalesHeader."Bill-to Address" := Customer.Address;
        SalesHeader."Bill-to City" := Customer.City;
        SalesHeader."Bill-to Post Code" := Customer."Post Code";
        SalesHeader."Bill-to Country/Region Code" := Customer."Country/Region Code";
        SalesHeader."Bill-to Contact" := Customer.Contact;
        SalesHeader."Bill-to Contact No." := Customer."Primary Contact No.";
        SalesHeader."Currency Code" := Customer."Currency Code";
        SalesHeader."Payment Terms Code" := Customer."Payment Terms Code";
        SalesHeader."Payment Method Code" := Customer."Payment Method Code";
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
            SalesLine.Validate("No.", '1006');
            SalesLine.Quantity := 1;
            SalesLine."Line No." := 10000;
            SalesLine.UpdateAmounts();
            SalesLine.Insert(true);

            SalesLine.Init();
            SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
            SalesLine."Document No." := SalesHeader."No.";
            SalesLine.Type := SalesLine.Type::Item;
            SalesLine."Line No." := 10001;
            SalesLine.Validate("No.", '1007');
            SalesLine.Quantity := CountErabliere;
            SalesLine.UpdateAmounts();
            SalesLine.Insert(true);

            // Update the Sales Invoice header with the total amount
            // SalesHeader.Validate("Amount", SalesLine.Amount);
            // SalesHeader.Modify(true);
        end;
    end;
}