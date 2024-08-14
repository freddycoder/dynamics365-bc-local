codeunit 50122 UtilsTest
{
    Subtype = Test;

    [Test]
    [TransactionModel(TransactionModel::None)]
    procedure ParseISODurationTest();
    var
        Duration: Text;
        ExpectedDuration: Duration;
    begin
        Duration := 'PT1H30M';
        ExpectedDuration := 5400000;
        Assert.AreEqual(ExpectedDuration, Utils.ParseISODuration(Duration), 'La duré devrait être de 1h30m');

        Duration := 'PT1H';
        ExpectedDuration := 3600000;
        Assert.AreEqual(ExpectedDuration, Utils.ParseISODuration(Duration), 'La duré devrait être de 1h');

        Duration := 'PT30M';
        ExpectedDuration := 1800000;
        Assert.AreEqual(ExpectedDuration, Utils.ParseISODuration(Duration), 'La duré devrait être de 30m');
    end;

    [Test]
    [TransactionModel(TransactionModel::None)]
    procedure HourToIntTest();
    var
        Hour: Text;
        ExpectedDuration: Duration;
    begin
        Hour := '1';
        ExpectedDuration := 3600000;
        Assert.AreEqual(ExpectedDuration, Utils.HourToInt(Hour), 'La duré devrait être de 1h');

        Hour := '12';
        ExpectedDuration := 3600000 * 12;
        Assert.AreEqual(ExpectedDuration, Utils.HourToInt(Hour), 'La duré devrait être de 12h');
    end;

    [Test]
    [TransactionModel(TransactionModel::None)]
    procedure MinuteToIntTest();
    var
        Minute: Text;
        ExpectedDuration: Duration;
    begin
        Minute := '1';
        ExpectedDuration := 60000;
        Assert.AreEqual(ExpectedDuration, Utils.MinuteToInt(Minute), 'La duré devrait être de 1m');

        Minute := '12';
        ExpectedDuration := 60000 * 12;
        Assert.AreEqual(ExpectedDuration, Utils.MinuteToInt(Minute), 'La duré devrait être de 12m');
    end;

    var
        Utils: Codeunit "Utils";
        Assert: Codeunit "Library Assert";
}