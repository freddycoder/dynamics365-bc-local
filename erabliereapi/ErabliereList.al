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
                    ImportErablieres: Codeunit "ImportErabliere";
                begin
                    ImportErablieres.ImportErablieres(ErabliereRec);
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
                    ImportErablieres: Codeunit "ImportErabliere";
                begin
                    ImportErablieres.ImportErablieres(ErabliereRec);
                    if ErabliereRec.FindSet() then begin
                        Page.Run(Page::"Erabliere List", ErabliereRec);
                    end
                    else
                        Dialog.Message('Nothing to import');
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
}