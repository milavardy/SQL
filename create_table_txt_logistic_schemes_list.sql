
--1 step - create table in DB
CREATE TABLE DatabasesProjects.dbo.logistic_schemes_list
	(
	logistic_scheme_id INT
	, logistic_scheme_name VARCHAR(50)
	, logistic_scheme_short_name VARCHAR(10)
	)


--2 step - choose data from the file
BULK INSERT DatabasesProjects.dbo.logistic_schemes_list
	FROM
	'C:\Users\User\Desktop\Data_Analytics\SQL\raw_data\logistic_schemes_list.txt'
	WITH (firstrow=2,codepage=1251)


--3 step - check data
SELECT * FROM DatabasesProjects.dbo.logistic_schemes_list