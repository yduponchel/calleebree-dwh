

-- --------------------------------------------------------------------------------
-- Agents buring leads
--
-- -- Agents with medium to low conversion rate on argumented contacts
-- -- Agents with proportionaly high rate of short call or simply argumented calls (excluding failed calls) vs. long calls
-- -- Campaigns with low lead volume and high quality leads

 


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









