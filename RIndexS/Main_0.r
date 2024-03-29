#####################################################################
# Function: Main
# Description: Main Entry of Rent Index Project
#
# Developer: Sam He
# Created On: 05/10/2012
# Last Modified: 05/10/2012
# Log:
#   05/10/2012: Re-arrange the codes for easy maintainence
#
#####################################################################

rm(list=ls())
#setwd("C:\\SamHe\\git\\PPR\\RentIndexProjS")

library(sp)
library(spdep)
library(gdata)

source("DataFetch_1.R")
source("DataClean_2.R")
#source("SpatialAnalysis_3.R")

CostarCBSA <- as.vector(read.csv("Costar_CBSA_210.csv",sep=",",header=T))

ListingDataRaw <- DataFetch()

######################################################################
# Parameters Parameters

OffQStart <- tapply(as.character(ListingDataRaw$QuarterOff),ListingDataRaw$CBSAID,min,na.rm=TRUE)
OffQStartMin <- min(OffQStart)
OffQStartMax <- max(OffQStart)

OffQEnd <- tapply(as.character(ListingDataRaw$QuarterOff),ListingDataRaw$CBSAID,max,na.rm=TRUE)
OffQEndMin <- min(OffQEnd)
OffQEndMax <- max(OffQEnd)

CostarCBSA$OffQStart <- OffQStart[as.character(CostarCBSA$CBSAID)]
CostarCBSA$OffQEnd <- OffQEnd[as.character(CostarCBSA$CBSAID)]

# Select Base Quarter for Off Market Time Dummy [OffQStartMax, OffQEndMin]
OffQBase <- OffQStartMax

Ptypes <- c("Office","Retail","Industry","Apartment")
PtypeID <- c(5,6,2,11)

# Define different formula
# formuL=log(AskingRate)~ListAge+Floor+as.factor(BldgClass)+as.factor(ST)
# formuL1=log(AskingRate)~Floor+as.factor(BldgClass)+as.factor(ST)
# formuLT=log(AskingRate)~QuarterOff
# formuLT1=log(AskingRate)~as.factor(ST)+QuarterOff
# formuLT2=log(AskingRate)~as.factor(BldgClass)+as.factor(ST)+QuarterOff
# formuLT3=log(AskingRate)~Floor+as.factor(BldgClass)+as.factor(ST)+QuarterOff
# formuLT4=log(AskingRate)~ListAge+Floor+as.factor(BldgClass)+as.factor(ST)+QuarterOff
#formula=log(AskingRate)~Quarters+ListAge+Floor+BldgClass+ST+AvgSqft+QuarterOff
formula="ListAge + Floor + BldgClass + ST "

