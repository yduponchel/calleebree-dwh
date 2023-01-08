-- --------------------------------------------------------------------------------
-- Performance Tuning
-- --------------------------------------------------------------------------------

-- create index on public.contacts (phone);
-- create index on public.contacts (email);
-- create index on public.contacts (date_created);

-- create index on public.calls (sponsor_id);
-- create index on public.calls (file_id);
-- create index on public.calls (team_id);
-- create index on public.calls (user_id);
-- create index on public.calls (contact_id);
-- create index on public.calls (level_1_code);
-- create index on public.calls (level_2_code);
-- create index on public.calls (level_3_code);



-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Consistency & Sanity Checks
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------



-- --------------------------------------------------------------------------------
-- Dashboards
-- --------------------------------------------------------------------------------



-- List all tables & views
-- $ grep "create.*view" *sql | sed -e "s/:.* dashboards./[VIEW]:\t\t/" | sed -e "s/ .*//";grep "create.*table" *sql | sed -e "s/:.* dashboards./[TABLE]:\t\t/" | sed -e "s/ .*//"

-- Type consistency checks within core tables => what a mess!!!
select * from dashboards.utils_check_model_consistency;

-- Missing tables or columns => ok (2023-01-08)
select * from dashboards.utils_check_dashboards_missing;

-- Type consistency checks within dashboard tables & views => mess apparently due to mess in core tables
select * from dashboards.utils_check_dashboards_consistency;



-- --------------------------------------------------------------------------------
-- Core Model
-- --------------------------------------------------------------------------------



-- consistency of data within "partners" => 29 ok | 4 NOK
select length(id), count(*) from partners group by 1;

-- consistency of data within "campaigns" => ok
select length(id), count(*) from campaigns group by 1;

-- consistency of data within "calls" => ok
select length(campaign_id), count(*) from calls group by 1;

-- --------------------------------------------------------------------------------

-- IDs not set in Calls
select 
	sum(case when sponsor_id is null then 1 else 0 end) as null_sponsors,
	sum(case when brand_id is null then 1 else 0 end) as null_brands,
	sum(case when campaign_id is null then 1 else 0 end) as null_campaigns,
	sum(case when file_id is null then 1 else 0 end) as null_files,
	sum(case when partner_id is null then 1 else 0 end) as null_partners,
	sum(case when team_id is null then 1 else 0 end) as null_teams,
	sum(case when user_id is null then 1 else 0 end) as null_users
from calls;

-- --------------------------------------------------------------------------------

-- Non-E164 phone numbers
select 
	sum(case when dialed_number not like '+%' and dialed_number not like '00%' then 1 else 0 end) as format_e164,
	sum(case when dialed_number like '+%' then 1 else 0 end) as format_plus,
	sum(case when dialed_number like '00%' then 1 else 0 end) as format_00
from calls
where 1=1
	and sponsor_id = 103
;

-- --------------------------------------------------------------------------------

-- Illegal Campaign IDs
select 
	sponsors_expected.id as sponsor_id_expected,
	sponsors_expected.name as sponsor_name_expected,
	sponsors_model.id as sponsor_id_model,
	sponsors_model.name as sponsor_name_model,
	brands.id as brand_id,
	brands.name as brand_name,
	campaigns.id as campaign_id,
	campaigns.name as campaign_name
from campaigns as campaigns
left join brands as brands on brands.id = campaigns.brand_id 
left join sponsors as sponsors_expected on sponsors_expected.id = campaigns.sponsor_id 
left join sponsors as sponsors_model on sponsors_model.id = brands.sponsor_id 
where 1=0
	or campaigns.sponsor_id <> brands.sponsor_id 
	or campaigns.brand_id is null 
	or campaigns.sponsor_id is null
;

-- --------------------------------------------------------------------------------

-- Inconsistencies between "contacts" and "calls" tables
select 
--	sum(case when calls.id is null and contacts.last_contacted is null then 1 else 0 end) as no_last_call, 
	sum(case when calls.id is not null and contacts.last_contacted is not null then 1 else 0 end) as matching_last_call, 
	sum(case when calls.id is not null and contacts.last_contacted is null then 1 else 0 end) as missing_last_contacted_date, 
	sum(case when calls.id is null and contacts.last_contacted is not null then 1 else 0 end) as missing_matching_call
--	sum(case when contacts.call_id is null and contacts.last_contacted is not null then 1 else 0 end) as missing_call_id,
--	sum(case when contacts.call_id is not null and calls.id is null and contacts.last_contacted is not null then 1 else 0 end) as missing_matching_call
from contacts 
left join calls on calls.contact_id = contacts.id 
;

-- Contacts with calls missing a "last_contacted" date
select *  from contacts  left join calls on calls.contact_id = contacts.id  where calls.id is not null and contacts.last_contacted is null;

-- Contacts with a "last_contacted" date set but no associated call found
select * from contacts left join calls on calls.contact_id = contacts.id where calls.id is null and contacts.last_contacted is not null;

