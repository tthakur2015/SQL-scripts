USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:
 
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) as rows_director_mapping from director_mapping;
-- Director Mapping: 3867
select count(*) as rows_genre from genre;
-- Genre: 14662
select count(*) as rows_movie from movie;
-- Movie: 7997
select count(*) as rows_names from names;
-- Names: 25735
select count(*) as rows_ratings from ratings;
-- Ratings: 7997
select count(*) as rows_role_mapping from role_mapping;
-- Role Mapping: 15615



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- null values in movie table

SELECT COUNT(*) from movie
WHERE id is null; 
-- id coulmn has 0 null values

SELECT COUNT(*) from movie
WHERE title is null; 
-- title coulmn has 0 null values

SELECT COUNT(*) from movie
WHERE year is null; 
-- year coulmn has 0 null values

SELECT COUNT(*) from movie
WHERE date_published is null; 
-- date_published coulmn has 0 null values

SELECT COUNT(*) from movie
WHERE duration is null; 
-- duration coulmn has 0 null values

SELECT count(*) from movie
WHERE country is null; 
-- year coulmn has 20 null values

SELECT COUNT(*) from movie
WHERE worlwide_gross_income is null;  
-- worlwide_gross_income coulmn has 3724 null values

SELECT COUNT(*) from movie
WHERE production_company is null; 
-- production_company coulmn has 528 null values

SELECT COUNT(*) from movie
WHERE languages is null; 
-- languages coulmn has 194 null values



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+ */
    
/* Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Part 1:
SELECT 
	YEAR(date_published) AS year,
    COUNT(*) AS number_of_movies
FROM 
	movie
GROUP BY 
	YEAR(date_published)
ORDER BY 
	YEAR(date_published);

-- Part 2:
SELECT 
	MONTH(date_published) AS month_num,
    COUNT(*) AS number_of_movies
FROM 
	movie
GROUP BY 
	MONTH(date_published)
ORDER BY 
	MONTH(date_published);
    

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(*) FROM movie
WHERE country like '%USA%' OR country like '%India%' 
AND year = 2019;
 -- There are 3164 movies produced by USA or India for the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT 
	DISTINCT genre
FROM 
	genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre, Count(id) as movie_count
FROM movie m 
inner join genre g
on m.id=g.movie_id
group by genre  
order by movie_count desc;

 -- Drama genre has the highest number of movie count


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- 3289
-- Type your code below:
WITH genre_count_table AS
(
	SELECT 
		movie_id,
		COUNT(genre) as genre_count
	FROM
		genre
	GROUP BY 
		movie_id
	HAVING 
		COUNT(genre) = 1
)
SELECT 
	COUNT(*) AS movies_belong_to_songle_genre 
FROM 
	genre_count_table;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre, AVG(duration) as avg_duration
FROM movie m 
inner join genre g
on m.id=g.movie_id
group by genre  
order by avg_duration desc;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘Thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- Answer: 3
-- (Hint: Use the Rank function)
    
/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_count_table AS
(
	SELECT 
		genre,
		COUNT(movie_id) as movie_count
	FROM
		genre
	GROUP BY 
		genre
)
SELECT 
	genre,
    movie_count,
    DENSE_RANK() OVER (ORDER BY movie_count DESC) AS genre_rank
FROM
	genre_count_table;



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:
SELECT
    MIN(avg_rating) AS min_avg_rating,
	MAX(avg_rating) AS max_avg_rating,
	MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
	MAX(median_rating) AS max_median_rating
FROM 
	ratings;
    
    
    
-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
	MIN(avg_rating) min_avg_rating,MAX(avg_rating) max_avg_rating,
    min(total_votes) min_total_votes,MAX(total_votes) max_total_votes,
	MIN(median_rating) min_median_rating,MAX(median_rating) max_median_rating 
FROM 
	ratings; 

-- # min_avg_rating		max_avg_rating		min_total_votes		max_total_votes		min_median_rating	max_median_rating
-- 			1.0				10.0				100					725138				1					10



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH avg_rating_rank AS
(
	SELECT 
		movie_id, 
        avg_rating,
        DENSE_RANK() OVER (ORDER BY avg_rating DESC) as movie_rank
	FROM
		ratings
)
SELECT 
	m.title,
    a.avg_rating,
    a.movie_rank
FROM 
	avg_rating_rank a
LEFT JOIN 
	movie m
ON	a.movie_id = m.id
WHERE
	movie_rank <= 10;



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating , COUNT(title) as movie_count 
FROM movie m 
inner join ratings r
on m.id=r.movie_id
group by median_rating 
order by movie_count DESC;




/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
	production_company, 
    COUNT(*) AS movie_count,
    DENSE_RANK() OVER (ORDER BY count(*) DESC) AS prod_company_rank
FROM 
	movie m
LEFT JOIN
	ratings r 
ON m.id = r.movie_id
WHERE 
	avg_rating > 8
GROUP BY production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, count(title) as movie_count
FROM movie m 
INNER JOIN genre g
ON m.id=g.movie_id
INNER JOIN ratings r
ON m.id=r.movie_id
WHERE country like '%USA%' 
AND year = 2017 AND month(date_published)=3
AND total_votes > 1000
group by genre  ;




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
	title, 
    avg_rating,
    genre
FROM
	movie m
LEFT JOIN 
	ratings r
ON m.id = r.movie_id
LEFT JOIN
	genre g
ON m.id = g.movie_id
WHERE 
	title REGEXP '^The'
    AND
    avg_rating > 8
ORDER BY 
	genre DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT count(title) as movie_count 
FROM movie m
INNER JOIN ratings r on m.id=r.movie_id
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01' AND median_rating=8;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- German: 4421525 / Italian: 2559540 (German > Italian)
-- Type your code below:
SELECT 
    SUM(total_votes) AS 'NET TOTAL VOTES' 
FROM 
	movie m
INNER JOIN
	ratings r
ON m.id = r.movie_id
WHERE languages REGEXP 'Italian';

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
	COUNT(*)-COUNT(name) AS name_nulls,
	COUNT(*)-COUNT(height) AS height_nulls,
	COUNT(*)-COUNT(date_of_birth) AS date_of_birth_nulls,
	COUNT(*)-COUNT(known_for_movies) AS known_for_movies_nulls
FROM names; 

/*
# name_nulls	height_nulls	date_of_birth_nulls		known_for_movies_nulls
		0			17335			13431					15226
*/



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
-- 1. James Mangold, Anthony Russo, Joe Russo

