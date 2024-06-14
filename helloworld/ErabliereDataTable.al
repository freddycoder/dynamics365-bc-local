table 50100 ErabliereDataTable
{
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code';
        }

        field(2; Name; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Name';
        }

        field(3; Location; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Location';
        }

        field(4; Capacity; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Capacity';
        }

        field(5; SensorId; Code[40])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sensor Id';
        }

        field(6; SensorType; Code[40])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sensor Type';
        }

        field(7; SensorValue; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sensor Value';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}