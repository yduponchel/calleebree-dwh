-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- General
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

-- TODO
-- -- Add cron table to periodically refresh materialized views and aggregation tables
-- -- Add UnitTest table to log outcome of test on the various functions
-- -- -- Table shall include function name, input parameters, expected result, success flag, test date
-- -- -- also have a query that calculate the test coverage (how many functions in the test tbale vs how many defined in the schema...)
-- -- Multiple graphs may use the same source view => (schema, table) cannot be the key in the public_reports table...
-- -- -- UUID shall be added in the inserts to ensure references in the frontend keep working when table is regenerated
-- -- -- a mechanism shall be defined to explicitly define which attributes can be used for "time" filtering, "model" filtering, "business" filtering... 
-- -- -- it shall also be possible to define if some attributes cannot be aggregated (ex: campaigns in the campaign quality table) and which/how other attributes can be aggregated (sum, count, average, max, min)
-- -- Quality views shall be tables, in Campaign Quality, a 2nd pass shall be performed to provide a campaign quality score for all campaigns not just the call KPIs
-- -- Rename 'sponsor' to 'organization'

-- --------------------------------------------------------------------------------

-- drop schema dashboards cascade;
-- create schema dashboards;



-- --------------------------------------------------------------------------------
-- Reports
-- --------------------------------------------------------------------------------

drop table if exists dashboards.public_reports;
create table if not exists dashboards.public_reports (
	-- --------------------------------------------------------------------------------
	id uuid default gen_random_uuid () primary key,
	-- 
	source_schema varchar(256),
	source_table varchar(256),
	name varchar(256), 											-- Report name to be displayed in the frontend
	description varchar,										-- Report description to be displayed in the frontend
	ranking int,												-- Rank of the report in the list of available dashboards
	aggregated boolean default false,							-- Is the data aggregated or raw data (typically at call,  contact, and/or agent level)
	roles_allowed int[], 										-- List of role_id allowed to use the report
	enabled boolean default true,
	caching int default null,									-- How long (in seconds) should a report be cached
	-- 
	created_date timestamp default current_timestamp,
	-- --------------------------------------------------------------------------------
	-- Constraints
	unique (source_schema, source_table),
	unique (name)
);

-- --------------------------------------------------------------------------------

delete from dashboards.public_reports where 1=1;
insert into dashboards.public_reports (source_schema, source_table, name, description, ranking, aggregated, roles_allowed, caching) values 
	( 'dashboards',	'summary_call_statistics',		'[Overview] Call Statistics',						'Overview of calls and call outcome aggregated per day/week/month/... and team/partner/brand/...', 100, true, '{0,1,2,3,4}', 3600 * 6),
	( 'dashboards',	'summary_contact_statistics',	'[Overview] Contact Statistics',					'Overview of contacts per outcomeaggregated per file and team/partner/brand/...', 101, true, '{0,1,2}', 3600 * 6),
	( 'dashboards',	'summary_agent_statistics',		'[Overview] Agent Statistics',						'Overview of call statistics per agent aggregated per week/month/... and team/partner/brand/...', 102, true, '{0,1,2,3,4}', 3600 * 24),
	( 'dashboards',	'summary_call_costs',			'[Overview] Call Costs',							'Overview of call types & call costs aggregated per day/week/month/... and team/partner/brand/...', 200, true, '{0,1}', 3600 * 6),
	( 'dashboards',	'details_call_cost_expensive',	'[Raw Data] Call details (expensive calls *only*)',	'Raw data exports with call type & call cost information for expensive calls', 900, false, '{0,1}', 3600 * 12)
;

-- select * from dashboards.public_reports;



-- --------------------------------------------------------------------------------
-- Widgets
-- --------------------------------------------------------------------------------

