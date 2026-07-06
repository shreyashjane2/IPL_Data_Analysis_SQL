create database IPL_Analysis;

use IPL_Analysis;

select * from deliveries;

select * from matches;

-- Finding Null Values
select * from matches
where winner is null;

-- Removing Duplicates
select id, count(*) from matches
group by id
having count(*) > 1;

-- Total No. of Matches
select count(*) as total_matches from matches;

-- IPL Winners by Season
select season, winner from matches;

-- Most Match Wins
select winner, count(*) as wins
from matches
group by winner
order by wins desc;

-- Top Run Scorers
select top 10 batsman,
       sum(batsman_runs) as total_runs
from deliveries
group by batsman
order by total_runs desc;

-- Most Wickets
select bowler,
       count(player_dismissed) as wickets
from deliveries
where player_dismissed is not null
group by bowler
order by wickets desc;

-- Team with Highest Total
select batting_team,
       sum(total_runs) as runs
from deliveries
group by batting_team
order by runs desc;

-- Orange Cap per Season
select season, batsman, total_runs
from (
    select m.season,
           d.batsman,
           sum(d.batsman_runs) as total_runs,
           row_number() over(
             partition by m.season
             order by sum(d.batsman_runs) desc
           ) as rn
    from deliveries d
    join matches m
      on d.match_id = m.id
    group by m.season, d.batsman
) s
where rn = 1;

-- Toss Win Impact
select toss_winner,
       count(*) as wins
from matches
where toss_winner = winner
group by toss_winner;

-- Total Teams
select count(distinct team) as total_teams
from
(
    select team1 as team from matches
    union
    select team2 from matches
) t;

-- Total Players
select count(distinct batsman) as total_players
from deliveries;

-- Total Venues
select count(distinct venue) as venues
from matches;

--STEP 2: Data Cleaning

select * from matches
where winner is null;

--Add:

--Missing Player of Match
select *
from matches
where player_of_match is null;

--Duplicate Deliveries
select match_id,
       inning,
       over,
       ball,
       count(*)
from deliveries
group by
match_id,
inning,
over,
ball
having count(*) > 1;


--STEP 3: Basic Analysis

--Most Successful Teams
select winner,
       count(*) wins
from matches
group by winner
order by wins desc;

--Most Player of Match Awards
select player_of_match,
       count(*) awards
from matches
group by player_of_match
order by awards desc;

--Highest Team Score
select top 10
match_id,
inning,
batting_team,
sum(total_runs) score
from deliveries
group by
match_id,
inning,
batting_team
order by score desc;


--STEP 4: Batting Analysis
--Orange Cap Overall
select top 10
batsman,
sum(batsman_runs) runs
from deliveries
group by batsman
order by runs desc;

--Most Sixes
select top 10
batsman,
count(*) sixes
from deliveries
where batsman_runs = 6
group by batsman
order by sixes desc;

-- Most Fours
select top 10
batsman,
count(*) fours
from deliveries
where batsman_runs = 4
group by batsman
order by fours desc;
Best Strike Rate

-- Only players with 1000+ balls

select top 10
batsman,
round(
sum(batsman_runs)*100.0/count(*),
2
) strike_rate
from deliveries
group by batsman
having count(*) >= 1000
order by strike_rate desc;


-- STEP 5: Bowling Analysis
-- Purple Cap Overall
select top 10
bowler,
count(player_dismissed) wickets
from deliveries
where dismissal_kind not in ('run out')
group by bowler
order by wickets desc;

-- Most Dot Balls
select top 10
bowler,
count(*) dot_balls
from deliveries
where total_runs = 0
group by bowler
order by dot_balls desc;

-- Best Economy
select top 10
bowler,
round(
sum(total_runs)*6.0/count(*),
2
) economy
from deliveries
group by bowler
having count(*) >= 500
order by economy;


-- STEP 6: Venue Analysis
-- Highest Scoring Venues
select top 10
m.venue,
avg(score) avg_score
from
(
    select match_id,
           inning,
           sum(total_runs) score
    from deliveries
    group by match_id, inning
) d
join matches m
on d.match_id = m.id
group by venue
order by avg_score desc;

-- Venues Hosting Most Matches
select venue,
       count(*) matches
from matches
group by venue
order by matches desc;


-- STEP 7: Toss Analysis
-- Toss Impact

select toss_winner,
       count(*) wins
from matches
where toss_winner = winner
group by toss_winner;

