/* FOR JSON AUTO

The functionality is similar to FOR XML AUTO. FOR JSON AUTO will export the tabular data by automatically creating the nested JSON sub-arrays based on the table hierarchy used in the query.
 */
Use master;
GO

DROP DATABASE IF EXISTS JSONDatabase;
GO

CREATE DATABASE JSONDatabase;
GO

USE JSONDatabase;
GO

CREATE TABLE dbo.OrderHeader(
	OrderID INT,
	OrderDate SMALLDATETIME,
	CustumerNumber VARCHAR(6)
);
GO
 
CREATE TABLE dbo.OrderDetails(
	OrderID INT,
	ProductNumber VARCHAR(6),
	Quantity INT,
	Price MONEY,
	LineTotal MONEY
);
GO
 
INSERT INTO dbo.OrderHeader (OrderID, OrderDate, CustumerNumber)
VALUES (1,'27-Dec-2016','CQ1234');
GO
 
INSERT INTO dbo.OrderDetails (OrderId, ProductNumber, Quantity, Price, LineTotal)
VALUES (1,'101010',2,150,300),(1,'202020',1,147.50,147.50);
GO

/* Execute the following query */
SELECT OH.OrderID, OH.OrderDate, OH.CustumerNumber, OD.ProductNumber, OD.Quantity, OD.Price,
    OD.LineTotal
FROM
	dbo.OrderHeader AS OH
	JOIN dbo.OrderDetails AS OD
	ON OD.OrderID = OH.OrderID
FOR JSON AUTO;
GO 

/* Since we haven't used any column aliases, the exact column names have been used as keys. If we use columns aliases the aliases will be used as attribute keys */
SELECT 
	OH.OrderID, OH.OrderDate, OH.CustumerNumber, 
    OD.ProductNumber, OD.Quantity AS ProductQuantity, OD.Price AS ProductPrice, 
	OD.LineTotal AS ProductLineTotal
FROM dbo.OrderHeader AS OH
	JOIN dbo.OrderDetails AS OD ON OD.OrderID = OH.OrderID
FOR JSON AUTO;
GO

/* The column aliases have been used as attribute keys 

In both examples for FOR JSON AUTO, you can see that the produced JSON doesn't contain a root element. This is due to the fact that we haven't given instruction to FOR JSON to export the result with a root element. Now we can export the details with a root element */
SELECT OH.OrderId, OH.OrderDate, OH.CustumerNumber, OD.ProductNumber, 
       OD.Quantity  AS ProductQuantity, OD.Price AS ProductPrice, 
	   OD.LineTotal AS ProductLineTotal
FROM dbo.OrderHeader AS OH
	JOIN dbo.OrderDetails AS OD 
	ON OD.OrderID = OH.OrderID
FOR JSON AUTO, ROOT ('OrderInfo');
GO

/* FOR JSON PATH
Using PATH option we extract the details in a way how the SELECT statement will fetch. That’s instead of fetching order line information as a separate object (like in AUTO option), it will return as two different elements, along with the Order Header information.
*/
SELECT OH.OrderID, OH.OrderDate, OH.CustumerNumber, OD.ProductNumber, 
       OD.Quantity AS ProductQuantity, OD.Price AS ProductPrice, 
	   OD.LineTotal AS ProductLineTotal
FROM dbo.OrderHeader AS OH
	JOIN dbo.OrderDetails AS OD 
	ON OD.OrderID = OH.OrderID
FOR JSON PATH, ROOT ('OrderInfo');
GO

/* However, there is one important thing, which you should be aware of when exporting details using FOR JSON PATH option. If you have the same column name on multiple tables you can only fetch one such column. If you include both these columns it will result in an error.

For example, if we try to export OrderId from both Header and Detail tables it will throw an error. */
SELECT OH.OrderID, OH.OrderDate, OH.CustumerNumber, OD.OrderID AS A, OD.ProductNumber,
       OD.Quantity, OD.Price, OD.LineTotal
FROM dbo.OrderHeader AS OH
	JOIN dbo.OrderDetails AS OD 
	ON OD.OrderID = OH.OrderID
FOR JSON PATH, ROOT ('OrderInfo');
GO