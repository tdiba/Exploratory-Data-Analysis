-- EXPLORATORY DATA ANALYSIS PROJECT

select*
from layoffs_staging2;

#look at maximum of total lay offs
select max(total_laid_off)
from layoffs_staging2;

#look at maximum of total lay offs and percentage laid off
select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;
#value of 1 is percentage laid off represents 100%. there are companies who just closed down

#look at all companies where total layoff was 100%
select*
from layoffs_staging2
where percentage_laid_off = 1;

#look at all companies where total layoff was 100% and order by ones with greatest number of people laid off
select*
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

#look at sum of total laid off in each company and order by the sum of people laid off
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc; #the 2 stands for the second column next to select statement
#result shows that amazon had the highest lay offs

#Let's look at the date range that we have to have a clear ideaon the data range of the data we have
select min(`date`), max(`date`)
from layoffs_staging2;
#Starts from march 2020 to march 2023

#look at what industry got hit the most during the period of major lay offs
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

#which country was hit the most by lay offs
select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

#group by year
select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

-- Progression of Lay off
#Start at the earliest of lay offs and do a rolling sum until the very end of these layoffs
#it will be done based off the month

#pull the month from the date column
select substring(`date`,6, 2) as `month`
from layoffs_staging2;

select substring(`date`,6, 2) as `month`, sum(total_laid_off)
from layoffs_staging2
group by `month`;
#This is not a great rolling total because it includes the data from all example march of all the years instead of the month of a particular year

#we'll do one that also includes the particular year
select substring(`date`,1, 7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1, 7) is not null
group by `month`
order by 1 asc;

#we want a rolling sum of the data
with Rolling_Total as
(
select substring(`date`,1, 7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1, 7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off,  sum(total_off) over(order by `month`)  as rolling_total#we are not going topartition by anything
from Rolling_Total;

#We want to know how many people each company was laying off per year
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by company asc;

#company with highest lay offs must be ranked first with teh year they laid off the most people
with Company_Year (company, years, total_laid_off) as  #included aliases for columns in the bracket
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
)
select*
from Company_Year;

#we want to partition based on years and rank based on how many people were laid off in each company in a particular year
with Company_Year (company, years, total_laid_off) as  #included aliases for columns in the bracket
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
)
select*, dense_rank() over (partition by years order by total_laid_off desc) as ranking #we want all each years data under the correct year and order by total laid off in descending order
from Company_Year
where years is not null
order by ranking asc;

#we want to filter on the top 5 so we will make another cte
WITH Company_Year (company, years, total_laid_off) AS (
    SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY years
               ORDER BY total_laid_off DESC
           ) AS ranking
    FROM Company_Year
    WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5
ORDER BY years ASC, ranking ASC, total_laid_off DESC, company ASC;
