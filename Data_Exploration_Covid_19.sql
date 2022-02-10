SET ARITHABORT OFF 
SET ANSI_WARNINGS OFF

Select *
from Portfolio_Projects..Covid_D
Where continent is not null 
order by 3,4

select * 
from Portfolio_Projects..CovidVaccine
Where continent is not null 
order by 3,4

-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
from Portfolio_Projects..Covid_D
Where continent is not null 
order by 1,2

--usecase 1:
-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Portfolio_Projects..Covid_D
Where location='India'
and continent is not null 
order by 1,2

--usecase 2:
-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
from Portfolio_Projects..Covid_D
--Where location like '%states%'
order by 1,2

--usecase 3:
-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from Portfolio_Projects..Covid_D
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc


--usecase 4:
-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
from Portfolio_Projects..Covid_D
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from Portfolio_Projects..Covid_D
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from Portfolio_Projects..Covid_D dea
join Portfolio_Projects..CovidVaccine vac
On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

