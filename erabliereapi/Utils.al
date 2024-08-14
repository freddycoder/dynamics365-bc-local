codeunit 50120 Utils
{
    procedure ParseISODuration(Duration: Text): Duration
    var
        DurationUnitValue: Integer;
        DurationParts: List of [Text];
        i: Integer;
        length: Integer;
        type: Text;
        cursor: Integer;
    begin
        i := 0;
        cursor := 0;
        DurationUnitValue := 0;
        Duration := Duration.Replace('PT', '');

        // Check the length of the first digit
        while (i < StrLen(Duration)) do begin
            length := 0;

            while (i < StrLen(Duration)) and (Duration[i] in ['0' .. '9']) do begin
                length += 1;
                i += 1;
            end;

            i += 1;

            if i >= StrLen(Duration) then
                break;

            Type := Duration[i];

            if Type = 'H' then
                DurationUnitValue += HourToInt(Duration.Substring(cursor, length))
            else if Type = 'M' then
                DurationUnitValue += MinuteToInt(Duration.Substring(cursor, length))
            else
                Error('Invalid duration type');
        end;

        exit(DurationUnitValue);
    end;

    procedure HourToInt(Hour: Text): Duration
    var
        HourInt: Integer;
    begin
        if Evaluate(HourInt, Hour) then
            exit(HourInt * 1000 * 60 * 60);

        exit(0);
    end;

    procedure MinuteToInt(Minute: Text): Duration
    var
        MinuteInt: Integer;
    begin
        if Evaluate(MinuteInt, Minute) then
            exit(MinuteInt * 1000 * 60);

        exit(0);
    end;
}