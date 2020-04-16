use SqlAssign

alter PROCEDURE spOutputJson 
@jsonOutput VARCHAR(MAX) OUTPUT 
AS 
BEGIN
 
SET @jsonOutput = (SELECT TOP (1) FirstName,LastName FROM JoinQuery.Employee FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
END

DECLARE @json AS NVARCHAR(MAX)
EXEC dbo.spOutputJson @jsonOutput = @json OUTPUT
  
SELECT @json