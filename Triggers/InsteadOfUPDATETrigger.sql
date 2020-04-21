USE SqlTriggers;
GO
CREATE TRIGGER InsteadOfUPDATETrigger
on EmployeeTable

INSTEAD OF UPDATE 
AS DECLARE @ActionPeformed VARCHAR(50)

IF UPDATE(YearlyIncome)
BEGIN
     SET @ActionPeformed = 'Updated Yearly Income'
END
ELSE BEGIN
      SET @ActionPeformed = 'Updated Sales'
END

INSERT INTO EmployeeTableAudit( 
       [ID],
       [Name],
       [Education],
       [Occupation],
       [YearlyIncome],
       [Sales],
       [Update Time],
       [ActionPerformed])

SELECT ID,
	Name,
	Education,
	Occupation,
	YearlyIncome,
	Sales,
	GETDATE(),
	@ActionPeformed
FROM INSERTED;

PRINT 'We Successfully Fired Our First INSTEAD OF UPDATE Triggers in SQL Server.'
GO