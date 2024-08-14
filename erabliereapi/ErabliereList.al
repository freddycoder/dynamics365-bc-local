page 50102 "Erabliere List"
{
    // Specify that this page will be a list page.
    PageType = List;

    // The page will be part of the "Lists" group of search results.
    UsageCategory = Lists;

    // The data of this page is taken from the "Reward" table.
    SourceTable = Erablieres;

    // The "CardPageId" is set to the Reward Card previously created.
    // This will allow users to open records from the list in the "Reward Card" page.
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
                    ErabliereObj: JsonObject;
                    ErabliereAPI: CodeUnit "ErabliereAPI";
                    ErabliereRec: Record "Erablieres";
                    propVal: JsonToken;
                    i: Integer;
                begin
                    ErablieresArray := ErabliereAPI.GetErabliere();
                    for i := 0 to ErablieresArray.Count - 1 do begin

                        ErablieresArray.Get(i, ErabliereToken);
                        ErabliereObj := ErabliereToken.AsObject();

                        ErabliereRec.Init();

                        ErabliereObj.Get('id', propVal);
                        ErabliereRec.Validate("Erabliere ID", propVal.AsValue().AsText());

                        ErabliereObj.Get('nom', propVal);
                        ErabliereRec.Validate("Description", propVal.AsValue().AsText());

                        ErabliereRec.Insert();
                    end;
                end;
            }
        }
    }
}