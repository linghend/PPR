DataFilter=function(Data,Ptype,PtypeID)
{	
	if (Ptype=="Office")
    {        
        
    } else 
	{
        
    } else	
	{
        
    }
	
	FilteredData= subset(Data,Data$PtypeID=PtypeID)	
    FilteredData= subset(FilteredData, !is.na(FileteredData$Latitude))
	FilteredData= subset(FilteredData, !is.na(FileteredData$Longitude))
		
	return(FilteredData)
}