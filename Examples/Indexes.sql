Use master;
GO

DROP DATABASE IF EXISTS JSONIndexes;
GO

CREATE DATABASE JSONIndexes;
GO

USE JSONIndexes;
GO

CREATE TABLE dbo.Customer ( 
    CustomerID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CustomerName NVARCHAR(50), 
	CustomerDetails NVARCHAR(MAX)
);
GO

INSERT INTO dbo.Customer (CustomerName, CustomerDetails)
SELECT TOP 200000 NEWID(),
 REPLACE('{"Address":{"State":"LU","Country":"Poland"},
 "Phone":"@Phone"}',
 '@Phone', 100000000-ROW_NUMBER() OVER (ORDER BY SC1.object_id))
FROM SYS.all_columns SC1
        CROSS JOIN SYS.all_columns SC2;
GO

SELECT * FROM dbo.Customer;
GO

/* Initial SpaceUsed by the Customer table */
EXEC sp_spaceused Customer;
GO

/* Enable the IO and TIME statistics to measure the performance of the queries */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

/* Statement which get the details of the Customer whose phone number is 99890000 */
SELECT *
FROM dbo.Customer
WHERE JSON_VALUE(CustomerDetails,'$.Phone') = '99890000';
GO

/* Fetching the customer data with this approach is resulting in higher number of IO and CPU time. */

/* The solution is add to the table a non-persisted computed column PhoneNumber to the Customer table. The value of this computed column is the Phone property value extracted using the JSON_VALUE function from the Detail column having Address and Phone information stored in the JSON format */
ALTER TABLE dbo.Customer
ADD PhoneNumber AS JSON_VALUE(CustomerDetails,'$.Phone');
GO

/* Space used after adding a computed column */
EXEC sp_spaceused Customer;
GO

/* A non-persisted computed column doesn't take any additional storage space. Non-persisted computed column value is computed/evaluated at run-time */

/* Get the details of the Customer, whose phone number is 99890000 by using the computed column PhoneNumber */
SELECT *
FROM dbo.Customer
WHERE PhoneNumber  = '99890000';
GO

/* The computed column didn't improve the IO and Time taken to execute the query */

/* Create an Index on the Computed column PhoneNumber */
CREATE INDEX IX_Customer_PhoneNumber
ON dbo.Customer(PhoneNumber);
GO

/* When you create this index you may get the warning. Simly: SQL Server doesn't know what will be the length of the value which will be extracted by the JSON_VALUE function. And the maximum length of the value that can be returned by JSON_VALUE function is NVARCHAR(4000).
*/

/* Space used after adding index on the computed column */
EXEC sp_spaceused Customer;
GO

/* There is no change the storage used for the table, it has taken only the extra storage for the index. So the computed column is still not persisted only in the index tree the computed value is persisted. Which is similar to creating index on any other table column */

/* Is there any improvement in the performance of the query */
SELECT *
FROM dbo.Customer
WHERE PhoneNumber  = '99890000';
GO 

/* Adding index on the computed column has drastically improved the IO and CPU time */

/* Disable statistics */
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

