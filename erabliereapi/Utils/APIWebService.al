codeunit 50126 "API Web Service"
{
    //Get a valid authentication token from setup. If token-age < expiry, get from blob, otherwise call API
    procedure GetAuthenticationToken(ApiSetup: Record "EAPI Setup"; ForceRenewal: Boolean): Text
    var
        TokenResponseText: Text;
        TokenExpiry: DateTime;
        TokenOutStream: OutStream;
        TokenInStream: InStream;
        AuthPayload: Text;
    begin
        if (ApiSetup."Token valid until" <= CurrentDateTime()) or ForceRenewal then begin
            //Get fresh Token 
            TokenResponseText := GetFreshAuthenticationToken(ApiSetup, TokenExpiry);

            //Write Token to Blob
            ApiSetup."API Token".CreateOutStream(TokenOutStream);
            TokenOutStream.WriteText(TokenResponseText);

            //Calculate the expriation date of the token. 
            //Should be defined by the API or even delivered in the response
            if TokenExpiry <> 0DT then
                ApiSetup."Token valid until" := TokenExpiry;
            ApiSetup.Modify();
        end else begin
            ApiSetup.CalcFields("API Token");

            //Read Token from Blob
            ApiSetup."API Token".CreateInStream(TokenInStream);
            TokenInStream.ReadText(TokenResponseText);
        end;

        //Return the token
        exit(TokenResponseText);
    end;

    procedure GetFreshAuthenticationToken(ApiSetup: Record "EAPI Setup"; var TokenExpiry: DateTime): Text
    var
        AuthPayload: Text;
        ResponseText: Text;
        TokenResponseText: Text;
        JObjectResult: JsonObject;
        JObjectRequest: JsonObject;
        WebClient: HttpClient;
        RequestHeader: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        TokenOutStream: OutStream;
        ClientAssertion: Text;
        HttpAuthUtils: Codeunit "HttpAuthUtils";
    begin
        //Create webservice call
        RequestMessage.Method := 'POST';

        if ApiSetup.Audiance = '' then
            Error('Please set the audiance parameter in the EAPI Setup Page. Ex: https://login.microsoftonline.com/<tenant_id>/oauth2/v2.0/token');

        RequestMessage.SetRequestUri(ApiSetup.Audiance);

        //Create webservice header
        RequestMessage.GetHeaders(RequestHeader);

        if ApiSetup."Client Id" = '' then
            Error('Please set the Client Id parameter in the EAPI Setup Page');

        if (ApiSetup."Client Secret" = '') and (ApiSetup.GetCertificateBase64() = '') then
            Error('Please set the Client Secret or Client Certificate parameter in the EAPI Setup Page');

        if (ApiSetup.Scope = '') then
            Error('Please set the Scope parameter in the EAPI Setup Page');

        if ApiSetup."Authentication Method" = ApiSetup."Authentication Method"::"Client Secret" then begin
            AuthPayload := 'grant_type=client_credentials&client_id=' + ApiSetup."Client Id" + '&client_secret=' + ApiSetup."Client Secret" + '&scope=' + ApiSetup."Scope";
        end
        else begin
            ClientAssertion := HttpAuthUtils.ComputeClientAssertion(ApiSetup);

            AuthPayload := 'grant_type=client_credentials&client_id=' + ApiSetup."Client Id" + '&Scope=' + ApiSetup.Scope + '&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer&client_assertion=' + ClientAssertion
        end;

        RequestContent.WriteFrom(AuthPayload);

        RequestContent.GetHeaders(RequestHeader);
        RequestHeader.Add('charset', 'UTF-8');
        RequestHeader.Remove('Content-Type');
        RequestHeader.Add('Content-Type', 'application/x-www-form-urlencoded');

        RequestMessage.Content := RequestContent;

        WebClient.Timeout := 20000;

        //Send webservice query
        WebClient.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content().ReadAs(ResponseText);

        if ResponseMessage.IsSuccessStatusCode() then begin
            if not JObjectResult.ReadFrom(ResponseText) then
                Error('API Web Service Error. Error Read JSON');

            TokenResponseText := GetJsonToken(JObjectResult, 'access_token').AsValue().AsText();
            TokenExpiry := CurrentDateTime() + GetJsonToken(JObjectResult, 'ext_expires_in').AsValue().AsInteger() * 1000;

        end else
            Error('API Web Service Error. Reason: %1 Message: %2', ResponseMessage.ReasonPhrase, ResponseText);

        exit(TokenResponseText);
    end;

    local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: Text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error(StrSubstNo('API Web Service Error. Token %1 not found', TokenKey));
    end;
}