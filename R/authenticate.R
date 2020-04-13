strava_keys <- list(
  app_name=Sys.getenv("app_name"),
  client_id=Sys.getenv("client_id"),
  client_secret=Sys.getenv("client_secret")
)

#stoken <- httr::config(
#  token = strava_oauth(
#    strava_keys$app_name,
#    strava_keys$client_id,
#    strava_keys$client_secret,
#    app_scope = "activity:read_all",
#    cache = TRUE
#  )
#)

# This line needs to be disabled when running httr::config() for the first time.
# A token will be cached in the working directory. This token can be used on
# the shiny server, where manuel accepting the request through Stravas website
# is not possible. After running above code once locally, upload the whole directory
# to shinyapps.io (super hacky, but worked for me at least).
stoken <- httr::config(token = readRDS('.httr-oauth')[[1]])
