pageextension 50104 "Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("CustomerInvoiceName"; Rec."CustomerInvoiceName")
            {
                Caption = 'Nom de facturation client';
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                QuickEntry = false;
                ToolTip = 'Nom de facturation client';
            }
            field("ErabliereAPICustomerId"; Rec."ErabliereAPICustomerId")
            {
                Caption = 'Identifiant de l''utilisateur érablière API';
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                QuickEntry = false;
                ToolTip = 'Identifiant utilisé dans les systèmes ÉrablièreAPI';
            }
        }
    }
}
