Demo 1:
-- QueryStore_Demo

IF EXISTS(SELECT * FROM sys.indexes WHERE name = N'ix_TempProduct' AND object_id = OBJECT_ID(N'SalesLT.TempProduct', N'U'))
BEGIN
	DROP INDEX ix_TempProduct
		ON SalesLT.TempProduct;
END

CREATE NONCLUSTERED INDEX ix_TempProduct
	ON SalesLT.TempProduct (ProductCategoryID)
	INCLUDE (Name, ProductNumber);

--------------------------------------------------------------------------------
ALTER DATABASE AdventureWorksLT
	SET QUERY_STORE CLEAR;
--------------------------------------------------------------------------------

SELECT C.ProductCategoryID, C.Name AS 'Category', P.Name AS 'ProductName', P.ProductNumber, SUM(D.OrderQty) AS 'OrderQty', SUM(D.LineTotal) AS 'OrderValue'
	FROM SalesLT.ProductCategory AS C
		INNER JOIN SalesLT.TempProduct AS P
			ON P.ProductCategoryID = C.ProductCategoryID
		LEFT OUTER JOIN SalesLT.SalesOrderDetail AS D
			ON D.ProductID = P.ProductID
	GROUP BY C.ProductCategoryID, C.Name, P.Name, P.ProductNumber;
--------------------------------------------------------------------------------
SELECT C.CompanyName, CONCAT(C.FirstName, N' ' + C.MiddleName, N' ' + C.LastName) AS Name, P.Name as 'ProductName', P.ProductNumber, SUM(H.TotalDue) AS 'TotalDue'
	FROM SalesLT.Customer AS C
		INNER JOIN SalesLT.SalesOrderHeader AS H
			ON H.CustomerID = C.CustomerID
		INNER JOIN SalesLT.SalesOrderDetail AS D
			ON D.SalesOrderID = H.SalesOrderID
		INNER JOIN SalesLT.TempProduct AS P
			ON P.ProductID = D.ProductID
	WHERE P.ProductCategoryID <= 15
	GROUP BY C.CompanyName, C.FirstName, C.MiddleName, C.LastName, P.Name, P.ProductNumber;
--------------------------------------------------------------------------------
DROP INDEX ix_TempProduct
	ON SalesLT.TempProduct;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Demo 2:
-- QueryStore_CatalogView_Demo

IF EXISTS(SELECT * FROM sys.indexes WHERE name = N'ix_TempProduct' AND object_id = OBJECT_ID(N'SalesLT.TempProduct', N'U'))
BEGIN
	DROP INDEX ix_TempProduct
		ON SalesLT.TempProduct;
END

CREATE NONCLUSTERED INDEX ix_TempProduct
	ON SalesLT.TempProduct (ProductCategoryID)
	INCLUDE (Name, ProductNumber);
--------------------------------------------------------------------------------
ALTER DATABASE AdventureWorksLT
	SET QUERY_STORE CLEAR;
--------------------------------------------------------------------------------
SELECT C.ProductCategoryID, C.Name AS 'Category', P.Name AS 'ProductName', P.ProductNumber, SUM(D.OrderQty) AS 'OrderQty', SUM(D.LineTotal) AS 'OrderValue'
	FROM SalesLT.ProductCategory AS C
		INNER JOIN SalesLT.TempProduct AS P
			ON P.ProductCategoryID = C.ProductCategoryID
		LEFT OUTER JOIN SalesLT.SalesOrderDetail AS D
			ON D.ProductID = P.ProductID
	GROUP BY C.ProductCategoryID, C.Name, P.Name, P.ProductNumber;
--------------------------------------------------------------------------------
SELECT C.CompanyName, CONCAT(C.FirstName, N' ' + C.MiddleName, N' ' + C.LastName) AS Name, P.Name as 'ProductName', P.ProductNumber, SUM(H.TotalDue) AS 'TotalDue'
	FROM SalesLT.Customer AS C
		INNER JOIN SalesLT.SalesOrderHeader AS H
			ON H.CustomerID = C.CustomerID
		INNER JOIN SalesLT.SalesOrderDetail AS D
			ON D.SalesOrderID = H.SalesOrderID
		INNER JOIN SalesLT.TempProduct AS P
			ON P.ProductID = D.ProductID
	WHERE P.ProductCategoryID <= 15
	GROUP BY C.CompanyName, C.FirstName, C.MiddleName, C.LastName, P.Name, P.ProductNumber;
