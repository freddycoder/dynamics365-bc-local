pageextension 50120 ContactPageExt extends "Contact List"
{
    layout
    {

    }

    actions
    {
        // Import contact from ErabliereAPI
        addafter("Export Contact")
        {
            action("Import from ErabliereAPI")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Import Contacts';
                ToolTip = 'Import contacts from ErabliereAPI';
                Image = Import;

                trigger OnAction()
                var
                    result: Boolean;
                begin
                    result := ImportContactsFromErabliereAPI(True);

                    if result then begin
                        result := ImportContactsFromErabliereAPI(False);
                    end;
                end;
            }
        }
    }

    procedure ImportContactsFromErabliereAPI(Preview: Boolean): Boolean
    var
        ErabliereAPI: CodeUnit "ErabliereAPI";
        ContactRec: Record "Contact";
        ContactsArray: JsonArray;
        ContactToken: JsonToken;
        uniqueName: Text;
        i: Integer;
        count: Integer;
        modified: Boolean;
    begin
        ContactsArray := ErabliereAPI.GetAdminContact();
        count := ContactsArray.Count;
        Dialog.Open(count);
        for i := 0 to count - 1 do begin
            ContactsArray.Get(i, ContactToken);
            uniqueName := Json.GetText(ContactToken, 'uniqueName');
            modified := false;

            if uniqueName.Contains('@') then begin
                ContactRec.SetFilter("ErabliereAPI Unique Name", uniqueName);

                if ContactRec.FindFirst() then begin
                    SynErabliereAPIContact(ContactRec, ContactToken);
                    if not Preview then
                        ContactRec.Modify(true);
                    Dialog.UpdateDescription(i + 1, StrSubstNo('Contact %1 %2 was updated', ContactRec."No.", uniqueName));
                    modified := true;
                end;

                ContactRec.SetFilter("ErabliereAPI Unique Name", '');
                ContactRec.SetFilter("E-Mail", Json.GetText(ContactToken, 'email'));

                if ContactRec.FindFirst() then begin
                    SynErabliereAPIContact(ContactRec, ContactToken);
                    if not Preview then
                        ContactRec.Modify(true);
                    Dialog.UpdateDescription(i + 1, StrSubstNo('Contact %1 %2 updated from an existing customer', ContactRec."No.", uniqueName));
                    modified := true;
                end;

                if not modified then begin
                    ContactRec.Init();
                    ContactRec.Type := ContactRec.Type::Person;
                    SynErabliereAPIContact(ContactRec, ContactToken);
                    ContactRec.CheckDuplicates();
                    if not Preview then begin
                        ContactRec."No." := ContactRec.CreateCustomer();
                        ContactRec.Insert(true);
                    end;

                    Dialog.UpdateDescription(i + 1, StrSubstNo('Contact %1 created', ContactRec."No." + ' ' + uniqueName));
                end;
            end
            else begin
                Dialog.UpdateDescription(i + 1, StrSubstNo('Device %1 was not imported as a contact', uniqueName));
            end;
        end;
        if Preview then
            exit(Dialog.PrettyConfirm('Do you confirm the import data?'))
        else
            Dialog.PrettyMessage('Importation terminée');

        exit(true);
    end;

    procedure SynErabliereAPIContact(var ContactRec: Record "Contact"; var ContactToken: JsonToken)
    begin
        ContactRec.Validate(Name, Json.GetText(ContactToken, 'name'));
        ContactRec.Validate("ErabliereAPI Unique Name", Json.GetText(ContactToken, 'uniqueName'));
        ContactRec.Validate("E-Mail", Json.GetText(ContactToken, 'email'));
        ContactRec.Validate("E-Mail 2", Json.GetText(ContactToken, 'secondaryEmail'));
        ContactRec.Validate("ErabliereAPI Account Type", Json.GetText(ContactToken, 'accountType'));
        ContactRec.Validate("ErabliereAPI Stripe ID", Json.GetText(ContactToken, 'stripeId'));
        ContactRec.Validate("ErabliereAPI Ext. Account Url", Json.GetText(ContactToken, 'externalAccountUrl'));
        ContactRec.Validate("ErabliereAPI Creation Time", Json.GetDate(ContactToken, 'creationTime'));
        ContactRec.Validate("ErabliereAPI Last Update Time", Json.GetDate(ContactToken, 'lastAccessTime'));
    end;

    var
        Dialog: Codeunit "DynDialog";
        Json: Codeunit "Json";
}