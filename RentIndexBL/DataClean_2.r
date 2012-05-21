#####################################################################
# Function: DataClean
# Description: Apply filters on existing listing data
#
# Developer: Sam He
# Created On: 05/10/2012
# Last Modified: 05/10/2012
# Log:
#   05/10/2012: Re-arrange the codes for easy maintainence
#
#####################################################################

DataClean=function(Data)
{	
  FData=Data
  FData=subset(FData,(!is.na(FData$Latitude)) & (!is.na(FData$Longitude)))
#   FData=subset(FData,grepl("^[0-9]",FData$FloorAbbreviation))
#   FData$FloorAbbreviation=as.integer(as.character(FData$FloorAbbreviation))
  # Sublease is not considered
#   FData=subset(FData, FData$SpaceTypeID!=3)
  # Only consider leased listing data
#   FData=subset(FData, FData$OffMarketReason==2)
#   FData$QuarterOn=factor(FData$QuarterOn)
  FData$QuarterOff=factor(FData$QuarterOff)
  FData=subset(FData,(as.character(FData$QuarterOff)>='2000Q1')&(as.character(FData$QuarterOff)<='2011Q4'))
#   temp=FData
#   tempY1=as.integer(substr(as.character(temp$QuarterOn),1,4))
#   tempY2=as.integer(substr(as.character(temp$QuarterOff),1,4))
#   tempQ1=as.integer(substr(as.character(temp$QuarterOn),6,6))
#   tempQ2=as.integer(substr(as.character(temp$QuarterOff),6,6))
#   Quarters=(tempY2-tempY1)*4+(tempQ2-tempQ1)
#   FData$Quarters=Quarters
  FData=subset(FData, as.character(FData$BldgClass)!='0_Unknown')
#   FData=subset(FData, as.character(FData$ST)!='0_Unknown')
  
  #Winsorization
  #--Winsorization: for AskingRate
  RL=quantile(FData$AskingRate,probs=.005)
  RH=quantile(FData$AskingRate,probs=.995)
  #--Winsorization: for AvgSqft
#   SL=quantile(FData$AvgSqft,probs=.05)
  #--Winsorization: for time on market
#   TH=quantile(FData$Quarters,probs=.95)
  #--Winsorization: for Age
#   AH=quantile(FData$ListAge,probs=.95,na.rm=T)
#   FData=subset(FData, (FData$AskingRate>RL) & (FData$AskingRate<RH) & (FData$AvgSqft>SL) & (FData$Quarters<TH) & (FData$ListAge<AH) )
   FData=subset(FData, (FData$AskingRate>RL) & (FData$AskingRate<RH) )
  
  #End of Winsorization    
  
# 	if (Ptype == "Office")
#   {        
#         
#   }else if (Ptype == "Retail")
# 	{
#     
#   }else if (Ptype == "Industry")
#   {
#     
#   }else if (Ptype == "Apartment")
#   {
#   }else
#   {
#   }      
  FData=FData[,c("PropertyID","QuarterOff","AskingRate","BldgClass","Latitude","Longitude","SubmarketName")]
#   names(FData)[8]<-"Floor"
  
  FData$BldgClass=factor(FData$BldgClass)
#   FData$ST=factor(FData$ST)
  FData$QuarterOff=factor(FData$QuarterOff)
  FData$SubmarketName=factor(FData$SubmarketName)
  
  
  return(FData)
}