--------------------------------------------------------------------------------
DROP INDEX ix_TempProduct
	ON SalesLT.TempProduct;
--------------------------------------------------------------------------------
SELECT *
	FROM sys.query_store_query_text
	WHERE query_sql_text LIKE N'SELECT C.ProductCategoryID,%' OR
			query_sql_text LIKE N'SELECT C.CompanyName,%';


SELECT *
	FROM sys.query_context_settings;
--------------------------------------------------------------------------------

WITH QueryText_CTE AS
(
	SELECT query_text_id
		FROM sys.query_store_query_text
		WHERE query_sql_text LIKE N'SELECT C.ProductCategoryID,%' OR
				query_sql_text LIKE N'SELECT C.CompanyName,%'
)
SELECT Q.*
	FROM sys.query_store_query AS Q
		INNER JOIN QueryText_CTE AS T
			ON Q.query_text_id = T.query_text_id;
--------------------------------------------------------------------------------

WITH QueryStoreQuery_CTE AS
(
	SELECT Q.query_id
		FROM sys.query_store_query_text AS T
			INNER JOIN sys.query_store_query AS Q
				ON Q.query_text_id = T.query_text_id
		WHERE T.query_sql_text LIKE N'SELECT C.ProductCategoryID,%' OR
				T.query_sql_text LIKE N'SELECT C.CompanyName,%'
)
SELECT P.*
	FROM sys.query_store_plan AS P
		INNER JOIN QueryStoreQuery_CTE AS Q
			ON P.query_id = Q.query_id;


WITH QueryStoreQuery_CTE AS
(
	SELECT Q.query_id
		FROM sys.query_store_query_text AS T
			INNER JOIN sys.query_store_query AS Q
				ON Q.query_text_id = T.query_text_id
		WHERE T.query_sql_text LIKE N'SELECT C.ProductCategoryID,%' OR
				T.query_sql_text LIKE N'SELECT C.CompanyName,%'
)
SELECT P.plan_id, P.query_id, CAST(query_plan AS xml) AS 'xml_query_plan'
	FROM sys.query_store_plan AS P
		INNER JOIN QueryStoreQuery_CTE AS Q
			ON P.query_id = Q.query_id;
--------------------------------------------------------------------------------
SELECT *
	FROM sys.query_store_runtime_stats_interval;
--------------------------------------------------------------------------------

WITH QueryStorePlan_CTE AS
(
	SELECT T.query_text_id, T.query_sql_text, Q.query_id, P.plan_id, P.query_plan
		FROM sys.query_store_query_text AS T
			INNER JOIN sys.query_store_query AS Q
				ON Q.query_text_id = T.query_text_id
			INNER JOIN sys.query_store_plan AS P
				ON P.query_id = Q.query_id
		WHERE T.query_sql_text LIKE N'SELECT C.ProductCategoryID,%' OR
				T.query_sql_text LIKE N'SELECT C.CompanyName,%'
)
SELECT P.query_text_id, P.query_sql_text, P.query_id, P.plan_id, CAST(p.query_plan as xml) as 'xml_query_plan', I.start_time AS 'interval_start_time', I.end_time AS 'interval_end_time', S.count_executions, S.avg_duration, S.avg_cpu_time, S.avg_logical_io_reads
	FROM sys.query_store_runtime_stats AS S
		INNER JOIN QueryStorePlan_CTE AS P
			ON S.plan_id = P.plan_id
		INNER JOIN sys.query_store_runtime_stats_interval AS I
			ON I.runtime_stats_interval_id = S.runtime_stats_interval_id
	ORDER BY P.query_text_id, P.query_id, P.plan_id, i.start_time;


