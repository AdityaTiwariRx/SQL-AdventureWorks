USE SqlTriggers;
GO

CREATE TRIGGER AfterUPDATETrigger
on EmployeeTable

FOR UPDATE 
AS DECLARE @EmpID INT,
           @EmpName VARCHAR(50),
	   @EmpEducation VARCHAR(50),
	   @EmpOccupation VARCHAR(50),
	   @EmpYearlyIncome DECIMAL (10, 2), 
	   @EmpSales DECIMAL (10, 2), 
	   @ActionPeformed VARCHAR(50);

SELECT @EmpID = ins.ID FROM INSERTED ins;
SELECT @EmpName = ins.Name FROM INSERTED ins;
SELECT @EmpEducation = ins.Education FROM INSERTED ins;
SELECT @EmpOccupation = ins.Occupation FROM INSERTED ins;
SELECT @EmpYearlyIncome = ins.YearlyIncome FROM INSERTED ins;
SELECT @EmpSales = ins.Sales FROM INSERTED ins;
  
IF UPDATE(YearlyIncome)
BEGIN
     SET @ActionPeformed = 'Updated Yearly Income'
END
 
IF UPDATE(Sales)
BEGIN
      SET @ActionPeformed = 'Updated Sales'
END

INSERT INTO EmployeeTableAudit ( 
       ID,
       [Name],
       [Education],
       [Occupation],
       [YearlyIncome],
       [Sales],
       [Update Time],
       [ActionPerformed])

VALUES (@EmpID,
        @EmpName,
	@EmpEducation,
	@EmpOccupation,
	@EmpYearlyIncome,
	@EmpSales,
	GETDATE(),
	@ActionPeformed);

PRINT 'We Successfully Fired the AFTER UPDATE Triggers in SQL Server.'
GO