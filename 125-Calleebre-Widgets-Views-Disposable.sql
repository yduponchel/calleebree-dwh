-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Dashboard | Widgets
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------



-- --------------------------------------------------------------------------------
-- Monthly Costs
-- --------------------------------------------------------------------------------

-- select * from dashboards.widget_cost_monthly;

drop view if exists dashboards.widget_cost_monthly;
create or replace view dashboards.widget_cost_monthly as 
select 
	-- --------------------------------------------------------------------------------
	-- Context
	calls.sponsor_id as sponsor_id,
	calls.brand_id as brand_id, 
	null::varchar(36) as partner_id, 
	null::uuid as team_id,  
	null::uuid as user_id,  
	calls.campaign_id as campaign_id,
	null::varchar(36) as file_id,
	-- --------------------------------------------------------------------------------
	-- Time windows
	dashboards.utils_format_year(calls.date) as year,
	dashboards.utils_format_month(calls.date) as month,
	null::char(7) as week,
	null::char(10) as date,
	null::char(12) as day_of_week,
	-- Hierarchy
	sponsors.name as sponsor_name,
	brands.name as brand_name,
	null::varchar(256) as partner_name,
	null::varchar(128) as team_name, 
	null::varchar(128) as agent_name, 
	dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name, 
	null::varchar(256) as file_name,
	-- --------------------------------------------------------------------------------
	-- Report specific attributes
	dashboards.utils_call_type(calls.duration) as call_type,
--	reasons.description as hangup_reason,
	-- --------------------------------------------------------------------------------
	count(*) as calls,
	sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
	sum(calls.cost) as cost
-- --------------------------------------------------------------------------------
from public.calls as calls
-- left join public.feedback_reasons_text as reasons on reasons.reason_id = calls.feedback_reason  and reasons.language_id = 'en'
left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
left join public.brands as brands on brands.id = calls.brand_id 
left join public.campaigns as campaigns on campaigns.id = calls.campaign_id
where 1=1
	and calls.sponsor_id = 103
	and calls.brand_id in ( 3, 5 ) 
	and calls.date >= date_trunc('year', current_date - interval '2 years') 
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
order by 9, sum(calls.cost) desc
;




-- --------------------------------------------------------------------------------
-- Quality & Engagement | Campaigns
-- --------------------------------------------------------------------------------

-- select * from dashboards.widget_quality_campaigns_monthly;

drop view if exists dashboards.widget_quality_campaigns_monthly cascade;
create or replace view dashboards.widget_quality_campaigns_monthly as 
select 
	sponsor_id, brand_id, partner_id, team_id, user_id, campaign_id, file_id,
	year, month, week, date, day_of_week, custom_interval,
	sponsor_name, brand_name, partner_name, team_name, agent_name, campaign_name, file_name, 
	total_calls, total_calls_handled, total_calls_argumented, total_calls_engaged, total_calls_converted, 
	total_productive_hours,
	percent_calls_handled, percent_calls_argumented, percent_calls_engaged, percent_calls_converted,
	index_quality_calls_handled, index_quality_calls_argumented, index_quality_calls_engaged, index_quality_calls_converted
--	confidence, confidence_value,
--	check_proxy, check_reference
from 
--	level in ('sponsor', 'brand', 'partner', 'team', 'agent', 'campaign', 'file')
--	breakdown in (true, false) 
--	interval in ('month', 'week', 'day', 'last 3 weeks', 'last 6 weeks', 'last 3 months')
	dashboards.trends_quality('campaign', false, 'month')
where 1=1
	and confidence 
;



-- --------------------------------------------------------------------------------

-- select * from dashboards.widget_quality_campaigns_current;

drop view if exists dashboards.widget_quality_campaigns_current cascade;
create or replace view dashboards.widget_quality_campaigns_current as 
with call_types (call_type) as (values (0), (1), (2), (3)) 
select 
	sponsor_id, brand_id, partner_id, team_id, user_id, campaign_id, file_id,
	year, month, week, date, day_of_week, custom_interval,
	sponsor_name, brand_name, partner_name, team_name, agent_name, campaign_name, file_name, 