drop table if exists dashboards.public_widgets;
create table if not exists dashboards.public_widgets (
	-- --------------------------------------------------------------------------------
	id uuid default gen_random_uuid() primary key,
	-- 
	source_schema varchar(256),
	source_table varchar(256),
	widget_name varchar(256), 			-- Report name to be displayed in the frontend
	widget_description varchar,			-- Report description to be displayed in the frontend
	widget_ranking int,					-- Rank of the report in the list of available dashboards
	roles_allowed int[], 				-- List of role_id allowed to use the widget
	enabled boolean default true,
	caching int default null,			-- How long (in seconds) should a report be cached
	-- 
	graph_title varchar(256),			-- Title to be displayed in the graph (or NULL for none)
	graph_description varchar,			-- Description to be displayed with the graph (or NULL for none)	
	-- 
	X_dimension1 varchar(256),			-- Name of the column for the primary X-series (for example: 'my_dates')
	X_dimension2 varchar(256),			-- Name of the column for the secondary X-series (for example: 'my_months')
	X_dimension3 varchar(256),			-- Name of the column for the tertiary X-series (for example: 'my_years')
	X_title varchar(256),				-- Title to be displayed for the X-axis (or NULL for none)
	X_sort int default 0,				-- Order in which values on the X-axis shall be sorted (0: none | +1: ascending | -1: desceding)
	-- 
	Y1_dimension1 varchar(256),			-- Name of the column for the primary Y1-series (for example: 'my_brands')
	Y1_dimension2 varchar(256),			-- Name of the column for the secondary Y1-series (for example: 'my_partners')
	Y1_dimension3 varchar(256),			-- Name of the column for the tertiary Y1-series (for example: 'my_teams')
	Y1_title varchar(256),				-- Title to be displayed for the Y1-axis (or NULL for none)
	Y1_sort int default 0,				-- Order in which values on the Y1-axis shall be sorted (0: none | +1: ascending | -1: desceding)
	Y1_chart_type varchar(128),			-- Type of chart used with the Y1-axis ('stacked columns' | '100% stacked columns' | 'lines' | 'pivot' | 'stacked bars' | '100% stacked bars' | 'pie' | 'donut' | 'dots')
	Y1_metric varchar(256),				-- Name of the column containing the values related to the Y1-dimensions
	Y1_aggregation varchar(32),			-- Type of aggregation for the values related to the Y1-dimensions ('sum' | 'average' | 'count' | 'min' | 'max' | 'distinct' | 'none')
	-- 
	Y2_dimension1 varchar(256),			-- Name of the column for the primary Y2-series (for example: 'my_brands')
	Y2_dimension2 varchar(256),			-- Name of the column for the secondary Y2-series (for example: 'my_campaigns')
	Y2_dimension3 varchar(256),			-- Name of the column for the tertiary Y2-series (for example: 'my_files')
	Y2_title varchar(256),				-- Title to be displayed for the Y2-axis (or NULL for none)
	Y2_sort int default 0,				-- Order in which values on the Y2-axis shall be sorted (0: none | +1: ascending | -1: desceding)
	Y2_chart_type varchar(128),			-- Type of chart used with the Y1-axis ('lines' | 'stacked columns' | '100% stacked columns' | 'dots')
	Y2_metric varchar(256),				-- Name of the column containing the values related to the Y2-dimensions
	Y2_aggregation varchar(32),			-- Type of aggregation for the values related to the Y2-dimensions ('sum' | 'average' | 'count' | 'none')
	-- 
	created_date timestamp default current_timestamp,
	-- --------------------------------------------------------------------------------
	-- Constraints
	unique (widget_name)
);

-- --------------------------------------------------------------------------------

