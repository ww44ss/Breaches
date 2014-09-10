##Data Breaches Exploratory Analysis

## The data was downloaded from website:
#https://docs.google.com/spreadsheet/ccc?key=0AmenB57kGPGKdHh6eGpTR2lPQl9NZmo3RlVzQ1N2Ymc&single=true&gid=2&range=A1%3AW400#gid=2
require(ggplot2)

Breaches <- read.csv("DataBreachesVisualisationData.csv", header=TRUE)

## DATA CLEANING

        ## delete trailing columns
        Breaches<-Breaches[,1:10]
        
        ##get rid of second desrciptive row
        Breaches<-Breaches[-1,]

        ##get rid of commas
        Breaches$NO.OF.RECORDS.STOLEN <- sub("[,]", "", Breaches$NO.OF.RECORDS.STOLEN)

        #Make the year numeric
                ## first define convenience function 
                as.numeric.factor <- function(x) {as.numeric(levels(x))[x]}

        ##then convert
        Breaches$YEAR<-as.numeric.factor(Breaches$YEAR) + 2004

        ##Make Breaches numeric
        Breaches$NO.OF.RECORDS.STOLEN<-as.numeric(Breaches$NO.OF.RECORDS.STOLEN)

        ##clean up sensitivity
        # this is a little dicey

        Breaches$DATA.SENSITIVITY<-as.character(Breaches$DATA.SENSITIVITY)

        first.char <- function(x){
                substring(x, 1, 1)
        }

        Breaches$DATA.SENSITIVITY <- lapply(Breaches$DATA.SENSITIVITY, first.char)

        Breaches$DATA.SENSITIVITY<-as.numeric(Breaches$DATA.SENSITIVITY)

## FIRST PLOT
AggBreach <- aggregate(Breaches$NO.OF.RECORDS.STOLEN, list(YEAR = Breaches$YEAR), sum, na.rm=TRUE)

plot(AggBreach, type="o", col=2, lty=1, log="y", ylim=c(10^7, 10^9), ylab=expression('Records Breached'))
title(main = expression("Total Records"))

#nls_fit <- nls(x ~ a + b*10^((YEAR-2004)/c), AggBreach, start = list(a = 10^5, b = 10, c = 1))
#lines(AggBreach$YEAR, predict(nls_fit), col = "red")
#plot(Breaches$NO.OF.RECORDS.STOLEN ~ Breaches$YEAR)

## SECOND PLOT
## This just addes up the number of breaches per year

BreachCount <- as.data.frame(table(Breaches$YEAR))
colnames(BreachCount)<-c("YEAR", "Freq")
BreachCount$YEAR<-as.numeric(BreachCount$YEAR)

plot(BreachCount, type="o", col=3, lty=1, ylab=expression('Breaches'))
title(main = expression("Total Breaches"))

## THIRD PLOT

head(Breaches$DATA.SENSITIVITY)

AggSensitivity <- aggregate(Breaches$DATA.SENSITIVITY, list(YEAR = Breaches$YEAR), sum, na.rm=TRUE)
plot(AggSensitivity, type="o", col=2, lty=1, log="y", ylab=expression('Sensitivity Sum'))
title(main = expression("Aggregated Sensitivity"))

##FOURTHPLOT

#Saves a file called Breach Impact
png(filename= "BreachImpact.png", height=300, width=400)

IMPACT <- Breaches$DATA.SENSITIVITY*Breaches$NO.OF.RECORDS.STOLEN/10^7
Breaches<- cbind(Breaches, IMPACT)

AggImpact <- aggregate(Breaches$IMPACT, list(YEAR = Breaches$YEAR), sum, na.rm=TRUE)
plot(AggImpact, type="o", col=2, lty=1, ylab=expression('Impact'), ylim=c(0, 80))
title(main = expression("Aggregated Breach Impact"))
legend("topleft", "Impact", col=2, lty=1,cex=0.8)

dev.off()


##FIFTHPLOT

#lok at Hacks only
Hacks<-Breaches[Breaches$METHOD == "hacked" | Breaches$METHOD == "hacked ",]

AggHacks <- aggregate(Hacks$NO.OF.RECORDS.STOLEN, list(YEAR = Hacks$YEAR), sum, na.rm=TRUE)

plot(AggHacks, type="o", col=2, lty=1, log="y", ylim=c(10^6, 5*10^8), ylab=expression('Records Hacked'))
title(main = expression("Total Records"))

##SIXTH PLOT
##Look at aggregate Impact

AggImpact <- aggregate(Hacks$IMPACT, list(YEAR = Hacks$YEAR), sum, na.rm=TRUE)

a<-qplot(YEAR, IMPACT, data=Breaches, geom=c("point", "smooth"), method="lm", ylim=c(0, NA))
print(a)

##SEVENTH PLOT

AggSeverity <- aggregate(Hacks$DATA.SENSITIVITY, list(YEAR = Hacks$YEAR), sum, na.rm=TRUE)


png(filename= "AttackSeverity.png", height=400, width=600)

barplot(AggSeverity$x, names.arg=AggSeverity$YEAR, col="red", xlab = "YEAR", ylab=expression('Aggregate Severity Index'), ylim=c(0, 35))
title(main = expression("Attack Severity"))
text(1,30,"Intel Analysis", cex=.7, col="black", pos=4)
text(1,28,"Data from: http://www.informationisbeautiful.net/visualizations/worlds-biggest-data-breaches-hacks/", cex=.6, col="black", pos=4)

dev.off()
