## INSTALL PACKAGES
doInstall <- TRUE  # Change to FALSE if you don't want packages installed.
toInstall <- c("ROAuth", "twitteR", "streamR", "ggplot2", "stringr",
               "tm", "RCurl", "maps", "Rfacebook", "topicmodels", "library", "devtools")


#####################################
###### CREATING AN OAUTH TOKEN ######
#####################################

## comsumer id and secret is Jacobs megatrends twitter app

library(ROAuth)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "TLoiGyoNjdO0cVJzbQCRW21VN"
consumerSecret <- "PZhT6ZXoGelh7rypBswiCP7ZwDBjmtuUZ4XUtACJTMPZvcEwt8"

my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret, requestURL=requestURL,
                             accessURL=accessURL, authURL=authURL)

## run this line and go to the URL that appears on screen
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

## now you can save oauth token for use in future sessions with twitteR or streamR
save(my_oauth, file="collect/oauth_token.Rdata")

### Run access token and secret

accessToken = '739726747973754880-MIjR4hL72aAa10nAT9agrRkSHuFqkQn'
accessSecret = 'jZ0Z6SMcVzvj92R9lNR4CMPAEq9APnJRFPD1TSY1JngsM'

## test that it works
library(twitteR)
setup_twitter_oauth(consumer_key=consumerKey, consumer_secret=consumerSecret,
                    access_token=accessToken, access_secret=accessSecret)
searchTwitter('uon', n=1)

## Run twitteR package
library(twitteR)


#####################################
####### SEARCH RECENT TWEETS ########
#####################################

# basic searches by keywords
tweets <- searchTwitter("uon", n=20)

# convert to data frame
tweets <- twListToDF(tweets)

#############################################
### DOWNLOADING RECENT TWEETS FROM A USER ###
#############################################

## you can do this with twitteR with user name
timeline <- userTimeline('Aliceincode', n=20)

timeline <- twListToDF(timeline)

###############################################
###### COLLECT TWEETS FILTER BY KEYWORDS ######
###############################################

library(streamR)

filterStream(file.name="collect/tweets_key.json", track="uon",
             timeout=60, oauth=my_oauth)

## "parseTweets" function to R as a data frame
tweets <- parseTweets("collect/tweets_key.json")

## capture tweets with multiple keywords:
filterStream(file.name="collect/tweets_phase.json",
             track=c("newcastle", "university", "australia"),
             tweets=100, oauth=my_oauth)

###############################################
###### COLLECT TWEETS FILTER BY LOCATION ######
###############################################


## I think these are the right co-ords for UON
filterStream(file.name="collect/tweets_geo.json", locations=c(151, 42, -32, 53),
             timeout=60, oauth=my_oauth)

## open the tweets in R
tweets <- parseTweets("collect/tweets_geo.json")


############################################
######### COLLECT  RANDOM  TWEETS ##########
############################################

##  collect a random  tweets with "sampleStream" function
sampleStream(file.name="collect/tweets_rand.json", timeout=30, oauth=my_oauth)

## Now open the tweets in R...
tweets <- parseTweets("collect/tweets_rand.json")

## Find most common hashtags
getCommonHashtags(tweets$text)

## Find most retweeted tweet?
tweets[which.max(tweets$retweet_count),]
