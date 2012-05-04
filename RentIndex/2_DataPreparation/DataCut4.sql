with t1 as
(
	select
		cast(datepart(yy,sl.DateOnMarket) as varchar(4))+'Q'+cast(DATEPART(Q,sl.DateOnMarket) as varchar(1)) as SignQuarterOn	
		,cast(datepart(yy,sl.DateOffMarket) as varchar(4))+'Q'+cast(DATEPART(Q,sl.DateOffMarket) as varchar(1)) as SignQuarterOff
		,(case sl.RateBasisID
			when 2 then coalesce(RateLow,RateHigh)
			when 1 then coalesce(RateLow,RateHigh)*12
		end) as AskingRate		
		,(case 
			when sl.ServiceTypeID in (13,12,10) then '1_Net'
			when sl.ServiceTypeID in (15,1,4,2,5,6) then '2_Between'
			when sl.ServiceTypeID in (7,8,9) then '3_FullService'
			else '0_Unknown'
		end) as ST
		,(case p.BldgClassCode
			when 'A' then '1_ClassA'
			when 'B' then '2_ClassB'
			when 'C' then '3_ClassC'
			else '0_Unknown'
		end) as BldgClass
		--,convert(int,fn.FloorAbbreviation) as NumStoriesAboveGrade
		,fn.FloorAbbreviation
		,ad.Latitude
		,ad.Longitude
		,pprgeo.CBSAID
		,coalesce((SqftMin+SqftMax)*0.5,SqftMin,SqftMax) as AvgSqft
		,sl.PropertyID
		,p.PropertyTypeID
		--,(case
		--	when sl.LeaseTermTypeID=1 then sl.LeaseTermLow*12
		--	when sl.LeaseTermTypeID=2 then sl.LeaseTermLow
		--	when sl.LeaseTermTypeID=3 then sl.LeaseTermLow/30
		--	else null
		--end) as LeaseTermLow
		--,(case
		--	when sl.LeaseTermTypeID=1 then sl.LeaseTermHigh*12
		--	when sl.LeaseTermTypeID=2 then sl.LeaseTermHigh
		--	when sl.LeaseTermTypeID=3 then sl.LeaseTermHigh/30
		--	else null
		--end) as LeaseTermHigh
		,sl.LeaseTermLow
		,sl.LeaseTermHigh
		,sl.LeaseTermTypeID
		,sl.DateOnMarket
		,sl.DateOffMarket
		,sl.SpaceTypeID	
		,sl.SqFtMin
		,sl.SqFtMax
		--,(sl.LeaseTermHigh-sl.LeaseTermLow) as LeaseTermDiff
		--,DATEDIFF(month,sl.DateOnMarket,sl.DateOffMarket) as MonthsOnMarket
	from  [Enterprise].[dbo].[SpaceForLease] sl  
	inner join [Enterprise].[dbo].[Property] p
		on sl.PropertyID=p.PropertyID
	inner join [Enterprise].[dbo].[Address] ad
		on p.PrimaryAddressID = ad.AddressID
	inner join [Enterprise].[dbo].[County] ct
		on ad.CountyID=ct.CountyID
	inner join [Enterprise].[dbo].[ServiceType] servt
		on sl.ServiceTypeID=servt.ServiceTypeID
	inner join [AnalyticDev].[dbo].[Fips_CBSA] fcbsa
		on ct.FipsCode=fcbsa.FipsCode
	inner join [AnalyticDev].[dbo].[PPR_New_CBSA_Geography] pprgeo
		on fcbsa.CBSAID=pprgeo.CBSAID
	inner join [Enterprise].[dbo].[PropertyFloor] pf
		on sl.PropertyFloorID=pf.PropertyFloorID
	inner join [Enterprise].[dbo].[FloorName] fn
		on pf.FloorNameID=fn.FloorNameID
	where 
		ad.CountryCode='USA' 
		and p.CoStarBldgTypeID=1
		and MonetaryUnitID=1
		and sl.RateBasisID in (1,2)
		and OffMarketReasonID =2
		and sl.IsExecutiveSuiteFlag = 0
		and sl.IsLeaseTermMonthToMonthFlag=0
		and coalesce(RateLow,RateHigh) >0
		and coalesce(SqftMin,SqftMax)>0
		
		--and ad.Latitude is not null
		--and ad.Longitude is not null						
		--and p.PropertyTypeID=5
		--and fcbsa.CBSAID=14460						
		--and sl.SpaceTypeID in (1,2)
		--and fn.FloorAbbreviation like '[0-9]%'
		--and Year(sl.DateOffMarket) <= 2011
		--and Year(sl.DateOffMarket) >= 2000	
		--and sl.LeaseTermTypeID is Not null		
)
select
	--SignQuarter, 
	--,COUNT(*) as Counts
	--,MIN((LeaseTermHigh-LeaseTermLow)/12.0) as MinLeaseTermDiff
	--,Avg((LeaseTermHigh-LeaseTermLow)/12.0) as AvgLeaseTermDiff
	--,MAX((LeaseTermHigh-LeaseTermLow)/12.0) as MaxLeaseTermDiff
	--,STDEV((LeaseTermHigh-LeaseTermLow)/12.0) as LeaseTermDiff_STDEV
	--,SUM((LeaseTermHigh-LeaseTermLow)/12.0*AvgSqft)/SUM(AvgSqft) as SpaceWeighted_LeaseTermDiff
	--sum(AvgSqft)
	*
from t1
--where LeaseTermTypeID in (1,2,3)
--group by SignQuarter
--order by SignQuarter	

