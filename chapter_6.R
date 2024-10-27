library(chillR)
Winters_hours_gaps
Winters_hours_gaps[1,1]
Winters_hours_gaps[,1]
Winters_hours_gaps[1,"Temp"]
Winters_hours_gaps$Hour[5]

a <- c(1,2,3,4,5,6)

hourtemps <- Winters_hours_gaps[, c("Year",
                                    "Month",
                                    "Day",
                                    "Hour",
                                    "Temp")]

hourtemps<-Winters_hours_gaps[,c("Year","Month","Day","Hour","Temp")]

hourtemps

4 > 0
4 < 7.2
4 == 5
4 >= 4

a <- 5
a > 0

b <- c(-1, 0, 1, 7, 8, 10)

b > 0

hourtemps$Temp > 10

hourtemps[,"Chilling_Hour"] <- hourtemps$Temp > 10
hourtemps

hourtemps[,"Chilling_Hour"] <- hourtemps$Temp > 0 &
  hourtemps$Temp <= 7.2

hourtemps

sum(hourtemps$Chilling_Hour)

sum(hourtemps$Chilling_Hour[10:200])

func1 <- function(x) x+1

func1(5)
func1(b)

func2 <- function(x)
{y <- x + 1
z <- y - 7
return(z)
}

func2(b)

CH <- function(THourly)
{THourly[,"Chilling_Hour"] <- THourly$Temp > 0 &
  THourly$Temp <= 7.2
return(THourly)

}

CH

CH(hourtemps)

CH_sum <- function(THourly)
{THourly[,"Chilling_Hour"] <- THourly$Temp > 0 &
  THourly$Temp <= 7.2
CHs <- sum(THourly$Chilling_Hour)
return(CHs)

}

CH_sum(hourtemps)

which(hourtemps$Year == 2008 &
        hourtemps$Month == 4 &
        hourtemps$Day == 1 &
        hourtemps$Hour == 0
)

startYear <- 2008
startMonth <- 5
startDay <- 1
startHour <- 0

which(hourtemps$Year == startYear &
        hourtemps$Month == startMonth &
        hourtemps$Day == startDay &
        hourtemps$Hour == startHour
)

CH_sum_interval <- function(THourly, 
                            startYear,
                            startMonth,
                            startDay,                   
                            startHour,
                            endYear,
                            endMonth,
                            endDay,                   
                            endHour)
{THourly[,"Chilling_Hour"] <- THourly$Temp > 0 &
  THourly$Temp <= 7.2

Start_row <- which(hourtemps$Year == startYear &
                     hourtemps$Month == startMonth &
                     hourtemps$Day == startDay &
                     hourtemps$Hour == startHour
)
End_row <- which(hourtemps$Year == endYear &
                   hourtemps$Month == endMonth &
                   hourtemps$Day == endDay &
                   hourtemps$Hour == endHour
)

CHs <- sum(THourly$Chilling_Hour[Start_row:End_row])
return(CHs)

}

CH_sum_interval(hourtemps, 2008, 5, 1, 0,
                2008, 5, 31, 0)
CH_sum_interval(hourtemps, 2008, 4, 1, 0,
                2008, 4, 30, 0)

CH_sum_interval(THourly = hourtemps, 
                startYear = 2008,
                startMonth = 4,
                startDay = 1, 
                startHour = 0,
                endYear = 2008,
                endMonth = 4,
                endDay = 30,
                endHour = 0)

CH_date <- function(THourly, 
                    startYEARMODAHO,
                    endYEARMODAHO)
{THourly[,"Chilling_Hour"] <- THourly$Temp > 0 &
  THourly$Temp <= 7.2

startYear <- as.numeric(substr(startYEARMODAHO, 1, 4))
startMonth <- as.numeric(substr(startYEARMODAHO, 5, 6))
startDay <- as.numeric(substr(startYEARMODAHO, 7, 8))
startHour <- as.numeric(substr(startYEARMODAHO, 9, 10))

endYear <- as.numeric(substr(endYEARMODAHO, 1, 4))
endMonth <- as.numeric(substr(endYEARMODAHO, 5, 6))
endDay <- as.numeric(substr(endYEARMODAHO, 7, 8))
endHour <- as.numeric(substr(endYEARMODAHO, 9, 10))


Start_row <- which(hourtemps$Year == startYear &
                     hourtemps$Month == startMonth &
                     hourtemps$Day == startDay &
                     hourtemps$Hour == startHour
)
End_row <- which(hourtemps$Year == endYear &
                   hourtemps$Month == endMonth &
                   hourtemps$Day == endDay &
                   hourtemps$Hour == endHour
)

CHs <- sum(THourly$Chilling_Hour[Start_row:End_row])
return(CHs)

}


CH_date(THourly = hourtemps,
        startYEARMODAHO = 2008040100, 
        endYEARMODAHO = 2008043023)

