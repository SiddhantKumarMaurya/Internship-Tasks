-- This stored procedure retrieves a summary of a delivery document (specified by DocKey).
-- It joins multiple tables to return details about the delivery, including document number, business partner info, item description, quantities, GST numbers, and shipping/billing addresses.
-- It also includes information about the item's HSN code, series name, and contact details for the business partner.


ALTER PROCEDURE ESPL_DLN_SUMRY
(IN DocKey INT)
AS
BEGIN
SELECT O."DocEntry" AS "DocEntry",
	M."SeriesName",
	O."DocNum" AS "DocNum", 
	O."DocDate" AS "Date",
	O."CardCode" AS "BPCode", 
	O."CardName" AS "BPName",
	O."NumAtCard" AS "PO No",
	D."Dscription" AS "Description",
	D."Quantity" AS "Quantity",
	D."unitMsr" AS "UoM",
	H."ChapterID" AS "HSN",
	N."BpGSTN" AS "BP GSTN",
	N."LocGSTN" AS "Company GSTN",
	N."StreetS" AS "Ship From State",
	N."BlockS" AS "Ship From Block",
	N."BuildingS" AS "Ship From Building",
	N."CityS" AS "Ship From City",
	N."ZipCodeS" AS "Ship From zipcode",
	SC."Name" AS "Ship From State",
	N."StreetB" AS "BP Street",
	N."BuildingB" AS "BP Building",
	N."CityB" AS "BP City",
	N. "ZipCodeB" AS "BP ZipCode",
	S."Name" AS "BP State",
	P."Name" AS "CP Name",
	P."Cellolar" AS "CP Contact No."
FROM "ODLN" O 
INNER JOIN "DLN1" D ON D."DocEntry" = O."DocEntry"
INNER JOIN "DLN12" N ON N."DocEntry" = D."DocEntry" 
INNER JOIN "NNM1" M ON M."Series" = O."Series"
INNER JOIN "OCST" S ON S."Code" = N."StateB" AND S."Country" = N."CountryB"
INNER JOIN "OCST" SC ON SC."Code" = N."StateS" AND SC."Country" = N."CountryS"
LEFT JOIN "OCPR" P ON P."CntctCode" = O."CntctCode"
INNER JOIN "OITM" I ON I."ItemCode" = D."ItemCode"
INNER JOIN "OCHP" H ON H."AbsEntry" = I."ChapterID"
WHERE O."DocEntry" = :DocKey;
END;

CALL ESPL_DLN_SUMRY(7172);
