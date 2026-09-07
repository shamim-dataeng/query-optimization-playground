-- M1: WINDOW FUNCTION
EXPLAIN ANALYZE
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
    rk<=3;

-- M2: CORRELATED SUBQUERY
EXPLAIN ANALYZE
SELECT
    t.PULocationID,
    t.fare_amount
FROM my_taxi t
WHERE (
    SELECT COUNT(DISTINCT t2.fare_amount)
    FROM my_taxi t2
    WHERE t2.PULocationID = t.PULocationID
      AND t2.fare_amount > t.fare_amount
) < 3;


-- M3: SELF JOIN
EXPLAIN ANALYZE
SELECT
    t1.PULocationID,
    t1.fare_amount
FROM my_taxi t1
JOIN my_taxi t2
    ON t2.PULocationID = t1.PULocationID
   AND t2.fare_amount > t1.fare_amount
GROUP BY
    t1.PULocationID,
    t1.fare_amount
HAVING COUNT(DISTINCT t2.fare_amount) < 3;