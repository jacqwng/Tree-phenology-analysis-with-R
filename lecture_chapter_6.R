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
