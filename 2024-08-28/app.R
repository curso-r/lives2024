library(shiny)

i18n <- shiny.i18n::Translator$new(
  translation_json_path = here::here("2024-08-28/translation.json")
)
i18n$set_translation_language("br")

ui <- tagList(
  shiny.i18n::usei18n(i18n),
  bslib::page_navbar(
    title = i18n$t("Shiny com i18n"),
    bslib::nav_panel(
      title = i18n$t("Exemplo"),
      uiOutput("desc"),
      plotOutput("grafico")
    ),
    bslib::nav_spacer(),
    bslib::nav_item(
      bslib::popover(
        trigger = bsicons::bs_icon("translate"),
        radioButtons(
          inputId = "idioma",
          label = i18n$t("Escolha o idioma"),
          choices = c(
            "Português" = "br",
            "Inglês" = "en",
            "Francês" = "fr"
          )
        )
      )
    )
  )
)



server <- function(input, output, session) {
  observeEvent(input$idioma, {
    shiny.i18n::update_lang(
      input$idioma,
      session = session
    )
  })

  observeEvent(input$idioma, ignoreInit = TRUE, {
    if (input$idioma == "br") {
      opcoes <- c(
        "Português" = "br",
        "Inglês" = "en",
        "Francês" = "fr"
      )
    } else if (input$idioma == "en") {
      opcoes <- c(
        "Portuguese" = "br",
        "English" = "en",
        "French" = "fr"
      )
    } else {
      opcoes <- c(
        "Portugais" = "br",
        "Anglais" = "en",
        "Français" = "fr"
      )
    }
    updateRadioButtons(
      inputId = "idioma",
      choices = opcoes,
      selected = input$idioma
    )
  })

  output$desc <- renderUI({
    includeMarkdown(
      here::here(glue::glue("2024-08-28/md/desc_{input$idioma}.md"))
    )
  })

  output$grafico <- renderPlot({
    plot(1:10, main = i18n$t("Shiny com i18n"))
  })

}

shinyApp(ui, server)

# dia_semana_br
# dia_semana_en
# dia_semana_fr

# dplyr::select(com_idioma("dia_semana"))

# com_idioma <- function(nome_coluna, idioma) {
#   dplyr::one_of(glue::glue("{nome_coluna}_{idoma}"))
# }

