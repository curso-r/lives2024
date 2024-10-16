tab <- tidygeocoder::geo(
  street = "Av Paulista, 302",
  city = "Sao Paulo",
  state = "SP",
  country = "Brazil"
)

tab |>
  leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::addMarkers(
    lng = tab$long,
    lat = tab$lat
  )

####

tab <- tidygeocoder::geo(
  address = "Av Paulista, 302, Sao Paulo, SP, Brazil"
)

tab |>
  leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::addMarkers(
    lng = tab$long,
    lat = tab$lat
  )

###

tab <- tidygeocoder::geo(
  address = "Estadio Morumbi, Sao Paulo, SP, Brazil"
)

tab |>
  leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::addMarkers(
    lng = tab$long,
    lat = tab$lat
  )

###

endereco_origem <- "Av Paulista, 302, Sao Paulo, SP, Brazil"
endereco_destino <- "Estadio Morumbi, Sao Paulo, SP, Brazil"

origem <- tidygeocoder::geo(address = endereco_origem)
destino <- tidygeocoder::geo(address = endereco_destino)

tab <- dplyr::bind_rows(origem, destino)

tab |>
  leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::addMarkers(
    lng = tab$long,
    lat = tab$lat
  )

url <- glue::glue(
  "http://router.project-osrm.org/route/v1/driving/{origem$long},{origem$lat};{destino$long},{destino$lat}"
)

rota <- rjson::fromJSON(file = url)

rota$routes[[1]]$distance

tab_rota <- googleway::decode_pl(rota$routes[[1]]$geometry)

tab_rota |>
  leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::addPolylines(
    lng = ~lon,
    lat = ~lat
  ) |>
  leaflet::addMarkers(
    data = tab,
    lng = tab$long,
    lat = tab$lat
  )


####

# Para fazer em loop, não esquecer de esperar um segundo
for (i in 1:nrow(sua_base)) {
  tab <- tidygeocoder::geo(
    address = "Av Paulista, 302, Sao Paulo, SP, Brazil"
  )
  tab_completa <- rbind(tab, tab_completa)
  Sys.sleep(1)
}