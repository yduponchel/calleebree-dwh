-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Dashboards || Disposable Tables (re-generated)
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------




-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- !!! DEPRECATED | REPLACED BY quality_trends() and trends_productivity() !!!
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------



-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Working & Persistence Tables
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------


-- --------------------------------------------------------------------------------
-- Campaign Quality
-- --------------------------------------------------------------------------------

drop table if exists dashboards.trends_monthly_quality_campaigns cascade;
/*
create table if not exists dashboards.trends_monthly_quality_campaigns (
	-- --------------------------------------------------------------------------------
	-- Context
	sponsor_id int, --uuid,
	brand_id int, --uuid,
--	partner_id varchar(36), --uuid,
--	team_id uuid,
--	user_id uuid,
	campaign_id varchar(36), --uuid,
	file_id varchar(36), --uuid,
	-- --------------------------------------------------------------------------------
	-- Time windows
	year char(4),
	month char(7),
--	week char(7) default null,
--	date char(10) default null,
--	day_of_week char(12) default null,
	-- --------------------------------------------------------------------------------
	-- Hierarchy
	sponsor_name varchar(128),
	brand_name varchar(128),
--	partner_name varchar(256),
--	team_name varchar(128),
--	agent_name varchar(128),
	campaign_name varchar(256),
	file_name varchar(256),
	-- --------------------------------------------------------------------------------
	-- Quality KPIs
	ratio_calls_handled numeric,							-- % Calls "Handled" vs. Calls "Attempted"
	ratio_calls_argumented numeric,							-- % Calls "Argumented" vs. Calls "Handled"
	ratio_calls_engaged numeric,							-- % Calls "Engaged" vs. Calls "Handled"
	quality_handled numeric,								-- index[0..100..] of ratio_calls_handled(campaign) vs. average{ ratio_calls_handled}
	quality_argumented numeric,								-- index[0..100..] of ratio_calls_argumented(campaign) vs. average{ ratio_calls_argumented }
	quality_engaged numeric,								-- index[0..100..] of ratio_calls_engaged(campaign) vs. average{ ratio_calls_engaged }
	confidence boolean,										-- confidence for ratio & quality KPIs (is there enough data?)
	-- Other Attributes	
	calls int,												-- all calls
	calls_handled int, 										-- including argumented & engaged
	calls_argumented int,									-- including engaged
	calls_engaged int,
	duration_minutes int,
	cost int,
	cost_per_minute numeric,
	-- --------------------------------------------------------------------------------
	-- Constraints
	unique (month, sponsor_id, brand_id, campaign_id, file_id)
);
-- --------------------------------------------------------------------------------
-- Indexes
create index on dashboards.trends_monthly_quality_campaigns (sponsor_id);
create index on dashboards.trends_monthly_quality_campaigns (brand_id);
create index on dashboards.trends_monthly_quality_campaigns (campaign_id);
create index on dashboards.trends_monthly_quality_campaigns (file_id);
create index on dashboards.trends_monthly_quality_campaigns (year);
create index on dashboards.trends_monthly_quality_campaigns (month);
create index on dashboards.trends_monthly_quality_campaigns (sponsor_name);
create index on dashboards.trends_monthly_quality_campaigns (brand_name);
create index on dashboards.trends_monthly_quality_campaigns (campaign_name);
create index on dashboards.trends_monthly_quality_campaigns (file_name);
*/


-- --------------------------------------------------------------------------------
-- Agent Quality
-- --------------------------------------------------------------------------------

drop table if exists dashboards.trends_weekly_quality_agents cascade;
/*
create table if not exists dashboards.trends_weekly_quality_agents (
	-- --------------------------------------------------------------------------------
	-- Context
	sponsor_id int, --uuid,
	brand_id int, --uuid,
	partner_id varchar(36), --uuid,
	team_id uuid,
	user_id uuid,
	campaign_id varchar(36), --uuid,
--	file_id varchar(36), --uuid,
	-- --------------------------------------------------------------------------------
	-- Time windows
	year char(4),
--	month char(7) default null,
	week char(7),
--	date char(10) default null,
--	day_of_week char(12) default null,
	-- --------------------------------------------------------------------------------
	-- Hierarchy
	sponsor_name varchar(128),
	brand_name varchar(128),
	partner_name varchar(256),
	team_name varchar(128),
	agent_name varchar(128),
	campaign_name varchar(256),
--	file_name varchar(256),
	-- --------------------------------------------------------------------------------
	-- Quality KPIs
	ratio_calls_handled numeric,							-- % Calls "Handled" vs. Calls "Attempted"
	ratio_calls_argumented numeric,							-- % Calls "Argumented" vs. Calls "Handled"
	ratio_calls_engaged numeric,							-- % Calls "Engaged" vs. Calls "Handled"
	quality_handled numeric,								-- index[0..100..] of ratio_calls_handled(campaign) vs. average{ ratio_calls_handled}
	quality_argumented numeric,								-- index[0..100..] of ratio_calls_argumented(campaign) vs. average{ ratio_calls_argumented }
	quality_engaged numeric,								-- index[0..100..] of ratio_calls_engaged(campaign) vs. average{ ratio_calls_engaged }
	confidence boolean,										-- confidence for ratio & quality KPIs (is there enough data?)
	-- Other Attributes	
	calls int,												-- all calls
	calls_handled int, 										-- including argumented & engaged
	calls_argumented int,									-- including engaged
	calls_engaged int,
	duration_minutes int,
	cost int,
	cost_per_minute numeric,
	-- --------------------------------------------------------------------------------
	-- Constraints
	unique (week, sponsor_id, brand_id, partner_id, team_id, user_id, campaign_name)	-- TODO FIXME: shall be ids and not names || shall include file_id as well
);
-- --------------------------------------------------------------------------------
-- Indexes
create index on dashboards.trends_weekly_quality_agents (sponsor_id);
create index on dashboards.trends_weekly_quality_agents (brand_id);
create index on dashboards.trends_weekly_quality_agents (partner_id);
create index on dashboards.trends_weekly_quality_agents (team_id);
create index on dashboards.trends_weekly_quality_agents (user_id);
create index on dashboards.trends_weekly_quality_agents (campaign_id);
create index on dashboards.trends_weekly_quality_agents (year);
create index on dashboards.trends_weekly_quality_agents (week);
create index on dashboards.trends_weekly_quality_agents (sponsor_name);
create index on dashboards.trends_weekly_quality_agents (brand_name);
create index on dashboards.trends_weekly_quality_agents (partner_name);
create index on dashboards.trends_weekly_quality_agents (team_name);
create index on dashboards.trends_weekly_quality_agents (agent_name);
create index on dashboards.trends_weekly_quality_agents (campaign_name);
*/


