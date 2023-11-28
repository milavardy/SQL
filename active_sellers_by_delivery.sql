
select
	calen.month_key
	, calen.month_name
	, count(distinct seller.seller_id_all) as qnt_sellers_all
	, count(distinct seller.seller_id_tech_active) as qnt_sellers_tech_active
	, count(distinct seller.seller_id_with_offers) as qnt_sellers_with_offers
	, count(distinct seller.seller_id_nonoffers) as qnt_sellers_nonoffers
	, count(distinct actseller.seller_activated_in_date) as qnt_seller_activated_in_date
	, count(distinct actseller.seller_activated_by_insales) as qnt_seller_activated_by_insales
	, count(distinct seller.seller_display_delivery) as qnt_seller_display_delivery
	, count(distinct seller.seller_collect_by_customer) as qnt_seller_collect_by_customer
	, count(distinct seller.seller_delivery_by_seller) as qnt_seller_delivery_by_seller
	, count(distinct seller.seller_fulfillment) as qnt_seller_fulfillment
from DBProjects.dbo.dim_calendar as calen
inner join
	(
	select
		fms.SnapshotDateKey
		, fms.sellerID as seller_id_all
		, iif(fms.IsActiveseller=1, fms.sellerID, NULL) as seller_id_tech_active
		, iif(fms.IssellerWithOffers=1, fms.sellerID, NULL)as seller_id_with_offers
		, iif(fms.IssellerWithOffers=0, fms.sellerID, NULL) as seller_id_nonoffers
		, case
			when fms.seller_is_delivery_key=1 and fms.IssellerWithOffers=1
			then fms.sellerID
			end as seller_display_delivery
		, case
			when fms.seller_is_collect_by_customer_key=1 and fms.IssellerWithOffers=1
			then fms.sellerID
			end as seller_collect_by_customer
		, case
			when fms.seller_is_delivery_by_seller_key=1 and fms.IssellerWithOffers=1
			then fms.sellerID
			end as seller_delivery_by_seller
		, case
			when fms.seller_is_fulfillment_key=1 and fms.IssellerWithOffers=1
			then fms.sellerID
			end as seller_fulfillment
	from DBProjects.dbo.FactsellerStatistic as fms
	inner join DBProjects.dbo.seller as seller
		on seller.seller_id=fms.sellerID
	where
		seller.is_test_seller=0
		and seller.is_deleted=0
		and seller.inn<>'0000000000'
		and seller.inn<>'n/a'
		and seller.name not like 'test%'
		and seller.name not like '%test%'
		and seller.name not like 'unknowntest'
		and fms.SnapshotDate between '20220101' and cast(getdate()-1 as date)
	) as seller on seller.SnapshotDateKey=calen.date_key
left join
	(
	select
		seller.activation_date
		, seller.seller_id as seller_activated_in_date
		, case
			when techpar.technical_partner_key=10 or seller.seller_lead_source='insales'
			then seller.seller_id
			end as seller_activated_by_insales
	from DBProjects.dbo.seller as seller
	left join DBProjects.dbo.seller_x_technical_partner as techpar
		on seller.seller_key=techpar.seller_key
	where
		seller.is_test_seller=0
		and seller.is_deleted=0
		and seller.inn<>'0000000000'
		and seller.inn<>'n/a'
		and seller.name not like 'test%'
		and seller.name not like '%test%'
		and seller.name not like 'unknowntest'
		and seller.activation_date<=cast(getdate()-1 as date)
	) as actseller on actseller.activation_date=calen.date_id
group by
	calen.month_key
	, calen.month_name