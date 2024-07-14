-- Which holidays affect weekly sales the most?
WITH overall_avg AS(
  SELECT
    AVG(Rounded_Weekly_Sales) AS Overall_Average_Sales
  FROM
    `my-database-bigquery.walmart_data.cleaned_walmart_sales`
),
holiday_sales AS(
  SELECT
    Formatted_Date ,
    AVG(Rounded_Weekly_Sales) AS Avg_Weekly_Sales
  FROM
    `my-database-bigquery.walmart_data.cleaned_walmart_sales`
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
--
-- Which stores in the dataset have the lowest unemployment rate
SELECT
  Store ,
  Formatted_Date ,
  Rounded_CPI ,
  MIN(Rounded_Unemployment) AS Min_Unemployment
FROM
  `my-database-bigquery.walmart_data.cleaned_walmart_sales` 
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
  `my-database-bigquery.walmart_data.cleaned_walmart_sales` 
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
  `my-database-bigquery.walmart_data.cleaned_walmart_sales` ;
--
-- Is there any correlation between CPI and Weekly Sales?  
SELECT
  CORR(Rounded_CPI, Rounded_Weekly_Sales) AS Correlation_CPI_Sales
FROM
  `my-database-bigquery.walmart_data.cleaned_walmart_sales` ;
--
-- How does the correlation differ when the Holiday Flag is 0 
SELECT
  CORR(Rounded_CPI, Rounded_Weekly_Sales) AS Correlation_CPI_NoHoli
FROM
  `my-database-bigquery.walmart_data.cleaned_walmart_sales` 
WHERE
  Holiday_Flag = 0;
--
-- versus when the Holiday Flag is 1?
SELECT
  CORR(Rounded_CPI, Rounded_Weekly_Sales) AS Correlation_CPI_OnHoli
FROM
  `my-database-bigquery.walmart_data.cleaned_walmart_sales` 
WHERE
  Holiday_Flag = 1;
--
-- Why do you think Fuel Price is included in this dataset? What conclusions can be made about Fuel Price compared to any of the other fields?
-- Fuel prices may affect someones willingness to drive so we will check the correlation
SELECT
  CORR(Rounded_Fuel_Price, Rounded_Weekly_Sales) AS Correlation_Fuel_Sales
FROM
  `my-database-bigquery.walmart_data.cleaned_walmart_sales` ;
--
-- What were the sales when fuel was at its max?
SELECT
  Store ,
  Formatted_Date ,
  Rounded_Weekly_Sales ,
  Rounded_Fuel_Price
FROM
  `my-database-bigquery.walmart_data.cleaned_walmart_sales` 
WHERE
  Rounded_Fuel_Price = (SELECT MAX(Rounded_Fuel_Price) FROM `my-database-bigquery.walmart_data.cleaned_walmart_sales`);
--
-- What were the sales when fuel was at its min?
SELECT
  Store ,
  Formatted_Date ,
  Rounded_Weekly_Sales ,
  Rounded_Fuel_Price
FROM
  `my-database-bigquery.walmart_data.cleaned_walmart_sales` 
WHERE
  Rounded_Fuel_Price = (SELECT MIN(Rounded_Fuel_Price) FROM `my-database-bigquery.walmart_data.cleaned_walmart_sales`);
--
--
