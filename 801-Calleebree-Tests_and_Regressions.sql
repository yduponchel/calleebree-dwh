-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Regression Testing & Sanity Checks
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

-- List all tables & views
-- $ grep "create.*view" *sql | sed -e "s/:.* dashboards./[VIEW]:\t\t/" | sed -e "s/ .*//";grep "create.*table" *sql | sed -e "s/:.* dashboards./[TABLE]:\t\t/" | sed -e "s/ .*//"

select * from dashboards.utils_check_model_inconsistent;

select * from dashboards.utils_check_dashboards_missing;

select * from dashboards.utils_check_dashboards_inconsistent;

-- --------------------------------------------------------------------------------

-- TODO: add a view that checks all public table to check the consistency of the various '_id' columns...
select length(id), count(*) from partners group by 1;
select length(id), count(*) from campaigns group by 1;
select length(campaign_id), count(*) from calls group by 1;





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

-- --------------------------------------------------------------------------------
-- Model Consistency Check
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

select * 
from contacts 
left join calls on calls.contact_id = contacts.id 
where calls.id is not null and contacts.last_contacted is null
;

-- --------------------------------------------------------------------------------

select * 
from contacts 
left join calls on calls.contact_id = contacts.id 
where calls.id is null and contacts.last_contacted is not null 
;



-- --------------------------------------------------------------------------------
-- Dashboards Reports, Utils, and related
-- --------------------------------------------------------------------------------

select * from information_schema.tables where table_schema = 'dashboards' order by table_name;
select * from information_schema.columns where table_schema = 'dashboards' order by table_name, column_name ; -- and table_name = 'table_name';
select routine_schema, routine_name, data_type, routine_type, routine_definition from information_schema.routines where routine_schema = 'dashboards' order by routine_name;


-- --------------------------------------------------------------------------------

select * from dashboards.public_dashboards;
select * from dashboards.public_widgets;

-- TODO FIXME: check that table/views listed actually do exist!!!

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

select * from dashboards.trends_reachability;


-- --------------------------------------------------------------------------------

select count(*) as count, min(month) as month_min, max(month) as month_max from dashboards.trends_monthly_quality_campaigns;
-- 
call dashboards.trends_monthly_quality_campaigns_refresh();
-- 
call dashboards.trends_monthly_quality_campaigns_kpi_global_refresh(null);
call dashboards.trends_monthly_quality_campaigns_kpi_sponsors_refresh(null);
call dashboards.trends_monthly_quality_campaigns_kpi_brands_refresh(null);
call dashboards.trends_monthly_quality_campaigns_kpi_campaigns_refresh(null);
--call dashboards.trends_monthly_quality_campaigns_kpi_files_refresh(null);
-- 
select count(*) as count, min(month) as month_min, max(month) as month_max from dashboards.trends_monthly_quality_campaigns;
select * from dashboards.trends_monthly_quality_campaigns where sponsor_id is null;
select * from dashboards.trends_monthly_quality_campaigns where sponsor_id is not null and brand_id is null;
select * from dashboards.trends_monthly_quality_campaigns where brand_id is not null and campaign_name is null;
select * from dashboards.trends_monthly_quality_campaigns where campaign_name is not null and file_id is null order by month desc, calls desc;

-- --------------------------------------------------------------------------------

select count(*) as count, min(week) as week_min, max(week) as week_max from dashboards.trends_weekly_quality_agents;
-- 
call dashboards.trends_weekly_quality_agents_refresh();
-- 
call dashboards.trends_weekly_quality_agents_kpi_global_refresh(null);
call dashboards.trends_weekly_quality_agents_kpi_sponsors_refresh(null);
call dashboards.trends_weekly_quality_agents_kpi_brands_refresh(null);
-- 
select count(*) as count, min(week) as week_min, max(week) as week_max from dashboards.trends_weekly_quality_agents;
select * from dashboards.trends_weekly_quality_agents where sponsor_id is null;
select * from dashboards.trends_weekly_quality_agents where sponsor_id is not null and brand_id is null;
select * from dashboards.trends_weekly_quality_agents where brand_id is not null and campaign_name is null;

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
-- Core model
-- --------------------------------------------------------------------------------

select 
	sum(case when sponsor_id is null then 1 else 0 end) as missing_sponsor,
	sum(case when brand_id is null then 1 else 0 end) as missing_brand,
	sum(case when partner_id is null then 1 else 0 end) as missing_partner,
	sum(case when team_id is null then 1 else 0 end) as missing_team,
	sum(case when user_id is null then 1 else 0 end) as missing_user,
	sum(case when campaign_id is null then 1 else 0 end) as missing_campaign,
	sum(case when file_id is null then 1 else 0 end) as missing_file
from calls as calls
;

select sponsors.name, count(distinct calls.campaign_id) from calls left join sponsors on sponsors.id = calls.sponsor_id group by 1;

select * from public.calls limit 1000;


