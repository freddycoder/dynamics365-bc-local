codeunit 50120 Utils
{
    procedure ConvertStringToDate(DateString: Text): Date
    var
        DateValue: Date;
    begin
        if Evaluate(DateValue, DateString, 0) then
            exit(DateValue)
        else
            Error('Invalid date format: %1', DateString);
    end;

    procedure ParseISODuration(Duration: Text): Duration
    var
        DurationUnitValue: Integer;
        DurationParts: List of [Text];
        i: Integer;
        length: Integer;
        type: Text;
        cursor: Integer;
    begin
        i := 1;
        cursor := 1;
        DurationUnitValue := 0;
        Duration := Duration.Replace('PT', '');

        // Check the length of the first digit
        while (i < StrLen(Duration)) do begin
            length := 0;

            while (i < StrLen(Duration)) and (Duration[i] in ['0' .. '9']) do begin
                length += 1;
                i += 1;
            end;

            if i > StrLen(Duration) then
                break;

            Type := Duration[i];
            i += 1;

            if Type = 'H' then
                DurationUnitValue += HourToInt(Duration.Substring(cursor, length))
            else if Type = 'M' then
                DurationUnitValue += MinuteToInt(Duration.Substring(cursor, length))
            else
                Error('Invalid duration type');

            cursor := i;
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

    procedure GetUnixTimestamp(): Integer
    var
        CurrentDateTime: DateTime;
        UnixEpoch: DateTime;
        TimeSpan: Duration;
        TimeZone: Codeunit "Time Zone";
        Offset: Duration;
        EpochOffset: Duration;
    begin
        // Get the current DateTime
        CurrentDateTime := CurrentDateTime();

        Offset := TimeZone.GetTimezoneOffset(CurrentDateTime);

        // Define the Unix epoch (January 1, 1970)
        UnixEpoch := CreateDateTime(19700101D, 000000T);

        EpochOffset := TimeZone.GetTimezoneOffset(UnixEpoch);

        // Calculate the difference between the current DateTime and the Unix epoch
        TimeSpan := CurrentDateTime - UnixEpoch - EpochOffset;

        // Convert the difference to seconds and return as an integer
        exit(Round(TimeSpan / 1000, 1));
    end;
}