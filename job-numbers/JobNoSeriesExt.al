// This is an extension to edit the number sequence of a job
// The number is determined by checking the next number available in the no series

pageextension 50107 "Job-EditNumberSequence" extends "Job Card"
{
    // layout
    // {
    //     modify("No.")
    //     {
    //         Editable = false;
    //     }
    // }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    var
        NewNos: Code[20];
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if not BelowxRec then
            exit(true);

        // NoSeries.GET('JOB');

        // NoSeriesLine.Get(NoSeries.Code);

        // NewNos := IncStr(NoSeriesLine."Last No. Used");

        // Rec."No." := NewNos;

        EXIT(Rec.INSERT);
    end;
}
