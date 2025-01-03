use assignment3;

show tables;

Select Extract(MONTH from created_at) as Months ,Count(activated_at) as "Num_of_Activated_Users" from users
where activated_at NOT IN("")
GROUP BY 1
ORDER BY 1;

Select Extract(WEEK from occurred_at) as "Week_Number", Count( Distinct user_id) as "User_id" from events
 where event_type="engagement" 
 group by Week_number;
 
Select  months,Num_of_Activated_Users,Round(((Num_of_Activated_Users/LAG(Num_of_Activated_Users,1) OVER (ORDER BY MONTHS)-1)*100),2) as "growth in %" 
From
(
Select Extract(MONTH from created_at) as Months ,Count(activated_at) as "Num_of_Activated_Users" from users
where activated_at NOT IN("")
GROUP BY 1
ORDER BY 1
) tabs;

Select first as "Number_of_week",
SUM(CASE WHEN week_number=0 Then 1 else 0 END)AS "WEEK 0",
SUM(CASE WHEN week_number=1 Then 1 else 0 END)AS "WEEK 1",
SUM(CASE WHEN week_number=2 Then 1 else 0 END)AS "WEEK 2",
SUM(CASE WHEN week_number=3 Then 1 else 0 END)AS "WEEK 3",
SUM(CASE WHEN week_number=4 Then 1 else 0 END)AS "WEEK 4",
SUM(CASE WHEN week_number=5 Then 1 else 0 END)AS "WEEK 5",
SUM(CASE WHEN week_number=6 Then 1 else 0 END)AS "WEEK 6",
SUM(CASE WHEN week_number=7 Then 1 else 0 END)AS "WEEK 7",
SUM(CASE WHEN week_number=8 Then 1 else 0 END)AS "WEEK 8",
SUM(CASE WHEN week_number=9 Then 1 else 0 END)AS "WEEK 9",
SUM(CASE WHEN week_number=10 Then 1 else 0 END)AS "WEEK 10",
SUM(CASE WHEN week_number=11 Then 1 else 0 END)AS "WEEK 11",
SUM(CASE WHEN week_number=12 Then 1 else 0 END)AS "WEEK 12",
SUM(CASE WHEN week_number=13 Then 1 else 0 END)AS "WEEK 13",
SUM(CASE WHEN week_number=14 Then 1 else 0 END)AS "WEEK 14",
SUM(CASE WHEN week_number=15 Then 1 else 0 END)AS "WEEK 15",
SUM(CASE WHEN week_number=16 Then 1 else 0 END)AS "WEEK 16",
SUM(CASE WHEN week_number=17 Then 1 else 0 END)AS "WEEK 17",
SUM(CASE WHEN week_number=18 Then 1 else 0 END)AS "WEEK 18"
FROM
(
Select event1.user_id,event1.login_week,event2.first,event1.login_week-first AS Week_number
FROM
(
Select user_id, EXTRACT(WEEK FROM occurred_at) AS login_week from events
Group by user_id,login_week)event1,
(Select user_id, MIN(EXTRACT(WEEK FROM occurred_at)) AS First from events 
Group by user_id)event2
Where event1.user_id=event2.user_id
)tabs
Group By first 
Order by first;

SELECT WEEK,
ROUND((weekly_digest/total*100),2) AS "Weekly Digest Rate",
Round((email_opens/total*100),2) AS "Email_open_rate",
Round((email_clickthroughs/total*100),2) AS "Email Clickthrough Rate",
Round((reengagement_emails/total*100),2) AS "Reengagement Email Rate"
From
(
    Select EXTRACT(WEEK from occurred_at) AS WEEK,
    Count(CASE WHEN action="sent_weekly_digest" THEN user_id ELSE NULL END) AS weekly_digest,
    Count(CASE WHEN action="email_open" THEN user_id ELSE NULL END) AS email_opens,
    Count(CASE WHEN action="email_clickthrough" THEN user_id ELSE NULL END) As email_clickthroughs,
    Count(CASE WHEN action="sent_reengagement_email" THEN user_id ELSE NULL END) As reengagement_emails,
Count(user_id) AS total
From email_events
Group BY 1
)tabs
Group By week
order By WEEK ;


Select EXTRACT(WEEK from occurred_at) As "WEEK NUMBERS",
Count(Distinct CASE WHEN device IN('dell inspiron notebook') Then user_id ELSE NULL END)AS
"Dell inspiron notebook",
Count(Distinct CASE WHEN device IN('iphone 5') Then user_id ELSE NULL END)AS
"iPhone 5",
Count(Distinct CASE WHEN device IN('iphone 4s') Then user_id ELSE NULL END)AS
"iPhone 4s",
Count(Distinct CASE WHEN device IN('windows surface') Then user_id ELSE NULL END)AS
"Windows surface",
Count(Distinct CASE WHEN device IN('macbook air') Then user_id ELSE NULL END)AS
"Macbook air",
Count(Distinct CASE WHEN device IN('iphone 5s') Then user_id ELSE NULL END)AS
"iPhone 5s",
Count(Distinct CASE WHEN device IN('macbook pro') Then user_id ELSE NULL END)AS
"Macbook pro",
Count(Distinct CASE WHEN device IN('kindle fire') Then user_id ELSE NULL END)AS
"Kindle fire",
Count(Distinct CASE WHEN device IN('ipad mini') Then user_id ELSE NULL END)AS
"iPad mini",
Count(Distinct CASE WHEN device IN('nexus 7') Then user_id ELSE NULL END)AS
"nexus 7",
Count(Distinct CASE WHEN device IN('nexus 5') Then user_id ELSE NULL END)AS
"nexus 5",
Count(Distinct CASE WHEN device IN('samsung galaxy s4') Then user_id ELSE NULL END)AS
"samsung galaxy s4",
Count(Distinct CASE WHEN device IN('lenovo thinkpad') Then user_id ELSE NULL END)AS
"lenovo thinkpad",
Count(Distinct CASE WHEN device IN('samsumg galaxy tablet') Then user_id ELSE NULL END)AS
"samsumg galaxy tablet",
Count(Distinct CASE WHEN device IN('asus chromebook') Then user_id ELSE NULL END)AS
"asus chromebook",
Count(Distinct CASE WHEN device IN('htc one') Then user_id ELSE NULL END)AS
"HTC one",
Count(Distinct CASE WHEN device IN('nokia lumia 635') Then user_id ELSE NULL END)AS
"Nokia lumia 635",
Count(Distinct CASE WHEN device IN('mac mini') Then user_id ELSE NULL END)AS
"mac mini",
Count(Distinct CASE WHEN device IN('dell inspiron desktop') Then user_id ELSE NULL END)AS
"dell inspiron desktop",
Count(Distinct CASE WHEN device IN('ipad air') Then user_id ELSE NULL END)AS
"ipad air",
Count(Distinct CASE WHEN device IN('amazon fire phone') Then user_id ELSE NULL END)AS
"Amazon fire phone",
Count(Distinct CASE WHEN device IN('nexus 10') Then user_id ELSE NULL END)AS
"Nexus 10"
From events 
where event_type='engagement'
Group by 1
order by 1;










