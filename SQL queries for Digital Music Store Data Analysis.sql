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

-- 3. top 5 purchased tracks
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

-- 4. distribution of total sales(according to invoice) among different genre 
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

-- 5. top 3 cities based on total sales(according to invoice)
SELECT 
    I.BillingCity AS City, SUM(I.Total) AS Total_Sales_USD
FROM
    musicstore.invoice I
GROUP BY City
ORDER BY Total_Sales_USD DESC
LIMIT 3;

-- 6. Who are the Rock Music Listeners? We want to know all Rock Music listeners’ email, first names, last names, and Genres.
SELECT 
    c.Email, c.FirstName, c.LastName, g.Name AS Genre
FROM
    musicstore.invoiceline l
        JOIN
    musicstore.invoice i ON l.InvoiceId = i.InvoiceId
        JOIN
    musicstore.customer c ON i.CustomerId = c.CustomerId
        JOIN
    musicstore.track t ON l.TrackId = t.TrackId
        JOIN
    musicstore.genre g ON t.GenreId = g.GenreId
WHERE
    g.Name = 'Rock'
GROUP BY c.FirstName , c.LastName , c.Email , g.Name
ORDER BY c.Email;

-- 7. top 5 artists based on their earnings according to invoice 
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
 

-- 8. Count of unique customers over yeras
SELECT 
    YEAR(I.InvoiceDate) AS Year,
    COUNT(DISTINCT I.CustomerId) AS no_of_unique_customers
FROM
    musicstore.invoice I
GROUP BY Year
ORDER BY no_of_unique_customers DESC;

-- 9. Find out the most popular genre for each Country.
WITH CountryPurchases AS 
(SELECT I.BillingCountry AS Country,COUNT(I.InvoiceId) AS Purchases,T.GenreId,G.Name AS Genre,
DENSE_RANK()OVER(PARTITION BY I.BillingCountry ORDER BY COUNT(I.InvoiceId) DESC) AS rank_by_purchases
FROM musicstore.invoice I
JOIN musicstore.invoiceline L ON I.InvoiceId=L.InvoiceId
JOIN musicstore.track T ON T.TrackId=L.TrackId JOIN musicstore.genre G ON T.GenreId=G.GenreId
GROUP BY Country,T.GenreId,Genre)

SELECT 
    Country, Purchases, GenreId, Genre
FROM
    CountryPurchases
WHERE
    rank_by_purchases = 1
ORDER BY Country , Genre;

-- 10. Which artist has earned the most according to the Invoice Lines? 
-- AND  Use this artist to find which customer spent the most on this artist. 
DROP VIEW IF EXISTS InvoiceLinesArtistEarned;
CREATE VIEW InvoiceLinesArtistEarned AS
    (SELECT 
        A.Name AS Artist_Name,
        SUM(L.UnitPrice * L.Quantity) AS Total_Earned
    FROM
        musicstore.invoiceline L
            JOIN
        musicstore.track T ON L.TrackId = T.TrackId
            JOIN
        musicstore.album AL ON T.AlbumId = AL.AlbumId
            JOIN
        musicstore.artist A ON AL.ArtistId = A.ArtistId
    GROUP BY A.ArtistId
    ORDER BY Total_Earned DESC);

DROP PROCEDURE IF EXISTS Top_artist_by_InvoiceLines_Earned;
DELIMITER $$
CREATE PROCEDURE Top_artist_by_InvoiceLines_Earned(TOP_N INT)
DETERMINISTIC
BEGIN
SELECT * FROM InvoiceLinesArtistEarned LIMIT TOP_N;
END $$
DELIMITER ;

/* PART - 1*/
CALL Top_artist_by_InvoiceLines_Earned(1);

/* PART -2*/
SELECT 
    A.Name AS Artist_Name,
    C.CustomerId,
    C.FirstName,
    C.LastName,
    SUM(L.UnitPrice*L.Quantity) AS Total_Spent
FROM
    musicstore.invoice I
        JOIN
    musicstore.invoiceline L ON I.InvoiceId = L.InvoiceId
        JOIN
    musicstore.track T ON L.TrackId = T.TrackId
        JOIN
    musicstore.album AL ON T.AlbumId = AL.AlbumId
        JOIN
    musicstore.artist A ON AL.ArtistId = A.ArtistId
        JOIN
    musicstore.customer C ON I.CustomerId = C.CustomerId
WHERE
    A.Name = (SELECT 
            Artist_Name
        FROM
            InvoiceLinesArtistEarned
        LIMIT 1)
GROUP BY Artist_Name , I.CustomerId
ORDER BY Total_Spent DESC
LIMIT 1;

-- 11. Which Employee has the Highest Total Number of Customers?
SELECT 
    CONCAT(E.first_name, ' ', E.last_name) AS Employee_Name,
    COUNT(C.CustomerId) AS Total_Number_of_Customers
FROM
    musicstore.customer C
        JOIN
    musicstore.employee E ON C.SupportRepId = E.employee_id
GROUP BY Employee_Name
ORDER BY Total_Number_of_Customers DESC;

-- 12. List the Tracks that have a song length greater than the Average song length.
SELECT 
    T.Name AS Track_Name, T.Milliseconds AS Song_Length_MS
FROM
    musicstore.track T
WHERE
    T.Milliseconds > (SELECT 
            AVG(T.Milliseconds) AS AVERAGE_song_length
        FROM
            musicstore.track T)
ORDER BY Song_Length_MS DESC;