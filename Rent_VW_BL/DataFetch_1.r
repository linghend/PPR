#####################################################################
# Function: DataFetch
# Description: Fetch listing data from Costar Database
#
# Developer: Sam He
# Created On: 05/10/2012
# Last Modified: 05/10/2012
# Log:
#   05/16/2012: Re-arrange the codes for easy maintainence
#
#####################################################################
DataFetch=function()
{
  Data=NULL;
    
	if(require(RODBC))
	{
    myconn = "Driver=SQL Server;Server=PPRDW;Database=CREForecast;Trusted_Connection=yes;"  
    mysql = 
"
SELECT 
  cbsacode
	,quarter
	,SimulationName
	,proptype
	,rent
FROM [CREForecast].[Archive].[CDEMetroForecastExport_20120316] cde
where SimulationName='Base Case'
	and quarter>='2000Q1'
	and quarter<='2011Q4'
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
