tableextension 50103 "Customer" extends Customer
{
    fields
    {
        field(50100; "CustomerInvoiceName"; Text[200])
        {
            Caption = 'Nom de facturation client';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }

        field(50101; "ErabliereAPICustomerId"; Text[200])
        {
            Caption = 'Identifiant utilisateur ÉrablièreAPI';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
    }

    trigger OnAfterInsert()
    var
        defaultDimension: Record "Default Dimension";
        dimensionValue: Record "Dimension Value";
    begin
        if (Rec.Name <> '') then begin
            dimensionValue.Init();

            dimensionValue.Validate("Dimension Code", 'CLIENT');
            dimensionValue.Validate(dimensionValue.Code, Rec."No.");
            dimensionValue.Validate(dimensionValue.Name, Rec.Name);
            dimensionValue.Validate(dimensionValue."Global Dimension No.", 1);
            if (dimensionValue.Insert(true)) then;
            defaultDimension.Init();
            defaultDimension.Validate(defaultDimension."Table ID", 18);
            defaultDimension.Validate("No.", Rec."No.");
            defaultDimension.Validate(defaultDimension."Dimension Code", 'CLIENT');
            defaultDimension.Validate("Dimension Value Code", dimensionValue.Code);
            if (defaultDimension.Insert(true)) then;
        end;
    end;

    trigger OnDelete()
    var
        defaultDimension: Record "Default Dimension";
        dimensionValue: Record "Dimension Value";
    begin
        dimensionValue.Init();

        dimensionValue.SetFilter("Dimension Code", 'CLIENT');
        dimensionValue.SetFilter(dimensionValue.Code, Rec."No.");
        if (dimensionValue.FindFirst) then;

        defaultDimension.Init();
        defaultDimension.SetRange(defaultDimension."Table ID", 18);
        defaultDimension.SetFilter("No.", Rec."No.");
        defaultDimension.SetFilter(defaultDimension."Dimension Code", 'CLIENT');
        defaultDimension.SetFilter("Dimension Value Code", dimensionValue.Code);
        if (defaultDimension.FindFirst) then
            defaultDimension.Delete();
        if (dimensionValue.FindFirst) then
            dimensionValue.Delete();
    end;

    trigger OnModify()
    var
        FieldNo: Integer;
        defaultDimension: Record "Default Dimension";
        dimensionValue: Record "Dimension Value";
    begin
        if (xRec.Name = '') and (Rec.Name <> '') then begin
            dimensionValue.Init();

            dimensionValue.Validate("Dimension Code", 'CLIENT');
            dimensionValue.Validate(dimensionValue.Code, Rec."No.");
            dimensionValue.Validate(dimensionValue.Name, Rec.Name);
            dimensionValue.Validate(dimensionValue."Global Dimension No.", 1);
            if (dimensionValue.Insert(true)) then;
            defaultDimension.Init();
            defaultDimension.Validate(defaultDimension."Table ID", 18);
            defaultDimension.Validate("No.", Rec."No.");
            defaultDimension.Validate(defaultDimension."Dimension Code", 'CLIENT');
            defaultDimension.Validate("Dimension Value Code", dimensionValue.Code);
            if (defaultDimension.Insert(true)) then;
        end
        else if Rec.Name <> xRec.Name then begin
            dimensionValue.Init();

            dimensionValue.SetFilter("Dimension Code", 'CLIENT');
            dimensionValue.SetFilter(dimensionValue.Code, Rec."No.");
            if (dimensionValue.FindFirst) then;

            defaultDimension.Init();
            defaultDimension.SetRange(defaultDimension."Table ID", 18);
            defaultDimension.SetFilter("No.", Rec."No.");
            defaultDimension.SetFilter(defaultDimension."Dimension Code", 'CLIENT');
            defaultDimension.SetFilter("Dimension Value Code", dimensionValue.Code);
            if (dimensionValue.FindFirst) then begin
                dimensionValue.Validate(dimensionValue.Name, Rec.Name);
                dimensionValue.Modify();
            end;
        end;
    end;
}
