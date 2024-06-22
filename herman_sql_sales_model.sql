-----Герман Александр, 3 курс, 5 группа--------------------
---а)-----
WITH sales_2022 AS (
    SELECT
        year,
        month,
        prd_type_id,
        emp_id,
        amount AS Amount_at_2022
    FROM
        all_sales
)
SELECT
    year,
    month,
    prd_type_id,
    emp_id,
    plan_amount AS Plan_Amount_AT_2023
FROM (
    SELECT
        year,
        month,
        prd_type_id,
        emp_id,
        Amount_at_2022,
        CASE
            WHEN emp_id IN (21, 22) THEN ROUND(Amount_at_2022 * 1.05, 2)
            ELSE ROUND(Amount_at_2022 * 1.1, 2)
        END AS Plan_amount
    FROM
        sales_2022
)
MODEL
    PARTITION BY (year, month, prd_type_id)
    DIMENSION BY (emp_id)
    MEASURES (Amount_at_2022, Plan_amount)
    RULES (
        plan_amount[21] = ROUND(Amount_at_2022[21] * 1.05, 2),
        plan_amount[22] = ROUND(Amount_at_2022[22] * 1.05, 2),
        plan_amount[23] = ROUND(Amount_at_2022[23] * 1.1, 2),
        plan_amount[24] = ROUND(Amount_at_2022[24] * 1.1, 2)
    )
ORDER BY year, month, emp_id;
----б)----
select emp_id, prd_type_id, year, month, sales_amount
    from all_sales
        model
            partition by (prd_type_id, emp_id)
            dimension by (month, year)
            measures (amount sales_amount)
            rules (
                sales_amount[for month from 1 to 12 increment 1 , 2004] =avg(sales_amount)[month between 2 and 3 ,2003]
                )
    order by year desc, month, emp_id, prd_type_id;
----в)----
WITH max_sales AS (
    SELECT
        prd_type_id,
        year,
        month,
        MAX(amount) AS max_amount
    FROM
        all_sales
    GROUP BY
        prd_type_id, year, month
),
employee_diff AS (
    SELECT
        a.year,
        a.month,
        a.prd_type_id,
        a.emp_id,
        (a.amount - b.max_amount) / 2 AS half_diff
    FROM
        all_sales a
    JOIN
        max_sales b ON a.prd_type_id = b.prd_type_id
                    AND a.year = b.year
                    AND a.month = b.month
)
SELECT
    year,
    month,
    prd_type_id,
    emp_id,
    abs(half_diff) AS abs_half_diff
FROM
    employee_diff
MODEL
    PARTITION BY (year, month, prd_type_id)
    DIMENSION BY (emp_id)
    MEASURES (half_diff, 0 AS abs_half_diff)
    RULES (
        abs_half_diff[21] = abs(half_diff[21]),
        abs_half_diff[22] = abs(half_diff[22]),
        abs_half_diff[23] = abs(half_diff[23]),
        abs_half_diff[24] = abs(half_diff[24])
    )
ORDER BY
    year, month, prd_type_id, emp_id;
