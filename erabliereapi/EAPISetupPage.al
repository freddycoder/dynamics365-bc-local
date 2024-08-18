page 50132 "EAPI Setup Page"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "EAPI Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'The code of the EAPI setup.';
                    ShowMandatory = true;
                }
                field("API URL"; Rec."API URL")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if Rec."API URL".EndsWith('/') then
                            Rec."API URL" := Rec."API URL".Substring(0, StrLen(Rec."API URL") - 1);
                    end;
                }
                field("Client Id"; Rec."Client Id")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Audiance"; Rec."Audiance")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Scope"; Rec."Scope")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    ApplicationArea = All;
                }
                field("Client Certificate"; Rec."Client Certificate")
                {
                    ApplicationArea = All;
                }
                field("Client Certificate Password"; Rec."Client Certificate Password")
                {
                    ApplicationArea = All;
                }
                field("Authentication Method"; Rec."Authentication Method")
                {
                    ApplicationArea = All;
                }
                field("API Token"; Rec."API Token")
                {
                    ApplicationArea = All;
                }
                field("Token valid until"; Rec."Token valid until")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}