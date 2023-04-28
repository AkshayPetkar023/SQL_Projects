
# In this IPL database there are 9 seasons (2008 to 2016) data are Stored.

use ipl;

# Q 1. display the total number of matches played by each team?
# Q 2. Display count the total wins of each team.
# Q 3. Display the final match teams and the winning team names by each season.
# Q 4. Display the names of all IPL trophy-winning teams and the count of their trophies.
# Q 5. Show count of players by country.
# Q 6. display the count of Man of the matches by player name.
# Q 7. Find name of player who are  Man of the series, Orange cap holder, purple cap holder by each season?
# Q 8. display which player has captained more number of matches?
# Q 9. List of top 10 highest runscoring players in IPL
# Q 10. List of players who scored centuries in IPL with their scores
# Q 11. Find the list of players with most Number of sixes
# Q 12. Display the youngest player form every country in IPL



# Q 1. display the total number of matches played by each team?

select
Team_name
,count(*) as Number_of_Matches
from ipl.match m inner join ipl.team t on m.Team_1=t.team_id or m.Team_2=t.Team_Id
group by team_name
order by Number_of_Matches desc;


# Q 2. Display count the total wins of each team.

Select Team_name,
count(*) as Number_of_wins
from ipl.match m inner join ipl.team t on m.Match_winner = t.Team_id
group by Team_Name
order by Number_of_wins desc;


# Q 3. Display the final match teams and the winning team names by each season.

with cte as
(
select match_date, t.Team_Name as TeamA
,t2.Team_Name as TeamB
,win.Team_Name,Season_Year,
row_number() over (partition by Season_Year order by match_date desc) as sn
from ipl.match m
 inner join ipl.team t on m.Team_1 =t.Team_Id
 inner join ipl.team t2 on m.Team_2 =t2.Team_Id
 inner join ipl.team win on m.Match_Winner =win.Team_Id
 inner join season s on m.Season_Id = s.Season_Id
 order by match_date desc)
 
 select Season_year as Season ,
 TeamA as Team_A, TeamB as Team_B, Team_Name as Season_Winner
 from cte
 where sn = 1
 order by season_year asc;


# Q 4. Display the names of all IPL trophy-winning teams and the count of their trophies.

with cte as
(
select match_date, t.Team_Name as TeamA
,t2.Team_Name as TeamB
,win.Team_Name,Season_Year,
row_number() over (partition by Season_Year order by match_date desc) as sn
from ipl.match m
 inner join ipl.team t on m.Team_1 =t.Team_Id
 inner join ipl.team t2 on m.Team_2 =t2.Team_Id
 inner join ipl.team win on m.Match_Winner =win.Team_Id
 inner join season s on m.Season_Id = s.Season_Id
 order by match_date desc)
 
 select Team_Name 
 ,count(*) as Total_Wins
 from cte
 where sn = 1
 group by Team_name
 order by Total_wins desc;



# Q 5. Display count of players by country

select c.Country_Name
,count(*) as Total_Players
from country c inner join player p on c.Country_Id = p.Country_Name
group by Country_Name
order by Total_Players desc;



# Q 6. display the count of Man of the matches by player name.

select
Player_Name
,count(*) as Man_of_Matches
from ipl.match m inner join ipl.player p on m.man_of_the_Match =p.Player_Id inner join ipl.country c on p.Country_Name = c.Country_Id
where c.country_Name = 'India'
group by Player_name
order by Man_of_Matches desc;



# Q 7. Find name of player who are  Man of the series, Orange cap holder, purple cap holder by each season?

select 
Season_Year
,p.Player_Name as Man_of_Series
,p2.Player_Name as Orange_Cap
,p3.Player_Name as Purple_Cap
from ipl.season s inner join ipl.player p on s.Man_of_the_series = p.Player_Id
Inner join ipl.player p2 on s.Orange_cap =p2.Player_id
Inner Join ipl.player p3 on s.Purple_cap= p3.Player_id;




# Q 8. display which player has captained more number of matches?

select 
Player_name
,count(*) as Captained_Matches
from ipl.player_match pm inner join ipl.player p on pm.Player_Id = p.Player_Id
inner join ipl.rolee r on pm.Role_Id = r.Role_Id
where Role_Desc like 'Captain%'
group by Player_name
order by captained_matches desc;




 # 9. List of top 10 highest runscoring players in IPL
 select Player_Name
 ,sum(Runs_Scored) as TotalRuns
 from ipl.ball_by_ball b inner join ipl.batsman_scored bs
 on b.ball_id= bs.ball_id and b.over_id =bs.over_id and b.Innings_no = bs.Innings_no
 and b.match_id =bs.match_id
 inner join ipl.player p on b.striker = p.player_id
 group by player_name
 order by TotalRuns desc
 limit 10;
 
 

# 10. List of players who scored centuries in IPL with their scores
 select Player_Name,
Match_Date
,t.Team_Name as TeamA
,t2.Team_Name as TeamB
 ,sum(Runs_Scored) as TotalRuns
 from ipl.ball_by_ball b inner join ipl.batsman_scored bs
 on b.ball_id= bs.ball_id and b.over_id =bs.over_id and b.Innings_no = bs.Innings_no
 and b.match_id =bs.match_id
 inner join ipl.match m on b.match_id =m.Match_Id
 inner join ipl.team t on m.Team_1 =t.Team_Id
 inner join ipl.team t2 on m.Team_2 =t2.Team_Id
 inner join ipl.player p on b.Striker =p.Player_Id
 group by player_name,Match_Date, TeamA, TeamB 
 having TotalRuns>=100
 order by TotalRuns desc;




# Q 11. Find the list of players with most Number of sixes
select
player_name
,count(*) as Number_of_six
 from ipl.ball_by_ball b inner join ipl.batsman_scored bs
 on b.ball_id = bs.ball_id and b.over_id = bs.over_id and b.Innings_no= bs.Innings_no
 and b.Match_id =bs.Match_id
 inner join ipl.player p on b.Striker = p.Player_Id
 where runs_scored =6
 group by player_name
 order by Number_of_six desc;
 
 
 
 
# Q 12. Display the youngest player form every country in IPL

with ab as (
select
c.Country_Name
, player_name
,DOB,
row_number() over(partition by c.country_name order by dob desc) as Young_player
from ipl.player p inner join ipl.country c on p.Country_Name=c.Country_Id)

select country_name, player_name, DOB from ab
where Young_player =1;







