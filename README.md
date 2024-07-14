# walmart-data-cleaning
Upon completing 8 courses in data analytics fundamentals, I was eager to apply my newly acquired skills. I found a problem set from Mary the Data Analyst (Mary Knoeferl) and decided to tackle the tasks she provided.
**Data:** [Walmart Sales Data](https://www.kaggle.com/datasets/mikhail1681/walmart-sales)

## Data Cleaning Practice
Using Python, R, Excel, or another data cleaning tool of your choice, clean the data to meet the following criteria:
- Data is sorted first by store number (ascending) and second by date (ascending)
- Date is in the format MM-DD-YYYY
- Weekly Sales is rounded to the nearest 2 decimal places
- Temperature is rounded to the nearest whole number
- Fuel Price is rounded to the nearest 2 decimal places
- CPI is rounded to the nearest 3 decimal places
- Unemployment is rounded to the nearest 3 decimal places
- Ensure that there is no missing data

## Business Questions
1. **Which holidays affect weekly sales the most?**
2. **Which stores in the dataset have the lowest and highest unemployment rate? What factors do you think are impacting the unemployment rate?**
3. **Is there any correlation between CPI and Weekly Sales? How does the correlation differ when the Holiday Flag is 0 versus when the Holiday Flag is 1?**
4. **Why do you think Fuel Price is included in this dataset? What conclusions can be made about Fuel Price compared to any of the other fields?**

## SQL Queries
The following SQL queries were used for data cleaning:
The following SQL queries were used for data analysis:
The first question asks which holidays affect weekly sales the most. To answer this question, I needed to know what sales were like on average throughout the whole year so that when I looked at sales during holiday, I would know how much different it is. In order to do this, I made two sub-queries to find overall average weekly sales and average weekly sales when there is a holiday. I then would need to calculate the absolute difference between these and order them descending to see the biggest differences between average weekly sales on top of my query result.  I then found that thanksgiving, new year’s, and valentine’s day affect weekly sales the most.
```sql
-- Data Cleaning Query
CREATE TABLE `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales` AS
SELECT
Store , 
FORMAT_DATE('%m-%d-%Y', Date) AS Formatted_Date,
ROUND(Weekly_Sales,2) AS Rounded_Weekly_Sales,
Holiday_Flag,
ROUND(Temperature) AS Rounded_Temperature,
ROUND(Fuel_Price,2) AS Rounded_Fuel_Price,
ROUND(CPI,3) AS Rounded_CPI,
ROUND(Unemployment,3) AS Rounded_Unemployment
FROM 
`decisive-lambda-424322-u1.walmart_data.walmart_sales`
WHERE
Store IS NOT NULL
AND Date IS NOT NULL
AND Weekly_Sales IS NOT NULL
AND Holiday_Flag IS NOT NULL
AND Temperature IS NOT NULL
AND Fuel_Price IS NOT NULL
AND CPI IS NOT NULL
AND Unemployment IS NOT NULL
ORDER BY
Store ASC, Date ASC;

-- Which holidays affect weekly sales the most?
WITH overall_avg AS(
  SELECT
    AVG(Rounded_Weekly_Sales) AS Overall_Average_Sales
  FROM
    `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales`
),
holiday_sales AS(
  SELECT
    Formatted_Date ,
    AVG(Rounded_Weekly_Sales) AS Avg_Weekly_Sales
  FROM
    `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales`
  WHERE
    Holiday_Flag = 1
  GROUP BY
    Formatted_Date
)
SELECT
  holiday_sales.Formatted_Date ,
  holiday_sales.Avg_Weekly_Sales ,
  overall_avg.Overall_Average_Sales ,
  ABS((holiday_sales.Avg_Weekly_Sales) - (overall_avg.Overall_Average_Sales)) AS Sales_Difference
FROM
  holiday_sales ,
  overall_avg
ORDER BY
  Sales_Difference DESC;
```
The next question asks about unemployment rates by stores. My query includes the data and cpi to help produce any clues as to why the rates were they way they were. I found that stores 12,28, and 38 had the highest unemployment rates. This was around the end of 2010 and CPI was around 126. I also found that store 4 had the lowest unemployment rates around October of 2012 and CPI was around 131.  I then decided to check the correlation between CPI and unemployment rates. Using the correlation function I found that as CPI increases, unemployment tends to decrease slightly, but the relationship is not strong. [MODERATE TO LOW CORRELATION]
```sql
-- Which stores in the dataset have the lowest unemployment rate
SELECT
  Store ,
  Formatted_Date ,
  Rounded_CPI ,
  MIN(Rounded_Unemployment) AS Min_Unemployment
FROM
  `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales` 
GROUP BY
  Store ,
  Formatted_Date ,
  Rounded_CPI 
ORDER BY
  Min_Unemployment ASC;
--
--  and highest unemployment rate? 
SELECT
  Store ,
  Formatted_Date ,
  Rounded_CPI ,
  MAX(Rounded_Unemployment) AS Max_Unemployment
FROM
  `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales` 
GROUP BY
  Store ,
  Formatted_Date,
  Rounded_CPI
ORDER BY
  Max_Unemployment DESC;
--
--What factors do you think are impacting the unemployment rate?
SELECT
  CORR(Rounded_CPI,Rounded_Unemployment) AS Correlation_CPI_Unemp
FROM
  `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales` ;
```
The third questions asks about the correlation between CPI and weekly sales. It also ask to check whether the correlation changes during a holiday or without the presnce of any holidays. The correlation between CPI and weekly sales is -0.07. When you take out the holidays it is still -0.07. When you look at just weekly sales around holidays it changes slightly and the correlation is -0.08.
```sql

-- Is there any correlation between CPI and Weekly Sales?  
SELECT
  CORR(Rounded_CPI, Rounded_Weekly_Sales) AS Correlation_CPI_Sales
FROM
  `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales` ;
--
-- How does the correlation differ when the Holiday Flag is 0 
SELECT
  CORR(Rounded_CPI, Rounded_Weekly_Sales) AS Correlation_CPI_NoHoli
FROM
  `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales` 
WHERE
  Holiday_Flag = 0;
--
-- versus when the Holiday Flag is 1?
SELECT
  CORR(Rounded_CPI, Rounded_Weekly_Sales) AS Correlation_CPI_OnHoli
FROM
  `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales` 
WHERE
  Holiday_Flag = 1;
```
The last question has us consider Fuel Prices. Off the top of my head I figured with high fuel prices, people would not want to drive or go out or ultimately even shop as much. I checked for correlation but I wanted to see what sales looked like when fuel prices were lower and what sales looked like when fuel prices were higher. I found that there was no correlation between gas prices and sales so I dove further into my analysis. My queries were inconclusive and I was unable to identify a trend.
```sql
-- Why do you think Fuel Price is included in this dataset? What conclusions can be made about Fuel Price compared to any of the other fields?
-- Fuel prices may affect someones willingness to drive so we will check the correlation
SELECT
  CORR(Rounded_Fuel_Price, Rounded_Weekly_Sales) AS Correlation_Fuel_Sales
FROM
  `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales` ;
--
-- What were the sales when fuel was at its max?
SELECT
  Store ,
  Formatted_Date ,
  Rounded_Weekly_Sales ,
  Rounded_Fuel_Price
FROM
  `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales` 
WHERE
  Rounded_Fuel_Price = (SELECT MAX(Rounded_Fuel_Price) FROM `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales`);
--
-- What were the sales when fuel was at its min?
SELECT
  Store ,
  Formatted_Date ,
  Rounded_Weekly_Sales ,
  Rounded_Fuel_Price
FROM
  `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales` 
WHERE
  Rounded_Fuel_Price = (SELECT MIN(Rounded_Fuel_Price) FROM `decisive-lambda-424322-u1.walmart_data.cleaned_walmart_sales`);
--
--
```




