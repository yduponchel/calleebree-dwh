-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Dashboard | Widgets
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
-- Campaign Quality | Monthly
-- --------------------------------------------------------------------------------

drop view if exists dashboards.widget_quality_campaigns_monthly cascade;
create or replace view dashboards.widget_quality_campaigns_monthly as 
select 
	-- --------------------------------------------------------------------------------
	-- Context
	c.sponsor_id as sponsor_id,
	c.brand_id as brand_id, 
	null::varchar(36) as partner_id, 
	null::uuid as team_id,  
	null::uuid as user_id,  
	c.campaign_id as campaign_id,
	null::varchar(36) as file_id,
	-- --------------------------------------------------------------------------------
	-- Time windows
	c.year as year,
	c.month as month,
	null::char(7) as week,
	null::char(10) as date,
	null::char(12) as day_of_week,
	-- Hierarchy
	c.sponsor_name as sponsor_name,
	c.brand_name as brand_name,
	null::varchar(256) as partner_name,
	null::varchar(128) as team_name, 
	null::varchar(128) as agent_name, 
	c.campaign_name as campaign_name, 
	null::varchar(256) as file_name,
	-- --------------------------------------------------------------------------------
	-- Report specific attributes
	round(c.quality_handled * 100.0, 1) as quality_handled,
	round(c.quality_argumented * 100.0, 1) as quality_argumented,
	round(c.quality_engaged * 100.0, 1) as quality_engaged,
	c.calls,
	c.duration_minutes
	-- --------------------------------------------------------------------------------
from dashboards.trends_monthly_quality_campaigns as c
where 1=1
	and month >= dashboards.utils_format_month(current_date - interval '7 months')
	and confidence
	and campaign_name is not null
order by c.month, c.calls desc
;



-- --------------------------------------------------------------------------------
-- Campaign Quality | Current
-- --------------------------------------------------------------------------------

drop view if exists dashboards.widget_quality_campaigns_current cascade;
create or replace view dashboards.widget_quality_campaigns_current as 
with call_types (call_type) as (values (0), (1), (2), (3)) 
select 
	-- --------------------------------------------------------------------------------
	-- Context
	c.sponsor_id as sponsor_id,
	c.brand_id as brand_id, 
	null::varchar(36) as partner_id, 
	null::uuid as team_id,  
	null::uuid as user_id,  
	c.campaign_id as campaign_id,
	null::varchar(36) as file_id,
	-- --------------------------------------------------------------------------------
	-- Time windows
	null::char(4) as year,
	null::char(7) as month,
	null::char(7) as week,
	null::char(10) as date,
	null::char(12) as day_of_week,
	-- --------------------------------------------------------------------------------
	-- Hierarchy
	c.sponsor_name as sponsor_name,
	c.brand_name as brand_name,
	null::varchar(256) as partner_name,
	null::varchar(128) as team_name, 
	null::varchar(128) as agent_name, 
	c.campaign_name as campaign_name, 
	null::varchar(256) as file_name,
	-- --------------------------------------------------------------------------------
	-- Report specific attributes
	round(c.quality_handled * 100.0, 1) as quality_handled,
	round(c.quality_argumented * 100.0, 1) as quality_argumented,
	round(c.quality_engaged * 100.0, 1) as quality_engaged,
	-- 
	dashboards.utils_call_type_by_id(t.call_type) as call_type,
	case 
		when t.call_type = 0 then c.calls - c.calls_handled 
		when t.call_type = 1 then c.calls_handled - c.calls_argumented 
		when t.call_type = 2 then c.calls_argumented - c.calls_engaged 
		when t.call_type = 3 then c.calls_engaged 
		else 0 end as calls
	-- --------------------------------------------------------------------------------
from dashboards.trends_monthly_quality_campaigns as c
left join call_types t on 1=1
where 1=1
	and month = dashboards.utils_format_month(current_date - interval '3 weeks')
	and confidence
	and campaign_name is not null
order by c.calls desc
;



