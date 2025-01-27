-- The first query joins OBTN (Batch Numbers), OIBT (Inventory Batch), and OIGN (Goods Issue) tables.
-- It retrieves goods receipt document details along with item codes, batch numbers, and quantities.

-- The second query joins OBTN (Batch Numbers), OIBT (Inventory Batch), and IGE1 (Goods Receipt Lines) tables.
-- It retrieves goods issue document details along with item codes, batch numbers, and quantities.
-- The results are ordered by the goods issue document entry.


select G.DocEntry "Goods Receit DocEntry", O.ItemCode, O.DistNumber "Batch Number", I.Quantity from OBTN O
inner join OIBT I on I.ItemCode = O.ItemCode and I.BatchNum = DistNumber
inner join OIGN G on G.ObjType = I.BaseType and G.DocEntry = I.BaseEntry


select G.DocEntry "Issue DocEntry", G.ItemCode, O.DistNumber "Batch Num", I.Quantity from OBTN O
inner join OIBT I on I.ItemCode = O.ItemCode and I.BatchNum = O.DistNumber
inner join IGE1 G on G.ItemCode = I.ItemCode
order by G.DocEntry;
