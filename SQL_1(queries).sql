CREATE DATABASE MAIN;
USE MAIN;
show tables;

select * from library1;

select * from library2;

select * from library3;

select * from library4;

select * from library5;

#########################LIBRARY 1 ANALYSIS#######################################
select * from library1;
#1. Identifying main location with maximum stop count monthly

SELECT `Main Location`, COUNT(*) AS Stop_Count FROM library1 WHERE Freq='monthly' GROUP BY `Main Location` ORDER BY Stop_Count DESC;

#2. Identify routes with potential delays by comparing Arrive and Depart times.

select Route,`Main Location`,`Secondary Location`,Freq,
(Depart-Arrive) as Actual_stop_duration, 
(Depart-Arrive)-`Stop Duration` as Delay
from library1 
order by Delay desc;


########################################LIBRARY 2 ANALYSIS###########################

select * from library2;

#3.	Most Popular Libraries: Find libraries with the highest total Attendees across all Dates.

select 
    Library,
    SUM(Attendees) as Total_Attendees
from library2
group by Library
order by Total_Attendees desc;

#4. Analyze attendance over time (group by Date) to identify peak periods

select 
`Date`,
sum(Attendees) as total_attendees
from library2
group by `Date`
order by total_attendees desc;

#5. Comparing Attendees across Library to see which library has most attendees.

select `Library`,
sum(Attendees) as Total_attendees
from library2
group by `Library`
order by Total_attendees desc;


###################################################LIBRARY 3 ANALYSIS######################################

select * from library3;

#6. no:of visits for each library

select Library,
sum(visits) as total_visits
from library3
group by Library
order by total_visits desc;


#7. top 3 visited libraries and least visited libraries

select Library,
sum(visits) as total_visits
from library3
group by Library
order by total_visits desc limit 3;

select Library,
sum(visits) as total_visits
from library3
group by Library
order by total_visits limit 3;

#8. count for type of visit preference

select `Count Type`, count(*) as Preference from library3  group by `Count Type` order by Preference desc;

#9. to see count type in most visit library

select `Count Type`, count(*) as Preference 
from library3  
where Library='Cambridge Central'
group by `Count Type` 
order by Preference;

select *
from library3
where Library='Cambridge Central';
################################################LIBRARY 4 ANALYSIS#########################################

select * from library4;

#10. to Count libraries by type of library 

select `Type of library`,count(*) from library4 group by `Type of library`;

#11. to Count libraries by year to identify high library starting year

select `Year Opened`,count(*) as no_of_lib_opened from library4 group by `Year Opened` order by no_of_lib_opened desc;

#12. selected details of libraries opened on 2010

select `Library name`,`type of library`,`Co-located with`,Postcode
from library4
where `Year Opened`=2010;

#13. details of unstaffed hours and those libraries

select `Library name`,`Monday Unstaffed hours`,`Tuesday Unstaffed hours`,`Wednesday Unstaffed hours`,`Thursday Unstaffed hours`,`Friday Unstaffed hours`,`Saturday Unstaffed hours`,`Sunday Unstaffed hours`,`Special Hours`
from library4
where (`Tuesday Unstaffed hours` !='')
 or (`Wednesday Unstaffed hours`!='')
 or (`Thursday Unstaffed hours`!='')
 or (`Friday Unstaffed hours`!='')
 or (`Saturday Unstaffed hours`='');
 
 #14. oppened and closing of libraries
 
 select `Library name`,`Year Opened`,`Year Closed`
 from library4
 where `Year Closed`!='';
 
 #15. Co-located Libraries:Identify libraries that share facilities (analyze Co-located and Co-located with).
 
select `Library name`,`Co-located`,`Co-located with`
from library4
where `Co-located`='Yes';

#16. to Count libraries by colocated with 

select `Co-located with`,count(*) as count_co from library4 where `Co-located`!='' group by `Co-located with` order by count_co desc;

##################################LIBRARY 5 ANALYSIS#############################################

select * from library5;

#17. Distinct months present in library5 data

select distinct `Month` from library5;

#18. loan count for both months in general

select `Month`,sum(Loans) as count_loan from library5 group by `Month` order by count_loan desc;

#19. loan count of different libraries

select `Library`,sum(Loans) as total_loans_per_lib from library5  group by `Library` order by total_loans_per_lib desc;

select `Library`,sum(Loans) as total_loans_per_lib from library5  group by `Library` order by total_loans_per_lib;

#20. identifying distinct types of loans

select `Type`,sum(Loans) as loan_type_num from library5 group by `Type` order by loan_type_num desc;

#21. loan types for highest loan num library

select `Type`, SUM(Loans) as loan_type_num
from library5
where Library='Cambridgeshire Libraries'
group by Library, `Type`
order by loan_type_num desc;

#####################JOINING ANALYSIS#################################

###############library2 &library4 FILE##########
select * from library2;
select * from library4;

#22. before trying to do joining operations, we have to have a look to the field names and field values

SELECT DISTINCT Library FROM library2;

SELECT DISTINCT `Library Name` FROM library4;

SELECT l2.Library, l2.Attendees
FROM library2 l2
JOIN library4 l4 
ON TRIM(l2.Library) = TRIM(REPLACE(l4.`Library Name`, ' Library', ''))
ORDER BY l2.Attendees DESC;

##########library3 and library5#######
select * from library3;

select * from library5;

#here also field names have the same issue


SELECT 
    l3.Library,
    SUM(l3.Visits) AS Total_Visits,
    SUM(l5.Loans) AS Total_Loans
FROM 
    library3 l3
JOIN 
    library5 l5 
ON TRIM(l3.Library) = TRIM(REPLACE(l5.Library, ' Library', ''))
GROUP BY 
    l3.Library
ORDER BY 
    Total_Loans DESC;
    
    SELECT 
    l3.Library,
    SUM(l3.Visits) AS Total_Visits,
    SUM(l5.Loans) AS Total_Loans
FROM 
    library3 l3
JOIN 
    library5 l5 
ON TRIM(l3.Library) = TRIM(REPLACE(l5.Library, ' Library', ''))
GROUP BY 
    l3.Library
ORDER BY 
    Total_Visits DESC;

##############library2 and library4#####################
#24. Join library2 (attendance) with library4 (library type) to see which types of libraries attract more visitors.

select * from library2;
select * from library4;

select l4.`Type of Library`,SUM(l2.Attendees) AS Total_Attendees
from library2 l2
join library4 l4 
on l2.Library = REPLACE(l4.`Library Name`, ' Library', '')
group by l4.`Type of Library`
order by Total_Attendees desc;


############library2, library3 and library5###################
#25. Compare trends in Attendees (library2), Visits (library3), and Loans (library5) over time to identify patterns.

select * from library2;
#Library, Attendees

select * from library3;
#Library ,visits

select * from library5;
#Library, Loans
#but data has extra ' Library'

select l2.Library,sum(l2.Attendees) as Total_attendees, sum(l3.visits) as Total_visits, sum(l5.Loans) as Total_loans
from library2 l2
join library3 l3 on l2.Library = l3.Library 
join library5 l5 on replace(l5.Library, ' Library', '') = l2.Library
group by l2.Library
order by Total_loans desc;








  
    