-- --------------------------------------------------------------------------------
-- Sanity Checks
-- --------------------------------------------------------------------------------

-- select count(*) as count, min(month) as month_min, max(month) as month_max from dashboards.trends_monthly_quality_campaigns;
-- call dashboards.trends_monthly_quality_campaigns_refresh();
-- select count(*) as count, min(month) as month_min, max(month) as month_max from dashboards.trends_monthly_quality_campaigns;

-- --------------------------------------------------------------------------------

-- select count(*) as count, min(month) as month_min, max(month) as month_max from dashboards.trends_weekly_quality_agents;
-- call dashboards.trends_weekly_quality_agents_refresh();
-- select count(*) as count, min(month) as month_min, max(month) as month_max from dashboards.trends_weekly_quality_agents;



-- --------------------------------------------------------------------------------
-- Implementation Notes
-- --------------------------------------------------------------------------------

-- TABLE: trends_monthly_quality_campaigns
-- -- CALL trends_monthly_quality_campaigns_refresh() 
-- -- --> CALL trends_monthly_quality_campaigns_kpi_global_refresh()
-- -- --> CALL trends_monthly_quality_campaigns_kpi_sponsors_refresh()
-- -- --> CALL trends_monthly_quality_campaigns_kpi_brands_refresh()
-- -- --> CALL trends_monthly_quality_campaigns_kpi_campaigns_refresh()
-- -- --> CALL trends_monthly_quality_campaigns_kpi_files_refresh()

-- TABLE: trends_weekly_quality_agents














-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Aggregation logic | Monthly Campaign Quality 
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------