# End of Parameters Definition
######################################################################
t1=Sys.time()
icount <- 0
for (PTID in (1:4))
{
  for (CBSAID in (CostarCBSA$CBSAID))
  {
    icount <- icount+1
    print(paste(sprintf("%i : Estimating Rent Index for CBSAID(%i)/",icount,CBSAID),Ptypes[PTID]))
    
    #TData=subset(ListingDataRaw,ListingDataRaw$CBSAID==as.integer(CBSAID))
    TData<-ListingDataRaw[ListingDataRaw$CBSAID==CBSAID & ListingDataRaw$PropertyTypeID==PtypeID[PTID],]
    #TData<-TData[TData$PrimarySubmarketID==675,]
    RData<-DataClean(TData,CBSAID,Ptypes[PTID])
    RData<-subset(RData,as.character(RData$QuarterOn)>="2004Q1")
    
    ROnQStart<-min(as.character(RData$QuarterOn))
    ROnQEnd<-max(as.character(RData$QuarterOn))
    ROffQStart<-min(as.character(RData$QuarterOff))
    ROffQEnd<-max(as.character(RData$QuarterOff))    
        
    tempY1<-as.integer(substr(as.character(ROnQStart),1,4))
    tempY2<-as.integer(substr(as.character(ROffQEnd),1,4))
    tempQ1<-as.integer(substr(as.character(ROnQStart),6,6))
    tempQ2<-as.integer(substr(as.character(ROffQEnd),6,6))
    RQSpan<-(tempY2-tempY1)*4+(tempQ2-tempQ1)+1
    
    RQS<-(4:(4+RQSpan-1))
    RQQ<-RQS%%4
    RQQ[RQQ==0]<-4
    RQY<-floor((RQS-1)/4)+tempY1
    RQT<-paste('Y',paste(RQY,RQQ,sep="Q"),sep="")
    FRQT=paste(RQT,collapse=' + ')
    RData[,RQT]<-0
    
    for (i in 1:nrow(RData))
    {
      RData[i,RQT]<-(substr(RQT,2,7)>=as.character(RData$QuarterOn[i]) & substr(RQT,2,7) <=as.character(RData$QuarterOff[i]))/RData$Quarters[i]
    }    
    
    
    RNQ<-length(levels(RData$QuarterOff))
    RNQMin<-min(table(RData$QuarterOff))
    
    if (nrow(RData)>=1000)
    {
      #RData$QuarterOff=relevel (RData$QuarterOff, ref=OffQBase)
      formulaT=as.formula(paste("log(AskingRate) ~ ",paste(formula,FRQT,sep=' + ')))
      resultlm=lm(formulaT,data=RData)
      RDataxy=coordinates(cbind(RData$Longitude,RData$Latitude))
      RDatanb <- dnearneigh(RDataxy, 0,2,longlat = TRUE)
      RDatanbd <- nbdists(RDatanb, RDataxy,longlat=T)
      RDatanbd_inv<-lapply(RDatanbd,function(x) (1/(1+9*x)))
      #RDatanbd_invS<-lapply(RDatanbd_inv,sum)
      RDatanbd_inv1<-mapply("/",RDatanbd_inv,RData$AvgSqft)
      #RDatanbd <- nbdists(RDatanb, coords,longlat=T)
      #RDatalw_W=nb2listw(RDatanb, style="W",zero.policy=TRUE)
      RDatalw_W=nb2listw(RDatanb, style="W",zero.policy=TRUE,glist=RDatanbd_inv1)
      #moran_RDatalm_W<-lm.morantest(resultlm,listw=RDatalw_W,zero.policy=TRUE,alternative="two.sided")
      Result_err_W<-errorsarlm(formulaT,data=RData,listw=RDatalw_W,method="MC",zero.policy=TRUE)
      
      #Result_err_W<-spautolm(formula,data=RData,listw=RDatalw_W,weights=RData$AvgSqft,method="MC",zero.policy=TRUE)
      
      
      
      RQcoeff<-tail(Result_err_W$coefficient,RNQ-1)
      RQse<-tail(Result_err_W$rest.se,RNQ-1)
      
#       plot(100*exp(RQcoeff),type='l') 
#       lines(100*exp(RQcoeff)*(1+RQse),type='l',lty=2)
#       lines(100*exp(RQcoeff)*(1-RQse),type='l',lty=2)
#       title(sprintf("%s / %s",as.character(CostarCBSA[CostarCBSA$CBSAID==CBSAID,"GeographyName"]),Ptypes[PTID]))
      
      ROutput<-cbind(Result_err_W$coefficients,Result_err_W$rest.se)
      RLambda<-matrix(c(Result_err_W$lambda,Result_err_W$lambda.se),1,2)
      rownames(RLambda)<-c("Lambda")
      RCoef<-rbind(ROutput,RLambda)      
      colnames(RCoef)<-c("value","s.e.")
      write.table(RCoef,paste("./Results/",Ptypes[PTID],'/',as.character(CostarCBSA[CostarCBSA$CBSAID==CBSAID,"GeographyName"]),"_",Ptypes[PTID],"_ListingRentIndex_",ROffQStart,"_2011Q4.csv",sep=""),sep=",")
      
      
    }else{
      print(sprintf("There are only %i quarterly minimum usable records avaiable. Ignore analysis!",RNQMin))
    }
  }
}
print(sprintf("%i jobs are done",icount))
t2=Sys.time()
t3=difftime(t2,t1,units='mins')      
print(t3)


