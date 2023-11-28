

--join all tables of sellers activation process

SELECT	sellers.seller_id
		, sellers.seller_name
		, sellers.attract_ways
		, busipart.business_partner_name
		, itpart.it_partner_name
		, logschemes.logistic_scheme_name
		, sellers.registration_date
		, docs.ein_final_confirm_date
		, docs.ein_first_decline_date
		, docs.ein_email_notice_date
		, docs.ein_email_notice_confirm_date
		, docs.ein_second_decline_date
		, docs.ein_account_manager_connecting_date
		, docs.ein_account_manager_confirm_date
		, docs.ein_final_decline_date
		, docs.documents_upload_date
		, docs.documents_final_confirm_date
		, docs.documents_first_decline_date
		, docs.documents_email_notice_date
		, docs.documents_email_notice_confirm_date
		, docs.documents_second_decline_date
		, docs.documents_account_manager_connecting_date
		, docs.documents_account_manager_confirm_date
		, docs.documents_final_decline_date
		, logist.logistic_scheme_selection_date
		, docs.agreement_date
		, wareh.warehouse_setup_date
		, goods.goods_upload_date
		, sellers.activation_date

FROM DBProjects.dbo.sellers AS sellers
LEFT JOIN DBProjects.dbo.goods AS goods ON goods.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.warehouses AS wareh ON wareh.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.seller_logistic AS logist ON logist.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.seller_documents AS docs ON docs.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.business_partners_list AS busipart ON busipart.business_partner_id=sellers.business_partner_id
LEFT JOIN DBProjects.dbo.logistic_schemes_list AS logschemes ON logschemes.logistic_scheme_id=logist.logistic_scheme_id
LEFT JOIN DBProjects.dbo.it_partners_list AS itpart ON itpart.it_partner_id=sellers.it_partner_id

WHERE sellers.seller_name <> 'test' --exclude none sellers

