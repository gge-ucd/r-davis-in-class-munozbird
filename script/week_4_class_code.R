#Intro to Dataframes

download.file(url = "https://ndownloader.figshare.com/files/2292169", destfile = "data/portal_data_joined.csv")  #Package will not know that to save the file as so have to specify

surveys <- read.csv(file = "data/portal_data_joined.csv")

head(surveys) #Prints first six observations of each column

# Each column in a data frame is a vector

#Looking at structure

str(surveys)

dim(surveys)
nrow(surveys) #Gives # of rows
ncol(surveys) #Gives # of columns

tail(surveys) #Prints last six observations of each column

names(surveys) #Character vector of all the columns in our survey
rownames(surveys)


# Another useful one
summary(surveys) # Good to check the data

#Subsetting dataframes

#subsetting vectors by giving them a location index
animal_vec <- c("mouse", "rat", "cat")
animal_vec[2]

#dataframes are 2D!
surveys[1,1] #first row, first column
head(surveys)
surveys[2,1]

surveys[1,6]

surveys[33000,1]

#whole first column as a VECTOR
surveys[,1] #leaving one of these dimensions blank means return everything from the selected dimension

#using a single number with no comma will give us a dataframe with one column
surveys[1]
head(surveys[1])

surveys[1:3,7]

# Pull out the first 3 vaues in the 6th columns

surveys[1:3,6]

#Pull our a whole single observation
surveys[5,]

#negative sign to exclude indices
surveys[1:5,-1]

surveys[-10:34786,]
#Error: Error in xj[i] : only 0's may be mixed with negative subscripts

#workaround:
surveys[-c(10:34786),]

surveys[c(10,15,20),]
surveys[c(10,15,20,10),]
surveys[c(1,1,1,1,1),]

#more ways to subset
surveys["plot_id"] #single column as data.frame
surveys[,"plot_id"] #single column as vector
surveys[["plot_id"]] #single column as vector; gives same result as previous, but double-brackets come in handy when utilizing lists
surveys$year #Probably most commonly used; single column as vector


###CHALLENGE###

#Create a data.frame (surveys_200) containing only the data in row 200 of the surveys dataset.
surveys_200 <- surveys[200,]
surveys_200

#Notice how nrow() gave you the number of rows in a data.frame? Use that number to pull out just that last row in the data frame. Compare that with what you see as the last row using tail() to make sure it’s meeting expectations.

nrow(surveys)   #34786
surveys[34786,]
tail(surveys)

#Pull out that last row using nrow() instead of the row number. Create a new data frame (surveys_last) from that last row.
surveys_last <- surveys[nrow(surveys),]
surveys_last

#Use nrow() to extract the row that is in the middle of the data frame. Store the content of this row in an object named surveys_middle.
surveys_middle <- surveys[nrow(surveys)/2,]
surveys_middle

#Combine nrow() with the - notation above to reproduce the behavior of head(surveys), keeping just the first through 6th rows of the surveys dataset.
surveys[-c(7:nrow(surveys)),]



# Finally, factors
# Represent categorical data. They are stored as integers with labels assigned to them. Can be ordered or unordered
surveys$sex

#Creating our own factor
sex <- as.factor(c("male", "female","female","male"))
sex

class(sex)  # tells us it is a factor; tells us higher level attribute of the item

typeof(sex) # tells is it is an integer

#Levels gives back a character vector of the levels
levels(sex)
levels(surveys$genus)

nlevels(sex)

concentration <- factor(c("high", "medium","high","low"))
concentration
# Want the levels to make sense
concentration <- factor(concentration, levels = c("low","medium","high"))
concentration

# Factors have idiosyncrasies
#Let's try adding to a factor
concentration <- c(concentration, "very high")
concentration
#Does not like this; Coerces to characters if you add a value that doesn't match a current level

#Let's just make them characters
as.character(sex)

#factors with numeric levels
year_factor <- factor(c(1990,1923,1965,2018))
as.numeric(year_factor)

as.character(year_factor)

#this will actually give us a numeric vector
as.numeric(as.character(year_factor))

#recommended way, "safer" than the previous
as.numeric(levels(year_factor))[year_factor]


#why the heck all the factors?
?read.csv

surveys_no_factors <- read.csv("data/portal_data_joined.csv", stringsAsFactors = F) #This will read in without factors
str(surveys_no_factors)

#renaming factors
sex <- surveys$sex
levels(sex) # We get three levels: F, M, and [Blank]
levels(sex)[1] <- "undetermined"
levels(sex)

#working with dates
install.packages("lubridate") #Generally do not have install.packages function in your code or can be annoying to collaborator 
library(lubridate)

my_date <- ymd("2015-01-01")
my_date
str(my_date)

my_date <- ymd(paste("2015","05","17",sep = "-"))
my_date

paste(surveys$year, surveys$month, surveys$day, sep="-")

surveys$date <- ymd(paste(surveys$year, surveys$month, surveys$day, sep="-"))
surveys$date

#Warning message: 129 failed to parse
surveys$date[is.na(surveys$date)]
