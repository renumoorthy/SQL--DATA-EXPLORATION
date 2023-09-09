--Getting data from tables
select*from portfolio..coviddata
order by 3,4

select*from portfolio..covidvacinations
order by 3,4

select location,date, total_cases, new_cases, total_deaths, population 
from portfolio..coviddata
where continent is not null
order by 1,2;


--total cases vs total deaths
select location,date,total_cases,total_deaths, (total_cases/total_deaths) as deathpercent 
from portfolio..coviddata 
where location='America' and continent is not null 
order by 1,2

select location,date,total_cases,population, (total_cases/population)*100 as infectedpopulation 
from portfolio..coviddata 
where location='Asia' continent is not null
order by 1,2;

select location, population, max(total_cases), max((total_cases/population))*100 as infectedpercetage 
from portfolio..coviddata 
where continent is not null
group by location, population 
order by infectedpercetage desc;

 --Total deathcount
select location,max(total_deaths) as deathcount
from portfolio..coviddata 
where continent is not null
group by location 
order by deathcount desc

--Total deathcount for each continent

select continent,max(total_deaths) as deathcount
from portfolio..coviddata 
where continent is not null
group by continent
order by deathcount desc

--GLOBAL NUMBERS


select date, sum(new_cases) as total_newcases, sum(cast(new_deaths as int)) as total_newdeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from portfolio..coviddata
where continent is not null
group by date


--Total people vacinated
select*
from portfolio..coviddata dea
join portfolio..covidvacinations vac
on dea.location = vac.location
and dea.date = vac.date

--CTE method

with PopvsVac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from portfolio..coviddata dea
join portfolio..covidvacinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select*, (rollingpeoplevaccinated/population)*100
from PopvsVac

--Temp Table

Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar,
location nvarchar,
date datetime,
population numeric,
new_vaccinations numeric,
rollingpercentagevaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from portfolio..coviddata dea
join portfolio..covidvacinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select*, (rollingpeoplevaccinated/population)*100
from #PercentPopulationVaccinated

--create view for later visualization
create view PopvsVac as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from portfolio..coviddata dea
join portfolio..covidvacinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *
from PopvsVac









