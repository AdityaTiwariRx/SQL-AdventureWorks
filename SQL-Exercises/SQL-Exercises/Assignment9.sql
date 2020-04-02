SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[NewStudent](

	[StudentId] [int] IDENTITY(1,1) NOT NULL,
	[Surname] [varchar](50) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[MiddleName] [varchar](50) NOT NULL,
	[Gender] [varchar](50) NOT NULL,
	[AdmitDate] [date] NOT NULL,
        CONSTRAINT [PK_NewStudent] PRIMARY KEY CLUSTERED 
(
	[StudentId] ASC
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO


SELECT * FROM NewStudent WHERE Surname="Shah";

SELECT * FROM NewStudent WHERE Gender="Male";

SELECT * FROM NewStudent WHERE Gender="Female" and Surname="Patel" or AdmitDate > 01/01/2006;

SELECT * FROM NewStudent WHERE MiddleName LIKE '%Bhai';

SELECT * FROM NewStudent WHERE FirstName LIKE 'M%' AND MiddleName LIKE '%ant%';

SELECT * FROM NewStudent WHERE Surname LIKE"__c%";

SELECT CONCAT(FirstName," ", SUBSTRING(MiddleName, 1, 1),'.'," ",Surname) AS FullNames FROM NewStudent;

SELECT FirstName,LENGTH(FirstName) as FirstNameLength FROM NewStudent;

UPDATE NewStudent SET FirstName=CONCATE(FirstName,"bhai") WHERE Gender="Male" AND FirstName=(SELECT FirstName FROM NewStudent WHERE FirstName not like '%bhai');

SELECT CONCATE("Mr.",FristName) FROM NewStudent WHERE Gender="Male";

SELECT FirstName FROM NewStudent WHERE FirstName="Mira";
