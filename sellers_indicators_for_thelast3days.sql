

select
	distinct
	calen.date_id -- indicator date
	, fos.qnt_articles as qnt_articles --count all articles
	, seller.qnt_sellers_all-ISNULL(blp.qnt_block_seller, 0) as qnt_sellers_without_del_test_block --sellers without tests and blocks
	, seller.qnt_sellers_tech_active --sellers technically active (if they have at least one delivery per day)
	, seller.qnt_sellers_with_offers --seller with offers
	, seller.qnt_sellers_nonoffers --sellers without offers
	, blp.qnt_block_seller --qnt sellers are blocked that day
	, blp.qnt_all_block_seller --all blocked sellers
	, actseller.qnt_seller_activated_in_date 
	, actseller.qnt_seller_activated_by_tp --by technical partner=10
	, cast(seller.qnt_sellers_with_offers as float) / 
		(cast(seller.qnt_sellers_all as float)) as share_sellers_with_offers
	, seller.qnt_sellers_all --all sellers
	, seller.qnt_sellers_all-blp.qnt_all_block_seller-seller.qnt_sellers_tech_active as qnt_seller_nonactive --non active sellers

from DBProjects.dbo.dim_calendar as calen

--all SKU
left join
	(
	select
		SnapshotDateKey
		, count(distinct item_key) as qnt_articles
	from DBProjects.dbo.FactOfferStatistic
	where
		SnapshotDate between cast(getdate()-3 as date) and cast(getdate()-1 as date)
	group by
		SnapshotDateKey
	) as fos on fos.SnapshotDateKey=calen.date_key

--all sellers, sellers technically active, sellers with offers, sellers without offers
left join
	(
	select
		fms.SnapshotDateKey
		, count(distinct fms.seller_id_all) as qnt_sellers_all
		, count(distinct fms.seller_id_tech_active) as qnt_sellers_tech_active
		, count(distinct fms.seller_id_with_offers) as qnt_sellers_with_offers
		, count(distinct fms.seller_id_nonoffers) as qnt_sellers_nonoffers 
	from
		(
		select
			fms.SnapshotDateKey
			, fms.sellerID as seller_id_all
			, iif(fms.IsActiveseller=1, fms.sellerID, NULL) as seller_id_tech_active
			, iif(fms.IssellerWithOffers=1, fms.sellerID, NULL)as seller_id_with_offers
			, iif(fms.IssellerWithOffers=0, fms.sellerID, NULL) as seller_id_nonoffers
		from DBProjects.dbo.FactsellerStatistic as fms
		inner join DBProjects.dbo.seller as seller
			on seller.seller_id=fms.sellerid
		where
			seller.is_test_seller=0
			and seller.is_deleted=0
			and seller.inn<>'0000000000'
			and seller.inn<>'n/a'
			and seller.name not like 'test%'
			and seller.name not like '%test%'
			and seller.name not like 'uknowntest'
			and fms.SnapshotDate between cast(getdate()-3 as date) and cast(getdate()-1 as date)
		group by
			fms.SnapshotDateKey
			, fms.sellerID
			, fms.IsActiveseller
			, fms.IssellerWithOffers
		) as fms
	group by
		fms.SnapshotDateKey
	) as seller on seller.SnapshotDateKey=calen.date_key

