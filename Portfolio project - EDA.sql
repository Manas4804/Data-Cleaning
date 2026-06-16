-- Exploratory Data Analysis

SELECT 
    *
FROM
    layoffs_staging2;

SELECT 
    MAX(total_laid_off), MAX(percentage_laid_off)
FROM
    layoffs_staging2;

alter table layoffs_staging2
modify column total_laid_off int;

alter table layoffs_staging2
modify column funds_raised_millions int;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    funds_raised_millions LIKE '%NULL%';

UPDATE layoffs_staging2 
SET 
    funds_raised_millions = NULL
WHERE
    funds_raised_millions LIKE '%NULL%';


SELECT 
    *
FROM
    layoffs_staging2
WHERE
    percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT 
    MIN(`date`) min_date, MAX(`date`) max_date
FROM
    layoffs_staging2;

SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT 
    industry, SUM(total_laid_off) laid_off
FROM
    layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT 
    country, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT 
    YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT 
    stage, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT 
    SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM
    layoffs_staging2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;

with Rolling_Total as
(
select substring(`date`,1,7) as `MONTH`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `MONTH`
order by 1
) 
select `MONTH`, total_off,
sum(total_off) over(order by `MONTH`)
from Rolling_Total;

SELECT 
    company, YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company , YEAR(`date`)
ORDER BY 3 DESC;

with company_year (company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), company_year_rank as
(select *,
dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from company_year_rank 
where ranking <= 5;








































