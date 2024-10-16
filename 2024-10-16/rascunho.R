res <- tidygeocoder::geo(
  street = "Av Paulista, 302",
  city = "Sao Paulo",
  state = "SP",
  postalcode = "01310000",
  country = "Brasil"
)

res

res |>
  leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::addMarkers(
    lng = ~long,
    lat = ~lat
  )

########


res <- tidygeocoder::geo(
  address = "Av Paulista, 302, Sao Paulo, SP, 01310000, Brasil"
)

res |>
  leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::addMarkers(
    lng = ~long,
    lat = ~lat
  )

####

res <- tidygeocoder::geo(
  address = "Av Paulista, 302"
)

res |>
  leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::addMarkers(
    lng = ~long,
    lat = ~lat
  )

###

endereco_origem <- "Av Paulista, 302, Sao Paulo, SP, 01310000, Brasil"
endereco_destino <- "Estadio do Morumbi, São Paulo, SP,"

origem <- tidygeocoder::geo(
  address = endereco_origem
)

destino <- tidygeocoder::geo(
  address = endereco_destino
)

origem |>
  dplyr::bind_rows(destino) |>
  leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::addMarkers(
    lng = ~long,
    lat = ~lat
  )

url <- paste0(
  "http://router.project-osrm.org/route/v1/car/",
  origem$long,
  ",",
  origem$lat,
  ";",
  destino$long,
  ",",
  destino$lat
)

rota <- rjson::fromJSON(file = url)

tab_rota <- googleway::decode_pl(
  rota$routes[[1]]$geometry
)

leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::addPolylines(
    data = tab_rota,
    lng = ~lon,
    lat = ~lat
  ) |>
  leaflet::addMarkers(
    lng = origem$long,
    lat = origem$lat,
    popup = endereco_origem
  ) |>
  leaflet::addMarkers(
    lng = destino$long,
    lat = destino$lat,
    popup = endereco_destino
  )
