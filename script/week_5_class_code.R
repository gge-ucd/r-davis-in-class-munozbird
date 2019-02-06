#Week 5 Live Code

# Corresponding lesson for today: https://gge-ucd.github.io/R-DAVIS/lesson_dplyr_ecology.html

#install.packages("tidyverse")

#Tidyverse allows reshaping and manipulation of data

library("tidyverse")

surveys <- readr::read_csv("data/portal_data_joined.csv")
str(surveys)

#tbl is a tidyverse thing. A fancy data frame

####DPLYR FUNCTIONS####

#select is used for columns in a data frame

select(surveys,plot_id,species_id,weight)

#filter is used for selecting rows

filter(surveys, year == 1995)

surveys2 <- filter(surveys, weight<5)

surveys_sml <- select(surveys2, species_id, sex, weight)

#Pipes: %>% Shortcut on a PC is ctrl-shift-M, on a Mac cmd+shift+M; package is part of the tidyverse package
#Takes all code to the left of pipe (%>%) and moves to right

surveys%>%
  filter(weight<5) %>%              # Can think of %>% as 'then.' For example, look at surveys then filter then select
  select(species_id, sex, weight)

#CHALLENGE: Subset surveys to include individuals collected before 1995 and retain only the columns year, sex, and weight
challenge_1 <- surveys %>% 
  filter(year<1995) %>% 
  select(year, sex, weight)

# Can you select before you filter? In many instances, yes

#mutate is used to create new columns

#want to convert grams to kg
surveys <- surveys %>% 
  mutate(weight_kg = weight/1000) %>%   #surveys tibble now has 14 variables instead of 13
  mutate(weight_kg2 = weight_kg*2)  #can have multiple mutate lines

# Filter out NAs from weight column
surveys %>%
  filter(!is.na(weight)) %>%  #! is 'not'. Will get rid of all the rows that have NA
  mutate(weight_kg = weight/1000) %>% 
  summary()




#CHALLENGE 2: Create a new data frame from the surveys data that meets the following criteria: contains only the species_id column and a new column called hindfoot_half containing values that are half the hindfoot_length values. In this hindfoot_half column, there are no NAs and all values are less than 30. Hint: think about how the commands should be ordered to produce this data frame!

challenge_2 <- surveys %>% 
  mutate(hindfoot_half = hindfoot_length/2) %>% 
  select(species_id, hindfoot_half) %>%
  filter(!is.na(hindfoot_half)) %>% 
  filter(hindfoot_half<30)


#Official answer
#surveys_hindfoot_half <- surveys %>%
#  filter(!is.na(hindfoot_length)) %>%
#  mutate(hindfoot_half = hindfoot_length / 2) %>%
#  filter(hindfoot_half < 30) %>%
#  select(species_id, hindfoot_half)



# group_by is good for split-apply-combine; summarize often used after group_by
# we want the mean weight of the males, and the mean weight of the females

surveys %>%
  group_by(sex) %>% #if we ran just this, surveys would look the same to us, but R will show you number of groups (3: Female, Male, NA)
  summarize(mean_weight = mean(weight, na.rm=TRUE)) #removes NAs from the calculations, but not the data frame; if any of the F had unknown weight those would have been removed

#mutate adds new columns to an existing data frame, summarize spits out a totally new data frame
#you can group by multiple columns!


surveys %>%
  group_by(sex) %>%
  mutate(mean_weight = mean(weight, na.rm=TRUE)) %>% View  #View pops up an unassigned data frame; case-sensitive

surveys %>%
  filter(is.na(sex)) %>% View # Way to look at all the NAs in the data frame

surveys %>%
  filter(is.na(sex)) %>% 
  tally()

surveys %>% #tells us where the NAs are in species
  group_by(species) %>% 
  filter(is.na(sex)) %>% 
  tally()

# You can use group_by with multiple columns
# Calculate the mean of each sex, by each species
surveys %>%
  group_by(sex, species_id) %>% 
  summarize(mean_weight = mean(weight, na.rm=TRUE)) %>% View #Get some NaNs ("Not a Number") We need to get rid of the NAs before our calculation. Possibly occurs when a particular combination doesn't exist. For example, if you wanted the mean weight of males of species 2, but you only caught females of species 2, it returns you NaN for males. See next batch of code.

surveys %>%
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarize(mean_weight = mean(weight)) %>% View 

surveys %>%
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarize(mean_weight = mean(weight), min_weight=min(weight)) %>% View 

#tally function: works well for telling us how many of a particular thing; just counts. 

surveys %>% #look at number of each sex
  group_by(sex) %>% 
  tally() %>% View

surveys %>%  #look at number of each sex for each species
  group_by(sex, species_id) %>% 
  tally() %>% View

#tally() is the same as group_by(something) %>% summarize(new_column = n())

###Gathering and spreading###
#Spreading: long-format (many rows) data frame into wide-format (many columns) data frame

#Spread

surveys_gw <- surveys %>%
  filter(!is.na(weight)) %>% 
  group_by(genus, plot_id) %>% 
  summarize(mean_weight = mean(weight)) #this yields a long-format df

# We want each genus to be its own column

surveys_spread <- surveys_gw %>% 
  spread(key=genus, value = mean_weight)

#image for visualization of this concept: https://gge-ucd.github.io/R-DAVIS/img/spread_data_R.png

surveys_gw %>% 
  spread(genus, mean_weight, fill=0) %>% View #shortcut, don't have to put in key or value; fill=0 replaces all NAs with zeros

#Gathering: Going to use a lot less because it is rare to get wide-format data. Requires a few more things. Useful for translating field datasheets into R-friendlier version
#recreate surveys_gw from the spread we made

surveys_gather <- surveys_spread %>% 
  gather(key = genus, value = mean_weight, -plot_id) %>%  #Use all the columns except plot ID to fill the key variable; NAs are back. Fill does not hold.
View

#image for visualization of this concept: https://gge-ucd.github.io/R-DAVIS/img/gather_data_R.png

#Nalina Nan is buddy