Select category_name,description from categories
order by category_name;

Select contact_name,address,city from customers 
where country not in('Germany', 'Mexico','Spain');

Select order_date,shipped_date,customer_id,freight from orders
where order_date='2018-02-26';

select * from orders;

select employee_id,order_id,customer_id,required_date,shipped_date from orders
where required_date<shipped_date;

select order_id from orders where order_id%2=0;

select city,company_name,contact_name from customers 
where city like "%L%"
order by contact_name ;

select company_name,contact_name,fax from customers 
where fax is not null;

select first_name,last_name,MAx(hire_date) hire_date from employees; 

Select Round(AVG(unit_price),2) As unit_price, SUM(units_in_stock) units_in_stock,
SUM(discontinued) As discontinued from products;

select p.product_name AS product_name ,s.company_name AS company_name,c.category_name AS category_name
from categories c 
inner join products p on 
     c.category_id=p.category_id
inner join suppliers s on 
     s.supplier_id=p.supplier_id;
     
select distinct(c.category_name) As category_name,Round(AVG(p.unit_price),2) AS  average_unit_price
from categories c 
inner join products p On
      c.category_id=p.category_id
group by category_name;

Select city,company_name,contact_name,'customers' AS Relationship from customers
union
Select city,company_name,contact_name,'suppliers' from suppliers;

Select Year(order_date) AS order_year ,Month(order_date) order_month,Count(*) As number_of_orders
from orders
group by order_month,order_year
order by order_year;

Select Year(o.order_date) As order_year, ROund(SUm(od.discount*p.unit_price*od.quantity),2) AS discount_amount from orders o 
Join order_details od ON 
   o.order_id=od.order_id
Join products p On
   od.product_id=p.product_id  
Group by order_year
Order by order_year desc;



