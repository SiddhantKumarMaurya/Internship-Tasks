--Task 11 December 2024
-- The first query selects all records from the OBTN (Batch Numbers) and OIBT (Inventory Batch) tables.
-- The second query joins OBTN and OIBT tables with PDN1 (Delivery Note Lines) and OPDN (Delivery Notes) tables to retrieve information about batch numbers, inventory details, and related sales orders.
-- It selects fields such as business partner code, business partner name, item code, batch number, warehouse, and quantity.

-- The third query selects all records from the OSRN (Serial Numbers) and OSRI (Inventory Serial) tables.
-- The fourth query joins OSRN and OSRI tables with PDN1 (Delivery Note Lines) and OPDN (Delivery Notes) tables to retrieve information about serial numbers, inventory details, and related sales orders.
-- It selects fields such as business partner code, business partner name, item code, serial number, warehouse, and quantity.



select * from OBTN;
select * from OIBT;

select N.CardCode, N.CardName, O.ItemCode, I.BatchNum, I.WhsCode, I.Quantity from OBTN O
inner join OIBT I on I.ItemCode = O.ItemCode and I.BatchNum = O.DistNumber
inner join PDN1 D on D.ObjType = I.BaseType and D.DocEntry = I.BaseEntry and D.LineNum = I.BaseLinNum
inner join OPDN N on N.DocEntry = D.DocEntry

select * from OSRN;
select * from OSRI;

select N.CardCode, N.CardName, O.ItemCode, I.IntrSerial, I.WhsCode, I.Quantity from OSRN O
inner join OSRI I on I.ItemCode = O.ItemCode and I.IntrSerial = O.DistNumber
inner join PDN1 D on D.ObjType = I.BaseType and D.DocEntry = I.BaseEntry and D.LineNum = I.BaseLinNum
inner join OPDN N on N.DocEntry = D.DocEntry
