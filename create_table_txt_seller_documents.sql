

--1 step - create table in DB
CREATE TABLE DatabasesProjects.dbo.seller_documents
	(
	seller_id INT
	, ein_final_confirm_date DATETIME
	, ein_first_decline_date DATETIME
	, ein_email_notice_date DATETIME
	, ein_email_notice_confirm_date DATETIME
	, ein_second_decline_date DATETIME
	, ein_account_manager_connecting_date DATETIME
	, ein_account_manager_confirm_date DATETIME
	, ein_final_decline_date DATETIME
	, documents_upload_date DATETIME
	, documents_final_confirm_date DATETIME
	, documents_first_decline_date DATETIME
	, documents_email_notice_date DATETIME
	, documents_email_notice_confirm_date DATETIME
	, documents_second_decline_date DATETIME
	, documents_account_manager_connecting_date DATETIME
	, documents_account_manager_confirm_date DATETIME
	, documents_final_decline_date DATETIME
	, agreement_date DATETIME
	)

--2 step - choose data from the file
BULK INSERT DatabasesProjects.dbo.seller_documents
	FROM
	'C:\Users\User\Desktop\Data_Analytics\SQL\raw_data\seller_documents.txt'
	WITH (firstrow=2,codepage=1251)


--3 step - check data
SELECT * FROM DatabasesProjects.dbo.seller_documents