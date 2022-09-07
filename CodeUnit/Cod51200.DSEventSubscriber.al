codeunit 51200 "DS Event Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Drop Shpt.", 'OnCodeOnBeforeSelectSalesHeader', '', false, false)]
    local procedure OnCodeOnBeforeSelectSalesHeader(var PurchaseHeader: Record "Purchase Header"; var SalesHeader: Record "Sales Header"; var IsHandled: Boolean);
    var
        SalesHeader2: Record "Sales Header";
    begin
        if PurchaseHeader."Customer Order No." <> '' then begin
            SalesHeader2.SetRange("External Document No.", PurchaseHeader."Customer Order No.");
            SalesHeader2.SetRange("Sell-to Customer No.", PurchaseHeader."Sell-to Customer No.");
            SalesHeader2.SetRange("Document Type", SalesHeader2."Document Type"::Order);
            if SalesHeader2.FindFirst() then begin
                SalesHeader.Get(SalesHeader."Document Type"::Order, SalesHeader2."No.");
                IsHandled := true;
            end;
        end;

    end;

}
