-- use the correct database
use sakila;

-- make sure the tables haven't been created already
drop table if exists inact_cust;
drop table if exists inact_cust1;
drop table if exists inact_cust2;

-- look at the databases for the correct join keys
select * from address limit 5; -- address_id is our numeric key
select * from customer limit 5; -- customer_id is key
select * from city limit 5; -- city_id is key
select * from country limit 5; -- country_id is key

-- add columns together from the tables
create table inact_cust as 
select customer.customer_id, customer.active, customer.first_name, customer.last_name, customer.address_id, 
address.address, address.city_id, city.city, city.country_id, country.country
from customer
inner join address on address.address_id = customer.address_id
inner join city on city.city_id = address.city_id
inner join country on country.country_id = city.country_id;

-- check work
select * from inact_cust;

-- drop unnecessary columns
alter table inact_cust
drop column customer_id,
drop column address_id,
drop column city_id,
drop column country_id;

select * from inact_cust;

-- do the concatonations
alter table inact_cust add column full_name varchar(50);
update inact_cust set full_name = concat(first_name, " ", last_name);

alter table inact_cust add column city_country varchar(50);
update inact_cust set city_country = concat (city, ", ", country);

-- get only inactive customers, sorting by last name
select full_name, address, city_country 
from inact_cust 
where inact_cust.active = 0 order by last_name;
-- only 15 inactive customers with their addresses
