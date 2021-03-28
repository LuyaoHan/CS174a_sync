/*
Tables: products, customers, and orders, with the following schema:

Product(pid,pname,price), pid is the primary key
Orders(oid,pid,cid,qnt,date), oid is the primary key
Customer(cid,cname,city), cid is the primary key

Producs have an ID, a name, and a sell price
Customers have an ID, a name, and the city where they live.

*Each order is for one product and one customer.*  The attribute
qnt is the quantity, i.e. the number of units of the product
placed in that order; qnt>0.
*/


/*
Write the sequence of SQL statements necessary to create
the tables above.  The attributes pid, oid, cid, qnt are
integers, price is a real number, date is of type
DATE and all other attributes are text. Please include all keys or foreign keys declarations.
*/
CREATE TABLE Product(
    pid INT PRIMARY KEY,
    pname VARCHAR,
    price REAL
);

CREATE TABLE Customer(
    cid INT PRIMARY KEY,
    cname VARCHAR,
    city VARCHAR
);

CREATE TABLE Orders(
    oid INT PRIMARY KEY,
    pid INT, 
    cid INT,
    qnt INT,
    date DATE,
    FOREIGN KEY(pid) REFERENCES Product(pid),
    FOREIGN KEY(cid) REFERENCES Customer(cid)
);


/*
Write a SQL query that returns, for each product, the
quantity of those products sold to customers in Goleta.  
Your query should return the pid, product name, and total quantity sold in
Goleta, sorted in decreasing order of the total quantity.  Your query
should include products with a total =0.
*/
SELECT P.pid, P.pname, SUM(O.qnt)
FROM Orders O, Customer C, Product P
WHERE C.city = "Goleta"
    AND O.pid = P.pid
    AND O.cid = C.cid
GROUP BY P.pid, P.pname
ORDER BY SUM(O.qnt) DESC;


/*
For each city, return the most expensive product sold in that city. 
Your query should return the city name, the pid,
pname, and price of the most expensive product sold
there; in case of a tie (two or more products had the same maximum
price), then return all of those products. If nothing was ordered in
a city, then your query does not need to return that city.
*/
with MaxPrice as (
    select C.city, max(P.price) as max_price
    from 
        Product P, Customer C, Orders O
    where 
            P.pid = O.pid
        and C.cid = O.cid
    group by C.city 
)

from Product P, Customer C, Orders O, MaxPrice M
where
    P.pid = O.pid
    and C.cid = O.cid
    and C.city = M.city
    and P.price = M.max_price
