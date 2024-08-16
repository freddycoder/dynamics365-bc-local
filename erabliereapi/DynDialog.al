codeunit 50130 DynDialog
{
    procedure Open(n: Integer)
    var
        dialogTemplate: Text;
        i: Integer;
    begin
        for i := 1 to n do begin
            dialogTemplate += '#' + Format(i) + ' ';
        end;
        Dialog.Open(dialogTemplate);
    end;

    procedure Close()
    begin
        Dialog.Close();
    end;

    procedure Update(number: Integer; text: Text)
    begin
        Dialog.Update(number, text);
    end;

    var
        Dialog: Dialog;
}