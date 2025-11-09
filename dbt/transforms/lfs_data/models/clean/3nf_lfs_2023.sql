{{ config(
    materialized = "table",
    schema = "clean_grp6",
    tags = ["3nf", "lfs", "2023"]
) }}

WITH base AS (
    SELECT * 
    FROM clean_grp6.stg_lfs_2023
),

occupation_dim AS (
    SELECT 
        row_number() OVER (ORDER BY 
            major_occupation_group, 
            major_industry_group, 
            nature_of_employment, 
            class_of_worker
        ) AS occupation_id,
        major_occupation_group,
        major_industry_group,
        nature_of_employment,
        class_of_worker
    FROM (
        SELECT DISTINCT
            COALESCE(major_occupation_group, 'Unknown') AS major_occupation_group,
            COALESCE(major_industry_group, 'Unknown') AS major_industry_group,
            COALESCE(nature_of_employment, 'Unknown') AS nature_of_employment,
            COALESCE(class_of_worker, 'Unknown') AS class_of_worker
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
    b.total_hours_worked_all_jobs,
    b.is_working,
    b.is_overworked
FROM base AS b
LEFT JOIN occupation_dim AS o
    ON  b.major_occupation_group = o.major_occupation_group
    AND b.major_industry_group   = o.major_industry_group
    AND b.nature_of_employment   = o.nature_of_employment
    AND b.class_of_worker        = o.class_of_worker
ORDER BY respondent_id