-- Contacts with no "dialed_number" (typically also invalid in "contacts.phone")
select count(*) from calls left join contacts on contacts.id = calls.contact_id where dialed_number = '' and contact_id is not null and contacts.phone is not null and contacts.phone = '';
select count(*) from calls where dialed_number = '';

-- --------------------------------------------------------------------------------

-- Inconsistencies and brands and sponsor of teams compared to those of their partner
-- Fundamentally, if "partners" has a "brand_id" field, than it cannot be shared!!! While some partners may be duplicated, each brand manager shall be able to set his own partners/sites...
select 
	partners.id as partner_id,
	partners.name as partner_name,
	teams.id as team_id,
	teams.name as team_name,
	partners.sponsor_id as partner_sponsor_id,
	sponsors_team.id as team_sponsor_id,
	sponsors_partner.name as partner_sponsor_name,
	sponsors_team.name as team_sponsor_name,
	partners.brand_id as partner_brand_id,
	brands_team.id as team_brand_id,
	brands_partner.name as partner_brand_name,
	brands_team.name as team_brand_name,
	partners.sponsor_id = sponsors_team.id as sponsor_check,
	partners.brand_id = brands_team.id as brand_check
from partners as partners
left join team as teams on teams.partner_id = partners.id
left join sponsors as sponsors_team on sponsors_team.id = teams.sponsor_id
left join sponsors as sponsors_partner on sponsors_partner.id = partners.sponsor_id
left join brands as brands_team on brands_team.id = teams.brand_id
left join brands as brands_partner on brands_partner.id = partners.brand_id
where 1=1
	and (1=0
		or partners.sponsor_id <> sponsors_team.id 
		or teams.id is null
		or partners.brand_id <> brands_team.id 
		)
;






-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Dashboards Reports, Widgets, and related
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

select * from information_schema.tables where table_schema = 'dashboards' order by table_name;
select * from information_schema.columns where table_schema = 'dashboards' order by table_name, column_name ; -- and table_name = 'table_name';
select routine_schema, routine_name, data_type, routine_type, routine_definition from information_schema.routines where routine_schema = 'dashboards' order by routine_name;

-- --------------------------------------------------------------------------------

select * from dashboards.public_dashboards;
select * from dashboards.public_widgets;

-- --------------------------------------------------------------------------------

select * from dashboards.summary_contact_statistics;
select * from dashboards.summary_call_statistics;
select * from dashboards.summary_agents_statistics;
select * from dashboards.details_call_cost_expensive;
select * from dashboards.summary_call_costs;
select * from dashboards.quality_campaigns;
select * from dashboards.quality_agents;

select * from dashboards.summary_quality_campaigns_monthly;

select * from dashboards.widget_cost_monthly;
select * from dashboards.widget_quality_campaigns_monthly;
select * from dashboards.widget_quality_campaigns_current;

-- --------------------------------------------------------------------------------

select * from dashboards.trends_productivity_monthly_partners;
select * from dashboards.trends_productivity_monthly_campaigns;
select * from dashboards.trends_productivity_weekly_partners;
select * from dashboards.trends_productivity_weekly_campaigns;
select * from dashboards.trends_productivity_daily_partners;
select * from dashboards.trends_productivity_daily_campaigns;
-- 
select * from dashboards.trends_productivity_daily_teams;


-- --------------------------------------------------------------------------------

-- Query time: 30 seconds
select * from dashboards.trends_reachability;







-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Core model
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------


-- Campaigns found in the "calls" table
select sponsors.name, count(distinct calls.campaign_id) as campaigns_with_calls, count(*) as calls from calls left join sponsors on sponsors.id = calls.sponsor_id group by 1;

select * from public.calls limit 1000;
select * from public.contacts limit 1000;






-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Utilities and helper functions | Regression testing
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

select dashboards.utils_duration_minutes(0 = 0);
select dashboards.utils_duration_minutes(1) = 1;
select dashboards.utils_duration_minutes(59) = 1;
select dashboards.utils_duration_minutes(60) = 1;
select dashboards.utils_duration_minutes(61) = 2;

select dashboards.utils_cost_per_minute(12, 0.15) = 0.15;
select dashboards.utils_cost_per_minute(59, 0.15) = 0.15;
select dashboards.utils_cost_per_minute(60, 0.15) = 0.15;
select dashboards.utils_cost_per_minute(61, 0.15) = 0.08;
select dashboards.utils_cost_per_minute(172, 0.48) = 0.16;
select dashboards.utils_cost_per_minute(172, 0.99) = 0.33;

select dashboards.utils_cost_category(172, 0.42);
select dashboards.utils_cost_category(172, 0.48);
select dashboards.utils_cost_category(172, 0.67);
select dashboards.utils_cost_category(172, 0.99);

