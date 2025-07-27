-- do a sanity check of the entire episode data
select *
from got_episodes 

-- see who are the writers for each episode and how often they appear as writers
select writer, count(*) as episode_count
from (select writer_1 as writer from got_episodes ge 
	  union all
      select writer_2 as writer from got_episodes ge) as all_writers
group by all_writers.writer
order by episode_count desc

-- select the top 10 episode with the most votes
select *
from (
	select season, episode, title, release_date, votes
	from got_episodes 
	order by votes desc
	limit 10
	) as ten_most_voted_episodes 
-- most of the episodes with the most votes are episodes with the most battle sequences 

-- order the most voted episodes by the latest release date
select *
from (
	select season, episode, title, release_date, votes
	from got_episodes 
	order by votes desc
	limit 10
	) as ten_most_voted_episodes 
order by release_date desc
-- episodes with the most votes are all from season 8, possibly because GOT has attained a large following and popularity then. Only 2 episoded with the most votes are from earlier seasons (season 3 and 5)

-- is there a correlation between votes, and duration? since most of these episodes have battle sequence, they might be longer
select title, us_viewers, ge.duration , votes
from got_data gd 
join got_episodes ge
on gd.episode_name = ge.title 
order by votes desc
limit 10
-- the 10 episodes with the most votes have a duration of > 51 minutes. The longest is almost 1 hour and half in duration. 

-- which episodes have the most us viewers?
select episode_name, us_viewers_millions
from got_data gd 
order by us_viewers_millions desc 
limit 10

-- is number of viewers related to the number of deaths per episode?
-- check the 10 episodes with the most death count
select episode_name, us_viewers_millions, notable_death_count 
from got_data 
order by got_data.notable_death_count desc
limit 10;
-- notable death count does not seem to have any correlation with viewer count 

-- check the connection between notable death count and the release date of the episodes
select gd.episode_name, gd.air_date, gd.season, gd.notable_death_count 
from got_data gd 
order by notable_death_count desc 
limit 10;

select episode_name, air_date, notable_death_count 
from ( 
	select 
		gd.episode_name, 
		gd.air_date, 
		gd.season, 
		gd.notable_death_count 
	from 
		got_data gd 
	order by 
		notable_death_count desc 
	limit 10
) as episodes_with_most_deaths 
order by air_date desc; 

select 
	deaths_per_season.season, 
	deaths_per_season.total_deaths, 
	viewers_per_season.total_us_viewers
from (
	select 
		season, 
		sum(notable_death_count) as total_deaths
	from 
		got_data gd 
	group by 
		season 
) as deaths_per_season  
join (
	select 
		season, 
		sum(us_viewers_millions) as total_us_viewers 
	from 
		got_data gd 
	group by 
		season 
) as viewers_per_season  
on 
	deaths_per_season.season = viewers_per_season.season
order by 
	deaths_per_season.total_deaths desc 
-- Season 6 has the highest number of character death count and the highest US viewers. $

-- check the average rating for the top 10 most rated episodes 
select avg(rating) AS avg_rating_top_10_eps
from (
    select rating
    from got_episodes
    ORDER by rating desc 
    limit 10
) as top_10_eps_per_rating;

-- check the differences between viewer critics and professional critics 
select season, gr.number_in_season, title, gr.imdb_rating, gr.rotten_tomatoes_rating, gr.metacritic_rating 
from got_ratings gr 
order by gr.rotten_tomatoes_rating desc;
-- The top 10 most rated episodes in rotten tomatoes are 'The Rains of Castamere,' 'Mhysa,' 'The Lion and the Rose,' 'Cripples, Bastards, and Broken Things,' etc. 

-- find episodes with perfect ratings on rotten tomatoes
select season, number_in_season, title, rotten_tomatoes_rating 
from got_ratings 
where rotten_tomatoes_rating >= 100;

select count(title) number_of_episodes_with_100_score_in_rotten_tomatoes
from got_ratings gr 
where rotten_tomatoes_rating >= 100;
-- 21 episodes have a score of 100 in Rotten Tomatoes 

-- check metacritics ratings
select season, number_in_season, title, gr.metacritic_rating 
from got_ratings gr 
where gr.metacritic_rating >= 9

select count(title) number_of_episodes_with_score_over_9_in_metacritic
from got_ratings
where metacritic_rating >= 9;

-- check imdb ratings
select season, number_in_season, title, imdb_rating
from got_ratings 
where imdb_rating >= 9; 

select count(title) number_of_episodes_with_score_over_9_in_imdb
from got_ratings
where imdb_rating  >= 9;
-- 29 episodes with imdb rating over 9 

-- check high rating episodes over all rating platforms 
select 
	season, 
	number_in_season, 
	title
from 
	got_ratings 
where 
	imdb_rating >= 9 and 
	metacritic_rating >= 9 and 
	rotten_tomatoes_rating >= 9;  

select 
	season, 
	number_in_season, 
	title
from 
	got_ratings 
where 
	imdb_rating >= 9.5 and 
	metacritic_rating >= 9.5 and 
	rotten_tomatoes_rating >= 9.5;  
-- most of the highest rating episodes are the episodes leading to the season finale. 
-- These "preludes" to the season finale may have less viewers than the finale itself, but they have better reviews from professional critics due to better storyline, direction, in contrast to just viewership momentum.


