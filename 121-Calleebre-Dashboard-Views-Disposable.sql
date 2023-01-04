-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- dashboards
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------



-- --------------------------------------------------------------------------------
-- Call Attmpts, Reachability and Costs
-- --------------------------------------------------------------------------------

-- select * from dashboards.summary_call_statistics;

drop view if exists dashboards.summary_call_statistics;
create or replace view dashboards.summary_call_statistics as 
select 
	-- --------------------------------------------------------------------------------
	-- Context
	calls.sponsor_id,
	calls.brand_id,
	calls.partner_id,
	calls.team_id,
	null::uuid as user_id,
	calls.campaign_id,
	calls.file_id,
	-- --------------------------------------------------------------------------------
	-- Time windows
	dashboards.utils_format_year(calls.date) as year,
	dashboards.utils_format_month(calls.date) as month,
	dashboards.utils_format_week(calls.date) as week,
	dashboards.utils_format_date(calls.date) as date,
	dashboards.utils_format_day_of_week(calls.date) as day_of_week,
	-- --------------------------------------------------------------------------------
	-- Hierarchy
	sponsors.name as sponsor_name,
	brands.name as brand_name,
	partners.name as partner_name,
	teams.name as team_name,
	null::varchar(128) as agent_name,
	dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name,
	files.name as file_name,
	-- --------------------------------------------------------------------------------
	-- Report specific attributes
	dashboards.utils_call_type(calls.duration) as call_type,
--	reasons.description as hangup_reason,
	-- --------------------------------------------------------------------------------
	count(distinct calls.id) as calls,
	sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
	sum(calls.cost) as cost
-- --------------------------------------------------------------------------------
from public.calls as calls
-- left join public.feedback_reasons_text as reasons on reasons.reason_id = calls.feedback_reason  and reasons.language_id = 'en'
left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id
left join public.brands as brands on brands.id = calls.brand_id 
left join public.partners as partners on partners.id = calls.partner_id
left join public.team as teams on teams.id = calls.team_id
left join public.campaigns as campaigns on campaigns.id = calls.campaign_id
left join public.files as files on files.id = calls.file_id
where 1=1
	and calls.sponsor_id = 103
	and calls.brand_id in ( 3, 5 ) 
	and calls.date >= date_trunc('month', current_date - interval '7 months') 
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
-- having count(*) >= 10
order by 11, 14, 15
;



-- --------------------------------------------------------------------------------
-- Agent Statistics
-- --------------------------------------------------------------------------------

-- select * from dashboards.summary_agent_statistics;

drop view if exists dashboards.summary_agent_statistics;
create or replace view dashboards.summary_agent_statistics as 
select 
	-- --------------------------------------------------------------------------------
	-- Context
	calls.sponsor_id,
	calls.brand_id,
	calls.partner_id,
	calls.team_id,
	agents.id as user_id,
	calls.campaign_id,
	null::varchar(36) as file_id, -- calls.file_id
	-- --------------------------------------------------------------------------------
	-- Time windows
	dashboards.utils_format_year(calls.date) as year,
	dashboards.utils_format_month(calls.date) as month,
	dashboards.utils_format_week(calls.date) as week,
	null::char(10) as date,
	null::char(12)  as day_of_week,
	-- --------------------------------------------------------------------------------
	-- Hierarchy
	sponsors.name as sponsor_name,
	brands.name as brand_name,
	partners.name as partner_name,
	teams.name as team_name,
	agents.name as agent_name,
	dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name,
	null::varchar(256) as file_name,
	-- --------------------------------------------------------------------------------
	-- Report specific attributes
	dashboards.utils_call_type(calls.duration) as call_type,
--	reasons.description as hangup_reason,
	count(distinct calls.id) as calls,
	sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
	sum(calls.cost) as cost
	-- --------------------------------------------------------------------------------
from public.calls as calls
-- left join public.feedback_reasons_text as reasons on reasons.reason_id = calls.feedback_reason  and reasons.language_id = 'en'
left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 					-- FIIXME: sponsor_id, team_id and file:id are not populated!!! 
left join public.brands as brands on brands.id = calls.brand_id 
left join public.partners as partners on partners.id = calls.partner_id
left join public.team as teams on teams.id = calls.team_id
left join public.users as users on users.id = calls.user_id 
left join public.accounts as agents on agents.id = users.account_id 
left join public.campaigns as campaigns on campaigns.id = calls.campaign_id
-- left join public.files as files on files.id = calls.file_id
where 1=1
	and calls.sponsor_id = 103
	and calls.brand_id in ( 3, 5 ) 
	and calls.date >= date_trunc('month', current_date - interval '7 months') 
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
-- having count(*) >= 10
order by 11, 14, 15
;



