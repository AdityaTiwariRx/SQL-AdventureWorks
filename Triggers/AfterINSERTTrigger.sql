USE SqlTriggers;
GO
CREATE TRIGGER AfterINSERTTrigger on EmployeeTable
FOR INSERT 
AS DECLARE @EmpID INT,
	   @EmpName VARCHAR(50),
	   @EmpEducation VARCHAR(50),
	   @EmpOccupation VARCHAR(50),
	   @EmpYearlyIncome DECIMAL (10, 2), 
	   @EmpSales DECIMAL (10, 2); 

SELECT @EmpID = ins.ID FROM INSERTED ins;
SELECT @EmpName = ins.Name FROM INSERTED ins;
SELECT @EmpEducation = ins.Education FROM INSERTED ins;
SELECT @EmpOccupation = ins.Occupation FROM INSERTED ins;
SELECT @EmpYearlyIncome = ins.YearlyIncome FROM INSERTED ins;
SELECT @EmpSales = ins.Sales FROM INSERTED ins;

INSERT INTO EmployeeTableAudit ( 
       [ID],
       [Name],
       [Education],
       [Occupation],
       [YearlyIncome],
       [Sales],
       [ServerName],
       [ServerInstanceName],
       [Insert Time])

VALUES (@EmpID,
	@EmpName,
	@EmpEducation,
	@EmpOccupation,
	@EmpYearlyIncome,
	@EmpSales,
	CAST( SERVERPROPERTY('MachineName') AS VARCHAR(50)), 
	CAST( SERVERPROPERTY('ServerName') AS VARCHAR(50)), 
	GETDATE()
	);

PRINT 'We Successfully Fired the AFTER INSERT Triggers in SQL Server.'
GO