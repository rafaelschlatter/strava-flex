library(shiny)

# Another hack here, embedd the whole markdown file in a shiny app.
# Seems to work nicely on shinyapps.io

shinyApp(
  ui = fluidPage(
    HTML('<meta name="viewport" content="width=1024">'),
    includeHTML(rmarkdown::render("index.Rmd"))),
  server = function(input, output) {
  }
)
