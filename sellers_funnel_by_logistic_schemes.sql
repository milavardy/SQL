

--count the number of sellers in the whole sellers' funnel by the logistic schemes

SELECT	logschemes.logistic_scheme_name
		, COUNT(sellers.seller_id) AS qnt_all_sellers
		, COUNT(docs.ein_final_confirm_date) AS qnt_sellers_ein_confirmed
		, COUNT(docs.ein_first_decline_date) AS qnt_sellers_ein_first_decline
		, COUNT(docs.ein_email_notice_date) AS qnt_sellers_ein_email_notice
		, COUNT(docs.ein_email_notice_confirm_date) AS qnt_sellers_ein_email_notice_confirm
		, COUNT(docs.ein_second_decline_date) AS qnt_sellers_ein_second_decline
		, COUNT(docs.ein_account_manager_connecting_date) AS qnt_sellers_ein_account_manager_connecting
		, COUNT(docs.ein_account_manager_confirm_date) AS qnt_sellers_ein_account_manager_confirm
		, COUNT(docs.ein_final_decline_date) AS qnt_sellers_ein_final_decline
		, COUNT(docs.documents_upload_date) AS qnt_sellers_docs_upload
		, COUNT(docs.documents_final_confirm_date) AS qnt_sellers_docs_final_confirm
		, COUNT(docs.documents_first_decline_date) AS qnt_sellers_docs_first_decline
		, COUNT(docs.documents_email_notice_date) AS qnt_sellers_docs_email_notice
		, COUNT(docs.documents_email_notice_confirm_date) AS qnt_sellers_docs_email_notice_confirm
		, COUNT(docs.documents_second_decline_date) AS qnt_sellers_docs_second_decline
		, COUNT(docs.documents_account_manager_connecting_date) AS qnt_sellers_docs_account_manager_connecting
		, COUNT(docs.documents_account_manager_confirm_date) AS qnt_sellers_docs_account_manager_confirm
		, COUNT(docs.documents_final_decline_date) AS qnt_sellers_docs_final_decline
		, COUNT(logist.logistic_scheme_selection_date) AS qnt_sellers_logistic_scheme_selection
		, COUNT(docs.agreement_date) AS qnt_sellers_agreement
		, COUNT(wareh.warehouse_setup_date) AS qnt_sellers_warehouse_setup
		, COUNT(goods.goods_upload_date) AS qnt_sellers_goods_upload
		, COUNT(sellers.activation_date) AS qnt_activated_sellers

FROM DBProjects.dbo.sellers AS sellers
LEFT JOIN DBProjects.dbo.goods AS goods ON goods.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.warehouses AS wareh ON wareh.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.seller_logistic AS logist ON logist.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.seller_documents AS docs ON docs.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.logistic_schemes_list AS logschemes ON logschemes.logistic_scheme_id=logist.logistic_scheme_id

WHERE sellers.seller_name <> 'test' --exclude none sellers
GROUP BY logschemes.logistic_scheme_name