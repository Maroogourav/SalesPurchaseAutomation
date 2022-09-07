// pageextension 51202 PO_ext2 extends "Purchase Order"
// {
//     layout
//     {

//         // addbefore("Vendor Invoice No.")
//         // {
//         //     field("Customer Order No."; Rec."Customer Order No.")
//         //     {
//         //         ApplicationArea = All;

//         //     }
//         // }
//         addlast("Shipping and Payment")
//         {
//             field("Package Tracking No."; Rec."Package Tracking No.")
//             {
//                 ApplicationArea = All;
//             }

//             field("Shipping Agent Service Code ext"; Rec."ShippingAgentServiceCodeExt")
//             {
//                 ApplicationArea = All;
//             }
//             field("Shipping Agent Code ext"; Rec."Shipping Agent Code ext")
//             {
//                 ApplicationArea = All;
//             }
//         }

//     }
//     actions
//     {

//         addbefore(CalculateInvoiceDiscount)
//         {
//             action(AddShippingDetails)
//             {
//                 Caption = 'Add Shipping Details';
//                 ApplicationArea = All;
//                 Image = NewDocument;
//                 trigger OnAction()
//                 var
//                     SalesOrder: Record "Sales Header";
//                     PurchaseOrder: Record "Purchase Header";
//                 begin
//                     SalesOrder.Reset();
//                     SalesOrder.SetRange("Document Type", Rec."Document Type");
//                     SalesOrder.SetFilter("External Document No.", Rec."Customer Order No.");
//                     if SalesOrder.FindSet(true, true) then
//                         repeat
//                             SalesOrder."Shipment Method Code" := Rec."Shipment Method Code";
//                             SalesOrder."Shipping Agent Code" := Rec."Shipping Agent Code ext";
//                             SalesOrder."Shipping Agent Service Code" := Rec."ShippingAgentServiceCodeExt";
//                             SalesOrder."Package Tracking No." := Rec."Package Tracking No.";
//                             SalesOrder.Modify(true);
//                         until SalesOrder.Next() = 0;
//                 end;
//             }
//         }
//     }
// }


