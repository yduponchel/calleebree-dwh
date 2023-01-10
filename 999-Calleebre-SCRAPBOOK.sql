


-- --------------------------------------------------------------------------------
-- Call Hangup Reasons
-- --------------------------------------------------------------------------------


-- Breakdown of Call Reasons 
select 
	level_1_code,
	level_2_code,
	level_3_code,
	count(*) as calls
from calls 
left join dashboards.migration_files_mapping as migration on migration.file_id = calls.file_id 
where 1=1
	and sponsor_id = 103
	and migration.file_id is not null 
	and not migration.legacy_flag 
group by 1, 2, 3
;

-- Breakdown of Call Reasons | Adjusted for migration | Last call only!!! 
with last_calls as (
	select 
		contact_id,
		level_1_code,
		level_2_code,
		level_3_code,
		rank() over (partition by contact_id order by calls.date desc) as rank
	from calls 
	where 1=1
		and sponsor_id = 103
)
select 
	mappings.file_name as file_name,
	coalesce(mappings.campaign_alt, dashboards.utils_campaign_mapping(campaigns.id, campaigns.name)) as campaign_name,
	brands.name as brand_name,
	last_calls.level_1_code,
	last_calls.level_2_code,
	last_calls.level_3_code,
	count(*)
from last_calls 
left join contacts on contacts.id = last_calls.contact_id 
left join dashboards.migration_files_mapping as mappings on mappings.file_id = contacts.file_id 
left join campaigns on campaigns.id = contacts.campaign_id 
left join brands on brands.id = contacts.brand_id 
where 1=1
	and mappings.file_id is not null 
	and not mappings.legacy_flag 
	and rank = 1
group by 1, 2, 3, 4, 5, 6
order by 1, 2, 3, 7 desc
;

-- --------------------------------------------------------------------------------

-- Hnagup Reasons at Contact level, including some "fix" to better reflect the real outcome
select 
	case 
		when contacts.last_call_id is null and contacts.last_contacted is null then 'new' 
		when coalesce(contacts.level_1_code, calls.level_1_code) = 'open' then 'open' 
		when coalesce(contacts.level_1_code, calls.level_1_code) <> 'open' then 'closed' 
		else '???' end as level_0_code,
	case 
		when calls.level_1_code <> 'open' then calls.level_1_code
		else coalesce(contacts.level_1_code, calls.level_1_code) end as level_1_code,
	case 
		when calls.level_1_code <> 'open' then calls.level_2_code
		else coalesce(contacts.level_2_code, calls.level_2_code) end as level_2_code,
	case 
		when calls.level_1_code <> 'open' then calls.level_3_code
		else coalesce(contacts.level_3_code, calls.level_3_code) end as level_3_code,
	calls.level_1_code as level_1_code_last_call,
	calls.level_2_code as level_2_code_last_call,
	calls.level_3_code as level_3_code_last_call,
	count(*) as calls,
	min(files.date_inserted) as date_min,
	max(files.date_inserted) as date_max
from contacts
left join calls on calls.id = contacts.last_call_id 
left join files on files.id = contacts.file_id 
left join dashboards.migration_files_mapping as migration on migration.file_id = contacts.file_id 
where 1=1
	and contacts.sponsor_id = 103
	and migration.file_id is not null 
	and not migration.legacy_flag 
group by 1, 2, 3, 4, 5, 6, 7
order by 8 desc
;


-- --------------------------------------------------------------------------------

-- Various checks
select count(*) from contacts where last_contacted is not null and last_call_id is null;
select count(*) from contacts where last_contacted is null and last_call_id is null;
select count(*) from contacts where last_contacted is null and last_call_id is null and level_1_code is null;
select count(*) from contacts where level_1_code is null;



-- --------------------------------------------------------------------------------
-- 
-- Agents buring leads
--
-- --------------------------------------------------------------------------------
-- -- Agents with medium to low conversion rate on argumented contacts
-- -- Agents with proportionaly high rate of short call or simply argumented calls (excluding failed calls) vs. long calls
-- -- Campaigns with low lead volume and high quality leads
-- --------------------------------------------------------------------------------

with campaign_quality as (select * from dashboards.quality_campaigns)
select 
	-- Context
	to_char(current_date - interval '42 days', 'YYYY-MM-DD') as assessment_start,
	42 as assessment_period,
	-- Hierarchy
	coalesce(sponsors.name, 'Ganira PT') as sponsor_name,
	brands.name as brand_name,
	partners.name as partner_name,
	coalesce(teams.name, partners.name || ' (default)') as team_name,
	agents.name as agent_name,
	-- Campaigns
	dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name,
--	files.name as file_name,
--	
	-- Report specific attributes
	round(round(sum(case when dashboards.utils_call_type_id(duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(duration) >= 1 then 1 else 0 end), 1) * 100.0 / campaign_quality.ratio_calls_argumented, 1) as ratio_quality_argumented,
	round(round(sum(case when dashboards.utils_call_type_id(duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(duration) >= 1 then 1 else 0 end), 1) * 100.0 / campaign_quality.ratio_calls_engaged, 1) as ratio_quality_engaged,
	-- Report specific attributes
	round(sum(case when dashboards.utils_call_type_id(duration) >= 1 then 1 else 0 end) * 100.0 / count(*), 1) as ratio_calls_handled,
	round(sum(case when dashboards.utils_call_type_id(duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(duration) >= 1 then 1 else 0 end), 1) as ratio_calls_argumented,
	round(sum(case when dashboards.utils_call_type_id(duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(duration) >= 1 then 1 else 0 end), 1) as ratio_calls_engaged,
	round(sum(case when dashboards.utils_call_type_id(duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(duration) >= 2 then 1 else 0 end), 1) as ratio_calls_engaged_vs_argumented,
	-- Other KPIs
	count(distinct calls.id) as calls,
	sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
	round(sum(calls.cost)) as cost,
	round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute,
	'|' as delim
from public.calls as calls
-- left join public.feedback_reasons_text as reasons on reasons.reason_id = calls.feedback_reason  and reasons.language_id = 'en'
left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 					-- FIIXME: sponsor_id, team_id and file:id are not populated!!! 
left join public.brands as brands on brands.id = calls.brand_id 
left join public.partners as partners on partners.id = calls.partner_id
left join public.team as teams on teams.id = calls.team_id
left join public.users as users on users.id = calls.user_id 
left join public.accounts as agents on agents.id = users.account_id 
left join public.campaigns as campaigns on campaigns.id = calls.campaign_id
left join campaign_quality on  campaign_quality.sponsor_name = coalesce(sponsors.name, 'Ganira PT') and campaign_quality.brand_name = brands.name and campaign_quality.campaign_name = dashboards.utils_campaign_mapping(campaigns.id, campaigns.name)
where 1=1
--	and calls.sponsor_id = 103
	and calls.brand_id in ( 3, 5 ) 
	and calls.date > current_date - interval '42 days' -- 6 weeks
group by 1, 2, 3, 4, 5, 6, 7, 8, campaign_quality.sponsor_name, campaign_quality.brand_name, campaign_quality.campaign_name, campaign_quality.ratio_calls_argumented, campaign_quality.ratio_calls_engaged
having sum(case when dashboards.utils_call_type_id(duration) >= 2 then 1 else 0 end) > 25
order by 9 desc
;









