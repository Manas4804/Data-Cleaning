-- 1. Remove Duplicate
-- 2. Standardize the Data
-- 3. Null values or Blank Values
-- 4. Remove any comlums

SELECT 
    *
FROM
    layoffs;


CREATE TABLE layoffs_staging LIKE layoffs;


SELECT 
    *
FROM
    layoffs_staging;

insert layoffs_staging
select * 
from layoffs;

SELECT 
    *
FROM
    layoffs_staging;

SELECT 
    *
FROM
    world_layoffs.layoffs_staging
;

SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`) AS row_num
	FROM 
		world_layoffs.layoffs_staging;


SELECT *
FROM (
	SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;
    
SELECT 
    *
FROM
    world_layoffs.layoffs_staging
WHERE
    company = 'Oda'
;


SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;
  

ALTER TABLE world_layoffs.layoffs_staging ADD row_num INT;

CREATE TABLE `world_layoffs`.`layoffs_staging2` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` TEXT,
    `percentage_laid_off` TEXT,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` TEXT,
    row_num INT
);

INSERT INTO `world_layoffs`.`layoffs_staging2`
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
`row_num`)
SELECT `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging;
        
        
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    row_num > 1;


DELETE FROM layoffs_staging2 
WHERE
    row_num > 1;


-- 2. Standardizing data

SELECT 
    company, TRIM(company)
FROM
    layoffs_staging2;

UPDATE layoffs_staging2 
SET 
    company = TRIM(company);

SELECT DISTINCT
    industry
FROM
    layoffs_staging2
ORDER BY 1;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry LIKE 'crypto%';

UPDATE layoffs_staging2 
SET 
    industry = 'Crypto'
WHERE
    industry LIKE 'Crypto%';

SELECT DISTINCT
    country, TRIM(TRAILING '.' FROM country)
FROM
    layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2 
SET 
    country = TRIM(TRAILING '.' FROM country)
WHERE
    country LIKE 'United States%';

SELECT 
    `date`
FROM
    layoffs_staging2;

UPDATE layoffs_staging2 
SET 
    `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` Date;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;
        
        
UPDATE layoffs_staging2 
SET 
    industry = NULL
WHERE
    industry = '';
        



SELECT 
    t1.industry, t2.industry
FROM
    layoffs_staging2 t1
        JOIN
    layoffs_staging2 t2 ON t1.company = t2.company
WHERE
    t1.industry IS NULL
        AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
        JOIN
    layoffs_staging2 t2 ON t1.company = t2.company 
SET 
    t1.industry = t2.industry
WHERE
    t1.industry IS NULL
        AND t2.industry IS NOT NULL;


SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry IS NULL;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging2 
WHERE
    total_laid_off IS NULL
    AND percentage_laid_off IS NULL;


SELECT 
    *
FROM
    layoffs_staging2;

alter table layoffs_staging2
drop column row_num;

SELECT 
    *
FROM
    layoffs_staging2;













