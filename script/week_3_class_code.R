#Week 3 Live Code

read.csv("data/tidy.csv")

#Vectors

weight_g <- c(50, 60, 31, 89)
weight_g

#now characters
animals <- c("mouse", "rat", "dog", "cat")
animals

#vector exploration tools
length(weight_g)   #how many entries in the vector
length(animals)

# Everything in a vector has to be the same data type.

class(weight_g) #What kind of data is contained in the vector
class(animals)

str(weight_g) #Gives structure of an object. Go-to first tool for looking at an object

#be careful about ading values and running this line multiple times
weight_g <- c(weight_g, 105) #Can add to a vector
weight_g

weight_g <- c(25, weight_g)
weight_g

#6 types of atomic vectors: "numeric" ("double", can have decimals), "character","logical", "integer" (have to be whole rounded numbers),"complex" (such as the i symbol), "raw" (storing as 0s and 1s, not encountered often)
#First 4 we listed are the main types we'll work with

typeof(weight_g)

weight_integer <- c(20L, 21L, 85L) #How R recognizes integers
class(weight_integer)
typeof(weight_integer)

#R will think of Excel columns as vectors


num_char <- c(1, 2, 3, "a")
num_logical <- c(1, 2, 3, TRUE)
char_logical <- c("a", "b", "c", TRUE)
tricky <- c(1, 2, 3, "4")

typeof(num_char)  # A character makes all numbers turn into a character
typeof(num_logical) # A logical makes all turn into numeric
typeof(char_logical) #Turns into all characters
typeof(tricky)

combined_logical <- c(num_logical, char_logical)

# R will coerce values into the same type. Characters > Double > Integers > Logical
# Regular expressions allow to pick out specific characters

###SUBSETTING VECTORS###

animals

#square-bracket subsetting
animals[3]

animals[2:3]     #OR (as in class)
animals[c(2,3)]
animals[c(3,1,3)]

#conditional subsetting
weight_g
weight_g[c(T, F, T, T, F, T, T)] # Will skip the values at positions 2 and 5

weight_g > 50

weight_g[weight_g > 50] # Get back all values in the vector that are greater than 50

#multiple conditions
weight_g[weight_g <30 | weight_g >50] # | means "or"

weight_g[weight_g>=30 & weight_g==90] #no value is equal to 90 so you get nothing back

weight_g[weight_g>=30 & weight_g==89]

#searching for characters
animals[animals =="cat"| animals =="rat"]

animals %in% c("rat", "antelope", "jackalope", "hippogriff") #Give me entries in animals that are also in this vector. Relates logical values to the animals vector

animals[animals %in% c("rat", "antelope", "jackalope", "hippogriff")] #To get actual entry rat

#challenge
"four" >"five"
"six" > "five"
"eight" > "five"
"a">"b"  #Looks at alphabetic order. a=1, b=2, etc.
"z">"y"


# MISSING VALUES

heights <- c(2, 4, 4, NA, 6)
heights

str(heights)

mean(weight_g)

mean(heights) # R does not like that there is an NA
max(heights)

mean(x = heights, na.rm=TRUE)
max(heights, na.rm =TRUE)

#is.na == NA #DO NOT DO THIS
is.na(heights) # NAs will be "True"
na.omit(heights)
complete.cases(heights) #NAs will be "False"
