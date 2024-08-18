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
        IsOpen := true;
    end;

    procedure Close()
    begin
        Dialog.Close();
        IsOpen := false;
    end;

    procedure Update(number: Integer; text: Text)
    begin
        Texts.Set(number, text);
        Dialog.Update(number, text);
    end;

    procedure UpdateAppend(number: Integer; text: Text)
    begin
        Texts.Set(number, Texts.Get(number) + text);
        Dialog.Update(number, Texts.Get(number));
    end;

    procedure PrettyMessage(text: Text)
    var
        i: Integer;
        template: Text;
    begin
        if IsOpen then
            Close();
        for i := 1 to Texts.Count do
            template += Texts.Get(i) + '\';
        Message(text + '\' + template, Texts);
    end;

    var
        Dialog: Dialog;
        Texts: List of [Text];
        IsOpen: Boolean;
}