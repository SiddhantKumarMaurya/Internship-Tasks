--Task December 12, 2024
-- The first query joins OBTN (Batch Numbers), OIBT (Inventory Batch), PDN1 (Delivery Note Lines), and OPDN (Delivery Notes) tables.
-- It retrieves batch number-related data along with business partner information, item codes, warehouse, and quantities.

-- The second query joins OPDN (Delivery Notes), PDN1 (Delivery Note Lines), OIBT (Inventory Batch), and OBTN (Batch Numbers) tables.
-- It retrieves batch-related details along with business partner information, warehouse, and quantity.

-- The third query joins OSRN (Serial Numbers), OSRI (Inventory Serial), PDN1 (Delivery Note Lines), and OPDN (Delivery Notes) tables.
-- It retrieves serial number-related data along with business partner information, item codes, warehouse, and quantities.

-- The fourth query joins OPDN (Delivery Notes), PDN1 (Delivery Note Lines), OSRI (Inventory Serial), and OSRN (Serial Numbers) tables.
-- It retrieves serial number-related details along with business partner information, warehouse, and quantity.


select N.CardCode, N.CardName, O.ItemCode, I.BatchNum, I.WhsCode, I.Quantity from OBTN O
inner join OIBT I on I.ItemCode = O.ItemCode and I.BatchNum = O.DistNumber
inner join PDN1 D on D.ObjType = I.BaseType and D.DocEntry = I.BaseEntry and D.LineNum = I.BaseLinNum
inner join OPDN N on N.DocEntry = D.DocEntry

select N.CardCode, N.CardName, I.BatchNum, I.WhsCode, I.Quantity from OPDN N
inner join PDN1 D on D.DocEntry = N.DocEntry
inner join OIBT I on I.BaseType = D.ObjType and I.BaseEntry = D.DocEntry and I.BaseLinNum = D.LineNum
inner join OBTN O on O.ItemCode = I.ItemCode and O.DistNumber = I.BatchNum;

select N.CardCode, N.CardName, O.ItemCode, I.IntrSerial, I.WhsCode, I.Quantity from OSRN O
inner join OSRI I on I.ItemCode = O.ItemCode and I.IntrSerial = O.DistNumber
inner join PDN1 D on D.ObjType = I.BaseType and D.DocEntry = I.BaseEntry and D.LineNum = I.BaseLinNum
inner join OPDN N on N.DocEntry = D.DocEntry


select N.CardCode, N.CardName, O.ItemCode, I.IntrSerial, I.WhsCode, I.Quantity from OPDN N
inner join PDN1 D on D.DocEntry = N.DocEntry
inner join OSRI I on I.BaseType = D.ObjType and I.BaseEntry = D.DocEntry and I.BaseLinNum = D.LineNum
inner join OSRN O on O.ItemCode = I.ItemCode and O.DistNumber = I.IntrSerial

