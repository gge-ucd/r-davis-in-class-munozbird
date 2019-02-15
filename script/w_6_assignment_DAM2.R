# wEEK 6 ASSIGNMENT

# Load Libraries
library(tidyverse)

# Import data
gapminder <- read_csv("http://gge-ucd.github.io/R-DAVIS/data/gapminder.csv")


####Part 1A ----
# Modify the following code to make a figure that shows how life expectancy has changed over time:

ggplot(gapminder, aes(x=year, y=lifeExp)) + 
  geom_point()


####Part 1B ----
# Look at the following code. What do you think the scale_x_log10() line is doing? What do you think the geom_smooth line is doing?

ggplot(gapminder, aes(x=gdpPercap, y= lifeExp))+
  geom_point(aes(color=continent), size=.25)+
  scale_x_log10()+
  geom_smooth(method='lm', color='black', linetype='dashed')+
  theme_bw()

# Remove scale_x_log10
ggplot(gapminder, aes(x=gdpPercap, y= lifeExp))+
  geom_point(aes(color=continent), size=.25)+
  geom_smooth(method='lm', color='black', linetype='dashed')+
  theme_bw()

# Remove geom_smooth
ggplot(gapminder, aes(x=gdpPercap, y= lifeExp))+
  geom_point(aes(color=continent), size=.25)+
  scale_x_log10()+
  theme_bw()

#The scale_x_log10() line is converting data to the log scale. Geom_smooth is adding a trendline to the data.


####Part 1C ----
# Modify the above code to size the points in proportion to the population of the country. Are you translating data to a visual feature of the plot?

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, size=pop)) +
  geom_point(aes(size = pop, color = continent)) + 
  scale_x_log10() +
  geom_smooth(method = 'lm', color = 'black', linetype = 'dashed') +
  theme_bw()
