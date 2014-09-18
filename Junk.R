



##clean up sensitivity
## This is a little subjective. The legend ranges from 1 to 5, but the data goes to 5000 and sometimes contains multiple impacts
## I have just taken the first character of each line. This will tend to underestimate  


##Turn sensitivity into character
Breaches$DATA.SENSITIVITY<-as.character(Breaches$DATA.SENSITIVITY)
##create function to select first character
first.char <- function(x){
        substring(x, 1, 1)
}
##apply the function
Breaches$DATA.SENSITIVITY <- lapply(Breaches$DATA.SENSITIVITY, first.char)
##turn back into numeric
Breaches$DATA.SENSITIVITY<-as.numeric(Breaches$DATA.SENSITIVITY)




###Analysis of Hacks
```{r "Get Hacks"}

#Create Hacks File
Hacks<-Breaches[Breaches$METHOD == "hacked" | Breaches$METHOD == "hacked ",]
##aggregate hacks data as a sum
AggHacks <- aggregate(Hacks$NO.OF.RECORDS.STOLEN, list(YEAR = Hacks$YEAR), sum, na.rm=TRUE)

plot(AggHacks, type="o", col=2, lty=1, log="y", ylim=c(10^6, 5*10^8), ylab=expression('Records Hacked'))
title(main = expression("Total Records"))

```