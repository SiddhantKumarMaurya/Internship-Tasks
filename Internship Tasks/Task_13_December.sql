-- Task December 13, 2024
-- The first query retrieves details for inward supply (purchases) by joining OPCH (Purchase Invoices), PCH1 (Purchase Invoice Lines), PCH4 (Tax Details), and other related tables.
-- It includes the document entry, item code, invoice dates, party name, GST number, HSN code, taxable amount, tax codes (IGST, CGST, SGST), and nature of the items.
-- The results provide GST-related details for inward supplies.

-- The second query retrieves details for outward supply (sales) by joining OINV (Sales Invoices), INV1 (Sales Invoice Lines), and other related tables.
-- It includes the document entry, item code, quantity, GST registration number, tax rate, HSN code, taxable amount, and tax codes (IGST, CGST, SGST).
-- The results also include export information and any remarks related to the sales transaction.



-- invard supply
select
	O.DocEntry,
	I.ItemCode,
	O.DocDate "Date of Entry", 
	O.TaxDate "Invoice Date", 
	O.CardName "Party Name", 
	PC.BpGSTN "GSTN",  --select * from PCH12
	O.NumAtCard "Invoice No.",
	H.ChapterID "HSN/SAC",
	P.VatSum "Taxable",
	case
		when P2.staType = -120
		then P2.staCode
		else null
	end as IGST,
	case
		when P2.staType = -100
		then P2.staCode
		else null
	end as CGST,
	case
		when P2.staType = -110
		then P2.staCode
		else null
	end as SGST,
	B.ItmsGrpNam "Nature"
	from OPCH O 
inner join PCH1 P on P.DocEntry = O.DocEntry
inner join PCH4 P2 on P2.DocEntry = P.DocEntry and P2.LineNum = P.LineNum
inner join OSTT T on T.AbsId = P2.staType
inner join OCRD C on O.CardCode = C.CardCode
left join CRD1 R on R.CardCode = C.CardCode
inner join OITM I on I.ItemCode = P.ItemCode
inner join OCHP H on H.AbsEntry = I.ChapterID
inner join OITB B on B.ItmsGrpCod = I.ItmsGrpCod
inner join PCH12 PC on PC.DocEntry = P.DocEntry;




-- outward Supply
select 
	O.DocEntry,
	O.CardCode,
	I.ItemCode,
	I.Quantity,
	O.CardName,
	C.GSTRegnNo,
	--C.StreetNo,
	O.DocDate "Date",
	O.NumAtCard "Inv. No.",
	N.TaxRate "Rate of Tax",
	C.ZipCode,
	S.Name "State",
	P.ChapterID "HSN",
	G.GroupName,
	I.VatSum "Taxable",
	case
		when NV.ImpORExp = 'Y' 
		then 'Yes'
		else 'No'
	end as Export,
	case
		when V.staType = -120
		then V.staCode
		else null
	end as IGST,
	case
		when V.staType = -100
		then V.staCode
		else null
	end as CGST,
	case
		when V.staType = -110
		then V.staCode
		else null
	end as SGST,
	O.Comments Remarks
from OINV O
inner join INV1 I on I.DocEntry = O.DocEntry
inner join OCRD R on R.CardCode = O.CardCode
left join CRD1 C on C.CardCode = R.CardCode
inner join INV4 N on N.DocEntry = I.DocEntry and N.LineNum = I.LineNum
left join OCST S on S.Code = C.State
inner join OITM M on M.ItemCode = I.ItemCode
left join OCHP P on P.AbsEntry = M.ChapterID
inner join INV4 V on V.DocEntry = I.DocEntry and V.LineNum = I.LineNum
inner join INV12 NV on NV.DocEntry = I.DocEntry
inner join OCRG G on G.GroupCode = R.GroupCode;




