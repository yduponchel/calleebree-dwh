-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Utilities
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------



-- --------------------------------------------------------------------------------
-- Campaign Mapping
-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_campaign_mapping cascade;
create or replace function dashboards.utils_campaign_mapping(_campaign_id_ text, _campaign_name_ text) returns varchar(256) as $$
	select 
		case 
			when _campaign_name_ ilike '%Contest%' then 'Contest'
			when _campaign_name_ ilike '%test%' then '!!! TEST'
--			when _campaign_name_ ilike '%test%' then '!!! TEST: ' || _campaign_name_
			when _campaign_name_ ilike '%MNP%' then 'MNP'
			when _campaign_name_ ilike '%Churn%' then 'Churn'
			when _campaign_name_ ilike '%Fiber%' then 'Fiber'
			when _campaign_name_ ilike '%Cable%' then 'Fiber'
			when _campaign_name_ ilike '%Gigabox%' then 'Fiber'
			when _campaign_name_ ilike '%MBB%' then 'MBB'
			when _campaign_name_ ilike '%Chat%' then 'Chat'
			when _campaign_name_ ilike '%Aband%' then 'Abandoned Baskets'
			when _campaign_name_ ilike '%Basket%' then 'Abandoned Baskets'
			when _campaign_name_ ilike '%Verpasse Anrufe%' then 'Abandoned Calls' 
			when _campaign_name_ ilike '%SITU%' then 'SITU'
			when _campaign_name_ ilike '%Content Tu_%' then 'Content'
			when _campaign_name_ ilike '%Sunrise Prepaid%' then 'Sunrise Prepaid'
			when _campaign_name_ ilike '%Pre_%' then 'Prepaid'
			-- 
--			when _campaign_name_ ilike '%Campaign1%' then 'Other'
			else 'Other: ' || _campaign_name_ end
$$ language sql;



-- --------------------------------------------------------------------------------
-- Cost & Call Durations/Types
-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_call_type_id cascade;
create or replace function dashboards.utils_call_type_id(_duration_ numeric) returns int as $$
	select 
		case 
			when _duration_ <= 15 +   0 then 0
			when _duration_ <= 15 +  20 then 1
			when _duration_ <= 15 + 300 then 2
			else 3 end
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_call_type_by_id cascade;
create or replace function dashboards.utils_call_type_by_id(_id_ numeric) returns varchar(128) as $$
	select 
		case 
			when _id_ = 0 then '0. Contact Attempt (not connected)'
			when _id_ = 1 then '1. Contact Handled (<20 seconds)'
			when _id_ = 2 then '2. Contact Argumented (>20 seconds)'
			when _id_ = 3 then '3. Contact Engaged (>5 minutes)' 
			else '9. Error' end
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_call_type cascade;
create or replace function dashboards.utils_call_type(_duration_ numeric) returns varchar(128) as $$
	select dashboards.utils_call_type_by_id(dashboards.utils_call_type_id(_duration_))
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_duration_minutes cascade;
create or replace function dashboards.utils_duration_minutes(_duration_ numeric) returns int as $$
	select case 
		when _duration_ <= 0 then 0
		else (1 + floor((_duration_ - 1.0) / 60.0)) end
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_cost_per_minute cascade;
create or replace function dashboards.utils_cost_per_minute(_duration_ numeric, _cost_ numeric) returns numeric as $$
	select case 
		when _duration_ <= 0 then _cost_
		else round(_cost_ / dashboards.utils_duration_minutes(_duration_), 2) end
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_cost_category cascade;
create or replace function dashboards.utils_cost_category(_duration_ numeric, _cost_ numeric) returns varchar(128) as $$
	select 
		case 
			when dashboards.utils_cost_per_minute(_duration_, _cost_) <= 0.15 then '0. Low [0.00..0.15]'
			when dashboards.utils_cost_per_minute(_duration_, _cost_) <= 0.20 then '1. Medium [0.15..0.20]'
			when dashboards.utils_cost_per_minute(_duration_, _cost_) <= 0.30 then '2. High [0.20..0.30]'
			else '3. Very High [0.30...]' end
$$ language sql;



-- --------------------------------------------------------------------------------
-- Agents
-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_user_role cascade;
create or replace function dashboards.utils_user_role(_role_ int) returns varchar(128) as $$
	select 
		case 
			when _role_ = 0 then '0. Admin'
			when _role_ = 1 then '1. Organization'
			when _role_ = 2 then '2. Brand'
			when _role_ = 3 then '3. Site/Partner'
			when _role_ = 4 then '4. Team'
			when _role_ = 5 then '5. Agent'
			else '9. Unknown' end
$$ language sql;



-- --------------------------------------------------------------------------------
-- Dates & Times
-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_hour cascade;
create or replace function dashboards.utils_format_hour(_date_ timestamp) returns char(2) as $$
	select to_char(_date_, 'HH24');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_day_of_week cascade;
create or replace function dashboards.utils_format_day_of_week(_date_ timestamp) returns char(12) as $$
	select to_char(_date_, 'ID. Day');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_date cascade;
create or replace function dashboards.utils_format_date(_date_ timestamp) returns char(10) as $$
	select to_char(_date_, 'YYYY-MM-DD');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_week cascade;
create or replace function dashboards.utils_format_week(_date_ timestamp) returns char(7) as $$
	select to_char(_date_, 'IYYY-IW');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_month cascade;
create or replace function dashboards.utils_format_month(_date_ timestamp) returns char(7) as $$
	select to_char(_date_, 'YYYY-MM');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_year cascade;
