-- This stored procedure retrieves detailed information for a given sales order (specified by @DocEntry).
-- It joins multiple tables to return data on the sales order, customer contact details, item information, inventory, and related invoice details.
-- It includes fields such as item code, customer name, GST relevance, material type, warehouse details, and tax rates.

if exists (select * from sys.objects where type = 'P' and name = 'GetDetails')
drop procedure GetDetails
go

create procedure GetDetails
	@DocEntry int
as
begin
	select 
    D.ItemCode,
    O.CardCode,
    O.CardName,
    R.DocDate AS "SO Posting Date",
    R.DocDueDate AS "SO Delivery Date",
    R.TaxDate AS "SO Document Date",
    C.Name AS "CP Name",
    C.FirstName AS "First Name",
    C.MiddleName AS "Middle Name",
    C.LastName AS "Last Name",
    C.Title,
    C.Position,
    C.Tel1 AS "Telephone1",
    C.Cellolar AS "Mobile Phone",
    C.Fax AS "Fax",
    C.E_MailL,
    I.GSTRelevnt,
	CASE 
		WHEN I.ValidFor = 'Y' THEN 'Yes'
		ELSE 'No'
    END AS "Active",
    CASE 
        WHEN I.GSTRelevnt = 'Y' THEN
            CASE 
                WHEN I.MatType = 1 THEN 'Raw Material'
                WHEN I.MatType = 2 THEN 'Capital Goods'
                WHEN I.MatType = 3 THEN 'Finished Goods'
                ELSE NULL
            END
        ELSE NULL 
    END AS "Material Type",
	CASE 
		WHEN H.ChapterID != '-1' THEN H.ChapterID
		ELSE NULL
    END AS "HSN",
	S.WhsName "Warehouse",
	OI.DocDate "INV Posting Date",
	OI.DocDueDate "INV Due Date",
	OI.TaxDate "INV Document Date",
	NV.Quantity "INV QTY",
	NV.Price "INV Unit Price",
	NV.TaxCode,
	TC.Rate
	from ORDR R
	inner join OCRD O on O.CardCode = R.CardCode
	inner join OCPR C on C.CardCode = O.CardCode
	inner join RDR1 D on D.DocEntry = R.DocEntry
	inner join OITM I on I.ItemCode = D.ItemCode
	left join OCHP H on H.AbsEntry = I.ChapterID and I.ChapterID != -1
	inner join OITW W on W.ItemCode = I.ItemCode
	inner join OWHS S on S.WhsCode = W.WhsCode
	inner join INV1 NV on NV.ObjType = D.TargetType and NV.BaseLine = D.LineNum and NV.BaseEntry = D.DocEntry
	inner join OINV OI on OI.DocEntry = NV.DocEntry
	inner join OSTC TC on TC.Code = NV.TaxCode
	where R.DocEntry = @DocEntry
end
go

exec GetDetails @DocEntry = 7;