-- --------------------------------------------------------------------------------
-- Contact Statistics 
-- --------------------------------------------------------------------------------

-- select * from dashboards.summary_contact_statistics;

drop view if exists dashboards.summary_contact_statistics;
create or replace view dashboards.summary_contact_statistics as 
select 
	-- --------------------------------------------------------------------------------
	-- Context
	contacts.sponsor_id,
	contacts.brand_id,
	contacts.partner_id,
	null::uuid as team_id,
	null::uuid as user_id,
	contacts.campaign_id,
	contacts.file_id,
	-- --------------------------------------------------------------------------------
	-- Time windows
	dashboards.utils_format_year(contacts.date_created) as year,
	dashboards.utils_format_month(contacts.date_created) as month,
	dashboards.utils_format_week(contacts.date_created) as week,
	dashboards.utils_format_date(contacts.date_created) as date,
	dashboards.utils_format_day_of_week(contacts.date_created) as day_of_week,
	-- --------------------------------------------------------------------------------
	-- Hierarchy
	sponsors.name as sponsor_name,
	brands.name as brand_name,
	partners.name as partner_name,
	null::varchar(128) as team_name,
	null::varchar(128) as agent_name,
	dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name,
	files.name as file_name,
	-- --------------------------------------------------------------------------------
	-- Report specific attributes
	case 
		when contacts.level_1_code is not null then contacts.level_1_code
		when calls.level_1_code = 'callback' then 'open'
		when calls.level_1_code is not null then calls.level_1_code
		when calls.id is null or contacts.last_contacted is null or rejections = 0 then 'new'
		else 'UNEXPECTED' end as reason_1,
	case 
		when contacts.level_1_code is not null then contacts.level_2_code
		when calls.level_1_code is not null then calls.level_2_code
		when calls.id is null and contacts.last_contacted is null and rejections = 0 then '-'
		else 'UNEXPECTED: ' || (case when calls.id is null then 'calls.id = null' else 'calls.id <> null' end) || ' | ' || (case when contacts.last_contacted is null then 'last_contacted = null' else 'last_contacted = ...' end) || ' | rejections=' || coalesce(rejections, -1)
			end as reason_2,
	case 
		when contacts.level_1_code is not null then contacts.level_3_code
		when calls.level_1_code is not null then calls.level_3_code
		when (calls.id is null or contacts.last_contacted is null) and (calls.id is not null or contacts.last_contacted is not null) then contacts.level_2_code
		else null end as reason_3,
	-- --------------------------------------------------------------------------------
	-- coalesce(contacts.next_contact, contacts.last_contacted, contacts.date_created) as XXX_last_touch
	-- --------------------------------------------------------------------------------
	count(distinct calls.id),
	count(distinct contacts.id) as contacts
-- --------------------------------------------------------------------------------
from public.contacts as contacts
left join public.sponsors as sponsors on sponsors.id = contacts.sponsor_id
left join public.brands as brands on brands.id = contacts.brand_id 
left join public.partners as partners on partners.id = contacts.partner_id
--left join public.team as teams on teams.id = contacts.team_id
left join public.campaigns as campaigns on campaigns.id = contacts.campaign_id
left join public.files as files on files.id = contacts.file_id
left join public.calls as calls on calls.contact_id = contacts.id and calls.date >= contacts.last_contacted - interval '120 minute' and calls.date <= contacts.last_contacted + interval '1 minute'
where 1=1
	and contacts.sponsor_id = 103
	and contacts.brand_id in ( 3, 5 ) 
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22
;


-- select level_1_code,level_2_code,level_3_code,count(*) from contacts group by 1,2,3 order by 4 desc;
-- select level_1_code,level_2_code,level_3_code,count(*) from calls group by 1,2,3 order by 4 desc;



-- --------------------------------------------------------------------------------
-- Cost Analysis
-- --------------------------------------------------------------------------------

-- select * from dashboards.details_call_cost_expensive;

