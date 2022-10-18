select * from covidproject..CovidDeaths;
select location,total_deaths from covidproject..CovidDeaths order by total_deaths DESC;

--select data
select location,date,total_cases,new_cases,total_deaths,population
from covidproject..CovidDeaths order by 1,2;

--total cases vs total deaths
select location,date,total_deaths,total_cases,(total_deaths/total_cases)*100 as mortality from covidproject..CovidDeaths where total_deaths > 0 order by 1,2 desc;

--total cases vs total deaths in states like countries
select location,date,total_deaths,total_cases,(total_deaths/total_cases)*100 as mortality from covidproject..CovidDeaths where total_deaths > 0 and location like '%lanka%' order by 1,2 desc;

--total cases vs populations
select location,date,population,total_cases,(total_cases/population)*100 as infection_Rate from covidproject..CovidDeaths where total_cases > 0 and location like '%lanka%' order by 3,4 desc;

--countries with highest infection rate
select location,MAX(total_cases) as highestInfections,MAX((total_cases/population)*100) as infection_Rate from covidproject..CovidDeaths where total_cases > 0 group by location order by infection_Rate desc;

--sri lanka highest infection rate
select location,MAX(total_cases) as highestInfections,MAX((total_cases/population)*100) as infection_Rate from covidproject..CovidDeaths where total_cases > 0 and location like '%lanka%' group by location order by infection_Rate desc;

--highest death by country
select location,MAX(cast(total_deaths as int)) as highestDeaths,MAX((cast(total_deaths as int)/population)*100) as deathRate from covidproject..CovidDeaths where total_cases > 0 and continent is not null group by location order by highestDeaths desc;

--highest deaths by continent throuh location
select location as continent,MAX(cast(total_deaths as int)) as highestDeaths,MAX((cast(total_deaths as int)/population)*100) as deathRate from covidproject..CovidDeaths where total_cases > 0 and continent is null group by location order by highestDeaths desc;


--GLOBAL LEVEL STATS
select location,date,total_deaths,total_cases,(total_deaths/total_cases)*100 as mortality from covidproject..CovidDeaths where total_deaths > 0 order by 1,2 desc;

--can't use aggregate functions within aggregate functions

--new cases and new deaths since the first death
select date, SUM(cast(new_cases as int)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths from covidproject..CovidDeaths where continent is not null and new_cases is not null group by date order by total_cases;





select * from  covidproject..CovidDeaths as d join covidproject..CovidVaccinations as v on d.location = v.location and d.date = v.date; 

--sri lanka new vaccinations per day
select d.date,d.population,cast(v.new_vaccinations as int) as new_vaccs from covidproject..CovidDeaths as d join covidproject..CovidVaccinations as v on d.location = v.location and d.date = v.date where d.continent is not null and d.location like '%lanka%' and v.new_vaccinations is not null order by 3;

--sri lanka total vaccinations per day
select d.continent,d.location,d.date,d.population,cast(v.total_vaccinations as int) as total_vacc from covidproject..CovidDeaths as d join covidproject..CovidVaccinations as v on d.location = v.location and d.date = v.date where d.continent is not null and d.location like '%lanka%' and v.total_vaccinations is not null order by 5;


select d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(convert(int,v.new_vaccinations)) over (partition by d.location) from covidproject..CovidDeaths as d join covidproject..CovidVaccinations as v on d.location = v.location and d.date=v.date where d.continent is not null order by 2,3; 


--creating a view

create view percentage_vaccinated as
select d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location,d.date) as RollPeopleVaccinated from covidproject..CovidDeaths as d join covidproject..CovidVaccinations as v on d.location = v.location and d.date = v.date where d.continent is not null;

select * from percentage_vaccinated;