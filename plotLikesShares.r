# Load Rfacebook package
library(Rfacebook)

## To get access to the Facebook API, you need an OAuth code.
## not sure how long this access token is valid (it belongs to Alana's Alice N Code facebook account)

## need fb access toden here
fb_oauth = ''

## Run the following line to return facebook public information for user:
getUsers("me", token=fb_oauth, private_info=TRUE)

## See also ?fbOAuth for information on how to get a long-lived OAuth token

################################################
############# SCRAPE FACEBOOK PAGES ############
################################################

## Get last N pages for UON fb page
uon_page <- getPage("TheUniversityofNewcastleAustralia", token=fb_oauth, n=100)


####################################
########## PLOT FROM CSV ###########
####################################

## Write dataset to csv, this will rewrite when you run it, put in folder /collect/fb.csv
## In main directory or change directory
write.csv(page, "collect/fb.csv", row.names = FALSE)

## OPEN ggplot2 package
library("readr")

## collect data from csv
df = read_csv("collect/fb.csv", 
              col_types = list(created_time = col_character()))

df$created_time = parse_datetime(df$created_time)

## plot onto graph with ggplot2 package
library(ggplot2)

## Plotting two (continuous) variables
p = ggplot(data = df, aes(x = likes_count, y = shares_count))
p + geom_point() + scale_x_log10() + scale_y_log10() # add log scales 

## Plotting two (continuous) variables: smoothers
p + geom_point() + geom_smooth(na.rm = TRUE, 
                               data = df[df$likes_count>0 & df$shares_count>0,]) + 
  geom_smooth(na.rm = TRUE, 
              data = df[df$likes_count>0 & df$shares_count>0,], 
              method = "lm", colour = "red") + 
  scale_x_log10() + scale_y_log10() # add log scales 