delete from dashboards.public_widgets where 1=1;
insert into dashboards.public_widgets (
		id, source_schema, source_table, widget_name, widget_description, widget_ranking, roles_allowed, enabled, caching,
		graph_title, graph_description,
		X_dimension1, X_dimension2, X_dimension3, X_title, X_sort,
		Y1_dimension1, Y1_dimension2, Y1_dimension3, Y1_title, Y1_sort, Y1_metric, Y1_aggregation, Y1_chart_type,
		Y2_dimension1, Y2_dimension2, Y2_dimension3, Y2_title, Y2_sort, Y2_metric, Y2_aggregation, Y2_chart_type
	) values 
	( 
		'ec03fc9f-65fa-4611-9119-1e6d025faf6f', 'dashboards', 'widget_cost_monthly', 'Monthly Costs', 'Breakdown of cost structure', 887, '{0,1}', true, 3600 * 12,
		'Monthly Costs Breakdown', 'Breakdown of cost structure',
		'month', null, null, 'Months', +1,
		'campaign_name', null, null, 'Costs (USD)', 0, 'stacked columns', 'cost', 'sum', 
		null, null, null, 'Total Duration (minutes)', 0, 'lines', 'duration_minutes', 'sum'
	),
	(
		'14b73fdb-bc85-4757-b940-7a07ed72a9b2', 'dashboards', 'widget_quality_campaigns_monthly', 'Campaign Quality Trend (Engagement Level)', 'Engagement quality in comparison to call volume', 127, '{0,1,2}', true, 3600 * 12,
		'Campaign Quality (Engagement Level)', 'Engagement quality in comparison to call volume (100 = average; higher is better)',
		'month', null, null, 'Months', +1,
		'campaign_name', null, null, 'Call Volume (#)', 0, 'stacked columns', 'calls', 'sum', 
		'campaign_name', null, null, 'Engagement KPI (100=average)', 0, 'lines', 'quality_engaged', 'average'
	),
	(
		'ba589261-525d-496a-b183-62dc2cc94c97', 'dashboards', 'widget_quality_campaigns_current', 'Campaign Quality (Engagement Level)', 'Various quality KPIs in comparison to call volume', 200, '{0,1,2,3,4}', true, 3600 * 4,
		'Campaign Quality (Engagement Level)', 'Call volume with breakdown per call type in comparison to call volume (100 = average; higher is better)',
		'campaign_name', null, null, 'Campaigns', 0,
		'call_type', null, null, 'Call Volume (#)', +1, 'stacked bars', 'calls', 'sum', 
		null, null, null, 'Engagement KPI (100=average)', 0, 'dots', 'quality_engaged', 'average'
	),
	(
		'38f63030-4908-4118-9bcf-bd0d6e495a88', 'dashboards', 'trends_productivity_monthly_partners', 'Monthly Productivity | Partners', 'Monthly productivity KPIs per partner', 301, '{0,1,2}', true, 3600 * 12,
		'Monthly Productivity | Partners', 'Monthly productivity per partner',
		'month', null, null, 'Months', +1,
		'campaign_name', null, null, 'Productive Hours (#)', +1, 'stacked bars', 'total_productive_hours', 'sum', 
		'campaign_name', null, null, 'Productive FTEs (#)', 0, 'lines', 'total_FTE', 'average'
	),
	(
		'89ac0eac-b9e4-4d96-8223-46e8dbab010e', 'dashboards', 'trends_productivity_monthly_campaigns', 'Monthly Productivity | Campaigns', 'Monthly productivity KPIs per campaign and per brand', 301, '{0,1,2}', true, 3600 * 12,
		'Monthly Productivity | Campaigns', 'Monthly productivity KPIs per campaign',
		'month', null, null, 'Months', +1,
		'campaign_name', null, null, 'Productive Hours (#)', +1, 'stacked bars', 'total_productive_hours', 'sum', 
		'campaign_name', null, null, 'Productive FTEs (#)', 0, 'lines', 'total_FTE', 'average'
	),
	(
		'421e4cd4-dc4b-4f8c-8b91-2a2c72675c6a', 'dashboards', 'trends_productivity_weekly_partners', 'Weekly Productivity | Partners', 'Weekly productivity KPIs per partner', 302, '{0,1,2}', true, 3600 * 12,
		'Weekly Productivity | Partners', 'Weekly productivity per partner',
		'week', null, null, 'Weeks', +1,
		'campaign_name', null, null, 'Productive Hours (#)', +1, 'stacked bars', 'total_productive_hours', 'sum', 
		'campaign_name', null, null, 'Productive FTEs (#)', 0, 'lines', 'total_FTE', 'average'
	),
	(
		'69e058cb-9945-4e4f-875d-39cbb5693ef7', 'dashboards', 'trends_productivity_weekly_campaigns', 'Weekly Productivity | Campaigns', 'Weekly productivity KPIs per campaign and per brand', 303, '{0,1,2}', true, 3600 * 12,
		'Weekly Productivity | Campaigns', 'Weekly productivity KPIs per campaign',
		'week', null, null, 'Weeks', +1,
		'campaign_name', null, null, 'Productive Hours (#)', +1, 'stacked bars', 'total_productive_hours', 'sum', 
		'campaign_name', null, null, 'Productive FTEs (#)', 0, 'lines', 'total_FTE', 'average'
	),
	(
		'76c8dee9-0e28-4962-a462-59d1f15aac86', 'dashboards', 'trends_productivity_daily_partners', 'Daily Productivity | Partners', 'Daily productivity KPIs per partner', 304, '{0,1,2}', true, 3600 * 1,
		'Daily Productivity | Partners', 'Daily productivity per partner',
		'day', null, null, 'Days', +1,
		'campaign_name', null, null, 'Productive Hours (#)', +1, 'stacked bars', 'total_productive_hours', 'sum', 
		'campaign_name', null, null, 'Productive FTEs (#)', 0, 'lines', 'total_FTE', 'average'
	),
	(
		'd688e3e9-0ed8-4f46-9702-996f007d2bf4', 'dashboards', 'trends_productivity_daily_campaigns', 'Daily Productivity | Campaigns', 'Daily productivity KPIs per campaign and per brand', 305, '{0,1,2}', true, 3600 * 1,
		'Daily Productivity | Campaigns', 'Daily productivity KPIs per campaign',
		'day', null, null, 'Days', +1,
		'campaign_name', null, null, 'Productive Hours (#)', +1, 'stacked bars', 'total_productive_hours', 'sum', 
		'campaign_name', null, null, 'Productive FTEs (#)', 0, 'lines', 'total_FTE', 'average'
	),
	(
		'e7ff86c5-4423-481a-971d-d8741cf7d433', 'dashboards', 'trends_reachability', 'Reachability', 'Rechability trends', 400, '{0,1,2}', false, 3600 * 1,
		'Reachability (week)', 'Rechability trends',
		'week', null, null, 'Week', +1,
		'call_type', 'campaignn', null, 'Reachability (%)', +1, '100% stacked bars', 'total_calls', 'sum', 
		null, null, null, null, 0, 'lines', null, 'average'
	),
	(
		gen_random_uuid(), 'dashboards', 'some_table_or_view', 'Widget Title', 'Some widget description', 999, '{0,1,2}', false, 60 * 15,
		'Chart Title', 'Some chart description',
		'day', null, null, 'Days', +1,
		'campaign_name', null, null, 'Hours (#)', +1, 'stacked bars', 'hours', 'sum', 
		'campaign_name', null, null, 'Conversion (%)', 0, 'lines', 'conversion', 'average'
	)
