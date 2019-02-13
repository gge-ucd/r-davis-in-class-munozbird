#Week 6 Live Code

#Load packages
library(tidyverse)

surveys <- read_csv("data/portal_data_joined.csv")

# ULTIMATE GOAL: Plot how species abundances have changed through time

# Take all NAs out of the weight, hindfoot_length, and sex column

surveys_complete <- surveys %>% 
  filter(!is.na(weight), !is.na(hindfoot_length), !is.na(sex))

# Remove the species that have less than 50 observations

species_counts <- surveys_complete %>% 
  group_by(species_id) %>% 
  tally() %>%         # When you tally, a new column "n" is created
  filter(n>= 50)

View(species_counts)

#We only want the species listed in species_counts in our new data frame

surveys_complete <- surveys_complete %>% 
  filter(species_id %in% species_counts$species_id)


#Writing your dataframe to .csv

write_csv(surveys_complete, path="data_output/surveys_complete.csv")

#### ggplot time! ===============
# If you do the above, R Studio organizes your code into sections
#ts, tab creates a time stamp
# Tue Feb 12 14:31:53 2019 ------------------------------

#ggplot2 automatically in tidyverse

#ggplot(data = DATA, mapping = aes(MAPPINGS)) +
#geom_function()

ggplot(data=surveys_complete) #Empty

#define a mapping

ggplot(data=surveys_complete, mapping= aes(x=weight, y=hindfoot_length)) #Get an empty plot, but has mapped the range of values for both variables.


ggplot(data=surveys_complete, mapping= aes(x=weight, y=hindfoot_length)) +  #line has to end with a +
  geom_point() #makes point for every X,Y value
  

# saving a plot object

surveys_plot <- ggplot(data=surveys_complete, mapping= aes(x=weight, y=hindfoot_length)) #Set your "canvas"

surveys_plot +
  geom_point()

####Challenge 1 ====
#Scatter plots can be useful exploratory tools for small datasets. For data sets with large numbers of observations, such as the surveys_complete data set, overplotting of points can be a limitation of scatter plots. One strategy for handling such settings is to use hexagonal binning of observations. The plot space is tessellated into hexagons. Each hexagon is assigned a color based on the number of observations that fall within its boundaries. To use hexagonal binning with ggplot2, first install the R package hexbin from CRAN:

#install.packages("hexbin")
library(hexbin)

surveys_plot +
  geom_hex()

#Nice when you have high density of points

#We're going to build plots from the ground up
ggplot(data=surveys_complete, mapping=aes(x=weight, y=hindfoot_length)) #Autocomplete doesn't show


# Modifying whole geom appearances
surveys_complete %>%    #Piping can help autocomplete
  ggplot(aes(x=weight, y=hindfoot_length)) +
  geom_point(alpha=0.1, color="tomato")    #alpha = 1 is regular points.


#Using data in a geom
surveys_complete %>% 
  ggplot(aes(x=weight, y=hindfoot_length))+    #This line is the global aesthetic
  geom_point(alpha=0.1, aes(color=species_id)) #set color according to species ID

#putting color as a global aesthetic
surveys_complete %>% 
  ggplot(aes(x=weight, y=hindfoot_length, color=species_id))+
  geom_point(alpha=0.1) 

# Using a little jitter

surveys_complete %>% 
  ggplot(aes(x=weight, y=hindfoot_length, color=species_id))+
  geom_jitter(alpha=0.1) #adds a bit of noise to each point to prevent exact values to be plotted on top of each other

# Move on to boxplots
surveys_complete %>% 
  ggplot(aes(x=species_id, y=weight)) +
  geom_boxplot()

#Adding points to boxplot
surveys_complete %>% 
  ggplot(aes(x = species_id, y = weight)) +
  geom_boxplot() +
  geom_point(alpha = 0.3, color = "tomato")
# DISASTER, do jitter instead
surveys_complete %>% 
  ggplot(aes(x = species_id, y = weight)) +
  geom_boxplot() +
  geom_jitter(alpha = 0.3, color = "tomato") #like painting in layers

#Move jitter underneath the boxplot
surveys_complete %>% 
  ggplot(aes(x = species_id, y = weight)) +
  geom_jitter(alpha = 0.3, color = "tomato")+
  geom_boxplot()

#Modify boxplot fill to be transparent
surveys_complete %>% 
  ggplot(aes(x = species_id, y = weight)) +
  geom_jitter(alpha = 0.3, color = "tomato")+
  geom_boxplot(alpha=0)

# Plotting time series
yearly_counts <- surveys_complete %>% 
  count(year, species_id)   # Same as doing group by (year, species ID) and then tally

yearly_counts %>% 
  ggplot(aes(x=year, y=n))+
  geom_line()
# hmm not quite


yearly_counts %>% 
  ggplot(aes(x=year, y=n, group=species_id, color=species_id))+
  geom_line()

#facetting
yearly_counts %>% 
  ggplot(aes(x=year,y=n, color=species_id))+
  geom_line() +
  facet_wrap(~ species_id) #makes a little subplot for every species ID

# Including sex, new data frame
yearly_sex_counts <- surveys_complete %>% 
  count(year, species_id, sex)

yearly_sex_counts %>% 
  ggplot(aes(x=year, y=n, color= sex)) +
  geom_line()+
  facet_wrap(~ species_id)

#Can add themes to change overall appearance of a plot
yearly_sex_counts %>% 
  ggplot(aes(x=year, y=n, color= sex)) +
  geom_line()+
  facet_wrap(~ species_id)+
  theme_bw() +
  theme(panel.grid = element_blank())     #modify the theme; Go to the panel grid and want a blank element

ysx_plot <- yearly_sex_counts %>%    #Can save a plot at any point
  ggplot(aes(x=year, y=n, color= sex)) +
  geom_line()+
  facet_wrap(~ species_id)

ysx_plot

ysx_plot + theme_minimal()

#install.packages("ggthemes")

ysx_plot + ggthemes::theme_excel() # Makes plot look like you made it in Excel

# A little more facetting, plot species weight over time by sex

yearly_sex_weight <- surveys_complete %>% 
  group_by(year,sex, species_id) %>% 
  summarise(avg_weight = mean (weight))

#facet_grid uses rows ~ columns for facetting. The "." indicates nothing in this dimension
yearly_sex_weight %>% 
  ggplot(aes(x=year, y=avg_weight, color=species_id))+
  geom_line() +
  facet_grid(sex ~ .)  # (rows ~ columns); "." nothing for columns; gives you two stacked plots. (. ~ sex) would give you two plots side by side


# Adding labels and stuff
yearly_sex_counts %>% 
  ggplot(aes(x=year, y=n, color= sex)) +
  geom_line()+
  facet_wrap(~ species_id)+
  theme_bw() +
  theme(panel.grid = element_blank())+
  labs(title = "Observed Species through Time", x= "Year of Observation", y="Number of species")+
  theme(text = element_text(size=16))+
  theme(axis.text.x = element_text(color="grey20", size = 12, angle = 90, hjust = 0.5, vjust =0.5))


ggsave("figures/my_test_facet_plot.jpeg", height=8, width=8) #can do png, pdf; will save last plot unless you specify

#ggplot2 cheat sheet: https://www.rstudio.com/wp-content/uploads/2016/11/ggplot2-cheatsheet-2.1.pdf
