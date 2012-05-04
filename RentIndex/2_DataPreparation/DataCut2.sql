with t1 as
(
	select	
		(case sl.RateBasisID
			when 2 then coalesce((RateLow+RateHigh)*0.5,RateLow,RateHigh)
			when 1 then coalesce((RateLow+RateHigh)*0.5,RateLow,RateHigh)*12
		end) as AskingRate
		,Year(sl.DateOffMarket) as SignYear
		,cast(datepart(yy,sl.DateOffMarket) as varchar(4))+'Q'+cast(DATEPART(Q,sl.DateOffMarket) as varchar(1)) as SignQuarter
		,(case 
			when sl.ServiceTypeID in (10,12,13,15) then '1_Net'
			when sl.ServiceTypeID in (1,2,3,4,5,6) then '2_Plus'
			when sl.ServiceTypeID in (7,8,9) then '3_FullService'
			else '0_Unknown'
		end) as ST
		,(case p.BldgClassCode
			when 'A' then '1_ClassA'
			when 'B' then '2_ClassB'
			when 'C' then '3_ClassC'
		end) as BldgClass
		,convert(int,fn.FloorAbbreviation) as NumStoriesAboveGrade
		,ad.Latitude
		,ad.Longitude
		,fcbsa.CBSAID
		,coalesce((SqftMin+SqftMax)*0.5,SqftMin,SqftMax) as AvgSqft
		,IsExecutiveSuiteFlag
		,IsFullFloorFlag
		,IsLeaseTermMonthToMonthFlag
		,sl.PropertyID
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
		and OffMarketReasonID in (2,3,5)
		and p.PropertyTypeID=5
		and fcbsa.CBSAID=14460
		and sl.RateBasisID in (1,2)
		and coalesce(RateLow,RateHigh) >0
		and coalesce(SqftMin,SqftMax)>0
		and p.BldgClassCode in ('A','B','C')
		and ad.Latitude is not null
		and ad.Longitude is not null
		and fn.FloorAbbreviation like '[0-9]%'
		and ServiceTypeDesc is not null
		and MonetaryUnitID=1
		and Year(sl.DateOffMarket) <= 2011
		and Year(sl.DateOffMarket) >= 2000
)
select *	
from t1
	