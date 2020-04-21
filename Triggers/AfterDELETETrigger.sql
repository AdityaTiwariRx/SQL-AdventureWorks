USE SqlTriggers;
GO

CREATE TRIGGER AfterDELETETrigger 
on EmployeeTable

FOR DELETE 
AS DECLARE @EmpID INT,
           @EmpName VARCHAR(50),
	   @EmpEducation VARCHAR(50),
	   @EmpOccupation VARCHAR(50),
	   @EmpYearlyIncome DECIMAL (10, 2), 
	   @EmpSales DECIMAL (10, 2);

SELECT @EmpID = del.ID FROM DELETED del;
SELECT @EmpName = del.Name FROM DELETED del;
SELECT @EmpEducation = del.Education FROM DELETED del;
SELECT @EmpOccupation = del.Occupation FROM DELETED del;
SELECT @EmpYearlyIncome = del.YearlyIncome FROM DELETED del;
SELECT @EmpSales = del.Sales FROM DELETED del;
  
INSERT INTO EmployeeAuditTable ( 
       ID,
       [Name],
       [Education],
       [Occupation],
       [YearlyIncome],
       [Sales],
       [ServerName],
       [ServerInstanceName],
       [Deleted Time])

VALUES (@EmpID,
        @EmpName,
	@EmpEducation,
	@EmpOccupation,
	@EmpYearlyIncome,
	@EmpSales,
	CAST( SERVERPROPERTY('MachineName') AS VARCHAR(50)), 
	CAST( SERVERPROPERTY('ServerName') AS VARCHAR(50)), 
	GETDATE());

PRINT 'We Successfully Fired the AFTER DELETE Triggers in SQL Server.'
GO