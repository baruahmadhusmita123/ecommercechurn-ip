SELECT * FROM ecommerce.`ecommerce dataset`;
select * from `ecommerce dataset`;
-- to change the table name from ecommerce
rename table `ecommerce dataset` to ecom;
 
-- to add primarykey
alter table ecom add constraint primary key (CustomerID);
-- to describe the table(to see the primary key)
desc ecom;


-- Finding the totatl number of customers?
select  distinct(count(CustomerID))totalnumberofcustomers from ecom; 
-- total nnumber of customer is 4293


-- to check the presence of duplicate rows
select customerid, count(customerid)as count
from ecom
group by customerid
having count>1; 
-- there is no duplicate rows

select * from ecom;
-- to see the presence of null

SELECT 'Tenure' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE TRIM(Tenure) = '' OR Tenure IS NULL 
UNION
SELECT 'PreferredLoginDevice' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE TRIM(PreferredLoginDevice) = '' OR PreferredLoginDevice IS NULL
UNION
SELECT 'CityTier' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE CityTier IS NULL
UNION
SELECT 'WarehouseToHome' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE WarehouseToHome IS NULL
UNION
SELECT 'PreferredPaymentMode' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE TRIM(PreferredPaymentMode) = '' OR PreferredPaymentMode IS NULL
UNION
SELECT 'Gender' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE TRIM(Gender) = '' OR Gender IS NULL
UNION
SELECT 'HourSpendOnApp' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE TRIM(HourSpendOnApp) = '' OR HourSpendOnApp IS NULL
UNION
SELECT 'NumberOfDeviceRegistered' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE NumberOfDeviceRegistered IS NULL
UNION
SELECT 'PreferedOrderCat' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE TRIM(PreferedOrderCat) = '' OR PreferedOrderCat IS NULL
UNION
SELECT 'SatisfactionScore' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE SatisfactionScore IS NULL
UNION
SELECT 'MaritalStatus' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE TRIM(MaritalStatus) = '' OR MaritalStatus IS NULL
UNION
SELECT 'NumberOfAddress' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE NumberOfAddress IS NULL
UNION
SELECT 'Complain' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE TRIM(Complain) = '' OR Complain IS NULL
UNION
SELECT 'OrderAmountHikeFromlastYear' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE OrderAmountHikeFromlastYear IS NULL
UNION
SELECT 'CouponUsed' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE CouponUsed IS NULL
UNION
SELECT 'OrderCount' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE OrderCount IS NULL
UNION
SELECT 'DaySinceLastOrder' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE DaySinceLastOrder IS NULL
UNION
SELECT 'CashbackAmount' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE CashbackAmount IS NULL
UNION
SELECT 'StatusofCustomer' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE TRIM(StatusofCustomer) = '' OR StatusofCustomer IS NULL 
union
SELECT 'Gender' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE TRIM(Gender) = '' OR Gender IS NULL OR LENGTH(TRIM(Gender)) is null
UNION
SELECT 'PreferredLoginDevice' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE TRIM(PreferredLoginDevice) = '' OR PreferredLoginDevice IS NULL OR LENGTH(TRIM(PreferredLoginDevice)) = 0
UNION
SELECT 'CityTier' AS columnname, COUNT(*) AS nullcount FROM ecom WHERE TRIM(CityTier) = '' OR CityTier IS NULL OR LENGTH(TRIM(CityTier)) = 0;
-- Tenure and hoyrspendonapp has null values 
select * from ecom
-- Creating a column churned from an exsisting column "churn"
Alter table ecom 
Add column StatusofCustomer varchar(20);
 
 update ecom
 set StatusofCustomer =
 case
 when churn = 1 then "Churned"
 when churn = 0 then "stayed"
 End;
 select * from ecom;
-- The new column “StatusofCustomer” has two distinct values called "churned" and "stayed,"


