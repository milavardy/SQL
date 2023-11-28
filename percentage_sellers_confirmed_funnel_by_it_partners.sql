

--count the percentage of sellers in the sellers' funnel using only steps' confirmed dates by the it partners

SELECT	itpart.it_partner_name
		, COUNT(sellers.seller_id) AS qnt_all_sellers
		, CAST(CAST(COUNT(docs.ein_final_confirm_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100 AS DECIMAL(4,2)) AS percent_sellers_ein_confirmed
		, CAST(CAST(COUNT(docs.documents_upload_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100 AS DECIMAL(4,2)) AS percent_sellers_docs_upload
		, CAST(CAST(COUNT(docs.documents_final_confirm_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100 AS DECIMAL(4,2)) AS percent_sellers_docs_final_confirm
		, CAST(CAST(COUNT(logist.logistic_scheme_selection_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100 AS DECIMAL(4,2)) AS percent_sellers_logistic_scheme_selection
		, CAST(CAST(COUNT(docs.agreement_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100 AS DECIMAL(4,2)) AS percent_sellers_agreement
		, CAST(CAST(COUNT(wareh.warehouse_setup_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100 AS DECIMAL(4,2)) AS percent_sellers_warehouse_setup
		, CAST(CAST(COUNT(goods.goods_upload_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100 AS DECIMAL(4,2)) AS percent_sellers_goods_upload
		, CAST(CAST(COUNT(sellers.activation_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100 AS DECIMAL(4,2)) AS percent_activated_sellers
FROM DBProjects.dbo.sellers AS sellers
LEFT JOIN DBProjects.dbo.goods AS goods ON goods.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.warehouses AS wareh ON wareh.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.seller_logistic AS logist ON logist.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.seller_documents AS docs ON docs.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.it_partners_list AS itpart ON itpart.it_partner_id=sellers.it_partner_id

WHERE	sellers.seller_name <> 'test' --exclude none sellers
		AND sellers.attract_ways='IT_partner'
GROUP BY itpart.it_partner_name