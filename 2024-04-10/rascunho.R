library(shiny)

imagens <- list.files("www")

ui <- bslib::page_navbar(
  title = "Shiny + Mansory",
  underline = FALSE,
  bslib::nav_panel(
    title = "Sem mansory",
    tags$head(
      tags$script(
        src = "https://cdn.jsdelivr.net/npm/masonry-layout@4.2.2/dist/masonry.pkgd.min.js",
        integrity = "sha384-GNFwBvfVxBkLMJpYMOABq3c+d3KnQxudP/mGPkzpZSTYykLBNsZEnG2D9G/X/+7D",
        crossorigin = "anonymous",
        async = ""
      )
    ),
    fluidRow(
      purrr::map(
        imagens,
        ~ column(
          width = 3,
          img(
            src = .x,
            width = glue::glue("{runif(1, 50, 200)}px"),
            style = "margin: auto; display: block;"
          )
        )
      )
    )
  ),
  bslib::nav_panel(
    title = "Com mansory",
    uiOutput("figuras")
  ),
  bslib::nav_spacer(),
  bslib::nav_item(
    tags$a(
      href = "https://github.com/williamorim/portfolio/tree/main/mansory",
      target = "_blank",
      bsicons::bs_icon("github")
    )
  )
)

server <- function(input, output) {

  output$figuras <- renderUI({
    tagList(
      fluidRow(
        id = "conteudoMansory",
        purrr::map(
          imagens,
          ~ column(
            width = 3,
            img(
              src = .x,
              width = glue::glue("{runif(1, 50, 200)}px"),
              style = "margin: auto; display: block;"
            )
          )
        )
      ),
      tags$script(
        "$('#conteudoMansory').masonry({
           percentPosition: true,
      });"
      )
    )

  })

}

shinyApp(ui = ui, server = server, options = list(launch.browser = FALSE, port = 4242))
