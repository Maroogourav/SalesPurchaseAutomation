tableextension 51200 PurchHeaderExtDS extends "Purchase Header"
{
    fields
    {
        field(51200; "Customer Order No."; Code[35])
        {
            Caption = 'Customer Order No.';
            DataClassification = CustomerContent;
        }
        field(51201; "Package Tracking No."; Text[30])
        {
            Caption = 'Package Tracking No.';
        }

        field(51202; "ShippingAgentServiceCode"; Code[10])

        {
            //AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Service Code';

            TableRelation = "Shipping Agent Services".CODE WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                //OnBeforeValidateShippingAgentServiceCode(Rec, IsHandled);
                if IsHandled then
                    exit;

                TestStatusOpen;
                if xRec."ShippingAgentServiceCode" = "ShippingAgentServiceCode" then
                    exit;

                // GetShippingTime(FieldNo("Shipping Agent Service Code"));
                // UpdateSalesLinesByFieldNo(FieldNo("Shipping Agent Service Code"), CurrFieldNo <> 0);
            end;
        }
         field(51203; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code ext';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;

                TestStatusOpen;
                if xRec."Shipping Agent Code" = "Shipping Agent Code" then
                    exit;

                "ShippingAgentServiceCode" := '';
                //GetShippingTime(FieldNo("Shipping Agent Code ext"));

                // OnValidateShippingAgentCodeOnBeforeUpdateLines(Rec, CurrFieldNo, HideValidationDialog);
                //UpdateSalesLinesByFieldNo(FieldNo("Shipping Agent Code ext"), CurrFieldNo <> 0);
            end;
        }
    }
}
