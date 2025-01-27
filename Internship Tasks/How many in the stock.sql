-- For the production, find how many of that product already exists in the inventory.

select I.ItemCode, I.ItemName, H.WhsName, W.OnHand "In Stock", W.IsCommited "Commited", W.OnOrder "Ordered", W.OnOrder - (W.IsCommited + W.OnHand) "Available" from OITT O
inner join OITM I on O.Code = I.ItemCode
inner join OITW W on I.ItemCode = W.ItemCode
inner join OWHS H on H.WhsCode = W.WhsCode