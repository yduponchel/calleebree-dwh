-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- 
-- Productivity KPIs & Statistics
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

-- Query Time: 20 seconds
-- select * from dashboards.trends_productivity(true, true, false, false, false, true, false, 'month'); 			-- sponsor, brand, partner, team, agent, campaign, file, custom interval ('last 3 weeks' / 'last 6 weeks' / 'last 3 months')
-- select * from dashboards.trends_productivity(true, true, false, false, false, true, false, 'last 6 weeks'); 		-- sponsor, brand, partner, team, agent, campaign, file, custom interval ('last 3 weeks' / 'last 6 weeks' / 'last 3 months')

drop function if exists dashboards.trends_productivity cascade;
--	sponsor, brand, partner, team, agent, campaign, file in (true, false)
--	interval in ('month', 'week', 'day', 'last 3 weeks', 'last 6 weeks', 'last 3 months')
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
-- Quality Index | Core Algorithm
-- 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

-- Sub-Query Time: 20 seconds
-- select * from dashboards.trends_productivity(true, true, false, false, false, true, false, 'month'); 			-- sponsor, brand, partner, team, agent, campaign, file, custom interval ('last 3 weeks' / 'last 6 weeks' / 'last 3 months')
-- select * from dashboards.trends_productivity(true, true, false, false, false, true, false, 'last 6 weeks'); 		-- sponsor, brand, partner, team, agent, campaign, file, custom interval ('last 3 weeks' / 'last 6 weeks' / 'last 3 months')

-- Query Time: xx seconds
-- select * from dashboards.trends_quality('campaign', true, 'month'); 						-- _level_ in ('global', 'sponsor', 'brand', 'partner', 'team', 'agent', 'campaign', 'file')


-- select * from dashboards.trends_productivity(true, true, false, false, false, true, false, 'last 6 weeks'); 

-- select * from dashboards.trends_quality('campaign', true, 'month');						-- level in ('sponsor', 'brand', 'partner', 'team', 'agent', 'campaign', 'file') | breakdown in (true, false) | interval in ('month', 'week', 'day', 'last 3 weeks', 'last 6 weeks', 'last 3 months')

-- TODO FIXME: all volumes seems to be multiplied by X where X is a multiple of 10 (smallest number is 20, all numbers are "round")
-- TODO FIXME: check volumes with sub-query
-- TODO FIXME: index quality seems weird, most likely not surprising if volumes are incorrect

drop function if exists dashboards.trends_quality cascade;
--	level in ('sponsor', 'brand', 'partner', 'team', 'agent', 'campaign', 'file')
--	breakdown in (true, false) 
--	interval in ('month', 'week', 'day', 'last 3 weeks', 'last 6 weeks', 'last 3 months')
create or replace function dashboards.trends_quality(_level_ text, _campaign_breakdown_ boolean, _interval_ text) 
--
-- Quality KPI Calculation: example: Partner with Brand as reference => Index_Engagement{partner/brand}
--                                   ____________                                                                       
--                                   \                % Engagement{partner|campaign{i}} x Weight{partner|campaign{i}}                  
--                                    \             ___________________________________________________________________ 
-- Index_Engagement{partner/brand} =  /                                 % Engagement{campaign{i}}                                 
--                                   /___________                                                                       
--                                    campaign{i}                                                                       
-- 
--                                   ____________                                                                       
--                                   \                  Sum[ Calls_Engaged{partner|campaign{i}} ] / Sum[ Calls_Handled{partner|campaign{i}} ]   X   Sum[ Calls_Handled{partner|campaign{i}} ] / Sum[ Calls_Handled{partner} ]
--                                    \             _____________________________________________________________________________________________________________________________________________________________________________
-- Index_Engagement{partner/brand} =  /                                                   Sum[ Calls_Engaged{campaign{i}} ] / Sum[ Calls_Handled{campaign{i}} ]
--                                   /___________                                                                       
--                                    campaign{i}                                                                       
-- 
--                                                                       ____________                                                                       
--                                                  1                    \                Sum[ Calls_Engaged{partner|campaign{i}} ]   X   Sum[ Calls_Handled{campaign{i}} ]
--                                   _______________________________  X   \             _____________________________________________________________________________________
-- Index_Engagement{partner/brand} =  Sum[ Calls_Handled{partner} ]       /                                     Sum[ Calls_Engaged{campaign{i}} ]
--                                                                       /___________                                                  
--                                                                        campaign{i}                                                                       
-- 
returns table (
	sponsor_id int, brand_id int, partner_id varchar(36) /*uuid*/, team_id uuid, user_id uuid, campaign_id varchar(36) /*uuid*/, file_id varchar(36) /*uuid*/,
	year char(4), month char(7), week char(7), date char(10), day_of_week char(12), custom_interval varchar(64),
	sponsor_name varchar(128), brand_name varchar(128), partner_name varchar(256), team_name varchar(128), agent_name varchar(128), campaign_name varchar(256), file_name varchar(256), 
	total_calls bigint, total_calls_handled bigint, total_calls_argumented bigint, total_calls_engaged bigint, total_calls_converted bigint, 
	total_productive_hours numeric,
	percent_calls_handled numeric, percent_calls_argumented numeric, percent_calls_engaged numeric, percent_calls_converted numeric,
	index_quality_calls_handled numeric, index_quality_calls_argumented numeric, index_quality_calls_engaged numeric, index_quality_calls_converted numeric,
	confidence boolean, confidence_value double precision,
	check_proxy bigint, check_reference bigint
	) as $$
