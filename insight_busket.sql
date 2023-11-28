select
	product.MasterLevel1Name 
	, product.MasterLevel2Name 
	, product.MasterLevel3Name
	, aut.MasterLevel1Name
	, aut.MasterLevel2Name
	, aut.MasterLevel3Name
	, calen.month_key 
	, count(distinct fop.OrderID) as orders_qty
	, sum(product.GrossAmount) as GrossAmount
from DatabasesProjects.dbo.FactOrderPosition as fop
inner join 
	(
	select distinct 
		product.OrderID
		, product.MasterLevel1Name
		, product.MasterLevel2Name
		, product.MasterLevel3Name 
	from DatabasesProjects.dbo.FactOrderPosition as fop
	inner join DatabasesProjects.dbo.ProductRange as product on product.ArticleNumber =fop.ArticleNumber 
	where
		fop.IsExcluded =0
		and product.MasterLevel3Name is not null
	) as aut on aut.OrderID=fop.OrderID
inner join DatabasesProjects.dbo.ProductRange as product on product.ArticleNumber =fop.ArticleNumber  
inner join DatabasesProjects.dbo.calendar as calen on fop.OrderCreateDateKey = calen.date_key
where
	fop.IsExcluded =0 
	and product.MasterLevel3Name is not null
	and calen.month_key between 202204 and 202204
	and product.MasterLevel3Name = 'Sample'
group by
	product.MasterLevel1Name 
	, product.MasterLevel2Name 
	, product.MasterLevel3Name
	, aut.MasterLevel1Name
	, aut.MasterLevel2Name
	, aut.MasterLevel3Name
	, calen.month_key