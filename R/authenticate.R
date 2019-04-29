strava_keys = fromJSON('keys.json')$strava
strava_goals = fromJSON('keys.json')$goals
strava_athlete = fromJSON("keys.json")$athlete
stoken <- httr::config(token = strava_oauth(strava_keys$app_name,
                                            strava_keys$client_id,
                                            strava_keys$client_secret,
                                            app_scope = 'view_private'))