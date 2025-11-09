{{ config(
    materialized = "table",
    schema = "clean_grp6",
    tags = ["3nf", "lfs", "2019"]
) }}

WITH base AS (
    SELECT * 
    FROM clean_grp6.stg_lfs_2019
),

--  Occupation dimension
occupation_dim AS (
    SELECT 
        row_number() OVER (ORDER BY 
            primary_occupation, 
            kind_of_business, 
            nature_of_employment, 
            class_of_worker, 
            basis_of_payment
        ) AS occupation_id,
        primary_occupation,
        kind_of_business,
        nature_of_employment,
        class_of_worker,
        basis_of_payment
    FROM (
        SELECT DISTINCT
            COALESCE(primary_occupation, 'Unknown') AS primary_occupation,
            COALESCE(kind_of_business, 'Unknown') AS kind_of_business,
            COALESCE(nature_of_employment, 'Unknown') AS nature_of_employment,
            COALESCE(class_of_worker, 'Unknown') AS class_of_worker,
            COALESCE(basis_of_payment, 'Unknown') AS basis_of_payment
        FROM base
    )
)

SELECT 
    b.record_id AS respondent_id,
    b.survey_year,
    b.sex,
    b.age,
    b.marital_status,
    b.highest_grade_completed,
    b.region,
    o.occupation_id,
    b.normal_working_hours_per_day,
    b.total_hours_worked_week,
    b.basic_pay_per_day,
    b.is_working,
    b.is_overworked
FROM base AS b
LEFT JOIN occupation_dim AS o
    ON  b.primary_occupation     = o.primary_occupation
    AND b.kind_of_business       = o.kind_of_business
    AND b.nature_of_employment   = o.nature_of_employment
    AND b.class_of_worker        = o.class_of_worker
    AND b.basis_of_payment       = o.basis_of_payment
ORDER BY respondent_id
