pageextension 51200 SalesOrderEXtDS extends "Sales Order"
{
    layout
    {
        modify("External Document No.")
        {
            Caption = 'Customer Order No.';
        }
    }
    actions
    {
        addafter(CreatePurchaseOrder)
        {
            action(CreateJNDPurchaseOrder)
            {
                Caption = 'Create Jahnda Purchase Order';
                ApplicationArea = All;
                Image = NewDocument;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseHeader2: Record "Purchase Header";
                    PurchaseLine: Record "Purchase Line";
                    SalesLine: Record "Sales Line";
                    Item: Record Item;
                    Vendor: Record Vendor;
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    PurchSetup: Record "Purchases & Payables Setup";
                    DropShip: Codeunit "Purch.-Get Drop Shpt.";
                    Counter: Integer;
                begin
                    if Rec.Status <> Rec.Status::Released then Error('Status must be released');
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    SalesLine.SetRange("Document No.", Rec."No.");
                    Counter := 0;
                    if SalesLine.FindSet() then
                        repeat
                            if SalesLine.Type = SalesLine.Type::Item then begin
                                if Item.Get(SalesLine."No.") then begin
                                    if (Item."Vendor No." <> '') and (Vendor.Get(Item."Vendor No.")) then begin
                                        PurchaseHeader2.Reset();
                                        PurchaseHeader2.SetRange("Customer Order No.", Rec."External Document No.");
                                        PurchaseHeader2.SetRange("Buy-from Vendor No.", Vendor."No.");
                                        if PurchaseHeader2.IsEmpty then begin
                                            //Create Purchase Order
                                            PurchaseHeader.Init();
                                            if PurchSetup.Get() then begin
                                                PurchaseHeader."No." := NoSeriesMgt.DoGetNextNo(PurchSetup."Order Nos.", WorkDate(), true, true);
                                                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
                                                PurchaseHeader.Insert(true);
                                                PurchaseHeader.validate("Buy-from Vendor No.", Vendor."No.");
                                                PurchaseHeader."Customer Order No." := Rec."External Document No.";
                                                PurchaseHeader.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
                                                PurchaseHeader.Validate("Ship-to Code", Rec."Ship-to Code");
                                                PurchaseHeader.Modify(true);
                                                DropShip.Run(PurchaseHeader);
                                                //Clear Unwanted Items
                                                ValidateItemVendor(PurchaseHeader."No.");
                                                Counter += 1;
                                            end;
                                        end;

                                    end;
                                end;

                            end;
                        until SalesLine.Next() = 0;
                    If Counter > 0 then
                        Message('%1 Order(s) created successfully', Counter)
                    else
                        Message('No Orders were Created!');
                end;
            }
        }
    }

    local procedure ValidateItemVendor(var PurchaseOrderNo: Code[20])
    var
        PurchHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        Item: Record Item;
    begin
        If PurchHeader.Get(PurchHeader."Document Type"::Order, PurchaseOrderNo) then begin
            PurchaseLine.Reset();
            PurchaseLine.SetRange("Document Type", PurchHeader."Document Type");
            PurchaseLine.SetRange("Document No.", PurchHeader."No.");
            if PurchaseLine.FindSet() then
                repeat
                    if (PurchaseLine.Type = PurchaseLine.Type::Item) and Item.Get(PurchaseLine."No.") then begin
                        if Item."Vendor No." <> PurchHeader."Buy-from Vendor No." then
                            PurchaseLine.Delete(true);
                    end;
                until PurchaseLine.Next() = 0;
        end;

    end;

}

