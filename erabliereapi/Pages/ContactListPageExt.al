pageextension 50120 ContactPageExt extends "Contact List"
{
    layout
    {

    }

    actions
    {
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
                    importContact: Codeunit "ImportContactFromEAPI";
                begin
                    result := importContact.ImportContactsFromErabliereAPI(True);

                    if result then begin
                        result := importContact.ImportContactsFromErabliereAPI(False);
                    end;
                end;
            }
        }
    }
}