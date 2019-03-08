USE master;
GO

DROP DATABASE IF EXISTS LoadJSONIntoSQLServer;
GO

CREATE DATABASE LoadJSONIntoSQLServer;
GO

USE LoadJSONIntoSQLServer;
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

-- Create stored procedure
DROP PROCEDURE IF EXISTS dbo.uspInsertPerformanceCounterData;
GO

CREATE PROCEDURE dbo.uspInsertPerformanceCounterData
@json NVARCHAR(MAX)
AS
BEGIN
INSERT INTO dbo.ZalnetPerformanceCounter (
   RecordedDateTime,
   RecordedDateTimeLocal,
   CpuPercentProcessorTime,
   MemoryAvailableInGB)
    SELECT
        RecordedDateTime,
        RecordedDateTimeLocal,
        CpuPercentProcessorTime,
        MemoryAvailableInGB
    FROM OPENJSON(@json)
    WITH (
      RecordedDateTime DATETIME2(0) '$.dateTime',
      RecordedDateTimeLocal DATETIME2(0) '$.dateTimeLocal',
      CpuPercentProcessorTime SMALLINT '$.cpuPercentProcessorTime',
      MemoryAvailableInGB SMALLINT '$.memoryAvailableInGB'
    ) AS jsonValues
END;
GO

 --Results
SELECT RecordedDateTime,
       RecordedDateTimeLocal,
       CpuPercentProcessorTime,
       MemoryAvailableInGB
  FROM dbo.ZalnetPerformanceCounter;
GO
