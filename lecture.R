library(chillR)

weather<-fix_weather(KA_weather[which(KA_weather$Year>2006),])
hourtemps<-stack_hourly_temps(weather,latitude=50.4)

Chilling_Hours(HourTemp = hourtemps$hourtemps$Temp,
               summ = FALSE)

Utah_Model
Dynamic_Model

Winters_hours_gaps


Dynamic_Model(Winters_hours_gaps$Temp)

df = data.frame(
  lower = c(-1000, 1, 2, 3, 4, 5, 6),
  upper = c(1, 2, 3, 4, 5, 6, 1000),
  weight = c(0, 1, 2, 3, 2, 1, 0))

step_model(HourTemp = Winters_hours_gaps$Temp, 
           df = df)

customChill <- function(HourTemps) 
  step_model(HourTemps, df)

customChill(Winters_hours_gaps$Temp)

chilling(stack_hourly_temps(
  fix_weather(KA_weather[which(KA_weather$Year > 2006), ]),
                            latitude = 50.4))



output <- tempResponse(make_JDay(Winters_hours_gaps),
                       Start_JDay = 90,
                       End_JDay = 100,
                       models = list(Chill_Portions = Dynamic_Model, 
                                     GDH = GDH,
                                     Harry = customChill))
output

library(chillR)
weather<-fix_weather(KA_weather[which(KA_weather$Year>2006),])

hourtemps<-stack_hourly_temps(weather,latitude=50.4)

df=data.frame(
  lower=c(-1000,1,2,3,4,5,6),
  upper=c(1,2,3,4,5,6,1000),
  weight=c(0,1,2,3,2,1,0))

custom<-function(x) step_model(x,df)

models<-list(Chilling_Hours=Chilling_Hours,Utah_Chill_Units=Utah_Model,Chill_Portions=
               Dynamic_Model,GDH=GDH,custom=custom)

tempResponse(hourtemps,Start_JDay = 305,End_JDay = 60,models)
