codeunit 50121 UtilsTestCodeUnit
{
    Subtype = Test;

    [Test]
    procedure ParseISODurationTest();
    var
        Utils: Codeunit "Utils";
        Duration: Text;
        ExpectedDuration: Duration;
    begin
        Duration := 'PT1H30M';
        ExpectedDuration := 5400000;
        Assert.AreEqual(ExpectedDuration, Utils.ParseISODuration(Duration));

        Duration := 'PT1H';
        ExpectedDuration := 3600000;
        Assert.AreEqual(ExpectedDuration, Utils.ParseISODuration(Duration));

        Duration := 'PT30M';
        ExpectedDuration := 1800000;
        Assert.AreEqual(ExpectedDuration, Utils.ParseISODuration(Duration));
    end;

    [Test]
    procedure HourToIntTest();
    var
        Utils: Codeunit "Utils";
        Hour: Text;
        ExpectedDuration: Duration;
    begin
        Hour := '1';
        ExpectedDuration := 3600000;
        Assert.AreEqual(ExpectedDuration, Utils.HourToInt(Hour));

        Hour := '2';
        ExpectedDuration := 7200000;
        Assert.AreEqual(ExpectedDuration, Utils.HourToInt(Hour));
    end;

    [Test]
    procedure MinuteToIntTest();
    var
        Utils: Codeunit "Utils";
        Minute: Text;
        ExpectedDuration: Duration;
    begin
        Minute := '1';
        ExpectedDuration := 60000;
        Assert.AreEqual(ExpectedDuration, Utils.MinuteToInt(Minute));

        Minute := '2';
        ExpectedDuration := 120000;
        Assert.AreEqual(ExpectedDuration, Utils.MinuteToInt(Minute));
    end;

    var
        Assert: Codeunit "Assert";
}