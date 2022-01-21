SELECT *
FROM PortfolioProjectCovid.dbo.['coviddeath']
WHERE continent IS NOT NULL


--Select data that we are going to use
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjectCovid.dbo.['coviddeath']
WHERE continent IS NOT NULL

--Looking at total_cases vs total_deaths
--Show likelihood of dying if you contract covid in Indonesia
SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS deathPercentage
FROM PortfolioProjectCovid.dbo.['coviddeath']
WHERE location = 'Indonesia'
ORDER BY date

--Looking at total_cases vs population in Indonesia
--Show percentage of population who's got covid in Indonesia
SELECT location, date, population, total_cases,(total_cases/population)*100 AS caseRatioToPopulation
FROM PortfolioProjectCovid.dbo.['coviddeath']
WHERE location = 'Indonesia'
ORDER BY date

--Looking for countries with highest infection rate compared to their population
SELECT location, population, MAX(total_cases) AS highestInfectedCountry, MAX((total_cases/population))*100 AS percentPopulationInfected
FROM PortfolioProjectCovid.dbo.['coviddeath']
GROUP BY location,population
ORDER BY percentPopulationInfected DESC

--Looking for countries with highest total_deaths
SELECT location, MAX(CAST(total_deaths AS BIGINT)) AS totalDeathCountDescending
FROM PortfolioProjectCovid.dbo.['coviddeath']
WHERE location NOT LIKE '%World' AND location NOT LIKE '%income%' 
AND location NOT LIKE '%Europe%' AND location NOT LIKE '%Asia%' 
AND location NOT LIKE '%North%' AND location NOT LIKE '%South%' 
AND location NOT LIKE '%Africa%' AND location NOT LIKE '%Oceania%' 
AND location NOT LIKE '%Antartica%' 
GROUP BY location
ORDER BY totalDeathCountDescending DESC

--Looking for total_deaths by continent
SELECT continent, SUM(CAST(total_deaths AS BIGINT)) AS totalDeathCountDescending
FROM PortfolioProjectCovid.dbo.['coviddeath']
WHERE continent <> ''
GROUP BY continent
ORDER BY totalDeathCountDescending DESC

--Looking for total new_cases, total new_deaths and deaths% in Indonesia in 2022 per day
SELECT date, SUM(new_cases) AS TodaysConfirmedCovidCases, 
SUM(CAST(new_deaths AS BIGINT)) AS TodaysConfirmedDeaths,
SUM(CAST(new_deaths AS BIGINT))/SUM(new_cases)*100 AS TodaysDeathPercentage
FROM PortfolioProjectCovid..['coviddeath']
WHERE location = 'Indonesia' AND date >= CONVERT(date,'2022-01-01')
GROUP BY date
ORDER BY date ASC


--Looking for total population vs vaccinations (Join table) date time series
SELECT dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProjectCovid..['coviddeath'] AS dea
INNER JOIN PortfolioProjectCovid..['covidvaccined'] AS vac
ON vac.location = dea.location AND vac.date = dea.date
WHERE dea.location IN ('Indonesia', 'Malaysia','Singapore','Thailand','Philip%')
ORDER BY location, date ASC
