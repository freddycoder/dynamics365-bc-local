tableextension 50104 "Job" extends Job
{
    fields
    {
        field(50100; DimensionErabliereAPI; Text[20])
        {
            Caption = 'Dimension ErabliereAPI';
            DataClassification = ToBeClassified;
        }
    }

    trigger OnAfterInsert()
    var
        defaultDimension: Record "Default Dimension";
        dimensionValue: Record "Dimension Value";
    begin
        if (Rec.DimensionErabliereAPI <> '') then begin
            dimensionValue.Init();
            dimensionValue.Validate("Dimension Code", 'ERABLIEREAPI');
            dimensionValue.Validate(dimensionValue.Code, Rec.DimensionErabliereAPI.ToUpper().Trim());
            dimensionValue.Validate(dimensionValue.Name, Rec.DimensionErabliereAPI);
            if (dimensionValue.Insert(true)) then;
            defaultDimension.Init();
            defaultDimension.Validate(defaultDimension."Table ID", 167);
            defaultDimension.Validate("No.", Rec."No.");
            defaultDimension.Validate(defaultDimension."Dimension Code", 'ERABLIEREAPI');
            defaultDimension.Validate("Dimension Value Code", dimensionValue.Code);
            if (defaultDimension.Insert(true)) then;
        end;
    end;

    trigger OnModify()
    var
        defaultDimension: Record "Default Dimension";
        dimensionValue: Record "Dimension Value";
    begin
        if (xRec.DimensionErabliereAPI = '') and (Rec.DimensionErabliereAPI <> '') then begin
            dimensionValue.Init();
            if (dimensionValue.Get(dimensionValue.Code, Rec.DimensionErabliereAPI.ToUpper().Trim())) then begin
                dimensionValue.Validate("Dimension Code", 'ERABLIEREAPI');
                dimensionValue.Validate(dimensionValue.Code, Rec."No.");
                dimensionValue.Validate(dimensionValue.Name, Rec.DimensionErabliereAPI.ToUpper().Trim());
                if (dimensionValue.Insert(true)) then;
            end;
            defaultDimension.Init();
            defaultDimension.Validate(defaultDimension."Table ID", 167);
            defaultDimension.Validate("No.", Rec."No.");
            defaultDimension.Validate(defaultDimension."Dimension Code", 'ERABLIEREAPI');
            defaultDimension.Validate("Dimension Value Code", dimensionValue.Code);
            if (defaultDimension.Insert(true)) then;
        end
        else if Rec.DimensionErabliereAPI <> xRec.DimensionErabliereAPI then begin
            dimensionValue.Init();
            dimensionValue.SetFilter("Dimension Code", 'ERABLIEREAPI');
            dimensionValue.SetFilter(dimensionValue.Code, Rec.DimensionErabliereAPI.ToUpper().Trim());
            if (dimensionValue.FindFirst) then;
            defaultDimension.Init();
            defaultDimension.SetRange(defaultDimension."Table ID", 18);
            defaultDimension.SetFilter("No.", Rec."No.");
            defaultDimension.SetFilter(defaultDimension."Dimension Code", 'ERABLIEREAPI');
            defaultDimension.SetFilter("Dimension Value Code", dimensionValue.Code);
            if (dimensionValue.FindFirst) then begin
                dimensionValue.Validate(dimensionValue.Name, Rec.DimensionErabliereAPI);
                dimensionValue.Modify();
            end;
        end;
    end;
}
