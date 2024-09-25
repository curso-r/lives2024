library(shiny)

ui <- fluidPage(
  theme = bslib::bs_theme(version = 4),
  h2("Exemplo 1", class = "mb-4"),
  includeMarkdown("mtcars.md"),
  hr(),
  sidebarLayout(
    sidebarPanel(
      helpText(
        "Selecione o tipo de gráfico e, em seguida, as variáveis e o título.",
        class = "mb-4"
      ),
      selectInput(
        inputId = "tipo_grafico",
        label = "Selecione o tipo de gráfico",
        choices = c("Histograma" = "histograma", "Dispersão" = "dispersao")
      ),
      hr(),
      conditionalPanel(
        condition = "input.tipo_grafico == 'histograma'",
        varSelectInput(
          inputId = "var",
          label = "Variável",
          data = mtcars
        )
      ),
      conditionalPanel(
        condition = "input.tipo_grafico == 'dispersao'",
        varSelectInput(
          inputId = "var_x",
          label = "Variável X",
          data = mtcars,
          selected = "wt"
        ),
        varSelectInput(
          inputId = "var_y",
          label = "Variável Y",
          data = mtcars
        )
      ),
      textInput(
        inputId = "titulo",
        label = "Título",
        value = "Gráfico"
      )
    ),
    mainPanel(
      plotOutput("grafico")
    )
  )
)

server <- function(input, output) {
  titulo <- reactive({
    input$titulo
  }) |>
    debounce(1000)

  output$grafico <- renderPlot({
    if (input$tipo_grafico == "histograma") {
      p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = !!input$var)) +
        ggplot2::geom_histogram(bins = 30)
    } else {
      if (input$var_x == input$var_y) {
        showNotification(
          "As variáveis X e Y devem ser diferentes.",
          type = "error"
        )
        # validate(need(
        #   input$var_x != input$var_y,
        #   "As variáveis X e Y devem ser diferentes."
        # ))
      } else {
        p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = !!input$var_x, y = !!input$var_y)) +
          ggplot2::geom_point()
      }
    }

    p +
      ggplot2::labs(title = titulo())
  })
}

shinyApp(ui = ui, server = server, options = list(launch.browser = FALSE, port = 4242))
