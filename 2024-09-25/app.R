library(shiny)

ui <- fluidPage(
  theme = bslib::bs_theme(version = 4),
  tags$head(
    tags$link(
      rel = "stylesheet",
      href = "custom.css"
    )
  ),
  titlePanel("Caixa de ferramentas do Shiny"),
  hr(),
  div(
    class = "mt-4",
    includeMarkdown("mtcars.md"),
  ),
  sidebarLayout(
    sidebarPanel(
      helpText("Selecione o tipo de gráfico, depois os parâmetros para gerar o gráfico escolhido."),
      selectInput(
        inputId = "tipo_grafico",
        label = "Tipo do gráfico",
        choices = c("Histograma" = "histograma", "Dispersão" = "dispersao")
      ),
      hr(),
      conditionalPanel(
        condition = "input.tipo_grafico == 'histograma'",
        varSelectInput(
          inputId = "variavel_histograma",
          label = "Variável",
          data = mtcars
        )
      ),
      conditionalPanel(
        condition = "input.tipo_grafico == 'dispersao'",
        varSelectInput(
          inputId = "varx_dispersao",
          label = "Variável eixo x",
          data = mtcars,
          selected = "wt"
        ),
        varSelectInput(
          inputId = "vary_dispersao",
          label = "Variável eixo y",
          data = mtcars
        )
      ),
      textInput(
        inputId = "titulo",
        label = "Título do gráfico",
        value = "Gráfico"
      )
    ),
    mainPanel(
      plotOutput(outputId = "grafico"),
      conditionalPanel(
        condition = "input.tipo_grafico == 'histograma'",
        helpText("O histograma mostra a distribuição da variável com relação aos seus possíveis valores.")
      ),
      conditionalPanel(
        condition = "input.tipo_grafico == 'dispersao'",
        helpText("O gráfico de dispersão mostra a relação entre as variáveis do eixo x e do eixo y.")
      ),
    )
  )
)

server <- function(input, output) {

  titulo <- reactive({
    input$titulo
  }) |> debounce(millis = 2000)

  shiny::withMathJax()

  output$grafico <- renderPlot({
    if (input$tipo_grafico == "histograma") {
      p <- mtcars |>
        ggplot2::ggplot() +
        ggplot2::geom_histogram(
          ggplot2::aes(x = !!input$variavel_histograma)
        )
    } else if (input$tipo_grafico == "dispersao") {
      
      # if (input$varx_dispersao == input$vary_dispersao) {
      #   showNotification(
      #     "Você deve escolher variáveis diferentes para o eixo x e y.",
      #     type = "error"
      #   )
      #   return(NULL)
      # } else {
      #   p <- mtcars |>
      #     ggplot2::ggplot() +
      #     ggplot2::geom_point(
      #       ggplot2::aes(
      #         x = !!input$varx_dispersao,
      #         y = !!input$vary_dispersao
      #       )
      #     )
      # }

      validate(need(
        input$varx_dispersao != input$vary_dispersao,
        "Você deve escolher variáveis diferentes para o eixo x e y."
      ))

      p <- mtcars |>
        ggplot2::ggplot() +
        ggplot2::geom_point(
          ggplot2::aes(
            x = !!input$varx_dispersao,
            y = !!input$vary_dispersao
          )
        )
    }

    p +
      ggplot2::labs(title = titulo())
  })
}

shinyApp(
  ui = ui,
  server = server,
  options = list(launch.browser = FALSE, port = 4242)
)
