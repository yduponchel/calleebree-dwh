-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Productivity KPIs & Statistics
-- 
-- --------------------------------------------------------------------------------
-- Intervals:
-- -- Month / Week / Day / custom ('last 3 weeks' / 'last 6 weeks' / 'last 3 months')
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

-- create index on public.calls (sponsor_id);
-- create index on public.calls (team_id);
-- create index on public.calls (user_id);
-- create index on public.calls (contact_id);
-- create index on public.calls (level_1_code);
-- create index on public.calls (level_2_code);
-- create index on public.calls (level_3_code);


-- Query Time: 20 seconds
-- select * from dashboards.trends_productivity(true, true, false, false, false, true, false, 'month'); 			-- sponsor, brand, partner, team, agent, campaign, file, custom interval ('last 3 weeks' / 'last 6 weeks' / 'last 3 months')
-- select * from dashboards.trends_productivity(true, true, false, false, false, true, false, 'last 6 weeks'); 		-- sponsor, brand, partner, team, agent, campaign, file, custom interval ('last 3 weeks' / 'last 6 weeks' / 'last 3 months')

drop function if exists dashboards.trends_productivity cascade;
create or replace function dashboards.trends_productivity(_sponsor_ boolean, _brand_ boolean, _partner_ boolean, _team_ boolean, _agent_ boolean, _campaign_ boolean, _file_ boolean, _interval_ text) 
returns table (
	sponsor_id int, brand_id int, partner_id varchar(36) /*uuid*/, team_id uuid, user_id uuid, campaign_id varchar(36) /*uuid*/, file_id varchar(36) /*uuid*/,
	year char(4), month char(7), week char(7), date char(10), day_of_week char(12), custom_interval varchar(64),
	sponsor_name varchar(128), brand_name varchar(128), partner_name varchar(256), team_name varchar(128), agent_name varchar(128), campaign_name varchar(256), file_name varchar(256), 
	total_calls bigint, total_calls_handled bigint, total_calls_argumented bigint, total_calls_engaged bigint, total_calls_converted bigint, 
	total_productive_hours numeric, total_FTE numeric, total_sales bigint, total_agents bigint, total_campaigns bigint, total_calling_cost numeric, total_Calling_hours numeric, 
	percent_calls_handled numeric, percent_calls_argumented numeric, percent_calls_engaged numeric, percent_calls_converted numeric,
	ratio_sales_per_hour numeric, ratio_sales_per_agent numeric, ratio_sales_per_FTE numeric, ratio_cost_per_sale numeric, ratio_cost_per_minute numeric, ratio_calls_per_hour numeric
	) as $$
declare
	_yearly_working_days_ numeric := 200.0;
	_yearly_productive_days_ numeric := _yearly_working_days_ * 0.85; -- Accounting for working time which is not productive (non-dialing time); ex: meeting, coaching, misc... 
	_hours_per_FTE_ numeric := case 
		when _interval_ = 'month' then (8.0 * _yearly_productive_days_ / 12.0)
		when _interval_ = 'week' then (8.0 * _yearly_productive_days_ / (365.25 / 7.0))
		when _interval_ = 'day' then (8.0 * _yearly_productive_days_ / 365.25)
		else null end;
	_cutoff_ timestamp := dashboards.utils_cutoff_date(_interval_, true);
	_minimum_calling_minutes_ bigint := 15;
	_minimum_calls_handled_ bigint := 10;
	-- TODO FIXME IMPORTANT: for Elena, a lower number of productive hour is better since it shows a propertionally better agent performance
	_correction_ numeric := 0.60; -- Arbitrary correction to account for the fact that '"productive hours" over-estimate the total since any hour started is fully counted
