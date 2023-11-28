

select
	calen.month_key
	, count(distinct fos.seller_id) as qnt_sellers_with_offers
from DBProjects.dbo.calendar as calen
inner join
	(
	select
		fos.SnapshotDateKey
		, sellers.seller_id
	from DBProjects.dbo.FactOfferStatistic as fos
	inner join DBProjects.dbo.sellers
		on sellers.seller_id=fos.sellers_id
	where
		SnapshotDateKey between 20210101 and 20221207
		and sellers.is_test_seller=0
		and sellers.is_deleted=0
		and sellers.seller_inn<>'0000000000'
		and sellers.seller_inn<>'n/a'
		and sellers.seller_name not like 'test%'
		and sellers.seller_name not like '%test%'
		and sellers.seller_name not like 'uknowntest'
	group by
		fos.SnapshotDateKey
		, sellers.seller_id
	) as fos on fos.SnapshotDateKey=calen.date_key
group by
	calen.month_key