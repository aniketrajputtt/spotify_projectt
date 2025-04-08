
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


--EDA

 SELECT *
 FROM spotify ;
 
 SELECT 
 COUNT(*)
 FROM SPOTIFY;

 SELECT COUNT(*)
 FROM spotify ;

 SELECT count(distinct album)
 FROM spotify ;

 SELECT count(distinct artist)
 FROM spotify ;

 SELECT DISTINCT album_type
 FROM duration_min ;

 SELECT MAX(duration_min),
		MIN(duration_min)
 FROM spotif

SELECT artist,track,MAX(VIEWS)
FROM spotify
;

 SELECT *
 FROM spotify
 WHERE duration_min = 0
	;

 DELETE 
 FROM spotify
 WHERE duration_min = 0
 ;

 SELECT *
 FROM spotify
 WHERE duration_min = 0
 ;

 SELECT DISTINCT most_played_on
 FROM spotify ;
 

-- --------------------------------
-- DATA ANALYSIS - EASY CATEGORY
-- --------------------------------

-- Q1 RETRIVE THE NAME OF ALL TRACKS THAT HAVE MORE THAN 1 BILLION STREAMS

 SELECT *
 FROM spotify
 WHERE stream > 1000000000
 ; 

 --Q2 LIST ALL THE ALBUMS ALONG WITH THEIR RESPECTIVE ARTISTS
 
 SELECT DISTINCT album,
		artist
 FROM spotify
 ORDER BY 1 ;

 --Q3 GET THE TOTAL NUM OF COMMENTS FOR TRACK WHERE LINCENSED =TRUE

 SELECT sum(comments)
 FROM spotify
 WHERE licensed = 'true'
  ;

 -- Q4 FIND ALL TRACK THAT BELONG TO THE ALBUM TYPE SINGLE .

 SELECT *
 FROM spotify
 WHERE album_type ='single'
 ;

 -- Q5 FIND THE TOTAL NUMBER OF TRACKS BY EACH ARTIST

 SELECT artist,
 COUNT(*) AS total_num_songs
 FROM spotify
 GROUP BY 1
 ORDER BY 2 DESC
 ;

 



-- Calculate the average danceability of tracks in each album.

-- Find the top 5 tracks with the highest energy values.

-- List all tracks along with their views and likes where official_video = TRUE.

-- For each album, calculate the total views of all associated tracks.

-- Retrieve the track names that have been streamed on Spotify more than YouTube.


--Q6 Calculate the average danceability of tracks in each album.

 SELECT album,
 AVG(danceability) AS avg_danceability
 FROM spotify
 GROUP BY 1 
 ORDER BY 2 DESC ;

--	Q7 Find the top 5 tracks with the highest energy values.
 
 SELECT track,MAX(energy) 
 from spotify
 GROUP BY 1
 ORDER BY 2 DESC
 LIMIT 5;

--Q8 List all tracks along with their views and likes where official_video = TRUE.

 SELECT track,
		SUM(views) AS total_views,
 		SUM(likes) AS total_likes
 FROM spotify
 WHERE official_video = 'true'
 GROUP BY 1
 ORDER BY 2 DESC ;

 --Q9  For each album, calculate the total views of all associated tracks.

 SELECT album,
 track,
 SUM(views) AS total_views 
 FROM spotify
 GROUP BY album,2
 ORDER BY 3 DESC ;

 --Q10 Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM
  (SELECT 
  		 track,
  -- most played on
        COALESCE(SUM(CASE WHEN  most_played_on ='youtube' THEN stream END),0) AS streamed_on_youtube ,
        COALESCE(SUM(CASE WHEN  most_played_on ='spotify' THEN stream END),0) AS streamed_on_spotify
  FROM spotify
  GROUP BY 1) AS T1
  WHERE streamed_on_spotify > streamed_on_youtube
  AND streamed_on_youtube <> 0
   ;

SELECT * FROM
  (SELECT 
        track,
        COALESCE(SUM(CASE WHEN LOWER(TRIM(most_played_on)) = 'youtube' THEN COALESCE(stream, 0) END), 0) AS streamed_on_youtube,
        COALESCE(SUM(CASE WHEN LOWER(TRIM(most_played_on)) = 'spotify' THEN COALESCE(stream, 0) END), 0) AS streamed_on_spotify
   FROM spotify
   GROUP BY track) AS T1
WHERE streamed_on_spotify > streamed_on_youtube
AND streamed_on_youtube <> 0;



-- Find the top 3 most-viewed tracks for each artist using window functions.

--Write a query to find tracks where the liveness score is above the average.

--Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

--Find tracks where the energy-to-liveness ratio is greater than 1.2.

--Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

--Q11 Find the top 3 most-viewed tracks for each artist usi ng window functions.

WITH ranking_views
AS
(
SELECT artist,
       track,
      SUM(views) AS total_views ,
	  DENSE_RANK()OVER(PARTITION BY artist ORDER BY SUM(views)DESC) AS rank 
FROM spotify
GROUP BY artist,track
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_views
WHERE RANK <= 3
;

--Q.12 Write a query to find tracks where the liveness score is above the average.

SELECT * 
FROM spotify 
WHERE liveness >(SELECT AVG(liveness) FROM spotify)
;

SELECT AVG(liveness) FROM spotify ;


--Q.13 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH cte
AS(
 	SELECT track,
 		 album,
		 MAX(energy) AS highest_energy,
		 MIN(energy)AS lowest_energy
	FROM spotify
	GROUP BY 1,2
)
SELECT album,
	   track,
	   highest_energy - lowest_energy as energy_diff
FROM cte
ORDER BY 3 DESC ;

-- Q.14 Find tracks where the energy-to-liveness ratio is greater than 1.2.


	SELECT track
	FROM spotify
   WHERE liveness IS NOT NULL
     AND liveness != 0
	 AND energy IS NOT NULL
	  AND (energy / liveness) > (
    SELECT AVG(energy / liveness)
    FROM spotify
    WHERE liveness IS NOT NULL AND liveness != 0 AND energy IS NOT NULL
  );
 -- ANOTHER WAY TO SLOVE THIS
 
 WITH ratio_data AS (
  SELECT track, energy, liveness
  FROM spotify
  WHERE liveness IS NOT NULL AND liveness != 0 AND energy IS NOT NULL
)
SELECT track
FROM ratio_data
WHERE energy / liveness > 1.2;

   

		   
