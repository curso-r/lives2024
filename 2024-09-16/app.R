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
      tags$head(
        tags$link(rel = "stylesheet", href = "custom.css")
      ),
      title = i18n$t("Exemplo"),
      uiOutput("desc"),
      plotOutput("grafico")
    ),
    bslib::nav_spacer(),
    bslib::nav_item(
      tagList(
        span(
          class = "lang-option lang-active",
          "PT",
          onclick = "Shiny.setInputValue('idioma', 'br')"
        ),
        span(" | "),
        span(
          class = "lang-option",
          "EN",
          onclick = "Shiny.setInputValue('idioma', 'en')"
        ),
        span(" | "),
        span(
          class = "lang-option",
          "FR",
          onclick = "Shiny.setInputValue('idioma', 'fr')"
        ),
        tags$script(src = "script.js")
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

  idioma <- reactive({
    if (is.null(input$idioma)) {
      idioma <- "br"
    } else {
      input$idioma
    }
  })

  output$desc <- renderUI({
    includeMarkdown(
      here::here(glue::glue("2024-08-28/md/desc_{idioma()}.md"))
    )
  })

  output$grafico <- renderPlot({
    plot(1:10, main = i18n$t("Shiny com i18n"))
  })
}

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4242))

# dia_semana_br
# dia_semana_en
# dia_semana_fr

# dplyr::select(com_idioma("dia_semana"))

# com_idioma <- function(nome_coluna, idioma) {
#   dplyr::one_of(glue::glue("{nome_coluna}_{idoma}"))
# }
