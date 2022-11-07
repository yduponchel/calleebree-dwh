

-- --------------------------------------------------------------------------------
-- Changed language id to just the 2 letters
-- --------------------------------------------------------------------------------





-- --------------------------------------------------------------------------------
-- Files / Contacts / Calls
-- --------------------------------------------------------------------------------

select count(*) from calls;
select * from calls limit 1000;
select * from calls c1 left join feedback_reasons fr on c1.feedback_reason = fr.id limit 1000;
select phone_number_id, count(*) from calls group by 1 order by 2 desc;
select * from phone_number as pn limit 500;
select count(*) from phone_number as pn;

select count(*) from scheduled_calls;
select * from scheduled_calls sc limit 100;

select * from feedback_reasons as fr;
select * from feedback_reasons_text as frt; -- How does this link to any other table??? These seem to be the agent feedbacks typed by hand.

select * from orders;

-- --------------------------------------------------------------------------------

select * from files where name not ilike '%test%';
select * from contacts limit 100;
select enabled, count(*) from contacts group by enabled ;
select * from contacts where not enabled limit 100;

-- Duplicated contacts (same campaign, multiple campaigns)
select phone, count(*), count(distinct campaign_id) from contacts group by phone having count(*) > 1 order by count(*) desc;

select enabled, rejections, count(*), sum(case when contract_closed then 1 else 0 end) from contacts group by 1, 2 order by 1, 2;




-- --------------------------------------------------------------------------------
-- Accounts & Users
-- --------------------------------------------------------------------------------

select * from accounts order by email;
select * from users;
select * from view_users; -- users left join accounts

select u.id, a.name, a.email, count(l.language_id), min(l.language_id) as lang0, max(l.language_id) as lang1 
from users as u left join accounts as a on u.account_id = a.id left join users_languages as l on u.id = l.user_id 
group by 1, 2, 3 having count(l.language_id) >= 1 order by 4 desc, 3;

select * from languages;
select * from users_languages;
select * from status_reasons sr ; -- Available | On Call | Lunch | Break | WC => Available | Calling & In Call | Break | Short Break | Back-Office | Admin & Management



-- Agent status
select * from xxx as left join status_reasons sr on sr.guid = ;

select * from users;

-- --------------------------------------------------------------------------------
-- Campaigns
-- --------------------------------------------------------------------------------
select count(*) from campaigns;
select * from campaigns limit 100;

-- Related tables (no that relevant... Only resolving to 'OUTBOUND' category...)
select * from campaign_categories limit 100; -- See Trello: 1) why not a json in campaign? Is it user defined or platform defined? why are they currently all unique?
select * from categories limit 100; -- See Trello: 1) again, why another table? 2) why only 1 value, especially because we will only have outbound 3) if platform, then it should be PROSPECTS | LOYALTY | XSELL | UPSELL | XUPSELL | OTHER

select * from offers as o order by name;




-- --------------------------------------------------------------------------------
-- Sponsors / Brands / Partners / Teams
-- --------------------------------------------------------------------------------

-- Sponsor.id = 103 || Brand.id = 3 => Ganira || Yallo

select * from sponsors;
select * from brands;
select * from partners;
select * from team;
select * from users;

select count(*) from partners;

select * from currencies;
select * from languages;




-- --------------------------------------------------------------------------------
-- Campaign linking tables
-- --------------------------------------------------------------------------------

select * from teamcampaign_partners;
--select * from campaign_users;
select * from team_campaigns;
select * from team_users;

-- --------------------------------------------------------------------------------

select * from public.campaign_partners;
select 
	cp.campaign_id,
	c.name as campaign_name,
	b0.name as campaign_brand,
	cp.partner_id,
	p.name as partner_name,
--	b1.name as partner_brand,
	'|' as delim
from campaign_partners as cp 
left join campaigns as c on cp.campaign_id = c.id 
left join partners as p on cp.partner_id = p.id 
left join brands as b0 on c.brand_id = b0.id 
--left join brands as b1 on p.brand_id = b0.id 
where 1=1
--	and c.sponsor_id = 103 and c.brand_id = 3
	and c.sponsor_id = 103 
order by 2, 1, 5, 4
;


select *
from campaign_partners as cp  
left join team_campaigns as tc on tc.campaign_id = cp.campaign_id 
where 1=1
--	and c.sponsor_id = 103 
;

select 
	cp.campaign_id,
	c.name as campaign_name,
	p0.id partner_id,
	p0.name as partner_name,
	'|' as delim0,
	tc.team_id,
	t.name as team_name,
	p1.id as team_partner_id,
	p1.name as team_partner_name,
	'|' as delim
from campaign_partners as cp  
left join campaigns as c on c.id = cp.campaign_id 
left join partners as p0 on p0.id = cp.partner_id
-- 
left join team_campaigns as tc on tc.campaign_id = cp.campaign_id 
left join team as t on t.id = tc.team_id 
left join partners as p1 on p1.id = t.partner_id 
where 1=1
--	and c.sponsor_id = 103 and c.brand_id = 3
	and c.sponsor_id = 103 
	and p0.id <> p1.id
order by 2, 3
;

select id from campaigns as c where c.brand_id = {brand.id};


