library(shiny)

i18n <- shiny.i18n::Translator$new(translation_json_path = here::here("2024-08-28/translation.json"))
i18n$set_translation_language("br")

ui <- fluidPage(
  shiny.i18n::usei18n(i18n),
  i18n$t("Shiny com i18n"),
  shiny::selectInput("language", "Idioma", choices = c("br", "en", "fr"))
)

server <- function(input, output, session) {

  # language <- reactiveVal("br")

  observeEvent(input$language, {
    shiny.i18n::update_lang(
      session = session,
      language = input$language
    )
    # language(input$language)
  })
  
}

shinyApp(ui, server)