-- Improving it:

select
count(*)*100.0/
(select count(*) from matches)
as toss_win_percentage
from matches
where toss_winner = winner;


-- STEP 8: Head-to-Head
-- CSK vs MI
select winner,
       count(*) wins
from matches
where
(team1='Chennai Super Kings'
and team2='Mumbai Indians')
or
(team1='Mumbai Indians'
and team2='Chennai Super Kings')
group by winner;

-- STEP 9: Window Functions
-- Orange Cap Per Season.

Add:

Purple Cap Per Season
select season,
       bowler,
       wickets
from
(
    select
    m.season,
    d.bowler,
    count(player_dismissed) wickets,

    dense_rank() over(
    partition by season
    order by count(player_dismissed) desc
    ) rnk

    from deliveries d
    join matches m
    on d.match_id=m.id

    where dismissal_kind not in ('run out')

    group by
    season,
    bowler
)t
where rnk=1;
Top Team Each Season
select *
from
(
select
season,
winner,
count(*) wins,

dense_rank() over(
partition by season
order by count(*) desc
) rnk

from matches
where winner is not null

group by
season,
winner
)t
where rnk=1;





STEP 10: CTEs
Top 5 Run Scorers
with Runs AS
(
select batsman,
       sum(batsman_runs) total_runs
from deliveries
group by batsman
)

select top 5 *
from Runs
order by total_runs desc;



STEP 11: Views

Create reusable views.

Orange Cap View
create view OrangeCap as
select batsman,
       sum(batsman_runs) runs
from deliveries
group by batsman;
Purple Cap View
create view PurpleCap as
select bowler,
       count(player_dismissed) wickets
from deliveries
where dismissal_kind not in ('run out')
group by bowler;



STEP 12: Stored Procedures
Player Stats
create procedure GetPlayerRuns
@Player varchar(100)
as
begin
select
batsman,
sum(batsman_runs) runs
from deliveries
where batsman=@Player
group by batsman;

end;

Execute:
exec GetPlayerRuns 'V Kohli';




--Powerplay Analysis (Overs 1–6)

Teams with Highest Powerplay Run Rate

SQL
select batting_team,
       round(sum(total_runs) * 1.0 / count(distinct match_id, inning), 2) as avgpowerplayruns
from deliveries
where over between 1 and 6
group by batting_team
order by avgpowerplayruns desc;
Batsmen with Most Powerplay Runs

SQL
select top 10 batsman,
       sum(batsman_runs) as powerplayruns
from deliveries
where over between 1 and 6
group by batsman
order by powerplayruns desc;
Death Overs Analysis (Overs 16–20)

Most Runs in Death Overs

SQL
select top 10 batsman,
       sum(batsman_runs) as deathruns
from deliveries
where over between 16 and 20
group by batsman
order by deathruns desc;
Best Death Bowlers (Economy)

SQL
select top 10 bowler,
       round(sum(total_runs) * 6.0 / count(*), 2) as economy
from deliveries
where over between 16 and 20
group by bowler
having count(*) >= 120
order by economy;
Chase Analysis

Teams Winning While Chasing

SQL
select winner,
       count(*) as chasewins
from matches
where win_by_wickets > 0
group by winner
order by chasewins desc;
Teams Defending Successfully

SQL
select winner,
       count(*) as defendedwins
from matches
where win_by_runs > 0
group by winner
order by defendedwins desc;
Boundary Analysis

Players with Most Boundaries

SQL
select top 10 batsman,
       count(*) as boundaries
from deliveries
where batsman_runs in (4,6)
group by batsman
order by boundaries desc;
Boundary Percentage of Players

SQL
select top 10 batsman,
       round(
           count(case when batsman_runs in (4,6) then 1 end) * 100.0 /
           count(*), 2
       ) as boundarypercentage
from deliveries
group by batsman
having count(*) >= 500
order by boundarypercentage desc;
Batting Consistency

Most 50+ Scores

SQL
select top 10 batsman,
       count(*) as fiftyplusscores
from (
    select match_id,
           batsman,
           sum(batsman_runs) as runs
    from deliveries
    group by match_id, batsman
    having sum(batsman_runs) >= 50
) t
group by batsman
order by fiftyplusscores desc;
Most Centuries

SQL
select batsman,
       count(*) as centuries
