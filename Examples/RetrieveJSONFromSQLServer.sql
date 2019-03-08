USE master;
GO

DROP DATABASE IF EXISTS RetrieveJSONFromSQLServer;
GO

CREATE DATABASE RetrieveJSONFromSQLServer;
GO

USE RetrieveJSONFromSQLServer;
GO

-- Create table
DROP TABLE IF EXISTS dbo.ZalnetPerformanceCounter;
GO

CREATE TABLE dbo.ZalnetPerformanceCounter(
    RecordedDateTime        datetime2(0) NOT NULL,
    RecordedDateTimeLocal   datetime2(0) NOT NULL,
    CpuPercentProcessorTime smallint     NOT NULL,
    MemoryAvailableInGB     smallint     NOT NULL
);
GO
 
--Insert sample row
INSERT INTO dbo.ZalnetPerformanceCounter(
            RecordedDateTime,
            RecordedDateTimeLocal,
            CpuPercentProcessorTime,
            MemoryAvailableInGB)
VALUES
           ('2019-03-07 21:30:40',
            '2019-03-07 17:30:40',
            35,
            27);
GO

-- Retreive most recent row
 SELECT TOP(1)
        RecordedDateTime AS 'dateTime',
        RecordedDateTimeLocal AS 'dateTimeLocal',
        CpuPercentProcessorTime,
        MemoryAvailableInGB
  FROM dbo.ZalnetPerformanceCounter
  ORDER BY RecordedDateTimeLocal DESC
  FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
  GO

-- Create stored procedure
DROP PROCEDURE IF EXISTS dbo.uspRetrievePerformanceCounterData
GO
 
CREATE PROCEDURE dbo.uspRetrievePerformanceCounterData @jsonOutput NVARCHAR(MAX) OUTPUT 
AS 
BEGIN
SET @jsonOutput = (SELECT TOP (1)
      RecordedDateTime AS 'dateTime',
      RecordedDateTimeLocal AS 'dateTimeLocal',
      CpuPercentProcessorTime,
      MemoryAvailableInGB
    FROM dbo.ZalnetPerformanceCounter
    ORDER BY RecordedDateTimeLocal DESC
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) 
END;
GO

-- Test stored procedure
DECLARE @json AS NVARCHAR(MAX)
EXEC dbo.uspRetrievePerformanceCounterData @jsonOutput = @json OUTPUT
 
SELECT @json;
GO