
select m.seller_id
	,case 
		when M.seller_key in
			(
			select SD.seller_key
			from DBProject.dbo.seller_x_self_registration_doc as SD
			left join DBProject.dbo.seller_x_self_registration_status as SS on SS.seller_key=SD.seller_key
			where
				SD.self_registration_doc_moderation_status in ('APPROVED','PROCESSING')
				and SS.legal_data_check_status in ('APPROVED','PROCESSING')
			)
		and M.seller_key not in
			(
			select SD.seller_key
			from DBProject.dbo.seller_x_self_registration_doc as SD
			left join DBProject.dbo.seller_x_self_registration_status as SS on SS.seller_key=SD.seller_key
			where SD.self_registration_doc_moderation_status not in ('APPROVED','PROCESSING')
			or SS.legal_data_check_status not in ('APPROVED','PROCESSING')
			)
		then MAX(SD.self_registration_doc_upload_dt)
		else NULL end as dt6_legal 
from DBProject.dbo.seller m
left join DBProject.dbo.seller_x_self_registration_doc as SD on SD.seller_key=M.seller_key
left join DBProject.dbo.seller_x_self_registration_status as SS on SS.seller_key=M.seller_key
group by m.seller_id, m.seller_key