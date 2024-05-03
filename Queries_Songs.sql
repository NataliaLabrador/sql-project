USE spotify_sql;

SELECT *
FROM song_attributes;

SELECT *
FROM tracks;

SELECT *
FROM artists;

-- QUERIES
-- JOINS
-- Join tracks and song_attributes tables
SELECT *
FROM tracks AS t
INNER JOIN song_attributes AS sa
ON t.track_id = sa.id;

-- Join artists and song_attributes tables
SELECT *
FROM artists AS a
INNER JOIN song_attributes AS sa
ON a.artist_id = sa.id;



-- RELEASED YEAR
-- Most ancient song
SELECT track_name,
released_year
FROM tracks
WHERE released_year = (SELECT MIN(released_year) FROM tracks);
-- The most ancient song is White Christmas from 1942

-- Songs released in 2020
SELECT COUNT(DISTINCT track_name)
FROM tracks
WHERE released_year = 2020;
-- There were 24 songs released in 2020

-- Songs released between 2021 and 2023
SELECT COUNT(DISTINCT track_name)
FROM tracks
WHERE released_year BETWEEN 2021 AND 2023;
-- There were 265 songs released between 2021 and 2023

-- Number of songs for the last 3 years
SELECT released_year,
COUNT(DISTINCT track_name) AS num_songs
FROM tracks
GROUP BY released_year
HAVING released_year > 2020
ORDER BY num_songs DESC;
-- There were 157 songs released in 2022, 91 songs in 2021 and 18 songs in 2023



-- STREAMS
-- Song with more streams
SELECT track_name
FROM tracks
WHERE streams = (SELECT MAX(streams) FROM tracks);

-- Song with more streams in 2022
SELECT track_name
FROM tracks
WHERE streams = (SELECT MAX(streams) FROM tracks WHERE released_year = 2022)
AND released_year = 2022;
-- The most listened song in 2022 was Anti-Hero.


-- Song with more streams in 2021
SELECT track_name
FROM tracks
WHERE streams = (SELECT MAX(streams) FROM tracks WHERE released_year = 2021)
AND released_year = 2021;
-- -- The most listened song in 2022 was Where Are You Now.


-- Minimum streams
SELECT MIN(streams)
FROM tracks;

-- Create a new column with songs success
SELECT track_name,
CASE
	WHEN streams < 500000000 THEN "Popularidad Baja"
    WHEN streams BETWEEN 500000000 AND 1000000000 THEN "Popularidad Media"
    ELSE "Popularidad Alta"
    END AS songs_success
FROM tracks;

-- Number of songs for each success category
SELECT songs_success, COUNT(*) AS number_songs_per_catgory
FROM (
    SELECT track_name,
    CASE
        WHEN streams < 500000000 THEN "Popularidad Baja"
        WHEN streams BETWEEN 500000000 AND 1000000000 THEN "Popularidad Media"
        ELSE "Popularidad Alta"
        END AS songs_success
    FROM tracks
) AS categories
GROUP BY songs_success;

-- Get songs from 2023 where streams are more than 1000000000
-- 1. Songs with more than 1000000000 streams
SELECT track_name
FROM tracks
WHERE streams > 1000000000;

-- 2. Get songs from 2023
SELECT track_name
FROM tracks
WHERE released_year = 2023;

-- Get songs from 2023 where streams are more than 1000000000
SELECT track_name
FROM tracks
WHERE released_year = 2023
AND track_name IN (
    SELECT track_name
    FROM tracks
    WHERE streams > 1000000000
);
-- Flowers was the only song from 2023 with more than 1000000000 streams.

-- Get number of songs from 2023 where streams are more than 1000000000
SELECT COUNT(track_name)
FROM tracks
WHERE released_year = 2023
AND track_name IN (
    SELECT track_name
    FROM tracks
    WHERE streams > 1000000000
);
-- There was only 1 song in 2023 that had more than 1000000000 streams.


-- Get number of songs from 2022 where streams are more than 1000000000
SELECT COUNT(track_name)
FROM tracks
WHERE released_year = 2022
AND track_name IN (
    SELECT track_name
    FROM tracks
    WHERE streams > 1000000000
);
-- There were 12 songs in 2022 that had more than 1000000000 streams.

-- Get number of songs from 2021 where streams are more than 1000000000
SELECT COUNT(track_name)
FROM tracks
WHERE released_year = 2021
AND track_name IN (
    SELECT track_name
    FROM tracks
    WHERE streams > 1000000000
);
-- There were 22 songs in 2021 that had more than 1000000000 streams.

-- Get number of songs from 2020 where streams are more than 1000000000
SELECT COUNT(track_name)
FROM tracks
WHERE released_year = 2020
AND track_name IN (
    SELECT track_name
    FROM tracks
    WHERE streams > 1000000000
);
-- There were 15 songs in 2020 that had more than 1000000000 streams.