--	total_calls, total_calls_handled, total_calls_argumented, total_calls_engaged, total_calls_converted, 
--	total_productive_hours, total_FTE, total_sales, total_agents, total_campaigns, total_calling_cost, total_Calling_hours, 
--	percent_calls_handled, percent_calls_argumented, percent_calls_engaged, percent_calls_converted,
--	ratio_sales_per_hour, ratio_sales_per_agent, ratio_sales_per_FTE, ratio_cost_per_sale, ratio_cost_per_minute, ratio_calls_per_hour,
	-- 
	dashboards.utils_call_type_by_id(t.call_type) as call_type,
	case 
		when t.call_type = 0 then c.total_calls - c.total_calls_handled 
		when t.call_type = 1 then c.total_calls_handled - c.total_calls_argumented 
		when t.call_type = 2 then c.total_calls_argumented - c.total_calls_engaged 
		when t.call_type = 3 then c.total_calls_engaged 
		else 0 end as calls
	-- --------------------------------------------------------------------------------
from 
--	sponsor, brand, partner, team, agent, campaign, file in (true, false)
--	interval in ('month', 'week', 'day', 'last 3 weeks', 'last 6 weeks', 'last 3 months')
	dashboards.trends_productivity(true, true, false, false, false, true, false, 'last 3 weeks') as c
left join call_types t on 1=1
where 1=1
;


-- --------------------------------------------------------------------------------
-- Quality & Engagement | Agents
-- --------------------------------------------------------------------------------

-- select * from dashboards.widget_quality_agents_weekly;

drop view if exists dashboards.widget_quality_agents_weekly cascade;
create or replace view dashboards.widget_quality_agents_weekly as 
select 
	sponsor_id, brand_id, partner_id, team_id, user_id, campaign_id, file_id,
	year, month, week, date, day_of_week, custom_interval,
	sponsor_name, brand_name, partner_name, team_name, agent_name, campaign_name, file_name, 
	total_calls, total_calls_handled, total_calls_argumented, total_calls_engaged, total_calls_converted, 
	total_productive_hours,
	percent_calls_handled, percent_calls_argumented, percent_calls_engaged, percent_calls_converted,
	index_quality_calls_handled, index_quality_calls_argumented, index_quality_calls_engaged, index_quality_calls_converted
--	confidence, confidence_value,
--	check_proxy, check_reference
from 
--	level in ('sponsor', 'brand', 'partner', 'team', 'agent', 'campaign', 'file')
--	breakdown in (true, false) 
--	interval in ('month', 'week', 'day', 'last 3 weeks', 'last 6 weeks', 'last 3 months')
	dashboards.trends_quality('agent', false, 'week')
where 1=1
	and confidence 
;



-- --------------------------------------------------------------------------------

-- select * from dashboards.widget_quality_agents_current;

drop view if exists dashboards.widget_quality_agents_current cascade;
create or replace view dashboards.widget_quality_agents_current as 
with call_types (call_type) as (values (0), (1), (2), (3)) 
select 
	sponsor_id, brand_id, partner_id, team_id, user_id, campaign_id, file_id,
	year, month, week, date, day_of_week, custom_interval,
	sponsor_name, brand_name, partner_name, team_name, agent_name, campaign_name, file_name, 
--	total_calls, total_calls_handled, total_calls_argumented, total_calls_engaged, total_calls_converted, 
--	total_productive_hours, total_FTE, total_sales, total_agents, total_campaigns, total_calling_cost, total_Calling_hours, 
--	percent_calls_handled, percent_calls_argumented, percent_calls_engaged, percent_calls_converted,
--	ratio_sales_per_hour, ratio_sales_per_agent, ratio_sales_per_FTE, ratio_cost_per_sale, ratio_cost_per_minute, ratio_calls_per_hour,
	-- 
	dashboards.utils_call_type_by_id(t.call_type) as call_type,
	case 
		when t.call_type = 0 then c.total_calls - c.total_calls_handled 
		when t.call_type = 1 then c.total_calls_handled - c.total_calls_argumented 
		when t.call_type = 2 then c.total_calls_argumented - c.total_calls_engaged 
		when t.call_type = 3 then c.total_calls_engaged 
		else 0 end as calls
	-- --------------------------------------------------------------------------------
