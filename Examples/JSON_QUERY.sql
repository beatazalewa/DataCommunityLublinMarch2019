/* JSON_QUERY function will extract and return details as an array string from a given JSON string 

In json_path the $ symbol implies the json_string and $. Hobbies means Hobbies property in the json_string at the root level 

In JSON_VALUE this examples returns NULL (in lax mode) or error (in strict mode), because JSON_VALUE function is not for reading the JSON object or array, instead it is for reading the scalar JSON values like string, integer etc.

The first query will return all details which is under SpeakerInfo path.
The second query will return all details which is under Dependents path.
The third query will return all details related to the first element under Dependants	   path. Hence it will return only the first detail set unlike the one above. */
DECLARE @JSONText AS NVARCHAR(4000) = N'{ 
"SpeakerInfo": {
"FirstName": "Beata","LastName": "Zalewa","DateOfBirth": "25-Sep-1976","MonthSalary":1500 },

	"Dependants": [
	{"DepType":"Husband", "DepName":"Roman", "DepAge":50}, 

			{"DepType": "Daughter", "DepName": "Daria", "DepAge": 12}
				  ]}'

SELECT JSON_QUERY(@JSONText,'$.SpeakerInfo') AS Speaker
SELECT JSON_QUERY(@JSONText,'$.Dependants') AS SpeakerHusbandAndDaughter
SELECT JSON_QUERY(@JSONText,'$.Dependants[0]') AS OnlyHusbandWithoutDaughter

SELECT JSON_VALUE(@JSONText,'$.SpeakerInfo') AS Speaker
SELECT JSON_VALUE(@JSONText,'$.Dependants') AS SpeakerHusbandAndDaughter
SELECT JSON_VALUE(@JSONText,'$.Dependants[0]') AS OnlyHusbandWithoutDaughter

/* Try to get a JSON scalar value (i.e. non-JSON object or array, but a property) */
DECLARE @JSONText2 AS NVARCHAR(4000) = N'{ 
"SpeakerInfo": {
"FirstName": "Beata","LastName": "Zalewa","DateOfBirth": "25-Sep-1976","MonthSalary":1500 },

	"Dependants": [
	{"DepType":"Husband", "DepName":"Roman", "DepAge":50}, 

			{"DepType": "Daughter", "DepName": "Daria", "DepAge": 12}
				  ]}'

SELECT JSON_QUERY(@JSONText2,'$.SpeakerInfo.FirstName') AS Speaker_QUERY
SELECT JSON_VALUE(@JSONText2,'$.SpeakerInfo.FirstName') AS Speaker_VALUE
SELECT JSON_QUERY(@JSONText2,'$.Dependants[0].DepAge') AS OnlyHusbandWithoutDaughter_QUERY
SELECT JSON_VALUE(@JSONText2,'$.Dependants[0].DepAge') AS OnlyHusbandWithoutDaughter_VALUE




