library(shiny)

ui <- bslib::page_navbar(
  title = "Hide navset",
  underline = FALSE,
  bg = "black",
  fillable = FALSE,
  bslib::nav_spacer(),
  bslib::nav_item(
    tags$a(
      href = "https://github.com/curso-r/lives2024",
      bsicons::bs_icon("github"),
      target = "_blank"
    )
  ),
  bslib::nav_panel_hidden(
    value = "pagina_principal",
    bslib::navset_hidden(
      id = "navegacao_escondida",
      bslib::nav_panel_hidden(
        value = "pagina_1",
        h2("Página 1"),
        hr(),
        bslib::layout_columns(
          col_width = c(4, 8),
          selectInput(
            inputId = "variavel_1",
            label = "Variável",
            choices = names(mtcars),
            width = "200px"
          ),
          plotOutput("grafico_1")
        ),
        hr(),
        bslib::layout_columns(
          col_widths = c(-10, 2),
          actionButton(
            inputId = "pag_1_2",
            label = "Ir para página 2"
          )
        )
      ),
      bslib::nav_panel_hidden(
        value = "pagina_2",
        h2("Página 2"),
        hr(),
        bslib::layout_columns(
          col_widths = c(2, 2, 8),
          selectInput(
            inputId = "variavel_2_x",
            label = "Variável x",
            choices = names(mtcars),
            width = "100%"
          ),
          selectInput(
            inputId = "variavel_2_y",
            label = "Variável y",
            choices = names(mtcars),
            width = "100%"
          ),
          plotOutput("grafico_2")
        ),
        hr(),
        bslib::layout_columns(
          col_widths = c(-7, 2, -1, 2),
          actionButton(
            inputId = "pag_2_1",
            label = "Ir para página 1"
          ),
          actionButton(
            inputId = "pag_2_3",
            label = "Ir para página 3"
          )
        )
      ),
      bslib::nav_panel_hidden(
        value = "pagina_3",
        h2("Página 3"),
        hr(),
        img(
          src = "https://s2-ge.glbimg.com/dbd9D43IIFEi2CwAlksmH_9zrnk=/0x0:2048x1152/1080x608/smart/filters:max_age(3600)/https://i.s3.glbimg.com/v1/AUTH_bc8228b6673f488aa253bbcb03c80ec5/internal_photos/bs/2024/1/9/6aGn3uTwexKtBAj7g0Dg/53833501956-c62b645628-k.jpg",
          style = "max-height: 400px;"
        ),
        hr(),
        bslib::layout_columns(
          col_widths = c(-10, 2),
          actionButton(
            inputId = "pag_3_2",
            label = "Ir para página 2"
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {

  # Página 1

  output$grafico_1 <- renderPlot({
    plot(x = mtcars[[input$variavel_1]], y = mtcars[["mpg"]])
  })

  observeEvent(input$pag_1_2, {
    bslib::nav_select(
      id = "navegacao_escondida",
      selected = "pagina_2",
    )
  })

  # Página 2

  output$grafico_2 <- renderPlot({
    plot(
      x = mtcars[[input$variavel_2_x]],
      y = mtcars[[input$variavel_2_y]]
    )
  })

  # observeEvent(input$pag_2_1, {
  #   bslib::nav_select(
  #     id = "navegacao_escondida",
  #     selected = "pagina_1"
  #   )
  # })

  # observeEvent(input$pag_2_3, {
  #   bslib::nav_select(
  #     id = "navegacao_escondida",
  #     selected = "pagina_3"
  #   )
  # })

  # Página 3

  # observeEvent(input$pag_3_2, {
  #   bslib::nav_select(
  #     id = "navegacao_escondida",
  #     selected = "pagina_2"
  #   )
  # })

  purrr::walk2(
    c("pag_1_2", "pag_2_1", "pag_2_3", "pag_3_2"),
    c("pagina_2", "pagina_1", "pagina_3", "pagina_2"),
    ~ observeEvent(input[[.x]], {
      bslib::nav_select(
        id = "navegacao_escondida",
        selected = .y
      )
    })
  )


}

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4242))
