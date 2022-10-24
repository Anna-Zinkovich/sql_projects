/* Movielens dataset overview

The “movielens dataset” project was created during ”Data Analyst” bootcamp by SPICED Academy:
https://www.spiced-academy.com/en/program/data-analytics?utm_source=GoogleAds&utm_medium=cpc&utm_id=16017941010&utm_term=132148996025&gclid=CjwKCAjwwo-WBhAMEiwAV4dybVyeN_x1nQD8Apo8arLEr6aq4KyTYSqrhioFALGk404HxQxsA5TcKBoCueEQAvD_BwE

In this project I as a Data Analyst was challenged to answer multiple questions that’ll give a detailed overview of the dataset and maybe even help future readers to pick a movie to watch☺.

STACK: Google Cloud | PostgreSQL | pgAdmin

Originally, there were 4 .csv files: 
Links
Movies
Ratings
Tags

Using Google Cloud and Postgres, I created a “movielens” database. Then I created 4 tables in it and populated them with data from the above-mentioned .cvs files chossing the appropriate data types for each column. Since all the tables had a common column “movieid”, I made it a primary key, and setup relationship between tables with “Movies” being the parent and other tables its children. After the setup was complete, I moved to pgAdmin where I used basic and advanced SQL queries to manipulate the data and get the answers to questions that’ll be covered further. */
  
  
-- Display the total count of different genres combinations in the movies table.
SELECT genres, COUNT(genres) as total_genres_combinations 
FROM movies 
GROUP BY 1 
ORDER BY 2 DESC;

-- Display 5 movies with the lowest movieids.
SELECT * 
FROM movies 
ORDER BY movieId 
LIMIT 5;

-- Display first 10 pure Drama movies. Only Drama is in the genre column.
SELECT * 
FROM movies 
WHERE genres LIKE "Drama"
LIMIT 10;

-- Find out which movie title is the first without a tag.
SELECT movies.title, tags.tag 
FROM movies
FULL JOIN tags USING (movieid)
WHERE tags.tag IS NULL
ORDER BY movies.title ASC 
LIMIT 1;

-- Display the first 10 movies that were released in 2003.
SELECT * 
FROM movies 
WHERE year = 2003 
LIMIT 10;

-- Display the count of movies in the years 1990-2000.
SELECT year, COUNT(movieId) 
FROM movies 
WHERE year BETWEEN 1990 AND 2000 
GROUP BY year; 

-- Find all movies with a year lower 1910.
SELECT * 
FROM movies 
WHERE year < 1910;

-- Filter out movies from 2003 (display all the movies from all the years except for 2003).
SELECT * 
FROM movies 
WHERE year <> 2003;

-- Count the number of genres per movie.
SELECT movieid, title, COUNT(DISTINCT genre) as genres_count 
FROM genres 
JOIN movies USING (movieid) 
GROUP BY movieid, title 
ORDER BY genres_count DESC;

-- Count the number of movies per genre.
SELECT DISTINCT genre, COUNT(movieid) as movies 
FROM genres 
GROUP BY genre 
ORDER BY movies DESC;

-- Count the number of movies per year.
SELECT year, COUNT(movieid) 
FROM movies 
GROUP BY year;

-- How many Drama movies are there in each year?
SELECT year, COUNT(movieid) as drama_movie_count 
FROM movies 
WHERE genres ILIKE "%drama%" 
GROUP BY year;

-- Display movies with the longest titles.
SELECT movieid, title, MAX(length(title)) as max_title 
FROM movies 
GROUP BY movieid 
ORDER BY max_title DESC;

-- Display Top-10 years that have the highest number of movies.
SELECT year, COUNT(movieid) 
FROM movies 
GROUP BY year 
ORDER BY count DESC
LIMIT 10;

-- Display first 10 pure Comedy movies. Only Comedy is in the genre column.
SELECT * 
FROM movies 
WHERE genres LIKE "Comedy" 
LIMIT 10;

-- Display the last 10 Comedy movies that can also contain other genres.
SELECT * 
FROM movies 
WHERE genres LIKE "%Comedy%" 
ORDER BY movieid DESC 
LIMIT 10;

-- Display all of the movie titles that have the tag ‘fun’.
SELECT movies.title, tags.tag 
FROM movies
JOIN tags USING (movieid)
WHERE tag LIKE '%fun';

-- Create a view that is a table of only movies that contain Comedy as one of it’s genres. Display the first 10 movies in the view.
CREATE VIEW new_movies AS
SELECT *
FROM movies
WHERE genres ILIKE '%Comedy%'; 

-- Display all of the movies that have Comedy genre and rating > 3.5.
SELECT title, AVG(rating) as rating
FROM movies 
JOIN genres USING (movieid)
JOIN ratings USING (movieid)
WHERE (genre ILIKE '%comedy%') AND (rating > 3.5)
GROUP BY title HAVING COUNT(rating) > 30 
ORDER BY AVG(rating) DESC;

-- What is the distribution of ratings?
SELECT DISTINCT rating 
FROM ratings 
ORDER BY rating ASC;

-- Display the first 10 movie titles and their average rating.
SELECT movies.title, AVG(ratings.rating) 
FROM ratings 
JOIN movies USING (movieid)
GROUP BY movies.title
LIMIT 10;

-- What are the Top-10 highest rated movies by average that have at least 50 ratings? 
SELECT movieid, COUNT(movieid), AVG(rating) as avg_rating, movies.title as title 
FROM ratings 
JOIN movies USING(movieid)
GROUP BY movieid, title 
HAVING COUNT (userId) > 50 
ORDER BY 3 DESC 
LIMIT 10;

-- Display the first 10 movie titles and their average rating where the films were rated by at least 100 users.
SELECT movies.movieid, movies.title, AVG(ratings.rating) as avg_rating 
FROM ratings 
JOIN movies USING(movieid)
GROUP BY 1, 2 
HAVING COUNT(ratings.userid) > 100 
ORDER BY 3 ASC LIMIT 10;

-- Display 10 movies with the most ratings. 
SELECT ratings.movieid, COUNT(rating) as movie_rating_count, movies.title as title
FROM ratings 
JOIN movies USING(movieid)
GROUP BY movieid, title 
ORDER BY movie_rating_count DESC 
LIMIT 10;

-- Display all of the Star Wars movies in order of average rating where the film was rated by at least 40 users. 
SELECT movies.title, AVG(ratings.rating) as avg_rating 
FROM movies
JOIN ratings ON ratings.movieid = movies.movieid
WHERE movies.title ILIKE 'star wars%'
GROUP BY movies.movieid 
HAVING COUNT(ratings.userid) > 40 
ORDER BY avg_rating DESC;

-- Display Top-10 users who rated the most movies.
SELECT ratings.movieid, COUNT(rating) as movie_rating_count, movies.title as title
FROM ratings 
JOIN movies USING(movieid)
GROUP BY movieid, title 
ORDER BY movie_rating_count DESC 
LIMIT 10;

-- What are Top-10 users who give the lowest ratings on average?
SELECT userid, AVG(rating) 
FROM ratings 
GROUP BY userid 
HAVING COUNT(rating) > 30 
ORDER BY AVG(rating) ASC;
