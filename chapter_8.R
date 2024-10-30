library(chillR)
library(ggplot2)
library(kableExtra)
# function to show sunrise, sunset and daylength at latitude 51:
daylength(latitude = 51, 
          JDay = 300)

# shows 365 daylength, sunrises and sunsets of the given latitude:
Days <- daylength(latitude = 50.4, JDay = 1:365)
Days

Days_df <-
  data.frame(
    JDay = 1:365,
    Sunrise = Days$Sunrise,
    Sunset = Days$Sunset,
    Daylength = Days$Daylength
  )

plot(Days_df$Sunrise ~ Days_df$JDay)

library(ggplot2)

ggplot(Days_df, 
       aes(JDay, 
           Sunset)) +
  geom_line(lwd = 2, 
            col = "blue", 
            lty = 2)


ggplot(Days_df, 
       aes(JDay, 
           Sunrise)) +
  geom_line(lwd = 2, 
            col = "blue", 
            lty = 2)

ggplot(Days_df, 
       aes(JDay, 
           Daylength)) +
  geom_line(lwd = 2, 
            col = "blue", 
            lty = 2)

library(tidyr)
Days_df

Days_df_longer <- pivot_longer(Days_df,
                        cols = c(Sunrise:Daylength))
Days_df_longer

ggplot(Days_df_longer, aes(JDay, value)) +
  geom_line(lwd = 1.5) +
  facet_grid(cols = vars(name)) +
  ylab("Time of Day / Daylengtj (Hours)") +
  theme_bw(base_size = 10) +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())


KA_weather[1:10,]

KA_hourly <- stack_hourly_temps(KA_weather,
                                latitude = 50.4,
                                keep_sunrise_sunset = TRUE)
KA_hourly

KA_hourly$hourtemps[100:120,]

KA_hourly$hourtemps[, "DATE"] <- 
  ISOdate(
    KA_hourly$hourtemps$Year,
    KA_hourly$hourtemps$Month,
    KA_hourly$hourtemps$Day,
    KA_hourly$hourtemps$Hour
  )

ggplot(KA_hourly$hourtemps[20:100,], 
       aes(DATE, 
           Temp)) +
  geom_line(lwd = 1.5) +
  xlab("Date") +
  ylab("Temperature (°C)") + 
  theme_bw(base_size = 10)


empi_curve <- Empirical_daily_temperature_curve(Winters_hours_gaps)
empi_curve[1:48,]

ggplot(data = empi_curve[1:96,],
       aes(Hour,
           Prediction_coefficient)) +
  geom_line(lwd = 1.3,
            col = "red") +
  facet_grid(rows = vars(Month)) +
  xlab("Hour of the day") +
  ylab("Prediction coefficient") +
  theme_bw(base_size = 20)

coeffs <- Empirical_daily_temperature_curve(Winters_hours_gaps)

day
  