-- Handling null values 
-- In order to handle these null values, we have fill the nulls with the mean value of their respective columns.
UPDATE ecom
SET tenure = (SELECT avg_tenure.avg_tenure FROM (SELECT round(avg(tenure),2) AS avg_tenure FROM ecom) AS avg_tenure)
WHERE TRIM(Tenure) = '' OR Tenure IS NULL; 

 update ecom 
 set HourSpendOnApp = (select avg_hsoa.avg_hsoa from (select round(avg(HourSpendOnApp)) as avg_hsoa from ecom) as avg_hsoa) 
 WHERE TRIM(HourSpendOnApp) = '' OR HourSpendOnApp IS NULL; 
 select * from ecom; 
 -- All the null values present in both the columns are removed. 
 
 -- Creating a new column from already exsisting complaincolumn 
 alter table ecom 
 add column Complainreceived varchar(20);
 update ecom 
 set Complainreceived = 
 case 
 when Complain = 1  then 'Yes'
 when Complain = 0  then 'No'
 end 
 ; 

-- Checking values in column for correctness and redundancy 
-- After going through each column, we noticed some redundant values in some columns and a wrongly entered value. 
-- This will be explored and fixed. 

-- Fixing redundancy in preferred login device
select distinct(PreferredLoginDevice) from ecom; 
-- Notice that phone and mobile phone appear in the column, but they mean the same thing. 
-- So we will replace the mobile phone with phone.

update ecom 
set PreferredLoginDevice = 'Phone'
where PreferredLoginDevice = 'Mobile Phone';
 
-- Fixing redundancy in “PreferedOrderCat” Column 
select distinct(PreferedOrderCat) from ecom; 
-- Similarly, here also phone and mobile phone appear in the column, but they mean the same thing.
-- So we will replace mobile with mobile phones 

update ecom 
set PreferedOrderCat = 'Mobile'
where PreferedOrderCat = 'Mobile Phone';

-- Fixing redundancy in “PreferredPaymentMode” Column 
select distinct(PreferredPaymentMode) from ecom; 
-- here also cod and Cash on Delivery appear in the column, but they mean the same thing.
-- So we will replace cod with Cash on Delivery 

update ecom 
set PreferredPaymentMode = 'COD'
where PreferredPaymentMode = 'Cash on Delivery'; 

-- Fixing wrongly entered values in “WarehouseToHome” column 
 select distinct(WarehouseToHome) from ecom; 
 -- The table shows a sample of the entire result. However, notice the 126 and 127 values; they are definitely outliers and most likely wrongly entered. 
 -- To fix this, we will correct the values to 26 and 27 to fall within the range of the values found in this column.

update ecom 
set warehousetohome = 26
where warehousetohome = 126; 
update ecom 
set warehousetohome = 27
where warehousetohome = 127; 

-- Data Exploration
-- Answering business questions.

-- 1. What is the overall customer churn rate?
select  totalnumberofcustomers, totalnumberofchurnedcustomer,
cast((totalnumberofchurnedcustomer*1.0/totalnumberofcustomers*1.0)*100 as decimal(10,2)) as Churnrate 
from 
(select count(*)totalnumberofcustomers from ecom)total,
(select count(*)totalnumberofchurnedcustomer from ecom 
where Statusofcustomer = 'Churned')churned; 
 -- The churn rate of 17.94% indicates that a significant portion of 
 -- customers in the dataset have ended their association with the company. 
 
 -- 2. How does the churn rate vary based on the preferred login device? 
 select * from ecom;
SELECT preferredlogindevice, COUNT(*) AS TotalCustomers,         
    SUM(churn) AS ChurnedCustomers,         
    CAST(SUM(churn) * 100.0 / COUNT(*) AS DECIMAL(10, 2)) AS ChurnRate 
FROM ecom 
GROUP BY preferredlogindevice 
order by churnrate desc;
-- The preferred login device appears to have some influence on customer churn rates. 
-- Customers who prefer logging in using a computer have a slightly higher churn rate 
-- compared to customers who prefer logging in using their phones. 