-- --------------------------------------------------------------------------------
-- Statistics
-- --------------------------------------------------------------------------------

select * from view_orders_per_campaign vopc ;
select * from view_contacts_enabled_per_campaign vcepc ;
select * from view_agents_per_partner vapp ;


-- --------------------------------------------------------------------------------
-- Calling statistics
select 
--	c1.phone_number_id, date_trunc('day', c1.date) as date,
	c1.phone_number_id, to_char(c1.date, 'YYYY-MM-DD') as date, 
	case when pn.disabled_date is not null then 1 else 0 end as disabled, pn.disabled_date,
	user_id, campaign_id, c3.name as campaign_name, c3.description as campaign_description,
	count(*) as calls,
	100.0 * sum(case when fr.rejected then 1 else 0 end) / count(*) as rejected_ratio,
	100.0 * sum(case when fr.text = 'Rejected'  then 1 else 0 end) / count(*) as rejected_rejected_ratio,
	100.0 * sum(case when fr.text = 'Failed'  then 1 else 0 end) / count(*) as rejected_failed_ratio,
	100.0 * sum(case when c1.duration < 10 then 1 else 0 end) / count(*) as voice_mail_ratio,
	100.0 * sum(case when c1.duration >= 10 and c1.duration <30 then 1 else 0 end) / count(*) as short_call_ratio,
	100.0 * sum(case when c1.duration >= 300 then 1 else 0 end) / count(*) as long_call_ratio,
	sum(case when fr.rejected then 1 else 0 end) as rejected,
	sum(case when fr.text = 'Rejected' then 1 else 0 end) as rejected_rejected,
	sum(case when fr.text = 'Failed' then 1 else 0 end) as rejected_failed,
	sum(case when c1.duration < 10 then 1 else 0 end) as voice_mail,
	sum(case when c1.duration >= 10 and c1.duration <30 then 1 else 0 end) as short_call,
	sum(case when c1.duration >= 300 then 1 else 0 end) as long_call,
--	sum(case when fr.text = 'Bad Number' then 1 else 0 end) as rejected_bad_number, -- Always 0???
--	sum(case when fr.text = 'Answering Machine' then 1 else 0 end) as rejected_voice_mail, -- Always 0???
--	sum(case when fr.disable then 1 else 0 end) as disabled,  -- Always 0???
	'|' as delim 
from calls as c1
left join feedback_reasons as fr on c1.feedback_reason = fr.id
left join phone_number as pn on pn.id = c1.phone_number_id 
left join campaigns c3 on c3.id = c1.campaign_id
where 1=1
	and campaign_id in (select id from campaigns as c2 where c2.sponsor_id = 103 and c2.brand_id = 3)
	and c1.phone_number_id is not null
	and c3.brand_id = 3 -- Ganira || Yallo	
group by 1, 2, 3, 4, 5, 6, 7, 8
order by 1, 2
;


-- --------------------------------------------------------------------------------
-- General statistics (contacts | campaigns | files | closed | conversion)
select 
	count(c1.*) as contacts,
	count(distinct c1.campaign_id) as campaigns,
	count(distinct c1.file_id) as files,
	sum(case when c1.contract_closed then 1 else 0 end) as closed, -- Closed means it won't be contacted again
	100.0 * sum(case when c1.contract_closed then 1 else 0 end) / count(*) as closed_rate -- Closed means it won't be contacted again
from contacts as c1 
left join campaigns as c2 on c1.campaign_id = c2.id 
where 1=1
	and c2.sponsor_id = 103 -- Ganira
	and c2.brand_id = 3 -- Ganira || Yallo
	and not c1.enabled 
order by 5 desc;


-- --------------------------------------------------------------------------------
-- Campaign statistics
select 
	c1.campaign_id, c2.description, c2.dateinserted,
	count(c1.*) as contacts,
	count(distinct c1.file_id) as files,
	sum(case when c1.contract_closed then 1 else 0 end) as closed, -- Closed means it won't be contacted again
	100.0 * sum(case when c1.contract_closed then 1 else 0 end) / count(*) as closed_rate -- Closed means it won't be contacted again
from contacts as c1 
left join campaigns as c2 on c1.campaign_id = c2.id 
where 1=1
	and c2.sponsor_id = 103 -- Ganira
	and c2.brand_id = 3 -- Ganira || Yallo
group by 1, 2, 3
order by 6 desc;


-- --------------------------------------------------------------------------------
-- File statistics

select 
	c1.file_id, f.name, f.date_inserted, c2.name as campaign, c2.description,
	count(distinct c1.id) as contacts,
	sum(case when c1.contract_closed then 1 else 0 end) as closed, -- Closed means it won't be contacted again
	100.0 * sum(case when c1.contract_closed then 1 else 0 end) / count(*) as closed_rate -- Closed means it won't be contacted again
from contacts as c1 
left join files as f on c1.file_id = f.id 
left join campaigns as c2 on c1.campaign_id = c2.id 
where 1=1
	and f.name not ilike '%test%'
	and f.sponsor_id = 103 -- Ganira
	and c2.brand_id = 3 -- Ganira || Yallo
group by 1, 2, 3, 4, 5
having sum(case when c1.contract_closed then 1 else 0 end) > 0
order by 6 desc;