-- --------------------------------------------------------------------------------
-- Master procedure | Monthly Campaign Quality | Overall
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_monthly_quality_campaigns_refresh;
/*
create or replace procedure dashboards.trends_monthly_quality_campaigns_refresh() as $$
declare
	_refresh_limit_text_ char(7) := (select max(t.month) from dashboards.trends_monthly_quality_campaigns as t); -- Can be NULL, will be handled by sub-procedures
	_refresh_limit_timestamp_ timestamp := to_timestamp(_refresh_limit_text_ || '-01', 'YYYY-MM-DD'); -- Can be NULL, will be handled by sub-procedures
	token char(64) := dashboards.utils_logs_token('trends_monthly_quality_campaigns_refresh');

begin
	raise notice 'Refresh limit: %', _refresh_limit_text_;
	call dashboards.utils_logs_init(token, 'dashboards.trends_monthly_quality_campaigns_refresh()');
	
	-- Refresh
	
	delete from dashboards.trends_monthly_quality_campaigns where month >= _refresh_limit_text_;
	commit;
	raise notice 'Cleaned recent data >= %', _refresh_limit_text_;
	call dashboards.utils_logs_event(token, 'Clean-up', 'Truncated DB: ' || _refresh_limit_text_);

	call dashboards.trends_monthly_quality_campaigns_kpi_global_refresh(_refresh_limit_timestamp_);
	commit;
	raise notice 'Regenerated KPIs: Global';
	call dashboards.utils_logs_event(token, 'Global KPIs', 'Regenerated KPIs: Global');

	call dashboards.trends_monthly_quality_campaigns_kpi_sponsors_refresh(_refresh_limit_timestamp_);
	commit;
	raise notice 'Regenerated KPIs: Organizations';
	call dashboards.utils_logs_event(token, 'Orgaization KPIs', 'Regenerated KPIs: Organizations');

	call dashboards.trends_monthly_quality_campaigns_kpi_brands_refresh(_refresh_limit_timestamp_);
	commit;
	raise notice 'Regenerated KPIs: Brands';
	call dashboards.utils_logs_event(token, 'Brand KPIs', 'Regenerated KPIs: Brands');

	call dashboards.trends_monthly_quality_campaigns_kpi_campaigns_refresh(_refresh_limit_timestamp_);
	commit;
	raise notice 'Regenerated KPIs: Campaigns';
	call dashboards.utils_logs_event(token, 'Camaign KPIs', 'Regenerated KPIs: Campaigns');

--	call dashboards.trends_monthly_quality_campaigns_kpi_files_refresh(_refresh_limit_timestamp_);
--	commit;
--	raise notice 'Regenerated KPIs: Files';
--	call dashboards.utils_logs_event(token, 'File KPIs', 'Regenerated KPIs: Files');

	call dashboards.utils_logs_event(token, null, '<OVERALL>');

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Sub-Procedure | Monthly Campaign Quality | Step 1 (Global)
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_monthly_quality_campaigns_kpi_global_refresh;
/*
create or replace procedure dashboards.trends_monthly_quality_campaigns_kpi_global_refresh(_refresh_limit_ timestamp) as $$
declare 
	__refresh_limit__ timestamp := coalesce(_refresh_limit_, (select min(c.date) from public.calls as c), '2020-01-01 00:00:00'::timestamp);
	__refresh_limit_text__ text := dashboards.utils_format_month(__refresh_limit__);
	__confidence_level__ int := 50;
begin
		
	delete from dashboards.trends_monthly_quality_campaigns where month >= __refresh_limit_text__;
	commit;

	insert into dashboards.trends_monthly_quality_campaigns 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		calls.sponsor_id,
		calls.brand_id as brand_id, 
		null::uuid as campaign_id, 
		null::uuid as file_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year(calls.date) as year,
		dashboards.utils_format_month(calls.date) as month,
		-- week,
		-- date,
		-- day_of_week,
		-- --------------------------------------------------------------------------------
		-- Hierarchy
		null::varchar(128) as sponsor_name,
		null::varchar(128) as brand_name,
		-- partner_name,
		-- team_name,
		-- agent_name,
		null::varchar(256) as campaign_name,
		-- file_name,
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		null::numeric as quality_handled,
		null::numeric as quality_argumented,
		null::numeric as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	where 1=1
		and calls.date >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	having sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
	order by 10 desc, 9 desc;

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Sub-Procedure | Monthly Campaign Quality | Sponsors
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_monthly_quality_campaigns_kpi_sponsors_refresh;
/*
create or replace procedure dashboards.trends_monthly_quality_campaigns_kpi_sponsors_refresh(_refresh_limit_ timestamp) as $$
declare 
	__refresh_limit__ timestamp := coalesce(_refresh_limit_, (select min(c.date) from public.calls as c), '2020-01-01 00:00:00'::timestamp);
	__refresh_limit_text__ text := dashboards.utils_format_month(__refresh_limit__);
	__confidence_level__ int := 50;
begin
	
	delete from dashboards.trends_monthly_quality_campaigns where month >= __refresh_limit_text__ and sponsor_id is not null;
	commit;

	insert into dashboards.trends_monthly_quality_campaigns 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		calls.sponsor_id,
		null::int as brand_id, 
		null::uuid as campaign_id, 
		null::uuid as file_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year(calls.date) as year,
		dashboards.utils_format_month(calls.date) as month,
		-- Hierarchy
		sponsors.name as sponsor_name,
		null::varchar(999) as brand_name,
		-- Campaigns
		null::varchar(999) as campaign_name,
		null::varchar(999) as file_name,
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) /  kpis.ratio_calls_handled as quality_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) / kpis.ratio_calls_argumented as quality_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) / kpis.ratio_calls_engaged as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
	left join dashboards.trends_monthly_quality_campaigns as kpis on kpis.month = dashboards.utils_format_month(calls.date) and kpis.sponsor_id is null
	where 1=1
		and calls.date >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, kpis.ratio_calls_handled, kpis.ratio_calls_argumented, kpis.ratio_calls_engaged
	having 1=1
		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
--		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > 0 	-- Ignore records with no 'engaged' calls (ratio cannot be calculated)
		and kpis.ratio_calls_engaged > 0
	order by 10 desc, 9 desc;

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Sub-Procedure | Monthly Campaign Quality | Brands
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_monthly_quality_campaigns_kpi_brands_refresh;
/*
create or replace procedure dashboards.trends_monthly_quality_campaigns_kpi_brands_refresh(_refresh_limit_ timestamp) as $$
declare 
	__refresh_limit__ timestamp := coalesce(_refresh_limit_, (select min(c.date) from public.calls as c), '2020-01-01 00:00:00'::timestamp);
	__refresh_limit_text__ text := dashboards.utils_format_month(__refresh_limit__);
	__confidence_level__ int := 40;
begin
	
	delete from dashboards.trends_monthly_quality_campaigns where month >= __refresh_limit_text__ and brand_id is not null;
	commit;

	insert into dashboards.trends_monthly_quality_campaigns 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		calls.sponsor_id,
		calls.brand_id as brand_id, 
		null::uuid as campaign_id, 
		null::uuid as file_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year(calls.date) as year,
		dashboards.utils_format_month(calls.date) as month,
		-- Hierarchy
		sponsors.name as sponsor_name,
		brands.name as brand_name,
		-- Campaigns
		null::varchar(999) as campaign_name,
		null::varchar(999) as file_name,
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) /  kpis.ratio_calls_handled as quality_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) / kpis.ratio_calls_argumented as quality_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) / kpis.ratio_calls_engaged as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
	left join public.brands as brands on brands.id = calls.brand_id 
	left join dashboards.trends_monthly_quality_campaigns as kpis on kpis.month = dashboards.utils_format_month(calls.date) and kpis.sponsor_id = calls.sponsor_id and kpis.brand_id is null
	where 1=1
		and calls.date >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, kpis.ratio_calls_handled, kpis.ratio_calls_argumented, kpis.ratio_calls_engaged
	having 1=1
		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
--		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > 0 	-- Ignore records with no 'engaged' calls (ratio cannot be calculated)
		and kpis.ratio_calls_engaged > 0
	order by 10 desc, 9 desc;

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Sub-Procedure | Monthly Campaign Quality | Campaigns
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_monthly_quality_campaigns_kpi_campaigns_refresh;
/*
create or replace procedure dashboards.trends_monthly_quality_campaigns_kpi_campaigns_refresh(_refresh_limit_ timestamp) as $$
declare 
	__refresh_limit__ timestamp := coalesce(_refresh_limit_, (select min(c.date) from public.calls as c), '2020-01-01 00:00:00'::timestamp);
	__refresh_limit_text__ text := dashboards.utils_format_month(__refresh_limit__);
	__confidence_level__ int := 30;
begin
	
	delete from dashboards.trends_monthly_quality_campaigns where month >= __refresh_limit_text__ and campaign_name is not null; -- TODO FIXME: use campaign_id
	commit;

	insert into dashboards.trends_monthly_quality_campaigns 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		calls.sponsor_id,
		calls.brand_id as brand_id, 
		null::uuid as campaign_id, -- TODO FIXME: change once campaign structure is updated
		null::uuid as file_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year(calls.date) as year,
		dashboards.utils_format_month(calls.date) as month,
		-- Hierarchy
		sponsors.name as sponsor_name,
		brands.name as brand_name,
		-- Campaigns
		dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name, 
		null::varchar(999) as file_name,
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) /  kpis.ratio_calls_handled as quality_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) / kpis.ratio_calls_argumented as quality_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) / kpis.ratio_calls_engaged as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
	left join public.brands as brands on brands.id = calls.brand_id 
	left join public.campaigns as campaigns on campaigns.id = calls.campaign_id 
	-- TODO FIXME: replace by campaign_id
	left join dashboards.trends_monthly_quality_campaigns as kpis on kpis.month = dashboards.utils_format_month(calls.date) and kpis.sponsor_id = calls.sponsor_id and kpis.brand_id = calls.brand_id and kpis.campaign_name is null
	where 1=1
		and calls.date >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, kpis.ratio_calls_handled, kpis.ratio_calls_argumented, kpis.ratio_calls_engaged
	having 1=1
		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
--		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > 0 	-- Ignore records with no 'engaged' calls (ratio cannot be calculated)
		and kpis.ratio_calls_engaged > 0
	order by 10 desc, 9 desc;

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------










-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Aggregation logic | Weekly Agent Quality 
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------




-- --------------------------------------------------------------------------------
-- Master procedure | Weekly Agent Quality | Overall 
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_weekly_quality_agents_refresh;
/*
create or replace procedure dashboards.trends_weekly_quality_agents_refresh() as $$
declare
	_refresh_limit_ text := (select max(t.week) from dashboards.trends_weekly_quality_agents as t);
	token char(64)  := dashboards.utils_logs_token('trends_weekly_quality_agents_refresh');

begin
	raise notice 'Refresh limit: %', _refresh_limit_text_;
	call dashboards.utils_logs_init(token, 'dashboards.trends_weekly_quality_agents_refresh()');
	
	-- Refresh
	
	delete from dashboards.trends_weekly_quality_agents where week >= _refresh_limit_;
	commit;
	raise notice 'Cleaned recent data >= %', _refresh_limit_text_;
	call dashboards.utils_logs_event(token, 'Truncated DB: ' || _refresh_limit_);

	-- 
	
	call dashboards.trends_weekly_quality_agents_kpi_global_refresh(_refresh_limi_);
	commit;
	raise notice 'Regenerated KPIs: Global';
	call dashboards.utils_logs_event(token, 'Regenerated KPIs: Global');

	call dashboards.trends_weekly_quality_agents_kpi_sponsors_refresh(_refresh_limit_);
	commit;
	raise notice 'Regenerated KPIs: Organizations';
	call dashboards.utils_logs_event(token, 'Regenerated KPIs: Organizations');

	call dashboards.trends_weekly_quality_agents_kpi_brands_refresh(_refresh_limit_);
	commit;
	raise notice 'Regenerated KPIs: Brands';
	call dashboards.utils_logs_event(token, 'Regenerated KPIs: Brands');

	call dashboards.trends_weekly_quality_agents_kpi_partners_refresh(_refresh_limit_);
	commit;
	raise notice 'Regenerated KPIs: Partners';
	call dashboards.utils_logs_event(token, 'Regenerated KPIs: Partners');

	call dashboards.trends_weekly_quality_agents_kpi_teams_refresh(_refresh_limit_);
	commit;
	raise notice 'Regenerated KPIs: Teams';
	call dashboards.utils_logs_event(token, 'Regenerated KPIs: Teams');

	call dashboards.trends_weekly_quality_agents_kpi_agents_refresh(_refresh_limit_);
	commit;
	raise notice 'Regenerated KPIs: Agents';
	call dashboards.utils_logs_event(token, 'Regenerated KPIs: Agents');

	call dashboards.trends_weekly_quality_agents_kpi_campaigns_refresh(_refresh_limit_);
	commit;
	raise notice 'Regenerated KPIs: Campaigns';
	call dashboards.utils_logs_event(token, 'Regenerated KPIs: Campaigns');

	call dashboards.trends_weekly_quality_agents_kpi_partners_by_campaign_refresh(_refresh_limit_);
	commit;
	raise notice 'Regenerated KPIs: Partners';
	call dashboards.utils_logs_event(token, 'Regenerated KPIs: Partners by Campaign');

	call dashboards.trends_weekly_quality_agents_kpi_teams_by_campaign_refresh(_refresh_limit_);
	commit;
	raise notice 'Regenerated KPIs: Teams';
	call dashboards.utils_logs_event(token, 'Regenerated KPIs: Teams by Campaign');

	call dashboards.trends_weekly_quality_agents_kpi_agents_by_campaign_refresh(_refresh_limit_);
	commit;
	raise notice 'Regenerated KPIs: Agents';
	call dashboards.utils_logs_event(token, 'Regenerated KPIs: Agents by Campaign');

	call dashboards.utils_logs_event(token, '<OVERALL>');

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Master procedure | Weekly Agent Quality | Global 
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_weekly_quality_agents_kpi_global_refresh;
/*
create or replace procedure dashboards.trends_weekly_quality_agents_kpi_global_refresh(_refresh_limit_ text) as $$
declare 
	__refresh_limit__ text := coalesce(_refresh_limit_, dashboards.utils_format_week((select min(c.date) from public.calls as c)), dashboards.utils_format_week('2020-01-01 00:00:00'::timestamp));
	__confidence_level__ int := 40;
begin

	delete from dashboards.trends_weekly_quality_agents where week >= refresh_limit_text;
	commit;

	insert into dashboards.trends_weekly_quality_agents 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		null::int as sponsor_id,
		null::int as brand_id, 
		null::int as partner_id, 
		null::uuid as team_id, 
		null::uuid as user_id, 
		null::uuid as campaign_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year_ISO(calls.date) as year,
		dashboards.utils_format_week(calls.date) as week,
		-- --------------------------------------------------------------------------------
		-- Hierarchy
		null::varchar(999) as sponsor_name,
		null::varchar(999) as brand_name,
		null::varchar(999) as partner_name,
		null::varchar(999) as team_name,
		null::varchar(999) as agent_name,
		null::varchar(999) as campaign_name,
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		null::numeric as quality_handled,
		null::numeric as quality_argumented,
		null::numeric as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	where 1=1
		and dashboards.utils_format_week(calls.date) >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
	having sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
	;

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Master procedure | Weekly Agent Quality | Sponsors 
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_weekly_quality_agents_kpi_sponsors_refresh;
/*
create or replace procedure dashboards.trends_weekly_quality_agents_kpi_sponsors_refresh(_refresh_limit_ text) as $$
declare 
	__refresh_limit__ text := coalesce(_refresh_limit_, dashboards.utils_format_week((select min(c.date) from public.calls as c)), dashboards.utils_format_week('2020-01-01 00:00:00'::timestamp));
	__confidence_level__ int := 35;
begin
		
	delete from dashboards.trends_weekly_quality_agents where 1=1
		and week >= refresh_limit_text 
		and campaign_name is null 
		and sponsor_id is not null and brand_id is null and partner_id is null and team_id is null and user_id is null;
	commit;

	insert into dashboards.trends_weekly_quality_agents 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		calls.sponsor_id as sponsor_id,
		null::int as brand_id, 
		null::int as partner_id, 
		null::uuid as team_id, 
		null::uuid as user_id, 
		null::uuid as campaign_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year_ISO(calls.date) as year,
		dashboards.utils_format_week(calls.date) as week,
		-- Hierarchy
		sponsors.name as sponsor_name,
		null::varchar(999) as brand_name,
		null::varchar(999) as partner_name,
		null::varchar(999) as team_name,
		null::varchar(999) as agent_name,
		-- Campaigns
		null::varchar(999) as campaign_name,
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		null::numeric as quality_handled,
		null::numeric as quality_argumented,
		null::numeric as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
	left join dashboards.trends_weekly_quality_agents as kpis on 1=1
		and kpis.week = dashboards.utils_format_week(calls.date) 
		and kpis.sponsor_id is null and kpis.brand_id is null and kpis.partner_id is null and kpis.team_id is null and kpis.user_id is null
		and kpis.campaign_name is null 
	where 1=1
		and dashboards.utils_format_week(calls.date) >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, kpis.ratio_calls_handled, kpis.ratio_calls_argumented, kpis.ratio_calls_engaged
	having 1=1
		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
--		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > 0 	-- Ignore records with no 'engaged' calls (ratio cannot be calculated)
		and kpis.ratio_calls_engaged > 0
	;

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Master procedure | Weekly Agent Quality | Brands
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_weekly_quality_agents_kpi_brands_refresh;
/*
create or replace procedure dashboards.trends_weekly_quality_agents_kpi_brands_refresh(_refresh_limit_ text) as $$
declare 
	__refresh_limit__ text := coalesce(_refresh_limit_, dashboards.utils_format_week((select min(c.date) from public.calls as c)), dashboards.utils_format_week('2020-01-01 00:00:00'::timestamp));
	__confidence_level__ int := 30;
begin
		
	delete from dashboards.trends_weekly_quality_agents where 1=1
		and week >= refresh_limit_text 
		and campaign_name is null 
		and sponsor_id is not null and brand_id is not null and partner_id is null and team_id is null and user_id is null;
	commit;

	insert into dashboards.trends_weekly_quality_agents 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		calls.sponsor_id as sponsor_id,
		calls.brand_id as brand_id, 
		null::varchar(36) as partner_id, 
		null::uuid as team_id, 
		null::uuid as user_id, 
		null::varchar(36) as campaign_id,
		null::varchar(36) as file_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year_ISO(calls.date) as year,
		null::char(7) as month,
		dashboards.utils_format_week(calls.date) as week,
		null::char(10) as date,
		null::char(12) as day_of_week,
		-- --------------------------------------------------------------------------------
		-- Hierarchy
		sponsors.name as sponsor_name,
		brands.name as brand_name,
		null::varchar(256) as partner_name,
		null::varchar(128) as team_name,
		null::varchar(128) as agent_name,
		null::varchar(256) as campaign_name,
		null::varchar(256) as file_name,
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		null::numeric as quality_handled,
		null::numeric as quality_argumented,
		null::numeric as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
	left join public.brands as brands on brands.id = calls.brand_id 
	left join dashboards.trends_weekly_quality_agents as kpis on 1=1
		and kpis.week = dashboards.utils_format_week(calls.date) 
		and kpis.sponsor_id = calls.sponsor_id and kpis.brand_id is null and kpis.partner_id is null and kpis.team_id is null and kpis.user_id is null
		and kpis.campaign_name is null 
	where 1=1
		and dashboards.utils_format_week(calls.date) >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, kpis.ratio_calls_handled, kpis.ratio_calls_argumented, kpis.ratio_calls_engaged
	having 1=1
		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
--		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > 0 	-- Ignore records with no 'engaged' calls (ratio cannot be calculated)
		and kpis.ratio_calls_engaged > 0
	;

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Master procedure | Weekly Agent Quality | Partners
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_weekly_quality_agents_kpi_partners_refresh;
/*
create or replace procedure dashboards.trends_weekly_quality_agents_kpi_partners_refresh(_refresh_limit_ text) as $$
declare 
	__refresh_limit__ text := coalesce(_refresh_limit_, dashboards.utils_format_week((select min(c.date) from public.calls as c)), dashboards.utils_format_week('2020-01-01 00:00:00'::timestamp));
	__confidence_level__ int := 25;
begin
		
	delete from dashboards.trends_weekly_quality_agents where 1=1
		and week >= refresh_limit_text 
		and campaign_name is null 
		and sponsor_id is not null and brand_id is not null and partner_id is not null and team_id is null and user_id is null;
	commit;

	insert into dashboards.trends_weekly_quality_agents 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		calls.sponsor_id as sponsor_id,
		calls.brand_id as brand_id, 
		calls.partner_id as partner_id, 
		null::uuid as team_id, 
		null::uuid as user_id, 
		null::varchar(36) as campaign_id,
		null::varchar(36) as file_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year_ISO(calls.date) as year,
		null::char(7) as month,
		dashboards.utils_format_week(calls.date) as week,
		null::char(10) as date,
		null::char(12) as day_of_week,
		-- --------------------------------------------------------------------------------
		-- Hierarchy
		sponsors.name as sponsor_name,
		brands.name as brand_name,
		partners.name as partner_name,
		null::varchar(128) as team_name,
		null::varchar(128) as agent_name,
		null::varchar(256) as campaign_name,
		null::varchar(256) as file_name,
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		null::numeric as quality_handled,
		null::numeric as quality_argumented,
		null::numeric as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
	left join public.brands as brands on brands.id = calls.brand_id 
	left join public.partners as partners on partners.id = calls.partner_id 
	left join dashboards.trends_weekly_quality_agents as kpis on 1=1
		and kpis.week = dashboards.utils_format_week(calls.date) 
		and kpis.sponsor_id = calls.sponsor_id and kpis.brand_id = calls.brand_id and kpis.partner_id is null and kpis.team_id is null and kpis.user_id is null
		and kpis.campaign_name is null 
	where 1=1
		and dashboards.utils_format_week(calls.date) >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, kpis.ratio_calls_handled, kpis.ratio_calls_argumented, kpis.ratio_calls_engaged
	having 1=1
		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
--		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > 0 	-- Ignore records with no 'engaged' calls (ratio cannot be calculated)
		and kpis.ratio_calls_engaged > 0
	;

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Master procedure | Weekly Agent Quality | Teams
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_weekly_quality_agents_kpi_teams_refresh;
/*
create or replace procedure dashboards.trends_weekly_quality_agents_kpi_teams_refresh(_refresh_limit_ text) as $$
declare 
	__refresh_limit__ text := coalesce(_refresh_limit_, dashboards.utils_format_week((select min(c.date) from public.calls as c)), dashboards.utils_format_week('2020-01-01 00:00:00'::timestamp));
	__confidence_level__ int := 25;
begin
		
	delete from dashboards.trends_weekly_quality_agents where 1=1
		and week >= refresh_limit_text 
		and campaign_name is null 
		and sponsor_id is not null and brand_id is not null and partner_id is not null and team_id is not null and user_id is null;
	commit;

	insert into dashboards.trends_weekly_quality_agents 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		calls.sponsor_id as sponsor_id,
		calls.brand_id as brand_id, 
		calls.partner_id as partner_id, 
		calls.team_id as team_id, 
		null::uuid as user_id, 
		null::varchar(36) as campaign_id,
		null::varchar(36) as file_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year_ISO(calls.date) as year,
		dashboards.utils_format_week(calls.date) as week,
		-- Hierarchy
		sponsors.name as sponsor_name,
		brands.name as brand_name,
		partners.name as partner_name,
		teams.name as team_name,
		null::varchar(999) as agent_name,
		-- Campaigns
		null::varchar(999) as campaign_name, 
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		null::numeric as quality_handled,
		null::numeric as quality_argumented,
		null::numeric as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
	left join public.brands as brands on brands.id = calls.brand_id 
	left join public.partners as partners on partners.id = calls.partner_id 
	left join public.team as teams on teams.id = calls.team_id 
	left join dashboards.trends_weekly_quality_agents as kpis on 1=1
		and kpis.week = dashboards.utils_format_week(calls.date) 
		and kpis.sponsor_id = calls.sponsor_id and kpis.brand_id = calls.brand_id and kpis.partner_id = calls.partner_id and kpis.team_id is null and kpis.user_id is null
		and kpis.campaign_name is null 
	where 1=1
		and dashboards.utils_format_week(calls.date) >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, kpis.ratio_calls_handled, kpis.ratio_calls_argumented, kpis.ratio_calls_engaged
	having 1=1
		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
--		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > 0 	-- Ignore records with no 'engaged' calls (ratio cannot be calculated)
		and kpis.ratio_calls_engaged > 0
	;

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Master procedure | Weekly Agent Quality | Agents
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_weekly_quality_agents_kpi_agents_refresh;
/*
create or replace procedure dashboards.trends_weekly_quality_agents_kpi_agents_refresh(_refresh_limit_ text) as $$
declare 
	__refresh_limit__ text := coalesce(_refresh_limit_, dashboards.utils_format_week((select min(c.date) from public.calls as c)), dashboards.utils_format_week('2020-01-01 00:00:00'::timestamp));
	__confidence_level__ int := 25;
begin
		
	delete from dashboards.trends_weekly_quality_agents where 1=1
		and week >= refresh_limit_text 
		and campaign_name is null 
		and sponsor_id is not null and brand_id is not null and partner_id is not null and team_id is not null and user_id is not null;
	commit;

	insert into dashboards.trends_weekly_quality_agents 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		calls.sponsor_id as sponsor_id,
		calls.brand_id as brand_id, 
		calls.partner_id as partner_id, 
		calls.team_id as team_id, 
		null::uuid as user_id, 
		null::uuid as campaign_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year_ISO(calls.date) as year,
		dashboards.utils_format_week(calls.date) as week,
		-- Hierarchy
		sponsors.name as sponsor_name,
		brands.name as brand_name,
		partners.name as partner_name,
		teams.name as team_name,
		null::varchar(999) as agent_name,
		-- Campaigns
		null::varchar(999) as campaign_name, 
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		null::numeric as quality_handled,
		null::numeric as quality_argumented,
		null::numeric as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
	left join public.brands as brands on brands.id = calls.brand_id 
	left join public.partners as partners on partners.id = calls.partner_id 
	left join public.team as teams on teams.id = calls.team_id 
	left join public.users as users on users.id = calls.user_id 
	left join public.accounts as agents on agents.id = users.account_id 
	left join dashboards.trends_weekly_quality_agents as kpis on 1=1
		and kpis.week = dashboards.utils_format_week(calls.date) 
		and kpis.sponsor_id = calls.sponsor_id and kpis.brand_id = calls.brand_id and kpis.partner_id = calls.partner_id and kpis.team_id = calls.team_id and kpis.user_id is null
		and kpis.campaign_name is null 
	where 1=1
		and dashboards.utils_format_week(calls.date) >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, kpis.ratio_calls_handled, kpis.ratio_calls_argumented, kpis.ratio_calls_engaged
	having 1=1
		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
--		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > 0 	-- Ignore records with no 'engaged' calls (ratio cannot be calculated)
		and kpis.ratio_calls_engaged > 0
	;

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Master procedure | Weekly Agent Quality | Campaigns
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_weekly_quality_agents_kpi_campaigns_refresh;
/*
create or replace procedure dashboards.trends_weekly_quality_agents_kpi_campaigns_refresh(_refresh_limit_ text) as $$
declare 
	__refresh_limit__ text := coalesce(_refresh_limit_, dashboards.utils_format_week((select min(c.date) from public.calls as c)), dashboards.utils_format_week('2020-01-01 00:00:00'::timestamp));
	__confidence_level__ int := 25;
begin
		
	delete from dashboards.trends_weekly_quality_agents where 1=1
		and week >= refresh_limit_text 
		and campaign_name is not null 
		and sponsor_id is not null and brand_id is not null and partner_id is null and team_id is null and user_id is null;
	commit;

	insert into dashboards.trends_weekly_quality_agents 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		calls.sponsor_id as sponsor_id,
		calls.brand_id as brand_id, 
		null::int as partner_id, 
		null::uuid as team_id, 
		null::uuid as user_id, 
		null::uuid as campaign_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year_ISO(calls.date) as year,
		dashboards.utils_format_week(calls.date) as week,
		-- Hierarchy
		sponsors.name as sponsor_name,
		brands.name as brand_name,
		null::varchar(999) as partner_name,
		null::varchar(999) as team_name,
		null::varchar(999) as agent_name,
		-- Campaigns
		dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name, 
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		null::numeric as quality_handled,
		null::numeric as quality_argumented,
		null::numeric as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
	left join public.brands as brands on brands.id = calls.brand_id 
	left join public.campaigns as campaigns on campaigns.id = calls.campaign_name 
	-- TODO FIXME: replace by campaign_id
	left join dashboards.trends_weekly_quality_agents as kpis on 1=1
		and kpis.week = dashboards.utils_format_week(calls.date) 
		and kpis.sponsor_id = calls.sponsor_id and kpis.brand_id = calls.brand_id and kpis.partner_id is null and kpis.team_id is null and kpis.user_id is null
		and kpis.campaign_name is null 
	where 1=1
		and dashboards.utils_format_week(calls.date) >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, kpis.ratio_calls_handled, kpis.ratio_calls_argumented, kpis.ratio_calls_engaged
	having 1=1
		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
--		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > 0 	-- Ignore records with no 'engaged' calls (ratio cannot be calculated)
		and kpis.ratio_calls_engaged > 0
	;

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Master procedure | Weekly Agent Quality | Partners by Campaign
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_weekly_quality_agents_kpi_partners_by_campaigns_refresh;
/*
create or replace procedure dashboards.trends_weekly_quality_agents_kpi_partners_by_campaigns_refresh(_refresh_limit_ text) as $$
declare 
	__refresh_limit__ text := coalesce(_refresh_limit_, dashboards.utils_format_week((select min(c.date) from public.calls as c)), dashboards.utils_format_week('2020-01-01 00:00:00'::timestamp));
	__confidence_level__ int := 25;
begin
		
	delete from dashboards.trends_weekly_quality_agents where 1=1
		and week >= refresh_limit_text 
		and campaign_name is not null 
		and sponsor_id is not null and brand_id is not null and partner_id is not null and team_id is null and user_id is null;
	commit;

	insert into dashboards.trends_weekly_quality_agents 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		calls.sponsor_id as sponsor_id,
		calls.brand_id as brand_id, 
		calls.partner_id as partner_id, 
		null::uuid as team_id, 
		null::uuid as user_id, 
		null::uuid as campaign_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year_ISO(calls.date) as year,
		dashboards.utils_format_week(calls.date) as week,
		-- Hierarchy
		sponsors.name as sponsor_name,
		brands.name as brand_name,
		partners.name as partner_name,
		null::varchar(999) as team_name,
		null::varchar(999) as agent_name,
		-- Campaigns
		dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name, 
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		null::numeric as quality_handled,
		null::numeric as quality_argumented,
		null::numeric as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
	left join public.brands as brands on brands.id = calls.brand_id 
	left join public.partners as partners on partners.id = calls.partner_id 
	left join dashboards.trends_weekly_quality_agents as kpis on 1=1
		and kpis.week = dashboards.utils_format_week(calls.date) 
		and kpis.sponsor_id = calls.sponsor_id and kpis.brand_id = calls.brand_id and kpis.partner_id is null and kpis.team_id is null and kpis.user_id is null
		and kpis.campaign_name = dashboards.utils_campaign_mapping(campaigns.id, campaigns.name)
	where 1=1
		and dashboards.utils_format_week(calls.date) >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, kpis.ratio_calls_handled, kpis.ratio_calls_argumented, kpis.ratio_calls_engaged
	having 1=1
		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
--		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > 0 	-- Ignore records with no 'engaged' calls (ratio cannot be calculated)
		and kpis.ratio_calls_engaged > 0
	;

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Master procedure | Weekly Agent Quality | Teams by Campaign
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_weekly_quality_agents_kpi_teams_by_campaigns_refresh;
/*
create or replace procedure dashboards.trends_weekly_quality_agents_kpi_teams_by_campaigns_refresh(_refresh_limit_ text) as $$
declare 
	__refresh_limit__ text := coalesce(_refresh_limit_, dashboards.utils_format_week((select min(c.date) from public.calls as c)), dashboards.utils_format_week('2020-01-01 00:00:00'::timestamp));
	__confidence_level__ int := 25;
begin
		
	delete from dashboards.trends_weekly_quality_agents where 1=1
		and week >= refresh_limit_text 
		and campaign_name is not null 
		and sponsor_id is not null and brand_id is not null and partner_id is not null and team_id is not null and user_id is null;
	commit;

	insert into dashboards.trends_weekly_quality_agents 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		calls.sponsor_id as sponsor_id,
		calls.brand_id as brand_id, 
		calls.partner_id as partner_id, 
		calls.team_id as team_id, 
		null::uuid as user_id, 
		null::uuid as campaign_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year_ISO(calls.date) as year,
		dashboards.utils_format_week(calls.date) as week,
		-- Hierarchy
		sponsors.name as sponsor_name,
		brands.name as brand_name,
		partners.name as partner_name,
		teams.name as team_name,
		null::varchar(999) as agent_name,
		-- Campaigns
		dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name, 
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		null::numeric as quality_handled,
		null::numeric as quality_argumented,
		null::numeric as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
	left join public.brands as brands on brands.id = calls.brand_id 
	left join public.partners as partners on partners.id = calls.partner_id 
	left join public.team as teams on teams.id = calls.team_id 
	left join dashboards.trends_weekly_quality_agents as kpis on 1=1
		and kpis.week = dashboards.utils_format_week(calls.date) 
		and kpis.sponsor_id = calls.sponsor_id and kpis.brand_id = calls.brand_id and kpis.partner_id = calls.partner_id and kpis.team_id is null and kpis.user_id is null
		and kpis.campaign_name = dashboards.utils_campaign_mapping(campaigns.id, campaigns.name)
	where 1=1
		and dashboards.utils_format_week(calls.date) >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, kpis.ratio_calls_handled, kpis.ratio_calls_argumented, kpis.ratio_calls_engaged
	having 1=1
		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
--		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > 0 	-- Ignore records with no 'engaged' calls (ratio cannot be calculated)
		and kpis.ratio_calls_engaged > 0
	;

end;
$$ language plpgsql;
*/


