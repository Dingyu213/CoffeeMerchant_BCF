-- Script written by Dingyu Liang
-- Script query to select Region for DimRegion
SELECT StateID AS Region_AK,
	ISNULL(dbo.State.StateName, 'N/A') AS State,
	ISNULL(dbo.Consumer.City, 'N/A') AS City

FROM dbo.State
	LEFT OUTER JOIN dbo.Consumer 
		ON dbo.State.StateID = dbo.Consumer.State