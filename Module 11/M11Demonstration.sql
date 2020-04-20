
USE AdventureWorks;
GO

CREATE TRIGGER TR_SalesOrderHeader_Insert
ON Sales.SalesOrderHeader
AFTER INSERT AS BEGIN
  IF EXISTS( SELECT 1 
             FROM inserted AS i
             WHERE i.SubTotal > 10000
             AND i.PurchaseOrderNumber IS NULL
           ) BEGIN
    PRINT 'Orders above 10000 must have PO numbers';
    ROLLBACK;           
  END;
END;
GO

INSERT INTO Sales.SalesOrderHeader 
  (RevisionNumber, OrderDate, DueDate, Status, 
   OnlineOrderFlag, PurchaseOrderNumber,
   CustomerID, SalespersonID, BillToAddressID, ShipToAddressID, 
   ShipMethodID, SubTotal, TaxAmt, Freight)
  VALUES (1, SYSDATETIME(), SYSDATETIME(), 1,
          1, 'ABC-123',
          4, 274, 3, 3,
          1, 10502, 12, 100);
GO

INSERT INTO Sales.SalesOrderHeader 
  (RevisionNumber, OrderDate, DueDate, Status, 
   OnlineOrderFlag, PurchaseOrderNumber,
   CustomerID, SalespersonID, BillToAddressID, ShipToAddressID, 
   ShipMethodID, SubTotal, TaxAmt, Freight)
  VALUES (1, SYSDATETIME(), SYSDATETIME(), 1,
          1, NULL,
          4, 274, 3, 3,
          1, 8000, 12, 100);
GO

INSERT INTO Sales.SalesOrderHeader 
  (RevisionNumber, OrderDate, DueDate, Status, 
   OnlineOrderFlag, PurchaseOrderNumber,
   CustomerID, SalespersonID, BillToAddressID, ShipToAddressID, 
   ShipMethodID, SubTotal, TaxAmt, Freight)
  VALUES (1, SYSDATETIME(), SYSDATETIME(), 1,
          1, NULL,
          4, 274, 3, 3,
          1, 18000, 12, 100);
GO

DROP TRIGGER Sales.TR_SalesOrderHeader_Insert;
GO

DELETE soh 
FROM Sales.SalesOrderHeader AS soh
WHERE NOT EXISTS (SELECT 1
                  FROM Sales.SalesOrderDetail AS sod
                  WHERE soh.SalesOrderID = sod.SalesOrderID);
GO
--------------------------------------------------------------

USE AdventureWorks;
GO

SELECT * FROM Sales.SalesTerritoryHistory;
GO

CREATE TRIGGER TR_SalesTerritoryHistory_Delete
ON Sales.SalesTerritoryHistory
AFTER DELETE AS BEGIN
  IF EXISTS(SELECT 1
            FROM deleted AS d
            WHERE d.EndDate IS NULL) BEGIN
    PRINT 'Current Sales Territory History rows cannot be deleted';
    ROLLBACK;
  END;
END;
GO

SELECT * FROM Sales.SalesTerritoryHistory WHERE BusinessEntityID = 283;
GO

DELETE FROM Sales.SalesTerritoryHistory 
WHERE BusinessEntityID = 283;
GO

DROP TRIGGER Sales.TR_SalesTerritoryHistory_Delete;
GO
---------------------------------------------------------------------------

USE tempdb;
GO

CREATE TABLE dbo.CurrentPrice
(
	CurrentPriceID int IDENTITY(1,1) 
	  CONSTRAINT PK_CurrentPrice PRIMARY KEY,
	SellingPrice decimal(18,2) NOT NULL,
	LastModified datetime2 NOT NULL
	  CONSTRAINT DF_CurrentPrice_LastModified
	  DEFAULT (SYSDATETIME()),
	ModifiedBy sysname NOT NULL
	  CONSTRAINT DF_CurrentPrice_ModifiedBy
	  DEFAULT (ORIGINAL_LOGIN())
);
GO

INSERT INTO dbo.CurrentPrice 
  (SellingPrice)
  VALUES (2.3), (4.3), (5);
GO

SELECT * FROM dbo.CurrentPrice;
GO

UPDATE dbo.CurrentPrice 
SET SellingPrice = 10 
WHERE CurrentPriceID = 2;
GO

SELECT * FROM dbo.CurrentPrice;
GO

CREATE TRIGGER TR_CurrentPrice_Update
ON dbo.CurrentPrice
AFTER UPDATE AS BEGIN
  SET NOCOUNT ON;
  UPDATE cp
  SET cp.LastModified = SYSDATETIME(),
      cp.ModifiedBy = ORIGINAL_LOGIN()
  FROM dbo.CurrentPrice AS cp
  INNER JOIN inserted AS i
  ON cp.CurrentPriceID = i.CurrentPriceID;
END;
GO

UPDATE dbo.CurrentPrice 
SET SellingPrice = 20 
WHERE CurrentPriceID = 2;
GO

SELECT * FROM dbo.CurrentPrice;
GO

SELECT * FROM sys.triggers;
GO

DROP TABLE dbo.CurrentPrice;
GO

SELECT * FROM sys.triggers;
GO
-------------------------------------------------------------

USE tempdb;
GO

