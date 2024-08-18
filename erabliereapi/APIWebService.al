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
    begin
        //Create webservice call
        RequestMessage.Method := 'POST';
        RequestMessage.SetRequestUri(ApiSetup.Audiance);

        //Create webservice header
        RequestMessage.GetHeaders(RequestHeader);

        //Payload needed? This might as well be a different implementation!
        //It's just an example where the credentials are stored as a json payload

        //Create json payload
        JObjectRequest.Add('client_id', ApiSetup."Client Id");
        JObjectRequest.Add('client_secret', ApiSetup."Client Secret");
        JObjectRequest.WriteTo(AuthPayload);

        //Get Request Content
        RequestContent.WriteFrom(AuthPayload);

        RequestContent.GetHeaders(RequestHeader);
        RequestHeader.Remove('Content-Type');
        RequestHeader.Add('Content-Type', 'application/json');

        RequestMessage.Content := RequestContent;

        //Send webservice query
        WebClient.Send(RequestMessage, ResponseMessage);

        if ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content().ReadAs(ResponseText);

            if not JObjectResult.ReadFrom(ResponseText) then
                Error('Error Read JSON');

            TokenResponseText := GetJsonToken(JObjectResult, 'access_token').AsValue().AsText();
            TokenExpiry := GetJsonToken(JObjectResult, 'expiry_date').AsValue().AsDateTime();

        end else
            Error('Webservice Error');

        exit(TokenResponseText);
    end;

    local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: Text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error(StrSubstNo('Token %1 not found', TokenKey));
    end;
}