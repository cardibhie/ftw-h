{{ config(
    materialized = "table",
    schema = "clean_grp6",
    tags = ["staging", "lfs"]
) }}

WITH source AS (
    SELECT * 
    FROM {{ source('raw_grp6', 'raw_grp6___raw_lfs_may_2024_grp6') }}
),

cleaned AS (
    SELECT
        --  BASIC STRING CLEANING
        initcap(trim(toString(c04_sex))) AS sex,
        initcap(trim(toString(c06_marital_status))) AS marital_status,
        initcap(trim(toString(c07_highest_grade_completed))) AS highest_grade_completed,
        trim(toString(c11_location_of_work_province_municipalityx)) AS location_of_work,
        trim(toString(c16_nature_of_employment_primary_occupationx)) AS nature_of_employment,
        trim(toString(c21_class_of_worker_primary_occupationx)) AS class_of_worker,

        --  TYPE CASTING
        toInt32OrNull(trim(toString(c05_age_as_of_last_birthday))) AS age,
        toFloat64OrNull(trim(toString(c17_normal_working_hours_per_day))) AS normal_working_hours_per_day,
        toInt32OrNull(trim(toString(survey_year))) AS survey_year,

        -- LOGICAL FLAGS
        case 
            when lower(trim(toString(c09_work_indicator))) = 'yes' then 1
            when lower(trim(toString(c09_work_indicator))) = 'no' then 0
            else null
        end AS is_working,

        case 
            when lower(trim(toString(c10_job_indicator))) = 'yes' then 1
            when lower(trim(toString(c10_job_indicator))) = 'no' then 0
            else null
        end AS has_job,

        case 
            when lower(trim(toString(c20_b_first_time_to_do_any_work))) = 'yes' then 1
            when lower(trim(toString(c20_b_first_time_to_do_any_work))) = 'no' then 0
            else null
        end AS first_time_worker,

        --  DERIVED COLUMNS
        case
            when toFloat64OrNull(trim(toString(c17_normal_working_hours_per_day))) > 8 then 1
            else 0
        end AS is_overworked,

        --  NULL REPLACEMENT
        nullif(trim(toString(c26_reason_for_not_looking_for_work)), '') AS reason_not_looking_for_work

    FROM source
    WHERE toInt32OrNull(trim(toString(c05_age_as_of_last_birthday))) BETWEEN 15 AND 100
)

SELECT * FROM cleaned
