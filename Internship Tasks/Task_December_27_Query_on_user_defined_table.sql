-- The first query selects all records from the custom table (User Defined) [@ESPL_DD_ORRS].

-- The second query retrieves the `TaxIdNum6` field from the ADM1 (Administration) table.

-- The third query selects all records from the RDR12 (Sales Order Tax) table.

-- The fourth query selects all records from the OADM (Administration Settings) table.

-- The fifth query performs a UNION of two queries:
-- - The first part selects `TaxId0` as "Tax", `BpGSTN` as "GST", and an empty string for "CIN" from the RDR12 (Sales Order Tax) table.
-- - The second part selects an empty string for "Tax" and "GST", and `TaxIdNum6` as "CIN" from the ADM1 (Administration) table.
-- This combines tax and GST details from both tables, providing an empty CIN field where applicable.


select * from [dbo].[@ESPL_DD_ORRS];

select TaxIdNum6 from ADM1;
select * from RDR12;
select * from OADM;

select R.TaxId0 as "Tax", R.BpGSTN as "GST", '' as "CIN" from RDR12 R
union
select '' as "Tax", '' as "GST", A.TaxIdNum6 as "CIN" from ADM1 A;

