library(chillR)
library(magrittr)
library(tidyverse)
Yakima <- read.csv("Yakima/chillR_weather.csv")
Yakima


is.na(Yakima$Tmin) %>% sum()

Yakima_QC <- fix_weather(Yakima)$QC
Yakima_QC

# wenn man nicht immer library aufrufen möchte geht auch folgendes:
chillR::fix_weather()

# plot missing values
Yakima %>% 
  select(Tmin, Tmax, Prec) %>% 
  naniar::vis_miss()

gap_summary <-Yakima %>% 
  group_by(Year) %>% 
  summarise(n_gap = sum(is.na(Tmin)),
            median_gap_length = get_gap_length(Tmin),
            max_gap_length = get_gap_length(Tmin, usmmary = "max"))




# Assignment 
Bonn <- read.csv("data/Bonn_chillR_weather.csv")

station_list <- handle_gsod(action="list_stations",
                            location=c(7.14,50.9),
                            time_interval=c(1990,2020))

station_list

patch_weather <-
  handle_gsod(action = "download_weather",
              location = as.character(station_list$chillR_code[c(2,5,6)]),
              time_interval = c(1990, 2020)) %>%
  handle_gsod()



#use the function to patch the gaps
#the algorim cycles through the auxiliary stations in the same order as supplied
patched <- patch_daily_temperatures(weather = Bonn,
                                    patch_weather = patch_weather)


patched$statistics[[1]]

patched$statistics[[2]]

patched$statistics[[3]]



# set minimum quality criteria
patched <- patch_daily_temperatures(weather = Bonn,
                                    patch_weather = patch_weather,
                                    max_mean_bias = 1,
                                    max_stdev_bias = 2)

patched$statistics[[1]]

patched$statistics[[2]]

patched$statistics[[3]]


#check where gaps remain
post_patch_stats <- fix_weather(patched)$QC

post_patch_stats


#only one gap remains,
#--> linear interpolation will do not much harm here
Bonn_weather<-fix_weather(patched)




patched_monthly <- patch_daily_temps(weather = Bonn,
                                     patch_weather = patch_weather,
                                     max_mean_bias = 1,
                                     max_stdev_bias = 2,
                                     time_interval = "month")

patched_monthly$statistics$Tmin$NORVENICH

#biases vary on a monthly basis, smaller differences in winter


#we can do also the bias correction every two weeks
patched_2weeks <- patch_daily_temps(weather = Bonn,
                                    patch_weather = patch_weather,
                                    max_mean_bias = 1,
                                    max_stdev_bias = 2,
                                    time_interval = "2 weeks")


Gaps <- sample(seq(1:nrow(Bonn)),
               size = 5000,
               replace = FALSE)

Bonn_gaps <- Bonn %>% mutate(obs_Tmin=Tmin,
                             obs_Tmax=Tmax)
Bonn_gaps$Tmin[Gaps] <- NA
Bonn_gaps$Tmax[Gaps] <- NA

patch_annual <- patch_daily_temps(weather = Bonn_gaps,
                                  patch_weather = patch_weather,
                                  max_mean_bias = 1,
                                  max_stdev_bias = 2,
                                  time_interval = "year")
patch_month <- patch_daily_temps(weather = Bonn_gaps,
                                 patch_weather = patch_weather,
                                 max_mean_bias = 1,
                                 max_stdev_bias = 2,
                                 time_interval = "month")
patch_2weeks <- patch_daily_temps(weather = Bonn_gaps,
                                  patch_weather = patch_weather,
                                  max_mean_bias = 1,
                                  max_stdev_bias = 2,
                                  time_interval = "2 weeks")

Bonn_gaps[,"Tmin_annual"] <- Bonn_gaps$obs_Tmin - patch_annual$weather$Tmin
Bonn_gaps[,"Tmax_annual"] <- Bonn_gaps$obs_Tmax - patch_annual$weather$Tmax
Bonn_gaps[,"Tmin_month"] <- Bonn_gaps$obs_Tmin - patch_month$weather$Tmin
Bonn_gaps[,"Tmax_month"] <- Bonn_gaps$obs_Tmax - patch_month$weather$Tmax
Bonn_gaps[,"Tmin_2weeks"] <- Bonn_gaps$obs_Tmin - patch_2weeks$weather$Tmin
Bonn_gaps[,"Tmax_2weeks"] <- Bonn_gaps$obs_Tmax - patch_2weeks$weather$Tmax

Interval_eval <- Bonn_gaps %>%
  filter(is.na(Tmin)) %>%
  pivot_longer(Tmin_annual:Tmax_2weeks) %>%
  mutate(Type=factor(name,
                     levels = c("Tmin_annual",
                                "Tmin_month",
                                "Tmin_2weeks",
                                "Tmax_annual",
                                "Tmax_month",
                                "Tmax_2weeks")) )



ggplot(Interval_eval,
       aes(Type,value)) +
  geom_violin(draw_quantiles = c(0.25,0.5,0.75)) +
  xlab("Variable and bias evaluation interval") +
  ylab("Prediction error")


error_eval <-
  data.frame(Variable = c(rep("Tmin",3),rep("Tmax",3)),
             Interval = rep(c("Year","Month","Two weeks"),2),
             Error = c(
               mean(abs(Bonn_gaps$Tmin_annual[is.na(Bonn_gaps$Tmin)]),na.rm=TRUE),
               mean(abs(Bonn_gaps$Tmin_month[is.na(Bonn_gaps$Tmin)]),na.rm=TRUE),
               mean(abs(Bonn_gaps$Tmin_2weeks[is.na(Bonn_gaps$Tmin)]),na.rm=TRUE),
               mean(abs(Bonn_gaps$Tmax_annual[is.na(Bonn_gaps$Tmin)]),na.rm=TRUE),
               mean(abs(Bonn_gaps$Tmax_month[is.na(Bonn_gaps$Tmin)]),na.rm=TRUE),
               mean(abs(Bonn_gaps$Tmax_2weeks[is.na(Bonn_gaps$Tmin)]),na.rm=TRUE))
  )


error_eval


monthly_bias_fixed <- fix_weather(patched_monthly)

write.csv(monthly_bias_fixed$weather,
          "data/Bonn_weather.csv")




Winters_hours_gaps[,"DATE"] <- ISOdate(Winters_hours_gaps$Year,
                                       Winters_hours_gaps$Month,
                                       Winters_hours_gaps$Day,
                                       Winters_hours_gaps$Hour)
Winters_hours_gaps[,"interpolated"] <-
  interpolate_gaps(Winters_hours_gaps$Temp_gaps)$interp

ggplot(data = Winters_hours_gaps[50:300,],
       aes(DATE,Temp)) +
  geom_line(lwd = 1.3) +
  ylab("Temperature (°C)") +
  xlab("Date") +
  geom_line(data = Winters_hours_gaps[50:300,],
            aes(DATE,interpolated),
            col = "red",lwd = 1.3) +
  theme_bw(base_size = 10