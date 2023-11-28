
--1 step - create table in DB
CREATE TABLE DatabasesProjects.dbo.business_partners_list
	(
	business_partner_id	INT
	, business_partner_name VARCHAR(50)
	)


--2 step - choose data from the file
BULK INSERT DatabasesProjects.dbo.business_partners_list
	FROM
	'C:\Users\User\Desktop\Data_Analytics\SQL\raw_data\business_partners_list.txt'
	WITH (firstrow=2,codepage=1251)


--3 step - check data
SELECT * FROM DatabasesProjects.dbo.business_partners_list