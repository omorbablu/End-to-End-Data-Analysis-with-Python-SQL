# End-to-End-Data-Analysis-with-Python-SQL
This repository demonstrates a complete data analysis pipeline using Python and SQL Server (SSMS). It reflects real-world skills in data collection, cleaning, processing, and analysis across two different environments—Jupyter Notebook (Python) and SQL (T-SQL)

## 📌 Project Workflow

### 1. 📥 Dataset Collection via Kaggle API

. The dataset was programmatically downloaded from Kaggle using the kaggle API.
. This ensures reproducibility and automation in the data acquisition process.

### 2. 🐍 Data Processing & Analysis in Python

. We used Pandas for:

  . Data cleaning (handling missing values, formatting issues, etc.)
  . Exploratory Data Analysis (EDA)
  . KPI calculations (sales, profit, quantity, etc.)
  . Group-by operations and time-based aggregations

### 3. 🗄️ Uploading to SQL Server (SSMS)

. After cleaning and transforming the dataset in Python, we used SQLAlchemy and to_sql() to upload the data into Microsoft SQL Server (SSMS) from Jupyter Notebook.

### 4. 🔍 Repeating the Analysis in SQL

. Once the data was in SQL Server, we replicated the core Python analyses using T-SQL queries.
. This helped in:
  . Strengthening SQL skills
  . Validating logic consistency between both tools
  . Building comparable dashboards or reports from either environment

## 🧪 Technologies Used

### . Python (Jupyter Notebook)
  . Pandas
  . SQLAlchemy
  . pyodbc
  . Kaggle API
### . SQL Server Management Studio (SSMS)
  . T-SQL Queries
  . Database schema design

### Data Source: Kaggle Dataset

## 🎯 Objective

To show how data can flow smoothly between Python and SQL, and demonstrate practical data analysis skills in both environments. This project proves your ability to:

. Work with real-world data pipelines
. Use Python for preprocessing and rapid analysis
. Use SQL for structured analysis and reporting
. Communicate insights in both notebooks and SQL scripts

## 🚀 Real-World Applications

. Business Intelligence Reports
. Data Migration Projects
. Analytics Engineering
. Portfolio Projects for Interviews
