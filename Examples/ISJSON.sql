/* Input is a valid JSON Data Set([]), in this case the ISJSON function will return value as 1 */
DECLARE @JSONText1 nvarchar(max) = '[{"Id":1,"Name":"Beata"},
  {"Id":2,"Name":"Monika"}]'

IF ISJSON ( @JSONText1 ) = 1 
    PRINT 'Valid JSON'
	ELSE
	PRINT 'Invalid JSON'

/* Input is an invalid JSON, in this case the ISJSON function will return value as 0 */
DECLARE @JSONText2 nvarchar(max) = 'Beata' --info about error
IF ISJSON ( @JSONText2 ) = 0
    PRINT 'Invalid JSON'

/* Another invalid JSON, in this case the ISJSON function will return value as 0 */
DECLARE @JSONText3 nvarchar(max) = 'Beata'
IF ISJSON ( @JSONText3 ) = 1 
    PRINT 'Valid JSON'
	ELSE
	PRINT 'Invalid JSON'

/* Input is a NULL value, in this case the ISJSON function will return value as NULL */
SELECT ISJSON ( NULL ) AS 'ISJSON Result'

/* one more example (this example works) */
DECLARE @JSONText4 AS nvarchar(4000) = N'{"SpeakerInfo": {
			"FirstName": "Beata",
			"LastName": "Zalewa",
			"DateOfBirth": "25-Sep-1976",
			"MonthSalary": 1500
		}
	}'  
IF (ISJSON(@JSONText4)) = 1
	PRINT 'Valid JSON'
ELSE
	PRINT 'Invalid JSON'

/* this time isn't valid JSON, missing " after my name */
DECLARE @JSONText5 AS nvarchar(4000) = N'{"SpeakerInfo": {
			"FirstName": "Beata, 
			"LastName": "Zalewa",
			"DateOfBirth": "25-Sep-1976",
			"MonthSalary": 1500
		}
	}'  
IF (ISJSON(@JSONText5)) = 1
	PRINT 'Valid JSON'
ELSE
	PRINT 'Invalid JSON'

/* ISJSON and duplicate key - invalid JSON input returns 1 */
DECLARE @JSONText6 AS nvarchar(4000) = N'{"SpeakerInfo": {
			"FirstName": "Beata",
			"FirstName": "Beata",
			"LastName": "Zalewa",
			"DateOfBirth": "25-Sep-1976",
			"MonthSalary": 1500
		}
	}' 
IF (ISJSON(@JSONText6)) = 1
	PRINT 'Valid JSON'
ELSE
	PRINT 'Invalid JSON'