```
# Music Database Analysis Project

This project involves analyzing a music database using SQL to extract meaningful insights about employees, customers, sales, and music trends. The database contains information about employees, customers, invoices, tracks, albums, artists, and genres.

## Project Goals

The main goals of this project are to:

* Analyze employee performance and identify top performers.
* Understand customer behavior and preferences.
* Analyze sales data to identify trends and patterns.
* Gain insights into music trends and popularity.

## Database Schema

The database consists of the following tables:

* **employee:** Stores information about employees, including their ID, name, title, and level.
* **customer:** Stores information about customers, including their ID, name, email, country, and support representative.
* **invoice:** Stores information about invoices, including the invoice ID, customer ID, date, and total amount.
* **invoice_line:** Stores information about invoice lines, including the invoice line ID, invoice ID, track ID, unit price, and quantity.
* **track:** Stores information about tracks, including the track ID, name, album ID, media type ID, genre ID, composer, milliseconds, bytes, and unit price.
* **album:** Stores information about albums, including the album ID, title, and artist ID.
* **artist:** Stores information about artists, including the artist ID and name.
* **genre:** Stores information about genres, including the genre ID and name.
* **media_type:** Stores information about media types, including the media type ID and name.

## SQL Queries

The project includes a series of SQL queries that address various aspects of the database. These queries are organized into the following categories:

### Employee Analysis

* **Query 1:** Identifies the senior-most employee based on their level.
* **Query 2:** Identifies the most helpful employee based on the number of customers they support.

### Regional Analysis

* **Query 3:** Identifies the country with the most invoices.
* **Query 4:** Identifies the top 3 cities with the highest total invoice amounts.

### Customer Analysis

* **Query 5:** Identifies the best customer based on their total spending.
* **Query 6:** Retrieves the email, first name, and last name of all rock music listeners.
* **Query 7:** Calculates the money spent by each customer on each artist.
* **Query 8:** Identifies the customer who has spent the most in each country.

### Music Analysis

* **Query 9:** Identifies the top 10 artists by the number of rock songs released.
* **Query 10:** Identifies the best-selling artist based on total revenue.
* **Query 11:** Identifies the most popular media type sold.
* **Query 12:** Counts the number of tracks longer than the average song length.
* **Query 13:** Identifies the artist with the highest spending by a single customer.
* **Query 14:** Identifies the most popular music genre in each country.

### Invoice Analysis

* **Query 15:** Calculates the average invoice total.
* **Query 16:** Analyzes the number of songs per invoice compared to the average.
* **Query 17:** Calculates the average monthly and annual change in sales.

## Key Findings

Some of the key findings from the analysis include:

* The senior-most employee is [Employee Name] with the title [Employee Title].
* The most helpful employee is [Employee Name] who supports [Number] customers.
* The USA has the most invoices ([Number] invoices).
* Prague has the highest total invoice amount.
* The best customer is [Customer Name] who has spent [Amount].
* There are [Number] rock music listeners.
* The best-selling artist is Queen.
* The most popular media type is MPEG audio file.

## Conclusion

This project demonstrates the use of SQL to analyze a music database and extract valuable insights. The findings can be used to make informed decisions about employee performance, customer engagement, sales strategies, and music trends.
