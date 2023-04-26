
Select MAX(date),
		MIN(date)
From Portfolio.dbo.CovidDeaths

Select *
From Portfolio.dbo.CovidVaccinations

-- Data set is from Jan/20 -Apr/21
-- Looking at total Cases bs Total Deaths
-- Liklihood of dying if you contract covid per country

SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
 From Portfolio.dbo.CovidDeaths
 WHERE location in ('United States')
 order by location, date

-- Shows what percentage of population contracted covid

SELECT location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
 From Portfolio.dbo.CovidDeaths
 --WHERE location in ('United States')
 order by location, date

-- Looking at Countries with Highest Infection Rate compared to population

SELECT location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as  PercentPopulationInfected
 From Portfolio.dbo.CovidDeaths
 --WHERE location in ('United States')
 group by location, population
 order by PercentPopulationInfected desc

 --Looking at Countries with the Highest Death Count Per Population


SELECT location, max(total_deaths) as HighestDeathCount
 From Portfolio.dbo.CovidDeaths
 --WHERE location in ('United States')
 where continent is not null 
 group by location
 order by HighestDeathCount  desc

-- LOOKING AT CONTINENTS NOW 
--Looking at Continent with the Highest Death Count Per Population

SELECT continent, max(cast(total_deaths as int)) as TotalDeathCount
From Portfolio.dbo.CovidDeaths
 --WHERE location in ('United States')
 where continent is not null 
 group by continent
 order by TotalDeathCount  desc

-- Global numbers of total cases and deaths in the world

SELECT date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
 From Portfolio.dbo.CovidDeaths
 --WHERE location in ('United States')
 where continent is not null 
 group by date
 order by 1,2 

 --Total Global Death Percentage 

 SELECT sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
 From Portfolio.dbo.CovidDeaths
 --WHERE location in ('United States')
 where continent is not null 
 --group by date
 order by 1,2 


SELECT *
 From Portfolio.dbo.CovidDeaths as dea
 Join Portfolio.dbo.CovidVaccinations as vac
  on dea.location = vac.location
  and dea.date = vac.date

-- Looking at Total Population vs. Vaccinations , Rolling Count

SELECT dea.continent, dea.location, dea.date, dea.population, vac. new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 --RollingPeopleVaccinated/dea.population)*100
  From Portfolio.dbo.CovidDeaths as dea
 Join Portfolio.dbo.CovidVaccinations as vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null 
  order by 2,3

  -- Use CTE

WITH Pop_vs_Vac as
 (
 SELECT dea.continent, dea.location, dea.date, dea.population, vac. new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 --, RollingPeopleVaccinated/dea.population)*100
 From Portfolio.dbo.CovidDeaths as dea
 Join Portfolio.dbo.CovidVaccinations as vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null  
 )
 SELECT *, (RollingPeopleVaccinated/population)*100
  FROM Pop_vs_Vac


  ----- Temp Table
  

  Create Table #PercentpopulationVaccinated
  (
  Continent nvarchar(255),
  Location Nvarchar(255),
  Date datetime,
  Population numeric,
  New_Vaccination numeric,
  RollingPeopleVaccinated numeric
  )
  Insert into #PercentpopulationVaccinated
  Select dea.continent, dea.location, dea.date, dea.population, vac. new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 --, RollingPeopleVaccinated/dea.population)*100
 From Portfolio.dbo.CovidDeaths as dea
 Join Portfolio.dbo.CovidVaccinations as vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null  
 
 SELECT *, (RollingPeopleVaccinated/population)*100
  FROM #PercentpopulationVaccinated