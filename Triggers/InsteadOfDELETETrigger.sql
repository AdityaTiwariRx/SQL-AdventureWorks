USE SqlTriggers;
GO

CREATE TRIGGER InsteadOfDELETETrigger
on EmployeeTable

INSTEAD OF DELETE
AS 

MERGE EmployeeTableAudit AS AuditTab
USING (SELECT * FROM DELETED) AS Emp
ON AuditTab.ID = emp.ID
WHEN MATCHED THEN DELETE; 

PRINT 'We Successfully Fired Our First INSTEAD OF DELETE Triggers in SQL Server.'
GO