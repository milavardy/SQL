

--count sellers average time-to-martket in minutes between each confirmed activation funnel steps by business partners


SELECT	busipart.business_partner_name
		, AVG(DATEDIFF(MINUTE, sellers.registration_date, sellers.activation_date)) AS ttm_reg_activation
		, AVG(DATEDIFF(MINUTE, sellers.registration_date, docs.ein_final_confirm_date)) AS ttm_reg_ein
		, AVG(DATEDIFF(MINUTE, docs.ein_final_confirm_date, docs.documents_upload_date)) AS ttm_ein_docupload
		, AVG(DATEDIFF(MINUTE, docs.documents_upload_date, docs.documents_final_confirm_date)) AS ttm_docupload_docfinal
		, AVG(DATEDIFF(MINUTE, docs.documents_final_confirm_date, logist.logistic_scheme_selection_date)) AS ttm_docfinal_logistic
		, AVG(DATEDIFF(MINUTE, logist.logistic_scheme_selection_date, docs.agreement_date)) AS ttm_logistic_agreement
		, AVG(DATEDIFF(MINUTE, docs.agreement_date, wareh.warehouse_setup_date)) AS ttm_agreement_warehouse
		, AVG(DATEDIFF(MINUTE, wareh.warehouse_setup_date, goods.goods_upload_date)) AS ttm_warehouse_goods
		, AVG(DATEDIFF(MINUTE, goods.goods_upload_date, sellers.activation_date)) AS ttm_goods_activation

FROM DBProjects.dbo.sellers AS sellers
LEFT JOIN DBProjects.dbo.goods AS goods ON goods.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.warehouses AS wareh ON wareh.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.seller_logistic AS logist ON logist.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.seller_documents AS docs ON docs.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.business_partners_list AS busipart ON busipart.business_partner_id=sellers.business_partner_id

WHERE	sellers.seller_name <> 'test' --exclude none sellers
		AND sellers.attract_ways='business_partner'
GROUP BY busipart.business_partner_name
