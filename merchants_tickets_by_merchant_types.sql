with 

calen as
  (
  select
    calen.date_id as dt
    , dateadd(ss,-1,dateadd (dd,1,cast(calen.date_id as datetime))) as end_of_dt
  from MDWH.dbo.calendar as calen
  where 
    calen.date_id between '2022-01-01' and cast(getdate() as date)
  )

, active_history as
  (
  select
    merchant_id
    , cast(snapshot_date as datetime) as snapshot_date
    , cast(active as datetime) as active
  from
    (
    select
      distinct
      merchant_id
      , snapshot_date
      , coalesce(lead(snapshot_date) over (partition by merchant_id order by snapshot_date),dateadd(dd,1,getdate())) as active
    from MDWH.core.merchant_snapshot
    where
      is_active_merchant=1
    ) as tb
  )

, tickets as
  (
  select 
    jis.issue_id
    , jis.base_id
    , jis.issue_num
    , jp.merchant_id
    , cast(jis.created as date) as ticket_created
    , max_acc.create_date
    , case
      when emp.department='Group "Clothes, shoes, accessories"'
      then 'Fashion'
      when emp.department='Group "Electronics"'
      then 'БТиЭ'
      when emp.department='Group "Consumer Goods"'
      then 'FMCG'
      when emp.department='Group "Durable Goods"'
      then 'Durable'
      else emp.department
      end as business_group_name
  from MDWH.dbo.vw_jira_issue as jis
  left join MDWH.dbo.vw_jira_project_ss_sla as jp
    on jis.issue_id=jp.issue_id and jis.base_id=jp.base_id
  left join
    (
    select
      merchant_id
      , create_date
      , MAX(account_manager_id) over(partition by account_manager_name) as max_manager_id
    from MDWH.dbo.merchant
    ) as max_acc on max_acc.merchant_id=jp.merchant_id
  left join mdwh.raw_mms_mms_security.users as users
    on users.user_id=max_acc.max_manager_id
  left join MDWH.dbo.employees as emp
    on users.email=emp.email
  where
    project_key='SS'
  )

, sales as
  (
  select
    MerchantID
    , cast(OrderCreateDate as date) as OrderCreateDate
    , count(distinct OrderID) as qnt_orders
  from MDWH.dbo.FactOrderPosition
  where
    lot_type_key=2
    and IsExcluded=0
    and OrderCreateDate between '20220101' and cast(getdate() as date)
  group by
    MerchantID
    , cast(OrderCreateDate as date)
  )

select 
  calen.dt as 'Period'
--  , sales.OrderCreateDate as 'Дата заказа'
  , tickets.business_group_name as 'Business Group'
  , count(distinct tickets.issue_id) as 'Tickets'
  , sum(sales.qnt_orders) as 'Orders'
  , count(distinct sales.MerchantID) as 'Merchants with orders'
  , count(distinct tickets.merchant_id) as 'Merchants'
  , count(distinct case when active_history.merchant_id is not null then active_history.merchant_id end) as 'Active Merchants'
  , count(distinct case when datediff(dd,tickets.create_date,calen.dt)>90 then tickets.merchant_id end) as 'Old Merchants'
  , count(distinct case when datediff(dd,tickets.create_date,calen.dt)<=90 then tickets.merchant_id end) as 'New Merchants'
from calen 
left join tickets on calen.end_of_dt>=tickets.ticket_created
left join active_history on tickets.merchant_id=active_history.merchant_id 
  and calen.end_of_dt between snapshot_date and active
left join sales on sales.MerchantID=active_history.merchant_id
  and calen.end_of_dt>=sales.OrderCreateDate
group by
  calen.dt
  , tickets.business_group_name
--  , sales.OrderCreateDate