select dashboards.utils_user_role(0);
select dashboards.utils_user_role(1);
select dashboards.utils_user_role(2);
select dashboards.utils_user_role(3);
select dashboards.utils_user_role(4);
select dashboards.utils_user_role(5);

select dashboards.utils_call_type(7);
select dashboards.utils_call_type(18);
select dashboards.utils_call_type(42);
select dashboards.utils_call_type(427);

select dashboards.utils_format_day_of_week(current_date);
select dashboards.utils_format_date(current_date);
select dashboards.utils_format_week(current_date);
select dashboards.utils_format_month(current_date);
select dashboards.utils_format_year(current_date);

-- --------------------------------------------------------------------------------

select dashboards.utils_ratio(2736, 100, 2);
select dashboards.utils_ratio(2736, 100, 1);
select dashboards.utils_ratio(2736, 100, 0);
select dashboards.utils_ratio(2736, 0, 0);

select dashboards.utils_percent(2736, 10000, 2);
select dashboards.utils_percent(2736, 10000, 1);
select dashboards.utils_percent(2736, 10000, 0);
select dashboards.utils_percent(2736, 0, 0);

-- --------------------------------------------------------------------------------

select dashboards.utils_generate_uuid('toto');
select dashboards.utils_generate_uuid('toto');
select dashboards.utils_generate_uuid('tata');

-- --------------------------------------------------------------------------------

select dashboards.utils_log_token('test') as token;
select dashboards.utils_logs_token('whatever') as token;

--delete from dashboards.utils_logs;
delete from dashboards.utils_logs where token in ('ffffffff11111111ffffffff11111111ffffffff11111111ffffffff11111111', '00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa');
call dashboards.utils_logs_init('ffffffff11111111ffffffff11111111ffffffff11111111ffffffff11111111' , '[TEST1] my_procedure');
call dashboards.utils_logs_init('00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa' , '[TEST1] my_procedure');
call dashboards.utils_logs_init('00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa' , '[TEST1] cheating');
call dashboards.utils_logs_event('00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa' , '[TEST1] subtask', 'some message');
call dashboards.utils_logs_event('00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa' , '[TEST1] subtask', 'another message');
call dashboards.utils_logs_event('00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa' , '[TEST1] new task', 'wtf');
--call dashboards.utils_logs_init(null, '[TEST2] my_procedure()');
--call dashboards.utils_logs_event('[TEST2] my_procedure()', null, 'whatever');
--call dashboards.utils_logs_event('[TEST2] my_procedure()', null, 'something else');

select * from dashboards.utils_logs order by date_native desc limit 5;










-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Miscellaneous
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------



-- --------------------------------------------------------------------------------
-- Calling statistics
-- --------------------------------------------------------------------------------

-- Attempts distribution
with dialed_numbers as (
	select dialed_number, count(*) as attempts 
	from calls 
	left join campaigns on campaigns.id = calls.campaign_id 
--	where calls.sponsor_id = 103 and dialed_number <> '' 
	where calls.sponsor_id = 103 and dialed_number <> '' and dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) <> '!!! TEST'
	group by 1 
	having count(*) > 3
	)
select 
	attempts,
	count(dialed_number) as contacts
from dialed_numbers
group by 1
order by 1 desc
;

-- --------------------------------------------------------------------------------

-- Numbers called too frequently
select 
	dialed_number,
	count(calls.id) as calls,
	count(distinct contact_id) as contacts,
	count(distinct file_id) as files,
	count(distinct campaign_id) as campaigns,
	count(distinct brand_id) as brands
from calls 
--left join campaigns on campaigns.id = calls.campaign_id
where 1=1
	and sponsor_id = 103
	and dialed_number <> '' 
--	and dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) <> '!!! TEST'
group by dialed_number 
having count(*) > 5
order by 2 desc, 3 desc, 4 desc
;



-- --------------------------------------------------------------------------------
-- Recycling Ratio
-- --------------------------------------------------------------------------------

-- TOO SLOW | NOT RETURNING
select 
	sponsors.id as sponsor_id,
	sponsors.name as sponsor_name,
	brands.id as brand_id,
	brands.name as brand_name,
	campaigns.id as campaign_id,
	dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_alias, 
	campaigns.name as campaign_name,
	dashboards.utils_format_month(files.date_inserted) as file_month,
	dashboards.utils_format_date(files.date_inserted) as file_date,
	files.id as file_id,
	files.name as file_name,
	count(distinct contacts.id) as file_contacts,
	count(distinct recycled.id) as file_contacts_recycled
from campaigns as campaigns
left join brands as brands on brands.id = campaigns.brand_id 
left join sponsors as sponsors on sponsors.id = campaigns.sponsor_id 
left join files as files on files.campaign_id = campaigns.id 
left join contacts as contacts on contacts.file_id = files.id 
left join contacts as recycled on (recycled.phone = contacts.phone /*or recycled.email = contacts.email*/) and recycled.date_created < contacts.date_created 
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
;