;

-- select * from dashboards.public_widgets;



-- --------------------------------------------------------------------------------
-- Consistency Checks
-- --------------------------------------------------------------------------------

drop table if exists dashboards.reports_skeleton;
create table if not exists dashboards.reports_skeleton (
	-- --------------------------------------------------------------------------------
	id uuid default gen_random_uuid () primary key,
	-- 
	column_name varchar(256),
	udt_name varchar(256),
	type_length int,
	ordinal_position int,
	-- --------------------------------------------------------------------------------
	-- Constraints
	unique (column_name)
);

-- --------------------------------------------------------------------------------

delete from dashboards.reports_skeleton where 1=1;
insert into dashboards.reports_skeleton (column_name, udt_name, type_length, ordinal_position) values 
	-- Object IDs
	( 'sponsor_id', 'int4', 32, 1 ),
	( 'brand_id', 'int4', 32, 2 ),
	( 'partner_id', 'varchar', 36, 3 ), -- defined as varchar(40) in 'partners' table, but referenced as varchar(36) in other places, and actually either 36 (which is in fact a uuid) or 24 (apparently only 4 old tests on sponsor_id = 100)
--	( 'partner_id', 'uuid', null, 3 ),
	( 'team_id', 'uuid', null, 4 ),
	( 'user_id', 'uuid', null, 5 ),
	( 'campaign_id', 'varchar', 36, 6 ), -- defined as varchar(40) in 'campaigns' table, but referenced as varchar(36) in other places and always seems to be a uuid encoded on 36 chars
--	( 'campaign_id', 'uuid', null, 3 ),
	( 'file_id', 'varchar', 36, 7 ), -- defined as varchar(36) in 'files', but always seems to be a uuid encoded on 36 chars
	-- Time intervals
	( 'year', 'bpchar', 4, 8 ),
	( 'month', 'bpchar', 7, 9 ),
	( 'week', 'bpchar', 7, 10 ),
	( 'date', 'bpchar', 10, 11 ),
	( 'day_of_week', 'bpchar', 12, 12 ), -- [1-7]. [A-Z][a-z ]{8}
	-- Object names
	( 'sponsor_name', 'varchar', 128, 13 ),
	( 'brand_name', 'varchar', 128, 14 ),
	( 'partner_name', 'varchar', 256, 15 ),
	( 'team_name', 'varchar', 128, 16 ),
	( 'agent_name', 'varchar', 128, 17 ),
	( 'campaign_name', 'varchar', 256, 18 ),
	( 'file_name', 'varchar', 256, 19 )
;

-- select * from dashboards.reports_skeleton;

-- --------------------------------------------------------------------------------
-- Model inconsistencies
-- --------------------------------------------------------------------------------

drop view if exists dashboards.utils_check_model_inconsistent;
create or replace view dashboards.utils_check_model_inconsistent as 
select 
	-- Context
	info_tables.table_type,
	info_tables.table_schema,
	info_tables.table_name,
	info_columns.column_name,
	info_columns.udt_name,
--	info_columns.data_type,
	coalesce(info_columns.character_maximum_length, info_columns.numeric_precision) as type_length,
	info_columns.ordinal_position
