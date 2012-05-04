with t1 as
(
	select	
		(case sl.RateBasisID
			when 2 then coalesce((RateLow+RateHigh)*0.5,RateLow,RateHigh)
			when 1 then coalesce((RateLow+RateHigh)*0.5,RateLow,RateHigh)*12
		end) as AskingRate
		,Year(sl.DateOffMarket) as SignYear
		,(case 
			when ServiceTypeDesc like 'Triple%' then 'NNN'
			when ServiceTypeDesc like 'Modified%' then 'Modified'
			when ServiceTypeDesc like 'Plus%' then 'Plus'
			else 'Others'
		end) as ST
		,p.BldgClassCode
		,convert(int,fn.FloorAbbreviation) as NumStoriesAboveGrade
		,ad.Latitude
		,ad.Longitude
		,fcbsa.CBSAID
		,coalesce((SqftMin+SqftMax)*0.5,SqftMin,SqftMax) as AvgSqft	
	from  [Enterprise].[dbo].[SpaceForLease] sl  
	left join [Enterprise].[dbo].[Property] p
		on sl.PropertyID=p.PropertyID
	left join [Enterprise].[dbo].[Address] ad
		on p.PrimaryAddressID = ad.AddressID
	left join [Enterprise].[dbo].[County] ct
		on ad.CountyID=ct.CountyID
	left join AnalyticDev.dbo.Fips_CBSA fcbsa
		on ct.FipsCode=fcbsa.FipsCode
	left join [Enterprise].[dbo].[ServiceType] servt
		on sl.ServiceTypeID=servt.ServiceTypeID
	left join [Enterprise].[dbo].[PropertyFloor] pf
		on sl.PropertyFloorID=pf.PropertyFloorID
	left join [Enterprise].[dbo].[FloorName] fn
		on pf.FloorNameID=fn.FloorNameID
	where ad.CountryCode='USA' 
		and p.CoStarBldgTypeID=1
		and OffMarketReasonID in (2)
		and p.PropertyTypeID=5
		and fcbsa.CBSAID=14460
		and sl.RateBasisID in (1,2)
		and coalesce((RateLow+RateHigh)*0.5,RateLow,RateHigh) >0
		and p.BldgClassCode in ('A','B','C')
		and ad.Latitude is not null
		and ad.Longitude is not null
		and fn.FloorAbbreviation like '[0-9]%'
		and ServiceTypeDesc is not null
		and Year(sl.DateOffMarket) <= 2011
		and Year(sl.DateOffMarket) >= 2000
)
select 
	SignYear
	,AVG(AskingRate) as EW_Rate
	,Sum(AskingRate*AvgSqft)/SUM(AvgSqft)
from t1
group by SignYear
order by SignYear	
	
--select Top 3 *
--from [Enterprise].[dbo].[SpaceForLease] sl  

--select Top 3 
--	*
--from [Enterprise].[dbo].[Property] p

