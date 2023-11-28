
select
	calen.date_id as Date_ID
	, seller.activation_date as Activation_Date
	, seller.seller_id as seller_ID
	, seller.name as seller_Name
	, seller.sales_manager_name as Sales_Manager_Name
	, feeds.processed_offers_count as Qnt_Proc_Offers
	, count(distinct assort.goods_id) as Qnt_Goods
	, count(distinct gd.goods_id) as Qnt_seller_Makes_Goods
from DBProjects.dbo.seller as seller
inner join DBProjects.dbo.calendar as calen
	on calen.date_id between seller.activation_date and DATEADD(day, 7, seller.activation_date)
left join
	(
	select
		cast(feed_date as date) as feed_date
		, seller_id
		, processed_offers_count
	from DBProjects.dbo.imported_offers_feeds
	where
		process_status<>'not_successfully_processed'
		and cast(feed_date as date)>='20220101'
	) as feeds on feeds.seller_id=seller.seller_id
		and feeds.feed_date=calen.date_id
left join
	(
	select
		cast(write_date as date) as match_date
		, seller_id
		, goods_id
	from DBProjects.dbo.seller_x_suggest_blacklist
	where
		auto_confirm=1
		and cast(write_date as date)>='20220101'
	) as assort on assort.seller_id=feeds.seller_id
		and assort.match_date=calen.date_id
left join
	(
	select
		cast(write_date as date) as write_date
		, seller_id
		, goods_id
	from DBProjects.dbo.seller_x_suggest_blacklist
	where
		goods_id like '6%'
		and cast(write_date as date)>='20220101'
	) as gd on gd.write_date=calen.date_id
		and gd.seller_id=feeds.seller_id
		and gd.goods_id=assort.goods_id
where
    seller.is_test_seller=0
    and seller.is_deleted=0
    and seller.inn<>'0000000000'
    and seller.inn<>'n/a'
    and seller.name not like 'test%'
    and seller.name not like '%testtest%'
    and seller.name not like 'thisisatest'
	and cast(seller.create_date as date)>='20220101'
group by
	calen.date_id
	, seller.activation_date
	, seller.seller_id
	, seller.name
	, seller.sales_manager_name
	, processed_offers_count