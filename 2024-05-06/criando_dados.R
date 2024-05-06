dados <- readr::read_csv("2024-05-06/dados.csv")


dados |>
  dplyr::group_by(season) |>
  tidyr::nest() |>
  tibble::deframe() |>
  writexl::write_xlsx(path = "2024-05-06/dados.xlsx")
