USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) from ratings;  -- 7997 rows
select count(*) from movie;  -- 7997 rows
select count(*) from names;  -- 25735 rows
select count(*) from genre;  -- 14662 rows
select count(*) from director_mapping;  -- 3867 rows
select count(*) from role_mapping;  -- 15615 rows

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
select 
	count(*) - count(id)as id_null_count, 
	count(*) - count(title)as title_null_count ,
	count(*) - count(year)as year_null_count ,
	count(*) - count(date_published)as date_published_null_count ,
	count(*) - count(duration)as duration_null_count ,
	count(*) - count(country)as country_null_count ,
	count(*) - count(worlwide_gross_income)as worlwide_gross_income_null_count ,
	count(*) - count(languages)as languages_null_count ,
	count(*) - count(production_company)as production_company_null_count 
from movie;
/* As observed from the results only 4 columns had null values present in them :-
1. country_null_count
2. worlwide_gross_income_null_count
3. languages_null_count
4. production_company_null_count
out of these 4, 'worlwide_gross_income' has the most null values present in it.
*/

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
select Year,count(title) as number_of_movies from movie group by year;
-- Highest number of movies were released in 2017

select month(date_published) as month_num , count(*) as number_of_movies from movie group by month_num
order by number_of_movies desc;
-- March comes out to be the month with the highest number of movies produced. 

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select year, count(*) as Total_movies 
from movie 
where (country like '%INDIA%' or country like '%USA%') and year = 2019 ;
-- 1059 movies were produced in the USA or India in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select distinct genre from genre;
select count(distinct genre) from genre;
-- there are total 13 genres present in the dataset and the Movies belong to those 13 genres in the dataset.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select genre , count(movie_id) as tot_movie 
from genre 
group by genre 
order by tot_movie desc limit 1;
/* 4265 Drama movies were produced in total and are the highest among all genres 
so making a dramatic movie should be the go to option for the production house. */

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
with 1_genre as (
SELECT movie_id FROM   genre GROUP  BY movie_id HAVING Count(DISTINCT genre) = 1)
select count(*) as single_genre from 1_genre;
-- 3289 movies belong to only one genre

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
select genre , avg(duration) as avg_duration
from movie as pic
inner join genre as gen
on gen.movie_id = pic.id
group by genre
order by avg_duration desc;
-- Action genre has the highest duration of 112.88 seconds followed by romance(110 secs) and crime(107 secs) genres.

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

select genre , count(movie_id) as total_movie,
	DENSE_RANK() OVER (order by count(movie_id) desc) as genre_rank
    from genre
    group by genre ;
    -- Thriller has rank=3 and movie count of 1484

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
select 
	min(avg_rating) as min_avg_rating,
	max(avg_rating) as max_avg_rating,
	min(total_votes) as min_total_votes,
	max(total_votes) as max_total_votes,
	min(median_rating) as min_median_rating,
	max(median_rating) as min_median_rating
from ratings;
-- no outliers are present.

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
	
select avg_rating , title , dense_Rank() OVER(ORDER BY avg_rating DESC) AS movie_rank
from movie as pic
inner join ratings as rate
on pic.id = rate.movie_id
order by avg_rating desc limit 10;
-- Top 3 movies have average rating >= 9.8

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

select median_rating, count(movie_id) as movie_count from ratings group by median_rating order by movie_count desc;

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
select production_company, count(movie_id) as movie_count , dense_rank() over(order by count(movie_id) desc) as prod_company_rank
from movie as pic
inner join ratings as rate
on pic.id = rate.movie_id
where avg_rating > 8 and production_company is not null
group by production_company limit 3;
-- Dream Warrior Pictures and National Theatre Live production houses has produced the most number of hit movies (average rating > 8)
-- They have rank=1 and movie count =3 

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
select genre, count(id) as movie_count
from movie as pic
inner join genre as gen
on pic.id = gen.movie_id
inner join ratings as rate
on rate.movie_id = pic.id
where year = 2017
AND Month(date_published) = 3
AND country LIKE '%USA%'
AND total_votes > 1000
group by genre ORDER  BY movie_count DESC; 
-- 24 Drama movies were released during March 2017 in the USA and had more than 1,000 votes
-- Top 3 genres are drama, comedy and action during March 2017 in the USA and had more than 1,000 votes

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

