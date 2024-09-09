import pandas as pd
import numpy as np
import echarts as ec

dados = pd.read_csv("2024-08-12/pokemon.csv")

tab = dados. \
  query("id_geracao <= 4"). \
  assign(ataque_final = (dados["ataque"] + dados["ataque_especial"]) / 2). \
  assign(defesa_final = (dados["defesa"] + dados["defesa_especial"]) / 2). \
  filter(["ataque_final", "defesa_final"])

chart = ec.Echart("Pokémon")
chart.use(ec.Scatter("Ataque vs Defesa", data = tab.values))

chart.json
chart.plot()


toList(tab.values)
