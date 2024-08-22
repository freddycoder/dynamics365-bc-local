codeunit 50140 ErabliereAPI
{
    procedure GetErabliere(): JsonArray
    begin
        exit(GetList('/Erablieres'));
    end;

    procedure GetAdminErabliere(): JsonArray
    begin
        exit(GetList('/Admin/Erablieres'));
    end;

    procedure GetAdminContact(): JsonArray
    begin
        exit(GetList('/Admin/Customers'));
    end;

    local procedure GetList(url: Text): JsonArray
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

        Token := HttpAuthUtils.GetAuthenticationToken(APIConfig, true);

        HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + Token);

        HttpClient.Get(APIConfig."API URL" + url, Response);

        Response.Content.ReadAs(ResponseText);

        if Response.IsSuccessStatusCode then begin
            if ErablieresObj.ReadFrom(ResponseText) then
                exit(ErablieresObj);
        end;

        Error('ErabliereAPI.GetList(%1)::Error: %2\Message: %3', url, Response.ReasonPhrase);
    end;
}