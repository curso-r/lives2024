library(shiny)

ui <- fluidPage(
  titlePanel("Tabela editável"),
  sidebarLayout(
    sidebarPanel(
      textInput(
        inputId = "nome",
        label = "Nome",
        value = ""
      ),
      textInput(
        inputId = "email",
        label = "E-mail",
        value = ""
      ),
      dateInput(
        inputId = "data_nascimento",
        label = "Data de nascimento",
        value = Sys.Date()
      ),
      actionButton(
        inputId = "botao",
        label = "Cadastrar"
      )
    ),
    mainPanel(
      DT::dataTableOutput("tabela")
    )
  )
)

server <- function(input, output, session) {

  con <- DBI::dbConnect(
    RSQLite::SQLite(),
    "dados_cadastrais.sqlite"
  )

  tab <- dplyr::tbl(con, "clientes") |>
    dplyr::collect()

  dados <- reactiveVal(tab)

  observeEvent(input$botao, {
    novo_dado <- data.frame(
      nome = input$nome,
      email = input$email,
      data_nascimento = input$data_nascimento
    )
    dados(rbind(dados(), novo_dado))
  })

  output$tabela <- DT::renderDT({
    dados() |>
      DT::datatable(
        editable = TRUE
      )
  })

  proxy = DT::dataTableProxy('tabela')

  observeEvent(input$tabela_cell_edit, {
    nova_tabela <- DT::editData(dados(), input$tabela_cell_edit)
    dados(nova_tabela)
    DT::replaceData(proxy, nova_tabela, resetPaging = FALSE)
  })

}

shinyApp(ui, server)
