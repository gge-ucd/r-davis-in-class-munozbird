# Week 7 Live Code

# Edward Tufte: "The Visual Display of Quantitative Infromation"

# R color chart: http://research.stowers.org/mcm/efg/R/Color/Chart/ColorChart.pdf

# http://colorbrewer2.org/

# ggplot2 visualizations: http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html

# Cowplot allows combination of multiple ggplots

# How to install a package from GitHub, most packages are in CRAN (official package)
install.packages("devtools")

devtools::install_github("thomasp85/patchwork") #(double-colons allows you to pull one function rather than load whole package)


#### Data Import and Export ####

library(tidyverse)

wide_data <- read_csv("data/wide_eg.csv", skip=2) #skip is number of lines you want to skip
wide_data

# In general, csvs are delimited files (some separator between each value in data such as comma)

# RDS and RDS: Ways to store R objects. RDS has to be single R object

# Loaded an RDA file that contained a single R object. RDA files can contain one or more R objects
load("data/mauna_loa_met_2001_minute.rda")

# write wide_data to an RDS file
saveRDS(wide_data, "data/wide_data.rds")

#remove wide_data from environment
rm(wide_data)

readRDS("data/wide_data.rds")

# saveRDS() and readRDS() for .rds files, and we use save() and load() for .rda files

# Other packages: readxl, googlesheets, and googledrive
#readxl:: Allows you to read excel files

#foreign:: reading in of other file types

# Rio package:
install.packages("rio")
library(rio)
#rio::import

#### Working with Dates and Times ####

#Lesson link: https://gge-ucd.github.io/R-DAVIS/lesson_lubridate.html

library(lubridate)

#Three basic tme classes in R: Dates, POSIXct, and POSIXlt
#Dates used for just dates; POSIXct used with times

sample_dates1 <- c("2016-02-01","2016-03-17","2017-01-01")

as.Date(sample_dates1) #looking for data that looks like YYYY MM DD

sample.date2 <- c("02-01-2001","04-04-1991") # dates the American way

as.Date(sample.date2)
# Does not like!

#But can tell our computer how to read our data

as.Date(sample.date2, format="%m-%d-%Y") # Capital Y dictates a year with 4 characters, lowercase y dictates a year with 2 characters
# Or
as.Date(sample.date2, format="%m/%d/%Y") # Capital Y dictates a year with 4 characters, lowercase y dictates a year with 2 characters

# Challenge: What if your dates are listed as follows: Jul 04, 2017?

as.Date("Jul 04, 2017", format="%b%d,%Y") # b is shortened month name, B is full month name

#Date Calculations

dt1 <- as.Date("2017-07-11")

dt2 <- as.Date("2016-04-22")

dt1

print(dt1-dt2) # Time difference of 445 days; sometimes R doesn't calculate if don't wrap around with print

# time difference in weeks

print(difftime(dt1, dt2, units="week"))

# We can create sequences

six.weeks <- seq(dt1,length = 6, by="week") # 6 dates at weekly interval from dt1
six.weeks


#Challenge: Create a sequence of 10 dates starting at dt1 with 2 week intervals

ten.dates <- seq(dt1, length=10, by=14)
ten.dates

#or

challenge <- seq(dt1, length=10, by="2 week")

ymd("2016/01/01")  # Using lubridate

dmy("04.04.91")

mdy("Feb 19, 2005")

dt1-dt2

