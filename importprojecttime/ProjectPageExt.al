pageextension 50100 ProjectExt extends "Job Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(processing)
        {
            action(UpdateProject)
            {
                ApplicationArea = All;
                Caption = 'Update Project';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Dialog: Dialog;
                    importTime: Codeunit "ImportTimeCodeunit";
                begin
                    Dialog.Open('Project updating...');

                    importTime.ImportTime(Rec."No.");

                    Dialog.Close();

                    Message('Project updated successfully.');
                end;
            }
        }
    }
}