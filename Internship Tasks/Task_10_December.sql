-- This stored procedure retrieves detailed information for a given sales order (specified by @DocEntry).
-- It creates a temporary table (DISPLAY) to store the results, including sales order details, customer information, item data, inventory, and invoice details.
-- It includes fields such as item code, business partner info, contact details, GST relevance, material type, warehouse, location, tax code, and unit price.
-- After populating the temporary table with the results, it selects all records from DISPLAY and then drops the temporary table.


alter procedure GetDetails
	@DocEntry int
as
begin
	create table DISPLAY( 
		DocEntry int,
		ItemCode nvarchar(50),
		CardCode nvarchar(15),
		CardName nvarchar(200),
		"SO Posting Date" datetime,
		"SO Delivery Date" datetime,
		"SO Document Date" datetime,
		"CP Name" nvarchar(50),
		"First Name" nvarchar(50),
		"Middle Name" nvarchar(50),
		"Last Name" nvarchar(50),
		"Title" nvarchar(10),
		"Position" nvarchar(90),
		"Telephone" nvarchar(90),
		"Mobile Phone" nvarchar(50),
		"Fax" nvarchar(50),
		"E Mail" nvarchar(100),
		"GST" char(1),
		"Active" char(15),
		"Material Type" nvarchar(30),
		"HSN" nvarchar(50),
		"Warehouse" nvarchar(100),
		"Location" nvarchar(100),
		"INV Posting Date" datetime,
		"INV Due Date" datetime,
		"INV Document Date" datetime,
		"INV QTY" numeric(19, 6),
		"INV Unit Price" numeric(19, 6),
		"Tax Code" nvarchar(8),
		"Rate" numeric(19, 6)
	);

	insert into DISPLAY (
    DocEntry,
    ItemCode,
    CardCode,
    CardName,
    "SO Posting Date",
    "SO Delivery Date",
    "SO Document Date",
    "CP Name",
    "First Name",
    "Middle Name",
    "Last Name",
    "Title",
    "Position",
    "Telephone",
    "Mobile Phone",
    "Fax",
    "E Mail",
    "GST",
    "Active",
    "Material Type",
    "HSN",
    "Warehouse",
	"Location",
    "INV Posting Date",
    "INV Due Date",
    "INV Document Date",
    "INV QTY",
    "INV Unit Price",
    "Tax Code",
    "Rate"
	)
	(select 
	R.DocEntry, --int
    D.ItemCode, --nvarchar(50)
    O.CardCode, --nvarchar(15)
    O.CardName, --nvarchar(200)
    R.DocDate as "SO Posting Date", --datetime
    R.DocDueDate as "SO Delivery Date", --datetime
    R.TaxDate as "SO Document Date", --datetime
    C.Name as "CP Name", --nvarchar(50)
    C.FirstName as "First Name", --nvarchar(50)
    C.MiddleName as "Middle Name", --nvarchar(50)
    C.LastName as "Last Name", --nvarchar(50)
    C.Title, --nvarchar(10)
    C.Position, --nvarchar(90)
    C.Tel1 as "Telephone1", --nvarchar(90)
    C.Cellolar as "Mobile Phone", --nvarchar(50)
    C.Fax as "Fax", --nvarchar(50)
    C.E_MailL, --nvarchar(100)
    I.GSTRelevnt, --char(1)
	case 
		when I.ValidFor = 'Y' then 'Yes'
		else 'No'
    end as "Active", --nvarchar(15)
    case 
        when I.GSTRelevnt = 'Y' then
            case 
                when I.MatType = 1 then 'Raw Material'
                when I.MatType = 2 then 'Capital Goods'
                when I.MatType = 3 then 'Finished Goods'
                else null
            end
        else null 
    end as "Material Type", --nvarchar(30)
	case
		when H.ChapterID != '-1' then H.ChapterID
		else null
    end as "HSN", --nvarchar(50)
	S.WhsName "Warehouse", --nvarchar(100)
	T.Location, --nvarchar(100)
	OI.DocDate "INV Posting Date", --datetime
	OI.DocDueDate "INV Due Date", --datetime
	OI.TaxDate "INV Document Date", --datetime
	NV.Quantity "INV QTY", --numeric(19, 6)
	NV.Price "INV Unit Price", --numeric(19, 6)
	NV.TaxCode, --nvarchar(8)
	TC.Rate --numeric(19, 6)
	from ORDR R
	inner join OCRD O on O.CardCode = R.CardCode
	inner join OCPR C on C.CardCode = O.CardCode
	inner join RDR1 D on D.DocEntry = R.DocEntry
	inner join OITM I on I.ItemCode = D.ItemCode
	left join OCHP H on H.AbsEntry = I.ChapterID and I.ChapterID != -1
	inner join OITW W on W.ItemCode = I.ItemCode
	inner join OWHS S on S.WhsCode = W.WhsCode
	inner join OLCT T on T.Code = S.Location
	inner join INV1 NV on NV.ObjType = D.TargetType and NV.BaseLine = D.LineNum and NV.BaseEntry = D.DocEntry
	inner join OINV OI on OI.DocEntry = NV.DocEntry
	inner join OSTC TC on TC.Code = NV.TaxCode
	where R.DocEntry = @DocEntry
	)

	select * from DISPLAY;

	drop table DISPLAY;
end
go


exec GetDetails @DocEntry = 7;
