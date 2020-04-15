
SELECT * FROM sys.views;
GO

SELECT * FROM sys.tables;
GO

SELECT * FROM sys.objects
GO

SELECT * FROM sys.objects
	WHERE type_desc = 'VIEW';
GO

SELECT * FROM INFORMATION_SCHEMA.TABLES;
GO

SELECT * FROM sys.dm_exec_connections;
GO

SELECT * FROM sys.dm_exec_sessions;
GO

SELECT * FROM sys.dm_exec_requests;
GO

SELECT * FROM sys.dm_exec_query_stats;
GO

SELECT TOP (20) qs.max_logical_reads,
                st.text 
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.max_logical_reads DESC;
-----------------------------------------------------------

IF OBJECT_ID(N'SalesLT.vw_CustomerOrders', N'V') IS NOT NULL
	DROP VIEW SalesLT.vw_CustomerOrders;
GO
CREATE VIEW SalesLT.vw_CustomerOrders
AS
SELECT C.CustomerID, C.FirstName, C.LastName, O.OrderDate, O.SubTotal, O.TotalDue 
FROM SalesLT.Customer AS C
	INNER JOIN SalesLT.SalesOrderHeader as O
ON C.CustomerID =O.CustomerID;
GO

SELECT * 
	FROM SalesLT.vw_CustomerOrders;
GO

SELECT * 
FROM SalesLT.vw_CustomerOrders
ORDER BY TotalDue Desc;
GO

SELECT OBJECT_DEFINITION(OBJECT_ID(N'SalesLT.vw_CustomerOrders',N'V'));
GO

ALTER VIEW SalesLT.vw_CustomerOrders
WITH ENCRYPTION
AS
	SELECT C.CustomerID, C.FirstName, C.LastName, O.OrderDate, O.SubTotal, O.TotalDue 
FROM SalesLT.Customer AS C
	INNER JOIN SalesLT.SalesOrderHeader as O
ON C.CustomerID =O.CustomerID;
GO

SELECT OBJECT_DEFINITION(OBJECT_ID(N'SalesLT.vw_CustomerOrders',N'V'));
GO

DROP VIEW SalesLT.vw_CustomerOrders;
GO
----------------------------------------------------------------------------------------------