Use [Northwind]
go

-- Assignment 2.1: Selecteer alle klanten (CUSTOMERID, COMPANYNAME) die in London wonen
-- en minder dan 5 orders hebben gedaan. Orden het resultaat op aantal geplaatste orders.
select Orders.CustomerID, CompanyName, count(OrderID) as nOrdersCustomer
from Customers
Join Orders ON Customers.CustomerID=Orders.CustomerID
where city like 'London'
Group by Orders.CustomerID, CompanyName
Having count(OrderID) < 5
ORDER BY nOrdersCustomer
go

-- Assignment 2.2: selecteer alle orders voor “Pavlova” met een salesresultaat van minstens 800.
select OrderID, ProductID, UnitPrice, Quantity, Discount, (UnitPrice * Quantity * (1-Discount)) as SalesResult
from [Order Details]
where productID in (select ProductID from Products where ProductName like 'Pavlova') AND (UnitPrice * Quantity * (1-Discount)) >= 800
order by SalesResult
go

-- Assignment 2.3: selecteer alle regio’s (REGIONDESCRIPTION) waarin het product “Chocolade” is verkocht.
-- 48 (productID)	Chocolade	22	3	10 pkgs.	12.75	15	70	25	0
select RegionDescription, RegionID
from Region
where regionID in (select RegionID from Territories where TerritoryID in 
	(select TerritoryID from EmployeeTerritories where EmployeeID in 
	(select EmployeeID from Orders where OrderID in 
	(select OrderID from [Order Details] where ProductID in 
	(select ProductID from Products where ProductName Like 'Chocolade')))))
go 

--Assignment 2.4: Selecteer alle orders (ORDERID, CUSTOMER.COMPANYNAME) voor het product “Tofu” waar de ‘freight’ kosten tussen 25 en 50 waren.
select Orders.OrderID, Customers.CompanyName
From Orders
Join Customers ON Orders.CustomerID=Customers.CustomerID
where Freight >= 25 AND Freight < 50 AND Orders.OrderID IN 
	(select OrderID from [Order Details] where ProductID IN 
	(select ProductID from Products where ProductName Like 'Tofu'))

--Assignment 2.5: Selecteer de plaatsnamen waarin zowel klanten als werknemers wonen. Gebruik een subquery voor deze opdracht.
select Distinct City
from Employees
where City in (select City from Customers)
go

--Assignment 2.6: Welke producten (PRODUCTID, PRODUCTNAME) zijn het meest verkocht (aantal) voor Duitse klanten,
-- en welke werknemers (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE) hebben deze producten verkocht?
-- Orden het resultaat op aantal. Toon alleen de top 5 resultaten.
select Products.ProductID, Products.ProductName, Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title, Customers.Country     
from Employees
Join Orders on Employees.EmployeeID=Orders.EmployeeID
Join [Order Details] on Orders.OrderID=[Order Details].OrderID
Join Products on [Order Details].ProductID=Products.ProductID
Join Customers on Orders.CustomerID=Customers.CustomerID
where Customers.Country like 'Germany' AND Products.ProductID in
(
select TOP 5 [Order Details].ProductID
from [Order Details]
Join Products on [Order Details].ProductID=Products.ProductID
Join Orders on [Order Details].OrderID=Orders.OrderID
Join Customers on Orders.CustomerID=Customers.CustomerID
where Country like 'Germany'
Group by [Order Details].ProductID
Order by sum(Quantity) desc
)

Group by Products.ProductID, Products.ProductName, Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title, Customers.Country
Order by Products.ProductID desc
go

--Assignment 2.7: Welke producten (PRODUCTID, PRODUCTNAME) zorgden voor de hoogste salesresultaten (SALESRESULT) voor Duitse klanten,
-- en welke werknemers (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE) hebben deze producten verkocht.
-- Orden op sales resultaat. Toon alleen de top 5 resultaten.
select Products.ProductID, Products.ProductName, Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title, CONVERT(Decimal(9,2), sum([Order Details].UnitPrice * Quantity * (1-Discount))) as SalesResult    
from Employees
Join Orders on Employees.EmployeeID=Orders.EmployeeID
Join [Order Details] on Orders.OrderID=[Order Details].OrderID
Join Products on [Order Details].ProductID=Products.ProductID
Join Customers on Orders.CustomerID=Customers.CustomerID
where Customers.Country like 'Germany' AND Products.ProductID in
(
select TOP 5 [Order Details].ProductID
from [Order Details]
Join Products on [Order Details].ProductID=Products.ProductID
Join Orders on [Order Details].OrderID=Orders.OrderID
Join Customers on Orders.CustomerID=Customers.CustomerID
where Country like 'Germany'
Group by [Order Details].ProductID
Order by sum([Order Details].UnitPrice * Quantity * (1-Discount)) desc
)

Group by Products.ProductID, Products.ProductName, Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title
Order by SalesResult desc
go

-- Assignment 2.8: Join de tabellen Products en Suppliers. Join de tabellen met: 
-- Inner Join
-- Left Join
-- Right Join
-- Full Join
-- Beschrijf de verschillen tussen de resultaten van deze joins en teken een plaatje van elke join.
select*
from Products
Inner join Suppliers on Products.SupplierID=Suppliers.SupplierID
go

select*
from Products
Left join Suppliers on Products.SupplierID=Suppliers.SupplierID
go

select*
from Products
right join Suppliers on Products.SupplierID=Suppliers.SupplierID
go

select*
from Products
full join Suppliers on Products.SupplierID=Suppliers.SupplierID
go

-- Assignment 2.9: Geef het gemiddelde resultaat van elke werknemer (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, AVARAGE_SALESRESULT).
-- Orden op salesresultaat.
select Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title, convert(decimal(10,2), avg(([Order Details].UnitPrice * Quantity * (1-Discount)))) as SalesResult    
from Employees
Join Orders on Employees.EmployeeID=Orders.EmployeeID
Join [Order Details] on Orders.OrderID=[Order Details].OrderID
Group by Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title
Order by avg([Order Details].UnitPrice * Quantity * (1-Discount)) desc
go