/* Output format:
+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH raw_director_genre_data AS
(
	SELECT 
		title,
		name,
		genre,
		avg_rating
	FROM 
		movie m
	LEFT JOIN 
		ratings r
		ON m.id = r.movie_id
	LEFT JOIN 
		genre g
		ON m.id = g.movie_id
	LEFT JOIN
		director_mapping dm
		ON m.id = dm.movie_id
	LEFT JOIN 	
		names n 
		ON n.id = dm.name_id
	WHERE 
		avg_rating > 8
), top_three_genres AS
(
	SELECT genre, COUNT(*) FROM raw_director_genre_data GROUP BY genre ORDER BY COUNT(*) DESC LIMIT 3
)
SELECT 
		name,
        COUNT(title) AS movie_count
	FROM 
		raw_director_genre_data
	WHERE 
		genre IN (SELECT genre FROM top_three_genres) AND 
        name IS NOT NULL
	GROUP BY 
		name
	ORDER BY COUNT(title) DESC;

-- Query to find out the number of movies that do not have director mapping
/* --------------------------
SELECT 
	COUNT(*)
FROM
	movie m
LEFT JOIN 
	director_mapping dm
	ON m.id = dm.movie_id
LEFT JOIN 
	names n
	ON dm.name_id = n.id 
WHERE 
	name IS NULL;
-------------------------- */

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
-- 1. Mammootty 2. Mohanlal
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
	name,  
	COUNT(m.id) movie_count
  FROM movie m INNER JOIN
  role_mapping r ON m.id=r.movie_id
  INNER JOIN names n ON r.name_id=n.id
  INNER JOIN ratings ra ON m.id=ra.movie_id
  WHERE median_rating>=8
  GROUP BY name
  ORDER BY movie_count DESC;



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH prod_comp_vote_count AS
(
	SELECT 
		production_company,
		SUM(total_votes) AS vote_count
	FROM
		movie m
	LEFT JOIN
		ratings r
		ON m.id = r.movie_id
	GROUP BY 
		production_company
	ORDER BY 
		vote_count DESC
)
SELECT 
	*, RANK() OVER (ORDER BY vote_count DESC) AS prod_comp_rank
FROM 
	prod_comp_vote_count;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actor_metrics AS
(
    SELECT 
		name, 
		SUM(total_votes) AS total_votes,
		COUNT(name) AS movie_count,
		ROUND
        ( 
		SUM(total_votes*avg_rating)/SUM(total_votes), 2
		) AS weighted_avg_rating
	FROM 
		movie m 
	LEFT JOIN 	
		ratings r
		ON 	m.id = r.movie_id
	LEFT JOIN
		role_mapping rm
		ON m.id = rm.movie_id
	LEFT JOIN 	
		names n
		ON rm.name_id = n.id
	WHERE 
		m.country = 'India' AND 
		rm.category = 'actor'
	GROUP BY 
		name
	HAVING 
		COUNT(name) > 2
)
SELECT 
	*, 
    RANK() OVER (ORDER BY weighted_avg_rating DESC, total_votes DESC) AS actor_rank
FROM
	actor_metrics
WHERE
	movie_count > 4;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_metrics AS
