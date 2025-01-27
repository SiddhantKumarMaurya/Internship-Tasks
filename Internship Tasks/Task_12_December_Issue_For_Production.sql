-- This query joins OWOR (Work Orders), WOR1 (Work Order Lines), IGE1 (Goods Receipt Lines), and IBT1 (Inventory Transfers) tables.
-- It retrieves work order details such as document number, item code, warehouse, batch number, quantity, planned quantity, and work order post date.
-- The results are ordered by work order document number, item code, and batch number.


SELECT 
    OWOR.DocNum,
    WOR1.ItemCode,
    IBT1.WhsCode,
    IBT1.BatchNum,
    IBT1.Quantity,
    WOR1.PlannedQty,
    OWOR.PostDate
FROM OWOR
JOIN WOR1 ON OWOR.DocEntry = WOR1.DocEntry
JOIN IGE1 ON OWOR.DocEntry = IGE1.BaseEntry AND IGE1.BaseType = OWOR.ObjType
JOIN IBT1 ON IGE1.DocEntry = IBT1.BaseEntry AND IGE1.LineNum = IBT1.BaseLinNum 
ORDER BY OWOR.DocNum, WOR1.ItemCode, IBT1.BatchNum;

 