from 
--	sponsor, brand, partner, team, agent, campaign, file in (true, false)
--	interval in ('month', 'week', 'day', 'last 3 weeks', 'last 6 weeks', 'last 3 months')
	dashboards.trends_productivity(true, true, true, true, true, false, false, 'last 3 weeks') as c
left join call_types t on 1=1
where 1=1
;






-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Dashboard | Reports & Support Tables
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------





-- --------------------------------------------------------------------------------
-- Productivity & Efficiency | Partners | Monthly
-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_monthly_partners;

drop view if exists dashboards.trends_productivity_monthly_partners cascade;
create or replace view dashboards.trends_productivity_monthly_partners as 
select * from dashboards.trends_productivity(true, true, true, false, false, false, false, 'month'); -- sponsor, brand, partner, team, agent, campaign, file, interval

-- --------------------------------------------------------------------------------
-- Productivity & Efficiency | Campaigns | Monthly
-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_monthly_campaigns;

drop view if exists dashboards.trends_productivity_monthly_campaigns cascade;
create or replace view dashboards.trends_productivity_monthly_campaigns as 
select * from dashboards.trends_productivity(true, true, false, false, false, true, false, 'month'); -- sponsor, brand, partner, team, agent, campaign, file, interval

-- --------------------------------------------------------------------------------
-- Productivity & Efficiency | Partners | Weekly
-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_weekly_partners;

drop view if exists dashboards.trends_productivity_weekly_partners cascade;
create or replace view dashboards.trends_productivity_weekly_partners as 
select * from dashboards.trends_productivity(true, true, true, false, false, false, false, 'week'); -- sponsor, brand, partner, team, agent, campaign, file, interval

-- --------------------------------------------------------------------------------
-- Productivity & Efficiency | Campaigns | Weekly
-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_weekly_campaigns;

drop view if exists dashboards.trends_productivity_weekly_campaigns cascade;
create or replace view dashboards.trends_productivity_weekly_campaigns as 
select * from dashboards.trends_productivity(true, true, false, false, false, true, false, 'week'); -- sponsor, brand, partner, team, agent, campaign, file, interval

-- --------------------------------------------------------------------------------
-- Productivity & Efficiency | Partners | Daily
-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_daily_partners;

drop view if exists dashboards.trends_productivity_daily_partners cascade;
create or replace view dashboards.trends_productivity_daily_partners as 
select * from dashboards.trends_productivity(true, true, true, false, false, false, false, 'day'); -- sponsor, brand, partner, team, agent, campaign, file, interval

-- --------------------------------------------------------------------------------
-- Productivity & Efficiency | Campaigns | Campaigns
-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_daily_campaigns;

drop view if exists dashboards.trends_productivity_daily_campaigns cascade;
create or replace view dashboards.trends_productivity_daily_campaigns as 
select * from dashboards.trends_productivity(true, true, false, false, false, true, false, 'day'); -- sponsor, brand, partner, team, agent, campaign, file, interval

-- --------------------------------------------------------------------------------
-- Productivity & Efficiency | Teams | Daily
-- --------------------------------------------------------------------------------

-- select * from dashboards.trends_productivity_daily_teams;

drop view if exists dashboards.trends_productivity_daily_teams cascade;
create or replace view dashboards.trends_productivity_daily_teams as 
select * from dashboards.trends_productivity(true, true, true, true, false, true, false, 'day'); -- sponsor, brand, partner, team, agent, campaign, file, interval


