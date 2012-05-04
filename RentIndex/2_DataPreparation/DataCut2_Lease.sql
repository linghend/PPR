with t1 as
(
	SELECT 
        (case AskingRateBasisDesc
            when 'Yearly' then coalesce((AskingRateLow+AskingRateHigh)*0.5,AskingRateLow,AskingRateHigh)
            when 'Monthly' then coalesce((AskingRateLow+AskingRateHigh)*0.5,AskingRateLow,AskingRateHigh)*12
        end) as AskingRate
        ,Year(LeaseSignDate) as SignYear
        ,cast(datepart(yy,LeaseSignDate) as varchar(4))+'Q'+cast(DATEPART(Q,LeaseSignDate) as varchar(1)) as SignQuarter
        ,(case 
            when servt.ServiceTypeID in (10,12,13,15) then '1_Net'
			when servt.ServiceTypeID in (1,2,3,4,5,6) then '2_Plus'
			when servt.ServiceTypeID in (7,8,9) then '3_FullService'
			else '0_Unknown'
        end) as ST
        ,(case p.BldgClassCode
			when 'A' then '1_ClassA'
			when 'B' then '2_ClassB'
			when 'C' then '3_ClassC'
		end) as BldgClass
	    ,ren.NumStoriesAboveGrade
	    ,Latitude
	    ,Longitude
	    ,CBSAID
	    ,TotalSqFtLeased as AvgSqft
	    ,SpaceUseDesc	    
	    ,ren.PropertyID	    
    FROM [AnalyticDev].[dbo].[PropRenewalDataCut] ren
    left join [Enterprise].[dbo].[Property] p
		on ren.PropertyID=p.PropertyID
    left join [Enterprise].[dbo].[ServiceType] servt
		on ren.ServiceTypeDesc=servt.ServiceTypeDesc
    where p.CoStarBldgTypeID=1			
        and SpaceUseDesc='Office'
        and CBSAID=14460
        and AskingRateBasisDesc is not null
        and coalesce(AskingRateLow,AskingRateHigh) > 0
        --and ren.BldgClassCode in ('A','B','C')
        --and Latitude is not null
        --and Longitude is not null
        --and ren.ServiceTypeDesc is not null
        --and ren.NumStoriesAboveGrade is not null
        and Year(LeaseSignDate) <= 2011
        and Year(LeaseSignDate) >= 2000

)
select
	SignQuarter, 
	--,COUNT(*) as Counts
	--,MIN((LeaseTermHigh-LeaseTermLow)/12.0) as MinLeaseTermDiff
	--,Avg((LeaseTermHigh-LeaseTermLow)/12.0) as AvgLeaseTermDiff
	--,MAX((LeaseTermHigh-LeaseTermLow)/12.0) as MaxLeaseTermDiff
	--,STDEV((LeaseTermHigh-LeaseTermLow)/12.0) as LeaseTermDiff_STDEV
	--,SUM((LeaseTermHigh-LeaseTermLow)/12.0*AvgSqft)/SUM(AvgSqft) as SpaceWeighted_LeaseTermDiff
	sum(AvgSqft)
from t1
--where LeaseTermTypeID in (1,2,3)
group by SignQuarter
order by SignQuarter	
       
        
        