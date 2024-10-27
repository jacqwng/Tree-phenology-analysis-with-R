library(chillR)
Winters_hours_gaps
Winters_hours_gaps[,1] # shows first column
Winters_hours_gaps[1,] # shows first row
Winters_hours_gaps[1, "Temp"] # column can be found by names
Winters_hours_gaps$Year     # $ can show the column names
hourtemps <- Winters_hours_gaps[1,1] # r[1,1] row, column

a <- c(1,2,3) # vector

hourtemps <- Winters_hours_gaps[,c("Year",
                                   "Month",
                                   "Day",
                                   "Hour",
                                   "Temp")] # remove temp_gap column
hourtemps

4 > 0 # 4 is bigger than 0
4 < 7.2 #  4 is smaller than 7.2
4 == 5 # 4 equals 5
4 >= 4 # 4 is equal or bigger than 4

a <- 5 # set 5  as vector a
a > 0

b <- c(-1, 0.1, 10) # vector of different numbers
b > 0

hourtemps$Temp > 10 # column is compared with 10 and shows, if the data is bigger than 10

hourtemps[,"Chilling_Hour"] <-hourtemps$Temp > 0 &  # add a column chilling hours
                              hourtemps$Temp  <= 7.2
hourtemps

sum(hourtemps$Chilling_Hour) # shows/sums up all chilling hours

sum(hourtemps$Chilling_Hour[10:200]) # gives the chilling hours between 10 and 200 



func1 <- function(x) x + 1 # x is input, add 1 to x
func1(5)
func1(b)


func2 <- function(x) 
{y <- x + 1
 z <- y - 7
  return(z)  # return z / give z back
  }  

func2(b)





CH <- function(THourly)
{THourly[,"Chilling_Hour"] <-THourly$Temp > 0 &  
                             THourly$Temp  <= 7.2
return(THourly)
  
}

CH
CH(hourtemps)



# chilling hour summing up function
CH_sum <- function(THourly)
{THourly[,"Chilling_Hour"] <-THourly$Temp > 0 &  
  THourly$Temp  <= 7.2
CHs <- sum(THourly$Chilling_Hour)
return(CHs)

}

CH_sum(hourtemps)

startYear <- 2008
startMonth <- 5
startDay <- 1
startHour <- 0

# shows all numbers where 
which(hourtemps$Year == startYear & 
        hourtemps$Month == startMonth &
        hourtemps$Day == startDay &
        hourtemps$Hour == startHour)









CH_date <- function(THourly, 
                    startYEARMODAHO,
                    endYEARMODAHO)
                   
{THourly[,"Chilling_Hour"] <-THourly$Temp > 0 &  
  THourly$Temp  <= 7.2

startYear <- as.numeric(substr(startYEARMODAHO,1,4)) 
startMonth <- as.numeric(substr(startYEARMODAHO,5,6))
startDay <- as.numeric(substr(startYEARMODAHO,7,8))
startHour <- as.numeric(substr(startYEARMODAHO,9,10))

endYear <- as.numeric(substr(endYEARMODAHO,1,4)) 
endMonth <- as.numeric(substr(endYEARMODAHO,5,6))
endDay <- as.numeric(substr(endYEARMODAHO,7,8))
endHour <- as.numeric(substr(endYEARMODAHO,9,10))



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



CH_date(Thourly = hourtemps,
        startYEARMODAHO = 2008040100,
        endYEARMODAHO = 2008043023)




CH_date <- function(THourly, 
                    startYEARMODAHO,
                    endYEARMODAHO)
{THourly[,"Chilling_Hour"] <- THourly$Temp > 0 & THourly$Temp <= 7.2

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









# calculate warm hours and create a column "warm_hours"
calculate_warm_hours <- function(data)
  {data[, "warm_hours"] <- data$Temp > 25 # make a column "warm hours" and add TRUE or FALSE if the temperature is > 25 °C
  return(data)
}
calculate_warm_hours(hourtemps)

# Funktion zur Berechnung der Anzahl warmer Stunden (> 25°C)

calculate_warm_hours <- function(data)
  {data[, "warm_hours"] <- data$Temp > 25 # make a column "warm hours" and add TRUE or FALSE if the temperature is > 25 °C
  return(data)
}
sum_calculate_warm_hours <- function(data, temp_column) 
  {sum(data$Temp > 25)
}
sum_calculate_warm_hours(hourtemps)


sum_calculate_warm_hours <- function(data, temp_column) 
  {sum(data$Temp[Start_Date:End_Date] > 25)
}


#sum_warm_hours <- function(hourtemps)
#  {hourtemps[, "warm_hours"] <- hourtemps$Temp > 25
  #warm_hours <- sum(hourtemps$warm_hours)
  #return(warm_hours)
#}
#sum_warm_hours(hourtemps)





sum_warm_hours <- function(hourtemps, 
                               Start_year, 
                               Start_month, 
                               Start_day, 
                               Start_hour, 
                               End_year,
                               End_month, 
                               End_day,
                               End_hour
                               )
{hourtemps[, "warm_hours"] <- hourtemps$Temp > 25

Start_Date <- which(hourtemps$Year == Start_year &
                    hourtemps$Month == Start_month &
                    hourtemps$Day == Start_day &
                    hourtemps$Hour == Start_hour)

End_Date <- which(hourtemps$Year == End_year &
                  hourtemps$Month == End_month &
                  hourtemps$Day == End_day &
                  hourtemps$Hour == End_hour)

warm_hours <- sum(hourtemps$warm_hours[Start_Date:End_Date])
return(warm_hours)
}

sum_warm_hours(hourtemps, 2008, 7, 1, 0,
                              2008, 7, 31, 0)

sum_warm_hours(hourtemps, 
                Start_year = 2008,
                Start_month = 7,
                Start_day = 1, 
                Start_hour = 0,
                End_year = 2008,
                End_month = 7,
                End_day = 31,
                End_hour = 0)

