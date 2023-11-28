
--count the percentage of sellers which company lost in the sellers' funnel using only steps' confirmed dates by the attract ways

SELECT	sellers.attract_ways
		, COUNT(sellers.seller_id) AS qnt_all_sellers
		, CAST(100-(CAST(COUNT(docs.ein_final_confirm_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100) AS DECIMAL(4,2)) AS percent_lost_sellers_ein_confirmed
		, CAST(100-(CAST(COUNT(docs.documents_upload_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100) AS DECIMAL(4,2)) AS percent_lost_sellers_docs_upload
		, CAST(100-(CAST(COUNT(docs.documents_final_confirm_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100) AS DECIMAL(4,2)) AS percent_lost_sellers_docs_final_confirm
		, CAST(100-(CAST(COUNT(logist.logistic_scheme_selection_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100) AS DECIMAL(4,2)) AS percent_lost_sellers_logistic_scheme_selection
		, CAST(100-(CAST(COUNT(docs.agreement_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100) AS DECIMAL(4,2)) AS percent_lost_sellers_agreement
		, CAST(100-(CAST(COUNT(wareh.warehouse_setup_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100) AS DECIMAL(4,2)) AS percent_lost_sellers_warehouse_setup
		, CAST(100-(CAST(COUNT(goods.goods_upload_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100) AS DECIMAL(4,2)) AS percent_lost_sellers_goods_upload
		, CAST(100-(CAST(COUNT(sellers.activation_date) AS FLOAT)/CAST(COUNT(sellers.seller_id) AS FLOAT)*100) AS DECIMAL(4,2)) AS percent_lost_activated_sellers
FROM DBProjects.dbo.sellers AS sellers
LEFT JOIN DBProjects.dbo.goods AS goods ON goods.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.warehouses AS wareh ON wareh.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.seller_logistic AS logist ON logist.seller_id=sellers.seller_id
LEFT JOIN DBProjects.dbo.seller_documents AS docs ON docs.seller_id=sellers.seller_id

WHERE	sellers.seller_name <> 'test' --exclude none sellers
GROUP BY sellers.attract_ways