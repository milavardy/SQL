
--count ttm and cohort of between each confirmed activation funnel steps

SELECT	sellers.seller_id --need to count unique Sellers_ID on Tableau
		, sellers.attract_ways
		, busipart.business_partner_name
		, itpart.it_partner_name
		, logschemes.logistic_scheme_name
		, CONVERT(date, sellers.registration_date) as registration_date
		, IIF(sellers.activation_date IS NOT NULL, 'activated', 'non_activated') AS seller_activation
		, CASE
			WHEN DATEDIFF(MINUTE, sellers.registration_date, sellers.activation_date)<=1440
			THEN '<=1 day'
			WHEN DATEDIFF(MINUTE, sellers.registration_date, sellers.activation_date) BETWEEN 1440 and 4320
			THEN '(1-3] days'
			WHEN DATEDIFF(MINUTE, sellers.registration_date, sellers.activation_date) BETWEEN 4321 and 10080
			THEN '(3-7] days'
			WHEN DATEDIFF(MINUTE, sellers.registration_date, sellers.activation_date) BETWEEN 10080 and 20160
			THEN '(7-14] days'
			WHEN DATEDIFF(MINUTE, sellers.registration_date, sellers.activation_date) BETWEEN 20160 and 43200
			THEN '(14-30] days'
			WHEN DATEDIFF(MINUTE, sellers.registration_date, sellers.activation_date) BETWEEN 43200 and 86400
			THEN '(30-60] days'
			WHEN DATEDIFF(MINUTE, sellers.registration_date, sellers.activation_date) BETWEEN 86400 and 129600
			THEN '(60-90] days'
			WHEN DATEDIFF(MINUTE, sellers.registration_date, sellers.activation_date) BETWEEN 86400 and 129600
			THEN '>90 days'
			END AS 'ttm_cohort'
		, DATEDIFF(MINUTE, sellers.registration_date, sellers.activation_date) AS ttm
		, DATEDIFF(MINUTE, sellers.registration_date, docs.ein_final_confirm_date) AS ttm_reg_ein
		, DATEDIFF(MINUTE, docs.ein_final_confirm_date, docs.documents_upload_date) AS ttm_ein_docupload
		, DATEDIFF(MINUTE, docs.documents_upload_date, docs.documents_final_confirm_date) AS ttm_docupload_docfinal
		, DATEDIFF(MINUTE, docs.documents_final_confirm_date, logist.logistic_scheme_selection_date) AS ttm_docfinal_logistic
		, DATEDIFF(MINUTE, logist.logistic_scheme_selection_date, docs.agreement_date) AS ttm_logistic_agreement
		, DATEDIFF(MINUTE, docs.agreement_date, wareh.warehouse_setup_date) AS ttm_agreement_warehouse
		, DATEDIFF(MINUTE, wareh.warehouse_setup_date, goods.goods_upload_date) AS ttm_warehouse_goods
		, DATEDIFF(MINUTE, goods.goods_upload_date, sellers.activation_date) AS ttm_goods_activation

FROM DBProjects.dbo.sellers AS sellers
LEFT JOIN DBProjects.dbo.goods AS goods ON goods.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.warehouses AS wareh ON wareh.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.seller_logistic AS logist ON logist.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.seller_documents AS docs ON docs.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.business_partners_list AS busipart ON busipart.business_partner_id=sellers.business_partner_id
LEFT JOIN DBProjects.dbo.logistic_schemes_list AS logschemes ON logschemes.logistic_scheme_id=logist.logistic_scheme_id
LEFT JOIN DBProjects.dbo.it_partners_list AS itpart ON itpart.it_partner_id=sellers.it_partner_id

WHERE sellers.seller_name <> 'test' --exclude none sellers

--GROUP BY sellers.seller_id
--		, sellers.attract_ways
--		, busipart.business_partner_name
--		, itpart.it_partner_name
--		, logschemes.logistic_scheme_name
--		, DATEDIFF(MINUTE, sellers.registration_date, sellers.activation_date)
--		, DATEDIFF(MINUTE, sellers.registration_date, docs.ein_final_confirm_date)
--		, DATEDIFF(MINUTE, docs.ein_final_confirm_date, docs.documents_upload_date)
--		, DATEDIFF(MINUTE, docs.documents_upload_date, docs.documents_final_confirm_date)
--		, DATEDIFF(MINUTE, docs.documents_final_confirm_date, logist.logistic_scheme_selection_date)
--		, DATEDIFF(MINUTE, logist.logistic_scheme_selection_date, docs.agreement_date)
--		, DATEDIFF(MINUTE, docs.agreement_date, wareh.warehouse_setup_date)
--		, DATEDIFF(MINUTE, wareh.warehouse_setup_date, goods.goods_upload_date)
--		, DATEDIFF(MINUTE, goods.goods_upload_date, sellers.activation_date)
