
--1 step - create table in DB
CREATE TABLE DatabasesProjects.dbo.it_partners_list
	(
	it_partner_id INT
	, it_partner_name NVARCHAR(50)
	)


--2 step - choose data from the file
BULK INSERT DatabasesProjects.dbo.it_partners_list
	FROM
	'C:\Users\User\Desktop\Data_Analytics\SQL\raw_data\it_partners_list.txt'
	WITH (firstrow=2,codepage=1251)


--3 step - check data
SELECT * FROM DatabasesProjects.dbo.it_partners_list