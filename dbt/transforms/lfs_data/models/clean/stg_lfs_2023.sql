{{ config(
materialized = "table",
schema = "clean_grp6",
tags = ["staging", "lfs", "managerial_women"]
) }}

WITH source AS (
SELECT *
FROM {{ source('raw_grp6', var('lfs_source_table', 'raw_grp6_lfs2023')) }}
),

cleaned AS (
SELECT
row_number() OVER (ORDER BY toInt32OrNull(trim(toString(`RDMD_ID`)))) AS record_id,
toInt32OrNull(left(trim(toString(`Survey Year`)), 4)) AS survey_year,

    -- DEMOGRAPHICS
    initcap(trim(toString(`C04-Sex`))) AS sex,
    toInt32OrNull(trim(toString(`C05-Age as of Last Birthday`))) AS age,
    initcap(trim(toString(`C06-Marital Status`))) AS marital_status,
    initcap(trim(toString(`C07-Highest Grade Completed`))) AS highest_grade_completed,

    -- EMPLOYMENT
    COALESCE(nullIf(initcap(trim(toString(`C13-Major Occupation Group`))), ''), 'Unknown') AS major_occupation_group,
    COALESCE(nullIf(initcap(trim(toString(`C15-Major Industry Group`))), ''), 'Unknown') AS major_industry_group,
    COALESCE(nullIf(initcap(trim(toString(`C16-Nature of Employment (Primary Occupation)`))), ''), 'Unknown') AS nature_of_employment,
    COALESCE(nullIf(initcap(trim(toString(`C21-Class of Worker (Primary Occupation)`))), ''), 'Unknown') AS class_of_worker,
    COALESCE(nullIf(initcap(trim(toString(`C22-Other Job Indicator`))), ''), 'Unknown') AS other_job_indicator,

    -- WORK CONDITIONS
    COALESCE(toFloat64OrNull(trim(toString(`C17-Normal Working Hours per Day`))), 0) AS normal_working_hours_per_day,
    COALESCE(toFloat64OrNull(trim(toString(`C18-Total Number of Hours Worked during the past week`))), 0) AS total_hours_worked_week,
    COALESCE(toFloat64OrNull(trim(toString(`C23-Total Hours Worked for all Jobs`))), 0) AS total_hours_worked_all_jobs,

    -- WORK STATUS FLAG
    COALESCE(
        CASE 
            WHEN lower(trim(toString(`C09-Work Indicator`))) IN ('yes', 'y', '1', 'worked') THEN 1
            WHEN lower(trim(toString(`C09-Work Indicator`))) IN ('no', 'n', '0', 'did not work') THEN 0
            ELSE NULL
        END,
    0) AS is_working,

    -- LOCATION OF WORK
    COALESCE(nullIf(initcap(trim(toString(`C11 - Location of Work (Province, Municipality)`))), ''), 'Unknown') AS location_of_work,

    -- DERIVED FLAG
    COALESCE(
        CASE
            WHEN toFloat64OrNull(trim(toString(`C17-Normal Working Hours per Day`))) > 8 THEN 1
            ELSE 0
        END,
    0) AS is_overworked,

    toInt32OrNull(trim(toString(`Region`))) AS region

FROM source
WHERE 
    toInt32OrNull(trim(toString(`C05-Age as of Last Birthday`))) BETWEEN 15 AND 100

)

SELECT *
FROM cleaned
ORDER BY record_id
