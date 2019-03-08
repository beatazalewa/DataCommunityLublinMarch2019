/* UPDATE the first name and the last name to 'Marta Marcjanska' respectively. */
DECLARE @JSONText AS NVARCHAR(4000) = N'{ 
"SpeakerInfo": 
{"FirstName": "Beata","LastName": "Zalewa","DateOfBirth": "25-Sep-1976", "MonthSalary": 1500 },

	"Dependants": [
	{"DepType":"Husband", "DepName":"Roman", "DepAge":50}, 
	{"DepType": "Daughter", "DepName": "Daria", "DepAge": 14}
				  ]}'
SELECT	
	@JSONText = JSON_MODIFY(@JSONText,'$.SpeakerInfo.FirstName','Marta'),
	@JSONText = JSON_MODIFY(@JSONText,'$.SpeakerInfo.LastName','Marcjanska')
SELECT JSON_QUERY(@JSONText,'$.SpeakerInfo') 
 
/* REMOVE a property from an existing JSON string. The second parameter needs to be passed as NULL */
DECLARE @JSONText2 AS NVARCHAR(4000) = N'{ 
"SpeakerInfo": 
{"FirstName": "Beata","LastName": "Zalewa","DateOfBirth": "25-Sep-1976", "MonthSalary":1500 },

	"Dependants": [
	{"DepType":"Husband", "DepName":"Roman", "DepAge":50}, 
	{"DepType": "Daughter", "DepName": "Daria", "DepAge": 14}
				  ]}'
SELECT	
	@JSONText2 = JSON_MODIFY(@JSONText2,'$.SpeakerInfo.MonthSalary',NULL)
PRINT @JSONText2

/* INSERT a property called Date of Join into an existing JSON string. When inserting a property the syntax is similar as updating a JSON string, but the path provided should not exist in the JSON. Otherwise, the function will behave as the JSON_MODIFY has been used for modifying the existing property. Hence it will replace the value under the provided path instead of inserting a new property. */
DECLARE @JSONText3 AS NVARCHAR(4000) = N'{ 
"SpeakerInfo": 
{"FirstName": "Beata","LastName": "Zalewa","DateOfBirth": "25-Sep-1976", "MonthSalary":1500 },

	"Dependants": [
	{"DepType":"Husband", "DepName":"Roman", "DepAge":50}, 
	{"DepType": "Daughter", "DepName": "Daria", "DepAge": 14}
				  ]}'
SELECT	
	@JSONText3 = JSON_MODIFY(@JSONText3,'$.SpeakerInfo.DateOfJoin','28-Mar-2017')
SELECT	
	@JSONText3 = JSON_MODIFY(@JSONText3,'$.SpeakerInfo.DateOfJoin','28-Mar-2017')
PRINT @JSONText3

/* Code for modyfying a property 
SELECT @JSONText = JSON_MODIFY(@JSONText,'$.SpeakerInfo.FirstName','Marta') 
*/

/*The other way of inserting a new value to an existing JSON is to add it as a new element using the append keyword */ 
--  (with \ characters)
DECLARE @JSONText4 AS NVARCHAR(4000) = N'{ 
"SpeakerInfo": 
{"FirstName": "Beata","LastName": "Zalewa","DateOfBirth": "25-Sep-1976", "MonthSalary":1500 },

	"Dependants": [
	{"DepType":"Husband", "DepName":"Roman", "DepAge":50}, 
	{"DepType": "Daughter", "DepName": "Daria", "DepAge": 14}
				  ]}'
SELECT	
@JSONText4 = JSON_MODIFY(@JSONText4,'append $.Dependants',('{"DepType": "Cat", "DepName": "Simon", "DepAge": 2}'))
PRINT @JSONText4

-- without \ characters, using JSON_QUERY function
DECLARE @JSONText5 AS NVARCHAR(4000) = N'{ 
"SpeakerInfo": 
{"FirstName": "Beata","LastName": "Zalewa","DateOfBirth": "25-Sep-1976", "MonthSalary": 1500 },

	"Dependants": [
	{"DepType":"Husband", "DepName":"Roman", "DepAge":50}, 
	{"DepType": "Daughter", "DepName": "Daria", "DepAge": 14}
				  ]}'
SELECT	
@JSONText5 = JSON_MODIFY(@JSONText5,'append $.Dependants',JSON_QUERY('{"DepType": "Cat", "DepName": "Simon", "DepAge": 2}'))
PRINT @JSONText5