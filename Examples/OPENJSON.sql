/* Usage of the OPENJSON without a pre-defined schema */
DECLARE @JSONText AS NVARCHAR(1000) = '
{
    "A Null Value":null,
    "String Value":"Some String Data",
    "Numeric Value":1000.00,
    "Boolean Value":true,
    "Array Data":["A","B","C"],
    "Object Data":{"Key1":"Value1", "Key2":10}
    }'
SELECT * FROM OPENJSON(@JSONText);
GO

/*Usage of the OPENJSON with a defined schema

When we use this method, it's mandatory to provide a list of column names along with the respective data types. One advantage we have using a well-defined schema over the previous method is the ability to generate a resultset containing different columns for each attribute value, and for column names can be customized as per our requirement. */
DECLARE @JSONText2 AS NVARCHAR(1000) = N'
{
	"OrderNumber":"XQ2379",
    "OrderDate":"20161228",
    "CustomerNumber": "CQ1298",
    "OrderValue": 12755.89
    }
'; 
SELECT * FROM OPENJSON(@JSONText2) WITH (
	OrderNumber VARCHAR(6),
	OrderDate DATE,
	OrderValue MONEY,
	CustomerNumber VARCHAR(6)	
);
GO

/* Now we will see how we can change the column names when we fetch the details using the  OPENJSON function. It's similar to the example shown previously. The difference here is that the column name should be the one which we require to be shown and after the respective data type, it should be followed by the exact JSON path. 
  (**Note that the path is case sensitive) 
  If you don't provide the correct path, the result set will return a NULL under the respective column. */
DECLARE @JSONText3 AS NVARCHAR(1000) = N'
{
	"OrderNumber":"XQ2379",
    "OrderDate":"20161228",
    "CustomerNo": "CQ1298",
    "OrderValue": 12755.89
    }
'; 
SELECT * FROM OPENJSON(@JSONText3) WITH (
	OrderNumber VARCHAR(6) N'$.OrderNumber',
	OrderDate DATE N'$.OrderDate',
	CustomerNumber VARCHAR(6) ,
	OrderValue MONEY N'$.OrderValue'
);
GO

/* The path for the OrderNumber is provided incorrectly */
DECLARE @JSONText4 AS NVARCHAR(1000) = N'
{"OrdNumber":"XQ2379","OrdValue": 12755.89}';
  
SELECT * FROM OPENJSON(@JSONText4) WITH (
	OrderNumber VARCHAR(6) N'$.OrderNumber',
	OrderValue MONEY N'$.OrderValue'
);
GO

/* Use strict */
DECLARE @JSONText5 AS NVARCHAR(1000) = N'
{"OrdNumber":"XQ2379","OrdValue": 12755.89}';
  
SELECT * FROM OPENJSON(@JSONText5) WITH (
	OrderNumber VARCHAR(6) N'strict $.OrderNumber',
	OrderValue MONEY N'strict $.OrderValue'
);
GO