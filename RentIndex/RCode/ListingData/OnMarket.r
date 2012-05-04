TData5=TData4
TData51=TData41
TData52=TData42

TData5_2003=subset(TData5, (as.character(TData5$QuarterOn)>="2003Q1") & (as.character(TData5$QuarterOn)<="2003Q4"))
TData51_2003=subset(TData51, (as.character(TData51$QuarterOn)>="2003Q1") & (as.character(TData51$QuarterOn)<="2003Q4"))
TData52_2003=subset(TData52, (as.character(TData52$QuarterOn)>="2003Q1") & (as.character(TData52$QuarterOn)<="2003Q4"))

temp=TData5_2003
tempY1=as.integer(substr(as.character(temp$QuarterOn),1,4))
tempY2=as.integer(substr(as.character(temp$QuarterOff),1,4))
tempQ1=as.integer(substr(as.character(temp$QuarterOn),6,6))
tempQ2=as.integer(substr(as.character(temp$QuarterOff),6,6))
Quarters=(tempY2-tempY1)*4+(tempQ2-tempQ1)
TData5_2003$Quarters=Quarters

TData5_2004=subset(TData5, (as.character(TData5$QuarterOn)>="2004Q1") & (as.character(TData5$QuarterOn)<="2004Q4"))
TData51_2004=subset(TData51, (as.character(TData51$QuarterOn)>="2004Q1") & (as.character(TData51$QuarterOn)<="2004Q4"))
TData52_2004=subset(TData52, (as.character(TData52$QuarterOn)>="2004Q1") & (as.character(TData52$QuarterOn)<="2004Q4"))

temp=TData5_2004
tempY1=as.integer(substr(as.character(temp$QuarterOn),1,4))
tempY2=as.integer(substr(as.character(temp$QuarterOff),1,4))
tempQ1=as.integer(substr(as.character(temp$QuarterOn),6,6))
tempQ2=as.integer(substr(as.character(temp$QuarterOff),6,6))
Quarters=(tempY2-tempY1)*4+(tempQ2-tempQ1)
TData5_2004$Quarters=Quarters

TData5_2005=subset(TData5, (as.character(TData5$QuarterOn)>="2005Q1") & (as.character(TData5$QuarterOn)<="2005Q4"))
TData51_2005=subset(TData51, (as.character(TData51$QuarterOn)>="2005Q1") & (as.character(TData51$QuarterOn)<="2005Q4"))
TData52_2005=subset(TData52, (as.character(TData52$QuarterOn)>="2005Q1") & (as.character(TData52$QuarterOn)<="2005Q4"))

temp=TData5_2005
tempY1=as.integer(substr(as.character(temp$QuarterOn),1,4))
tempY2=as.integer(substr(as.character(temp$QuarterOff),1,4))
tempQ1=as.integer(substr(as.character(temp$QuarterOn),6,6))
tempQ2=as.integer(substr(as.character(temp$QuarterOff),6,6))
Quarters=(tempY2-tempY1)*4+(tempQ2-tempQ1)
TData5_2005$Quarters=Quarters

TData5_2006=subset(TData5, (as.character(TData5$QuarterOn)>="2006Q1") & (as.character(TData5$QuarterOn)<="2006Q4"))
TData51_2006=subset(TData51, (as.character(TData51$QuarterOn)>="2006Q1") & (as.character(TData51$QuarterOn)<="2006Q4"))
TData52_2006=subset(TData52, (as.character(TData52$QuarterOn)>="2006Q1") & (as.character(TData52$QuarterOn)<="2006Q4"))


temp=TData5_2006
tempY1=as.integer(substr(as.character(temp$QuarterOn),1,4))
tempY2=as.integer(substr(as.character(temp$QuarterOff),1,4))
tempQ1=as.integer(substr(as.character(temp$QuarterOn),6,6))
tempQ2=as.integer(substr(as.character(temp$QuarterOff),6,6))
Quarters=(tempY2-tempY1)*4+(tempQ2-tempQ1)
TData5_2006$Quarters=Quarters

TData5_2007=subset(TData5, (as.character(TData5$QuarterOn)>="2007Q1") & (as.character(TData5$QuarterOn)<="2007Q4"))
TData51_2007=subset(TData51, (as.character(TData51$QuarterOn)>="2007Q1") & (as.character(TData51$QuarterOn)<="2007Q4"))
TData52_2007=subset(TData52, (as.character(TData52$QuarterOn)>="2007Q1") & (as.character(TData52$QuarterOn)<="2007Q4"))


