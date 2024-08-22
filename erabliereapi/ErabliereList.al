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
                    ErablieresArray: JsonArray;
                    ErabliereToken: JsonToken;
                    ErabliereAPI: CodeUnit "ErabliereAPI";
                    ErabliereRec: Record "Erablieres";
                    propVal: Text;
                    i: Integer;
                    count: Integer;
                begin
                    ErablieresArray := ErabliereAPI.GetAdminErabliere();
                    count := ErablieresArray.Count;
                    Dialog.Open(count);
                    for i := 0 to ErablieresArray.Count - 1 do begin

                        ErablieresArray.Get(i, ErabliereToken);

                        propVal := Json.GetText(ErabliereToken, 'id');

                        // Si l'érable n'existe pas, on le crée
                        if not ErabliereRec.Get(propVal) then begin
                            ErabliereRec.Init();

                            ErabliereRec.Validate("Erabliere ID", propVal);

                            propVal := Json.GetText(ErabliereToken, 'nom');

                            ErabliereRec.Validate("Description", propVal);

                            ErabliereRec.Insert();

                            Dialog.Update(i + 1, propVal + ' inséré');
                        end
                        else begin
                            propVal := Json.GetText(ErabliereToken, 'nom');

                            Dialog.Update(i + 1, propVal + ' existe déjà');
                        end;
                    end;
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
                    ErablieresArray: JsonArray;
                    ErabliereToken: JsonToken;
                    ErabliereAPI: CodeUnit "ErabliereAPI";
                    ErabliereRec: Record "Erablieres";
                    propVal: Text;
                    i: Integer;
                    count: Integer;
                begin
                    ErablieresArray := ErabliereAPI.GetAdminErabliere();
                    count := ErablieresArray.Count;
                    Dialog.Open(count);
                    for i := 0 to count - 1 do begin
                        Sleep(125);
                        ErablieresArray.Get(i, ErabliereToken);
                        propVal := Json.GetText(ErabliereToken, 'nom');
                        Dialog.Update(i + 1, propVal);
                    end;
                    Sleep(625);
                    Dialog.PrettyMessage('Prévisualisation terminée');
                end;
            }
        }
    }

    var
        Dialog: Codeunit "DynDialog";
        Json: Codeunit "Json";
}