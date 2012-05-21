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
,ot as
(
select  
  cast(datepart(yy,sl.DateOffMarket) as varchar(4))+'Q'+cast(DATEPART(Q,sl.DateOffMarket) as varchar(1)) as QuarterOff
  ,(
    case sl.RateBasisID
    when 2 then coalesce(RateLow,(RateLow+RateHigh)*0.5,RateHigh)
    when 1 then coalesce(RateLow,RateHigh)*12
    end
  ) as AskingRate  	  
  ,TDim.TimeDimID
  ,(
    case AF.BldgClassCode
    when 'A' then '1_ClassA'
    when 'B' then '2_ClassB'
    when 'C' then '3_ClassC'
    else '0_Unknown'
    end
  ) as BldgClass  
  ,ad.Latitude
  ,ad.Longitude
  ,pprgeo.CBSAID  
  ,sl.PropertyID
  ,p.PropertyTypeID
  ,sl.OffMarketReasonID
  ,sm.SubmarketName
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
--inner join [Enterprise].[dbo].[FloorName] fn
--  on pf.FloorNameID=fn.FloorNameID
--left join listage
--  on sl.SpaceForLeaseID=listage.SpaceForLeaseID
inner join [Enterprise].[dbo].[Submarket] sm
  on p.PrimarySubmarketID=sm.SubMarketID
--inner join [Enterprise].[dbo].[Submarket_CRM3_5] smcrm
--  on sm.SubMarketName=smcrm.SubmarketName
inner join [EnterpriseAnalytic].[dbo].[TimeDim] TDim
  on cast(datepart(yy,sl.DateOffMarket) as varchar(4))=TDim.Yr 
	and cast(DATEPART(Q,sl.DateOffMarket) as varchar(1))=TDim.Qtr
	and TDim.QuarterEndDate=TDim.TimeDimDate
left join [EnterpriseAnalytic].[dbo].[AnalyticFact] AF
  on AF.PropertyID=p.PropertyID and AF.TimeDimID=TDim.TimeDimID
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
  --and pprgeo.CBSAID=14460
  and sl.SpaceTypeID in (1,2)
  --and p.PropertyTypeID=5
  and sm.SubmarketName is not null
)
select 
	ot.PropertyID
  ,PropertyTypeID
  ,CBSAID
	,QuarterOff
	,AVG(AskingRate) as AskingRate
	,BldgClass
	,Latitude
	,Longitude
	,SubmarketName
from ot
group by CBSAID,QuarterOff,PropertyID,PropertyTypeID,BldgClass,Latitude,Longitude,SubmarketName
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
