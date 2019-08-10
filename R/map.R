library(leaflet)

compile_activity_streams <- function(streams, id = NULL){
  
  if (!is.null(id) && length(id) != 1) {
    stop('id must be a scalar or NULL.')
  }
  
  # Remove 'resolution', 'series_type', 'original_size' columns from stream contents
  tmp <- streams %>% 
    purrr::transpose(.) %>% 
    tibble::as.tibble() %>% 
    dplyr::select(type, data) %>% 
    dplyr::mutate(type = unlist(type))
  
  # Expand data column to columns removing one layer of lists
  tmp.wide <- tmp %>% 
    tidyr::spread(data = ., key = type, value = data) %>% 
    tidyr::unnest()
  
  # Or:
  # tmp.wide <- x %>% map_dfc(~ tibble(data = pluck(.x, 'data')) %>% set_names(pluck(.x, 'type')))
  
  # Deal with latitude-longitude field separately
  if ('latlng' %in% colnames(tmp.wide)) {
    
    # Remove singletons (list-columns with 1-long lists)
    df.wide <- tmp.wide %>% 
      tidyr::unnest(.preserve = latlng)
    
    # Assign names to latlng field
    f.latlng.to.df <- function(x) {
      purrr::set_names(x, nm = c('lat', 'lng')) %>% 
        tibble::as.tibble()
    }
    
    # and unnest to columns
    df.stream <- df.wide %>% 
      dplyr::mutate(latlng = purrr::map(latlng, f.latlng.to.df)) %>% 
      tidyr::unnest(latlng)
    
  } else {
    df.stream <- tmp.wide %>% 
      tidyr::unnest()
  }
  
  if (!is.null(id)) {
    df.stream %>% dplyr::mutate(id = id)
  } else {
    df.stream  
  }
}

all_ids <- df$id

df2 <- data.frame(
  altitude=double(),
  lat=double(),
  lng=double(),
  id=integer()
)


for (id in all_ids){
  stream <- get_streams(stoken, id=id)
  compiled_stream <- compile_activity_streams(stream)
  compiled_stream$id <- rep(id, nrow(compiled_stream))
  subset_df <- subset(compiled_stream, select=c("altitude", "lat", "lng", "id"))
  df2 <- rbind(df2, subset_df)
}

write.csv(df2, "data/df2.csv")
csv <- read.csv("data/df2.csv")

strava_map <- leaflet() %>%
  addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', group="Night") %>%
  addProviderTiles(providers$CartoDB.Positron, group="Day") %>%
  addMarkers(
    lng=10.757820,
    lat=59.980426,
    popup="Deer, 3.8.2019",
    label="Deer",
    group="Animal sightings"
  ) %>%
  addMarkers(
    lng=10.760199,
    lat=59.980003,
    popup="Deer, 3.8.2019",
    label="Deer",
    group="Animal sightings"
  ) %>%
  addMarkers(
    lng=10.722723,
    lat=59.974511,
    popup="Deer, 17.6.2019",
    label="Deer",
    group="Animal sightings"
  ) %>%
  addMarkers(
    lng=10.685896,
    lat=59.989332,
    popup="Deer, 12.7.2019",
    label="Deer",
    group="Animal sightings"
  ) %>%
  addMarkers(
    lng=10.721030,
    lat=59.971683,
    popup="Common adder, 20.7.2019",
    label="Common adder",
    group="Animal sightings"
  ) %>%
  addMarkers(
    lng=10.774640,
    lat=60.016072,
    popup="Common adder, 29.7.2019",
    label="Common adder",
    group="Animal sightings"
  ) %>%
  addMarkers(
    lng=10.720636,
    lat=60.017274,
    popup="Beaver, 12.7.2019",
    label="Beaver",
    group="Animal sightings"
  ) %>%
  addMarkers(
    lng=29.865990,
    lat=66.131462,
    popup="Brown bears, 26.6.2019",
    label="Brown bears",
    group="Animal sightings"
  ) %>%
  addMarkers(
    lng=29.121397,
    lat=66.168220,
    popup="Rendeers, 28.6.2019",
    label="Rendeers",
    group="Animal sightings"
  ) %>%
  addMarkers(
    lng=29.858714,
    lat=66.132046,
    popup="White tailed eagle, 26.6.2019",
    label="White tailed eagle",
    group="Animal sightings"
  ) %>%
  addMiniMap(
    tiles=providers$CartoDB.Positron
  ) %>%
  addLayersControl(
    baseGroups = c("Day", "Night"),
    overlayGroups = c("Activities", "Animal sightings"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  setView(10.728123, 59.96588, zoom=11) %>%
  addEasyButton(
    easyButton(
      icon="fa-globe", title="Zoom to Level 1",
      onClick=JS("function(btn, map){ map.setZoom(4); }")
    )
  ) %>%
  addEasyButton(
    easyButton(
      icon="fa-crosshairs", title="Locate Me",
      onClick=JS("function(btn, map){ map.locate({setView: true}); }")
    )
  )

for (id in all_ids){
  data <- csv[csv$id == id, ]
  strava_map <- addPolylines(strava_map, lng=data$lng, lat=data$lat , color="red", opacity=1/2, weight=1.5, group="Activities")
  strava_map <- addPolylines(strava_map, lng=data$lng, lat=data$lat , color="blue", opacity=1/3, weight=1, group="Activities")
}

strava_map