--	_correction_ numeric := 0.85; -- Arbitrary correction to account for the fact that '"productive hours" over-estimate the total since any hour started is fully counted
begin
	return query select 
		-- --------------------------------------------------------------------------------
		-- Context
		case when _sponsor_ then calls.sponsor_id else null end as sponsor_id,
		case when _brand_ then calls.brand_id else null end as brand_id, 
		case when _partner_ then calls.partner_id else null end as partner_id, 
		case when _team_ then calls.team_id else null end as team_id,  
		case when _agent_ then calls.user_id else null end as user_id,  
		case when _campaign_ then dashboards.utils_generate_uuid(calls.brand_id || '|' || dashboards.utils_campaign_mapping(campaigns.id, campaigns.name)) else null end as campaign_id, -- TODO FIXME: use real UUID once the campaigns are cleaned!!!
--		case when _campaign_ then calls.campaign_id else null end as campaign_id,
		case when _file_ then calls.file_id else null end as file_id,  
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_timestamp_with_cutoff(calls.date, 'year', _interval_, _cutoff_)::char(4) as year,
		dashboards.utils_format_timestamp_with_cutoff(calls.date, 'month', _interval_, _cutoff_)::char(7) as month,
		dashboards.utils_format_timestamp_with_cutoff(calls.date, 'week', _interval_, _cutoff_)::char(7) as week,
		dashboards.utils_format_timestamp_with_cutoff(calls.date, 'day', _interval_, _cutoff_)::char(10) as date,
		dashboards.utils_format_timestamp_with_cutoff(calls.date, 'day_of_week', _interval_, _cutoff_)::char(12) as day_of_week,
		dashboards.utils_format_timestamp_with_cutoff(calls.date, 'custom', _interval_, _cutoff_)::varchar(64) as custom_interval,
		-- Hierarchy
		case when _sponsor_ then sponsors.name else null end as sponsor_name,
		case when _brand_ then brands.name else null end as brand_name,
		case when _partner_ then partners.name else null end as partner_name,
		case when _team_ then teams.name else null end as team_name, 
		case when _agent_ then agents.name else null end as agent_name, 
		case when _campaign_ then dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) else null end as campaign_name, 
		case when _file_ then files.name end as file_name, 
		-- --------------------------------------------------------------------------------
		-- Call Volumes
		count(calls.id) as total_calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as total_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as total_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as total_calls_engaged,
		null::bigint as total_calls_converted, --sum(case when calls.is_order then 1 else 0 end) as total_calls_converted, -- converted calls have at least 1 associated sale
		-- Other Volumes
		round(count(distinct(date_trunc('hour', calls.date), calls.user_id)) * _correction_, 0) as total_productive_hours,
		round(count(distinct(date_trunc('hour', calls.date), calls.user_id)) / _hours_per_FTE_ * _correction_, 1) as total_FTE,
		null::bigint as total_sales, -- sum(case when calls.is_order then 1 else 0 end) as total_sales, -- onverted calls have 1 or more sales
		count(distinct calls.user_id) as total_agents,
		count(distinct dashboards.utils_campaign_mapping(campaigns.id, campaigns.name)) as total_campaigns,
		round(sum(calls.cost), 2) as total_calling_cost,
		round(sum(dashboards.utils_duration_minutes(calls.duration)) / 60.0, 1) as total_calling_hours,
		-- --------------------------------------------------------------------------------
		-- Efficency KPIs
		dashboards.utils_percent(sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end), count(*), 2) as percent_calls_handled,
		dashboards.utils_percent(sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end), sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end), 2) as percent_calls_argumented,
		dashboards.utils_percent(sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end), sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end), 3) as percent_calls_engaged,
		null::numeric as ratio_calls_converted, -- dashboards.utils_percent(sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end), sum(case when calls.is_order then 1 else 0 end), 4) as percent_calls_converted,
		-- Productivity KPIs
		null::numeric as ratio_sales_per_hour, -- sum(case when calls.is_order then 1 else 0 end) * 60.0 / sum(dashboards.utils_duration_minutes(calls.duration)) as ratio_sales_per_hour,
		null::numeric as ratio_sales_per_agent, -- sum(case when calls.is_order then 1 else 0 end) / count(distinct calls.user_id) as ratio_sales_per_agent,
		null::numeric as ratio_sales_per_FTE, -- sum(case when calls.is_order then 1 else 0 end) * _hours_per_FTE_ / count(distinct(date_trunc('hour', calls.date), calls.user_id)) as ratio_sales_per_FTE,
		null::numeric as ratio_cost_per_sale, -- case when sum(case when calls.is_order then 1 else 0 end) = 0 then null else sum(calls.cost) / sum(case when calls.is_order then 1.0 else 0.0 end) end as ratio_cost_per_sale,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as ratio_cost_per_minute,
		round(count(calls.id) * 60.0 / sum(dashboards.utils_duration_minutes(calls.duration)), 0) as ratio_calls_per_hour
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
	left join public.brands as brands on brands.id = calls.brand_id 
	left join public.partners as partners on partners.id = calls.partner_id 
	left join public.team as teams on teams.id = calls.team_id 
	left join public.users as users on users.id = calls.user_id 
	left join public.accounts as agents on agents.id = users.account_id  
	left join public.campaigns as campaigns on campaigns.id = calls.campaign_id
	left join public.files as files on files.id = calls.file_id
	where 1=1
		and calls.date >= _cutoff_ 
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
	having 1=1
		and sum(dashboards.utils_duration_minutes(calls.duration)) >= _minimum_calling_minutes_									-- total "in call" time higher than 10 minutes
		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) >= _minimum_calls_handled_ 		-- Some "handled" calls
	order by 9, 10, 11, 12, 13, 14, 18
	;
