use project;

--1st KPI : List the distinct customer types are present in the hotel booking dataset.

select distinct customer_type as Customers_type
from hotel_booking;



--2nd : KPI  What is the average length of stay (in days) for customers who checked out?

select round(avg(days_in_waiting_list),2) as Avg_Days_in_Wating_list
from hotel_booking
where reservation_status='Check-Out';



--3rd KPI : Find the percentage of cancel and non cancel reservations.

select 
( case
 when is_canceled =0 then 'Not Canceld'
else 'Canceled' 
end
) as reservation_type,
count(*) * 100 / sum(count(*)) over () as percentage
from hotel_booking
group by is_canceled;




--4th KPI : What is the average daily rate (ADR) for each customer type?

select customer_type,
round(avg(adr),2) as Average_Daily_Rate
 from hotel_booking
 group by customer_type;


 
 
--5th KPI : ADR (Average daily rate) by per month.

select month(reservation_status_date) as Month_No,
round(avg(adr),2) as Average_Daily_Rate
 from hotel_booking
 WHERE ISDATE(reservation_status_date) = 1
 group by month(reservation_status_date)
 order by month_no asc;
  
  

  
 --6th KPI : Find the percentage of cancel and non cancel reservations of Resort Hotel .

 select hotel,
( case
 when is_canceled =0 then 'Not Canceld'
else 'Canceled' 
end) as reservation_type,
count(*) * 100 / sum(count(*)) over () as percentage
from hotel_booking
where hotel ='Resort hotel'
group by hotel,is_canceled;
  


--7th KPI : Find the percentage of cancel and non cancel reservations of City Hotel.

select hotel,
( case
 when is_canceled =0 then 'Not Canceld'
else 'Canceled' 
end
) as reservation_type,
count(*) * 100 / sum(count(*)) over () as percentage
from hotel_booking
where hotel ='City hotel'
group by hotel,is_canceled;




--8th KPI  reservation Status count by Month

select month(try_convert(date, reservation_status_date)) as Month,
count(*) as All_Reservations,
sum(case when is_canceled = 0 then 1 end ) as Reservation_Done,
sum(case when is_canceled = 1 then 1 end ) as Reservation_Canceled
from hotel_booking
group by month(try_convert(date, reservation_status_date))
order by month asc;
  


 
--9th KPI  reservation cancel by market segment

select market_segment,
sum(is_canceled) as Total_Cancel_reservation
from hotel_booking
group by market_segment;



