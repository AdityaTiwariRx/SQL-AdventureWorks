USE TSQL;
GO

Create table DirectMarketing.TVAdvertisements(
    AdvertisementId int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    AdvertisementName VARCHAR(50) NOT NULL,
    AdvertisementBrand VARCHAR(50) NOT NULL,
    AdvertisementProduct VARCHAR(50) NOT NULL,
    AdvertisementTime VARCHAR(50) NOT NULL,
	AdvertisementSchedule VARCHAR(50) NOT NULL,
	ChannelName VARCHAR(50) NOT NULL,
    Cost MONEY NOT NULL,
	Date DateTimeOffset(7) NOT NULL
    );

DROP TABLE DesignMarketing.TVAdvertisement;

CREATE TABLE Marketing.CampaignResponse(
	CampaignId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    CampaignName VARCHAR(50) NOT NULL,
	CampaignResponse VARCHAR(10) NOT NULL,
    CampaignCity VARCHAR(50) NOT NULL,
	CampaignLead VARCHAR(50) NOT NULL,
	CampaignProfit MONEY NOT NULL
    ConfirmTenant VARCHAR(50) NOT NULL,
	NumberOfResponse INT NOT NULL,
	InterestedTenant VARCHAR(50) NOT NULL,
    MoneyInvested MONEY NOT NULL,
    );

DROP TABLE DesignMarketing.CampaignResponse;

CREATE TABLE DesignMarketing.Competitors(
	 CompetitorId INT PRIMARY KEY IDENTITY (1, 1),
	 CompetitorName VARCHAR(30) NOT NULL,
	 CompetitorLocation VARCHAR(MAX) NOT NULL,
	 CompetitionBrand VARCHAR(50) NOT NULL,
	 DateEntered DATETIME NOT NULL,
	 StrengthOfCompetition VARCHAR(10) NOT NULL,
	 Rating INT NULL,
	 Comments VARCHAR(MAX) NULL
	 );

DROP TABLE DesignMarketing.Competitors;

