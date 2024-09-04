codeunit 50130 DynDialog
{
    procedure Open(n: Integer)
    var
        dialogTemplate: Text;
        i: Integer;
    begin
        Description.RemoveRange(1, Description.Count);
        for i := 1 to n do begin
            dialogTemplate += '#' + Format(i) + ' ';
            Name.Add('');
            Error.Add('');
            Description.Add('');
        end;
        Dialog.Open(dialogTemplate);
        IsOpen := true;
    end;

    procedure Close()
    begin
        Dialog.Close();
        IsOpen := false;
    end;

    procedure UpdateName(number: Integer; text: Text)
    begin
        Name.Set(number, text);
        Dialog.Update(number, Name.Get(number) + ' ' + Error.Get(number) + ' ' + Description.Get(number));
    end;

    procedure UpdateError(number: Integer; text: Text)
    begin
        Error.Set(number, text);
        Dialog.Update(number, Name.Get(number) + ' ' + Error.Get(number) + ' ' + Description.Get(number));
    end;

    procedure UpdateDescription(number: Integer; text: Text)
    begin
        Description.Set(number, text);
        Dialog.Update(number, Name.Get(number) + ' ' + Error.Get(number) + ' ' + Description.Get(number));
    end;

    procedure UpdateAppend(number: Integer; text: Text)
    begin
        Description.Set(number, Description.Get(number) + text);
        Dialog.Update(number, Name.Get(number) + ' ' + Error.Get(number) + ' ' + Description.Get(number));
    end;

    /// <summary>
    /// Display the text from the dialog into a message box.
    /// The dialog will be closed if it was open.
    /// </summary>
    procedure PrettyMessage(text: Text)
    var
        i: Integer;
        template: Text;
    begin
        if IsOpen then
            Close();
        for i := 1 to Description.Count do
            template += Name.Get(i) + ' ' + Error.Get(i) + ' ' + Description.Get(i) + '\';
        Message(text + '\' + template);
    end;

    procedure PrettyConfirm(text: Text): Boolean
    var
        i: Integer;
        template: Text;
    begin
        if IsOpen then
            Close();
        for i := 1 to Description.Count do
            template += Name.Get(i) + ' ' + Error.Get(i) + ' ' + Description.Get(i) + '\';
        exit(Confirm(text + '\' + template));
    end;

    procedure DisplayAsPreviewPage()
    var
        i: Integer;
        template: Record "Preview" temporary;
    begin
        if IsOpen then
            Close();
        for i := 1 to Description.Count do begin
            template."No" := i;
            template.Name := Name.Get(i);
            template.Error := Error.Get(i);
            template.Description := Description.Get(i);
            template.Insert();
        end;

        template.SetCurrentKey(Error);
        template.SetAscending(Error, true);

        Page.Run(Page::PreviewPage, template);
    end;

    var
        Dialog: Dialog;
        Name: List of [Text];
        Error: List of [Text];
        Description: List of [Text];
        IsOpen: Boolean;
}