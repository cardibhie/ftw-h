# 📝 FTW-H Data Engineer Documentation & Presentation

---

## 1. Project Overview

- **Dataset Used:**  
  *2022 Philippines Demographic and Health Survey*
  *2022 International Labor Organization Statistics*
  *2019-2023 Philippine Statistics Authority Labor Force Survey*
  *[Women's Employment and Health in the Philippines Survey](https://docs.google.com/forms/d/e/1FAIpQLScaQxn7jTkP45K8JQuW7PI9zMjMfQwjUH18SS35z5HtLvf8sA/viewform)*  

- **Goal of the Capstone Project:**  
  *(What was the objective? Example: transform OLTP schema into dimensional star schema for analytics.)*  

- **Team Setup:**  
  FTW-H held multiple meetings with Ms. Chelsea and Ms. Belle to keep up with progress and ask for feedback. Data engineer scholars would set Slack huddles regularly to maintain communcations and discuss tasks. The DE scholars decided to assign tasks to each member to fast-track the completion of the data pipeline.

- **Environment Setup:**  
  *(Describe your environment — local vs remote, individual vs shared instances. Example: Docker containers on a shared VM + local laptops.)*  

---

## 2. Architecture & Workflow

- **Pipeline Flow:**  
  *(Diagram or describe: raw → clean → mart → BI.)*  

- **Tools Used:**  
  - Ingestion: `dlt`  
  - Modeling: `dbt`  
  - Visualization: `Tableau`  

- **Medallion Architecture Application:**  
  - **Bronze (Raw):** Initial ingestion of source data  
  - **Silver (Clean):** Cleaning, type casting, handling missing values  
  - **Gold (Mart):** Business-ready star schema for BI  

*(Insert diagram or screenshot here if possible.)*  

---

## 3. Modeling Process

- **Source Structure (Normalized):**  
  *(Describe how the original tables were structured — 3NF, relationships, etc.)*  

- **Star Schema Design:**  
  - Fact Tables: *fact_death_causes, fact_health_insurance, fact_ilostat_employment, fact_labor_force*  
  - Dimension Tables: *Sex, Age Group, Country, Region, Area Type, Occupation, Marital Status, Education, Death Cause, Death Date*  

- **Challenges / Tradeoffs:**  
  Raw data was sourced from multiple, disconnected, public datasets each with its own format and structure.   

---

## 4. Collaboration & Setup

- **Task Splitting:**  
  *(How the team divided ingestion, modeling, BI dashboards, documentation.)*  

- **Shared vs Local Work:**  
  *(Issues faced with sync conflicts, version control, DB connections, etc.)*  

- **Best Practices Learned:**  
  *(E.g., using Git for dbt projects, naming conventions, documenting assumptions, group debugging sessions.)*  

---

## 5. Business Questions & Insights

- **Business Questions Explored:**  
  1. *(Example: Who are the top customers by revenue?)*  
  2. *(Example: What factors contribute to student dropout?)*  
  3. *(Example: Which genres/actors perform best in ratings?)*  

- **Dashboards / Queries:**  
  *(Add screenshots, SQL snippets, or summaries of dashboards created in Metabase.)*  

- **Key Insights:**  
  - *(Highlight 1–2 interesting findings. Example: “Rock was the top genre in North America, while Latin genres dominated in South America.”)*  

---

## 6. Key Learnings

- **Technical Learnings:**  
  *(E.g., SQL joins, window functions, dbt builds/tests, schema design.)*  

- **Team Learnings:**  
  *(E.g., collaboration in shared environments, version control, importance of documentation.)*  

- **Real-World Connection:**  
  *(How this exercise relates to actual data engineering workflows in industry.)*  

---

## 7. Future Improvements

- **Next Steps with More Time:**  
  *(E.g., add orchestration with Airflow/Prefect, implement testing, optimize queries, handle larger datasets.)*  

- **Generalization:**  
  *(How this workflow could be applied to other datasets or business domains.)*  
