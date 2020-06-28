# Strava-flex
[![Build Status](https://travis-ci.org/rafaelschlatter/strava-flex.svg?branch=master)](https://travis-ci.org/rafaelschlatter/strava-flex)
[![made-with-Markdown](https://img.shields.io/badge/Made%20with-Markdown-1f425f.svg)](http://commonmark.org)

## 1. Description
A flex dashboard to visualize Strava activities. My app is hosted here: <https://rafaelschlatter.shinyapps.io/strava-flex/>


![screenshot](https://github.com/rafaelschlatter/strava-flex/blob/master/resources/screenshot.png)
![screenshot2](https://github.com/rafaelschlatter/strava-flex/blob/master/resources/screenshot2.png)

## 2. Setup
### 2.1 Register app with Strava
To run the dasboard with your Strava data you need to register and API application with Strava.  

To do so, follow the instructions here (step 1 and 2):  
<https://medium.com/@annthurium/getting-started-with-the-strava-api-a-tutorial-f3909496cd2d>

### 2.2 Create `keys.json` file
Create a json file with the below structure, and save it in the same directory as the `index.Rmd` file (integer values in the goals section do not require quotation marks). Name the file `keys.json`. The dashboard will pick up these values when you run it.

```javascript
{
  "strava": {
    "app_name": "YOUR-APP-NAME",
    "client_id": "YOUR-CLIENT-ID",
    "client_secret": "YOUR-CLIENT-SECRET",
    "access_token": "YOUR-ACCESS-TOKEN"
  },
  "goals": {
    "yearly_km": YOUR-YEARLY-KM-GOAL,
    "monthly_km": YOUR-MONTHLY-KM-GOAL,
    "weekly_min": YOUR-MIN-GOAL
  },
  "athlete": {
    "birthdate": "YYYY-MM-DD"
  }
}
```
## 3. Usage
### 2.3 Run the dashboard locally
All dependencies are handled in the `install_packages.R` file. Set your working directory to the folder that contains `index.Rmd` an run these commands:

```r
setwd("your/path/strava-flex")
rmarkdown::run()
```

A browser window opens and you will be automatically authenticated with Strava, the dashboard appears in a new window.

### 2.4 Deploy to shinyapps.io
Create a shinyapps.io account and follow the instructions here: <https://docs.rstudio.com/shinyapps.io/getting-started.html#deploying-applications>.
**Note:** Any call to `install_packages()` will cause the deployment to fail. The shiny server will installs all packages referenced in a `library()` call. Then deploy the app with this command (use `forceUpdate` if you want to overwrite an existing app):

````r
rsconnect::setAccountInfo(
  name=<your-account-name>,
  token=<your-token>,
  secret=<your-secret>
)
rsconnect::deployApp(forceUpdate = TRUE)
````
