
--1 step - create table in DB
CREATE TABLE DatabasesProjects.dbo.goods
	(
	seller_id INT
	, goods_upload_date DATETIME
	)


--2 step - choose data from the file
BULK INSERT DatabasesProjects.dbo.goods
	FROM
	'C:\Users\User\Desktop\Data_Analytics\SQL\raw_data\goods.txt'
	WITH (firstrow=2,codepage=1251)


--3 step - check data
SELECT * FROM DatabasesProjects.dbo.goods