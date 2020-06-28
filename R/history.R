create_yearly_history_df <- function(df, years) {
  data <- data.frame(matrix(ncol = 10, nrow = 0))
  columns <- c(
    "Year",
    "Distance.run",
    "Time.run",
    "Activities.run",
    "Distance.ride",
    "Time.ride",
    "Activities.ride",
    "Distance.ski",
    "Time.ski",
    "Activities.ski"
  )
  colnames(data) <- columns
  
  for (year in years) {
    yearly_activites <- subset(df, calendar_year == year)
    data[nrow(data) + 1,] <- list(
      year,
      paste(round(sum(subset(yearly_activites, type == "Run")$distance), 1), "km"),
      paste(round(sum(subset(yearly_activites, type == "Run")$elapsed_time) / (60*60), 2), "hr"),
      length(subset(yearly_activites, type == "Run")$id),
      paste(round(sum(subset(yearly_activites, type == "Ride")$distance), 1), "km"),
      paste(round(sum(subset(yearly_activites, type == "Ride")$elapsed_time) / (60*60), 2), "hr"),
      length(subset(yearly_activites, type == "Ride")$id),
      paste(round(sum(subset(yearly_activites, type == "NordicSki")$distance), 1), "km"),
      paste(round(sum(subset(yearly_activites, type == "NordicSki")$elapsed_time) / (60*60), 2), "hr"),
      length(subset(yearly_activites, type == "NordicSki")$id)
    )
  }
  return(data)
}