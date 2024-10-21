import pandas as pd
import numpy as np

# read_csv

dados = pd.read_csv("shiny-python/matches.csv")

# filter (dplyr::select)

dados.filter(["score", "home", "away"])

# query (dplyr::filter)

dados.query("season == 2024")

temporada = 2024
dados.query("season == @temporada")

# sort_values (dplyr::arrange)

dados.sort_values(by = "home")
dados.sort_values(by = ["home", "date"])

# assign (dplyr::mutate)

dados.assign(novo_id = dados["id_match"] + 1)

dados.assign(
  num_gols_mandante = dados["score"].apply(lambda y: y.split(sep = "x")[0])
)

# groupby + agg (dplyr::group_by + dplyr::summarise)

dados.groupby("season").agg({"season": "count"})
dados.groupby("season", as_index = False).agg(num_jogos = ("season", "count"))

# merge (dplyr::left_join)

pd.merge(
  dados.filter(["id_match", "home"]),
  dados.filter(["id_match", "away"]),
  on = "id_match"
)
