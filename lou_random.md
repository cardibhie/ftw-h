| Column Name                    | Data Type | Description                                            | Example Values                | Notes                                     |
| ------------------------------ | --------- | ------------------------------------------------------ | ----------------------------- | ----------------------------------------- |
| `record_id`                    | Integer   | Unique sequential identifier for each respondent       | 1, 2, 3                       | Starts at 1, automatically generated      |
| `survey_year`                  | Integer   | Year the survey was conducted                          | 2019                          | Stored in `YYYY` format                   |
| `sex`                          | String    | Gender of the respondent                               | Female, Male                  | Cleaned to initcap                        |
| `age`                          | Integer   | Age of respondent as of last birthday                  | 25, 42, 60                    | Filtered to 15–100 years                  |
| `marital_status`               | String    | Marital status of respondent                           | Single, Married, Widowed      | Cleaned to initcap                        |
| `highest_grade_completed`      | String    | Highest education level attained                       | High School, College          | Cleaned to initcap                        |
| `primary_occupation`           | String    | Primary occupation of the respondent                   | Teacher, Accountant, Unknown  | Null/blank values replaced with 'Unknown' |
| `kind_of_business`             | String    | Type of business where primary occupation is performed | Private, Government, Unknown  | Null/blank values replaced with 'Unknown' |
| `nature_of_employment`         | String    | Employment nature for primary occupation               | Full-time, Part-time, Unknown | Null/blank values replaced with 'Unknown' |
| `class_of_worker`              | String    | Worker classification for primary occupation           | Regular, Contractual, Unknown | Null/blank values replaced with 'Unknown' |
| `basis_of_payment`             | String    | Payment basis for primary occupation                   | Daily, Monthly, Unknown       | Null/blank values replaced with 'Unknown' |
| `normal_working_hours_per_day` | Float     | Standard working hours per day                         | 8.0, 9.5                      | Null values replaced with 0               |
| `total_hours_worked_week`      | Float     | Total hours worked in the past week                    | 40.0, 48.5                    | Null values replaced with 0               |
| `basic_pay_per_day`            | Float     | Daily basic pay for primary occupation                 | 500.0, 1200.0                 | Null values replaced with 0               |
| `is_working`                   | Integer   | Flag indicating if respondent is currently working     | 1 = Yes, 0 = No               | Null values replaced with 0               |
| `is_overworked`                | Integer   | Flag indicating if normal daily working hours exceed 8 | 1 = Yes, 0 = No               | Derived column                            |
| `region`                       | Integer   | Geographic region code of respondent                   | 1, 2, 3                       | ClickHouse integer                        |
