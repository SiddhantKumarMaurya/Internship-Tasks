-- make a join of Issue for production and Bill of Material

select O.DocEntry, O.ItemCode, I.BaseRef, I.ItemCode, I.Dscription, I.Quantity, I.WhsCode from IGE1 I
inner join OWOR O on O.DocNum = I.BaseRef
inner join OITT T on T.Code = O.ItemCode;
