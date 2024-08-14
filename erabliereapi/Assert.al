codeunit 50129 Assert
{
    procedure AreEqual(actual: Text[100]; expected: Text[100])
    begin
        if actual <> expected then
            error('Assertion failed: Actual value "' + actual + '" is not equal to expected value "' + expected + '".');
    end;

    procedure AreNotEqual(actual: Text[100]; expected: Text[100])
    begin
        if actual = expected then
            error('Assertion failed: Actual value "' + actual + '" is equal to expected value "' + expected + '".');
    end;

    procedure AreEqual(actual: Duration; expected: Duration)
    begin
        if actual <> expected then
            error('Assertion failed: Actual value "' + Format(actual) + '" is not equal to expected value "' + Format(expected) + '".');
    end;
}