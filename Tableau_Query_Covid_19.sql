use [Portfolio_Projects]

--usecase 1:
--Description: It shows total no of cases and death percentage globally

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from Portfolio_Projects..Covid_D
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


--usecase 2:
--Description- continent wise splitup on the number of total death counts.
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
from Portfolio_Projects..Covid_D
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- usecase 3:
--Description: Table shows total percentage of population infected countrywise globally.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
from Portfolio_Projects..Covid_D
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--usecase 4:
--Description: Inferences about the total percentage of population infected

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
from Portfolio_Projects..Covid_D
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc