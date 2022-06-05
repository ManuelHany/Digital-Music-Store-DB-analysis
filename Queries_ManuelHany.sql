---------------------------------------------------
------------------ First Query --------------------
---------------------------------------------------
WITH t1 AS
  (SELECT g.name,
          COUNT(c.country) PurchaseCount
   FROM Genre g
   JOIN Track t ON g.GenreId = t.GenreId
   JOIN InvoiceLine il ON t.TrackId = il.TrackId
   JOIN Invoice i ON il.InvoiceId = i.InvoiceId
   JOIN Customer c ON i.CustomerId = c.CustomerId
   WHERE c.country = "France"
   GROUP BY 1
   ORDER BY 2),
     t2 AS
  (SELECT SUM(PurchaseCount) TotalPurchases
   FROM t1)
SELECT t1.name,
       ROUND((t1.PurchaseCount*100)/ROUND(t2.TotalPurchases), 2) "Purchase Percentage"
FROM t1,
     t2;

---------------------------------------------------
------------------ Second Query -------------------
---------------------------------------------------
SELECT e.Email,
       il.InvoiceId,
       COUNT(*) Above_1$unitPrice_purchase
FROM InvoiceLine il
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
WHERE UnitPrice > 0.99
GROUP BY 2
ORDER BY 3 DESC
LIMIT 3;

---------------------------------------------------
------------------ Third Query --------------------
---------------------------------------------------
SELECT ar.Name artist_name,
       t.Name Track_Name,
       t.TrackId,
       COUNT(*) "Number of Purchasing"
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId
GROUP BY 1
ORDER BY 4 DESC
LIMIT 10;

---------------------------------------------------
------------------ Fourth Query -------------------
---------------------------------------------------
SELECT a.Title albumName,
       t.Name trackName,
       COUNT(*),
       CASE
           WHEN t.Name LIKE "% love%" THEN "Love"
           WHEN t.Name LIKE "% hate%" THEN "Hate"
           ELSE "NA"
       END AS "Love_VS_Hate"
FROM Album a
JOIN Track t ON a.AlbumId = t.AlbumId
AND Love_VS_Hate != "NA"
GROUP BY 4