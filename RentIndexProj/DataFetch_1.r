#####################################################################
# Function: DataFetch
# Description: Fetch listing data from Costar Database
#
# Developer: Sam He
# Created On: 05/10/2012
# Last Modified: 05/10/2012
# Log:
#   05/10/2012: Re-arrange the codes for easy maintainence
#
#####################################################################
DataFetch=function()
{
  Data=NULL;
    
	if(require(RODBC))
	{
    myconn = "Driver=SQL Server;Server=dcsqlprd208\\genprocess;Database=Enterprise;Trusted_Connection=yes;"  
    mysql = 
"
with listage as
(
  select    
  sl.SpaceForLeaseID
  ,p.PropertyID
  ,max(cast(cast(isNull(EventMonth,1) as varchar) + '/1/' + cast(EventYear as varchar) as datetime)) as LastBuiltOrRenovationDate
  from  [Enterprise].[dbo].[SpaceForLease] sl  
  inner join [Enterprise].[dbo].[Property] p (nolock)
    on sl.PropertyID=p.PropertyID
  inner join [Enterprise].[dbo].[PropertyConstructionEvent] pce (nolock) 
    on p.PropertyID  = pce.PropertyID
  where 
    pce.ConstructionEventTypeID in (2,4) 
    and pce.EventYear >= 1754 
    and sl.DateOnMarket is not null
    and cast(cast(isNull(EventMonth,1) as varchar) + '/1/' + (cast(EventYear as varchar)) as datetime) <= sl.DateOnMarket
  group by sl.SpaceForLeaseID,p.PropertyID	
)
select
  cast(datepart(yy,sl.DateOnMarket) as varchar(4))+'Q'+cast(DATEPART(Q,sl.DateOnMarket) as varchar(1)) as QuarterOn    
  ,cast(datepart(yy,sl.DateOffMarket) as varchar(4))+'Q'+cast(DATEPART(Q,sl.DateOffMarket) as varchar(1)) as QuarterOff
  ,(
    case sl.RateBasisID
    when 2 then coalesce((RateLow+RateHigh)*0.5,RateLow,RateHigh)
    when 1 then coalesce(RateLow,RateHigh)*12
    end
  ) as AskingRate		
  ,(
    case 
    when sl.ServiceTypeID in (13,12,10) then '1_Net'
    when sl.ServiceTypeID in (15,1,4,2,5,6) then '2_Between'
    when sl.ServiceTypeID in (7,8,9) then '3_FullService'
    else '0_Unknown'
    end
  ) as ST
  ,(
    case p.BldgClassCode
    when 'A' then '1_ClassA'
    when 'B' then '2_ClassB'
    when 'C' then '3_ClassC'
    else '0_Unknown'
    end
  ) as BldgClass
  ,fn.FloorAbbreviation
  ,ad.Latitude
  ,ad.Longitude
  ,pprgeo.CBSAID
  ,coalesce((SqftMin+SqftMax)*0.5,SqftMin,SqftMax) as AvgSqft
  ,sl.PropertyID
  ,p.PropertyTypeID
  ,sl.LeaseTermLow
  ,sl.LeaseTermHigh
  ,sl.LeaseTermTypeID
  ,sl.DateOnMarket
  ,sl.DateOffMarket
  ,sl.SpaceTypeID	
  ,sl.SqFtMin
  ,sl.SqFtMax
  ,sl.OffMarketReasonID
  ,listage.LastBuiltOrRenovationDate
  ,DATEDIFF(yy,listage.LastBuiltOrRenovationDate,sl.DateOnMarket) as ListAge
  ,p.NumStoriesAboveGrade as TotalStories
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
left join listage
  on sl.SpaceForLeaseID=listage.SpaceForLeaseID
where 
  ad.CountryCode='USA' 
  and p.CoStarBldgTypeID=1
  and MonetaryUnitID=1
  and sl.RateBasisID in (1,2)
  --and OffMarketReasonID =2
  and sl.IsExecutiveSuiteFlag = 0
  and sl.IsLeaseTermMonthToMonthFlag=0
  and coalesce(RateLow,RateHigh) >0
  and coalesce(SqftMin,SqftMax)>0
"
    channel<-odbcDriverConnect(myconn);
    Data<-sqlQuery(channel,mysql);
    odbcClose( channel);
	}else{
    print("Error while Reading Access Database!");
    break;
  }
	return(Data);
}