drop view if exists dashboards.details_call_cost_expensive;
create or replace view dashboards.details_call_cost_expensive as 
select 
	-- --------------------------------------------------------------------------------
	-- Context
	calls.sponsor_id,
	calls.brand_id,
	calls.partner_id,
	calls.team_id,
	null::uuid as user_id,
	calls.campaign_id,
	calls.file_id,
	-- --------------------------------------------------------------------------------
	-- Time windows
	dashboards.utils_format_year(calls.date) as year,
	dashboards.utils_format_month(calls.date) as month,
	dashboards.utils_format_week(calls.date) as week,
	dashboards.utils_format_date(calls.date) as date,
	dashboards.utils_format_day_of_week(calls.date) as day_of_week,
	-- --------------------------------------------------------------------------------
	-- Hierarchy
	sponsors.name as sponsor_name,
	brands.name as brand_name,
	partners.name as partner_name,
	teams.name as team_name,
	null::varchar(128) as agent_name,
	dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name,
	files.name as file_name,
	-- --------------------------------------------------------------------------------
	-- Report specific attributes
	calls.dialed_number as contact_number,
	calls.duration as duration_seconds,
	dashboards.utils_duration_minutes(calls.duration) as duration_minutes,
	dashboards.utils_call_type(calls.duration) as call_type,
	calls.cost as cost,
	dashboards.utils_cost_per_minute(calls.duration, calls.cost) as cost_per_minute,
	dashboards.utils_cost_category(calls.duration, calls.cost) as cost_category
	-- --------------------------------------------------------------------------------
from public.calls as calls
left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 					-- FIIXME: sponsor_id, team_id and file:id are not populated!!! 
left join public.brands as brands on brands.id = calls.brand_id 
left join public.partners as partners on partners.id = calls.partner_id
left join public.team as teams on teams.id = calls.team_id
-- left join public.users as users on users.id = calls.user_id 
-- left join public.accounts as agents on agents.id = users.account_id 
left join public.campaigns as campaigns on campaigns.id = calls.campaign_id
left join public.files as files on files.id = calls.file_id
where 1=1
	and calls.sponsor_id = 103
	and calls.brand_id in ( 3, 5 ) 
	and calls.date >= date_trunc('month', current_date - interval '2 months') 
	and date_trunc('month', calls.date) > current_date - interval '2 months'
	and dashboards.utils_cost_per_minute(calls.duration, calls.cost) > 0.15
order by 11, 14, 15
;



-- --------------------------------------------------------------------------------

-- select * from dashboards.summary_call_costs;

drop view if exists dashboards.summary_call_costs;
create or replace view dashboards.summary_call_costs as 
select 
	-- --------------------------------------------------------------------------------
	-- Context
	calls.sponsor_id,
	calls.brand_id,
	calls.partner_id,
	calls.team_id,
	null::uuid as user_id,
	calls.campaign_id,
	calls.file_id,
	-- --------------------------------------------------------------------------------
	-- Time windows
	dashboards.utils_format_year(calls.date) as year,
	dashboards.utils_format_month(calls.date) as month,
	dashboards.utils_format_week(calls.date) as week,
	dashboards.utils_format_date(calls.date) as date,
	dashboards.utils_format_day_of_week(calls.date) as day_of_week,
	-- --------------------------------------------------------------------------------
	-- Hierarchy
	sponsors.name as sponsor_name,
	brands.name as brand_name,
	partners.name as partner_name,
	teams.name as team_name,
	null::varchar(128) as agent_name,
	dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name,
	files.name as file_name,
	-- --------------------------------------------------------------------------------
	-- Report specific attributes
	dashboards.utils_call_type(calls.duration) as call_type,
	dashboards.utils_cost_category(calls.duration, calls.cost) as cost_category,
	count(distinct calls.id) as calls,
	sum(calls.cost) as cost
	-- --------------------------------------------------------------------------------
from public.calls as calls
left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 					-- FIIXME: sponsor_id, team_id and file:id are not populated!!! 
left join public.brands as brands on brands.id = calls.brand_id 
left join public.partners as partners on partners.id = calls.partner_id
left join public.team as teams on teams.id = calls.team_id
-- left join public.users as users on users.id = calls.user_id 
-- left join public.accounts as agents on agents.id = users.account_id 
left join public.campaigns as campaigns on campaigns.id = calls.campaign_id
left join public.files as files on files.id = calls.file_id
where 1=1
	and calls.sponsor_id = 103
	and calls.brand_id in ( 3, 5 ) 
