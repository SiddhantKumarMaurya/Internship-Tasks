-- find products missing in the production order
select W.DocEntry, O.ItemCode, count(W.ItemCode) "MaterialCount" from OWOR O
inner join WOR1 W on O.DocEntry = W.DocEntry
group by W.DocEntry, O.ItemCode

select I.Father, count(I.Code) "MaterialCount" from OITT O
inner join ITT1 I on I.Father = O.Code
group by I.Father;







-- got the document Entry, ItemCode, MaterialCount (incorrect) for which materials were off by the original count in the BOM
SELECT W.DocEntry, 
       O.ItemCode, 
       COUNT(W.ItemCode) AS MaterialCount
FROM OWOR O
INNER JOIN WOR1 W ON O.DocEntry = W.DocEntry
INNER JOIN (
    SELECT I.Father, 
           COUNT(I.Code) AS MaterialCount
    FROM OITT O
    INNER JOIN ITT1 I ON I.Father = O.Code
    GROUP BY I.Father
) C ON O.ItemCode = C.Father  -- Correctly join the subquery
GROUP BY W.DocEntry, O.ItemCode
HAVING COUNT(W.ItemCode) != (SELECT C.MaterialCount 
							 FROM (SELECT I.Father, COUNT(I.Code) AS MaterialCount
                             FROM OITT O
                             INNER JOIN ITT1 I ON I.Father = O.Code
                             GROUP BY I.Father) C
                             WHERE C.Father = O.ItemCode)
ORDER BY W.DocEntry ASC


-- final solution 
SELECT distinct O.DocEntry, O.ItemCode "Product" , I.Code "Missing Materials" FROM OWOR O
INNER JOIN WOR1 W ON O.DocEntry = W.DocEntry
INNER JOIN (
SELECT W.DocEntry, 
       O.ItemCode, 
       COUNT(W.ItemCode) AS MaterialCount
FROM OWOR O
INNER JOIN WOR1 W ON O.DocEntry = W.DocEntry
INNER JOIN (
    SELECT I.Father, 
           COUNT(I.Code) AS MaterialCount
    FROM OITT O
    INNER JOIN ITT1 I ON I.Father = O.Code
    GROUP BY I.Father
) C ON O.ItemCode = C.Father
GROUP BY W.DocEntry, O.ItemCode
HAVING COUNT(W.ItemCode) != (SELECT C.MaterialCount 
							 FROM (SELECT I.Father, COUNT(I.Code) AS MaterialCount
                             FROM OITT O
                             INNER JOIN ITT1 I ON I.Father = O.Code
                             GROUP BY I.Father) C
                             WHERE C.Father = O.ItemCode)
) P ON O.DocEntry = P.DocEntry
INNER JOIN ITT1 I ON O.ItemCode = I.Father 
WHERE NOT EXISTS (
    SELECT 1
    FROM WOR1 W1
    WHERE W1.ItemCode = I.Code
    AND W1.DocEntry = O.DocEntry
);


