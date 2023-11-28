
--1 step - create table in DB
CREATE TABLE DatabasesProjects.dbo.warehouses
	(
	seller_id INT
	, warehouse_setup_date DATETIME
	)


--2 step - choose data from the file
BULK INSERT DatabasesProjects.dbo.warehouses
	FROM
	'C:\Users\User\Desktop\Data_Analytics\SQL\raw_data\warehouses.txt'
	WITH (firstrow=2,codepage=1251)


--3 step - check data
SELECT * FROM DatabasesProjects.dbo.warehouses