import pandas as pd
import numpy as np
import seaborn as sb
import plotnine as pn

dados = pd.read_csv("2024-05-13/dados.csv")

# Fazer gráfico do número de pontos acumulados de um time

temporada = 2023

dados_temporada = dados.query("season == @temporada")
dados_temporada

def pegar_gols_mandante(s) :
  return s.split(sep = "x")[0]

def pegar_gols_visitante(s) :
  return s.split(sep = "x")[1]

pegar_gols_mandante("2x1")
pegar_gols_visitante("2x1")

gols_mandante = [0] * len(dados_temporada)
gols_visitante = [0] * len(dados_temporada)

for i in range(len(dados_temporada["score"])) :
  gols_mandante[i] = pegar_gols_mandante(dados_temporada["score"].iloc[i])
  
for i in range(len(dados_temporada["score"])) :
  gols_visitante[i] = pegar_gols_visitante(dados_temporada["score"].iloc[i])

dados_temporada["num_gols_mandante"] = gols_mandante  
dados_temporada["num_gols_visitante"] = gols_visitante 

def calcular_pontos_mandante(gols_mand, gols_vis) :
  if gols_mand > gols_vis:
    return 3
  elif gols_mand == gols_vis:
    return 1
  else:
    return 0

num_pontos_mandante = [0] * len(dados_temporada)
num_pontos_visitante = [0] * len(dados_temporada)

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

time = "Athletico PR"


pontos_time_mandante = dados_temporada.query("home == @time")[["date", "pontos_mandante"]]
pontos_time_visitante = dados_temporada.query("away == @time")[["date", "pontos_visitante"]]

pontos_time_mandante = pontos_time_mandante.rename(columns={"pontos_mandante": "pontos"})
pontos_time_visitante = pontos_time_visitante.rename(columns={"pontos_visitante": "pontos"})


dados_pontos = pd.concat([pontos_time_mandante, pontos_time_visitante]).sort_values(by = "date")

dados_pontos = dados_pontos["pontos"].cumsum()

dados_pontos["num_partida"] = ?

# Fazer gráfico do número de pontos ganhos em casa e fora