select title, avg_rating, genre
from movie as pic
inner join genre as gen
on gen.movie_id = pic.id
inner join ratings as rate
on   rate.movie_id = pic.id 
where avg_rating > 8
and title like 'The%'
group by title, avg_rating, genre
order by avg_rating desc;
-- There are 8 movies which begin with "The" in their title.
-- The Brighton Miracle has highest average rating of 9.5.
-- All the movies belong to the top 3 genres.

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. no Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
select median_rating, count(id)
from movie as pic
inner join ratings as rate
on rate.movie_id = pic.id
where median_rating =8 and date_published between '2018-04-01' AND '2019-04-01'
group by median_rating;
-- 361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select country, sum(total_votes) as total_votes 
from movie as pic
inner join ratings as rate
on rate.movie_id = pic.id
where country = 'Germany' or country like 'Italy'
group by country;
-- By observation, German movies received the highest number of votes when queried against language and country columns.
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
select count(*) - count(name) as name_nulls,
count(*) - count(height) as height_nulls,
count(*) - count(date_of_birth) as date_of_birth_nulls,
count(*) - count(known_for_movies) as known_for_movies_nulls
from names;

-- or

SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;
-- Height(17335), date_of_birth(13431), known_for_movies(15226) columns contain NULLS

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

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

with top_genre as 
(select genre, count(id) as movie_count, dense_Rank() OVER(ORDER BY Count(id) DESC) AS genre_rank
	from movie as pic
    inner join genre as gen
    on gen.movie_id = pic.id
    inner join ratings as rate
    on rate.movie_id = pic.id
    WHERE avg_rating > 8
	GROUP BY   genre limit 3 )

