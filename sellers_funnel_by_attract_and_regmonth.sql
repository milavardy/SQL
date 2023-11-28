

--count the number of sellers in funnel in the first and the last steps by attracted ways and by registration month
SELECT	sellers.attract_ways
		, FORMAT(sellers.registration_date, 'MMMM') as reg_month
		, YEAR(sellers.registration_date) as reg_year
		, COUNT(sellers.seller_id) AS qnt_all_sellers
		, COUNT(sellers.activation_date) AS qnt_activated_sellers

FROM DBProjects.dbo.sellers AS sellers
WHERE sellers.seller_name <> 'test' --exclude none sellers
GROUP BY sellers.attract_ways
		, FORMAT(sellers.registration_date, 'MMMM')
		, YEAR(sellers.registration_date)
