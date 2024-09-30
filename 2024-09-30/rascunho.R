bslib::nav_item(
  tagList(
    htmltools::span(
      class = paste(
        "lang-choice",
        ifelse(language_selected == "en", "lang-active", "")
      ),
      id = "lang-en",
      onclick = "Shiny.setInputValue('language', 'en')",
      "EN"
    ),
    htmltools::span(" | "),
    htmltools::span(
      class = paste(
        "lang-choice",
        ifelse(language_selected == "es", "lang-active", "")
      ),
      onclick = "Shiny.setInputValue('language', 'es')",
      "ES"
    ),
    htmltools::span(" | "),
    htmltools::span(
      class = paste(
        "lang-choice",
        ifelse(language_selected == "br", "lang-active", "")
      ),
      onclick = "Shiny.setInputValue('language', 'br')",
      "PT"
    ),
    htmltools::tags$script(src = "assets/lang_widget.js"),
  )
)
