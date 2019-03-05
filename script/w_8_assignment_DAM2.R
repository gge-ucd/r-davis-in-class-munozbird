library(tidyverse)
library(lubridate)

#### PART I ----

am_riv <- read_csv("https://gge-ucd.github.io/R-DAVIS/data/2015_NFA_solinst_08_05.csv", skip = 13)

# 1. Make a datetime column by using paste to combine the date and time columns; remember to convert it to a datetime!

am_riv$datetime <- paste(am_riv$Date, " ", am_riv$Time, sep = "") #Combine date and time columns

glimpse(am_riv) #Check datetime data type, shows up as character

am_riv$datetime <- ymd_hms(am_riv$datetime)  # Lubridate function to convert datetime data type to dttm


# 2. Calculate the weekly mean, max, and min water temperatures and plot as a point plot (all on the same graph)

am_riv$week <- week(am_riv$datetime) #create week column

View(am_riv)

am_riv_week <- am_riv %>%
  group_by(week) %>% 
  summarize(mean_week = mean(Temperature), min_week = min(Temperature), max_week = max(Temperature))

glimpse(am_riv_week)

# Plotting

am_riv_week %>% 
  ggplot()+
  geom_point(aes(x=week, y = mean_week), color = "blue")+
  geom_point(aes(x=week, y = min_week), color = "red")+
  geom_point(aes(x=week, y = max_week), color= "green")+
  xlab("Week Number")+ ylab("Temperature")+
  theme_bw()

# 3. Calculate the hourly mean Level for April through June and make a line plot (y axis should be the hourly mean level, x axis should be datetime)

am_riv$hourly <- hour(am_riv$datetime)
am_riv$month <- month(am_riv$datetime)

am_riv_hr <- am_riv %>%
  filter(month==4 | month == 5 | month == 6) %>% 
  group_by(hourly, month, datetime) %>% 
  summarize(mean_level =mean(Level))

am_riv_hr %>% 
  ggplot()+
  geom_line(aes(x=datetime, y=mean_level), color = "blue")+
  ylim(1.1,1.9)+
  theme_bw()


####Part 2 ----

# Use the mloa_2001 data set. Remember to remove the NAs (-99 and -999) and to create a datetime column (we did this in class).

load("data/mauna_loa_met_2001_minute.rda")

#making datetime column 
mloa_2001$datetime <- paste(mloa_2001$year, "-", mloa_2001$month, "-", mloa_2001$day, " ", mloa_2001$hour24, ":", mloa_2001$min)

glimpse(mloa_2001)

mloa_2001$datetime<- ymd_hm(mloa_2001$datetime)  #datetime format

#Remove NAs
mloa2 <- mloa_2001 %>% 
  filter(rel_humid != -99, rel_humid != -999) %>% 
  filter(temp_C_2m != -99, temp_C_2m != -999) %>% 
  filter(windSpeed_m_s!= -99, windSpeed_m_s != -999)

# Then, write a function called plot_temp that returns a graph of the temp_C_2m for a single month. The x-axis of the graph should be pulled from a datetime column (so if your data set does not already have a datetime column, you’ll need to create one!)

plot_temp <- function(monthinput, dat = mloa2){
  df <- filter(dat, month == monthinput)
  plot <- df %>% 
    ggplot()+ geom_line(aes(x=datetime, y = temp_C_2m), color = "blue")+
    theme_bw()
  return(plot)
}

#testing the function, should get a plot for just March temperatures 
plot_temp(3)


