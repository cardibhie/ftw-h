{{ config(
    materialized="table",
    schema="clean"
) }}

with source as (
    select
        cast(ref_area.label as varchar) as country,
        cast(source.label as varchar) as source_label,
        cast(indicator.label as varchar) as indicator_label,
        cast(sex.label as varchar) as sex_label,
        cast(classif1.label as varchar) as educ_level_raw,
        cast(classif2.label as varchar) as classif2_label,
        cast(replace(time, ',', '') as integer) as year,
        cast(obs_value as float) as obs_value,
        cast(coalesce(nullif(obs_status.label, ''), 'Not Applicable') as varchar) as obs_status_label,
        cast(note_classif.label as varchar) as note_classif_label,
        cast(note_indicator.label as varchar) as note_indicator_label,
        cast(note_source.label as varchar) as note_source_label
    from {{ source('raw', 'raw_grp6_ilostat_labor_force') }}
),

filtered as (
    select *
    from source
    where lower(sex_label) = 'female'
),

standardized as (
    select
        country,
        source_label,
        indicator_label,
        sex_label,
        year,
        obs_value,
        obs_status_label,
        note_classif_label,
        note_indicator_label,
        note_source_label,
        classif2_label,
        educ_level_raw,
        case
            when lower(educ_level_raw) like '%kinder%' 
              or lower(educ_level_raw) like '%nursery%' 
              or lower(educ_level_raw) like '%preschool%' 
              or lower(educ_level_raw) like '%early%' 
              then 'Early Childhood / Kindergarten'

            when lower(educ_level_raw) like '%grade%' 
              or lower(educ_level_raw) like '%elementary%' 
              or lower(educ_level_raw) like '%primary%' 
              then 'Grade School / Primary Education'

            when lower(educ_level_raw) like '%junior%' 
              or lower(educ_level_raw) like '%lower secondary%' 
              or lower(educ_level_raw) like '%middle school%' 
              then 'Junior High School / Lower Secondary'

            when lower(educ_level_raw) like '%senior%' 
              or lower(educ_level_raw) like '%upper secondary%' 
              or lower(educ_level_raw) like '%high school%' 
              then 'Senior High School / Upper Secondary'

            when lower(educ_level_raw) like '%vocational%' 
              or lower(educ_level_raw) like '%technical%' 
              or lower(educ_level_raw) like '%tvet%' 
              or lower(educ_level_raw) like '%tesda%' 
              then 'Post-Secondary / Vocational Training'

            when lower(educ_level_raw) like '%diploma%' 
              or lower(educ_level_raw) like '%associate%' 
              or lower(educ_level_raw) like '%short%' 
              then 'College Diploma / Associate Degree'

            when lower(educ_level_raw) like '%bachelor%' 
              or lower(educ_level_raw) like '%college%' 
              or lower(educ_level_raw) like '%undergrad%' 
              then 'Bachelor’s Degree / Undergraduate'

            when lower(educ_level_raw) like '%master%' 
              or lower(educ_level_raw) like '%postgrad%' 
              or lower(educ_level_raw) like '%graduate%' 
              then 'Master’s Degree / Graduate'

            when lower(educ_level_raw) like '%phd%' 
              or lower(educ_level_raw) like '%doctor%' 
              or lower(educ_level_raw) like '%doctoral%' 
              then 'Doctoral Degree / PhD'

            else 'Unclassified'
        end as standardized_educ_level
    from filtered
    where educ_level_raw is not null
)

select *
from standardized