CREATE TABLE dbo.CurrentPrice
(
	CurrentPriceID int IDENTITY(1,1) 
	  CONSTRAINT PK_CurrentPrice PRIMARY KEY,
	SellingPrice decimal(18,2) NOT NULL,
	LastModified datetime2 NOT NULL
	  CONSTRAINT DF_CurrentPrice_LastModified
	  DEFAULT (SYSDATETIME()),
	ModifiedBy sysname NOT NULL
	  CONSTRAINT DF_CurrentPrice_ModifiedBy
	  DEFAULT (ORIGINAL_LOGIN()),
	IsValid bit NOT NULL
	  CONSTRAINT DF_CurrentPrice_IsValid
	  DEFAULT (1)
);
GO

INSERT INTO dbo.CurrentPrice 
  (SellingPrice)
  VALUES (2.3), (4.3), (5);
GO

SELECT * FROM dbo.CurrentPrice;
GO

CREATE TRIGGER TR_CurrentPrice_Delete
ON dbo.CurrentPrice
INSTEAD OF DELETE AS BEGIN
  SET NOCOUNT ON;
  UPDATE cp
  SET cp.IsValid = 0
  FROM dbo.CurrentPrice AS cp
  INNER JOIN deleted AS d
  ON cp.CurrentPriceID = d.CurrentPriceID;
END;
GO

DELETE dbo.CurrentPrice
WHERE CurrentPriceID = 2;
GO

SELECT * FROM dbo.CurrentPrice;
GO

SELECT * FROM sys.triggers;
GO

DROP TABLE dbo.CurrentPrice;
GO

CREATE TABLE dbo.PostalCode
( CustomerID int PRIMARY KEY,
  PostalCode nvarchar(5) NOT NULL,
  PostalSubCode nvarchar(5) NULL
);
GO

CREATE VIEW dbo.PostalRegion
AS
SELECT CustomerID,
       PostalCode + COALESCE('-' + PostalSubCode,'') AS PostalRegion
FROM dbo.PostalCode;
GO

INSERT dbo.PostalCode (CustomerID,PostalCode,PostalSubCode)
VALUES (1,'23422','234'),
       (2,'23523',NULL),
       (3,'08022','523');
GO

SELECT * FROM dbo.PostalRegion;
GO

INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (4,'09232-432');
GO

UPDATE dbo.PostalRegion SET PostalRegion = '23234-523' WHERE CustomerID = 3;
GO

DELETE FROM dbo.PostalRegion WHERE CustomerID = 3;
GO

CREATE TRIGGER TR_PostalRegion_Insert
ON dbo.PostalRegion
INSTEAD OF INSERT
AS
INSERT INTO dbo.PostalCode 
SELECT CustomerID, 
       SUBSTRING(PostalRegion,1,5),
       CASE WHEN SUBSTRING(PostalRegion,7,5) <> '' THEN SUBSTRING(PostalRegion,7,5) END
FROM inserted;
GO

INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (4,'09232-432');
GO

ALTER TRIGGER TR_PostalRegion_Insert
ON dbo.PostalRegion
INSTEAD OF INSERT
AS
SET NOCOUNT ON;
INSERT INTO dbo.PostalCode 
SELECT CustomerID, 
       SUBSTRING(PostalRegion,1,5),
       CASE WHEN SUBSTRING(PostalRegion,7,5) <> '' THEN SUBSTRING(PostalRegion,7,5) END
FROM inserted;
GO

INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (5,'92232-142');
GO

INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (6,'11111-111'),
       (7,'99999-999');
GO

SELECT * FROM dbo.PostalRegion;
GO

DROP VIEW dbo.PostalRegion;
GO
DROP TABLE dbo.PostalCode;
GO
----------------------------------------------------------------------------------------------

USE tempdb;
GO

CREATE TABLE dbo.SellingPrice
(
	SellingPriceID int IDENTITY(1,1) 
	  CONSTRAINT PK_SellingPrice PRIMARY KEY,
	SubTotal decimal(18,2) NOT NULL,
	TaxAmount decimal(18,2) NOT NULL,
	FreightAmount decimal(18,2) NOT NULL,
	ExtendedAmount decimal(18,2) NULL
);
GO

CREATE TRIGGER TR_SellingPrice_InsertUpdate
ON dbo.SellingPrice
AFTER INSERT, UPDATE AS BEGIN
  SET NOCOUNT ON;
  UPDATE sp
  SET sp.ExtendedAmount = sp.SubTotal 
                        + sp.TaxAmount 
                        + sp.FreightAmount
  FROM dbo.SellingPrice AS sp
  INNER JOIN inserted AS i
  ON sp.SellingPriceID = i.SellingPriceId;
END;
GO

INSERT INTO dbo.SellingPrice
  (SubTotal, TaxAmount, FreightAmount)
  VALUES (12.3, 1.23, 10), (5, 1, 2);
GO

SELECT * FROM dbo.SellingPrice;
GO
 
DROP TABLE dbo.SellingPrice;
GO

CREATE TABLE dbo.SellingPrice
(
	SellingPriceID int IDENTITY(1,1) 
	  CONSTRAINT PK_SellingPrice PRIMARY KEY,
	SubTotal decimal(18,2) NOT NULL,
	TaxAmount decimal(18,2) NOT NULL,
	FreightAmount decimal(18,2) NOT NULL,
	ExtendedAmount AS (SubTotal + TaxAmount + FreightAmount) PERSISTED
);
GO

INSERT INTO dbo.SellingPrice
  (SubTotal, TaxAmount, FreightAmount)
  VALUES (12.3, 1.23, 10), (5, 1, 2);
GO

SELECT * FROM dbo.SellingPrice;
GO

DROP TABLE dbo.SellingPrice;
GO
---------------------------------------------------------------------------





