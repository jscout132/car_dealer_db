create table salesperson (
	sale_id SERIAL primary key,
	fname VARCHAR(150),
	lname VARCHAR(150)
);

create table car_info(
	serial_number SERIAL primary key,
	car_make VARCHAR(150),
	car_model VARCHAR(150),
	cost_ NUMERIC(6,2),
	mileage INTEGER,
	year_ INTEGER
);

create table customer(
	customer_id SERIAL primary key,
	fname VARCHAR(150),
	lname VARCHAR(150),
	phone INTEGER,
	email VARCHAR(200),
	address VARCHAR(300),
	billing INTEGER
);

create table add_on(
	add_id SERIAL primary key,
	add_on_name VARCHAR(100),
	add_on_desc VARCHAR (1000),
	add_price NUMERIC(3,2)
);

create table mechanic(
	mech_id SERIAL primary key,
	fname VARCHAR(150),
	lname VARCHAR(150)
);

create table part_inventory(
	part_id SERIAL primary key,
	part_name VARCHAR(150),
	inventory INTEGER
);

create table sale(
	car_sale_id SERIAL primary key,
	customer_id INTEGER,
	sale_id INTEGER,
	add_id INTEGER, 
	serial_number INTEGER, 
	sale_date DATE,
	amount NUMERIC(6,3),
	foreign key(customer_id) references customer(customer_id),
	foreign key(sale_id) references salesperson(sale_id),
	foreign key(add_id) references add_on(add_id),
	foreign key (serial_number) references car_info(serial_number)
);

create table service_ticket(
	service_id SERIAL primary key,
	customer_id INTEGER,
	mech_id INTEGER,
	serial_number INTEGER, 
	part_id INTEGER,
	date_ DATE,
	service_needed VARCHAR(500),
	quote_ NUMERIC(5,2),
	total NUMERIC(5,2),
	foreign key (customer_id) references customer(customer_id),
	foreign key(mech_id) references mechanic(mech_id),
	foreign key (serial_number) references car_info(serial_number),
	foreign key (part_id) references part_inventory(part_id)
);
--altering tables as needed 
alter table part_inventory
add part_brand VARCHAR(150);

alter table part_inventory
add part_price NUMERIC(4,2);

alter table car_info 
add car_color VARCHAR(50);

alter table part_inventory
alter column part_price type NUMERIC(5,2);

alter table add_on 
alter column add_price type NUMERIC(5,2);

alter table car_info  
alter column cost_ type NUMERIC(7,2);

alter table customer 
alter column phone type VARCHAR(15);

alter table sale 
add column total_amount NUMERIC(8,2);

alter table customer 
add column password_ VARCHAR(20);

alter table customer
add column auth_verify BOOLEAN;

alter table customer 
alter column customer_id type VARCHAR(36);

--inserting values into mechanic table manually
insert into mechanic (mech_id, fname, lname)
values (2, 'Diane', 'Fox');

--inserting values into part_inventory table manually
insert into part_inventory (part_id, part_name, inventory, part_brand, part_price)
VALUES(2, 'Air Filter', 70, 'Cabin Air Filter', 64.99);

--inserting values into customer table
insert into customer (customer_id, fname, lname, phone, email, address, billing)
VALUES(2,'Sarah','Owens','4444444444','sarah@mail.com','1555 South Drive Road', 1234);

--inserting values into sale table
INSERT into sale (car_sale_id, customer_id, sale_id, serial_number, sale_date)
VALUES(2, 1, 1, 10001, CURRENT_TIMESTAMP)

--inserting values into service_ticket 
insert into service_ticket (service_id, customer_id, mech_id, serial_number, part_id, date_, service_needed, quote_, total)
VALUES(2, 2, 2, 10002, 1, CURRENT_TIMESTAMP, 'New tires', 783.6, 933.6)


update car_info set car_color = 'White' where serial_number = 10003;

update sale 
set total_amount = 19195.27
where car_sale_id =2;


-- join for add on price and car cost 
select add_price, sale.car_sale_id, car_info.serial_number, car_info.cost_, sum(add_on.add_price, car_info.cost_)
from add_on 
full join sale  
on add_on.add_id = sale.add_id 
full join car_info 
on sale.serial_number = car_info.serial_number 

--join to find the total cost for car sale- add_price + cost_
select add_on.add_price + car_info.cost_ as sum_result
from add_on 
full join sale  
on add_on.add_id = sale.add_id 
full join car_info 
on sale.serial_number = car_info.serial_number 


--function to add content to add_ons table
create or replace function add_addons(
	add_id_ INTEGER, add_name VARCHAR(100), add_desc VARCHAR(1000), add_price_ NUMERIC(5,2))
returns void
as $MAIN$
begin 
	insert into add_on(add_id, add_on_name, add_on_desc, add_price)
	values (add_id_, add_name, add_desc, add_price_);
end;
$MAIN$
language plpgsql;

select add_addons(3, 'Tire Protection Package', 'This package includes tire rotations and alignments for the first 24 months after purchase', 175.00);


--function to add content to salesperson table
create or replace function add_sales_person(sale_id_ INTEGER, f_name VARCHAR(150), l_name VARCHAR(150) 
	)
returns VOID
as $MAIN$
begin 
	insert into salesperson (sale_id, fname, lname)
	values (sale_id_, f_name, l_name);
end;
$MAIN$
language plpgsql;

select add_sales_person(2, 'Brady', 'Long');


--function to add content to car_info table
create or replace function add_car(serial INTEGER, make VARCHAR(150), model VARCHAR(150), _cost_ numeric(6,2), miles INTEGER, _year_ INTEGER, car_color_ VARCHAR(50))
returns VOID
as $MAIN$
begin 
	insert into car_info (serial_number, car_make, car_model, cost_, mileage, year_, car_color)
	VALUES(serial, make, model, _cost_, miles, _year_, car_color_);
end;
$MAIN$
language plpgsql;

select add_car(10003, 'Ford', 'F1-50', 49338.27, 4862, 2019, 'White');

select * from car_info; 