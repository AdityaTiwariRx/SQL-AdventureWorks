ALTER TABLE Sales.MediaOutlet ADD CONSTRAINT IX_MediaOutlet UNIQUE CLUSTERED (
MediaOutletID
);

CREATE UNIQUE CLUSTERED INDEX CIX_PrintMediaPlacement ON Sales.PrintMediaPlacement (
PrintMediaPlacementID ASC
);

USE [AdventureWorks2012]
GO
CREATE NONCLUSTERED INDEX NCI_PrintMediaPlacement
ON [Sales].[PrintMediaPlacement] ([PublicationDate],[PlacementCost])
INCLUDE ([PrintMediaPlacementID],[MediaOutletID],[PlacementDate],[RelatedProductID])
GO

CREATE TABLE Sales.MediaOutlet (
MediaOutletID INT NOT NULL,
MediaOutletName NVARCHAR(40),
PrimaryContact NVARCHAR (50),
City NVARCHAR (50)
);

CREATE TABLE Sales.PrintMediaPlacement ( PrintMediaPlacementID INT NOT NULL,
MediaOutletID INT,
PlacementDate DATETIME,
PublicationDate DATETIME,
RelatedProductID INT,
PlacementCost DECIMAL(18,2)
);



