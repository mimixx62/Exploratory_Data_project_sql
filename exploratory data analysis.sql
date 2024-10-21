-- exploratory Data Analysis  
-- normally when you star tthe eda process you have some idea of what you are looking for sometimes  not always 
-- you can than find issues with the data and have to clean it 

Select *
from layoffs_staging2; 


select MAX(total_laid_off), MAX(percentage_laid_off)
from layoffs_staging2;

-- percentage laid off we wont work to much with because we dont know how much people are working there so its kinde useless 

Select *
from layoffs_staging2
WHERE percentage_laid_off = 1
order by funds_raised_millions desc; 
-- THESE are company that completly went under and everyone is laid off 
-- order by is by how much was invested 

Select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc; 

select min(`date`), max(`date`)
from layoffs_staging2;
-- here we can see that it was during covid and little more 2020- 2023

Select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc; 
-- here we can see the industry that got hit the most by layoffs. 
-- we see that consumer and retail got hit hard which makes sence because it was during covid times 
-- these are only assumsion 

Select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc; 
-- usa had the most laid off 

Select year (`date`), sum(total_laid_off)
from layoffs_staging2
group by year (`date`)
order by 1 desc; 
-- 2023 alot of layoffs 

Select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc; 
-- shows the stage of the company
-- this post-ipo is the googles the amazon all the large company 


Select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc; 

Select
from layoffs_staging2;

-- rolling total layoffs based on month 

select substring(`date`,1,7) as `MONTH`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `MONTH`
order by 1 asc
;

-- cte 
with rolling_total as 
(
select substring(`date`,1,7) as `MONTH`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `MONTH`
order by 1 asc
)
select `MONTH`, total_off,
sum(total_off) over(order by `MONTH`) as rolling_total
from rolling_total;


Select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc; 

Select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;




with company_year (company, years, total_laid_off) as
(
Select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), company_year_rank as
(select * , dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from company_year_rank
where ranking <= 5
;
-- ^what we are going to do is partition it based of the years we want to rank it on how many they laid off in that year 
-- so we can see who laid off the most people per year bc some like amazon laid off multiple people per year but 
-- was it the highest per year 

-- alot of the big tech companies had lots of laid off. 

-- DONT STOP HERE ANALYZE MORE 