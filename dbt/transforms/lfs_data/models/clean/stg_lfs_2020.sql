{{ config(
    materialized = "table",
    schema = "clean_grp6",
    tags = ["staging", "lfs", "managerial_women"]
) }}

WITH source AS (
    SELECT * 
    FROM {{ source('raw_grp6', 'raw_grp6_lfs2020') }}
),

cleaned AS (
    SELECT
        -- PRIMARY KEYS / IDENTIFIERS FIRST
        row_number() OVER (ORDER BY toInt32OrNull(trim(toString(`RDMD_ID`)))) AS record_id,

        -- SURVEY YEAR (cleaned and formatted to YYYY)
        toInt32OrNull(left(trim(toString(`Survey Year`)), 4)) AS survey_year,

        -- DEMOGRAPHICS
        initcap(trim(toString(`C04-Sex`))) AS sex,
        toInt32OrNull(trim(toString(`C05-Age as of Last Birthday`))) AS age,
        initcap(trim(toString(`C06-Marital Status`))) AS marital_status,
        initcap(trim(toString(`C07-Highest Grade Completed`))) AS highest_grade_completed,

        -- EMPLOYMENT DETAILS (NULL or BLANK → 'Unknown')
        COALESCE(nullIf(initcap(trim(toString(`C14-Primary Occupation`))), ''), 'Unknown') AS primary_occupation,
        COALESCE(nullIf(initcap(trim(toString(`C16-Kind of Business (Primary Occupation)`))), ''), 'Unknown') AS kind_of_business,
        COALESCE(nullIf(initcap(trim(toString(`C17-Nature of Employment (Primary Occupation)`))), ''), 'Unknown') AS nature_of_employment,
        COALESCE(nullIf(initcap(trim(toString(`C23-Class of Worker (Primary Occupation)`))), ''), 'Unknown') AS class_of_worker,
        COALESCE(nullIf(initcap(trim(toString(`C24-Basis of Payment (Primary Occupation)`))), ''), 'Unknown') AS basis_of_payment,

        -- WORK CONDITIONS (NULLS → 0)
        COALESCE(toFloat64OrNull(trim(toString(`C18-Normal Working Hours per Day`))), 0) AS normal_working_hours_per_day,
        COALESCE(toFloat64OrNull(trim(toString(`C19-Total Number of Hours Worked during the past week`))), 0) AS total_hours_worked_week,
        COALESCE(toFloat64OrNull(trim(toString(`C25-Basic Pay per Day (Primary Occupation)`))), 0) AS basic_pay_per_day,

        -- WORK STATUS FLAGS (NULLS → 0)
        COALESCE(
            CASE 
                WHEN lower(trim(toString(`C11-Work Indicator`))) IN ('yes', 'y', '1', 'worked') THEN 1
                WHEN lower(trim(toString(`C11-Work Indicator`))) IN ('no', 'n', '0', 'did not work') THEN 0
                ELSE NULL
            END,
        0) AS is_working,

        -- DERIVED FLAG (NULLS → 0)
        COALESCE(
            CASE
                WHEN toFloat64OrNull(trim(toString(`C18-Normal Working Hours per Day`))) > 8 THEN 1
                ELSE 0
            END,
        0) AS is_overworked,

        -- CONTEXTUAL INFO
        toInt32OrNull(trim(toString(`Region`))) AS region

    FROM source
    WHERE 
        toInt32OrNull(trim(toString(`C05-Age as of Last Birthday`))) BETWEEN 15 AND 100
)

SELECT *
FROM cleaned
ORDER BY record_id
