setwd("~/Desktop")
appl <- read.csv("~/Desktop/AAPL.csv")
priceb=appl$Adj.Close
priceb <- ts(rev(priceb), frequency=225, start=c(2005,230))
plot.ts(priceb, main="APPL Stock Price")
price4=as.numeric(priceb)
log.rtnb = as.vector(diff(log(price4)))
pricebd <- ts(log.rtnb, frequency=225, start=c(2005,230))
plot.ts(pricebd,main="log returen of AAPL stock Price")

require(forecast)
auto.arima(log.rtnb)
acf(log.rtnb)#####try MA1 OR MA 2
pacf(log.rtnb)
require(TSA)
eacf(log.rtnb)

fit_appl=arima(log.rtnb, order=c(2,0,2));fit_appl###All significant
tsdiag(fit_appl,gof=20)
Box.test(fit_appl$resid, lag = 20, type = "Ljung", fitdf = 2)###P-value=0.2016
Box.test(fit_appl$resid^2, lag = 20, type = "Ljung", fitdf = 2)####ARCH EFFECT

#####TRY t-GARCH 
require(rugarch)
spec7=ugarchspec(variance.model=list(model="fGARCH",submodel="TGARCH",garchOrder=c(1,1)),mean.model=list(armaOrder=c(2,2)),distribution.model="std")
fit7=ugarchfit(log.rtnb,spec=spec7)
show(fit7)
plot(fit7, which=9)
require(rugarch)
spec71=ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(1,1)),mean.model=list(armaOrder=c(2,2)),distribution.model="std")
fit71=ugarchfit(log.rtnb,spec=spec71)
show(fit71)
plot(fit71, which=9)


spec6=ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(1,1)),mean.model=list(armaOrder=c(2,2)),distribution.model="norm")
fit6=ugarchfit(log.rtnb,spec=spec6)
show(fit6)
plot(fit6, which=9)
spec61=ugarchspec(variance.model=list(model="iGARCH", garchOrder=c(1,1)),mean.model=list(armaOrder=c(2,2)),distribution.model="std")
fit61=ugarchfit(log.rtnb,spec=spec61)
show(fit61)
plot(fit71,which = 9)

#####Forecast 
#plot(ugarchforecast(fit71, n.ahead=10))
length(log.rtnb)
m71=ugarchfit(log.rtnb, spec=spec71, out.sample=10)
forecast71=ugarchforecast(m71,data=NULL,n.ahead=10,n.roll=10, out.sample=200)
forecast71
plot(forecast71, which=2)
roll=ugarchroll(spec71, data=log.rtnb, n.ahead=1, forecast.length=50, refit.every=10, refit.window=c("moving"))
plot(roll, which=4)
##VaR
m2=ugarchfit(log.rtnb,spec=spec71)
round(coef(m2),4)
log.rtnb[length(log.rtnb)]
sigma(m2)[length(log.rtnb)]
sigma1=sqrt(0.0477*(0.01612666)^2+0.9271*0.02409727^2);sigma1
dnorm(qnorm(0.95))
VaR1=0+1.645*sigma1;VaR1
ES1=0+(0.1031356/0.05)*sigma1;ES1
