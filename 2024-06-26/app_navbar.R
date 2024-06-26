library(shiny)

ui <- bslib::page_navbar(
  title = "bslib navbar",
  fillable = FALSE,
  bslib::nav_panel(
    title = "Página 1",
    h2("Conteúdo da página 1"),
    hr(),
    p("texto")
  ),
  bslib::nav_panel(
    title = "Página 2",
    bslib::layout_sidebar(
      sidebar = bslib::sidebar(
        selectInput(
          inputId = "variavel",
          label = "Variável",
          choices = names(mtcars)
        )
      ),
      h2("Conteúdo da página 2"),
      hr(),
      p("texto")
    )
  ),
  bslib::nav_panel(
    title = "Página 3",
    h2("Conteúdo da página 3"),
    hr(),
    p("texto")
  ),
  bslib::nav_menu(
    title = "Várias páginas",
    bslib::nav_panel(
      title = "Página 4",
      h2("Conteúdo da página 4"),
      hr(),
      p("texto")
    ),
    bslib::nav_panel(
      title = "Página 5",
      h2("Conteúdo da página 5"),
      hr(),
      p("texto")
    )
  )
)

server <- function(input, output, session) {

}

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4242))
