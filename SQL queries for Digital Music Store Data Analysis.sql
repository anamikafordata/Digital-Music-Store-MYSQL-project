-- 1. Total Sales Over the years
SELECT 
    YEAR(I.InvoiceDate) AS Year,
    SUM(I.Total) AS Total_Sales_Amount_In_USD
FROM
    musicstore.invoice I
GROUP BY Year
ORDER BY Total_Sales_Amount_In_USD DESC;

    
-- 2. Who are our top 5 Customers according to Invoices?
SELECT 
    CONCAT(C.FirstName, ' ', C.LastName) AS Customer_Name,
    SUM(I.Total) AS Total_Spent_Amount_USD
FROM
    musicstore.invoice I
        JOIN
    musicstore.customer C ON I.CustomerId = C.CustomerId
GROUP BY Customer_Name
ORDER BY Total_Spent_Amount_USD DESC LIMIT 5;

--  top 5 purchased tracks
SELECT 
    L.TrackId,
    T.Name AS TrackName,
    SUM(L.Quantity) AS QuantityPurchased
FROM
    musicstore.invoiceline L
        JOIN
    musicstore.track T ON L.TrackId = T.trackId
GROUP BY L.TrackId , TrackName
ORDER BY QuantityPurchased DESC
LIMIT 5;

-- 3. distribution of total sales(according to invoice) among different genre 
SELECT 
    G.Name AS Genre_Name, SUM(I.Total) AS Total_Sales_USD
FROM
    musicstore.invoice I
        JOIN
    musicstore.invoiceline L ON I.InvoiceId = L.InvoiceId
        JOIN
    musicstore.track T ON L.TrackId = T.TrackId
        JOIN
    musicstore.genre G ON T.GenreId = G.GenreId
GROUP BY Genre_Name
ORDER BY Total_Sales_USD DESC;

-- 4. top 3 cities based on total sales(according to invoice)
SELECT 
    I.BillingCity AS City, SUM(I.Total) AS Total_Sales_USD
FROM
    musicstore.invoice I
GROUP BY City
ORDER BY Total_Sales_USD DESC
LIMIT 3;

-- 5. distribution of total sales(according to invoice) among different genre 
SELECT 
    G.Name AS Genre_Name, SUM(I.Total) AS Total_Sales_USD
FROM
    musicstore.invoice I
        JOIN
    musicstore.invoiceline L ON I.InvoiceId = L.InvoiceId
        JOIN
    musicstore.track T ON L.TrackId = T.TrackId
        JOIN
    musicstore.genre G ON T.GenreId = G.GenreId
GROUP BY Genre_Name
ORDER BY Total_Sales_USD DESC;

-- 6. top 5 artists based on their earnings according to invoice 
SELECT 
    A.ArtistId,A.Name AS Artist_Name,SUM(I.Total) AS Total_Amount_Earned_USD 
FROM
    musicstore.invoice I
        JOIN
    musicstore.invoiceline L ON I.InvoiceId = L.InvoiceId
        JOIN
    musicstore.track T ON L.TrackId = T.TrackId
        JOIN
    musicstore.album AL ON T.AlbumId=AL.AlbumId
    JOIN 
    musicstore.artist A ON AL.ArtistId=A.ArtistId
    GROUP BY A.ArtistId ORDER BY Total_Amount_Earned_USD DESC LIMIT 5 ;
 

-- 7. Count of unique customers over yeras
SELECT 
    YEAR(I.InvoiceDate) AS Year,
    COUNT(DISTINCT I.CustomerId) AS no_of_unique_customers
FROM
    musicstore.invoice I
GROUP BY Year
ORDER BY no_of_unique_customers DESC;