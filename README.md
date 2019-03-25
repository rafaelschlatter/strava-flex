# strava-flex

## Description
A flex dashboard to visualize your Strava activities.

## Usage
To run the dasboard with your Strava data you need to register and API application with Strava.  

To do so, follow the instructions here (step 1 and 2):  
<https://medium.com/@annthurium/getting-started-with-the-strava-api-a-tutorial-f3909496cd2d>

Create a json file with the below structure, and save it in the same directory as the `strava_flex.Rmd` file (integer values in the goals section do not require quotation marks). The dashboard will pick up these values when you run it.

```javascript
{
  "strava": {
    "app_name": "YOUR-APP-NAME",
    "client_id": "YOUR-CLIENT-ID",
    "client_secret": "YOUR-CLIENT-SECRET",
    "access_token": "YOUR-ACCESS-TOKEN"
  },
  "goals": {
    "yearly_km": YOUR-KM-GOAL,
    "weekly_min": YOUR-MIN-GOAL
  }
}
```