end;
$$ language plpgsql;







-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Productivity & Efficiency | Views
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_monthly_partners;

drop view if exists dashboards.trends_productivity_monthly_partners cascade;
create or replace view dashboards.trends_productivity_monthly_partners as 
select * from dashboards.trends_productivity(true, true, true, false, false, false, false, 'month'); -- sponsor, brand, partner, team, agent, campaign, file, interval

-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_monthly_campaigns;

drop view if exists dashboards.trends_productivity_monthly_campaigns cascade;
create or replace view dashboards.trends_productivity_monthly_campaigns as 
select * from dashboards.trends_productivity(true, true, false, false, false, true, false, 'month'); -- sponsor, brand, partner, team, agent, campaign, file, interval

-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_weekly_partners;

drop view if exists dashboards.trends_productivity_weekly_partners cascade;
create or replace view dashboards.trends_productivity_weekly_partners as 
select * from dashboards.trends_productivity(true, true, true, false, false, false, false, 'week'); -- sponsor, brand, partner, team, agent, campaign, file, interval

-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_weekly_campaigns;

drop view if exists dashboards.trends_productivity_weekly_campaigns cascade;
create or replace view dashboards.trends_productivity_weekly_campaigns as 
select * from dashboards.trends_productivity(true, true, false, false, false, true, false, 'week'); -- sponsor, brand, partner, team, agent, campaign, file, interval

-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_daily_partners;

drop view if exists dashboards.trends_productivity_daily_partners cascade;
create or replace view dashboards.trends_productivity_daily_partners as 
select * from dashboards.trends_productivity(true, true, true, false, false, false, false, 'day'); -- sponsor, brand, partner, team, agent, campaign, file, interval

-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_daily_campaigns;

drop view if exists dashboards.trends_productivity_daily_campaigns cascade;
create or replace view dashboards.trends_productivity_daily_campaigns as 
select * from dashboards.trends_productivity(true, true, false, false, false, true, false, 'day'); -- sponsor, brand, partner, team, agent, campaign, file, interval

-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_daily_teams;

-- drop view if exists dashboards.trends_productivity_daily_teams cascade;
-- create or replace view dashboards.trends_productivity_daily_teams as 
-- select * from dashboards.trends_productivity(true, true, true, true, false, true, false, 'day'); -- sponsor, brand, partner, team, agent, campaign, file, interval

-- --------------------------------------------------------------------------------



