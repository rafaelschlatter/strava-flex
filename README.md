# strava-flex

## 1. Description
A flex dashboard to visualize your Strava activities.
![screenshot](https://github.com/rafaelschlatter/strava-flex/resources/screenshot.jpeg)

## 2. Usage
### 2.1 Register app with Strava
To run the dasboard with your Strava data you need to register and API application with Strava.  

To do so, follow the instructions here (step 1 and 2):  
<https://medium.com/@annthurium/getting-started-with-the-strava-api-a-tutorial-f3909496cd2d>

### 2.2 Create `keys.json` file
Create a json file with the below structure, and save it in the same directory as the `strava_flex.Rmd` file (integer values in the goals section do not require quotation marks). Name the file `keys.json`. The dashboard will pick up these values when you run it.

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
  }
}
```

### 2.3 Run the dashboard
All dependencies are handled in the `install_packages.R` file. Set your working directory to the folder that contains `index.Rmd` an run:

```r
rmarkdown::run()
```


