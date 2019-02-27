# Week 8 Code

install.packages("tidyverse")

library(lubridate)
library(tidyverse)

load("data/mauna_loa_met_2001_minute.rda")

as.Date("02-01-1998", format = "%m-%d-%Y")

mdy("02-01-1998")

tm1 <- as.POSIXct("2016-07-24 23:55:26 PDT") #Class of date time data (Y-M-D HH:MM:SS)
tm1

tm2 <- as.POSIXct("25072016 08:32:07", format = "%d%m%Y %H:%M:%S")
tm2

tm3 <- as.POSIXct("2010-12-01 11:42:03", tz = "GMT") # Good way to switch the time zone
tm3

#specifying timezone and date format in the same call
tm4 <- as.POSIXct(strptime("2016/04/04 14:47", format = "%Y/%m/%d %H:%M", tz="America/Los_Angeles"))
tm4
tz(tm4)

Sys.timezone() #default timezone on your computer

#Do the same thing with lubridate

ymd_hm("2016/04/04 14:47", tz = "America/Los_Angeles")

ymd_hms("2016-05-04 22:14:11", tz ="GMT")


#Troubleshooting: Diana's Tidyverse would not load
# Tried re-installing Tidyverse, but during attempted load R complained that there was no package 'colorspace'
# We also tried install.packages("tidyverse", dependencies = TRUE) but that also did not work
# Finally did install.packages("colorspace") then loaded Tidyverse and it worked


#### Dataframe with Date-Time Data ----

nfy <- read_csv("data/2015_NFY_solinst.csv")

nfy1 <- read_csv("https://gge-ucd.github.io/R-DAVIS/data/2015_NFY_solinst.csv", skip = 12)

nfy2 <- read_csv("https://gge-ucd.github.io/R-DAVIS/data/2015_NFY_solinst.csv", skip = 12, col_types = "ccidd")

glimpse(nfy2)

#TANGENT
nfy2 <- read_csv("https://gge-ucd.github.io/R-DAVIS/data/2015_NFY_solinst.csv", skip = 12, col_types = Cols(Date = col_date())) #read everything as normal, but just read the column Date as a different thing


nfy2$datetime <- paste(nfy2$Date, " ", nfy2$Time, sep = "")  # sep tells R how to separate your date and time (delimitation). sep ="" means there's a space in between. sep="," puts a comma between your date and time.


glimpse(nfy2)


nfy2$datetime_test <- ymd_hms(nfy2$datetime, tz = "America/Los_Angeles") #Put in date-time format. Resulting glimpse will show <dttm>

glimpse(nfy2)

tz(nfy2$datetime_test)

summary(mloa_2001)

mloa_2001$datetime <- paste(mloa_2001$year, "-", mloa_2001$month, "-", mloa_2001$day, " ", mloa_2001$hour24, ":", mloa_2001$min)

glimpse(mloa_2001)

mloa_2001$datetime <- ymd_hm(mloa_2001$datetime)


#Challenge with dplyr & ggplot
# Step 1: Remove the NA’s (-99 and -999) in rel_humid, temp_C_2m, windSpeed_m_s

mloa2 <- mloa_2001 %>% 
  filter(rel_humid > -99, temp_C_2m > -99, windSpeed_m_s > -99)

summary(mloa2)

#Martha's code:
mloa2 <- mloa_2001 %>% 
  filter(rel_humid != -99, rel_humid != -999) %>% 
  filter(temp_C_2m!= -99, temp_C_2m != -999) %>% 
  filter(windSpeed_m_s!= -99, windSpeed_m_s != -999)


# Step 2: Use dplyr to calculate the mean monthly temperature (temp_C_2m) using the datetime column (HINT: look at lubridate functions like month())


mloa_3 <- mloa2 %>% 
  mutate(which_month = month(datetime, label = TRUE)) %>% 
  group_by(which_month) %>% 
  summarize(avg_temp = mean(temp_C_2m))

glimpse(mloa_3)

#Make a ggplot of the avg monthly temperature

mloa_3 %>% ggplot()+
  geom_point(aes(x=which_month, y = avg_temp), size =3, color = "blue") +
  geom_line(aes(x=which_month, y = avg_temp, group =1))
#Michael is checking this out


#### FUN-CTIONS ----
# Any operation that you want to perform more than once

log(5) # 5 is an argument in the log() function

my_sum <- function(a, b) {   #take a and b, sum them
  the_sum <- a + b
  return(the_sum)
}

# can now use as if it was a log() function
my_sum(3, 7)


my_sum <- function(a=1, b=2) {   #setting default values
  the_sum <- a + b
  return(the_sum)
}

my_sum()   # returns sum of 3

my_sum(a=5, b=8)   # defaults can be over-ridden

#Create a function that converts the temp in K to the temp in C. Hint: subtract 273.15 from Kelvin temp to get Celcius

calc_C <- function (K, b=273.15) {
  celcius <- K - b
  return(celcius)
}

calc_C(600)

list <- c(8,9,130)

calc_C(list)


#### ITERATION ----

x <- 1:10
log(x)

# for loops
# Repeats some bit of code each time with a new input value

for(i in 1:10){           # for each value i in vector 1:10 apply the following fxn
  print(i)
} 

# Doesn't print a vector. Printed each item one at a time
# Have value in Environment that says 10L. 10 is the last value in the loop.

for(i in 1:10){
  print(i)
  print(i^2)
}

letters[1]


# We can use the "i" value as an index
# mtcars is a built-in dataset useful for playing around in R

for(i in 1:10){
  print(letters[i])
  print(mtcars$wt[i])
}


# Make a results vector ahead of time

results <- rep (NA,10)

for (i in 1:10){
  results[i] <- letters[i]
}
results





