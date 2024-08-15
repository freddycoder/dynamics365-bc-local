codeunit 50101 ImportTimeCodeUnit
{
    procedure ImportTime(ProjectNo: Text[20])
    var
        tasks: Record "Job Task";
        planningLine: Record "Job Planning Line";
        jobTransferLine: Codeunit "Job Transfer Line";
        jobJnlLine: Record "Job Journal Line";
    begin
        tasks.SetFilter("Job No.", ProjectNo);

        if (tasks.FindSet()) then begin
            repeat
                planningLine.SetFilter("Job No.", tasks."Job No.");
                planningLine.SetFilter("Job Task No.", tasks."Job Task No.");
                if (planningLine.FindSet()) then begin
                    repeat
                        jobTransferLine.FromPlanningLineToJnlLine(
                            planningLine, WorkDate(), 'JOB', 'DEFAULT', jobJnlLine
                        );
                    until planningLine.Next() = 0;
                end;
            until tasks.Next() = 0;
        end;
    end;

}