-- --------------------------------------------------------------------------------
-- Master procedure | Weekly Agent Quality | Agents by Campaign
-- --------------------------------------------------------------------------------

drop procedure if exists dashboards.trends_weekly_quality_agents_kpi_agents_by_campaigns_refresh;
/*
create or replace procedure dashboards.trends_weekly_quality_agents_kpi_agents_by_campaigns_refresh(_refresh_limit_ text) as $$
declare 
	__refresh_limit__ text := coalesce(_refresh_limit_, dashboards.utils_format_week((select min(c.date) from public.calls as c)), dashboards.utils_format_week('2020-01-01 00:00:00'::timestamp));
	__confidence_level__ int := 25;
begin
		
	delete from dashboards.trends_weekly_quality_agents where 1=1
		and week >= refresh_limit_text 
		and campaign_name is not null 
		and sponsor_id is not null and brand_id is not null and partner_id is not null and team_id is not null and user_id is not null;
	commit;

	insert into dashboards.trends_weekly_quality_agents 
	select
		-- --------------------------------------------------------------------------------
		-- Context
		calls.sponsor_id as sponsor_id,
		calls.brand_id as brand_id, 
		calls.partner_id as partner_id, 
		calls.team_id as team_id, 
		calls.user_id as user_id, 
		null::uuid as campaign_id,
		-- --------------------------------------------------------------------------------
		-- Time windows
		dashboards.utils_format_year_ISO(calls.date) as year,
		dashboards.utils_format_week(calls.date) as week,
		-- Hierarchy
		sponsors.name as sponsor_name,
		brands.name as brand_name,
		partners.name as partner_name,
		teams.name as team_name,
		agents.name as agent_name,
		-- Campaigns
		dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name, 
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) * 100.0 / count(*) as ratio_calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) * 100.0 / sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as ratio_calls_engaged,
		null::numeric as quality_handled,
		null::numeric as quality_argumented,
		null::numeric as quality_engaged,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > __confidence_level__ as confidence,
		-- Other Attributes
		count(distinct calls.id) as calls,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) as calls_handled,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) as calls_argumented,
		sum(case when dashboards.utils_call_type_id(calls.duration) >= 3 then 1 else 0 end) as calls_engaged,
		sum(dashboards.utils_duration_minutes(calls.duration)) as duration_minutes,
		round(sum(calls.cost)) as cost,
		round(sum(calls.cost) / sum(dashboards.utils_duration_minutes(calls.duration)), 2) as cost_per_minute
		-- --------------------------------------------------------------------------------
	from public.calls as calls
	left join public.sponsors as sponsors on sponsors.id = calls.sponsor_id 
	left join public.brands as brands on brands.id = calls.brand_id 
	left join public.partners as partners on partners.id = calls.partner_id 
	left join public.team as teams on teams.id = calls.team_id 
	left join public.users as users on users.id = calls.user_id 
	left join public.accounts as agents on agents.id = users.account_id 
	left join dashboards.trends_weekly_quality_agents as kpis on 1=1
		and kpis.week = dashboards.utils_format_week(calls.date) 
		and kpis.sponsor_id = calls.sponsor_id and kpis.brand_id = calls.brand_id and kpis.partner_id = calls.partner_id and kpis.team_id = team_id and kpis.user_id is null
		and kpis.campaign_name = dashboards.utils_campaign_mapping(campaigns.id, campaigns.name)
	where 1=1
		and dashboards.utils_format_week(calls.date) >= __refresh_limit__
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, kpis.ratio_calls_handled, kpis.ratio_calls_argumented, kpis.ratio_calls_engaged
	having 1=1
		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 1 then 1 else 0 end) > 0 	-- Ignore records with no 'handled' calls (ratio cannot be calculated)
--		and sum(case when dashboards.utils_call_type_id(calls.duration) >= 2 then 1 else 0 end) > 0 	-- Ignore records with no 'engaged' calls (ratio cannot be calculated)
		and kpis.ratio_calls_engaged > 0
	;

end;
$$ language plpgsql;
*/








-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Sliding Window (snapshot)
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------




-- --------------------------------------------------------------------------------
-- Agent Quality | last 6 weeks
-- --------------------------------------------------------------------------------

-- select * from dashboards.quality_agents;

drop view if exists dashboards.quality_agents;
/*
create or replace view dashboards.quality_agents as 
with campaign_quality as (select * from dashboards.quality_campaigns)
select 
	-- --------------------------------------------------------------------------------
	-- Context
	to_char(current_date - interval '42 days', 'YYYY-MM-DD') as assessment_start,
	42 as assessment_period,
	-- --------------------------------------------------------------------------------
	-- Hierarchy
	coalesce(sponsors.name, 'Ganira PT') as sponsor_name,
	brands.name as brand_name,
	partners.name as partner_name,
	coalesce(teams.name, partners.name || ' (default)') as team_name,
	agents.name as agent_name,
	-- Campaigns
	dashboards.utils_campaign_mapping(campaigns.id, campaigns.name) as campaign_name,
--	files.name as file_name,
	-- --------------------------------------------------------------------------------
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
	-- --------------------------------------------------------------------------------
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
*/


