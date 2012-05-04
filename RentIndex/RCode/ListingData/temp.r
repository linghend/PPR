timeRent=subset(TData5, (as.character(TData5$QuarterOn)>="2005Q1") & (as.character(TData5$QuarterOn)<="2010Q4"))

temp=tempRent
tempY1=as.integer(substr(as.character(temp$QuarterOn),1,4))
tempY2=as.integer(substr(as.character(temp$QuarterOff),1,4))
tempQ1=as.integer(substr(as.character(temp$QuarterOn),6,6))
tempQ2=as.integer(substr(as.character(temp$QuarterOff),6,6))
Quarters=(tempY2-tempY1)*4+(tempQ2-tempQ1)
timeRent$Quarters=Quarters

timeRent1=subset(timeRent, timeRent$Quarters<=16)


RL=quantile(timeRent1$AskingRate,probs=.005)
RH=quantile(timeRent1$AskingRate,probs=.995)
SL=quantile(timeRent1$AvgSqft,probs=.05)

timeRent2=subset(timeRent1, (timeRent1$AskingRate>RL) & (timeRent1$AskingRate<RH))

timeRent3=subset(timeRent2, timeRent2$AvgSqft>SL)
timeRent3$DaysOnMarket=difftime(as.Date(timeRent3$DateOffMarket),as.Date(timeRent3$DateOnMarket))

mylm=lm(log(AskingRate)~DaysOnMarket,data=timeRent3)

plot(timeRent3$DaysOnMarket,log(timeRent3$AskingRate),xlab="Days On Market",ylab="log( Asking Annual Rent )")
title("log of Asking Annual Rent(/sqft) Vs. Days On Market")
lines(timeRent3$DaysOnMarket,mylm$fitted.values,col=2)

AskingRent=timeRent3$AskingRate
QuartersOnMarkets=timeRent3$Quarters

timeRent4=timeRent3[,c("Quarters","AskingRate")]
timeRent4$Quarters=factor(timeRent4$Quarters)

plot(QuartersOnMarkets,log(AskingRent),xlab="Quarters on Market",ylab="log [ Asking Annual Rent (/Sqft) ]")
title("log (Asking Annual Rent ) vs Times on Market")

plot(AskingRent,QuartersOnMarkets,ylab="Quarters on Market",xlab="Asking Annual Rent (/Sqft)")
title("Asking Annual Rent vs Times on Market")

timeRentNew=subset(timeRent3,(timeRent3$ST=="3_FullService") & (timeRent3$BldgClass=="1_ClassA"))

for (i in 0:16) {print(mean(timeRentNew[timeRentNew$Quarters == i,"AskingRate"]))}

for (i in 0:12) {print(mean(timeRentNew[(timeRentNew$AskingRate > 5*i) & (timeRentNew$AskingRate > 5*(i+1)),"Quarters"]))}

# Asking Rent Vs Time Example
x1=0:15
a=(30-19.6)/225
y1=-a*x*x+30
x2=1:15
y2=rep(19.6,15)
x3=c(1,15)
y3=c(19.6,30)
plot(x1,y1,xlab="Quarters On Market",ylab="Asking Annual Rent (/sqft)")
title("Asking Rent Vs. Times On Market")
lines(x2,y2,'l',col=2)
lines(x3,y3,'l',col=1)
x4=c(0,15)
y4=c(30,30)
x5=c(15,15)
y5=c(19.6,30)
lines(x4,y4,'l',lty=2)
lines(x5,y5,'l',lty=2)
text(13,20,"real curve",col=2)
text(11,29,"expected curve")
points(c(1,15),c(19.6,19.6),pch=19)
points(15,30,pch=1)
text(2,20,"Ex.2: $19.6")
text(2,19.4,"After 1Q Off Market")
text(2,29.6,"EX.1: $30 On Market")
text(13,19.4,"Ex.1: $19.6 Off Market")
# End of Asking Rent Vs Time Example

# Asking Rent Vs Time Example
x=0:15
y1=2.976-(5.94e-5)*x
y=exp(y1)
plot(x,y,xlab="Quarters On Market",ylab="Asking Annual Rent (/sqft)",xlim=c(0,16),ylim=c(19,20),'l',col=2)
title("Average Asking Rent Vs. Times On Market")

# End of Asking Rent Vs Time Example

plot(x,y)