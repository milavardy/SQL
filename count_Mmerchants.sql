select
    calen.month_key
    , calen.month_name
    , count(distinct merch.merchant_id_all) as qnt_merchants_all
    , count(distinct merch.merchant_id_tech_active) as qnt_merchants_tech_active
    , count(distinct merch.merchant_id_with_offers) as qnt_merchants_with_offers
    , count(distinct merch.merchant_id_nonoffers) as qnt_merchants_nonoffers
    , count(distinct actmerch.merch_activated_in_date) as qnt_merch_activated_in_date
    , count(distinct actmerch.merch_activated_by_insales) as qnt_merch_activated_by_insales
from MDWH.dbo.calendar as calen
inner join
  (
  select
    fms.SnapshotDateKey
    , fms.MerchantID as merchant_id_all
    , iif(fms.IsActiveMerchant=1, fms.MerchantID, NULL) as merchant_id_tech_active
    , iif(fms.IsMerchantWithOffers=1, fms.MerchantID, NULL)as merchant_id_with_offers
    , iif(fms.IsMerchantWithOffers=0, fms.MerchantID, NULL) as merchant_id_nonoffers
  from MDWH.dbo.FactMerchantStatistic as fms
  inner join MDWH.dbo.merchant as merch
    on merch.merchant_id=fms.merchantid
  where
    merch.is_test_merchant=0
    and merch.is_deleted=0
    and merch.inn<>'0000000000'
    and merch.inn<>'n/a'
    and merch.name not like 'test%'
    and merch.name not like '%testtest%'
    and merch.name not like 'doubletesttest'
    and fms.SnapshotDate between '20220101' and cast(getdate()-1 as date)
  group by
    fms.SnapshotDateKey
    , fms.MerchantID
    , fms.IsActiveMerchant
    , fms.IsMerchantWithOffers
  ) as merch on merch.SnapshotDateKey=calen.date_key
left join
  (
  select
    merch.activation_date
    , merch.merchant_id as merch_activated_in_date
    , iif(tech.technical_partner_key=10, merch.merchant_id, NULL) as merch_activated_by_insales
  from MDWH.dbo.merchant as merch
  left join MDWH.dbo.merchant_x_technical_partner as tech on merch.merchant_key=tech.merchant_key
  where
    merch.is_test_merchant=0
    and merch.is_deleted=0
    and merch.inn<>'0000000000'
    and merch.inn<>'n/a'
    and merch.name not like 'test%'
    and merch.name not like '%testtest%'
    and merch.name not like 'doubletesttest'
    and merch.activation_date<=cast(getdate()-1 as date)
  group by
    merch.activation_date
    , merch.merchant_id
    , tech.technical_partner_key
  ) as actmerch on actmerch.activation_date=calen.date_id
group by
  calen.month_key
  , calen.month_name