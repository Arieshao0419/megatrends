# Packages
library(Rfacebook)
library(httr)
library(httpuv)
library(rjson)

## need fb access token here
fb_oauth = 'EAACEdEose0cBACEkRLalmQdiuVDygwN4WBKto1VG9KtZCVRjDYmxCVy28bVsDJCYLPgpRRF5bGc625guBqzse7qdK4UO8BIl4GrIA2GgDMTLf6UJFuCIYVyNbQdaJ0ZCOU5JgVvxTNVHlZAiSpoZANyz59hqL4fORv9E7HPiLo0QvtpodaEl'

## Run the following line to return facebook public information for user:
getUsers("me", token=fb_oauth, private_info=TRUE)

## See also ?fbOAuth for information on how to get a long-lived OAuth token

################################################
############# SCRAPE FACEBOOK PAGES ############
################################################

## Get posts from = to
uon_page <- getPage(page = "TheUniversityofNewcastleAustralia", token = fb_oauth, n = 1000, since = "2016/05/19", until = "2016/06/19")

## read
uon_page <- read.table("uon_page.txt")

## View page details
names(uon_page)
head(uon_page)

## Most Likes
uon_page[which.max(uon_page$likes_count), ]

## Get posts and comments
post <- getPost("67258704085_10153848235689086", n = 2000, token = fb_oauth)

## Get Details
post1 <- read.table("post1.txt")
post2 <- read.table("post2.txt")
post3 <- read.table("post3.txt")
post <- list(post = post1, likes = post2, comments = post3)
tail(post$comments)

## Who liked it
head(post$likes)

## information about people who liked
people <- getUsers(post$likes$from_id, token = fb_oauth)
people <- read.table("people.txt")
head(people)

##############################################################
#################### ANALYSE #################################
##############################################################

uon_page$created_time <- as.Date(substr(as.character(uon_page$created_time), 1, 10))
may <- uon_page$created_time >= as.Date("2016/05/19")
ma <- data.frame(time = sort(unique(uon_page$created_time[may])), 
                  likes = tapply(uon_page[may, 8], uon_page[may, 4], sum),
                  comments = tapply(uon_page[may, 9], uon_page[may, 4], sum), 
                  shares = tapply(uon_page[may, 10], uon_page[may, 4], sum))


######### FIX ######### FIX ######### FIX ######### FIX ######
##############################################################

library(ggplot2)
library(scales)
mapop <- data.frame(time = rep(ma$time, 3), 
                     count = c(ma$likes, ma$comments, ma$shares),
                     measure = rep(c("likes", "comments", "shares"), 
                                   each = nrow(ma)))
pma <- ggplot(mapop, aes(time, count, colour = measure)) + geom_line() + 
  ggtitle("University of Newcastle Facebook Page in May/June 2016") + 
  scale_y_log10("Average count per day", breaks = c(10, 100, 1000))
print(pma)

## What type of posts attracted most likes from May 19 to Jun 19 2016?

MayC <- uon_page$created_time >= as.Date("2016/05/19") & 
  uon_page$created_time <= as.Date("2016/05/31")
JunC <- uon_page$created_time >= as.Date("2016/06/01") & 
  uon_page$created_time <= as.Date("2016/06/19")
MC <- tapply(uon_page$likes_count[MayC], uon_page$type[MayC], sum)
MC <- MC[-3]
JC <- tapply(uon_page$likes_count[JunC], uon_page$type[JunC], sum)
JC <- JC[-3]
M <- tapply(uon_page$likes_count[may], uon_page$type[may], sum)
M <- M[-3]
like <- data.frame(month = rep(1:6, each = 3), 
                   type = rep(c( "link", "photo", "video"), 3),
                   likes = c(MC, JC, M))
pl <- ggplot(like, aes(month, likes, fill = type)) + geom_bar(stat="identity") + 
  ggtitle("Likes to uon from different post types on Facebook in 2016")
print(pl)

############ ALL GOOD ### WORKS ###################

sbd <- searchPages( string="Big Data", token=fb_oauth, n=1000)
sbd <- read.table("sbd.txt")
names(sbd)

head(sbd)
