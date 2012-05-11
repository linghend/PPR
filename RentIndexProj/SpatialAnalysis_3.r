SpatialModel=function(LeaseData, formula,maxrange)
{
    #
    maxrange=1
    range=maxrange
    sweight=LeaseData$AvgSqft
    #
    #LeaseData$SignQuarter=relevel (LeaseData$SignQuarter, ref="2005Q2")
    LeaseData$QuarterOff=relevel (LeaseData$QuarterOff, ref="2005Q2")
    xy<-cbind(LeaseData$Longitude,LeaseData$Latitude)
    coords <- coordinates(xy)
    xy.sp <- SpatialPoints(xy)
    
    best.LL<-Inf
    best.ModelResult<-NULL
    found <- FALSE
    for (range in 1:maxrange)
    {
        nb <- dnearneigh(coords, 0,range,longlat = TRUE)
        nbd <- nbdists(nb, coords,longlat=T)
        inverse<-lapply(nbd,function(x) (1/(x+1)))
        #qinverse<-lapply(nbd,function(x) (1/(x*x)))
        #wlinear<-lapply(nbd,function(x) (maxrange-x))
        #listw1=nb2listw(nb, style="W",zero.policy=TRUE,glist=wlinear)
        listw2=nb2listw(nb, style="W",zero.policy=TRUE,glist=inverse)
        #listw3=nb2listw(nb, style="W",zero.policy=TRUE,glist=qinverse)
        rm(nb,nbd,inverse)
        if (nrow(LeaseData)<=5000)
        {
            SACMix2<-sacsarlm(formula,data=LeaseData, listw=listw2, method="Matrix", zero.policy=TRUE)
        } else
        {
            #Error Model
            #SACError1<-errorsarlm(formula,data=LeaseData, listw=listw1, method="MC", zero.policy=TRUE)
            SACError2<-errorsarlm(formula,data=LeaseData, listw=listw2, method="MC", zero.policy=TRUE)
            #SACError3<-errorsarlm(formula,data=LeaseData, listw=listw3, method="MC", zero.policy=TRUE)
            #Lag Model
            #SACLag1<-lagsarlm(formula,data=LeaseData, listw=listw1, method="MC",type="mixed", zero.policy=TRUE)
            SACLag2<-lagsarlm(formula,data=LeaseData, listw=listw2, method="MC", zero.policy=TRUE)
            #SACLag3<-lagsarlm(formula,data=LeaseData, listw=listw3, method="MC", zero.policy=TRUE)
            #Mixed Model
            #SACMix1<-sacsarlm(formula,data=LeaseData, listw=listw1, method="MC", zero.policy=TRUE)
            SACMix2<-sacsarlm(formula,data=LeaseData, listw=listw2, method="MC", zero.policy=TRUE)
            #SACMix3<-sacsarlm(formula,data=LeaseData, listw=listw3, method="MC", zero.policy=TRUE)
            #SACAutoW1<-spautolm(formula,data=LeaseData, listw=listw1,weight=sweight, method="MC", zero.policy=TRUE)
            #SACAutoW2<-spautolm(formula,data=LeaseData, listw=listw2,weight=sweight, method="MC", zero.policy=TRUE)
            #SACAutoW3<-spautolm(formula,data=LeaseData, listw=listw3,weight=sweight, method="MC", zero.policy=TRUE)
            #SACDub1<-lagsarlm(formula,data=LeaseData, listw=listw1, method="MC",type="mixed", zero.policy=TRUE)
            SACDubW2<-lagsarlm(formula,data=LeaseData, listw=listw2, method="MC",type="mixed", zero.policy=TRUE)
            #SACDubW3<-lagsarlm(formula,data=LeaseData, listw=listw3, method="MC",type="mixed", zero.policy=TRUE)
            #RIlm<-lm(formula,data=LeaseData)
            #RIWlm<-lm(formula,data=LeaseData,weight=sweight)            
        }
        fit.LL<-SACMix2$LL
        
        if(fit.LL < best.LL)
        {
            best.LL <- fit.LL
            best.ModelResult<-SACMix2            
            coeffs=as.matrix(coefficients(SACMix2))
            p1 <- residuals(SACMix2)
            best.range=range
            found<-TRUE
            
        }
    }
    if(!found) return(NULL) 
    return(list(CoefList=coeffs, LL=best.LL,OptRange=best.range,Residuals=p1,ModelResult=best.ModelResult))
}

		
		
		

		 