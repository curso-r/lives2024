library(shiny)

ui <- bslib::page_sidebar(
  fillable = FALSE,
  sidebar = bslib::sidebar(
    selectInput(
      inputId = "variavel",
      label = "Variável",
      choices = names(mtcars)
    )
  ),
  plotOutput("grafico")
)

server <- function(input, output, session) {

  output$grafico <- renderPlot({
    plot(x = mtcars[[input$variavel]], y = mtcars$mpg)
  })

}

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4242))
