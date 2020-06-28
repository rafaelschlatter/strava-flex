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


df_2 <- subset(df, type != "Workout")
df_3 <- subset(df_2, external_id != "NA")
df_4 <- subset(df_3, start_latitude != "NA")
all_ids <- df_4$id

df2 <- data.frame(
  altitude=double(),
  lat=double(),
  lng=double(),
  id=integer()
)


for (id in all_ids){
  stream <- get_streams(stoken, id=id)
  print(id)
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
  addMiniMap(
    tiles=providers$CartoDB.Positron
  ) %>%
  addLayersControl(
    baseGroups = c("Day", "Night"),
    #overlayGroups = c("Activities", "Animal sightings"),
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
  strava_map <- addPolylines(strava_map, lng=data$lng, lat=data$lat , color="red", opacity=1/2, weight=2, group="Activities")
  strava_map <- addPolylines(strava_map, lng=data$lng, lat=data$lat , color="blue", opacity=1/3, weight=1, group="Activities")
}

strava_map