--blocked sellers
left join
	(
	select
		blp.date_id
		, sum(blp.qnt_block_seller) as qnt_block_seller
		, sum(blp.qnt_block_seller) over(order by blp.date_id) as qnt_all_block_seller
	from
		(
		select
			blparam.date_id
			, count(distinct blparam.seller_id) as qnt_block_seller
		from
			(
			select
				cast(bldet.date_id as date) as date_id
				, bldet.seller_id
				, bldet.block_type_details
				, bldet.block_type
				, bldet.rank_block
				, case
					when bldet.rank_block=1 and bldet.block_type='Blocked'
					then 'Blocked'
					when bldet.rank_block=1 and bldet.block_type='Unblocked'
					then 'Active'
					else NULL end as block_result
			from
				(
				select
					bl.date_id
					, bl.seller_id
					, bl.block_type
					, bl.block_type_details
					, row_number() over(partition by bl.seller_id order by date_id desc) as rank_block
				from
					(
					select
						distinct
						calen.date_id
						, P.seller_id
						, case 
							when P.param_code='isBlockedBysellerDelivery' and P.param_value=1
								then 'seller_blocked_SD'
							when P.param_code='isBlockedBysellerCc' and P.param_value=1
								then 'seller_blocked_CC'
							when P.param_code='isDbmBlockedByseller' and P.param_value=1
								then 'seller_blocked_DBS'
							when P.param_code='issellerActive' and P.param_value=0
								then 'manager_blocked_SD'
							when P.param_code='issellerActiveCc' and P.param_value=0
								then 'manager_blocked_CC'
							when P.param_code='isDbmLock' and P.param_value=1
								then 'manager_blocked_DBS'
							when P.param_code='isLockedByCancel' and P.param_value=1
								then 'autoblocked_SD' 
							when P.param_code='isBlockedBysellerDelivery' and P.param_value=0
								then 'seller_unblocked_SD' 
							when P.param_code='isBlockedBysellerCc' and P.param_value=0
								then 'seller_unblocked_CC'  
							when P.param_code='isDbmBlockedByseller' and P.param_value=0
								then 'manager_unblocked_SD' 
							when P.param_code='issellerActiveCc' and P.param_value=1
								then 'manager_unblocked_CC'
							when P.param_code='isDbmLock' and P.param_value=0
								then 'manager_unblocked_DBS'
							end as block_type_details
						, case 
							when P.param_code='isBlockedBysellerDelivery' and P.param_value=1
								then 'Blocked'
							when P.param_code='isBlockedBysellerCc' and P.param_value=1
								then 'Blocked' 
							when P.param_code='isDbmBlockedByseller' and P.param_value=1
								then 'Blocked'
							when P.param_code='issellerActive' and P.param_value=0
								then 'Blocked'
							when P.param_code='issellerActiveCc' and P.param_value=0
								then 'Blocked'
							when P.param_code='isDbmLock' and P.param_value=1
								then 'Blocked'
							when P.param_code='isLockedByCancel' and P.param_value=1
								then 'Blocked'
							when P.param_code='isBlockedBysellerDelivery' and P.param_value=0
								then 'Unblocked'
							when P.param_code='isBlockedBysellerCc' and P.param_value=0
								then 'Unblocked'
							when P.param_code='isDbmBlockedByseller' and P.param_value=0
								then 'Unblocked'
							when P.param_code='issellerActive' and P.param_value=1
								then 'Unblocked'
							when P.param_code='issellerActiveCc' and P.param_value=1
								then 'Unblocked'
							when P.param_code='isDbmLock' and P.param_value=0
								then 'Unblocked'
							end as block_type		
					from DBProjects.dbo.seller_param_history as P
					left join DBProjects.dbo.seller as seller on seller.seller_id=P.seller_id
					left join DBProjects.dbo.dim_calendar as calen on calen.date_id=cast(P.date as date)
					where
						seller.is_test_seller=0
						and seller.is_deleted=0
						and seller.inn<>'0000000000'
						and seller.inn<>'n/a'
						and seller.name not like 'test%'
						and seller.name not like '%test%'
						and seller.name not like 'uknowntest'
						and calen.date_id<=cast(getdate()-1 as date)
					) as bl
				where
					bl.block_type_details is not NULL
				) as bldet
			)as blparam
		where
			blparam.block_result='Blocked'
		group by
			blparam.date_id
		) as blp
	group by
		blp.date_id
		, blp.qnt_block_seller
	) as blp on blp.date_id=calen.date_id

--qnt technical partner=10 and activated in on date
left join
	(
	select
		seller.activation_date
		, count(distinct seller.seller_id) as qnt_seller_activated_in_date
		, sum(iif(tech.technical_partner_key=10, 1, 0)) as qnt_seller_activated_by_insales
	from DBProjects.dbo.seller as seller
	left join DBProjects.dbo.seller_x_technical_partner as tech on seller.seller_key=tech.seller_key
	where
		seller.is_test_seller=0
		and seller.is_deleted=0
		and seller.inn<>'0000000000'
		and seller.inn<>'n/a'
		and seller.name not like 'test%'
		and seller.name not like '%test%'
		and seller.name not like 'uknowntest'
		and seller.activation_date<=cast(getdate()-1 as date)
	group by
		seller.activation_date
	) as actseller on actseller.activation_date=calen.date_id

where
	calen.date_id between cast(getdate()-3 as date) and cast(getdate()-1 as date)