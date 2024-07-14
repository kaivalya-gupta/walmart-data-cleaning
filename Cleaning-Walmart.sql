-- Data Cleaning Query
CREATE TABLE `my-database-bigquery.walmart_data.cleaned_walmart_sales` AS
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
`my-database-bigquery.walmart_data.walmart_sales`
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