from information_schema.tables as info_tables
left join information_schema.columns as info_columns on info_tables.table_schema = info_columns.table_schema and info_columns.table_name = info_tables.table_name 
where 1=1
	and info_tables.table_schema = 'public'
	and info_columns.column_name like '%_id'
order by info_columns.column_name, info_tables.table_name
;

-- select * from dashboards.utils_check_model_inconsistent;



-- --------------------------------------------------------------------------------
-- Missing tables
-- --------------------------------------------------------------------------------

drop view if exists dashboards.utils_check_dashboards_missing;
create or replace view dashboards.utils_check_dashboards_missing as 
with checks as (
	select 'reports', reports.source_schema, reports.source_table from dashboards.public_reports as reports
	union
	select 'widgets', widgets.source_schema, widgets.source_table from dashboards.public_widgets as widgets
	order by 1, 2, 3
	)		
select 
	checks.source_schema,
	checks.source_table,
	case when info_tables.table_name is null then null else skeleton.column_name end as column_name,
	case when info_tables.table_name is null then null else skeleton.ordinal_position end as ordinal_position
from checks as checks
left join information_schema.tables as info_tables on checks.source_schema = info_tables.table_schema and checks.source_table = info_tables.table_name 
full join dashboards.reports_skeleton as skeleton on 1=1 
left join information_schema.columns as info_columns on info_tables.table_name = info_columns.table_name and info_columns.column_name = skeleton.column_name
where 1=0 
	or info_tables.table_name is null	
	or info_columns.column_name is null
group by 1, 2, 3, 4
order by 1, 2, 4
;

-- select * from dashboards.utils_check_dashboards_missing;



-- --------------------------------------------------------------------------------
-- Inconsistent tables
-- --------------------------------------------------------------------------------

drop view if exists dashboards.utils_check_dashboards_inconsistent;
create or replace view dashboards.utils_check_dashboards_inconsistent as 
with checks as (
	select 'reports', reports.source_schema, reports.source_table from dashboards.public_reports as reports
	union
	select 'widgets', widgets.source_schema, widgets.source_table from dashboards.public_widgets as widgets
	order by 1, 2, 3
	)		
select 
	-- Context
	info_tables.table_type,
	info_tables.table_name,
	-- Matching overview
	info_columns.column_name is not null as matching_column_name,
	coalesce(info_columns.udt_name = skeleton.udt_name, false) or (skeleton.udt_name = 'bpchar' and info_columns.udt_name = 'varchar') as matching_udt_name,
	coalesce(skeleton.type_length, -1) = coalesce(info_columns.character_maximum_length, info_columns.numeric_precision, -1) or coalesce(info_columns.character_maximum_length, info_columns.numeric_precision) is null as matching_type_length,
	coalesce(info_columns.ordinal_position = skeleton.ordinal_position, false) as matching_ordinal_position,
	-- Matching details
	skeleton.column_name as REF_column_name,
	info_columns.column_name as ACT_column_name,
	skeleton.udt_name as REF_udt_name,
	info_columns.udt_name as ACT_udt_name,
--	info_columns.data_type as ACT_data_type,
	skeleton.type_length as REF_type_length,
	coalesce(info_columns.character_maximum_length, info_columns.numeric_precision) as ACT_type_length,
	skeleton.ordinal_position as REF_ordinal_position,
	info_columns.ordinal_position as ACT_ordinal_position
from checks as checks
left join information_schema.tables as info_tables on info_tables.table_schema = checks.source_schema and info_tables.table_name = checks.source_table
full join dashboards.reports_skeleton as skeleton on 1=1
left join information_schema.columns as info_columns on info_tables.table_schema = info_columns.table_schema and info_columns.table_name = info_tables.table_name and info_columns.column_name = skeleton.column_name
where 1=1
	and info_tables.table_schema = 'dashboards'
	and ( 0=1
			or info_columns.column_name is null
			or not (coalesce(info_columns.udt_name = skeleton.udt_name, false) or (skeleton.udt_name = 'bpchar' and info_columns.udt_name = 'varchar'))
			or not (coalesce(skeleton.type_length, -1) = coalesce(info_columns.character_maximum_length, info_columns.numeric_precision, -1) or coalesce(info_columns.character_maximum_length, info_columns.numeric_precision) is null)
--			or not coalesce(info_columns.ordinal_position = skeleton.ordinal_position, false)
		)
order by info_tables.table_name, skeleton.ordinal_position
;

-- select * from dashboards.utils_check_dashboards_inconsistent;


