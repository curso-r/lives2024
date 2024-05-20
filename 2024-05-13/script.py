import pandas as pd
import numpy as np
import seaborn as sb
import plotnine as pn
import matplotlib.pyplot as plt

# Fazer gráfico do número de pontos acumulados de um time

def pegar_gols_mandante(s) :
  return s.split(sep = "x")[0]

def pegar_gols_visitante(s) :
  return s.split(sep = "x")[1]

def calcular_pontos_mandante(gols_mand, gols_vis) :
  if gols_mand > gols_vis:
    return 3
  elif gols_mand == gols_vis:
    return 1
  else:
    return 0

def grafico_pts_acumulados(dados, temporada, time, type = "sb"):
  dados_temporada = dados.query("season == @temporada")
  gols_mandante = np.array([0] * len(dados_temporada))
  gols_visitante = np.array([0] * len(dados_temporada))
  for i in range(len(dados_temporada["score"])) :
    gols_mandante[i] = pegar_gols_mandante(dados_temporada["score"].iloc[i])
  for i in range(len(dados_temporada["score"])) :
    gols_visitante[i] = pegar_gols_visitante(dados_temporada["score"].iloc[i])
  dados_temporada["num_gols_mandante"] = gols_mandante  
  dados_temporada["num_gols_visitante"] = gols_visitante 
  num_pontos_mandante = np.array([0] * len(dados_temporada))
  num_pontos_visitante = np.array([0] * len(dados_temporada))
  for i in range(len(dados_temporada["score"])) :
    num_pontos_mandante[i] = calcular_pontos_mandante(
      dados_temporada["num_gols_mandante"].iloc[i],
      dados_temporada["num_gols_visitante"].iloc[i]
    )
  for i in range(len(dados_temporada["score"])) :
    num_pontos_visitante[i] = calcular_pontos_mandante(
      dados_temporada["num_gols_visitante"].iloc[i],
      dados_temporada["num_gols_mandante"].iloc[i]
    )
  dados_temporada["pontos_mandante"] = num_pontos_mandante
  dados_temporada["pontos_visitante"] = num_pontos_visitante
  pontos_time_mandante = dados_temporada.query("home == @time")[["date", "pontos_mandante"]]
  pontos_time_visitante = dados_temporada.query("away == @time")[["date", "pontos_visitante"]]
  pontos_time_mandante = pontos_time_mandante.rename(columns={"pontos_mandante": "pontos"})
  pontos_time_visitante = pontos_time_visitante.rename(columns={"pontos_visitante": "pontos"})
  dados_pontos = pd.concat([pontos_time_mandante, pontos_time_visitante]).sort_values(by = "date")
  dados_pontos["pontos_acumulados"] = np.array(dados_pontos["pontos"].cumsum())
  dados_pontos["num_partida"] = np.array(range(1, len(dados_pontos) + 1))
  if type == "sb":
    sb.relplot(
      data = dados_pontos,
      kind = "line",
      x = "num_partida", 
      y = "pontos_acumulados"
    )
    plt.show()
  elif type == "pn":
    p = (
      pn.ggplot(dados_pontos)
      + pn.geom_line(pn.aes(x = "num_partida", y = "pontos_acumulados"))
    )
    print(p)


dados = pd.read_csv("2024-05-13/dados.csv")
grafico_pts_acumulados(dados, 2023, "Palmeiras")
grafico_pts_acumulados(dados, 2023, "Palmeiras", type = "pn")

# Fazer gráfico do número de pontos ganhos em casa e fora

import pandas as pd
import numpy as np
import seaborn as sb
import plotnine as pn
import matplotlib.pyplot as plt

temporada = 2023

dados = pd.read_csv("2024-05-13/dados.csv")

dados_temporada = dados.query("season == @temporada")

def calcular_pontos_mandante(p) :
  gols_mandante = p.split(sep = "x")[0]
  gols_visitante = p.split(sep = "x")[1]
  if gols_mandante > gols_visitante:
    return 3
  elif gols_mandante == gols_visitante:
    return 1
  else:
    return 0

num_pontos_mandante = np.array([0] * len(dados_temporada))
num_pontos_visitante = np.array([0] * len(dados_temporada))

i = 0

for placar in dados_temporada["score"]:
  num_pontos_mandante[i] = calcular_pontos_mandante(placar)
  i = i + 1

i = 0
for pts in num_pontos_mandante:
  if pts == 3:
    p = 0
  elif pts == 1:
    p = 1
  else:
    p = 3
  num_pontos_visitante[i] = p
  i = i + 1

num_pontos_mandante.sum()
num_pontos_visitante.sum()

d = {"mando": ["em casa", "visitante"], "num_pontos": [num_pontos_mandante.sum(), num_pontos_visitante.sum()]}

tab_plot = pd.DataFrame(d)

sb.catplot(
  data = tab_plot,
  x = "mando",
  y = "num_pontos",
  kind = "bar"
)
plt.show()

(
  pn.ggplot(tab_plot)
  + pn.geom_col(pn.aes(x = "mando", y = "num_pontos"))
)








