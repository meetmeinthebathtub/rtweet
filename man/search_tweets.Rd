% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/search.R
\name{search_tweets}
\alias{search_tweets}
\title{search_tweets}
\usage{
search_tweets(q, n = 100, type = "recent", max_id = NULL,
  include_rts = TRUE, full_text = TRUE, parse = TRUE, usr = TRUE,
  token = NULL, retryonratelimit = FALSE, verbose = TRUE, adjtimer = 20,
  ...)
}
\arguments{
\item{q}{Query to be searched, used to filter and select tweets
to return from Twitter's REST API. Must be a character string not
to exceed maximum of 500 characters. Spaces behave like boolean
"AND" operator. To search for tweets containing at least one of
multiple possible terms, separate each search term with spaces
and "OR" (in caps). For example, the search
\code{q = "data science"} looks for tweets containing both
"data" and "science" anywhere located anywhere in the tweets and
in any order. When "OR" is entered between search terms,
\code{query = "data OR science"}, Twitter's REST API should return
any tweet that contains either "data" or
"science." It is also possible to search for exact phrases using
double quotes. To do this, either wrap single quotes around a
search query using double quotes, e.g.,
\code{q = '"data science"'} or escape each internal double quote
with a single backslash, e.g., \code{q = "\"data science\""}.}

\item{n}{Integer, specifying the total number of desired tweets to
return. Defaults to 100. Maximum number of tweets returned from
a single token is 18,000. To return more than 18,000 tweets, users
are encouraged to set \code{retryonratelimit} to TRUE. See details
for more information.}

\item{type}{Character string specifying which type of search
results to return from Twitter's REST API. The current default is
\code{type = "recent"}, other valid types include
\code{type = "mixed"} and \code{type = "popular"}.}

\item{max_id}{Character string specifying the [oldest] status
id beyond which search results should resume returning.
Especially useful large data returns that require multiple
iterations interrupted by user time constraints. For searches
exceeding 18,000 tweets, users are encouraged to take advantage
of rtweet's internal automation procedures for waiting on
rate limits by setting \code{retryonratelimit} argument to TRUE.
It some cases, it is possible that due to processing time and
rate limits, retreiving several million tweets can take several
hours or even multiple days. In these cases, it would likely be
useful to leverage \code{retryonratelimit} for sets of tweets
and \code{max_id} to allow results to continue where previous
efforts left off.}

\item{include_rts}{Logical, indicating whether to include retweets
in search results. Retweets are classified as any tweet
generated by Twitter's built-in "retweet" (recycle arrows)
function. These are distinct from quotes (retweets with
additional text provided from sender) or manual retweets
(old school method of manually entering "RT" into the text
of one's tweets).}

\item{full_text}{Logical, indicating whether to return full text of
tweets. Defaults to TRUE. Setting this to FALSE will truncate any
tweet that exceed 140 characters.}

\item{parse}{Logical, indicating whether to return parsed
data.frame, if true, or nested list (fromJSON), if false. By default,
\code{parse = TRUE} saves users from the wreck of time and frustration
associated with disentangling the nasty nested list returned
from Twitter's API (for proof, check rtweet's Github commit history).
As Twitter's APIs are subject to change, this argument would be
especially useful when changes to Twitter's APIs affect performance of
internal parsers. Setting \code{parse = FALSE} also ensures the
maximum amount of possible information is returned. By default, the
rtweet parse process returns nearly all bits of information returned
from Twitter. However, users may occassionally encounter new or
omitted variables. In these rare cases, the nested list object will
be the only way to access these variables.}

\item{usr}{Logical indicating whether to return a data frame of
users data. Users data is stored as an attribute. To access this
data, see \code{\link{users_data}}. Useful for marginal returns in
memory demand. However, any gains are likely to be negligible as
Twitter's API invariably returns this data anyway. As such, this
defaults to true, see \code{\link{users_data}}.}

\item{token}{OAuth token. By default \code{token = NULL} fetches a
non-exhausted token from an environment variable. Find
instructions on how to create tokens and setup an environment
variable in the tokens vignette (in r, send \code{?tokens} to
console).}

\item{retryonratelimit}{Logical indicating whether to wait and
retry when rate limited. This argument is only relevant if the
desired return (n) exceeds the remaining limit of available
requests (assuming no other searches have been conducted in the
past 15 minutes, this limit is 18,000 tweets). Defaults to false.
Set to TRUE to automate process of conducting big searches
(i.e., n > 18000). For many search queries, esp. specific or
specialized searches, there won't be more than
18,000 tweets to return. But for broad, generic, or popular
topics, the total number of tweets within the REST window of
time (7-10 days) can easily reach the millions.}

\item{verbose}{Logical, indicating whether or not to include
output processing/retrieval messages. Defaults to TRUE. For
larger searches, messages include rough estimates for time
remaining between searches. It should be noted, however, that
these time estimates only describe the amount of time between
searches and not the total time remaining. For large searches
conducted with \code{retryonratelimit} set to TRUE, the
estimated retreival time can be estimated by dividing the number
of requested tweets by 18,000 and then multiplying the quotient
by 15 (token cooldown time, in minutes).}

\item{adjtimer}{Numeric buffer (in seconds) used when sleeping
between API requests with \code{retryonratelimit}. Defaults to
20. Added this because for my linux laptop has a high resting
heart rate, so it kept sending requests before the rate limit
could be reset. If this happens to you, add to this value to
achieve smoother experience. If you're trying to maximize
efficiency, you may be able to set this to 0 or 1 without any
issue.}

\item{\dots}{Futher arguments passed on to \code{make_url}.
All named arguments that do not match the above arguments
(i.e., count, type, etc.) will be built into the request.
To return only English language tweets, for example, use
\code{lang = "en"}. For more options see Twitter's
API documentation.}
}
\value{
List object with tweets and users each returned as a
  data frame.
}
\description{
Returns two data frames (tweets data and users data)
  using a provided search query.
}
\details{
Twitter API documentation recommends limiting searches to
  10 keywords and operators. Complex queries may also produce
  API errors preventing recovery of information related to
  the query.
  It should also be noted Twitter's search API does not consist
  of an index of all Tweets. At the time of searching, the
  search API index includes between only 6-9 days of Tweets.


  Number of tweets returned will often be less than what was
  specified by the user. This can happen because (a) the search
  query did not return many results (the search pool is already
  thinned out from the population of tweets to begin with),
  (b) because user hitting rate limit for a given token, or (c)
  of recent activity (either more tweets, which affect pagination
  in returned results or deletion of tweets). To return more than
  18,000 tweets in a single call, users must set
  \code{retryonratelimit} argument to true. This method relies on
  updating the \code{max_id} parameter and waiting for token rate
  limits to refresh between searches. As a result, it is possible
  to search for 50,000, 100,000, or even 10,000,000 tweets, but
  these searches can take hours or even days. At these durations,
  it would not be uncommon for connections to timeout. Users are
  instead encouraged to breakup data retrieval into smaller chunks
  by leveraging \code{retryonratelimit} and then using the
  status_id of the oldest tweet as the \code{max_id} to resume
  searching where the previous efforts left off.
}
\examples{
\dontrun{
## search for 1000 tweets mentioning Hillary Clinton
hrc <- search_tweets(q = "hillaryclinton", n = 1000)

## data frame where each observation (row) is a different tweet
hrc

## users data also retrieved. can access it via users_data()
users_data(hrc)

## search for 1000 tweets in English
djt <- search_tweets(q = "realdonaldtrump", n = 1000, lang = "en")
djt
users_data(djt)

## exclude retweets
rt <- search_tweets("rstats", n = 500, include_rts = FALSE)

## perform search for lots of tweets
rt <- search_tweets("trump OR president OR potus", n = 100000,
                    retryonratelimit = TRUE)

## plot time series of tweets frequency
ts_plot(rt, by = "mins", theme = "spacegray",
        main = "Tweets about Trump")

}
}
\seealso{
\url{https://dev.twitter.com/overview/documentation}

Other tweets: \code{\link{get_favorites}},
  \code{\link{get_timeline}},
  \code{\link{lookup_statuses}},
  \code{\link{stream_tweets}}, \code{\link{tweets_data}}
}