temp=TData5_2007
tempY1=as.integer(substr(as.character(temp$QuarterOn),1,4))
tempY2=as.integer(substr(as.character(temp$QuarterOff),1,4))
tempQ1=as.integer(substr(as.character(temp$QuarterOn),6,6))
tempQ2=as.integer(substr(as.character(temp$QuarterOff),6,6))
Quarters=(tempY2-tempY1)*4+(tempQ2-tempQ1)
TData5_2007$Quarters=Quarters

TData5_2008=subset(TData5, (as.character(TData5$QuarterOn)>="2008Q1") & (as.character(TData5$QuarterOn)<="2008Q4"))
TData51_2008=subset(TData51, (as.character(TData51$QuarterOn)>="2008Q1") & (as.character(TData51$QuarterOn)<="2008Q4"))
TData52_2008=subset(TData52, (as.character(TData52$QuarterOn)>="2008Q1") & (as.character(TData52$QuarterOn)<="2008Q4"))


temp=TData5_2008
tempY1=as.integer(substr(as.character(temp$QuarterOn),1,4))
tempY2=as.integer(substr(as.character(temp$QuarterOff),1,4))
tempQ1=as.integer(substr(as.character(temp$QuarterOn),6,6))
tempQ2=as.integer(substr(as.character(temp$QuarterOff),6,6))
Quarters=(tempY2-tempY1)*4+(tempQ2-tempQ1)
TData5_2008$Quarters=Quarters

TData5_2009=subset(TData5, (as.character(TData5$QuarterOn)>="2009Q1") & (as.character(TData5$QuarterOn)<="2009Q4"))
TData51_2009=subset(TData51, (as.character(TData51$QuarterOn)>="2009Q1") & (as.character(TData51$QuarterOn)<="2009Q4"))
TData52_2009=subset(TData52, (as.character(TData52$QuarterOn)>="2009Q1") & (as.character(TData52$QuarterOn)<="2009Q4"))

temp=TData5_2009
tempY1=as.integer(substr(as.character(temp$QuarterOn),1,4))
tempY2=as.integer(substr(as.character(temp$QuarterOff),1,4))
tempQ1=as.integer(substr(as.character(temp$QuarterOn),6,6))
tempQ2=as.integer(substr(as.character(temp$QuarterOff),6,6))
Quarters=(tempY2-tempY1)*4+(tempQ2-tempQ1)
TData5_2009$Quarters=Quarters

TData5_2010=subset(TData5, (as.character(TData5$QuarterOn)>="2010Q1") & (as.character(TData5$QuarterOn)<="2010Q4"))
TData51_2010=subset(TData51, (as.character(TData51$QuarterOn)>="2010Q1") & (as.character(TData51$QuarterOn)<="2010Q4"))
TData52_2010=subset(TData52, (as.character(TData52$QuarterOn)>="2010Q1") & (as.character(TData52$QuarterOn)<="2010Q4"))


temp=TData5_2010
tempY1=as.integer(substr(as.character(temp$QuarterOn),1,4))
tempY2=as.integer(substr(as.character(temp$QuarterOff),1,4))
tempQ1=as.integer(substr(as.character(temp$QuarterOn),6,6))
tempQ2=as.integer(substr(as.character(temp$QuarterOff),6,6))
Quarters=(tempY2-tempY1)*4+(tempQ2-tempQ1)
TData5_2010$Quarters=Quarters

TData5_2005_2010=subset(TData5, (as.character(TData5$QuarterOn)>="2005Q1") & (as.character(TData5$QuarterOn)<="2010Q4"))
temp=TData5_2005_2010
tempY1=as.integer(substr(as.character(temp$QuarterOn),1,4))
tempY2=as.integer(substr(as.character(temp$QuarterOff),1,4))
tempQ1=as.integer(substr(as.character(temp$QuarterOn),6,6))
tempQ2=as.integer(substr(as.character(temp$QuarterOff),6,6))
Quarters=(tempY2-tempY1)*4+(tempQ2-tempQ1)
TData5_2005_2010$Quarters=Quarters

TData5_2003_2010=subset(TData5, (as.character(TData5$QuarterOn)>="2003Q1") & (as.character(TData5$QuarterOn)<="2010Q4"))
temp=TData5_2003_2010
tempY1=as.integer(substr(as.character(temp$QuarterOn),1,4))
tempY2=as.integer(substr(as.character(temp$QuarterOff),1,4))
tempQ1=as.integer(substr(as.character(temp$QuarterOn),6,6))
tempQ2=as.integer(substr(as.character(temp$QuarterOff),6,6))
Quarters=(tempY2-tempY1)*4+(tempQ2-tempQ1)
TData5_2003_2010$Quarters=Quarters


