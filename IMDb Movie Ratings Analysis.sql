USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Total number of rows in the 'ratings' table 
SELECT COUNT(*) FROM ratings;

-- Total number of rows in the 'director_mapping' table 
SELECT COUNT(*) FROM director_mapping;

-- Total number of rows in the 'names' table
SELECT COUNT(*) FROM names;

-- Total number of rows in the 'role_mapping' table
SELECT COUNT(*) FROM role_mapping;

-- Total number of rows in the 'movie' table
SELECT COUNT(*) FROM movie;

-- Total number of rows in the 'genre' table
SELECT COUNT(*) FROM genre;




-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT Sum(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null_count,
       Sum(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null_count,
       Sum(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null_count,
       Sum(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null_count,
       Sum(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null_count,
       Sum(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null_count,
       Sum(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_null_count,
       Sum(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null_count,
       Sum(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null_count
FROM movie;     

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Number of movies released each year

SELECT year,
       Count(title) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY year;

-- Number of movies released each month 

SELECT Month(date_published) AS MONTH_NUM,
       Count(*)              AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, letâ€™s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??

-- Type your code below:

SELECT Count(DISTINCT id) AS number_of_movies, year
FROM   movie
WHERE  ( country LIKE '%INDIA%' OR country LIKE '%USA%' )
       AND year = 2019
GROUP BY year;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Letâ€™s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM   genre; 


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldnâ€™t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT     genre,
           Count(m.id) AS number_of_movies
FROM       movie       AS m
INNER JOIN genre       AS g
where      g.movie_id = m.id
GROUP BY   genre
ORDER BY   number_of_movies
DESC limit 1 ;

/* So, based on the insight that you just drew, RSVP Movies should focus on the â€˜Dramaâ€™ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, letâ€™s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- For the ease of the process, we would be using genre table to find movies which belong to only one genre 
-- and the grouping rows based on movie id and finding the exact number of genre each movie belongs to. 
-- Lastly, we would use CTE to find the count of movies which belong to exact one genre

WITH movies_with_one_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_with_one_genre
FROM   movies_with_one_genre;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Moviesâ€™ next project.*/

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

SELECT     genre,
           Round(Avg(duration),2) AS avg_duration
FROM       movie                  AS m
INNER JOIN genre                  AS g
ON      g.movie_id = m.id
GROUP BY   genre
ORDER BY avg_duration DESC;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_summary AS
(
           SELECT     genre,
                      Count(movie_id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
           FROM       genre                                 
           GROUP BY   genre )
SELECT *
FROM   genre_summary
WHERE  genre = "THRILLER" ;

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating, 
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes, 
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating, 
    MAX(median_rating) AS max_median_rating
FROM ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, letâ€™s find out the top 10 movies based on average rating.*/

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

SELECT
    m.title,
    r.avg_rating,
    ROW_NUMBER() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM
    ratings r
INNER JOIN
    movie m
ON
    r.movie_id = m.id
LIMIT 10;

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

SELECT
    median_rating,
    COUNT(m.id) AS movie_count
FROM
    ratings r
INNER JOIN
    movie m
ON
    r.movie_id = m.id
GROUP BY
    median_rating
ORDER BY
    movie_count DESC;

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
    COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM
    movie m
INNER JOIN
    ratings r
ON
    m.id = r.movie_id
WHERE
    avg_rating > 8
    AND production_company IS NOT NULL
GROUP BY
    production_company;


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

SELECT
    genre,
    COUNT(id) AS movie_count
FROM
    genre g
INNER JOIN
    movie m
ON
    m.id = g.movie_id
INNER JOIN
    ratings r
ON
    m.id = r.movie_id
WHERE
    MONTH(date_published) = 3
    AND YEAR(date_published) = 2017
    AND total_votes > 1000
    AND country LIKE '%USA%'
GROUP BY
    genre
ORDER BY
    movie_count DESC;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word â€˜Theâ€™ and which have an average rating > 8?
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

SELECT m.title, r.avg_rating, g.genre
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
INNER JOIN genre g ON m.id = g.movie_id
WHERE m.title LIKE 'The%'
  AND r.avg_rating > 8
ORDER BY r.avg_rating DESC;

-- You should also try your hand at median rating and check whether the â€˜median ratingâ€™ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT
    COUNT(id) AS Movie_released_april2018_april2019
FROM
    movie m
INNER JOIN
    ratings r
ON
    m.id = r.movie_id
WHERE
    (date_published BETWEEN '2018-04-01' AND '2019-04-01')
    AND (median_rating = 8);

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT
    country,
    SUM(total_votes) AS total_votes
FROM
    movie AS m
INNER JOIN
    ratings AS r
ON
    m.id = r.movie_id
WHERE
    country IN ('Germany', 'Italy')
GROUP BY
    country;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Letâ€™s begin by searching for null values in the tables.*/

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
    SUM(CASE WHEN name IS NULL THEN 1 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 END) AS known_for_movies_nulls
FROM names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Letâ€™s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH GenreAvgRatings AS (
    SELECT
        genre,
        AVG(r.rating) AS avg_rating,
        COUNT(*) AS movie_count
    FROM movies m
    JOIN ratings r ON m.movie_id = r.movie_id
    GROUP BY genre
    HAVING AVG(r.rating) > 8
),
TopGenres AS (
    SELECT
        genre
    FROM GenreAvgRatings
    ORDER BY movie_count DESC
    LIMIT 3
),
DirectorMovieCounts AS (
    SELECT
        d.director_name,
        COUNT(*) AS movie_count
    FROM movies m
    JOIN directors d ON m.director_id = d.director_id
    WHERE m.genre IN (SELECT genre FROM TopGenres)
    GROUP BY d.director_name
),
RankedDirectors AS (
    SELECT
        director_name,
        movie_count,
        RANK() OVER (ORDER BY movie_count DESC) AS rank
    FROM DirectorMovieCounts
)
SELECT
    director_name,
    movie_count
FROM RankedDirectors
WHERE rank <= 3
ORDER BY movie_count DESC;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, letâ€™s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
    N.name AS actor_name,
    COUNT(M.id) AS movie_count
FROM
    role_mapping AS RM
 INNER JOIN
    movie AS M ON M.id = RM.movie_id
 INNER JOIN
    ratings AS R USING(movie_id)
 INNER JOIN
    names AS N ON N.id = RM.name_id
WHERE
    R.median_rating >= 8
    AND RM.category = 'ACTOR'
GROUP BY
    N.name
ORDER BY
    movie_count DESC
LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Letâ€™s find out the top three production houses in the world.*/

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

WITH ProductionVotes AS (
    SELECT
        p.production_company,
        SUM(m.vote_count) AS total_vote_count
    FROM movies m
    JOIN production_companies p ON m.production_company_id = p.production_company_id
    GROUP BY p.production_company
),
RankedProductionCompanies AS (
    SELECT
        production_company,
        total_vote_count,
        RANK() OVER (ORDER BY total_vote_count DESC) AS prod_comp_rank
    FROM ProductionVotes
)
SELECT
    production_company,
    total_vote_count AS vote_count,
    prod_comp_rank
FROM RankedProductionCompanies
WHERE prod_comp_rank <= 3
ORDER BY prod_comp_rank;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Letâ€™s find who these actors could be.*/

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

WITH ActorMovieRatings AS (
    SELECT
        a.actor_name,
        m.rating,
        m.vote_count
    FROM movies m
    JOIN movie_actors ma ON m.movie_id = ma.movie_id
    JOIN actors a ON ma.actor_id = a.actor_id
    WHERE m.country = 'India'
),
ActorStats AS (
    SELECT
        actor_name,
        COUNT(*) AS movie_count,
        SUM(vote_count) AS total_votes,
        SUM(rating * vote_count) / NULLIF(SUM(vote_count), 0) AS actor_avg_rating
    FROM ActorMovieRatings
    GROUP BY actor_name
    HAVING COUNT(*) >= 5
),
RankedActors AS (
    SELECT
        actor_name,
        total_votes,
        movie_count,
        actor_avg_rating,
        RANK() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
    FROM ActorStats
)
SELECT
    actor_name,
    total_votes,
    movie_count,
    actor_avg_rating,
    actor_rank
FROM RankedActors
WHERE actor_rank = 1;

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

WITH ActressMovieRatings AS (
    SELECT
        a.actress_name,
        m.rating,
        m.vote_count
    FROM movies m
    JOIN movie_actors ma ON m.movie_id = ma.movie_id
    JOIN actresses a ON ma.actress_id = a.actress_id
    WHERE m.country = 'India' AND m.language = 'Hindi'
),
ActressStats AS (
    SELECT
        actress_name,
        COUNT(*) AS movie_count,
        SUM(vote_count) AS total_votes,
        SUM(rating * vote_count) / NULLIF(SUM(vote_count), 0) AS actress_avg_rating
    FROM ActressMovieRatings
    GROUP BY actress_name
    HAVING COUNT(*) >= 3
),
RankedActresses AS (
    SELECT
        actress_name,
        total_votes,
        movie_count,
        actress_avg_rating,
        RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
    FROM ActressStats
)
SELECT
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    actress_rank
FROM RankedActresses
WHERE actress_rank <= 5
ORDER BY actress_rank;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT
    m.movie_id,
    m.title,
    m.rating,
    CASE
        WHEN m.rating > 8 THEN 'Superhit movies'
        WHEN m.rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN m.rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        WHEN m.rating < 5 THEN 'Flop movies'
        ELSE 'Unknown category'
    END AS movie_category
FROM movies m
WHERE m.genre = 'Thriller'
ORDER BY m.rating DESC;

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

WITH GenreAvgDuration AS (
    SELECT
        genre,
        AVG(duration) AS avg_duration
    FROM movies
    GROUP BY genre
),

RunningTotal AS (
    SELECT
        genre,
        avg_duration,
        SUM(avg_duration) OVER (PARTITION BY genre ORDER BY genre) AS running_total_duration
    FROM GenreAvgDuration
),
MovingAvg AS (
    SELECT
        genre,
        avg_duration,
        running_total_duration,
        AVG(avg_duration) OVER (PARTITION BY genre ORDER BY genre ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS moving_avg_duration
    FROM RunningTotal
)
SELECT
    genre,
    ROUND(avg_duration, 2) AS avg_duration,
    ROUND(running_total_duration, 2) AS running_total_duration,
    ROUND(moving_avg_duration, 2) AS moving_avg_duration
FROM MovingAvg
ORDER BY genre;

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

WITH GenreMovieCount AS (
    SELECT
        genre,
        COUNT(*) AS movie_count
    FROM movies
    GROUP BY genre
),
TopGenres AS (
    SELECT
        genre
    FROM GenreMovieCount
    ORDER BY movie_count DESC
    LIMIT 3
),
RankedMovies AS (
    SELECT
        m.genre,
        m.year,
        m.title AS movie_name,
        m.worldwide_gross_income,
        ROW_NUMBER() OVER (PARTITION BY m.year, m.genre ORDER BY m.worldwide_gross_income DESC) AS movie_rank
    FROM movies m
    JOIN TopGenres tg ON m.genre = tg.genre
)
SELECT
    genre,
    year,
    movie_name,
    worldwide_gross_income,
    movie_rank
FROM RankedMovies
WHERE movie_rank <= 5
ORDER BY genre, year, movie_rank; 

-- Finally, letâ€™s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
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

SELECT
        m.movie_id,
        m.production_company,
        m.rating,
        CASE
            WHEN POSITION(',' IN m.languages) > 0 THEN 'Multilingual'
            ELSE 'Single Language'
        END AS language_type
    FROM movies m
    WHERE POSITION(',' IN m.languages) > 0 -- Ensures the movie is multilingual
),
SELECT
        m.movie_id,
        m.production_company,
        m.rating,
        -- Using ROW_NUMBER() and COUNT() to calculate the median rating
        ROW_NUMBER() OVER (PARTITION BY m.production_company ORDER BY m.rating) AS row_num,
        COUNT(*) OVER (PARTITION BY m.production_company) AS total_count
    FROM MultilingualMovies m
),
SELECT
        production_company,
        rating
    FROM MovieRatings
    WHERE (row_num = (total_count + 1) / 2 AND rating >= 8) -- Median calculation
       OR (total_count % 2 = 0 AND row_num IN (total_count / 2, total_count / 2 + 1) AND rating >= 8) -- Median for even number of rows
),
HitCounts AS (
    SELECT
        production_company,
        COUNT(*) AS movie_count
    FROM Hits
    GROUP BY production_company
),
Rank production houses based on the number of hits
RankedProductionHouses AS (
    SELECT
        production_company,
        movie_count,
        RANK() OVER (ORDER BY movie_count DESC) AS prod_comp_rank
    FROM HitCounts
)
SELECT
    production_company,
    movie_count,
    prod_comp_rank
FROM RankedProductionHouses
WHERE prod_comp_rank <= 2
ORDER BY prod_comp_rank;


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

WITH SuperHitDramaMovies AS (
    SELECT
        m.movie_id,
        m.title,
        m.rating,
        m.actress_name,
        m.total_votes
    FROM movies m
    WHERE m.genre = 'Drama'
      AND m.rating > 8
),
ActressHitCounts AS (
    SELECT
        s.actress_name,
        COUNT(*) AS movie_count,
        SUM(s.total_votes) AS total_votes,
        AVG(s.rating) AS actress_avg_rating
    FROM SuperHitDramaMovies s
    GROUP BY s.actress_name
),
RankedActresses AS (
    SELECT
        actress_name,
        total_votes,
        movie_count,
        actress_avg_rating,
        RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
    FROM ActressHitCounts
)
SELECT
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    actress_rank
FROM RankedActresses
WHERE actress_rank <= 3
ORDER BY actress_rank;

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

WITH DirectorStats AS (
    SELECT
        d.director_id,
        d.director_name,
        COUNT(m.movie_id) AS number_of_movies,
        AVG(m.rating) AS avg_rating,
        SUM(m.total_votes) AS total_votes,
        MIN(m.rating) AS min_rating,
        MAX(m.rating) AS max_rating,
        SUM(m.duration) AS total_duration,
        AVG(DATEDIFF(
            LEAD(m.release_date) OVER (PARTITION BY d.director_id ORDER BY m.release_date),
            m.release_date
        )) AS avg_inter_movie_days
    FROM movies m
    JOIN directors d ON m.director_id = d.director_id
    GROUP BY d.director_id, d.director_name
),
RankedDirectors AS (
    SELECT
        ds.director_id,
        ds.director_name,
        ds.number_of_movies,
        ds.avg_inter_movie_days,
        ds.avg_rating,
        ds.total_votes,
        ds.min_rating,
        ds.max_rating,
        ds.total_duration,
        RANK() OVER (ORDER BY ds.number_of_movies DESC) AS director_rank
    FROM DirectorStats ds
)
SELECT
    director_id,
    director_name,
    number_of_movies,
    ROUND(avg_inter_movie_days, 2) AS avg_inter_movie_days,
    ROUND(avg_rating, 2) AS avg_rating,
    total_votes,
    ROUND(min_rating, 2) AS min_rating,
    ROUND(max_rating, 2) AS max_rating,
    total_duration
FROM RankedDirectors
WHERE director_rank <= 9
ORDER BY director_rank;


























