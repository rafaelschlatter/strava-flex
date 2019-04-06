install <- function(packages){
  new.packages <- packages[!(packages %in% installed.packages()[, "Package"])]
  if (length(new.packages)) 
    install.packages(new.packages, dependencies = TRUE)
  sapply(packages, require, character.only = TRUE)
}

required.packages <- c("flexdashboard", "rStrava", "jsonlite", "highcharter", "dplyr", "tidyr")
install(required.packages)
