/****** Script for SelectTopNRows command from SSMS  ******/
select 
	td.TimeDimDate,
	SUM(cast(coalesce(af.NetRentNumeratorTotal,af.GrossRentNumeratorTotal) as bigint)) as TotalRent,
	SUM(cast(coalesce(af.NetRentDenominatorTotal,af.GrossRentDenominatorTotal) as bigint)) as TotalRentedSpace,
	SUM(cast(coalesce(af.NetRentNumeratorTotal,af.GrossRentNumeratorTotal) as bigint))*1.0/SUM(cast(coalesce(af.NetRentDenominatorTotal,af.GrossRentDenominatorTotal) as bigint)) as SWRent,
	SUM(cast(coalesce(af.NetRentNumeratorDirect,af.GrossRentNumeratorDirect) as bigint)) as DirectRent,
	SUM(cast(coalesce(af.NetRentDenominatorDirect,af.GrossRentDenominatorDirect) as bigint)) as DirectRentedSpace,
	SUM(cast(coalesce(af.NetRentNumeratorDirect,af.GrossRentNumeratorDirect) as bigint))*1.0/SUM(cast(coalesce(af.NetRentDenominatorTotal,af.GrossRentDenominatorTotal) as bigint)) as SWDirectRent	
from [EnterpriseAnalyticSub].[dbo].[AnalyticFact] af
inner join [EnterpriseAnalyticSub].[dbo].[TimeDim] td
	on af.TimeDimID=td.TimeDimID
left join [EnterpriseSub].[dbo].[Property] p
	on af.PropertyID=p.PropertyID
left join [EnterpriseSub].[dbo].[Address] ad
	on p.PrimaryAddressID = ad.AddressID
left join [EnterpriseSub].[dbo].[County] ct
	on ad.CountyID=ct.CountyID
where 
	ad.CountryCode='USA' 
	and p.CoStarBldgTypeID=1
	and af.PropertyTypeID=5
	and ct.CBSAID=14460
	and coalesce(af.NetRentNumeratorTotal,af.GrossRentNumeratorTotal) is not null
	and coalesce(af.NetRentDenominatorTotal,af.GrossRentDenominatorTotal) is not null
	--and Year(td.TimeDimDate)>=2000
	--and YEAR(td.TimeDimDate)<=2011
group by td.TimeDimDate
order by td.TimeDimDate