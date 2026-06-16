# Data-Cleaning
# World Layoffs — Data Cleaning & Exploratory Data Analysis

> **SQL-based end-to-end data project** | Cleaned 2,000+ records and surfaced actionable business insights from a real-world global layoffs dataset (2020–2023).

---

## Project Overview

This project demonstrates a complete data analysis pipeline using **MySQL** — from raw, messy data to clean, query-ready insights. It covers industry-standard data cleaning practices and exploratory analysis techniques used by data analysts in professional settings.

**Dataset:** Real-world tech & startup layoff events across 50+ countries, covering companies from seed-stage startups to public giants like Amazon, Google, and Meta.

---

## Skills Demonstrated

`SQL` `MySQL` `Data Cleaning` `Exploratory Data Analysis` `Window Functions` `CTEs` `Data Standardization` `Analytical Thinking`

---

## Project Structure

```
├── layoffs.csv                   # Raw input dataset
├── Layoffs_Clean_Dataset.csv     # Cleaned output dataset
├── Data_Cleaning.sql             # Step-by-step data cleaning script
├── Portfolio project - EDA.sql   # Exploratory analysis queries
└── README.md
```

---

## Part 1: Data Cleaning

**Problem:** The raw dataset contained duplicates, inconsistent formatting, mixed data types, and missing values — making it unsuitable for analysis.

**Solution:** A structured 4-step cleaning pipeline built entirely in SQL.

| Step | Action | Technique Used |
|---|---|---|
| 1 | Remove duplicates | `ROW_NUMBER()` window function partitioned over all columns |
| 2 | Standardize text values | `TRIM()`, `LIKE` pattern matching, `UPDATE` statements |
| 3 | Fix data types | `STR_TO_DATE()` to convert text dates → `DATE` type |
| 4 | Handle nulls & blanks | Self-joins to backfill missing values; removed non-informative rows |

**Key decisions:**
- Preserved the original table by working on a staging copy — a production-safe practice.
- Used a self-join to intelligently backfill missing `industry` values where another record for the same company had a known value, rather than simply dropping rows.
- Only removed rows where **both** `total_laid_off` and `percentage_laid_off` were NULL — avoiding unnecessary data loss.

---

## Part 2: Exploratory Data Analysis

**Goal:** Answer business-relevant questions about layoff trends across companies, industries, countries, and time.

### Questions Explored

**Scale**
- What were the largest single layoff events in the dataset?
- Which well-funded companies still shut down entirely (100% laid off)?

**Company-Level**
- Which companies had the highest cumulative layoffs?
- Who were the top 5 hardest-hit companies **each year**?

**Industry & Geography**
- Which industries were hit hardest overall?
- How did layoffs distribute across countries?

**Time Trends**
- How did layoffs trend month-over-month?
- What does the rolling cumulative total look like over the full 3-year period?

### Sample Insights

- Layoffs **peaked in early 2023**, driven by post-pandemic corrections and rising interest rates
- Several companies that raised **$500M+** still shut down completely
- **Consumer, Retail, and Transportation** were among the hardest-hit industries
- The **United States** accounted for the largest share of total layoffs globally

---

## Technical Highlights

```sql
-- Rolling monthly layoff total using CTE + window function
WITH Rolling_Total AS (
  SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS total_off
  FROM layoffs_staging2
  WHERE SUBSTRING(date, 1, 7) IS NOT NULL
  GROUP BY month
  ORDER BY 1
)
SELECT month, total_off, SUM(total_off) OVER (ORDER BY month) AS rolling_total
FROM Rolling_Total;
```

```sql
-- Top 5 companies by layoffs per year using DENSE_RANK()
WITH company_year AS (
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
),
company_year_rank AS (
  SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM company_year
  WHERE years IS NOT NULL
)
SELECT * FROM company_year_rank WHERE ranking <= 5;
```

---

## How to Run

1. Import `layoffs.csv` into a MySQL database as the `layoffs` table
2. Run `Data_Cleaning.sql` → produces the cleaned `layoffs_staging2` table
3. Run `Portfolio project - EDA.sql` → explore trends and insights.