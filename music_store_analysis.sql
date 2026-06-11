use music_store;
show tables;
select * from employee;

-- 1. Who is the senior most employee based on job title?
select employee_id, first_name, last_name, title from employee
order by cast(substring(levels,2) as unsigned) desc limit 1;


-- 2. Which countries have the most Invoices?
select count(invoice_id) as invoice_count, billing_country from invoice
group by billing_country order by invoice_count desc;


-- 3. What are the top 3 values of total invoice?
select invoice_id, total from invoice order by total desc limit 3;


/* 4. Which city has the best customers? - We would like to throw a
 promotional Music Festival in the city we made the most
 money. Write a query that returns one city that has the highest
 sum of invoice totals. Return both the city name & 
 sum of all invoice totals */
select  billing_city, sum(total) as total_invoice from invoice
 group by billing_city order by total_invoice desc limit 1;


/* 5. Who is the best customer? - The customer who has spent the most
 money will be declared the best customer.
 Write a query that returns the person who has spent the most money */
select c.customer_id, c.first_name, c.last_name, sum(i.total) as invoice_total
 from customer c join invoice i on c.customer_id = i.customer_id group by
 c.customer_id,c.first_name, c.last_name order by invoice_total desc limit 1;
 
 
 /* 6. Write a query to return the email, first name, last name, &
 Genre of all Rock Music listeners. Return your list ordered alphabetically
 by email starting with A */
 select distinct c.first_name, c.last_name, c.email, g.name from customer c
 join invoice i on c.customer_id = i.customer_id join invoice_line ii on
 ii.invoice_id = i.invoice_id join track t on t.track_id = ii.track_id
 join genre g on t.genre_id = g.genre_id where g.name = 'Rock' order by c.email asc;
 
 
 /* 7. Let's invite the artists who have written the most rock music in
 our dataset. Write a query that returns the Artist name and
 total track count of the top 10 rock bands */
 select a.artist_id,a.name, count(t.track_id) as track_count from
 artist a join album aa on a.artist_id = aa.artist_id join track t
 on t.album_id = aa.album_id join genre g on g.genre_id = t.genre_id
 where g.name = 'Rock' group by a.artist_id,a.name order by track_count desc limit 10;
 
 
 /*8. Return all the track names that have a song length longer than
 the average song length.- Return the Name and Milliseconds for each track.
 Order by the song length, with the longest songs listed first */
 select name, milliseconds from track where milliseconds > ( select avg(milliseconds)
 avg_time from track) order by milliseconds desc;
 
 
 /* 9. Find how much amount is spent by each customer on artists?
 Write a query to return customer name,artist name and total spent  */
select c.first_name, c.last_name, sum(ii.unit_price * ii.quantity) as
 total_spent,aa.name from customer c join invoice i on c.customer_id = i.customer_id
join invoice_line ii on i.invoice_id = ii.invoice_id join track t on
 t.track_id = ii.track_id join album a on a.album_id = t.album_id
join artist aa on aa.artist_id = a.artist_id group by c.first_name,
 c.last_name, aa.name order by total_spent desc;
 
 
/* 10. We want to find out the most popular music Genre for each country.
 We determine the most popular genre as the genre with the highest amount
 of purchases. Write a query that returns each country along with the top Genre.
 For countries where the maximum number of purchases is shared, return all Genres */
 WITH genre_purchases AS (
    SELECT c.country,g.name AS genre_name,COUNT(*) AS purchases,DENSE_RANK()
    OVER (PARTITION BY c.country ORDER BY COUNT(*) DESC) AS rnk FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id JOIN invoice_line il ON
    i.invoice_id = il.invoice_id JOIN track t ON il.track_id = t.track_id JOIN
    genre g ON t.genre_id = g.genre_id GROUP BY c.country, g.name)
SELECT country,genre_name,purchases FROM genre_purchases WHERE rnk = 1 ORDER BY country;


/* 11. Write a query that determines the customer that has spent the most
 on music for each country. Write a query that returns the country along with
 the top customer and how much they spent. For countries where the top amount
 spent is shared, provide all customers who spent this amount */
WITH customer_spending AS (
SELECT c.country,c.customer_id,c.first_name,c.last_name,SUM(i.total) AS
 total_spent,DENSE_RANK() OVER (PARTITION BY c.country ORDER BY SUM(i.total) DESC)
 AS rnk FROM customer c JOIN invoice i ON c.customer_id = i.customer_id GROUP BY c.country,
c.customer_id, c.first_name, c.last_name) SELECT country,customer_id,first_name,
last_name,total_spent FROM customer_spending WHERE rnk = 1 ORDER BY country;


 

 
