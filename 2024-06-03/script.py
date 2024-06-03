import pandas as pd
import numpy as np
import seaborn as sb
import matplotlib.pyplot as plt

tab_jogos = pd.read_csv('2024-06-03/matches.csv')
tab_jogos = tab_jogos.query("season <= 2023")

# Gráfico do número de pontos dos 10 times que mais pontuaram de 2003 a 2023

def calc_pontos_mandante(placar):
  gols = placar.split(sep = "x")
  if gols[0] > gols[1]:
    return 3
  elif gols[0] == gols[1]:
    return 1
  else:
    return 0

def calc_pontos_visitante(placar):
  gols = placar.split(sep = "x")
  if gols[0] > gols[1]:
    return 0
  elif gols[0] == gols[1]:
    return 1
  else:
    return 3

tab_jogos["pontos_mandante"] = tab_jogos.score.apply(calc_pontos_mandante)
tab_jogos["pontos_visitante"] = tab_jogos.score.apply(calc_pontos_visitante)

tab_mandante = (
  tab_jogos.
    filter(items = ["home", "pontos_mandante"]).
    rename(columns = {"home": "time", "pontos_mandante": "pontos"})
)
tab_visitante = tab_jogos. \
    filter(items = ["away", "pontos_visitante"]). \
    rename(columns = {"away": "time", "pontos_visitante": "pontos"})

tab_pontos = pd.concat([tab_mandante, tab_visitante])

tab_plot = tab_pontos. \
  groupby("time"). \
  agg("sum"). \
  sort_values("pontos", ascending = False). \
  iloc[0:10]
  
sb.barplot(tab_plot, y = "time", x = "pontos")
plt.show()

# Fazer join com a base de times*
  
# tab_times = pd.read_csv("2024-06-03/teams.csv"). \
#   rename(columns = {"team": "time"})
# 
# tab_plot.join(tab_times, on = "time", lsuffix='_x', rsuffix='_y')
  







