#####################################################################
# Function: Main
# Description: Main Entry of Equal-Weighted Building-Level Rent
#
# Developer: Sam He
# Created On: 05/16/2012
# Last Modified: 05/16/2012
# Log:
#   05/10/2012: Re-arrange the codes for easy maintainence
#
#####################################################################

rm(list=ls())

source("DataFetch_1.R")


CostarCBSA <- as.vector(read.csv("Costar_CBSA_210.csv",sep=",",header=T))

RentEWDataRaw <- DataFetch()

######################################################################
# Parameters Parameters

Ptypes <- c("OFF","RET","IND","APT")
PtypeID <- c(5,6,2,11)

# End of Parameters Definition
######################################################################
t1=Sys.time()
icount <- 0
for (PTID in (1:4))
{
  for (CBSAID in (CostarCBSA$CBSAID))
  {
    icount <- icount+1
    print(paste(sprintf("%i : Estimating Vacant Weighted Building Level Rent for CBSAID(%i)/",icount,CBSAID),Ptypes[PTID]))
        
    TData<-RentEWDataRaw[RentEWDataRaw$CBSAID==CBSAID & RentEWDataRaw$PropertyTypeID==PtypeID[PTID],]
    
    ROutput<-cbind(as.character(TData$QuarterEnd),TData$rent_ew,TData$rent_vw)
    RCBSA<-c('CBSAID',CBSAID,Ptypes[PTID])    
    RCoef<-rbind(RCBSA,ROutput)      
    colnames(RCoef)<-c("Quarters","Rent_EW","Rent_VW")
      write.table(RCoef,paste("./Results/",Ptypes[PTID],'/',as.character(CostarCBSA[CostarCBSA$CBSAID==CBSAID,"GeographyName"]),"_",Ptypes[PTID],"_RentEWBL_",CBSAID,"_2011Q4.csv",sep=""),sep=",",row.names=FALSE)
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
	
	









