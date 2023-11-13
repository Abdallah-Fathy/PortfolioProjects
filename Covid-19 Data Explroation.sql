select * 
from CovidDeaths
where continent is not null
order by 3, 4

select *  
from CovidVaccinations
order by 3, 4

-- Select Data that are going to using 

select location, date, total_cases, new_cases, total_deaths, population 
from CovidDeaths
where continent is not null
order by 1, 2

-- Looking Total Casaes VS Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location = 'Egypt' and continent is not null
order by 1, 2

-- Looking At  Total Cases VS population

select location, date, population, total_cases, (total_cases/population)*100 as PercentageInfected
from CovidDeaths
--where location = 'Egypt'
where continent is not null
order by 1, 2


-- Looking at countries with Highest Infection Rate Compared to popualtion

select location, population, MAX(total_cases) as HeighestInfectionCount,
		MAX((total_cases/population))*100 as PercentageInfected
from CovidDeaths
--where location = 'Egypt'
where continent is not null
Group by location, population
order by  PercentageInfected desc

-- Showing countries with Highest death count popualtion

select location, MAX(total_deaths) as TotalDeathCount
from CovidDeaths
--where location = 'Egypt'
where continent is not null
Group by location
order by  TotalDeathCount desc



-- Showing the continents with the highest death count per population

select continent, MAX(total_deaths) as TotalDeathCount
from CovidDeaths
--where location = 'Egypt'
where continent is not null
Group by continent
order by  TotalDeathCount desc


-- Global Numbers


select  SUM(new_cases) Total_Cases, SUM(new_deaths) Total_Death, (SUM(new_deaths)/SUM(new_cases) * 100) as
		DeathPercentage
from CovidDeaths
where continent is not null
--group by date
order by 1, 2



-- Looking at Total Population VS Vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(Convert(int, vac.new_vaccinations)) 
		OVER  
		(partition by  dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
		--,(RollingPeopleVaccinated/population)*100 as
From CovidDeaths dea
join  CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by  2, 3


-- USE CTE

with PopvsVac (continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(Convert(int, vac.new_vaccinations)) 
		OVER  
		(partition by  dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
		--,(RollingPeopleVaccinated/population)*100 as
From CovidDeaths dea
join  CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
-- order by 2, 3
)
select * , (RollingPeopleVaccinated/population)*100 
From PopvsVac




-- TEMP TABLE

Drop table if exists #PerrcentPopulationVaccination
Create Table #PerrcentPopulationVaccination
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PerrcentPopulationVaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(vac.new_vaccinations) 
		OVER  
		(partition by  dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
		--,(RollingPeopleVaccinated/population)*100 as
From CovidDeaths dea
join  CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
order by  2, 3

select * , (RollingPeopleVaccinated/population)*100 
From #PerrcentPopulationVaccination


-- ceateing View for visualization

Create view PerrcentPopulationVaccination as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(vac.new_vaccinations) 
		OVER  
		(partition by  dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
		--,(RollingPeopleVaccinated/population)*100 as
From CovidDeaths dea
join  CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


select *
from PerrcentPopulationVaccination