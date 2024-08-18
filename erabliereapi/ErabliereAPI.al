codeunit 50140 ErabliereAPI
{
    procedure GetErabliere(): JsonArray
    var
        HttpClient: HttpClient;
        Response: HttpResponseMessage;
        ResponseText: Text;
        ErablieresObj: JsonArray;
        Token: Text;
        HttpAuthUtils: Codeunit "API Web Service";
        APIConfig: Record "EAPI Setup";
    begin
        APIConfig.FindSet();

        Token := HttpAuthUtils.GetAuthenticationToken(APIConfig, false);

        HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + Token);

        HttpClient.Get(APIConfig."API URL" + '/Erablieres', Response);
        if Response.IsSuccessStatusCode then begin
            Response.Content.ReadAs(ResponseText);

            if ErablieresObj.ReadFrom(ResponseText) then
                exit(ErablieresObj);
        end;

        Error('ErabliereAPI.GetErabliere::Error: %1', Response.ReasonPhrase);
    end;
}