maxQ=max(TData5_2003$Quarters,TData5_2004$Quarters,TData5_2005$Quarters,TData5_2006$Quarters,TData5_2007$Quarters,TData5_2008$Quarters,TData5_2009$Quarters,TData5_2010$Quarters,TData5_2005_2010$Quarters)

mytable=matrix(data=rep(0,(maxQ+1)*8),nrow=maxQ+1,ncol=9)
ttable=as.data.frame(table(TData5_2003$Quarters))
mytable[as.integer(as.character(ttable$Var1))+1,1]=ttable$Freq
ttable=as.data.frame(table(TData5_2004$Quarters))
mytable[as.integer(as.character(ttable$Var1))+1,2]=ttable$Freq
ttable=as.data.frame(table(TData5_2005$Quarters))
mytable[as.integer(as.character(ttable$Var1))+1,3]=ttable$Freq
ttable=as.data.frame(table(TData5_2006$Quarters))
mytable[as.integer(as.character(ttable$Var1))+1,4]=ttable$Freq
ttable=as.data.frame(table(TData5_2007$Quarters))
mytable[as.integer(as.character(ttable$Var1))+1,5]=ttable$Freq
ttable=as.data.frame(table(TData5_2008$Quarters))
mytable[as.integer(as.character(ttable$Var1))+1,6]=ttable$Freq
ttable=as.data.frame(table(TData5_2009$Quarters))
mytable[as.integer(as.character(ttable$Var1))+1,7]=ttable$Freq
ttable=as.data.frame(table(TData5_2010$Quarters))
mytable[as.integer(as.character(ttable$Var1))+1,8]=ttable$Freq
ttable=as.data.frame(table(TData5_2005_2010$Quarters))
mytable[as.integer(as.character(ttable$Var1))+1,9]=ttable$Freq

mytable<-as.data.frame(mytable)
names(mytable)=c("Y2003","Y2004","Y2005","Y2006","Y2007","Y2008","Y2009","Y2010","Y2005_2010")

mysum=sapply(mytable,sum) #total records
myquarter=0:maxQ    #quarter vectors
mymeanquarter=sapply(mytable*myquarter,sum)/mysum   #Average quarters to be leased
myprop=sapply(mytable,prop.table)
mycumprop=sapply(as.data.frame(myprop),cumsum)

#layout(matrix(c(1,2),2,1))

plot(myquarter,myprop[,1],'l',col=1,xlim=c(0,34),ylim=c(0,0.25),xlab="Quarters",ylab="Probability to be Leased at Each Quarter")
for (i in 2:4)
{
    lines(myquarter,myprop[,i],col=i)
}
legend("topright",inset=0.05,title="Entry Year of Lists",legend=names(mytable)[1:4],col=1:4,pch=1,text.col=1:4,bty="n")

# plot(myquarter,myprop[,5],'l',col=1,xlim=c(0,34),ylim=c(0,0.25),xlab="Quarters",ylab="Probability to be Leased")
# for (i in 6:8)
# {
#     lines(myquarter,myprop[,i],col=i-4)
# }
# legend("topright",inset=0.05,title="Entry Year of Lists",legend=names(mytable)[5:8],col=1:4,pch=1,text.col=1:4,bty="n")

#--------------------------------------------------------------------------

plot(myquarter,mycumprop[,1],'l',col=1,xlim=c(0,34),ylim=c(0,1),xlab="Quarters",ylab="Probability to be Leased after Quarters")
for (i in 2:4)
{
    lines(myquarter,mycumprop[,i],col=i)
}
legend("bottomright",inset=0.05,title="Entry Year of Lists",legend=names(mytable)[1:4],col=1:4,pch=1,text.col=1:4,bty="n")

# plot(myquarter,mycumprop[,5],'l',col=1,xlim=c(0,34),ylim=c(0,1),xlab="Quarters",ylab="Probability to be Leased")
# for (i in 6:8)
# {
#     lines(myquarter,mycumprop[,i],col=i-4)
# }
# legend("bottomright",inset=0.05,title="Entry Year of Lists",legend=names(mytable)[5:8],col=1:4,pch=1,text.col=1:4,bty="n")

