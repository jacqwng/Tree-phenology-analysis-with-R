sum_WH <- function(data, 
                   startYEARMODAHO,
                   endYEARMODAHO)
  
{data[,"Warm_Hour"] <- data$Temp > 25

startYear <- as.numeric(substr(startYEARMODAHO, 1, 4))
startMonth <- as.numeric(substr(startYEARMODAHO, 5, 6))
startDay <- as.numeric(substr(startYEARMODAHO, 7, 8))
startHour <- as.numeric(substr(startYEARMODAHO, 9, 10))

endYear <- as.numeric(substr(endYEARMODAHO, 1, 4))
endMonth <- as.numeric(substr(endYEARMODAHO, 5, 6))
endDay <- as.numeric(substr(endYEARMODAHO, 7, 8))
endHour <- as.numeric(substr(endYEARMODAHO, 9, 10))


Start_Date <- which(data$Year == startYear &
                      data$Month == startMonth &
                      data$Day == startDay &
                      data$Hour == startHour)

End_Date <- which(data$Year == endYear &
                    data$Month == endMonth &
                    data$Day == endDay &
                    data$Hour == endHour)

WHs <- sum(data$Warm_Hour[Start_Date:End_Date])
return(WHs)
}


sum_WH(Winters_hours_gaps, 2008073108, 
       2008073112)
