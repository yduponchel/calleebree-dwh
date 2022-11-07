-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Logging
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------


-- Sample usage: 
-- 
-- -- token char(64) := dashboards.utils_log_token('Whatever');
-- -- call dashboards.utils_logs_init(token, 'my_procedure()');
-- -- call dashboards.utils_logs_event(token, 'my_task#1', 'my task is now completed');
-- -- call dashboards.utils_logs_event(token, 'my_task#2', 'my other task is now completed');
-- -- call dashboards.utils_logs_event(token, null, 'Overall completed');
-- 
--  or (not thread safe)
-- 
-- -- call dashboards.utils_logs_init(null, 'my_procedure()');
-- -- call dashboards.utils_logs_event('my_procedure()', 'my_task#1', 'my task is now completed');
-- -- call dashboards.utils_logs_event('my_procedure()', 'my_task#2', 'my other task is now completed');
-- -- call dashboards.utils_logs_event('my_procedure()', null, 'Overall completed');


-- --------------------------------------------------------------------------------

--drop function if exists dashboards.utils_log_token cascade;
create or replace function dashboards.utils_logs_token(_procedure_ text) returns char(64) as $$
  select concat(md5(coalesce(_procedure_, '<DEFAULT>')), md5(current_timestamp::text));
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop table if exists dashboards.utils_logs;
create table if not exists dashboards.utils_logs ( 
  token char(64),
  -- 
  date_native timestamp,
  date_iso char(10),
  month_iso char(10),
  -- 
  procedure_name varchar(255),
  subtask_name varchar(255),
  -- 
  procedure_start_time timestamp,
  procedure_end_time timestamp,
  procedure_elapsed_time int,
  -- 
  subtask_start_time timestamp,
  subtask_end_time timestamp,
  subtask_elapsed_time int,
  -- 
  message varchar(1024)
);
-- --------------------------------------------------------------------------------
-- Indexes
create index on dashboards.utils_logs (token);
create index on dashboards.utils_logs (date_native);
create index on dashboards.utils_logs (date_iso);
create index on dashboards.utils_logs (month_iso); 
create index on dashboards.utils_logs (procedure_name);

-- --------------------------------------------------------------------------------

--drop procedure if exists dashboards.utils_logs_init;
create or replace procedure dashboards.utils_logs_init(_token_ text, _procedure_ text) as $$
declare
	__token__ char(64) := coalesce(_token_, (select dashboards.utils_logs_token(_procedure_)));
	__procedure__ varchar(255) := coalesce(
			(select procedure_name from dashboards.utils_logs where token = __token__ and procedure_name is not null limit 1), 
			_procedure_,
			'<UNDEFINED>'
		);

begin
  insert into dashboards.utils_logs values ( 
    __token__, 										-- as token,
    current_timestamp, 								-- as date_native,
    dashboards.utils_format_date(current_date), 	-- as date_iso,
    dashboards.utils_format_month(current_date), 	-- as month_iso,
    __procedure__, 									-- as procedure_name,
    null, 											-- as subtask_name,
    current_timestamp, 								-- as procedure_start_time,
    null, 											-- as procedure_end_time,
    null, 											-- as procedure_elapsed_time,
    null, 											-- as subtask_start_time,
    null, 											-- as subtask_end_time,
    null, 											-- as subtask_elapsed_time,
    '<INIT>' 										-- as message
  );
  
end;
$$ language plpgsql;

-- --------------------------------------------------------------------------------

--drop procedure if exists dashboards.utils_logs_event;
create or replace procedure dashboards.utils_logs_event(_token_ text, _subtask_ text, _message_ text) as $$
declare 
	__token__ char(64) := coalesce(
			(select token from dashboards.utils_logs where token = _token_ order by date_native desc limit 1),
			(select token from dashboards.utils_logs where procedure_name = _token_ order by date_native desc limit 1),
			_token_
		);
	__procedure__ varchar(255) := coalesce(
			(select procedure_name from dashboards.utils_logs where token = __token__ and procedure_name is not null limit 1), 
			'<UNDEFINED>',
			_token_
		);
	_start_ timestamp := coalesce((select min(procedure_start_time) from dashboards.utils_logs where token = __token__), current_timestamp);
	_end_ timestamp := current_timestamp;
	_total_ int := dashboards.utils_time_difference(_start_, _end_);
	_last_ timestamp := coalesce((select max(procedure_end_time) from dashboards.utils_logs where token = __token__), _start_);
	_elapsed_ int := dashboards.utils_time_difference(_last_, _end_);

begin
	insert into dashboards.utils_logs values ( 
		__token__, -- as token,
		current_timestamp, -- as date_native,
		dashboards.utils_format_date(current_date), -- as date_iso,
		dashboards.utils_format_month(current_date), -- as month_iso,
		__procedure__, -- as procedure_name,
		coalesce(_subtask_, ''), -- as subtask_name,
		_start_, -- as procedure_start_time,
		_end_, -- as procedure_end_time,
		_total_, -- as procedure_elapsed_time,
		_last_, -- as subtask_start_time,
		_end_, -- as subtask_end_time,
		_elapsed_, -- as subtask_elapsed_time,
		coalesce(_message_, '') -- as message
	);
  
	raise notice '[%|%][%] +% sec (% min) | =% sec (+% min)', 
		__procedure__, case when _subtask_ is null then '-' else _subtask_ end, 
		(select count(*) from dashboards.utils_logs where token = __token__ and _end_ is not null),
		_elapsed_, round(_elapsed_ / 60.0, 1),
		_total_, round(_total_ / 60.0, 1)
	;

end;
$$ language plpgsql;