--	and dashboards.utils_cost_per_minute(calls.duration, calls.cost) > 0.15
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21
order by 11, 14, 15
;



-- --------------------------------------------------------------------------------
-- Reachability
-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_reachability;

drop view if exists dashboards.trends_reachability;
create or replace view dashboards.trends_reachability as  
select 
	-- --------------------------------------------------------------------------------
	-- Context
	calls.sponsor_id as sponsor_id,
	calls.brand_id as brand_id, 
	calls.partner_id as partner_id, 
	calls.team_id as team_id,  
	calls.user_id as user_id,  
	calls.campaign_id as campaign_id,
	null::varchar(36) as file_id,
	-- --------------------------------------------------------------------------------
	-- Time windows
	dashboards.utils_format_timestamp(calls.date, 'year', null, true) as year,
	dashboards.utils_format_timestamp(calls.date, 'month', null, true) as month,
	dashboards.utils_format_timestamp(calls.date, 'week', null, true) as week,
	dashboards.utils_format_timestamp(calls.date, 'day', null, true) as date,
	dashboards.utils_format_timestamp(calls.date, 'day_of_week', null, true) as day_of_week,
	dashboards.utils_format_timestamp(calls.date, 'hour', null, true) as hour,
	-- --------------------------------------------------------------------------------
	-- Hierarchy
	sponsors.name as sponsor_name,
	brands.name as brand_name,
	partners.name as partner_name,
	teams.name as team_name, 
	agents.name as agent_name, 
	dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name, 
	null::varchar(256) as file_name,
	-- --------------------------------------------------------------------------------
	-- Call statistics
	dashboards.utils_call_type(calls.duration) as call_type,
	sum(calls.duration) as total_calls
	-- --------------------------------------------------------------------------------
from public.calls as calls
left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
left join public.brands as brands on brands.id = calls.brand_id 
left join public.partners as partners on partners.id = calls.partner_id 
left join public.team as teams on teams.id = calls.team_id 
left join public.users as users on users.id = calls.user_id 
left join public.accounts as agents on agents.id = users.account_id  
left join public.campaigns as campaigns on campaigns.id = calls.campaign_id
where 1=1
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21
order by 10, 12, 19, 20
;

-- --------------------------------------------------------------------------------

-- select * from dashboards.recent_reachability;

drop view if exists dashboards.recent_reachability;
create or replace view dashboards.recent_reachability as  
select 
	-- --------------------------------------------------------------------------------
	-- Context
	calls.sponsor_id as sponsor_id,
	calls.brand_id as brand_id, 
	calls.partner_id as partner_id, 
	calls.team_id as team_id,  
	null::uuid as user_id,  
	calls.campaign_id as campaign_id,
	calls.file_id as file_id,
	-- --------------------------------------------------------------------------------
	-- Time windows
	dashboards.utils_format_year(calls.date) as year,
	dashboards.utils_format_month(calls.date) as month,
	dashboards.utils_format_week(calls.date) as week,
	dashboards.utils_format_date(calls.date) as date,
	dashboards.utils_format_day_of_week(calls.date) as day_of_week,
	dashboards.utils_format_hour(calls.date) as hour,
	-- --------------------------------------------------------------------------------
	-- Hierarchy
	sponsors.name as sponsor_name,
	brands.name as brand_name,
	partners.name as partner_name,
	teams.name as team_name, 
	null::varchar(128) as agent_name, 
	dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name, 
	files.name as file_name,
	-- --------------------------------------------------------------------------------
	-- Call statistics
	dashboards.utils_call_type(calls.duration) as call_type,
	sum(calls.duration) as total_calls
	-- --------------------------------------------------------------------------------
from public.calls as calls
left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
left join public.brands as brands on brands.id = calls.brand_id 
left join public.partners as partners on partners.id = calls.partner_id 
left join public.team as teams on teams.id = calls.team_id 
-- left join public.users as users on users.id = calls.user_id 
-- left join public.accounts as agents on agents.id = users.account_id  
left join public.campaigns as campaigns on campaigns.id = calls.campaign_id
left join public.files as files on files.id = calls.file_id
where 1=1
	and calls.date >= dashboards.utils_cutoff_date('last 3 months', true) 
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21
order by 10, 12, 19, 20
;

