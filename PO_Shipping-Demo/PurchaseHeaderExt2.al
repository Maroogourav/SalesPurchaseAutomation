// tableextension 50100 "PurchaseHeader Ext2" extends "Purchase Header"
// {
//     fields
//     {

//         field(50100; "Package Tracking No."; Text[30])
//         {
//             Caption = 'Package Tracking No.';
//         }

//         field(50102; "ShippingAgentServiceCodeExt"; Code[10])

//         {
//             //AccessByPermission = TableData "Shipping Agent Services" = R;
//             Caption = 'Shipping Agent Service Code ext';

//             TableRelation = "Shipping Agent Services".CODE WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code ext"));

//             trigger OnValidate()
//             var
//                 IsHandled: Boolean;
//             begin
//                 IsHandled := false;
//                 //OnBeforeValidateShippingAgentServiceCode(Rec, IsHandled);
//                 if IsHandled then
//                     exit;

//                 TestStatusOpen;
//                 if xRec."ShippingAgentServiceCodeExt" = "ShippingAgentServiceCodeExt" then
//                     exit;

//                 // GetShippingTime(FieldNo("Shipping Agent Service Code"));
//                 // UpdateSalesLinesByFieldNo(FieldNo("Shipping Agent Service Code"), CurrFieldNo <> 0);
//             end;
//         }
//         // field(50103; "Customer Order No."; Code[35])
//         // {
//         //     Caption = 'Customer Order No.';
//         //     DataClassification = CustomerContent;
//         // }


//         field(50101; "Shipping Agent Code ext"; Code[10])
//         {
//             AccessByPermission = TableData "Shipping Agent Services" = R;
//             Caption = 'Shipping Agent Code ext';
//             TableRelation = "Shipping Agent";

//             trigger OnValidate()
//             var
//                 IsHandled: Boolean;
//             begin
//                 IsHandled := false;

//                 TestStatusOpen;
//                 if xRec."Shipping Agent Code ext" = "Shipping Agent Code ext" then
//                     exit;

//                 "ShippingAgentServiceCodeExt" := '';
//                 //GetShippingTime(FieldNo("Shipping Agent Code ext"));

//                 // OnValidateShippingAgentCodeOnBeforeUpdateLines(Rec, CurrFieldNo, HideValidationDialog);
//                 //UpdateSalesLinesByFieldNo(FieldNo("Shipping Agent Code ext"), CurrFieldNo <> 0);
//             end;
//         }

//     }

//     // [IntegrationEvent(false, false)]
//     // local procedure OnBeforeValidateShippingAgentCode(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; var xSalesHeader: Record "Sales Header"; CurrentFieldNo: Integer)
//     // begin
//     // end;

// }