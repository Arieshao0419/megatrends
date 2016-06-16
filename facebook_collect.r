# Load Rfacebook package

## To get access to the Facebook API, you need an OAuth code.

fb_oauth = ''

## Run the following line to return facebook public information:
getUsers("me", token=fb_oauth, private_info=TRUE)

## See also ?fbOAuth for information on how to get a long-lived OAuth token

################################################
############# SCRAPE FACEBOOK PAGES ############
################################################

# Get a list of 10 most recent posts from UON Facebook page
# The Newcastle University Australia
page <- getPage("TheUniversityofNewcastleAustralia", token=fb_oauth, n=20)

# What information is available for each post?
page[1,]

# Which post got more likes?
page[which.max(page$likes_count),]

# Which post got more comments?
page[which.max(page$comments_count),]

# Which post was shared the most?
page[which.max(page$shares_count),]

# Subset data by date example, get all the posts from January 2016
page <- getPage("TheUniversityofNewcastleAustralia", token=fb_oauth, n=1000,
	since='2016/01/01', until='2016/01/31')


####################################
##### COLLECT PAGES AND LIKES ######
####################################

# List of users who liked a specific post?
post <- getPost(page$id[1], token=fb_oauth, n.likes=1000, comments=FALSE)

# View that list of people:
likes <- post$likes
head(likes)

# Get information for these users with their IDs as main option.
users <- getUsers(likes$from_id, token=fb_oauth)

# Get most common first names?
head(sort(table(users$first_name), decreasing=TRUE), n=10)


##################################
### COLLECTING PAGES' COMMENTS ###
##################################

# Get comments on a specific post?
post <- getPost(page$id[1], token=fb_oauth, n.comments=1000, likes=FALSE)

# View those comments
comments <- post$comments
head(comments)

# Which comments got the most likes?
comments[which.max(comments$likes_count),]
