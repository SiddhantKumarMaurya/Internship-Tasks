-- This stored procedure retrieves invoice details based on the provided @ObjType parameter.
-- If @ObjType is 18 (Purchase Invoice), it retrieves the business partner code, business partner name, item code, and quantity from OPCH (Purchase Invoices) and PCH1 (Purchase Invoice Lines).
-- If @ObjType is 13 (Sales Invoice), it retrieves the business partner code, business partner name, item code, and quantity from OINV (Sales Invoices) and INV1 (Sales Invoice Lines).


alter procedure Invoice
@ObjType int
as
if @ObjType = 18
begin
	select O.CardCode, O.CardName, P.ItemCode, P.Quantity from OPCH O
	inner join PCH1 P on P.DocEntry = O.DocEntry;
end
else if @ObjType = 13
begin
	select O.CardCode, O.CardName, I.ItemCode, I.Quantity from OINV O
	inner join INV1 I on I.DocEntry = O.DocEntry;
end

exec Invoice @ObjType = 18;