pageextension 50108 "Job Card" extends "Job Card"
{
    layout
    {
        addlast(General)
        {
            field("CustomerInvoiceName"; Rec."DimensionErabliereAPI")
            {
                Caption = 'Nom de dimension ErabliereAPI';
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                QuickEntry = false;
                ToolTip = 'Nom de dimension ErabliereAPI';
            }
        }
    }
}
