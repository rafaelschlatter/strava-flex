get_weekstart <- function(current_date, current_day) {
  if (current_day == "Monday") {
    weekstart <- current_date
  } else if (current_day == "Tuesday") {
    weekstart <- current_date - 1
  } else if (current_day == "Wednesday") {
    weekstart <- current_date - 2
  } else if (current_day == "Thursday") {
    weekstart <- current_date - 3
  } else if (current_day == "Friday") {
    weekstart <- current_date - 4
  } else if (current_day == "Saturday") {
    weekstart <- current_date - 5
  } else {
    weekstart <- current_date - 6
  }
  return(weekstart)
}


remove_latlng <- function(stream) {
  for (i in seq(length(stream))) {
    if (toString(stream[[i]]["type"]) == "latlng") {
      stream[[i]] <- NULL
      break
    }
  }
  return(stream)
}


stream_to_df <- function(stream) {
  for (i in seq(length(stream))) {
    column_name = toString(stream[[i]]["type"])
    column_data = unlist(stream[[i]]["data"])
    if (i == 1) {
      df <- data.frame(column_name=column_data)
    }
    else {
      df[column_name]<-column_data
    }
  }
  return(df)
}


get_latest_activity <- function(df, workout_type) {
  type_activities <- df[df$type == workout_type, ] 
  latest_id <- type_activities["id"][1, ]
  return(latest_id)
}


calculate_max_heartrate <- function(birthdate) {
  # This doesnt handle edge cases (e.g. leap years), but is enough here
  age <- round((as.numeric(Sys.Date() - as.Date(birthdate)) / 365))
  return(220-age)
}


calculate_heartrate_zone <- function(max_hr, hr_data) {
  breaks <- c(0.5*max_hr, 0.6*max_hr, 0.7*max_hr, 0.8*max_hr, 0.9*max_hr, 1*max_hr)
  lables <- c("Very light", "Light", "Moderate", "Intense", "Maximum")
  bins <- cut(hr_data, breaks = breaks, include.lowest = TRUE, right = FALSE, labels = lables)
  return(bins)
}