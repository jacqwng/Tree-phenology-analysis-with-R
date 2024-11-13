library(chillR)

station_list <- handle_gsod(action = "list_stations",
                            location = c(7.10, 50.73), # first longitude, than latitude
                            time_interval = c(1990,2020))

station_list_Oman <- handle_gsod(action = "list_stations",
                            location = c(long = 57.66, lat = 23.07), # first longitude, than latitude
                            time_interval = c(1990,2020))
station_list_Oman







# Yakima Valley Temperature Data

# Making a list of weather stations near our location:
station_list_Yakima <- handle_gsod(action = "list_stations",
                                   location = c(long = -120.505898, lat = 46.602070), # first longitude, than latitude
                                   time_interval = c(1990, 2020))
station_list_Yakima


# Downloading weather data from a weather station (2nd in list of weather stations)
weather <- handle_gsod(action = "download_weather",
                       location = station_list_Yakima$chillR_code[2],
                       time_interval = c(1990, 2020))

weather[[1]][1:20,]


# Convert temperature (Fahrenheit) into Grad Celsius
cleaned_weather <- handle_gsod(weather) 
cleaned_weather

cleaned_weather[[1]][1:20,]


# Save created data of Yakima temperature data 
dir.create("Yakima")
write.csv(station_list_Yakima,"Yakima/station_list_Yakima.csv", row.names = FALSE)
write.csv(weather[[1]],"Yakima/Yakima_raw_weather.csv", row.names = FALSE)
write.csv(cleaned_weather[[1]],"Yakima/Yakima_chillR_weather.csv", row.names = FALSE)

fix_weather(cleaned_weather[[1]])

