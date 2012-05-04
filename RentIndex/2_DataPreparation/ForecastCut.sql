/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	quarter
	,rent
	,cbsacode
	,proptype
  FROM [CREForecast].[Forecast].[CDEMetroForecastExport_20120118]
where proptype='OFF'
	and SimulationName='Base Case'
	and cbsacode=31084
	and quarter>='2005Q2'
	and quarter<='2011Q4'