-- DURATION
-- Shortest song
SELECT track_name
FROM tracks
WHERE duration = (SELECT MIN(duration) FROM tracks);

-- Longest song
SELECT track_name
FROM tracks
WHERE duration = (SELECT MAX(duration) FROM tracks);
-- The longest song is All Too Well.


-- Average songs duration
SELECT AVG(duration)
FROM tracks;
-- The average duration of songs is 209.18 seconds.


-- Songs below average duration
SELECT COUNT(track_name)
FROM tracks
WHERE duration < (
SELECT AVG(duration)
FROM tracks);
-- There are 275 songs whose duration is below the average.

-- Songs above average duration
SELECT COUNT(track_name)
FROM tracks
WHERE duration > (
SELECT AVG(duration)
FROM tracks);
-- There are 220 songs whose duration is above the average.

-- Songs where duration is between 150 and 200 seconds
SELECT track_name
FROM tracks
WHERE duration BETWEEN 150 AND 200;



-- ALBUM
-- Most repeated album
SELECT album, COUNT(*) AS most_repeated_album
FROM tracks
GROUP BY album
ORDER BY COUNT(*) DESC
LIMIT 1;
-- The most repeated album is Un Verano Sin Ti

-- Songs from the album Un Verano Sin Ti
SELECT *
FROM tracks
WHERE album IN ('Un Verano Sin Ti');



-- ARTISTS
-- Most repeated artist
SELECT artist_name, 
COUNT(*) AS number_of_repeats
FROM artists
GROUP BY artist_name
ORDER BY number_of_repeats DESC
LIMIT 1;
-- The most repeated artist is Bad Bunny.


-- Artists starting with the "The"
SELECT *
FROM artists
WHERE artist_name LIKE 'The%';




-- GENRE
-- Count number of genres
SELECT COUNT(DISTINCT genre)
FROM artists;
-- There are 165 different genres.

-- Most repeated genre
SELECT genre, COUNT(*) AS most_repeated_genre
FROM artists
GROUP BY genre
ORDER BY COUNT(*) DESC
LIMIT 3;
-- The most repeated genres are pop and reggaeton.


-- SONGS ATTRIBUTES
-- Create a new column with danceability categories
SELECT sa.id,
track_name,
CASE
	WHEN danceability < 30 THEN "Bajo"
    WHEN danceability BETWEEN 30 AND 60 THEN "Medio"
    ELSE "Alto"
    END AS danceability_categories
FROM song_attributes AS sa
INNER JOIN tracks AS t
ON sa.id = t.track_id;

-- Create a new column with energy categories
SELECT sa.id,
t.track_name,
CASE
	WHEN sa.energy < 30 THEN "Bajo"
	WHEN sa.energy BETWEEN 30 AND 60 THEN "Medio"
	ELSE "Alto"
	END AS energy_categories
FROM song_attributes AS sa
INNER JOIN tracks AS t
ON sa.id = t.track_id;



-- Get the song with the highest energy attribute
SELECT t.track_name,
sa.energy
FROM song_attributes AS sa
INNER JOIN tracks AS t
ON sa.id = t.track_id
WHERE sa.energy = (SELECT MAX(energy) 
FROM song_attributes);
-- The song with the highest energy attribute is Money Trees

-- Get the song with the highest danceability attribute
SELECT t.track_name,
sa.danceability
FROM song_attributes AS sa
INNER JOIN tracks AS t
ON sa.id = t.track_id
WHERE sa.danceability = (SELECT MAX(danceability) 
FROM song_attributes);
-- The song with the highest danceability attibute is The Real Slim Shady.


-- Get the song with the highest bpm attribute
SELECT t.track_name,
sa.bpm
FROM song_attributes AS sa
INNER JOIN tracks AS t
ON sa.id = t.track_id
WHERE sa.bpm = (SELECT MAX(bpm) 
FROM song_attributes);
-- The song with the highest bpm attribute is MIDDLE OF THE NIGHT.

-- Get the average danceability index
SELECT AVG(danceability)
FROM song_attributes;
-- The average danceability index of songs is 65.86.


-- Songs above average danceability index
SELECT COUNT(t.track_name)
FROM tracks AS t
JOIN song_attributes AS sa 
ON sa.id = t.track_id
WHERE danceability < (
    SELECT AVG(danceability)
    FROM song_attributes
);
-- There are 225 songs whose danceability index is above the average.

-- Get the average energy index
SELECT AVG(energy)
FROM song_attributes;
-- The average danceability index of songs is 65.86.


-- Songs above average energy index
SELECT COUNT(t.track_name)
FROM tracks AS t
JOIN song_attributes AS sa 
ON sa.id = t.track_id
WHERE energy < (
    SELECT AVG(energy)
    FROM song_attributes
);
-- There are 235 songs whose energy index is above the average.