declare
	_pi_ double precision := 3.14159265359;
	_confidence_calls_threshold_ double precision := 100.0; 			-- Number of calls to consider the confidence to be "good" 		|| confidence is "good"							<==> sum(calls) >= confidence_calls_threshold		<==> confidence >= confidence_value_threshold
	_confidence_value_threshold_ double precision := 80.0; 				-- Value  within [0..100] that defines confidence as "good"		|| sum(calls) = confidence_calls_threshold 		==> confidence = confidence_value_threshold
	_confidence_calls_middle_ double precision := 65.0;					-- Number of calls to reach a confidence of "50"				|| sum(calls) = confidence_middle 				==> confidence = 50
	_confidence_scale_ double precision := (_confidence_value_threshold_ - _confidence_calls_middle_) / tan((_confidence_value_threshold_ - 50) * _pi_ / 100.0); --									|| -pi/2 < arctan(x) < +pi/2 || y = arctan(x) 	<==> tan(y) = x 		|| arctan( ( confidence_calls_threshold - confidence_calls_middle) / confidence_scale ) / pi * 100 + 50 = confidence_value_threshold
	_hours_threshold_ numeric := 0.2; 							-- min number of dialing hours to include the data point in the calculations
	_calls_threshold_ numeric := 50.0							-- min number of calls to include the data point in the calculations
		* case 
			when _interval_ = 'month' then 2.0
			when _interval_ = 'week' then 1.0
			when _interval_ = 'day' then 0.5
			else 1.5 end -- Ex: custom interval such as 'last 6 weeks'
		* case
		when _level_ in ('team', 'campaign') then 0.75
		when _level_ in ('agent') then 0.5
		else 1.0 end;
	-- --------------------------------------------------------------------------------
	-- result=sponsor | brand | campaign => global 							=> proxy=sponsor|...				=> reference=global
	-- result=(partner, campaign) | (team, campaign) | (agent, campaign) 	=> proxy=(partner|..., campaign)	=> reference=campaign
	-- result=partner | team | agent (weighted average by campaign) 		=> proxy=(partner|..., campaign)	=> reference=brand (with campaign breakdown)
	-- --------------------------------------------------------------------------------
	_reference_brand_ boolean := _level_ in ('partner', 'team', 'agent');
	_reference_campaign_ boolean := _level_ in ('partner', 'team', 'agent', 'file');
	-- 
	_proxy_sponsor_ boolean := _level_ in ('sponsor', 'brand', 'partner', 'team', 'agent', 'campaign', 'file');
	_proxy_brand_ boolean := _level_ in ('brand', 'partner', 'team', 'agent', 'campaign', 'file');
	_proxy_partner_ boolean := _level_ in ('partner', 'team', 'agent');
	_proxy_team_ boolean := _level_ in ('team', 'agent');
	_proxy_agent_ boolean := _level_ in ('agent');
	_proxy_campaign_ boolean := _level_ in ('partner', 'team', 'agent', 'campaign', 'file');
	_proxy_file_ boolean := _level_ in ('file');
	-- 
	_result_sponsor_ boolean := _level_ in ('sponsor', 'brand', 'partner', 'team', 'agent', 'campaign', 'file');
	_result_brand_ boolean := _level_ in ('brand', 'partner', 'team', 'agent', 'campaign', 'file');
	_result_partner_ boolean := _level_ in ('partner', 'team', 'agent');
	_result_team_ boolean := _level_ in ('team', 'agent');
	_result_agent_ boolean := _level_ in ('agent');
	_result_campaign_ boolean := _level_ in ('campaign', 'file') or (_campaign_breakdown_ and _level_ in ('partner', 'team', 'agent'));
	_result_file_ boolean := _level_ in ('file');
