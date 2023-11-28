
select 
  calen.dt as 'period'
  , tickets.business_group_name as business_group
  , sum(tickets.qnt_issue_id) as tickets
  , sum(sales.qnt_orders) as orders
  , count(distinct sales.sellerID) as sellers_with_orders
  , count(distinct tickets.seller_id) as qnt_sellers
  , count(distinct case when active_history.seller_id is not null then active_history.seller_id end) as qnt_active_sellers
  , count(distinct case when datediff(dd,tickets.create_date,calen.dt)>90 then tickets.seller_id end) as qnt_old_sellers
  , count(distinct case when datediff(dd,tickets.create_date,calen.dt)<=90 then tickets.seller_id end) as qnt_new_sellers
from 
  (
  select
    calen.date_id as dt
    , dateadd(ss,-1,dateadd (dd,1,cast(calen.date_id as datetime))) as end_of_dt
  from DBProject.dbo.calendar as calen
  where
    calen.date_id between '2022-01-01' and cast(getdate() as date)
  ) as calen 
left join
  (
  select 
    jp.seller_id
    , cast(jis.created as date) as ticket_created
    , max_acc.create_date
    , case
      when emp.department='Group "Clothes, shoes, accessories"'
      then 'Fashion'
      when emp.department='Group "Electronics"'
      then 'Electronics'
      when emp.department='Group "Consumer Goods"'
      then 'FMCG'
      when emp.department='Durable Goods Group'
      then 'Durable'
      else emp.department
      end as business_group_name
    , count(jis.issue_id) as qnt_issue_id
  from DBProject.dbo.vw_jira_issue as jis
  left join DBProject.dbo.vw_jira_project_ss_sla as jp
    on jis.issue_id=jp.issue_id and jis.base_id=jp.base_id
  left join
    (
    select
      seller_id
      , create_date
      , MAX(account_manager_id) over(partition by account_manager_name) as max_manager_id
    from DBProject.dbo.seller
    ) as max_acc on max_acc.seller_id=jp.seller_id
  left join DBProject.raw_mms_mms_security.users as users
    on users.user_id=max_acc.max_manager_id
  left join DBProject.dbo.employees as emp
    on users.email=emp.email
  where
    project_key='SS'
  group by
    jp.seller_id
    , cast(jis.created as date)
    , max_acc.create_date
    , emp.department
  ) as tickets on calen.end_of_dt>=tickets.ticket_created
left join 
  (
  select
    seller_id
    , cast(snapshot_date as datetime) as snapshot_date
    , cast(active as datetime) as active
  from
    (
    select
      distinct
      seller_id
      , snapshot_date
      , coalesce(lead(snapshot_date) over (partition by seller_id order by snapshot_date),dateadd(dd,1,getdate())) as active
    from DBProject.core.seller_snapshot
    where
      is_active_seller=1
      and snapshot_date>='20220101'
    ) as tb
  ) as active_history on tickets.seller_id=active_history.seller_id 
    and calen.end_of_dt between snapshot_date and active
left join
  (
  select
    sellerID
    , cast(OrderCreateDate as date) as OrderCreateDate
    , count(distinct OrderID) as qnt_orders
  from DBProject.dbo.FactOrderPosition
  where
    lot_type_key=2
    and IsExcluded=0
    and OrderCreateDate>='20220101'
  group by
    sellerID
    , cast(OrderCreateDate as date)
  ) as sales on sales.sellerID=active_history.seller_id
    and calen.end_of_dt>=sales.OrderCreateDate
group by
  calen.dt
  , tickets.business_group_name