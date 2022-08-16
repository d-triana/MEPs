## Author: Daniel Triana
## Data retrieved: 25/06/2022; 14:27

# load rtweet
library(rtweet)
library(tidyverse)
library(tm)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)

# Create MEP tw user vector
users <- meps_data$tw_name

# Remove "NA" from vector
users <- na.omit(users)
users

# Search for Twitter OAuth token(s)
token <- get_tokens()
token

# get users data
usr_df <- lookup_users(users)

``
## Making test
#test_df <- lookup_users(test)
#test_df_data <- users_data(test_df)
#test_followers <- as.data.frame(NULL)
#l = list(meps_followers, users_data_df$screen_name, followers)

#for(i in 1:nrow(test_df_data)){
  
  #pull followers
#  follow_tst <- get_followers(test_df_data$screen_name[i], n = test_df_data$followers_count[i], retryonratelimit = TRUE)
  
  #populate dataframe
#  test_followers <- rbind(test_followers, follow_tst)
  
  #pause for five seconds to further prevent rate limiting
#  Sys.sleep(5)
  
  #print number/iteration for debugging/monitoring progress
#  print(i)
#}

# prueba 2
get_all_followers <- function(name) {
  test_info <- lookup_users(name)
  test_data <- users_data(test_info)
  test_fllw <- get_followers(test_data$screen_name, n = test_data$followers_count, retryonratelimit = T)
  Sys.sleep(5)
  return(test_fllw)
}

fllw <- sapply(X = test_df_data$screen_name, FUN = get_all_followers, USE.NAMES = T)
``


# view users data
usr_df

# view users data for these users via users_data()
users_data_df <- users_data(usr_df)
write_excel_csv(users_data_df, "C:\\Users\\dondt\\OneDrive\\DOCUME~1-PC0DSGY3-2708\\Echo chambers MEP\\meps_account_data.csv")

# Retrieve followers from users vector
#create empty container to store tweets for each MEP
#meps_followers <- as.data.frame(NULL)
#l = list(meps_followers, users_data_df$screen_name, followers)

#for(i in 1:nrow(users_data_df)){
  
  #pull followers
#  followers <- get_followers(test_df[i], n = users_data_df$followers_count[i], retryonratelimit = TRUE)
  
  #populate dataframe
#  meps_followers <- rbind(l, use.names = TRUE, idcol = "ID")
  
  #pause for five seconds to further prevent rate limiting
#  Sys.sleep(5)
  
  #print number/iteration for debugging/monitoring progress
#  print(i)
#}


get_all_followers <- function(name) {
  usr_df <- lookup_users(name)
  usr_data <- users_data(usr_df)
  followers_data <- get_followers(name, n = usr_data$followers_count, retryonratelimit = T)
  Sys.sleep(5)
  return(followers_data)
}

all_followers <- sapply(X = usr_data$screen_name, FUN = get_all_followers, USE.NAMES = T)
