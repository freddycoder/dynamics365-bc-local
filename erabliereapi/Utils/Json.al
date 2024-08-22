codeunit 50100 "Json"
{
    procedure GetText(var JsonToken: JsonToken; propKey: Text[250]): Text
    var
        jObj: JsonObject;
    begin
        jObj := JsonToken.AsObject();
        exit(GetText(jObj, propKey));
    end;

    procedure GetText(var JsonObject: JsonObject; propKey: Text[250]): Text
    var
        jTokenVal: JsonToken;
        jVal: JsonValue;
    begin
        JsonObject.Get(propKey, jTokenVal);
        jVal := jTokenVal.AsValue();
        if jVal.IsNull() then
            exit('');
        exit(jVal.AsText());
    end;

    procedure GetDate(var JsonToken: JsonToken; propKey: Text[250]): Date
    var
        jObj: JsonObject;
    begin
        jObj := JsonToken.AsObject();
        exit(GetDate(jObj, propKey));
    end;

    procedure GetDate(var JsonObject: JsonObject; propKey: Text[250]): Date
    var
        jTokenVal: JsonToken;
        jVal: JsonValue;
        utils: Codeunit Utils;
    begin
        JsonObject.Get(propKey, jTokenVal);
        jVal := jTokenVal.AsValue();

        if jVal.IsNull() then
            exit(0D);

        if StrLen(jVal.AsText()) > 10 then
            exit((Utils.ConvertStringToDate(jVal.AsText().Substring(1, 10))));

        exit(jVal.AsDate());
    end;
}