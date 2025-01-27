-- get all the production order for which receipt for production has been created.

select O.* from IGN1 I
inner join OWOR O on I.BaseRef = O.DocNum and O.ObjType = I.BaseType and O.DocEntry = I.BaseEntry
inner join WOR1 W on W.DocEntry = O.DocEntry


select O.DocEntry, O.ItemCode, O.ProdName, O.PlannedQty, O.CmpltQty, W.ItemCode "Materials", W.BaseQty "MBaseQty", W.PlannedQty "MPlannedQty", W.IssuedQty "MIssuedQty", O.Status, O.PostDate, O.DueDate, O.CreateDate from IGN1 I
inner join OWOR O on I.BaseRef = O.DocNum and O.ObjType = I.BaseType and O.DocEntry = I.BaseEntry
inner join WOR1 W on W.DocEntry = O.DocEntry