-- 3. What is the distribution of churncustomers across different city tiers?
select * from ecom; 
select citytier, count(*) as totalnumberofcustomer, sum(churn) as churnedcustomers,
cast(sum(churn)*100/count(*) as decimal(10,2))churnrate
from ecom
group by CityTier 
order by churnrate desc; 
-- The result suggests that the city tier has an impact on customer churn rates. 
-- Tier 1 cities have a relatively lower churn rate compared to Tier 2 and Tier 3 cities. 
-- This could be attributed to various factors such as competition, customer preferences, 
--  or the availability of alternatives in different city tiers. 

-- 4. Is there any correlation between the warehouse-to-home distance and customer churn? 
-- In order to answer this question, we will create a new column called “WarehouseToHomeRange” 
-- that groups the distance into very close, close, moderate, and far using the CASE statement. 

alter table ecom 
add column WarehouseToHomeRange varchar(50);

update ecom 
set WarehouseToHomeRange = 
case 
WHEN warehousetohome <= 10 THEN 'Very close'
    WHEN warehousetohome > 10 AND warehousetohome <= 20 THEN 'Close'
    WHEN warehousetohome > 20 AND warehousetohome <= 30 THEN 'Moderate'
    WHEN warehousetohome > 30 THEN 'Far'
END;
  
  select warehousetohomerange,count(*) as totalnumberofcustomers,
  sum(churn)as totalnumberofchurnedcustomers,
  cast((sum(churn)*100/count(*)) as decimal(10,2)) as churnrate
  from ecom 
group by 1
order by churnrate desc ;
-- The distance between the warehouse and the customer’s home 
-- seems to have some influence on customer churn rates. 

-- 5. Which is the most preferred payment mode among churned customers? 

select PreferredPaymentMode, count(*) as totalcustomers, sum(churn)as churnedcustomers,
cast((sum(churn)*100/count(*)) as decimal(10,2))as churnrate
from ecom 
group by 1 
order by churnrate desc; 
-- The most preferred payment mode among churned customers is cash on delivery. 

-- 6. What is the typical tenure for churned customers? 
-- we will create a new column called “TenureRange” that groups the customer 
-- tenure into 6 months, 1 year, 2 years, and more than 2 years using the CASE statement. 
 alter table ecom 
 add column TenureRange varchar(20); 
 
 update ecom 
 set TenureRange = 
 case 
 when Tenure <= 6 then '6 months'
 when Tenure >= 7 and tenure <= 12  then '1 year' 
 when Tenure >= 13 and tenure <= 24  then '2 years'
 when Tenure > 24  then 'more than 2 year'
 end;
 
select TenureRange, count(*)as totalcustomers, sum(churn) as totalchurnedcustomers, 
 cast((sum(churn)*100/count(*)) as decimal(10,2)) as churnrate
 from ecom 
 group by 1 
 order by churnrate desc; 
 -- The customers who are associated for 6 months or less 
 -- than that have churned more as compared to old customers who were there for more than 1 years
 
 -- 7. Is there any difference in churn rate between male and female customers? 
 select gender, count(*) as totalcustomers, sum(churn) as totalchurnedcustomers,
 cast((sum(churn)*100/count(*))as decimal(10,2)) churnrate 
 from ecom 
 group by 1
 order by churnrate desc; 
 -- Both male and female customers exhibit churn rates, with males having a slightly higher 
 -- churn rate compared to females. However, the difference in churn rates between 
 -- the genders is relatively small.

 -- 8. How does the average time spent on the app differ for churned and non-churned customers?

 select statusofcustomer, cast(avg(hourspendonapp) as decimal(10,2)) as Avgtimespentonapp
 from ecom
 group by 1
 order by Avgtimespentonapp desc; 
 -- Here we can see that churned customers comparatively spent more time on app which is likely to be contradictory
 
 -- 9. Does the number of registered devices impact the likelihood of churn? 
 SELECT NumberofDeviceRegistered,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 100 /COUNT(*) AS DECIMAL(10,2)) AS Churnrate
