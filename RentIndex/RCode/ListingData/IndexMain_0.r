rm(list=ls())

setwd("C:\\SamHe\\PPR\\RentIndex\\RCode\\ListingData")

library(sp)
library(spdep)
library(gdata)

source("DataAccess_1.R")
#source("DataFilter2.R")
#source("SpatialModel3.R")

CBSAorDivID=as.vector(read.csv("CBSAorDivID.csv",sep=",",header=T))

ListingDataRaw=DataAccess()

######################################################################
# Parameters Definition

StartQ="2000Q1"
EndDate="2011Q4"


Ptypes = c("Office")
PtypeID = c(5)

# End of Parameters Definition
######################################################################

######################################################################
# General Data Cleaning

# End of General Data Cleaning
#####################################################################

#####################################################################
# Statistical Testing
TData=subset(ListingDataRaw,ListingDataRaw$PropertyTypeID==5 & ListingDataRaw$CBSAID==14460)

TData1=subset(TData,(!is.na(TData$Latitude)) & (!is.na(TData$Longitude)))

TData2=subset(TData1,grepl("^[0-9]",TData1$FloorAbbreviation))
TData2$FloorAbbreviation=as.integer(as.character(TData2$FloorAbbreviation))

TData3=subset(TData2,TData2$SpaceTypeID!=3)
#TData3$QuarterOn=factor(TData3$QuarterOn)
#TData3$QuarterOff=factor(TData3$QuarterOff)

TData4=subset(TData3, TData3$OffMarketReason==2)
TData4$QuarterOn=factor(TData4$QuarterOn)
TData4$QuarterOff=factor(TData4$QuarterOff)

TData41=subset(TData3, TData3$OffMarketReason==1)
TData41$QuarterOn=factor(TData41$QuarterOn)
TData41$QuarterOff=factor(TData41$QuarterOff)

TData42=subset(TData3, is.na(TData3$OffMarketReason))


TDataOff=subset(TData4,(as.character(TData4$QuarterOff)>='2000Q1')&(as.character(TData4$QuarterOff)<='2011Q4'))

temp=TDataOff
tempY1=as.integer(substr(as.character(temp$QuarterOn),1,4))
tempY2=as.integer(substr(as.character(temp$QuarterOff),1,4))
tempQ1=as.integer(substr(as.character(temp$QuarterOn),6,6))
tempQ2=as.integer(substr(as.character(temp$QuarterOff),6,6))
Quarters=(tempY2-tempY1)*4+(tempQ2-tempQ1)
TDataOff$Quarters=Quarters

#Winsorization
#--Winsorization: for AskingRate
RL=quantile(TDataOff$AskingRate,probs=.005)
RH=quantile(TDataOff$AskingRate,probs=.995)
#--Winsorization: for AvgSqft
SL=quantile(TDataOff$AvgSqft,probs=.05)
#--Winsorization: for time on market
TH=quantile(TDataOff$Quarters,probs=.95)
#--Winsorization: for Age
AH=quantile(TDataOff$ListAge,probs=.95,na.rm=T)
TDataOff1=subset(TDataOff, (TDataOff$AskingRate>RL) & (TDataOff$AskingRate<RH) & (TDataOff$AvgSqft>SL) & (TDataOff$Quarters<TH) & (TDataOff$ListAge<AH) )
#End of Winsorization

TDataOff2=subset(TDataOff1, as.character(TDataOff1$BldgClass)!='0_Unknown')

#TDataOff4=subset(TDataOff3, as.integer(TDataOff3$SpaceTypeID)!=3)

RData=TDataOff2[,c("AskingRate","QuarterOff","BldgClass","ST","Quarters","ListAge","FloorAbbreviation","AvgSqft","Latitude","Longitude")]
names(RData)[7]<-"Floor"

RData$BldgClass=factor(RData$BldgClass)
RData$ST=factor(RData$ST)
RData$QuarterOff=factor(RData$QuarterOff)


formuL=log(AskingRate)~ListAge+Floor+as.factor(BldgClass)+as.factor(ST)
formuL1=log(AskingRate)~Floor+as.factor(BldgClass)+as.factor(ST)
#formuT=log(AskingRate)~QuarterOff
formuLT=log(AskingRate)~QuarterOff
formuLT1=log(AskingRate)~as.factor(ST)+QuarterOff
formuLT2=log(AskingRate)~as.factor(BldgClass)+as.factor(ST)+QuarterOff
formuLT3=log(AskingRate)~Floor+as.factor(BldgClass)+as.factor(ST)+QuarterOff
formuLT4=log(AskingRate)~ListAge+Floor+as.factor(BldgClass)+as.factor(ST)+QuarterOff
formuLT5=log(AskingRate)~Quarters+ListAge+Floor+as.factor(BldgClass)+as.factor(ST)+QuarterOff


xri=seq(2005.25,2011.75,by=0.25)

resultLT=lm(formuLT,data=RData)
temp=resultLT$coefficients
temp=temp[(length(temp)-25):length(temp)]
ri=c(100,100*exp(temp))

resultLT1=lm(formuLT1,data=RData)
temp=resultLT1$coefficients
temp=temp[(length(temp)-25):length(temp)]
ri1=c(100,100*exp(temp))

