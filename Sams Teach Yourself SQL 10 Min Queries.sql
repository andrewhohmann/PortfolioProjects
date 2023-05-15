--- Sams Teach Yourself SQL in 10 Minutes Book

--- Retrieving Indiv Columns

Select prod_name
From Book.dbo.Products

Select *
From Book.dbo.Products


--- Sorting columns

Select prod_name, prod_price, prod_id
From Book.dbo.Products
order by prod_price, prod_name

Select prod_name, prod_price, prod_id
From Book.dbo.Products
order by 1, 2

Select prod_name, prod_price, prod_id
From Book.dbo.Products
order by prod_price desc, prod_name


--- Filtering data


Select prod_name, prod_price, prod_id
From Book.dbo.Products
where prod_price > 8

Select prod_name, prod_price, prod_id     --- 
From Book.dbo.Products
Where vend_id <> 'DLL01'

Select prod_name, prod_price, prod_id
From Book.dbo.Products
where prod_price between 5 and 10


Select cust_contact, cust_name
From Book.dbo.Customers
where cust_email is not null 


---- Advance Filtering 

Select prod_name, prod_price, prod_id
From Book.dbo.Products
where vend_id = 'DLL01' and prod_price <= 4

Select prod_name, prod_price, prod_id
From Book.dbo.Products
where vend_id = 'DLL01' or vend_id = 'BRS01' and prod_price >= 10


Select prod_name, prod_price, prod_id
From Book.dbo.Products
where vend_id in ('DLL01', 'BRS01')
order by prod_name


---- Using Wildcards 

Select prod_name, prod_price, prod_id
From Book.dbo.Products
where prod_name like 'Fish%'

Select prod_name, prod_price, prod_id
From Book.dbo.Products
where prod_name like '%bean bag%'

Select cust_country, cust_name, cust_contact, cust_email
From Book.dbo.Customers
where cust_email like '%@%'

Select cust_contact, cust_email
From Book.dbo.Customers
where cust_contact like '[JM]%'
order by cust_contact


--- Calculated fields 

Select RTRIM(vend_name) + '(' + RTRIM(vend_country) + ')' As vend_title
from Book.dbo.Vendors

Select prod_id, quantity, item_price, quantity*item_price as total_purchase_price
from Book.dbo.OrderItems
order by total_purchase_price

Select order_num
from Book.dbo.Orders
where YEAR(order_date) = 2012

Select AVG(prod_price) as avg_price
From Book.dbo.Products

Select AVG(prod_price) as avg_price
From Book.dbo.Products 
where vend_id = 'DLL01'

select COUNT(*) as num_cust
from Book.dbo.Customers

select Max(prod_price) As max_price
from Book.dbo.Products

select sum(order_item) As total_items
from Book.dbo.OrderItems

select AVG( Distinct prod_price) As avg_price
from Book.dbo.Products
where vend_id = 'DLL01'

select count(*) As num_items,
       MIN(prod_price) as price_min,
	   MAX(prod_price) as price_max,
	   Avg(prod_price) as avg_price
from Book.dbo.Products

----- Data Grouping

select vend_id, COUNT(*) as num_prod
from Book.dbo.Products
group by vend_id

select vend_id, COUNT(*) as num_prod
from Book.dbo.Products
where prod_price >= 4
group by vend_id
having COUNT(*) >= 2

select order_num, COUNT(*) as items
from Book.dbo.OrderItems
group by order_num
having COUNT(*) >= 3
order by items, order_num


---- Working With Subqueries

 Select order_num
 From Book.dbo.OrderItems
 where prod_id = 'RGAN01'

 Select cust_id	
 From Book.dbo.Orders
 where order_num IN ('20007','20008')

 Select cust_id	
 From Book.dbo.Orders
 where order_num IN ( Select order_num
 From Book.dbo.OrderItems
 where prod_id = 'RGAN01')

select cust_contact, cust_name                                    
from Book.dbo.Customers
where cust_id In (Select cust_id
                  From Book.dbo.Orders
				  where order_date in (Select order_date
				                       From Book.dbo.OrderItems
									   where prod_id = 'RGAN01'))


									   Select cust_id, cust_name, cust_contact
 from Book.dbo.Customers
 where cust_name = (Select cust_name
                   from Book.dbo.Customers
                   where cust_contact =  'Jim Jones')

Select 
cust_name,
cust_contact,
(select Count(*)
from Book.dbo.Orders as orders
where orders.cust_id = customers.cust_id) as num_of_orders
from Book.dbo.Customers as customers
order by cust_name


--- Joining Tables


Select vend_name, prod_name, prod_price
from Book.dbo.Vendors as Vendors, Book.dbo.Products as Products
where Vendors.vend_id = Products.vend_id

Select vend_name, prod_name, prod_price
from Book.dbo.Vendors as Vendors inner join Book.dbo.Products as Products 
 on Vendors.vend_id = Products.vend_id



 Select prod_name, vend_name, prod_price, quantity
 from Book.dbo.Vendors as Vendors, Book.dbo.Products as Products, Book.dbo.OrderItems as OrderItems 
 where Vendors.vend_id = Products.vend_id 
  and OrderItems.prod_id = Products.prod_id 
  and order_num = 20007


  --- Joining three tables to find customer names and contacts for product id 
  Select cust_name, cust_contact
  from Book.dbo.Customers as Customers, Book.dbo.Orders as Orders, Book.dbo.OrderItems as OrderItems
  Where Customers.cust_id = Orders.cust_id 
   and OrderItems.order_num = Orders.order_num
   and prod_id = 'RGAN01'

--- Subquies 
 Select cust_id, cust_name, cust_contact
 from Book.dbo.Customers
 where cust_name = (Select cust_name
                   from Book.dbo.Customers
                   where cust_contact =  'Jim Jones')