(
    SELECT 
		name, 
		SUM(total_votes) AS total_votes,
		COUNT(name) AS movie_count,
		ROUND
        ( 
		SUM(total_votes*avg_rating)/SUM(total_votes), 2
		) AS weighted_avg_rating
	FROM 
		movie m 
	LEFT JOIN 	
		ratings r
		ON 	m.id = r.movie_id
	LEFT JOIN
		role_mapping rm
		ON m.id = rm.movie_id
	LEFT JOIN 	
		names n
		ON rm.name_id = n.id
	WHERE 
		m.languages = 'Hindi' AND 
		m.country = 'India' AND 
		rm.category = 'actress'
	GROUP BY 
		name
	HAVING 
		COUNT(name) > 2
)
SELECT 
	*, 
    RANK() OVER (ORDER BY weighted_avg_rating DESC) AS actress_rank
FROM
	actress_metrics;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT Title ,genre,r.avg_rating ,
CASE
	WHEN r.avg_rating > 8 THEN 'Superhit movies'
	WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
	WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
	ELSE 'Flop movies'
END AS categories
FROM movie m INNER JOIN
genre g on m.id=g.movie_id
INNER JOIN ratings r on g.movie_id=r.movie_id
where genre ='Thriller'
ORDER BY r.avg_rating DESC;







/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
	genre,
    SUM(duration) OVER w AS running_total,
    AVG(duration) OVER w AS moving_avg
FROM 
	movie m
LEFT JOIN
	genre g
	ON m.id = g.movie_id
WINDOW 
	w AS (PARTITION BY genre ROWS UNBOUNDED PRECEDING);

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_3_genres AS
(
	SELECT 
		genre
	FROM 
		genre
	GROUP BY 
		genre
	ORDER BY 
		COUNT(*) DESC
	LIMIT 3
), raw_income_data AS
(
	SELECT 
		genre,
		title,
        year,
        CASE 
			WHEN LEFT(worlwide_gross_income, 1) = '$' THEN CAST( RIGHT(worlwide_gross_income, LENGTH(worlwide_gross_income)-2) AS UNSIGNED)
            WHEN LEFT(worlwide_gross_income, 1) = 'I' THEN CAST( RIGHT(worlwide_gross_income, LENGTH(worlwide_gross_income)-4) AS UNSIGNED)/75
			ELSE 0
		END AS income_in_$,
		DENSE_RANK() OVER (PARTITION BY year ORDER BY worlwide_gross_income DESC) AS year_wise_rank
	FROM 
		movie m
	LEFT JOIN 
		genre g
		ON m.id = g.movie_id
	WHERE 
		genre IN 
			( SELECT * FROM top_3_genres)
)
SELECT 
	genre, 
    year, 
    title,
    income_in_$
FROM 
	raw_income_data;
	





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH multilingual_count AS
(
	SELECT 
		production_company,
		COUNT(title) AS movie_count
	FROM
		movie m
	LEFT JOIN 
		ratings r
		ON m.id = r.movie_id
	WHERE 
		POSITION(',' IN languages) > 0
		AND median_rating >= 8
	GROUP BY 
		production_company
)
SELECT 
	*,
    RANK() OVER (ORDER BY movie_count DESC) AS prod_comp_rank
FROM
	multilingual_count
WHERE 
	production_company IS NOT NULL;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH drama_actress_raw AS
(
	SELECT 
		name as actress_name,
		SUM(total_votes) AS totaL_votes,
		COUNT(title) AS movie_count,
		AVG(avg_rating) AS avg_rating
	FROM
		movie m
	LEFT JOIN
		ratings r
		ON r.movie_id = m.id
	LEFT JOIN
		genre g
		ON m.id = g.movie_id
	LEFT JOIN
		role_mapping rm
		ON rm.movie_id = m.id
	LEFT JOIN
		names n
		ON n.id = rm.name_id
	WHERE 
		category = 'actress'
		AND avg_rating > 8
		AND genre = 'Drama'
	GROUP BY
		name
)
SELECT 
	*,
    RANK() OVER (ORDER BY movie_count DESC, avg_rating DESC) AS actress_rank
FROM 
	drama_actress_raw
LIMIT 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH dir_raw_data AS
(
	SELECT 
		dm.name_id AS director_id,
		name AS director_name,
		title,
		date_published,
		lag(date_published) over (partition by name ORDER BY date_published) as lag_date_published,
		avg_rating,
		total_votes,
		duration
	FROM 
		movie m
	LEFT JOIN
		ratings r
		ON r.movie_id = m.id
	LEFT JOIN 
		director_mapping dm
		ON m.id = dm.movie_id
	LEFT JOIN 
		names n 
		ON dm.name_id = n.id
	WHERE 
		dm.name_id IS NOT NULL
)
SELECT 
	
	director_id, 
    director_name,
    COUNT(title) AS number_of_movies,
    COALESCE(
			ROUND( AVG(DATEDIFF(date_published, lag_date_published)), 0), 0
            ) 
            AS avg_inter_movie_days,
    AVG(avg_rating) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM
	dir_raw_data
GROUP BY 
	director_id,
    director_name;


 
	
    
	






