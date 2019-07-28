install <- function(packages){
  new.packages <- packages[!(packages %in% installed.packages()[, "Package"])]
  if (length(new.packages)) 
    install.packages(new.packages, dependencies = TRUE)
  sapply(packages, require, character.only = TRUE)
}

required.packages <- c("flexdashboard", "rStrava", "jsonlite", "highcharter", "dplyr", "tidyr", "knitr")

# Because the shinyapps.io server does not allow calls to install_packages()
#install(required.packages)

# Use library() instead, shiny will install the required packages.
library(flexdashboard)
library(rStrava)
library(jsonlite)
library(highcharter)
library(dplyr)
library(tidyr)
library(knitr)
library(htmltools)
