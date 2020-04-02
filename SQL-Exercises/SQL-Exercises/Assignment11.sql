Q-
student (studentid, rollno, fname, sname, surname, admitdate, birthdate, standard, gender)

select concat(UPPER(LEFT(fname,1))," ",UPPER(LEFT(sname,1))," ",UPPER(LEFT(surname,1))) as FULLNAME 
from student where gender="male" and fname like "%h" and admitdate >= '2006-01-01' and admitdate<='2006-08-01';

Q-
1) product (productid, mfrid, description, price, qtyonhand)

2) orders (ordersid, customerid, orderdate, salesrepsid, productid, qty, amount)

3) customer (customerid, company, salesrepsid, creditlimit)

4) salesreps (salesrepsid, name, officeid, designation, hiredate, manager, quota, sales, age)

5) office (officeid, city, region, manager, targetsales, actualsales)

Q-
select s.name,o.city,s.hiredate,count(c.customerid) from 
salesreps as s left join office as o on s.officeid=o.officeid
left join customer as c on c.salesrepsid=s.salesrepsid
where s.hiredate<'2006-01-01' and s.age>21 and count(c.customerid)>=2
and o.city like '%pur';

Q-
select customer.company as CompanyName,salesreps.name as SalesRepName,office.city as OfficeCity,
customer.creditlimit as CompanyCredit from customer
inner join salesreps on customer.salesrepid=salesreps.salesrepid 
inner join office on salesreps.officeid=office.officeid;

Q-
select  c.company, s.salesreps,o.city,c.creditlimit from
customer as c left join salesreps as s 
on c.salesrepsid = s.salesrepsid
leftjoin office as o
on o.officeid=s.officeid

Q-
select o.officeid, sum(s.salesrepsid),sum(s.sales),o.targetsales,o.actualsales, (o.targetsales - o.actualsales) as different from
office as o left join salesreps as s 
on o.officeid = s.office id
grop by(s.officeid)

Q-
select p.description,p.price,p.qtyonhand,sum(o.amount),sum(o.qty),count(o.orderid) from
product as p left join office as o 
on p.productid = o.productid
grop by(o.productid)

Q-
select c.company , sum(o.qty),sum(o.amount) from
customer as c left join office as o
on c.customerid=o.customerid
gropby(o.customerid)

Q-
select s.name,s.hiredate,s.quota,s.sales
from salesreps as s
where hiredate between 
'2015-01-01' and '2020-01-01'

Q-
select p.description, sum(o.customerid) from
product as p left join order as o
on p.productid=o.productid
left join customer as c
on o.customerid=c.customerid
groupby(o.productid)



