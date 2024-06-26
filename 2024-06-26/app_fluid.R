# bootstrap
# shinydashboard::
# bs4Dash::
# bslib::

# theme = bslib::bs_theme(version = 5)

library(shiny)

ui <- bslib::page_fluid(
  bslib::layout_columns(
    col_widths = c(3, 4, 5),
    h2("Este é o meu app"),
    tagList(
      p("Um texto qualquer"),
      p("Outro texto qualquer"),
    ),
    img(
      src = "https://getbootstrap.com/docs/5.3/assets/brand/bootstrap-logo-shadow.png"
    )
  )
)

server <- function(input, output, session) {

}

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4242))