# RDataxy=coordinates(cbind(RData$Longitude,RData$Latitude))
# RDatanb <- dnearneigh(RDataxy, 0,1,longlat = TRUE)
# RDatanbd <- nbdists(RDatanb, coords,longlat=T)
# RData_inv<-lapply(RDatanbd,function(x) (1/(x+1)))
# RData_res<-resid(resultLT5)
# 
# RDatalw_W=nb2listw(RDatanb, style="W",zero.policy=TRUE)
# RDatalw_B=nb2listw(RDatanb, style="B",zero.policy=TRUE)
# RDatalw_C=nb2listw(RDatanb, style="C",zero.policy=TRUE)
# RDatalw_S=nb2listw(RDatanb, style="S",zero.policy=TRUE)
# RDatalw_W_inv<-nb2listw(RDatanb, style="W",zero.policy=TRUE,glist=RData_inv)
# 
# moran_RData<-moran.test(log(RData$AskingRate),listw=RDatalw_W,zero.policy=TRUE,randomisation=FALSE,alternative="two.sided")
# moran_RDatalm_W<-lm.morantest(resultLT5,listw=RDatalw_W,zero.policy=TRUE,alternative="two.sided")
# moran_RData_W<-moran.test(RData_res,listw=RDatalw_W,zero.policy=TRUE,alternative="two.sided")
# moran_RData_W<-moran.test(RData_res,listw=RDatalw_W,zero.policy=TRUE,alternative="two.sided",rank=TRUE)
# set.seed(1234)
# moran_RData_W_mc<-moran.mc(RData_res,listw=RDatalw_W,zero.policy=TRUE,alternative="greater",nsim=999)
# moran_RData_W_cor8<-sp.correlogram(neighbours=RDatanb,var=RData_res,order=3,method="I",style="W",randomisation=FALSE,zero.policy=TRUE)
# moran_RData_W_corD<-correlog(RDataxy,RData_res,method="Moran")
# 
# moran_RDatalm_B<-lm.morantest(resultLT5,listw=RDatalw_B,zero.policy=TRUE,alternative="two.sided")
# moran_RDatalm_C<-lm.morantest(resultLT5,listw=RDatalw_C,zero.policy=TRUE,alternative="two.sided")
# moran_RDatalm_S<-lm.morantest(resultLT5,listw=RDatalw_S,zero.policy=TRUE,alternative="two.sided")
# moran_RDatalm_inv<-lm.morantest(resultLT5,listw=RDatalw_W_inv,zero.policy=TRUE,alternative="two.sided")
# 
# Result_autolm_W<-spautolm(formuLT5, data=RData,listw=RDatalw_W,zero.policy=TRUE,method="MC")
# 
# Result_autolm_W1<-spautolm(formuLT5, data=RData,listw=RDatalw_W,zero.policy=TRUE,method="MC",family="SAR",llprof=100)
# 
# Result_autolm_W2<-spautolm(formuLT5, data=RData,listw=RDatalw_W,zero.policy=TRUE,method="Matrix")
# 
# RData_res<-lm.LMtests(resultLT5,listw=RDatalw_W,test="all",zero.policy=TRUE)
# 
# Result_lag_W<-lagsarlm(formuLT5,data=RData,listw=RDatalw_W,method="MC",zero.policy=TRUE)
# 
# RData_W <- as(as_dgRMatrix_listw(RDatalw_W), "CsparseMatrix")
# trMatb <- trW(RData_W, type="mult")
# 
# Result_mix_W<-sacsarlm(formuLT5,data=RData,listw=RDatalw_W,method="eigen",zero.policy=TRUE)
# 
# Result_dubin_W<-lagsarlm(formuLT5,data=RData,listw=RDatalw_W,method="MC",zero.policy=TRUE,type="mixed")
# 
# Result_err_W<-errorsarlm(formuLT5,data=RData,listw=RDatalw_W,method="MC",zero.policy=TRUE)
# 
# Result_stsls_W<-stsls(formuLT5,data=RData,listw=RDatalw_W,zero.policy=TRUE)
# 
# Result_stslsR_W<-stsls(formuLT5,data=RData,listw=RDatalw_W,zero.policy=TRUE,robust=TRUE)
# 
# Result_GMerr_W<-GMerrorsar(formuLT5,data=RData,listw=RDatalw_W,zero.policy=TRUE)
# 
# Result_GAM<-gam(log(AskingRate) ~ Quarters + ListAge + Floor + as.factor(BldgClass) + as.factor(ST) + QuarterOff + s(x,y),data=RData,weights=AvgSqft)
# 
# bwG<-gwr.sel(formuLT5,data=RData,coords=RDataxy,gweight=gwr.Gauss,verbose=FALSE)
# 
# #1/range(eigenw(RDatalw_W))
# 
# 
# 
# Result_autolmCAR_W<-spautolm(formuLT5, data=RData,listw=RDatalw_W,zero.policy=TRUE,family="CAR",method="MC")
# 
# ResultW_autolm_W<-spautolm(formuLT5, data=RData,weights=RData$AvgSqft,listw=RDatalw_W,zero.policy=TRUE,method="MC")
# 
# ResultW_autolmCAR_W<-spautolm(formuLT5, data=RData,weights=RData$AvgSqft,listw=RDatalw_W,zero.policy=TRUE,family="CAR",method="MC")
# 
# RData_res<-lm.LMtests(resultLT5,listw=RDatalw_W,test="all",zero.policy=TRUE)
# 
# 
# #end of plot control variable choice
# 
# t1=Sys.time()
# BestModelResult=NULL
# #for (i in 1:4)
# #{
#     i=1
#     Ptype=Ptypes[i]
#     PtypeID=PtypeID[i]
# 
#     CoefList=NULL
#     Ptype=Ptypes[i]
#     ListingData=DataFilter(ListingDataRaw,Ptype,PtypeID)    
#     
#     #for (j in 1:nrow(CBSAorDivID))
#     #{        
#         #id= CBSAorDivID[j,]
#         id=14460
#         print(id)
#         
# #ModelResult = calculateHPIModelPropType(PriceData,StartDate,EndDate,EndQ,Ptype,id)
#         coeffs=NULL
# 
#         #formula <- as.formula("log(AskingRate)~NumStoriesAboveGrade+as.factor(ST)+as.factor(BldgClass)+as.factor(SignQuarter)")
# 
#         #LeaseData=subset(LeaseDataRaw, CBSAID == id)
#         formula=formuLT5
#         LeaseData=RData
#         ModelResult=NULL
#         if (nrow(LeaseData)>10)
#         {
#             ModelResult=SpatialModel(LeaseData, formula,maxrange=1)
#             if (!is.null(ModelResult))
#             {
#                 coeffs=ModelResult$CoefList
#                 range=ModelResult$OptRange
#                 coeffs1=rbind(id,range,coeffs)
#                 rownames(coeffs1)=c('CBSAID','OptRange',rownames(coeffs))
#                 CoefList=cbind(CoefList,coeffs1)  
#                 BestModelResult=ModelResult$ModelResult
#             } else 
#             {
#                 cat('Error in CBSAID:', id , '.')
#             }
#         }
#     
#     #}   
# write.table(CoefList,paste(PtypesShort[i],"_ListingRentIndex_",BegYear,"_11Q4.csv",sep=""),sep=",")    
# #}
# t2=Sys.time()
# t3=difftime(t2,t1,units='mins')
# print("Time Escaped:")
# print(t3)

GetIndex=function(resultcoeff)
{  
  temp=resultcoeff[(length(resultcoeff)-25):length(resultcoeff)]
  ri=c(100,100*exp(temp)) 
  names(ri)[1]="QuarterOff2005Q2"
  return(ri)
}
	
	









