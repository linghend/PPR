#####################################################################
# Function: DataFetch
# Description: Fetch data from Costar Database
#
# Developer: Sam He
# Created On: 05/16/2012
# Last Modified: 05/16/2012
# Log:
#   05/16/2012: Re-arrange the codes for easy maintainence
#
#####################################################################
DataFetch=function()
{
  Data=NULL;
    
	if(require(RODBC))
	{
    myconn = "Driver=SQL Server;Server=dcsqlprd208\\genprocess;Database=EnterpriseAnalytic;Trusted_Connection=yes;"  
    mysql = 
"
with ot as
(
  SELECT
		AF.TimeDimID
		,TimeDimDate
		,AF.PropertyID
		,AF.PropertyTypeID
		,pprgeo.CBSAID
		,cast(datepart(yy,QuarterEndDate) as varchar(4))+'Q'+cast(DATEPART(Q,QuarterEndDate) as varchar(1)) as QuarterEnd
		,NetRentNumeratorTotal
		,NetRentDenominatorTotal	
		,GrossRentNumeratorTotal
		,GrossRentDenominatorTotal
		,GrossRentNumeratorTotal*1.0/GrossRentDenominatorTotal as rent
		,GrossRentDenominatorTotal*1.0 as vacant
	FROM [EnterpriseAnalytic].[dbo].[AnalyticFact] AF
	inner join [EnterpriseAnalytic].[dbo].[TimeDim] TDim
		on TDIM.TimeDimID = AF.TimeDimID
	inner join [Enterprise].[dbo].[Property] p
	  on AF.PropertyID=p.PropertyID
	inner join [Enterprise].[dbo].[Address] ad
	  on p.PrimaryAddressID = ad.AddressID
	inner join [Enterprise].[dbo].[County] ct
	  on ad.CountyID=ct.CountyID
	inner join [AnalyticDev].[dbo].[Fips_CBSA] fcbsa
	  on ct.FipsCode=fcbsa.FipsCode
	inner join [AnalyticDev].[dbo].[PPR_New_CBSA_Geography] pprgeo
	  on fcbsa.CBSAID=pprgeo.CBSAID
	where 
	  ad.CountryCode='USA' 
	  and p.CoStarBldgTypeID=1  
	  and p.PropertyTypeID in (5,6,2,11)
	  and GrossRentDenominatorTotal>0
)
select
	CBSAID
	,PropertyTypeID
	,QuarterEnd
	,AVG(rent) as rent_ew
	,SUM(rent*vacant)/SUM(vacant) as rent_vw
from ot
where rent<=100.0
group by CBSAID,PropertyTypeID,QuarterEnd
order by CBSAID,PropertyTypeID,QuarterEnd
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
