create database Hr_analytics;
use hr_analytics;

CREATE TABLE hr_data (
    EmployeeId INT PRIMARY KEY,
    MonthlyIncome BIGINT,
    MonthlyRate INT,
	NumCompaniesWorked INT,
	Over18	VARCHAR(5),
    OverTime VARCHAR(15),
	PercentSalaryHike INT,
    PerformanceRating	INT,
    RelationshipSatisfaction INT,
	StandardHours INT,
	StockOptionLevel INT,	
    TotalWorkingYears INT,
	TrainingTimesLastYear INT,
	WorkLifeBalance INT,
	YearsAtCompany INT,
	YearsInCurrentRole INT,
	YearsSinceLastPromotion INT,
    YearsWithCurrManager INT,
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(100),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(100),
    EmployeeCount INT,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(100),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(50)
);

select @@secure_file_priv;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Hr DataSet.csv' 
INTO TABLE Hr_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from Hr_data;

-- Total_Employees
create table Tot_Emp as
SELECT COUNT(*) AS total_employees FROM hr_data;

  -- average age 
  create table Avg_Age as
  SELECT CONCAT(ROUND(AVG(Age), 1),' yrs') AS average_age FROM hr_data;

 -- attrition rate --
create table AttritionRate as 
SELECT CONCAT(ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),2),'%') AS Overall_Attrition_Rate FROM hr_data;

 -- Employees Quit
  create table Emp_quit as 
  SELECT COUNT(*) AS total_employees_quit FROM hr_data WHERE Attrition = 'Yes';

-- 1.Average hourly rate of male reaserch scientist 
create table Hr1 as
SELECT ROUND(AVG(HourlyRate), 2) AS avg_hourly_rate_male_research_scientist FROM hr_data WHERE Gender = 'Male'AND JobRole = 'Research Scientist';
  
-- 2.average attrition rate for all deparments 
create table Hr2 as
SELECT Department,CONCAT(ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2),'%') AS attrition_rate FROM hr_data
GROUP BY Department order by attrition_rate desc;

-- 3. Attrition rate Vs Monthly income stats
create table Hr3 as 
SELECT Attrition,COUNT(*) AS Employee_Count,
    ROUND(AVG(MonthlyIncome), 2) AS Avg_Monthly_Income,
    ROUND(MIN(MonthlyIncome), 2) AS Min_Monthly_Income,
    ROUND(MAX(MonthlyIncome), 2) AS Max_Monthly_Income FROM hr_data GROUP BY Attrition;

-- 4. Average working years for each Department
create table Hr4 as
SELECT Department, ROUND(AVG(TotalWorkingYears), 2) AS Avg_Working_Years FROM hr_data GROUP BY Department ORDER BY Avg_Working_Years DESC;

-- 5. Job Role Vs Work life balance
create table Hr5 as
SELECT JobRole, ROUND(AVG(WorkLifeBalance), 2) AS WorkLife_Balance FROM hr_data GROUP BY JobRole ORDER BY WorkLife_Balance DESC;

-- 6. Attrition rate Vs Year since last promotion relation
create table Hr6 as
SELECT Attrition,COUNT(*) AS Employee_Count,ROUND(AVG(YearsSinceLastPromotion), 3) AS Years_Since_Last_Promotion
FROM hr_data GROUP BY Attrition ORDER BY Attrition;

-- 7.Attrition rate Vs Education Field
 create table Hr7 as
 Select Educationfield,CONCAT(ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2),'%') AS Attrition_rate
FROM hr_data GROUP BY educationfield order by Attrition_rate desc;

-- 8.Attrition Rate Vs Gender
create table Hr8
select gender,CONCAT(ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2),'%') AS Attrition_Rate
FROM hr_data GROUP BY gender order by Attrition_Rate desc;

-- 9.Job Satisfaction vs Attrtion Rate
create table Hr9
select jobsatisfaction,CONCAT(ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2),'%') AS Attrition_Rate
FROM hr_data GROUP BY jobsatisfaction order by Attrition_Rate desc;