page 50102 "Erabliere List"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Erablieres;
    CardPageId = "Erabliere Card";

    layout
    {
        area(content)
        {
            repeater(Erabliere)
            {
                field("Erabliere ID"; Rec."Erabliere ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifie the ID of the Erabliere.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field("Invoice Customer"; Rec."Invoice Customer")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    TableRelation = Customer;
                }

                field("Invoice Contact"; Rec."Invoice Contact")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    TableRelation = Contact;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetErablieres)
            {
                Promoted = true;
                ApplicationArea = All;
                Caption = 'Importer Érablieres';

                trigger OnAction()
                var
                    ErabliereAPI: CodeUnit "ErabliereAPI";
                    ErabliereRec: Record "Erablieres";
                begin
                    ImportErablieres(ErabliereRec);
                    Dialog.PrettyMessage('Importation terminée');
                end;
            }

            action(PreviewErablieres)
            {
                Promoted = true;
                ApplicationArea = All;
                Caption = 'Prévisualiser Érablieres';

                trigger OnAction()
                var
                    ErabliereRec: Record "Erablieres" temporary;
                    previewPage: Page "Erabliere List";
                begin
                    ImportErablieres(ErabliereRec);
                    if ErabliereRec.FindSet() then begin
                        Page.Run(Page::"Erabliere List", ErabliereRec);
                    end
                    else
                        Dialog.PrettyMessage('Nothing to import');
                end;
            }

            action(CreateInvoice)
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Create Invoice';

                trigger OnAction()
                var
                    result: Boolean;
                begin
                    result := CreateSalesInvoiceWorkflow(True);
                    if result then
                        result := Dialog.PrettyConfirm('Do you want to create the invoices?');

                    if result then
                        CreateSalesInvoiceWorkflow(False);
                end;
            }
        }
    }

    local procedure CreateSalesInvoiceWorkflow(Preview: Boolean): Boolean
    var
        ErablieresRec: Record "Erablieres";
        Count: Integer;
        i: Integer;
    begin
        i := 1;
        if ErablieresRec.FindSet() then begin
            Count := ErablieresRec.Count();
            Dialog.Open(Count);
            repeat begin
                if ErablieresRec."Invoice Customer" <> '' then begin
                    Dialog.Update(i, 'Creating invoice for ' + ErablieresRec.Description + ' for customer ' + ErablieresRec."Invoice Contact" + '.');
                    CreateSalesInvoice(ErablieresRec."Invoice Customer", Preview);
                end
                else
                    Dialog.Update(i, 'No customer for ' + ErablieresRec.Description + ', no invoice created.');
                Sleep(100);
                i += 1;
            end until ErablieresRec.Next() = 0;
            exit(true);
        end
        else
            Dialog.PrettyMessage('Without Erablieres, no invoice can be created');

        exit(false);
    end;

    local procedure ImportErablieres(var ErabliereRec: Record Erablieres)
    var
        ErablieresArray: JsonArray;
        ErabliereToken: JsonToken;
        ErabliereAPI: CodeUnit "ErabliereAPI";
        propVal: Text;
        i: Integer;
        count: Integer;
    begin
        ErablieresArray := ErabliereAPI.GetAdminErabliere();
        count := ErablieresArray.Count;
        Dialog.Open(count);
        for i := 0 to count - 1 do begin
            ErablieresArray.Get(i, ErabliereToken);

            GetOrCreateErabliere(ErabliereRec, ErabliereToken, i);
        end;
        Dialog.Close();
    end;

    local procedure GetOrCreateErabliere(var ErabliereRec: Record "Erablieres"; var ErabliereToken: JsonToken; var i: Integer)
    var
        propVal: Text;
    begin
        propVal := Json.GetText(ErabliereToken, 'id');

        // Si l'érable n'existe pas, on le crée
        if not ErabliereRec.Get(propVal) then begin
            ErabliereRec.Init();

            ErabliereRec.Validate("Erabliere ID", propVal);

            propVal := Json.GetText(ErabliereToken, 'nom');

            ErabliereRec.Validate("Description", propVal);

            ErabliereRec.Insert(true);

            Dialog.Update(i + 1, propVal + ' inséré');
        end
        else begin
            propVal := Json.GetText(ErabliereToken, 'nom');

            ErabliereRec.Validate(Description, propVal);

            ErabliereRec.Modify(true);

            Dialog.Update(i + 1, propVal + ' existe déjà');
        end;
    end;

    procedure CreateSalesInvoice(CustomerNo: Code[20]; Preview: Boolean)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        InvoiceNo: Code[20];
    begin
        // Initialize a new Sales Invoice header
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."No." := ''; // No. will be assigned by NoSeriesManagement
        SalesHeader."Sell-to Customer No." := CustomerNo;
        if not Preview then begin
            SalesHeader.Insert(true);

            // Get the next invoice number from the number series
            InvoiceNo := NoSeriesMgt.GetNextNo(SalesHeader."No. Series", SalesHeader."Posting Date", true);
            SalesHeader."No." := InvoiceNo;
            SalesHeader.Modify(true);

            // Initialize a new Sales Invoice line
            SalesLine.Init();
            SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
            SalesLine."Document No." := SalesHeader."No.";
            SalesLine."Line No." := 10000; // Line number
            SalesLine.Type := SalesLine.Type::Item;
            SalesLine.Insert(true);
        end;
    end;

    var
        Dialog: Codeunit "DynDialog";
        Json: Codeunit "Json";
}