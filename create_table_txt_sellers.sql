
--1 step - create table in DB
CREATE TABLE DatabasesProjects.dbo.sellers
	(
	seller_id INT
	, seller_name NVARCHAR(100)
	, registration_date DATETIME
	, activation_date DATETIME
	, it_partner_id INT
	, business_partner_id INT
	, attract_ways VARCHAR(30)
	)


--2 step - choose data from the file
BULK INSERT DatabasesProjects.dbo.sellers
	FROM
	'C:\Users\User\Desktop\Data_Analytics\SQL\raw_data\sellers.txt'
	WITH (firstrow=2,codepage=1251)


--3 step - check data
SELECT * FROM DatabasesProjects.dbo.sellers