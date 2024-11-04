library(tidyverse)
library(chillR)
dat <- data.frame(a=c(1, 2, 3),
                  b=c(4, 5, 6))
dat

d <- as_tibble(dat)
d

# %>% is a pipe ctrl shft m for %>% 
d %>% sum()

# tidyr functions
KAw <- as_tibble(KA_weather[1:10, ])
KAw

# pivot longer
KAwlong <- KAw %>% pivot_longer(cols=Tmax:Tmin)
KAwlong

# pivot wider
KAwwide <- KAwlong %>% pivot_wider(names_from=name,
                                   values_from=value) 
KAwwide

# select function selects the columns I want to be printed
KAw %>% select(c(Month, Day, Tmax))
KAw %>% select(c(Month:Tmax))
KAw %>% 
  select(c(Month:Tmax)) %>% 
  sum()

# filter shows the rows I want to be printed out
KAw %>% filter(Tmax>10)


# mutate creates a new column
KAw_K <- KAw %>% 
  mutate(Tmax_K = Tmax + 273.15,
         Tmin_K = Tmin + 273.15)
KAw_K


# deletes selected columns with mutate
KAw_K <- KAw %>% 
  mutate(Tmin_K = NULL,
         Tmax_K = NULL)
KAw_K

# arrange (sortiert Reihen)
KAw %>% arrange(Tmax, 
                Tmin)

KA_weather %>% arrange(desc(Tmax), 
                Tmin)



# loops (i is a counter and a variable in a calculation)
for (i in 1:3) 
  print("Hello")

# use the counter to modify a variable
for (i in 1:3) 
{
  if(i == 1) addition <- 1
  addition <- addition + 1
  print(addition)
}

for (i in 1:3) 
{
  if(i == 1) addition <- 1
  addition <- addition + i
  print(addition)
}


names <- c("Jacqueline", "Ola", "Lars")

for (i in 1:3)
{
  print(paste("Hello", names[i]))
}



names <- c("Jacqueline", "Ola", "Lars")

for (name in c("Jacqueline", "Ola", "Lars"))
{
  print(paste("Hello", name))
}




# while loops

cond <- 5

while (cond > 0)
{
  print(cond)
  cond <- cond - 1
}


# apply function 
func <- function(x)
  x + 1

sapply(1:5, func)

# makes it more fast
sapply(1:1000000, func)


sapply(list(1:5), func)


lapply(1:5, func)

lapply(list(1:5), func)


mat <- matrix(c(1,1,1,2,2,2,3,3,3),c(3,3))
mat


apply(mat, MARGIN=1, sum) # adding up all the data in each row
apply(mat, MARGIN=2, sum) # adding up all the data in each column
apply(mat, MARGIN=2, mean)



for(i in 0:23)
  {KAhour <- KAw %>% mutate(Hour = i, 
                            Temp = NA)
  if(i == 6) KAhour <- KAhour %>% mutate(Temp = Tmin)
  if(i == 18) KAhour <- KAhour %>% mutate(Temp = Tmax)
  
  if(i == 0) KAhourly <- KAhour else
    KAhourly <- rbind(KAhourly, KAhour)
  
}
KAhourly <- KAhourly %>% arrange(Year, Month, Day, Hour)

interpolate_gaps(KAhourly$Temp)


KAhourly$Temp <- interpolate_gaps(KAhourly$Temp)$interp
plot(KAhourly$Temp)





