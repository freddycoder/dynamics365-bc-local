codeunit 50140 ErabliereAPI
{
    procedure GetErabliere(): JsonArray
    var
        HttpClient: HttpClient;
        Response: HttpResponseMessage;
        ResponseText: Text;
        ErablieresObj: JsonArray;
    begin
        HttpClient.Get('https://erabliereapi.freddycoder.com/Erablieres', Response);
        if Response.IsSuccessStatusCode then begin
            Response.Content.ReadAs(ResponseText);

            if ErablieresObj.ReadFrom(ResponseText) then
                exit(ErablieresObj);
        end;

        Error('ErabliereAPI.GetErabliere::Error: %1', Response.ReasonPhrase);
    end;
}