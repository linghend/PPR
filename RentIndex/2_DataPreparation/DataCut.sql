select sm.ResearchMarketID	
	,rm.ResearchMarketName
	--,sm.SubMarketID
	,pst.PropertySubTypeID
	,pst.PropertySubTypeDesc
	,YEAR(sl.DateOffMarket) as LeasedYear
	,COUNT(*) as LeaseCount
	--sl.*	
    --,p.*
    --,ad.* 
    --,ct.CountyName
    --,fcbsa.*
from  [Enterprise].[dbo].[SpaceForLease] sl  
left join [Enterprise].[dbo].[Property] p
	on sl.PropertyID=p.PropertyID
left join [Enterprise].[dbo].[Address] ad
	on p.PrimaryAddressID = ad.AddressID
left join [Enterprise].[dbo].[County] ct
	on ad.CountyID=ct.CountyID
left join AnalyticDev.dbo.Fips_CBSA fcbsa
on ct.FipsCode=fcbsa.FipsCode
left join [Enterprise].[dbo].[Submarket] sm
	on p.PrimarySubmarketID=sm.SubMarketID
left join [Enterprise].[dbo].[ResearchMarket] rm
	on sm.ResearchMarketID=rm.ResearchMarketID
left join [Enterprise].[dbo].[PropertySubType] pst
	on p.PropertySubTypeID=pst.PropertySubTypeID
	and p.PropertyTypeID=pst.PropertyTypeID
where ad.CountryCode='USA' 
	and p.CoStarBldgTypeID=1
	and OffMarketReasonID in (2,3)
	and p.PropertyTypeID=6
	and sm.ResearchMarketId is not null
	and sm.SubMarketID is not null
	and sm.ResearchMarketID is not null
	and pst.PropertySubTypeID is not null
--group by sm.ResearchMarketID,rm.ResearchMarketName,sm.SubMarketID,YEAR(sl.DateOffMarket)
--order by sm.ResearchMarketID,rm.ResearchMarketName,sm.SubMarketID,YEAR(sl.DateOffMarket)
--group by sm.ResearchMarketID,rm.ResearchMarketName,YEAR(sl.DateOffMarket)
--order by sm.ResearchMarketID,rm.ResearchMarketName,YEAR(sl.DateOffMarket)	
group by sm.ResearchMarketID,rm.ResearchMarketName,pst.PropertySubTypeID,pst.PropertySubTypeDesc,YEAR(sl.DateOffMarket)
order by sm.ResearchMarketID,rm.ResearchMarketName,pst.PropertySubTypeID,pst.PropertySubTypeDesc,YEAR(sl.DateOffMarket)	
--group by sm.ResearchMarketID,rm.ResearchMarketName,pst.PropertySubTypeID,pst.PropertySubTypeDesc
--order by sm.ResearchMarketID,rm.ResearchMarketName,pst.PropertySubTypeID,pst.PropertySubTypeDesc