--- Using Alises and joining the same table for customer contacts, company and id who work at the same company as jim jones
Select c1.cust_name, c1.cust_contact, c1.cust_id
  from Book.dbo.Customers as c1, Book.dbo.Customers as c2
  Where c1.cust_name = c2.cust_name 
  and c2.cust_contact = 'Jim Jones'
   
   --- join Cust id and order numbers
   Select Customers.cust_id, Orders.order_num
   from Book.dbo.Customers as Customers join Book.dbo.Orders as Orders
   on Customers.cust_id = Orders.cust_id
   order by cust_id

   --- Left join Cust id and order numbers
   Select Customers.cust_id, Orders.order_num
   from Book.dbo.Customers as Customers left join Book.dbo.Orders as Orders
   on Customers.cust_id = Orders.cust_id
   order by cust_id

   --- right join Cust id and order numbers
   Select Customers.cust_id, Orders.order_num
   from Book.dbo.Customers as Customers right join Book.dbo.Orders as Orders
   on Customers.cust_id = Orders.cust_id
   order by cust_id


---- Using Joins with aggregate functions

--- counting order numbers and joining two tables 
Select Customers.cust_id, COUNT(Orders.order_num) as num_ord
 from Book.dbo.Customers as Customers join Book.dbo.Orders as Orders
 on Customers.cust_id = Orders.cust_id 
 group by Customers.cust_id



 ---Combining queries using Union 

 Select cust_name, cust_contact, cust_email
 from Book.dbo.Customers as Customers
 Where cust_state in ('IL', 'IN', 'MI') 
 Union 
 Select cust_name, cust_contact, cust_email
 from Book.dbo.Customers as Customers
 where cust_name = 'Fun4All'
 

 Select cust_name, cust_contact, cust_email
 from Book.dbo.Customers as Customers
 Where cust_state in ('IL', 'IN', 'MI') or cust_name = 'Fun4All'

 Select cust_name, cust_contact, cust_email
 from Book.dbo.Customers as Customers
 Where cust_state in ('IL', 'IN', 'MI') 
 Union all
 Select cust_name, cust_contact, cust_email
 from Book.dbo.Customers as Customers
 where cust_name = 'Fun4All'


 ----- Inserting Rows

insert into Book.dbo.Customers
Values ('1000000006',
        'Toy Land',
		'123 Any Street',
		'New York',
		'NY',
		'12345',
		'USA',
		'Bob James',
		'Bob.James@gmail.com')

--- inserting Retrieved data
---importing all data from CustNew
Insert Into  Book.dbo.Customers ( cust_id,
                                  cust_contact,
								  cust_email,
								  cust_name,
								  cust_address,
								  cust_city,
								  cust_state,
								  cust_zip,
								  cust_country)
Select cust_id,
       cust_contact,
	   cust_email,
	   cust_name,
	   cust_address,
	   cust_city,
	   cust_state,
	   cust_zip,
	   cust_country
from CustNew 

--- Copying from One Table to ANother

Select * 
Into CustCopy 
From Book.dbo.Customers

Create Table CustCopy As
Select * From Book.dbo.Customers


---- Updating and Deleting Data

Update Book.dbo.Customers
set cust_email = 'Kim@thetoystore.com'
where cust_id = '1000000005' 

Update Book.dbo.Customers
set cust_email = 'Bob.james@thetoystore.com',
    cust_contact = 'Bobby James'
where cust_id = '1000000006'

--- Deleting Data 

 Delete From Book.dbo.Customers
 where cust_id = '1000000006'

 ---Creating and Manipulationg tables
 
 Create Table Orders
 (
       order_num Integer 
	   orer_date DateTime 
	   Cust_id   Char 
  )


Alter Table Book.dbo.Vendors
Add Vend_Phone char 

Alter Table Book.dbo.Customers
Drop Column Vend_Phone 

Drop Table CustCopy

----Using Veiws 

Create View  ProductCustomers As
 Select cust_name, cust_contact
  from Book.dbo.Customers as Customers, Book.dbo.Orders as Orders, Book.dbo.OrderItems as OrderItems
  Where Customers.cust_id = Orders.cust_id 
   and OrderItems.order_num = Orders.order_num

 Select * 
 from ProductCustomers

 Create View VendorsLocation as
 Select RTRIM(vend_name) + '(' + RTRIM(vend_country) + ')' As vend_title
from Book.dbo.Vendors

Select * 
from VendorsLocation

----Managing Processing Transactions

Begin Transaction
Delete Book.dbo.OrderItems where order_item = 12345
Delete Book.dbo.Orders where order_date = 12345
Commit Transaction


Delete from Orders 
Rollback

Begin Transaction
Insert Into Book.dbo.Customers(cust_id, cust_name)
Values ('1000000010', 'Toy Emporium')
Save Transaction StartOrder
Insert Into Book.dbo.Orders(order_date, order_date, cust_id)
Values(20100, '2001/12/2', '1000000010') 
if @@ERROR <> 0 Rollback Transaction Startorder 
Insert Into Book.dbo.OrderItems( order_num, order_item, prod_id, quantity, item_price)
Values(20100, 1, 'BR01', 100, 5.50)
If @@ERROR<> 0 Rollback Transaction Startorder 
insert into Book.dbo.OrderItems( order_item, order_item, prod_id,quantity,item_price)
Values( 20100, 2, 'BR03' , 100, 10.99) 
if @@ERROR <> 0 Rollback Transaction Startorder 
commit Transaction 

---- Primary keys and checks

Create Table Orders
 (
       order_num Integer  Primary key 
	   orer_date DateTime 
	   Cust_id   Char      Check (cust_id)
  )


  ---Indexes 

  Create Index prod_name_ind
  on Book.dbo.Products