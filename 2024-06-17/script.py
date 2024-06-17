import pandas as pd
import numpy as np

dados = pd.read_csv("2024-06-17/dados.csv")
times = pd.read_csv("2024-06-17/times.csv")

dados_2023 = dados.query("season == 2023")

pd.merge(dados_2023, times, how = "left", left_on = "home", right_on = "team")

dados_2023. \
  groupby("home", as_index = False). \
  agg(date = ("date", "max")). \
  merge(
    dados_2023.filter(["home", "date", "score", "away"]), 
    how = "left", 
    on = ["home", "date"]
  ). \
  merge(
    times,
    left_on = "home",
    right_on = "team",
    how = "left"
  ). \
  merge(
    times,
    left_on = "away",
    right_on = "team",
    how = "left",
    suffixes = ("_home", "_away")
  )
  
times_2023 = dados_2023.home.unique()
times.query("team in @times_2023")
times.query("team not in @times_2023")


