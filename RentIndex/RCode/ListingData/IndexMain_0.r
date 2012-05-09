rm(list=ls())

setwd("C:\\SamHe\\git\\PPR\\RentIndex\\RCode\\ListingData")

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


RDataxy=coordinates(cbind(RData$Longitude,RData$Latitude))
RDatanb <- dnearneigh(RDataxy, 0,1,longlat = TRUE)
RDatanbd <- nbdists(RDatanb, coords,longlat=T)
RData_inv<-lapply(RDatanbd,function(x) (1/(x+1)))
RData_res<-resid(resultLT5)

RDatalw_W=nb2listw(RDatanb, style="W",zero.policy=TRUE)
RDatalw_B=nb2listw(RDatanb, style="B",zero.policy=TRUE)
RDatalw_C=nb2listw(RDatanb, style="C",zero.policy=TRUE)
RDatalw_S=nb2listw(RDatanb, style="S",zero.policy=TRUE)
RDatalw_W_inv<-nb2listw(RDatanb, style="W",zero.policy=TRUE,glist=RData_inv)

moran_RData<-moran.test(log(RData$AskingRate),listw=RDatalw_W,zero.policy=TRUE,randomisation=FALSE,alternative="two.sided")
moran_RDatalm_W<-lm.morantest(resultLT5,listw=RDatalw_W,zero.policy=TRUE,alternative="two.sided")
moran_RData_W<-moran.test(RData_res,listw=RDatalw_W,zero.policy=TRUE,alternative="two.sided")
moran_RData_W<-moran.test(RData_res,listw=RDatalw_W,zero.policy=TRUE,alternative="two.sided",rank=TRUE)
set.seed(1234)
moran_RData_W_mc<-moran.mc(RData_res,listw=RDatalw_W,zero.policy=TRUE,alternative="greater",nsim=999)
moran_RData_W_cor8<-sp.correlogram(neighbours=RDatanb,var=RData_res,order=3,method="I",style="W",randomisation=FALSE,zero.policy=TRUE)
moran_RData_W_corD<-correlog(RDataxy,RData_res,method="Moran")

moran_RDatalm_B<-lm.morantest(resultLT5,listw=RDatalw_B,zero.policy=TRUE,alternative="two.sided")
moran_RDatalm_C<-lm.morantest(resultLT5,listw=RDatalw_C,zero.policy=TRUE,alternative="two.sided")
moran_RDatalm_S<-lm.morantest(resultLT5,listw=RDatalw_S,zero.policy=TRUE,alternative="two.sided")
moran_RDatalm_inv<-lm.morantest(resultLT5,listw=RDatalw_W_inv,zero.policy=TRUE,alternative="two.sided")

Result_autolm_W<-spautolm(formuLT5, data=RData,listw=RDatalw_W,zero.policy=TRUE,method="MC")

Result_autolm_W1<-spautolm(formuLT5, data=RData,listw=RDatalw_W,zero.policy=TRUE,method="MC",family="SAR",llprof=100)

Result_autolm_W2<-spautolm(formuLT5, data=RData,listw=RDatalw_W,zero.policy=TRUE,method="Matrix")

RData_res<-lm.LMtests(resultLT5,listw=RDatalw_W,test="all",zero.policy=TRUE)

Result_lag_W<-lagsarlm(formuLT5,data=RData,listw=RDatalw_W,method="MC",zero.policy=TRUE)

RData_W <- as(as_dgRMatrix_listw(RDatalw_W), "CsparseMatrix")
trMatb <- trW(RData_W, type="mult")

Result_mix_W<-sacsarlm(formuLT5,data=RData,listw=RDatalw_W,method="eigen",zero.policy=TRUE)

Result_dubin_W<-lagsarlm(formuLT5,data=RData,listw=RDatalw_W,method="MC",zero.policy=TRUE,type="mixed")

Result_err_W<-errorsarlm(formuLT5,data=RData,listw=RDatalw_W,method="MC",zero.policy=TRUE)

Result_stsls_W<-stsls(formuLT5,data=RData,listw=RDatalw_W,zero.policy=TRUE)

Result_stslsR_W<-stsls(formuLT5,data=RData,listw=RDatalw_W,zero.policy=TRUE,robust=TRUE)

Result_GMerr_W<-GMerrorsar(formuLT5,data=RData,listw=RDatalw_W,zero.policy=TRUE)

Result_GAM<-gam(log(AskingRate) ~ Quarters + ListAge + Floor + as.factor(BldgClass) + as.factor(ST) + QuarterOff + s(x,y),data=RData,weights=AvgSqft)

bwG<-gwr.sel(formuLT5,data=RData,coords=RDataxy,gweight=gwr.Gauss,verbose=FALSE)

#1/range(eigenw(RDatalw_W))



Result_autolmCAR_W<-spautolm(formuLT5, data=RData,listw=RDatalw_W,zero.policy=TRUE,family="CAR",method="MC")

ResultW_autolm_W<-spautolm(formuLT5, data=RData,weights=RData$AvgSqft,listw=RDatalw_W,zero.policy=TRUE,method="MC")

ResultW_autolmCAR_W<-spautolm(formuLT5, data=RData,weights=RData$AvgSqft,listw=RDatalw_W,zero.policy=TRUE,family="CAR",method="MC")

RData_res<-lm.LMtests(resultLT5,listw=RDatalw_W,test="all",zero.policy=TRUE)


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
	
	









