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
        inputId = "cadastrar",
        label = "Cadastrar"
      )
    ),
    mainPanel(
      DT::dataTableOutput("tabela"),
      br(),
      br(),
      div(
        class = "pull-right",
        actionButton(
          inputId = "salvar_alteracoes",
          label = "Salvar alterações"
        )
      )
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

  tab_rv <- reactiveVal(tab)

  output$tabela <- DT::renderDataTable({
    tab |>
      DT::datatable(
        editable = TRUE
      )
  })

  proxy <- DT::dataTableProxy("tabela")

  observeEvent(input$tabela_cell_edit, {

    nova_tabela <- DT::editData(tab_rv(), input$tabela_cell_edit)

    tab_rv(nova_tabela)

    DT::replaceData(proxy, nova_tabela)

  })

  observeEvent(input$salvar_alteracoes, {

    DBI::dbWriteTable(con, "clientes", tab_rv(), overwrite = TRUE)

    shinyalert::shinyalert(
      title = "Sucesso!",
      text = "Suas alterações foram realizadas.",
      type = "success"
    )

  })

  observeEvent(input$cadastrar, {

    nova_linha <- tibble::tibble(
      nome = input$nome,
      email = input$email,
      data_nascimento = as.character(input$data_nascimento)
    )

    nova_tabela <- tab_rv() |>
      dplyr::bind_rows(nova_linha)

    DBI::dbWriteTable(con, "clientes", nova_tabela, overwrite = TRUE)

    DT::replaceData(proxy, nova_tabela)

    tab_rv(nova_tabela)

    shinyalert::shinyalert(
      title = "Sucesso!",
      text = "A pessoa foi cadastra no banco.",
      type = "success"
    )

  })


}

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4242))










