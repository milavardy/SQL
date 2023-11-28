select
    distinct
    merch.merchant_id
    , concat(users.first_name, ' ', users.last_name) as merchant_employee_name
    , users.user_login as merchant_employee_email_address
    , users.phone as merch_employee_phone
  from MDWH.dbo.merchant as merch
  left join MDWH.dbo.user_permissions as per on per.merchant_id=merch.merchant_id
  left join MDWH.dbo.users as users on users.user_id=per.user_id
  where
    users.is_deleted=0
    and users.is_active=1