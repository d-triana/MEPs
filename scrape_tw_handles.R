library(tidyverse)
library(rvest)
library(selectr)
library(htmltools)
library(stringr)
library(dplyr)

# Load relevant url and name objet: results
results<-read_html("https://www.europarl.europa.eu/meps/en/full-list/all")

results

# Generate vector of names
names<-results %>%
  html_nodes("#docMembersList .t-item") %>%
  html_text()

names

# Generate vector of parliamentary group
group<-results %>%
  html_nodes(".mb-25:nth-child(1)") %>%
  html_text()

group

# Generate vector of origin country
country<-results %>%
  html_nodes(".mb-25+ .mb-25") %>%
  html_text()

country

# Generate vector of political party
party<-results %>%
  html_nodes(".mb-25~ .mb-25+ .sln-additional-info") %>%
  html_text()

party

# Generate vector of all additional info by MPE
addinfo<-results %>%
  html_nodes("#docMembersList .t-y-block") %>%
  html_text()

addinfo

# Generate vector of relative url's by MPE
url<-results %>%
  html_nodes("#docMembersList .t-y-block") %>%
  html_attr("href")

url

# Build tibble using the vectors generated before
results_df <- tibble(names, group, country, party, url)

results_df

# Build df with relative url's
nav_df <- tibble(url)
nav_df

# navigation results
nav_results_list <- tibble(
  html_results = map(nav_df$url[1:705],
                     ~ {
                       Sys.sleep(1)
                       .x %>%
                         read_html()
                       }),
  summary_url = nav_df$url[1:705]
)

nav_results_list

# Results by page
social_by_mep <- tibble( twitter =
                            map(nav_results_list$html_results,
                                ~ .x %>%
                                  html_nodes(".link_twitt") %>%
                                  html_attr("href")),
                          instagram =
                            map(nav_results_list$html_results,
                                ~ .x %>%
                                  html_nodes(".link_instagram") %>%
                                  html_attr("href")),
                          website = map(nav_results_list$html_results, 
                                        ~ .x %>%
                                          html_nodes(".link_website") %>%
                                          html_attr("href")),
                          mail = map(nav_results_list$html_results, 
                                     ~ .x %>% 
                                       html_nodes(".link_email") %>% 
                                       html_attr("href")),
                          facebook = map(nav_results_list$html_results, 
                                         ~ .x %>% 
                                           html_nodes(".link_fb") %>% 
                                           html_attr("href")),
                          summary_url = nav_results_list$summary_url
)

social_by_mep

# Complete df
complete_df_mep <- tibble(names, country, group, party, social_by_mep)


# Extract substring with tw public name
meps_data1$twitter <- str_remove(meps_data1$twitter, "\\?.*")
meps_data1$tw_name <- str_extract(meps_data1$twitter,"\\w+$") 

meps_data1 <- select(meps_data1, country, group, party, twitter, tw_name, instagram, website, mail, facebook, summary_url)

# Generate .csv file
fwrite(meps_data1, "C:\\Users\\dondt\\OneDrive\\DOCUME~1-PC0DSGY3-2708\\Web scraping Tw MPEs\\meps_data.csv")
write_excel_csv(meps_data1, "C:\\Users\\dondt\\OneDrive\\DOCUME~1-PC0DSGY3-2708\\Echo chambers MEP\\meps_data.csv")
fwrite(social_by_mep, "C:\\Users\\dondt\\OneDrive\\DOCUME~1-PC0DSGY3-2708\\Web scraping Tw MPEs\\social_data.csv")
