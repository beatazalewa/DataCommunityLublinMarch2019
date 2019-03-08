/* JSON_VALUE - this example will use a JSON string which contains an array. 
We can fetch the speaker's first name and the name of speaker's daughter and husband's age 
Syntax: JSON_VALUE ( json_string,  json_path ) 
In the json_path the $ symbol implies the json_string and $.FirstName means FirstName property in the json_string at the root level.*/
DECLARE @JSONText AS NVARCHAR(4000) = N'{ 
"SpeakerInfo": {
"FirstName": "Beata", "LastName": "Zalewa", "DateOfBirth": "25-Sep-1976", "MonthSalary": 1500 },

	"Dependants": [
	{"DepType": "Husband", "DepName": "Roman", "DepAge": 50}, 

			{"DepType": "Daughter", "DepName": "Daria", "DepAge": 14}
				  ]}'
SELECT JSON_VALUE(@JSONText,'$.SpeakerInfo.FirstName') AS SpeakerName
SELECT JSON_VALUE(@JSONText,'$.Dependants[0].DepAge') AS SpeakerHusbandAge
SELECT JSON_VALUE(@JSONText,'$.Dependants[1].DepName') AS SpeakerDaughterName

/* The JSON path is case sensitive. Therefore it should match exactly with what you have on the JSON string. If the path is not found it will return NULL. */
DECLARE @JSONText2 AS NVARCHAR(4000) = N'{ 
"SpeakerInfo": 
{"FirstName": "Beata", "LastName": "Zalewa", "DateOfBirth": "25-Sep-1976", "MonthSalary": 1500 },

	"Dependants": [
	{"DepType": "Husband", "DepName": "Roman", "DepAge": 50}, 
	{"DepType": "Daughter", "DepName": "Daria", "DepAge": 14}
				  ]}'
SELECT JSON_VALUE(@JSONText2,'$.SpeakerInfo.firstName') AS SpeakerName
SELECT JSON_VALUE(@JSONText2,'$.Dependants[0].DepName') AS SpeakerHusbandName 

/* We can use 'strict' keyword before the JSON path, if we want distinguish NULL value from valid JSON string from invalid path */
DECLARE @JSONText3 AS NVARCHAR(4000) = N'{ 
"SpeakerInfo": 
{"FirstName": "Beata", "LastName": "Zalewa", "DateOfBirth": "25-Sep-1976", "MonthSalary": 1500 },

	"Dependants": [
	{"DepType": "Husband", "DepName": "Roman", "DepAge": 50}, 
	{"DepType": "Daughter", "DepName": "Daria", "DepAge": 14}
				  ]}'

SELECT JSON_VALUE(@JSONText3,'strict $.SpeakerInfo.firstName') AS SpeakerName

/*Trying to get non-scalar value */
DECLARE @JSONText4 AS NVARCHAR(4000) = N'{ 
"SpeakerInfo": 
{"FirstName": "Beata", "LastName": "Zalewa", "DateOfBirth": "25-Sep-1976", "MonthSalary": 1500 },

	"Dependants": [
	{"DepType": "Husband", "DepName": "Roman", "DepAge": 50}, 
	{"DepType": "Daughter", "DepName": "Daria", "DepAge": 14}
				  ]}'

--SELECT JSON_VALUE(@JSONText4,'$.Dependants') AS Dependants
SELECT JSON_VALUE(@JSONText4,'strict $.Dependants') AS Dependants

/* Another NULL example */
DECLARE @JSONText5 AS NVARCHAR(4000) = N'{ 
"SpeakerInfo": 
{"FirstName": "Beata", "LastName": "Zalewa", "DateOfBirth": "25-Sep-1976", "MonthSalary": 1500 },

	"Dependants": [
	{"DepType": "Husband", "DepName": "Roman", "DepAge": 50}, 
	{"DepType": "Daughter", "DepName": "Daria", "DepAge": 14}
				  ]}'
SELECT JSON_VALUE(@JSONText5,'strict $.Dependants[0]') AS Dependants
SELECT JSON_VALUE(@JSONText5,'$.Dependants[0].DepAge') AS Dependants