mycounts=as.data.frame(matrix(rep(0,24),3,8))
names(mycounts)=c("Y2003","Y2004","Y2005","Y2006","Y2007","Y2008","Y2009","Y2010")

mycounts[1,]=c(nrow(TData5_2003),nrow(TData5_2004),nrow(TData5_2005),nrow(TData5_2006),nrow(TData5_2007),nrow(TData5_2008),nrow(TData5_2009),nrow(TData5_2010))
mycounts[2,]=c(nrow(TData51_2003),nrow(TData51_2004),nrow(TData51_2005),nrow(TData51_2006),nrow(TData51_2007),nrow(TData51_2008),nrow(TData51_2009),nrow(TData51_2010))
mycounts[3,]=c(nrow(TData52_2003),nrow(TData52_2004),nrow(TData52_2005),nrow(TData52_2006),nrow(TData52_2007),nrow(TData52_2008),nrow(TData52_2009),nrow(TData52_2010))

mycountssum=sapply(mycounts,sum)
mycountsprop=sapply(mycounts,prop.table)

mystdquarter=mymeanquarter
for (i in 1:9)
{
    mystdquarter[i]=sqrt(sum((myquarter-mymeanquarter[i])^2*myprop[,i]))
}

mystdprop=myprop
for (i in 1:9)
{
    mystdprop[,i]=(myquarter-mymeanquarter[i])/mystdquarter[i]
}

plot(mystdprop[,1],myprop[,1],'l',col=1,xlim=c(-3,14),ylim=c(0,0.25),xlab="Standardized Quarters",ylab="Probability to be Leased at Standardized Quarters")
for (i in 2:5)
{
    lines(mystdprop[,i],myprop[,i],'l',col=i)
}
legend("topright",inset=0.05,title="Entry Year of Lists",legend=names(mytable)[1:5],col=1:5,pch=1,text.col=1:5,bty="n")

#Plot AskingRate pdf
myfactor=factor(TData4$AskingRate,levels=c(seq(5,100,by=1)))
plot(prop.table(table(myfactor)), xlab="Asking Annual Rent (/sqft)", ylab="Probability")
title("Boston Office Asking Rent pdf")
RL=quantile(TData4$AskingRate,probs=.005)
RH=quantile(TData4$AskingRate,probs=.995)
temp=subset(TData4, (TData4$AskingRate>=RL) & (TData4$AskingRate<=RH))
myfactor1=factor(temp$AskingRate,levels=c(seq(RL,RH,by=1)))
plot(prop.table(table(myfactor1)), xlab="Asking Annual Rent (/sqft)", ylab="Probability")
title("Boston Office Asking Rent pdf (after)")
#End of Plot AskingRate pdf

#Plot AvgSqft pdf
myfactor=factor(TData4$AvgSqft,levels=c(seq(0,20000,by=200)))
plot(prop.table(table(myfactor)), xlab="Average Vacant (sqft)", ylab="Probability")
title("Boston Office Average Vacant pdf")
SL=quantile(TData4$AvgSqft,probs=.05)

temp=subset(TData4, (TData4$AvgSqft>=SL) )
myfactor1=factor(temp$AskingRate,levels=c(seq(RL,RH,by=1)))
plot(prop.table(table(myfactor1)), xlab="Asking Annual Rent (/sqft)", ylab="Probability")
title("Boston Office Asking Rent pdf (after)")
#End of Plot AvgSqft pdf

#Plot Age of List pdf
myfactor2=factor(TData4$ListAge[!is.na(TData4$ListAge)],levels=c(seq(0,200,by=5)))
plot(prop.table(table(myfactor2)),xlab="Age (years)", ylab="Probability")
title("Age pdf for Boston Office Leased Lists")
AH=quantile(TData4$ListAge,probs=.95,na.rm=T)
#End of Plot Age of List pdf

# Age vs AskingRent
agerent=subset(TData5, (TData5$AskingRate>RL) & (TData5$AskingRate<RH))
agerent1=subset(agerent, agerent$AvgSqft>SL)
agerent2=subset(agerent1,(!is.na(agerent1$ListAge)) & (agerent1$ListAge<AH))

AskingRent=agerent2$AskingRate
AgeOfLists=agerent2$ListAge
plot(AgeOfLists,log(AskingRent),xlab="Ages (year)",ylab="log [ Asking Annual Rent (/Sqft) ]")
title("log (Asking Annual Rent ) vs Age of the Property")
