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

            action(CreateInvoices)
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Create Invoices';

                trigger OnAction()
                var
                    createEAPIInvoice: Codeunit "CreateEAPIInvoice";
                begin
                    createEAPIInvoice.CreateSalesInvoices(True);
                end;
            }
        }
    }

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

            Dialog.UpdateDescription(i + 1, propVal + ' inséré');
        end
        else begin
            propVal := Json.GetText(ErabliereToken, 'nom');

            ErabliereRec.Validate(Description, propVal);

            ErabliereRec.Modify(true);

            Dialog.UpdateDescription(i + 1, propVal + ' existe déjà');
        end;
    end;

    var
        Dialog: Codeunit "DynDialog";
        Json: Codeunit "Json";
}