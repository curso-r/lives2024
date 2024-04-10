library(shiny)

imagens <- list.files(path = here::here("2024-04-10/www/"))

ui <- bslib::page_navbar(
  title = "Shiny + Mansory",
  bslib::nav_panel(
    title = "Sem mansory",
    bslib::layout_columns(
      col_widths = rep(3, 15),
      !!!purrr::map(
        imagens,
        ~ img(
          src = .x,
          width = glue::glue("{runif(1, 50, 200)}px"),
          style = "display: block; margin: auto;"
        )
      )

    )
  ),
  bslib::nav_panel(
    title = "Com mansory",
    tags$head(
      tags$script(
        src = "https://cdn.jsdelivr.net/npm/masonry-layout@4.2.2/dist/masonry.pkgd.min.js",
        integrity = "sha384-GNFwBvfVxBkLMJpYMOABq3c+d3KnQxudP/mGPkzpZSTYykLBNsZEnG2D9G/X/+7D",
        crossorigin = "anonymous",
        async = ""
      )
    ),
    uiOutput("imagens")
  )
)

server <- function(input, output, session) {

  output$imagens <- renderUI({
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
              style = "display: block; margin: auto;"
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

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4242))











