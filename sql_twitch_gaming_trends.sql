/*
This project was completed during Codecademy’s Career Path “Learn Data Analysis for your Business”:
https://www.codecademy.com/learn/paths/data-analyst-training-for-your-business-cfb
STACK: SQL
Twitch is the world’s leading live streaming platform for gamers, with 15 million daily active users. Using data to understand its users and products is one of the main responsibilities of the Twitch Data Science Team.
In this project, I worked with two tables that contain Twitch users’ stream viewing data and chat room usage data.
Stream viewing data:
•stream table
Chat usage data:
•chat table
The Twitch Science Team provided this practice dataset (the .csv files with 800,000 rows)
*/

-- To get a feel for the stream and the chat tables, select the first 10 rows from each of the two tables.
SELECT * FROM stream LIMIT 10;
SELECT * FROM chat LIMIT 10;

-- What are the unique games in the stream table?
SELECT DISTINCT(game) FROM stream;

-- What are the unique channels in the stream table?
SELECT DISTINCT(channel) FROM stream;

-- What are the most popular games in the stream table?
SELECT game, COUNT(*) as number_of_viewers
FROM stream
GROUP BY game
ORDER BY number_of_viewers DESC;

-- Where are League of Legends (LoL/lol) stream viewers located?
SELECT country, COUNT(*) as lol_viewers
FROM stream
WHERE game = "League of Legends"
GROUP BY country
ORDER BY 2 DESC 
LIMIT 10;

-- How many viewers are using each of Twitch’s stream sources to watch streams?
SELECT player AS stream_source, COUNT(*) AS viewers_count
FROM stream
GROUP BY player
ORDER BY viewers_count DESC;

-- Create a genre column, group games by their genres and count viewers.
SELECT game,
CASE
WHEN game = 'League of Legends' THEN 'MOBA'
WHEN game = 'Dota 2' THEN 'MOBA'
WHEN game = 'Heroes of the Storm' THEN 'MOBA'
WHEN game = 'Counter-Strike: Global Offensive' THEN 'FPS'
WHEN game = 'DayZ' THEN 'Survival'
WHEN game ='ARK: Survival Evolved' THEN 'Survival'
ELSE 'OTHER'
END AS 'genre', COUNT(*) as viewers_count
FROM stream 
GROUP BY game 
ORDER BY 3 DESC;

-- Write a query that returns the hours of the time column, the view count for each hour and filter the result with only users in your country.
SELECT strftime('%H', time) as hours, COUNT(*)
FROM stream
WHERE country = "DE"
GROUP BY hours;

SELECT strftime('%H', time) as hours, COUNT(*)
FROM stream
WHERE country = "BY"
GROUP BY hours;