begin
	return query 
	with 
		proxy as (select * from dashboards.trends_productivity(_proxy_sponsor_, _proxy_brand_, _proxy_partner_, _proxy_team_, _proxy_agent_, _proxy_campaign_, _proxy_file_, _interval_)),
		reference as (select * from dashboards.trends_productivity(_reference_brand_, _reference_brand_, false, false, false, _reference_campaign_, false, _interval_))
	select 
		-- --------------------------------------------------------------------------------
		-- Context
		case when _result_sponsor_ then proxy.sponsor_id else null end as sponsor_id,
		case when _result_brand_ then proxy.brand_id else null end as brand_id, 
		case when _result_partner_ then proxy.partner_id else null end as partner_id, 
		case when _result_team_ then proxy.team_id else null end as team_id,  
		case when _result_agent_ then proxy.user_id else null end as user_id, 
		case when _result_campaign_ then proxy.campaign_id else null end as campaign_id, 
		case when _result_file_ then proxy.file_id else null end as file_id, 
		-- --------------------------------------------------------------------------------
		-- Time windows
		proxy.year as year,
		proxy.month as month,
		proxy.week as week,
		proxy.date as date,
		proxy.day_of_week as day_of_week,
		proxy.custom_interval as custom_interval,
		-- Hierarchy
		case when _result_sponsor_ then proxy.sponsor_name else null end as sponsor_name,
		case when _result_brand_ then proxy.brand_name else null end as brand_name,
		case when _result_partner_ then proxy.partner_name else null end as partner_name,
		case when _result_team_ then proxy.team_name else null end as team_name, 
		case when _result_agent_ then proxy.agent_name else null end as agent_name,
		case when _result_campaign_ then proxy.campaign_name else null end as campaign_name, 
		case when _result_file_ then proxy.file_name else null end as file_name, 
		-- --------------------------------------------------------------------------------
		-- Call volumes
		sum(proxy.total_calls)::bigint as total_calls,
		sum(proxy.total_calls_handled)::bigint as total_calls_handled,
		sum(proxy.total_calls_argumented)::bigint as total_calls_argumented,
		sum(proxy.total_calls_engaged)::bigint as total_calls_engaged,
		sum(proxy.total_calls_converted)::bigint as total_calls_converted,
		-- Other Volumes
		sum(proxy.total_productive_hours) as total_productive_hours,
		-- Efficency KPIs
		dashboards.utils_percent(sum(proxy.total_calls_handled), sum(proxy.total_calls), 1)  as percent_calls_handled,
		dashboards.utils_percent(sum(proxy.total_calls_argumented), sum(proxy.total_calls_handled), 1)  as percent_calls_argumented,
		dashboards.utils_percent(sum(proxy.total_calls_engaged), sum(proxy.total_calls_handled), 2)  as percent_calls_engaged,
		dashboards.utils_percent(sum(proxy.total_calls_converted), sum(proxy.total_calls_handled), 3)  as percent_calls_converted,
		-- --------------------------------------------------------------------------------
		-- Quality KPIs
		dashboards.utils_ratio(
			100.0 * sum(
				dashboards.utils_division(
					proxy.total_calls_handled
						* reference.total_calls,
					reference.total_calls_handled)), 
			sum(proxy.total_calls),
			1) as index_quality_calls_handled,
		dashboards.utils_ratio(
			100.0 * sum(
				dashboards.utils_division(
					proxy.total_calls_argumented
						* reference.total_calls_handled,
					reference.total_calls_argumented)), 
			sum(proxy.total_calls_handled),
			1) as index_quality_calls_argumented,
		dashboards.utils_ratio(
			100.0 * sum(
				dashboards.utils_division(
					proxy.total_calls_engaged
						* reference.total_calls_handled,
					reference.total_calls_engaged)),
			sum(proxy.total_calls_handled),
			1) as index_quality_calls_engaged,
		dashboards.utils_ratio(
			100.0 * sum(
				dashboards.utils_division(
					proxy.total_calls_converted
						* reference.total_calls_handled,
					reference.total_calls_converted)),
			sum(proxy.total_calls_handled),
			1) as index_quality_calls_converted,
		-- --------------------------------------------------------------------------------
		-- Other
		_confidence_value_threshold_ <= atan((sum(proxy.total_calls_engaged) - _confidence_calls_middle_) / _confidence_scale_) / _pi_ * 100.0 + 50.0 as confidence,
		atan((sum(proxy.total_calls_engaged) - _confidence_calls_middle_) / _confidence_scale_) / _pi_ * 100.0 + 50.0 as confidence_value,
		count(proxy.*) as check_proxy,
		count(reference.*) as check_reference
		-- --------------------------------------------------------------------------------
	from proxy as proxy
	left join reference as reference on 1=1
		and coalesce(reference.month, '') = coalesce(proxy.month, '')
		and coalesce(reference.week, '') = coalesce(proxy.week, '')
		and coalesce(reference.date, '') = coalesce(proxy.date, '')
		and coalesce(reference.custom_interval, '') = coalesce(proxy.custom_interval, '')
		and case when _reference_brand_ then proxy.sponsor_id = reference.sponsor_id and proxy.brand_id = reference.brand_id else true end 
		and case when _reference_campaign_ then proxy.campaign_name = reference.campaign_name else true end
	where 1=1
--		and reference.partner_id is null and reference.team_id is null and reference.user_id is null -- Shall be implicit from definition of "reference" in query
		and proxy.total_Calling_hours >= _hours_threshold_
		and proxy.total_calls_argumented >= _calls_threshold_
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
	order by 9, 10, 11, 12, 13, 14, 15, 19
	;
end;
$$ language plpgsql;