resultLT2=lm(formuLT2,data=RData)
temp=resultLT2$coefficients
temp=temp[(length(temp)-25):length(temp)]
ri2=c(100,100*exp(temp))

resultLT3=lm(formuLT3,data=RData)
temp=resultLT3$coefficients
temp=temp[(length(temp)-25):length(temp)]
ri3=c(100,100*exp(temp))

resultLT4=lm(formuLT4,data=RData)
temp=resultLT4$coefficients
temp=temp[(length(temp)-25):length(temp)]
ri4=c(100,100*exp(temp))

resultLT5=lm(formuLT5,data=RData)
temp=resultLT5$coefficients
temp=temp[(length(temp)-25):length(temp)]
ri5=c(100,100*exp(temp))

temp=SACMix2$coefficients
temp=temp[(length(temp)-25):length(temp)]
ri6=c(100,100*exp(temp))


formuLL=log(AskingRate)~ST*BldgClass
formuLLT=log(AskingRate)~ST*BldgClass+QuarterOff

resultL=lm(formuL,data=RData)
resultL1=lm(formuL1,data=RData)
#resultT=lm(formuT,data=RData)
resultLT=lm(formuLT,data=RData)
resultLT1=lm(formuLT1,data=RData)

temp=resultLT$coefficients
temp=temp[(length(temp)-25):length(temp)]
ri=c(100,100*exp(temp))
temp1=resultLT1$coefficients
temp1=temp1[(length(temp1)-25):length(temp1)]
ri1=c(100,100*exp(temp1))
xri=seq(2005.25,2011.75,by=0.25)

temp1=resultLT1$coefficients
temp1=temp1[(length(temp1)-25):length(temp1)]
ri1=c(100,100*exp(temp1))
xri=seq(2005.25,2011.75,by=0.25)
# End of Statistical Testing
####################################################################

#plot control variable choice
layout(matrix(c(1,2,3,4,5,6),2,3,byrow=T))

plot(xri,ri,'l',ylim=c(80,120))
lines(xri,ri1,'l',col=2)
title("formula0 vs formula1")

plot(xri,ri1,'l',ylim=c(80,120))
lines(xri,ri2,'l',col=2)
title("formula1 vs formula2")

plot(xri,ri2,'l',ylim=c(80,120))
lines(xri,ri3,'l',col=2)
title("formula2 vs formula3")

plot(xri,ri3,'l',ylim=c(80,120))
lines(xri,ri4,'l',col=2)
title("formula3 vs formula4")

plot(xri,ri4,'l',ylim=c(80,120))
lines(xri,ri5,'l',col=2)
title("formula4 vs formula5")

plot(xri,ri,'l',ylim=c(80,120))
lines(xri,ri1,'l',col=2)
lines(xri,ri2,'l',col=3)
lines(xri,ri3,'l',col=4)
lines(xri,ri4,'l',col=5)
lines(xri,ri5,'l',col=6)
title("all formula")


#end of plot control variable choice

t1=Sys.time()
BestModelResult=NULL
#for (i in 1:4)
#{
    i=1
    Ptype=Ptypes[i]
    PtypeID=PtypeID[i]

    CoefList=NULL
    Ptype=Ptypes[i]
    ListingData=DataFilter(ListingDataRaw,Ptype,PtypeID)    
    
    #for (j in 1:nrow(CBSAorDivID))
    #{        
        #id= CBSAorDivID[j,]
        id=14460
        print(id)
        
#ModelResult = calculateHPIModelPropType(PriceData,StartDate,EndDate,EndQ,Ptype,id)
        coeffs=NULL

        #formula <- as.formula("log(AskingRate)~NumStoriesAboveGrade+as.factor(ST)+as.factor(BldgClass)+as.factor(SignQuarter)")

        #LeaseData=subset(LeaseDataRaw, CBSAID == id)
        formula=formuLT5
        LeaseData=RData
        ModelResult=NULL
        if (nrow(LeaseData)>10)
        {
            ModelResult=SpatialModel(LeaseData, formula,maxrange=1)
            if (!is.null(ModelResult))
            {
                coeffs=ModelResult$CoefList
                range=ModelResult$OptRange
                coeffs1=rbind(id,range,coeffs)
                rownames(coeffs1)=c('CBSAID','OptRange',rownames(coeffs))
                CoefList=cbind(CoefList,coeffs1)  
                BestModelResult=ModelResult$ModelResult
            } else 
            {
                cat('Error in CBSAID:', id , '.')
            }
        }
    
    #}   
write.table(CoefList,paste(PtypesShort[i],"_ListingRentIndex_",BegYear,"_11Q4.csv",sep=""),sep=",")    
#}
t2=Sys.time()
t3=difftime(t2,t1,units='mins')
print("Time Escaped:")
print(t3)

GetIndex=function(resultcoeff)
{  
  temp=resultcoeff[(length(resultcoeff)-25):length(resultcoeff)]
  ri=c(100,100*exp(temp)) 
  names(ri)[1]="QuarterOff2005Q2"
  return(ri)
}
	
	








