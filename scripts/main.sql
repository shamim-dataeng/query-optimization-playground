-- Identify the number of trips for each pickup zone
SELECT
    PULocationID,
    COUNT(*) AS "Number_Of_Trips",
    AVG(fare_amount) as "Avg_Fare_Amount"
FROM
    my_taxi
GROUP BY
    PULocationID
ORDER BY 
    Number_Of_Trips DESC;

-- Question : For each pickup zone (PULocationID), find the 3 trips with the highest fare_amount that started there. Not the top 3 fares overall — top 3 within each zone, so a busy zone and a quiet zone each contribute their own top 3.

-- Top-N per group, there are basically three major approaches

SELECT
    PULocationID,
    fare_amount
FROM 
    my_taxi
WHERE 
    PULocationID=107;

-- M1 : Window Function
WITH CTE1 AS (
    SELECT
        PULocationID,
        fare_amount,
        DENSE_RANK() OVER(PARTITION BY PULocationID ORDER BY FARE_AMOUNT DESC) AS rk
    FROM 
        my_taxi
)

SELECT
    *
FROM
    CTE1
WHERE
    rk<=3 and PULocationID=107;

-- M2: Correlated Subquery
SELECT
    t.PULocationID,
    t.fare_amount
FROM my_taxi t
WHERE (
    SELECT COUNT(DISTINCT t2.fare_amount)
    FROM my_taxi t2
    WHERE t2.PULocationID = t.PULocationID
      AND t2.fare_amount > t.fare_amount
) < 3 and PULocationID=107;

-- M3: Self join  
SELECT
    t1.PULocationID,
    t1.fare_amount
FROM my_taxi t1
JOIN my_taxi t2
    ON t2.PULocationID = t1.PULocationID
   AND t2.fare_amount > t1.fare_amount
where t1.PULocationID=107
GROUP BY
    t1.PULocationID,
    t1.fare_amount
HAVING COUNT(DISTINCT t2.fare_amount) < 3;