create or replace function dashboards.utils_format_year(_date_ timestamp) returns char(4) as $$
	select to_char(_date_, 'YYYY');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_year_ISO cascade;
create or replace function dashboards.utils_format_year_ISO(_date_ timestamp) returns char(4) as $$
	select to_char(_date_, 'IYYY');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_cutoff_date cascade;
create or replace function dashboards.utils_cutoff_date(_field_ text, _limited_ boolean) returns timestamp as $$ -- if "interval" is set, then it assumes strict aggregation on this interval and will ignore incompatible "fields"
	select case 
		when not _limited_ then null
		when _field_ in ('year', 'month') then date_trunc('month', current_date - interval '13 months')
		when _field_ = 'week' then date_trunc('week', current_date - interval '14 weeks')
		when _field_ in ('day', 'day_of_week') then date_trunc('day', current_date - interval '33 days')
		when _field_ = 'hour' then date_trunc('day', current_date - interval '9 days')
		when _field_ = 'last 3 months' then date_trunc('day', current_date - interval '91 days')
		when _field_ = 'last 6 weeks' then date_trunc('day', current_date - interval '42 days')
		when _field_ = 'last 3 weeks' then date_trunc('day', current_date - interval '21 days')
		else null end;
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_timestamp_with_cutoff cascade;
create or replace function dashboards.utils_format_timestamp_with_cutoff(_date_ timestamp, _field_ text, _interval_ text, _cutoff_ timestamp) returns varchar(64) as $$ -- if "interval" is set, then it assumes strict aggregation on this interval and will ignore incompatible "fields"
	select case 
		when _cutoff_ is not null and _date_ < _cutoff_ then null
		when _interval_ is not null and _field_ <> 'custom' and _interval_ <> _field_ then null
		when _field_ = 'year' and _interval_ = 'week' then dashboards.utils_format_year_ISO(_date_)
		when _field_ = 'year' then dashboards.utils_format_year(_date_)
		when _field_ = 'month' then dashboards.utils_format_month(_date_)
		when _field_ = 'week' then dashboards.utils_format_week(_date_)
		when _field_ = 'day' then dashboards.utils_format_date(_date_)
		when _field_ = 'day_of_week' then dashboards.utils_format_day_of_week(_date_)
		when _field_ = 'hour' then dashboards.utils_format_hour(_date_)
		else _interval_ end;
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_timestamp cascade;
create or replace function dashboards.utils_format_timestamp(_date_ timestamp, _field_ text, _interval_ text, _limited_ boolean) returns varchar(64) as $$ -- if "interval" is set, then it assumes strict aggregation on this interval and will ignore incompatible "fields"
	select dashboards.utils_format_timestamp_with_cutoff(_date_, _field_, _interval_, dashboards.utils_cutoff_date(_field_, _limited_));
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_time_difference cascade;
create or replace function dashboards.utils_time_difference(_date1_ timestamp, _date2_ timestamp) returns int as $$ -- Returns the time difference in seconds
	select extract(epoch from (_date2_ - _date1_));
$$ language sql;



-- --------------------------------------------------------------------------------
-- Miscellaneous Utilities
-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_ratio cascade;
create or replace function dashboards.utils_ratio(_numerator_ numeric, _denominator_ numeric, _precision_ int) returns numeric as $$ -- Returns the time difference in seconds
	select case
		when _denominator_ is null then null
		else round(_numerator_ / _denominator_, _precision_) end;
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_percent cascade;
create or replace function dashboards.utils_percent(_numerator_ numeric, _denominator_ numeric, _precision_ int) returns numeric as $$ -- Returns the time difference in seconds
	select dashboards.utils_ratio(100.0 * _numerator_, _denominator_, _precision_);
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_generate_uuid cascade;
create or replace function dashboards.utils_generate_uuid(_text_ text) returns varchar(36) as $$
declare
	_md5_ char(32) := md5(_text_);
begin
	return substring(_md5_, 1, 8) || '-' || substring(_md5_, 5, 4) || '-' || substring(_md5_, 9, 4) || '-' || substring(_md5_, 13, 4) || '-' || substring(_md5_, 17);
end;
$$ language plpgsql;



-- --------------------------------------------------------------------------------
-- Data normalization
-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_household_key cascade;
create or replace function dashboards.utils_household_key(zip text, street text, street_number text, last_name text) returns varchar(1024) as $$
	select
	case 
		when coalesce(zip, '') = '' or coalesce(street, '') = '' or coalesce(last_name, '') = '' then null
		else
			concat(
				lower(trim(zip)),
				'|',
				lower(trim(street)),
				'|',
				lower(trim(coalesce(street_number, '-'))),
				'|',
				substring(trim(lower(last_name)), 1, 4),
				regexp_replace(trim(lower(last_name)), ' .*', '') -- 1st for letters, and what is after until first space (to avoid multiple names)
-- MySQL:		trim(lower(substring(last_name, 1, 4))), lower(substring_index(substring(last_name, 5), ' ', 1)) -- 1st for letters, and what is after until first space (to avoid multiple names)
--				case when length(substring_index(last_name, ' ', 1)) <= 3 then lower(trim(last_name)) else lower(trim(substring_index(last_name, ' ', 1))) end
			) 
		end;
$$ language sql;

-- --------------------------------------------------------------------------------




-- --------------------------------------------------------------------------------
-- ...
-- --------------------------------------------------------------------------------




