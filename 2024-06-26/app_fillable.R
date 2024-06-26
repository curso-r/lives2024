library(shiny)

ui <- bslib::page_fillable(
  bslib::layout_columns(
    col_widths = c(3, 3, 6, 4, 8),
    bslib::card(
      "Card 1"
    ),
    bslib::card(
      "Card 2"
    ),
    bslib::card(
      "Card 3"
    ),
    bslib::card(
      "Card 4"
    ),
    bslib::card(
      "Card 5"
    )
  )
)

server <- function(input, output, session) {

}

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4242))