FROM ecom
GROUP BY 1
ORDER BY Churnrate desc ; 
-- There seems to be a correlation between the number of devices registered by customers and the likelihood of churn. 
-- Customers with a higher number of registered devices, such as 6 or 5, exhibit higher churn rates.

-- 10. Which order category is most preferred among churned customers? 
SELECT preferedordercat,COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 100 /COUNT(*)  AS DECIMAL(10,2)) AS Churnrate
FROM ecom
GROUP BY preferedordercat
ORDER BY Churnrate DESC; 
-- The analysis suggests that different order categories have varying impacts on customer churn rates. 

-- 11. Is there any relationship between customer satisfaction scores and churn?
SELECT satisfactionscore,COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 100 /COUNT(*)  AS DECIMAL(10,2)) AS Churnrate
FROM ecom
GROUP BY satisfactionscore
ORDER BY Churnrate DESC; 
-- The result indicates that customers with higher satisfaction scores, 
-- particularly those who rated their satisfaction as 5, 
-- have a relatively higher churn rate compared to other satisfaction score categories.

-- 12. Does the marital status of customers influence churn behavior? 

SELECT MaritalStatus,COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 100 /COUNT(*)  AS DECIMAL(10,2)) AS Churnrate
FROM ecom
GROUP BY MaritalStatus
ORDER BY Churnrate DESC; 
-- Single customers have the highest churn rate compared to customers with other marital statuses

-- 13. How many addresses do churned customers have on average? 
SELECT cast(AVG(numberofaddress)as decimal(10,0 )) AS Averagenumofchurnedcustomeraddress
FROM ecom
WHERE StatusofCustomer = 'churned'; 
-- On average, customers who churned had four addresses associated with their accounts.

-- 14. Do customer complaints influence churned behavior? 

SELECT complainreceived, COUNT(*) AS TOTALCUSTOMERS,sum(CHURN) AS TOTALCHURNEDCUSTOMERS,
CAST((SUM(CHURN)*100/COUNT(*)) AS DECIMAL (10,2)) AS CHURNRATE
FROM ECOM
GROUP BY 1 
ORDER BY CHURNRATE DESC; 
-- The fact that a larger proportion of customers 
-- who stopped using the company’s services registered complaints indicates the importance 
-- of dealing with and resolving customer concerns. 

-- 15. How does the use of coupons differ between churned and non-churned customers? 
select statusofcustomer, count(couponused) as totalnumberofcouponsused
from ecom 
group by 1 
order by totalnumberofcouponsused desc; 
-- The higher coupon usage among stayed customers
-- indicates their higher level of loyalty and engagement with the company.

-- 16. What is the average number of days since the last order for churned customers? 
SELECT cast(AVG(daysincelastorder) as decimal (10,2))AS AverageNumofDaysSinceLastOrder
FROM ecom
WHERE StatusofCustomer = 'churned';
 -- The fact that churned customers have, on average, only had a short period of time
 -- since their last order indicates that they recently stopped engaging with the company.
 
 -- 17. Is there any correlation between cashback amount and churn rate?
 
 alter table ecom
add column cashbackamountrange VARCHAR(50); 

update ecom
set cashbackamountrange = 
case 
WHEN cashbackamount <= 100 THEN 'Low Cashback Amount'
    WHEN cashbackamount > 100 AND cashbackamount <= 200 THEN 'Moderate Cashback Amount'
    WHEN cashbackamount > 200 AND cashbackamount <= 300 THEN 'High Cashback Amount'
    WHEN cashbackamount > 300 THEN 'Very High Cashback Amount'
END; 

select cashbackamountrange, count(*) as totalcustomers, sum(churn) as totalchurnedcustomers,
cast((sum(churn)*100/count(*))as decimal(10,2)) as churnrate 
from ecom
group by 1
order by churnrate desc; 
-- Customers who receivedvery high cashback amounts had a relatively higher churn rate,
--  while those who received moderate and  high cashback amounts exhibited lower churn rates.
--  Customers who received lower cashback amounts also had a 100% retention rate.


