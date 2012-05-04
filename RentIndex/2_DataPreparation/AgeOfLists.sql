/****** Script for SelectTopNRows command from SSMS  ******/
select 
	p.PropertyID
	,max(cast(cast(isNull(EventMonth,1) as varchar) + '/1/' + cast(EventYear as varchar) as datetime)) as LastBuiltOrRenovationDate    
from Enterprise.dbo.Property p (nolock) 
join Enterprise.dbo.PropertyConstructionEvent pce (nolock) 
	on p.PropertyID  = pce.PropertyID
where pce.ConstructionEventTypeID in (2,4) 
	and pce.EventYear >= 1754
	--and cast(cast(isNull(EventMonth,1) as varchar) + '/1/' + (cast(EventYear as varchar)) as datetime) <= c.SoldDate and pce.EventYear >= 1754
group by p.PropertyID

--select COUNT (distinct propertyID)
--from Property

