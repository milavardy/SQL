
--1 step - create table in DB
CREATE TABLE DatabasesProjects.dbo.seller_logistic
	(
	seller_id INT
	, logistic_scheme_selection_date DATETIME
	, logistic_scheme INT
	)


--2 step - choose data from the file
BULK INSERT DatabasesProjects.dbo.seller_logistic
	FROM
	'C:\Users\User\Desktop\Data_Analytics\SQL\raw_data\seller_logistic.txt'
	WITH (firstrow=2,codepage=1251)


--3 step - check data
SELECT * FROM DatabasesProjects.dbo.seller_logistic