select name as director_name, count(movie_id) as movie_count
FROM       director_mapping  AS dmap
inner join genre as gen
using (movie_id)
INNER JOIN names AS n
ON n.id = dmap.name_id
INNER JOIN top_genre
using     (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3 ;
-- James Mangold , Anthony russo and Soubin Shahir are top three directors in the top three genres whose movies have an average rating > 8

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select N.name as actor_name, count(movie_id) as movie_count
from role_mapping as rm
inner join movie as pic
on pic.id = rm.movie_id
inner join ratings as rate using(movie_id)
inner join names as n
on n.id = rm.name_id
where rate.median_rating >=8 and category ='ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC; 
-- Top 2 actors are Mammootty and Mohanlal.

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

select 	production_company, 
		sum(total_votes) as vote_count, 
        dense_rank() over(order by sum(total_votes) desc) as prod_comp_rank
from movie as pic
inner join ratings as rate
on rate.movie_id = pic.id
group by production_company
order by prod_comp_rank;

-- Top three production houses are Marvel Studios, Twentieth Century Fox and Warner Bros.

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

with actor_profile as(
select 	n.name as actor_name, 
		sum(rate.total_votes) as total_votes, 
        count(distinct RM.movie_id) as movie_count,
        round(sum(rate.avg_rating * rate.total_votes)/sum(rate.total_votes),2) as actor_avg_rating
from 	role_mapping as RM
		inner join names as n
        on N.id = RM.name_id
        inner join ratings AS rate
		ON rate.movie_id = RM.movie_id
        INNER JOIN movie AS pic
		ON RM.movie_id = pic.id
        where RM.category = 'ACTOR' and country like '%india%'
        group by  RM.name_id, n.name
        having count(distinct RM.movie_id)  >=3 limit 5)
SELECT *,Rank() OVER(ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   actor_profile; 

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
with actress_profile as(
select 	n.name as actress_name, 
		sum(rate.total_votes) as total_votes, 
        count(distinct RM.movie_id) as movie_count,
        round(sum(rate.avg_rating * rate.total_votes)/sum(rate.total_votes),2) as actress_avg_rating
from 	role_mapping as RM
		inner join names as n
        on N.id = RM.name_id
        inner join ratings AS rate
		ON rate.movie_id = RM.movie_id
        INNER JOIN movie AS pic
		ON RM.movie_id = pic.id
        where RM.category = 'ACTRESS' 
        group by  RM.name_id, n.name
        having  count(distinct RM.movie_id)  >= 5 )
	
SELECT *,dense_Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM   actress_profile limit 5;
-- Top five actresses in Hindi movies released in India based on their average ratings are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
select title , avg_rating ,
		case 	when avg_rating > 8 then 'Superhit Movies'
				when avg_rating between 7 and 8 then 'Hit Movies'
                when avg_rating between 5 and 7 then 'One-time-watch movies'
                else 'Flop Movies'
		end as peoples_choice
from movie as pic
inner join ratings as rate
on pic.id = rate.movie_id
inner join genre as gen using(movie_id)
WHERE  genre LIKE 'THRILLER';

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
SELECT genre,
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie AS pic 
INNER JOIN genre AS gen
ON pic.id= gen.movie_id
GROUP BY genre
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

-- Top 3 Genres based on most number of movies
select genre , count(pic.id) as movie_count,
						Rank() OVER(ORDER BY Count(pic.id) DESC) AS genre_rank
                        from movies as pic
                        inner join genre as gen
                        on pic.id = gen.movie_id
                        inner join ratings as rate
                        on rate.movie_id = pic.id
                        where avg_rating > 9
                        group by genre limit 3;
                        
-- now using this quety in a CTE for further analysis

with top_3_genres as(
						select genre , count(pic.id) as movie_count,
						Rank() OVER(ORDER BY Count(pic.id) DESC) AS genre_rank
                        from movie as pic
                        inner join genre as gen
                        on pic.id = gen.movie_id
                        inner join ratings as rate
                        on rate.movie_id = pic.id
                        where avg_rating > 9
                        group by genre limit 3),
movie_profile as(
						select genre, year, title AS movie_name,
                        CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income ,
						DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank
                        from movie as pic
                        inner join genre as gen
                        on pic.id = gen.movie_id
                        where genre in ( select genre from top_3_genres)
                        group by genre,year,movie_name,worlwide_gross_income)
select * from movie_profile where movie_rank <= 5 order by year;

/* # genre, year, movie_name, worlwide_gross_income, movie_rank
'Thriller', '2017', 'The Fate of the Furious', '1236005118', '1' 
The Fate of the Furious was the top most movie having largest worldwide_gross_income*/

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
-- query for Top 2 production house
select production_company, count(id) as movie_count
from movie as pic
inner join ratings as rate
on pic.id = rate.movie_id
where median_rating >= 8 and production_company is not null AND Position(',' IN languages) > 0
group by production_company
order by movie_count desc;

-- using the above query as a CTE
with top_production as (	
select production_company, count(id) as movie_count
from movie as pic
inner join ratings as rate
on pic.id = rate.movie_id
where median_rating >= 8 and production_company is not null AND Position(',' IN languages) > 0
group by production_company
order by movie_count desc)
SELECT *,Rank()over(ORDER BY movie_count DESC) AS prod_comp_rank
FROM   top_production
LIMIT 2; 
-- Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits among multilingual movies.

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
WITH actress_profile AS
(SELECT n.NAME AS actress_name, SUM(total_votes) AS total_votes, Count(rate.movie_id) AS movie_count,
Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM movie AS pic
           INNER JOIN ratings AS rate
           ON pic.id=rate.movie_id
           INNER JOIN role_mapping AS rm
           ON pic.id = rm.movie_id
           INNER JOIN names AS n
           ON rm.name_id = n.id
           INNER JOIN GENRE AS gen
           ON gen.movie_id = pic.id
           WHERE category = 'ACTRESS'
           AND avg_rating>8
           AND genre = "Drama"
           GROUP BY NAME )
SELECT   *,
         DENSE_Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM     actress_profile LIMIT 3;

-- Top 3 actresses based on number of Super Hit movies are Parvathy Thiruvothu, Susan Brown and Amanda Lawrence

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
WITH next_date_published_report AS
(			SELECT    dmap.name_id, NAME,
                      dmap.movie_id, duration,
                      rate.avg_rating,total_votes,
                      pic.date_published,
                      Lead(date_published,1) OVER(partition BY dmap.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM director_mapping AS dmap
           INNER JOIN names AS n
           ON n.id = dmap.name_id
           INNER JOIN movie AS pic
           ON pic.id = dmap.movie_id
           INNER JOIN ratings AS rate
           ON rate.movie_id = pic.id ), 
director_report AS
( SELECT *,Datediff(next_date_published, date_published) AS date_difference FROM next_date_published_report )
SELECT   name_id AS director_id,
         NAME AS director_name,
         Count(movie_id) AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2) AS avg_rating,
         Sum(total_votes) AS total_votes,
         Min(avg_rating)  AS min_rating,
         Max(avg_rating)  AS max_rating,
         Sum(duration) AS total_duration
FROM director_report
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;
-- so here we can see that andrew jones is the the director with max no of movies directed till date .