/****** Script for SelectTopNRows command from SSMS  ******/
select 
	td.TimeDimDate,
	SUM(cast(coalesce(af.NetRentNumeratorTotal,af.GrossRentNumeratorTotal) as bigint)),
	SUM(cast(coalesce(af.NetRentDenominatorTotal,af.GrossRentDenominatorTotal) as bigint))
from [EnterpriseAnalyticSub].[dbo].[AnalyticFact] af
inner join [EnterpriseAnalyticSub].[dbo].[TimeDim] td
	on af.TimeDimID=td.TimeDimID
where af.PropertyTypeID=5
	and af.ResearchMarketID=4
	and coalesce(af.NetRentNumeratorTotal,af.GrossRentNumeratorTotal) is not null
	and coalesce(af.NetRentDenominatorTotal,af.GrossRentDenominatorTotal) is not null
group by td.TimeDimDate
order by td.TimeDimDate



SELECT top 3 *
from [EnterpriseAnalyticSub].[dbo].[AnalyticFact]
