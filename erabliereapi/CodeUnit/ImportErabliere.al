codeunit 50104 ImportErabliere
{
    trigger OnRun()
    var
        ErabliereRec: Record "Erablieres";
    begin
        ImportErablieres(ErabliereRec);
    end;

    procedure ImportErablieres(var ErabliereRec: Record Erablieres)
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
        Dialog.PrettyMessage('Importation terminée');
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