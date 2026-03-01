# Exploratory Data Analysis (SQL) – Global Layoffs Dataset


## Table of Contents
- [Project Overview](#project-overview)
- [Project Objectives](#project-objectives)
- [Dataset](#dataset)
- [Tools Used](#tools-used)
- [Key Analysis Performed](#key-analysis-performed)
- [Key Insights Identified](#key-insights-identified)
- [Business Relevance](#business-relevance)
- [SQL Skills Demonstrated](#sql-skills-demonstrated)
- [Limitations](#limitations)
- [Acknowledgements](#acknowledgements)



### Project Overview:
This project performs exploratory data analysis (EDA) on a cleaned global layoffs dataset using SQL.
The objective was to uncover trends, identify high-impact industries and companies, analyze time-based patterns, and generate insights that could support business intelligence reporting.



### Project Objectives
- Identify companies with the highest layoffs
- Detect companies that shut down completely
- Analyze layoffs by industry and country
- Examine yearly and monthly trends
- Compare funding levels to layoff magnitude
- Identify top companies by layoffs per year
- Generate cumulative layoff trends over time



### Dataset
The dataset used for this project is the cleaned dataset, layoffs.csv. The dataset contains company layoffs data for various companies spanning multiple industries in different parts of the world from the period of March 2020 up until March 2023. The table used is layoffs_staging2.



### Tools Used
-  MySQL
- Window Functions
- CTEs
- Aggregations
- Ranking Functions
- Grouping & Time Functions



### Key Analysis Performed
1. Maximum Layoffs & Full Shutdowns
   Identified:
   - Maximum employees laid off in a single record
   - Companies with percentage_laid_off = 1 (100% workforce reduction)

     ```sql
     SELECT *
      FROM layoffs_staging2
      WHERE percentage_laid_off = 1;
     ```


2. Top Companies by Total Layoffs

   ```sql
   SELECT company, SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company
    ORDER BY 2 DESC;
   ```
This analysis highlights which companies were most affected.


3. Industry-Level Impact
   - Reveals which industries experienced the highest workforce reductions.

     ```sql
     SELECT industry, SUM(total_laid_off)
      FROM layoffs_staging2
      GROUP BY industry
      ORDER BY 2 DESC;
     ```

4. Monthly Layoff Trends
   - This provides insight into short-term fluctuations.
  
```sql
SELECT SUBSTRING(date,1,7) AS month,
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY month
ORDER BY month;
```


5. Rolling Total of Layoffs (Window Function)
   - This cumulative calculation helps visualize how layoffs progressed over time.

   ```sql
   SUM(total_laid_off) OVER (ORDER BY month) AS rolling_total
   ```


6. Top Companies by Layoffs Per Year
   - This ranks companies by layoff magnitude within each year.
   - Using CTE + DENSE_RANK():
  
   ```sql
   DENSE_RANK() OVER (
    PARTITION BY year
    ORDER BY total_laid_off DESC
    )
   ```



### Key Insights Identified
- Layoffs spiked significantly during specific economic periods.
- Certain industries consistently experienced higher workforce reductions.
- Some highly funded companies still executed major layoffs.
- Workforce reductions show clear time-based clustering rather than uniform distribution.
- A small number of companies contributed disproportionately to total layoffs.



### Business Relevance
This analysis could support:
- Workforce trend reporting
- Industry risk assessment
- Economic impact analysis
- Investment risk evaluation
- Strategic workforce planning
- Government labor policy analysis



### SQL Skills Demonstrated
- Aggregation Functions (SUM, MIN, MAX)
- Date Functions (YEAR)
- Window Functions (SUM() OVER, DENSE_RANK)
- CTEs
- Grouping & Ordering
- Analytical Pattern Recognition



### Limitations
- Dataset does not include reasons for layoffs.
- No employee demographic information available.
- Funding data may not reflect real-time financial status.
- Analysis is descriptive (no predictive modeling applied).



### Acknowledgements
This exploratory data analysis project was completed as part of a guided SQL series by [Alex The Analyst](https://www.youtube.com/watch?v=QYd-RtK58VQ&list=PLUaB-1hjhk8FE_XZ87vPPSfHqb6OcM0cF&index=20).




