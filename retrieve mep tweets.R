## Author: Daniel Triana
## Data retrieved: 08/07/2022; 14:27

# load rtweet
library(rtweet)
library(tidyverse)
library(tm)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(readr)
library(data.table)

# Import relevant data base (twitter handles)
meps_data <- read_csv("meps_data.csv")
View(meps_data)

# Create MEP tw user vector (optional)
usr_name <- meps_data$tw_name

# Remove "NA" from vector (optional)
usr_name <- na.omit(usr_name)
usr_name <- as.data.frame(usr_name)

# Search for Twitter OAuth token(s). This is our personal token stored as an environment variable
token <- get_tokens()
token

# get users data (optional at this point)
usr_df <- lookup_users(meps_data$tw_name)
usr_data <- users_data(usr_df)

# Create a function for retrieving tweets
# Careful with the Sys.sleep function. It will helps us to slow down the rate limit.
# Loop
tweets_1 <- as.data.frame(NULL)

for(i in 1:nrow(usr_name)){
  
  #pull tweets
  tweets <- get_timeline(usr_name$usr_name[i], n = 1000, retryonratelimit = T, since_id = "1477276204034138118", max_id = 1544949236038619136, type = "recent"
) #%>%
    #dplyr::filter(created_at > "2022-01-01" & created_at <="2022-07-07")
  
  #populate df
  tweets_1 <- rbind(tweets_1, tweets)
  
  #pause for five seconds to further prevent rate limiting
  Sys.sleep(5)
  
  #print number/iteration for debugging/monitoring progress
  print(i)
}

fwrite(data.table(tweets_1), "C:\\Users\\dondt\\OneDrive\\DOCUME~1-PC0DSGY3-2708\\Echo chambers MEP\\meps_tweets_0122-0722.csv")