from (
    select match_id,
           batsman,
           sum(batsman_runs) as runs
    from deliveries
    group by match_id, batsman
    having sum(batsman_runs) >= 100
) t
group by batsman
order by centuries desc;
Bowling Insights

Bowlers with Most 3-Wicket Hauls

SQL
select bowler,
       count(*) as threewickethauls
from (
    select match_id,
           bowler,
           count(player_dismissed) as wickets
    from deliveries
    where dismissal_kind <> 'run out'
    group by match_id, bowler
    having count(player_dismissed) >= 3
) t
group by bowler
order by threewickethauls desc;
Bowlers with Most Maidens

SQL
select bowler,
       count(*) as maidenovers
from (
    select match_id,
           inning,
           over,
           bowler,
           sum(total_runs) as runsconceded
    from deliveries
    group by match_id, inning, over, bowler
    having sum(total_runs) = 0
) t
group by bowler
order by maidenovers desc;
Match Excitement Analysis

Closest Matches by Runs

SQL
select top 10 id,
       team1,
       team2,
       win_by_runs
from matches
where win_by_runs > 0
order by win_by_runs;
Closest Matches by Wickets

SQL
select top 10 id,
       team1,
       team2,
       win_by_wickets
from matches
where win_by_wickets > 0
order by win_by_wickets;
Team Dependency Analysis

Which Player Scores Highest % of Team Runs?

SQL
select top 10 batsman,
       round(
           sum(batsman_runs) * 100.0 /
           sum(total_runs), 2
       ) as contributionpercent
from deliveries
group by batsman
order by contributionpercent desc;
Venue Intelligence

Venue Favoring Chasing

SQL
select venue,
       count(*) as chasewins
from matches
where win_by_wickets > 0
group by venue
order by chasewins desc;
Venue Favoring Defending

SQL
select venue,
       count(*) as defendwins
from matches
where win_by_runs > 0
group by venue
order by defendwins desc;
Rivalry Analysis

Highest Scoring Rivalries

SQL
select top 10
       m.team1,
       m.team2,
       sum(d.total_runs) as runs
from matches m
join deliveries d
on m.id = d.match_id
group by m.team1, m.team2
order by runs desc;
Most Frequently Played Rivalries

SQL
select team1,
       team2,
       count(*) as matchesplayed
from matches
group by team1, team2
order by matchesplayed desc;
Pressure Situations

Players Winning Most Player of Match Awards in Finals

SQL
select player_of_match,
       count(*) as finalawards
from matches
where match_type = 'final'
group by player_of_match
order by finalawards desc;
Teams with Best Final Record

SQL
select winner,
       count(*) as finalwins
from matches
where match_type = 'final'
group by winner
order by finalwins desc;
Extra Runs Analysis

Teams Benefiting Most from Extras

SQL
select batting_team,
       sum(extra_runs) as extras
from deliveries
group by batting_team
order by extras desc;
Bowlers Giving Most Extras

SQL
select bowler,
       sum(extra_runs) as extrasconceded
from deliveries
group by bowler
order by extrasconceded desc;
Super Over Analysis

Teams Playing Most Super Overs

SQL
select team1,
       team2,
       count(*) as superovers
from matches
where super_over = 'y'
group by team1, team2
order by superovers desc;
Teams Winning Most Super Overs

SQL
select winner,
       count(*) as superoverwins
from matches
where super_over = 'y'
group by winner
order by superoverwins desc;
Advanced Window Function Queries

Running Career Runs of Each Batsman

SQL
select batsman,
       match_id,
       sum(batsman_runs) over (
           partition by batsman
           order by match_id
       ) as runningruns
from deliveries;
Running Wickets of Bowlers

SQL
select bowler,
       match_id,
       sum(
           case when player_dismissed is not null then 1 else 0 end
       ) over (
           partition by bowler
           order by match_id
       ) as runningwickets
from deliveries;
Rank Teams by Wins Each Season

SQL
select season,
       winner,
       count(*) as wins,
       dense_rank() over (
           partition by season
           order by count(*) desc
       ) as rankno
from matches
where winner is not null
group by season, winner;
Best Opening Partnerships

SQL
select top 10
       match_id,
       batting_team,
       sum(total_runs) as openingstand
from deliveries
where over <= 6
group by match_id, batting_team
order by openingstand desc;
Teams Losing Most After Winning Toss

SQL
select toss_winner,
       count(*) as lossesaftertosswin
from matches
where toss_winner <> winner
group by toss_winner
order by lossesaftertosswin desc