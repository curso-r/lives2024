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
    here::here("2024-07-08/dados_cadastrais.sqlite")
  )

  tab <- dplyr::tbl(con, "clientes") |>
    dplyr::collect()

  output$tabela <- DT::renderDataTable({
    tab |>
      DT::datatable(
        editable = TRUE
      )
  })

  proxy <- DT::dataTableProxy("tabela")

  observeEvent(input$tabela_cell_edit, {

    nova_tabela <- DT::editData(tab, input$tabela_cell_edit)

    DBI::dbWriteTable(con, "clientes", nova_tabela, overwrite = TRUE)

  })

}

shinyApp(ui, server)










