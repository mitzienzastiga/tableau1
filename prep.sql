select * 
from csvwi
where country = 'Mexico'

select * 
from csvwi
where Country = 'American Samoa'
order by `Birth Rate`

/* BIRTH RATE */
/* 119 missing rows */
-- I get the list of Countries with missing values, then from that list I calculate the average for each Country
select country, count(Country), sum(`Birth Rate`), sum(`Birth Rate`)/count(Country) as av
from  csvwi
where country in ( select country from csvwi where rtrim(ltrim(`Birth Rate`)) = '' group by Country order by 1)
group by Country
order by 1

CREATE TEMPORARY TABLE BirthRate(
	Country TEXT,
    countOfBR INT,
    avgBR FLOAT
)

INSERT INTO BirthRate
	select country, 
		count(Country), 
        sum(`Birth Rate`)/count(Country)
	from  csvwi
	where country in ( select country from csvwi where rtrim(ltrim(`Birth Rate`)) = '' group by Country order by 1)
	group by Country
	order by 1

select * from birthrate

-- Filling the BirthRate missing values
UPDATE indicators_pp LEFT JOIN birthrate ON indicators_pp.Country = birthrate.Country
SET `Birth Rate` = avgBR
WHERE rtrim(ltrim(`Birth Rate`)) = ''

select * from indicators_pp order by country

/******************************************************/
/*DAYS TO START BUSINESS*/
-- 986 missing values
-- I get the list of Countries with missing values, then from that list I calculate the average for each Country
select country, count(Country), sum(`Days to Start Business`), sum(`Days to Start Business`)/count(Country) as av
from  csvwi
where country in ( select country from csvwi where rtrim(ltrim(`Days to Start Business`)) = '' group by Country order by 1)
group by Country
order by 1

CREATE TABLE DaysToStartBusiness(
	Country TEXT,
    countOfCountry INT,
    avgDaysToStartBusiness FLOAT
)


INSERT INTO DaysToStartBusiness
	select country, count(Country), sum(`Days to Start Business`)/count(Country) as av
	from  csvwi
	where country in ( select country from csvwi where rtrim(ltrim(`Days to Start Business`)) = '' group by Country order by 1)
	group by Country
	order by 1 

SELECT * FROM daystostartbusiness

-- I need another table with values after pre-processing step
-- create duplicate table
ALTER TABLE csvwi ADD id INT PRIMARY KEY AUTO_INCREMENT

CREATE TABLE IF NOT EXISTS indicators_pp 
SELECT * FROM csvwi

select count(*) from indicators_pp
describe indicators_pp

select * from indicators_pp limit 5

select * from indicators_pp

-- In the new table fill the missing values for Column 'Days to Start Business'
UPDATE indicators_pp LEFT JOIN daystostartbusiness ON indicators_pp.Country = daystostartbusiness.Country
SET `Days to Start Business` = avgDaysToStartBusiness
WHERE rtrim(ltrim(`Days to Start Business`)) = ''

select * from indicators_pp
where rtrim(ltrim(`Days to Start Business`)) = '0'

/*******************************************************************/
/*CO2 EMISSIONS*/
/*579 missing values*/
select Region, country, count(country), `Year`
from csvwi
WHERE rtrim(ltrim(`CO2 Emissions`)) = ''
group by Region, Country, `Year`
order by country, `Year`

select Country, count(country)
from csvwi
group by Country
having count(country) <> 13

select country, count(country)
from csvwi
WHERE rtrim(ltrim(`CO2 Emissions`)) = ''
group by Country
having count(country) <> 2
order by 1

/*There are 13 countries that doesnt have sufficient information per year*/
select *
from csvwi
where Country in (
	select country
	from csvwi
	where rtrim(ltrim(`CO2 Emissions`)) = ''
	group by Country
	having count(country) > 10
)
order by Country, `Year`

/* deleting 13 countries with no sufficient information from 2000-2012 *******************/
delete from indicators_pp
where country in(
	select country
	from csvwi
	where rtrim(ltrim(`CO2 Emissions`)) = ''
	group by Country
	having count(country) > 10
)
--    and country <> 'Puerto Rico'

select Region, country, count(country), `Year`
from indicators_pp
WHERE rtrim(ltrim(`CO2 Emissions`)) = ''
group by Region, Country, `Year`
order by country, `Year`

select *
from indicators_pp
WHERE rtrim(ltrim(`CO2 Emissions`)) = ''
order by country, `Year`

select country, count(Country), sum(`CO2 Emissions`)/count(Country) as av
from  indicators_pp
where country in ( select country from indicators_pp where rtrim(ltrim(`CO2 Emissions`)) = '' group by Country order by 1)
group by Country
order by 1 

CREATE TEMPORARY TABLE tmp_co2Emissions(
	Country TEXT,
    countOfCountry INT,
    avgCo2Emissions FLOAT
)

INSERT INTO tmp_co2Emissions
	select country, count(Country), sum(`CO2 Emissions`)/count(Country)
	from  indicators_pp
	where country in ( select country from indicators_pp where rtrim(ltrim(`CO2 Emissions`)) = '' group by Country order by 1)
	group by Country
	order by 1

SELECT * from tmp_co2Emissions 

UPDATE indicators_pp LEFT JOIN tmp_co2Emissions
ON indicators_pp.Country = tmp_co2Emissions.Country
SET `CO2 Emissions` = avgCo2Emissions
WHERE rtrim(ltrim(`CO2 Emissions`)) = '' 

select * from indicators_pp
order by 1

	select Country, count(Country)
	from indicators_pp
	where rtrim(ltrim(`CO2 Emissions`)) = ''
	group by Country
    order by 1
    
select * from indicators_pp
where Country = 'American Samoa'

select * from csvwi
where Country = 'American Samoa'

PREPARE stmt1 FROM 'SELECT SQRT(POW(?,2) + POW(?,2)) AS hypotenuse'
SET @a = 3
SET @b = 4
EXECUTE stmt1 USING @a, @b
DEALLOCATE PREPARE stmt1

select  `Internet Usage` , count(country)
from csvwi
group by `Internet Usage`
order by 1 desc

select * from csvwi where `Internet Usage` = 0.80  
order by 1  