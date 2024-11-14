library(chillR)
library(tidyverse)
library(kableExtra)


#get a list of close-by weather stations
station_list <- handle_gsod(action = "list_stations",
                            location = c(long = -120.5, lat = 46.6),
                            time_interval = c(1973, 2023))


#download data
Yakima_weather <- handle_gsod(action = "download_weather",
                            location = station_list$chillR_code[1],
                            time_interval = c(1973, 2023)) %>%
  handle_gsod()


# check record for missing data
fix_weather(Yakima_weather$`YAKIMA AIR TERMINAL/MCALSR FIELD AP`)$QC


# filling gaps
patch_weather <-
  handle_gsod(action = "download_weather",
              location = as.character(station_list$chillR_code[c(4, 6)]),
              time_interval = c(1973, 2023)) %>%
  handle_gsod()


Yakima_patched <- patch_daily_temperatures(
  weather = Yakima_weather$`YAKIMA AIR TERMINAL/MCALSR FIELD AP`,
  patch_weather = patch_weather)


fix_weather(Yakima_patched)$QC


Yakima_temps <- Yakima_patched$weather





# Aufgabe 1:

scenario_1980 <- temperature_scenario_from_records(weather = Yakima_temps,
                                                   year = 1980)



temps_1980 <- temperature_generation(weather = Yakima_temps,
                                     years = c(1973, 2023),
                                     sim_years = c(2001, 2100),
                                     temperature_scenario = scenario_1980)

scenario_1998 <- temperature_scenario_from_records(weather = Yakima_temps,
                                                   year = 1998)

relative_scenario <- temperature_scenario_baseline_adjustment(
  baseline = scenario_1998,
  temperature_scenario = scenario_1980)

temps_1980 <- temperature_generation(weather = Yakima_temps,
                                   years = c(1973, 2023),
                                   sim_years = c(2001,2100),
                                   temperature_scenario = relative_scenario)

all_past_scenarios <- temperature_scenario_from_records(
  weather = Yakima_temps,
  year = c(1980,
           1990,
           2000,
           2010, 
           2020))

adjusted_scenarios <- temperature_scenario_baseline_adjustment(
  baseline = scenario_1998,
  temperature_scenario = all_past_scenarios)

all_past_scenario_temps <- temperature_generation(
  weather = Yakima_temps,
  years = c(1973, 2023),
  sim_years = c(2001, 2100),
  temperature_scenario = adjusted_scenarios)

save_temperature_scenarios(all_past_scenario_temps, "Yakima", "Yakima_hist_scenarios")

frost_model <- function(x)
  step_model(x,
             data.frame(
               lower = c(-1000,0),
               upper  = c(0,1000),
               weight = c(1,0)))

models <- list(Chill_Portions = Dynamic_Model,
               GDH = GDH,
               Frost_H = frost_model)

chill_hist_scenario_list <- tempResponse_daily_list(all_past_scenario_temps,
                                                    latitude = 46.6,
                                                    Start_JDay = 305,
                                                    End_JDay = 59,
                                                    models = models)

chill_hist_scenario_list <- lapply(chill_hist_scenario_list,
                                   function(x) x %>%
                                     filter(Perc_complete == 100))

save_temperature_scenarios(chill_hist_scenario_list, "Yakima","Yakima_hist_chill_305_59")

scenarios <- names(chill_hist_scenario_list)[1:5]

all_scenarios <- chill_hist_scenario_list[[scenarios[1]]] %>%
  mutate(scenario = as.numeric(scenarios[1]))

for (sc in scenarios[2:5])
  all_scenarios <- all_scenarios %>%
  rbind(chill_hist_scenario_list[[sc]] %>%
          cbind(
            scenario=as.numeric(sc))
  ) %>%
  filter(Perc_complete == 100)

# Let's compute the actual 'observed' chill for comparison
actual_chill <- tempResponse_daily_list(Yakima_temps,
                                        latitude=46.6,
                                        Start_JDay = 305,
                                        End_JDay = 59,
                                        models)[[1]] %>%
  filter(Perc_complete == 100)

ggplot(data = all_scenarios,
       aes(scenario,
           Chill_Portions,
           fill = factor(scenario))) +
  geom_violin() +
  ylab("Chill accumulation (Chill Portions)") +
  xlab("Scenario year") +
  theme_bw(base_size = 15) +
  ylim(c(0,90)) +
  geom_point(data = actual_chill,
             aes(End_year,
                 Chill_Portions,
                 fill = "blue"),
             col = "blue",
             show.legend = FALSE) +
  scale_fill_discrete(name = "Scenario",
                      breaks = unique(all_scenarios$scenario)) 


write.csv(actual_chill,"Yakima/Yakima_observed_chill_305_59.csv", row.names = FALSE)

temperature_means <- 
  data.frame(Year = min(Yakima_temps$Year):max(Yakima_temps$Year),
             Tmin = aggregate(Yakima_temps$Tmin,
                              FUN = "mean",
                              by = list(Yakima_temps$Year))[,2],
             Tmax=aggregate(Yakima_temps$Tmax,
                            FUN = "mean",
                            by = list(Yakima_temps$Year))[,2]) %>%
  mutate(runn_mean_Tmin = runn_mean(Tmin,15),
         runn_mean_Tmax = runn_mean(Tmax,15))


Tmin_regression <- lm(Tmin~Year,
                      temperature_means)

Tmax_regression <- lm(Tmax~Year,
                      temperature_means)

temperature_means <- temperature_means %>%
  mutate(regression_Tmin = Tmin_regression$coefficients[1]+
           Tmin_regression$coefficients[2]*temperature_means$Year,
         regression_Tmax = Tmax_regression$coefficients[1]+
           Tmax_regression$coefficients[2]*temperature_means$Year
  )

ggplot(temperature_means,
       aes(Year,
           Tmin)) + 
  geom_point() + 
  geom_line(data = temperature_means,
            aes(Year,
                runn_mean_Tmin),
            lwd = 2,
            col = "blue") + 
  geom_line(data = temperature_means,
            aes(Year,
                regression_Tmin),
            lwd = 2,
            col = "red") +
  theme_bw(base_size = 15) +
  ylab("Mean monthly minimum temperature (°C)")


ggplot(temperature_means,
       aes(Year,
           Tmax)) + 
  geom_point() + 
  geom_line(data = temperature_means,
            aes(Year,
                runn_mean_Tmax),
            lwd = 2,
            col = "blue") + 
  geom_line(data = temperature_means,
            aes(Year, 
                regression_Tmax),
            lwd = 2,
            col = "red") +
  theme_bw(base_size = 15) +
  ylab("Mean monthly maximum temperature (°C)")

