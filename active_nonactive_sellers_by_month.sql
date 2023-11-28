

--count the number of activated sellers and the number of non activated sellers by registration months
--count the percentage of activated sellers from all sellers

SELECT	tb.reg_month
		, SUM(tb.qnt_activated_sellers) AS qnt_activated_sellers
		, SUM(tb.qnt_non_activated_sellers) AS qnt_non_activated_sellers
		, CAST(CAST(SUM(tb.qnt_activated_sellers) AS FLOAT)/CAST(SUM(qnt_all_sellers) AS FLOAT) AS DECIMAL(4,2)) AS percentage_activated_sellers
FROM (
	SELECT	MONTH(sellers.registration_date) AS reg_month
			, COUNT(sellers.seller_id) as qnt_all_sellers
			, IIF(sellers.activation_date IS NOT NULL, COUNT(sellers.seller_id), NULL) AS qnt_activated_sellers
			, IIF(sellers.activation_date IS NULL, COUNT(sellers.seller_id), NULL) AS qnt_non_activated_sellers

	FROM DBProjects.dbo.sellers AS sellers

	WHERE sellers.seller_name <> 'test' --exclude none sellers
	GROUP BY MONTH(sellers.registration_date)
			, sellers.activation_date
	) AS tb
GROUP BY tb.reg_month
ORDER BY 1