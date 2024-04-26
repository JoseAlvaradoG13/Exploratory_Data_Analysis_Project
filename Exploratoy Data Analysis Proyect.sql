-- Exploratory Data Analysis Project

SELECT *
FROM layoffs_staging2;

-- On this Exploratory Data Analysis, I dont have concrete data that I want to check, so we are going to check everything 

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- If percentage_laid_off is equal to 1, means that the company close, let´s check witch companies close in the last 2 years

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
order by funds_raised_millions Desc;

-- Let´s check how many layoffs does each company had.

SELECT company, Sum(total_laid_off)
FROM layoffs_staging2
Group By company
Order By 2 Desc;

-- cheking the date range we are using

Select min(`date`), max(`date`)
FROM layoffs_staging2;

-- Let´s check how many layoffs does each industry had

SELECT industry, Sum(total_laid_off)
FROM layoffs_staging2
Group By industry
Order By 2 Desc;

-- Let´s check how many layoffs does each country had

SELECT country, Sum(total_laid_off)
FROM layoffs_staging2
Group By country
Order By 2 Desc;

-- Let´s check how many layoffs does each year had

Select Year (`date`), Sum(total_laid_off)
FROM layoffs_staging2
group by year(`date`)
order by 1 desc;
 
Select substring(`date`,1,7) As `Month`, Sum(total_laid_off) As total_off
FROM layoffs_staging2
Where substring(`date`,1,7) iS not null
Group By `Month`
Order By 1 Asc
;

With Rolling_Total As
(
Select substring(`date`,1,7) As `Month`, Sum(total_laid_off) As total_off
FROM layoffs_staging2
Where substring(`date`,1,7) iS not null
Group By `Month`
Order By 1 Asc
)
SELECT `Month`, total_off,
Sum(total_off) Over(Order by `Month`) As rolling_total
FROM Rolling_Total;

-- On the Rolling_Total table, we can se how many people have been layoffs, per month, on the total_off column, 
-- and we can also see the  month by month progression of the layoffs


-- Let´s check how many layoffs does each company had per year 

Select company, year(`date`) as `Year`, sum(total_laid_off) AS Total
from layoffs_staging2
group by company, year(`date`)
Order by 2 desc;

-- Now let´s create a CTE, to make a rank base of how many layoffs does each company had per year, I want this rank to only show the top 10 of each year

With Company_Year (Company, Years, Total_Laid_Off) AS
(
Select company, year(`date`) as `Year`, sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), Company_Year_Rank as
(Select *,
dense_rank() over(Partition by years order by total_laid_off desc) as Ranking
From Company_Year
Where years is not null
)
Select *
from Company_Year_Rank
Where Ranking <= 10;

















