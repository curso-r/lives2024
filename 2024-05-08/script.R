install.packages("ggsoccer")


# Desenhar um campo de futebol no ggplot
ggplot2::ggplot() +
  ggsoccer::annotate_pitch()

# Tema para mostrar só o campo
ggplot2::ggplot() +
  ggsoccer::annotate_pitch() +
  ggsoccer::theme_pitch()


# Coordenadas do campo

ggsoccer::pitch_opta # padrão
ggsoccer::pitch_statsbomb

ggplot2::ggplot() +
  ggsoccer::annotate_pitch(dimensions = ggsoccer::pitch_statsbomb)

# Mostrar passes

tab_passes <- tibble::tibble(
  x_inicio = c(18, 78, 53),
  y_inicio = c(55, 18, 44),
  x_fim = c(44, 85, 64),
  y_fim = c(62, 44, 28)
)

tab_passes |>
  ggplot2::ggplot() +
  ggsoccer::annotate_pitch() +
  ggsoccer::theme_pitch() +
  ggplot2::geom_segment(
    ggplot2::aes(x = x_inicio, y = y_inicio, xend = x_fim, yend = y_fim),
    arrow = ggplot2::arrow(
      length = ggplot2::unit(0.15, "cm"),
      type = "closed"
    )
  )

tab_passes |>
  ggplot2::ggplot() +
  ggsoccer::annotate_pitch() +
  ggsoccer::theme_pitch() +
  ggplot2::geom_segment(
    ggplot2::aes(x = x_inicio, y = y_inicio, xend = x_fim, yend = y_fim),
    arrow = ggplot2::arrow(
      length = ggplot2::unit(0.25, "cm"),
      type = "closed"
    )
  ) +
  ggsoccer::direction_label()

# Podemos facilmente criar a nossa função

ggsoccer::direction_label

label_direcao <- function (x_label = 50, y_label = -3, label_length = 20,
                           colour = "dimgray", linewidth = 0.5,
                           linetype = "solid", text_size = 3, label = "Direction of play") {
  layer <- list(ggplot2::annotate("segment", x = x_label - (label_length/2),
                                  y = y_label, xend = x_label + (label_length/2), yend = y_label,
                                  arrow = ggplot2::arrow(length = ggplot2::unit(0.02, "npc"), type = "closed"),
                                  colour = colour, linetype = linetype, linewidth = linewidth),
                ggplot2:: annotate("text", x = x_label, y = y_label - 1, label = label,
                                   vjust = 1.5, size = text_size, colour = colour))
  return(layer)
}

tab_passes |>
  ggplot2::ggplot() +
  ggsoccer::annotate_pitch() +
  ggsoccer::theme_pitch() +
  ggplot2::geom_segment(
    ggplot2::aes(x = x_inicio, y = y_inicio, xend = x_fim, yend = y_fim),
    arrow = ggplot2::arrow(
      length = ggplot2::unit(0.25, "cm"),
      type = "closed"
    )
  ) +
  label_direcao(label = "Ataque")

# Mostrar passes + condução

tab_conducao <- tibble::tibble(
  x_inicio = c(44, 64),
  y_inicio = c(62, 28),
  x_fim = c(53, 78),
  y_fim = c(44, 18)
)

tab_passes |>
  ggplot2::ggplot() +
  ggsoccer::annotate_pitch() +
  ggsoccer::theme_pitch() +
  ggplot2::geom_segment(
    ggplot2::aes(x = x_inicio, y = y_inicio, xend = x_fim, yend = y_fim),
    arrow = ggplot2::arrow(
      length = ggplot2::unit(0.25, "cm"),
      type = "closed"
    )
  ) +
  ggplot2::geom_segment(
    data = tab_conducao,
    ggplot2::aes(x = x_inicio, y = y_inicio, xend = x_fim, yend = y_fim),
    linetype = 3
  ) +
  ggsoccer::direction_label()

# Mostrar chutes

tab_chutes <- data.frame(
  x = c(90, 85, 82, 78, 83, 74, 94, 91),
  y = c(43, 40, 52, 56, 44, 71, 60, 54)
)

tab_chutes |>
  ggplot2::ggplot() +
  ggsoccer::annotate_pitch() +
  ggsoccer::theme_pitch() +
  ggplot2::geom_point(
    ggplot2::aes(x = x, y = y),
    color = "red",
    size = 3
  )


# Podemos usar as funções do ggplot à vontade

tab_chutes |>
  ggplot2::ggplot() +
  ggsoccer::annotate_pitch() +
  ggsoccer::theme_pitch() +
  ggplot2::geom_point(
    ggplot2::aes(x = x, y = y),
    color = "red",
    size = 3
  ) +
  ggplot2::coord_flip() +
  ggplot2::scale_y_reverse()


tab_chutes |>
  ggplot2::ggplot() +
  ggsoccer::annotate_pitch() +
  ggsoccer::theme_pitch() +
  ggplot2::geom_point(
    ggplot2::aes(x = x, y = y),
    color = "red",
    size = 3
  ) +
  ggplot2::coord_flip(xlim = c(49, 101)) +
  ggplot2::scale_y_reverse()


tab_chutes |>
  ggplot2::ggplot() +
  ggsoccer::annotate_pitch(fill = "darkgreen", colour = "white") +
  ggsoccer::theme_pitch() +
  ggplot2::geom_point(
    ggplot2::aes(x = x, y = y),
    color = "orange",
    size = 3
  ) +
  ggplot2::coord_flip(xlim = c(49, 101)) +
  ggplot2::scale_y_reverse()















