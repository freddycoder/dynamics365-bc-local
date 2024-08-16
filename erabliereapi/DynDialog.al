codeunit 50130 DynDialog
{
    procedure Open(n: Integer)
    var
        dialogTemplate: Text;
        i: Integer;
    begin
        for i := 1 to n do begin
            dialogTemplate += '#' + Format(i) + ' ';
            Texts.Add('');
        end;
        Dialog.Open(dialogTemplate);
    end;

    procedure Close()
    begin
        Dialog.Close();
    end;

    procedure Update(number: Integer; text: Text)
    begin
        Texts.Set(number, text);
        Dialog.Update(number, text);
    end;

    procedure PrettyMessage(text: Text)
    var
        i: Integer;
        template: Text;
    begin
        for i := 1 to Texts.Count do
            template += Texts.Get(i) + '\';
        Message(text + '\' + template, Texts);
    end;

    var
        Dialog: Dialog;
        Texts: List of [Text];
}