import pandas as pd

dados = pd.read_csv("2024-04-29/dados.csv")

# dados$score
dados.get("score") 
dados["score"]

temporada = 2023

# Filtrando a base (dplyr::filter)
dados.query("season == 2023")
dados_2023 = dados[dados["season"] == 2023]

string = "2x1"

num_gols = string.split(sep = "x")
num_gols[0]
num_gols[1]

num_gols[0] > num_gols[1]
num_gols[0] == num_gols[1]

def pegar_gols_mandante(placar):
  return placar.split(sep = "x")[0]

def pegar_gols_visitante(placar):
  return placar.split(sep = "x")[1]

dados_2023["gols_mandante"] = dados_2023["score"].apply(pegar_gols_mandante)
dados_2023["gols_visitante"] = dados_2023["score"].apply(pegar_gols_visitante)

dados_2023

dados_2023["vitoria_mandante"] = dados_2023["gols_mandante"] > dados_2023["gols_visitante"]
dados_2023["vitoria_visitante"] = dados_2023["gols_mandante"] < dados_2023["gols_visitante"]


dados_2023
View(dados_2023)

dados_corinthians = dados_2023.query("home == 'Corinthians'")

vitorias_mandante = dados_corinthians.query("vitoria_mandante == True")
vitorias_visitante = dados_corinthians.query("vitoria_visitante == True")

len(vitorias_mandante) + len(vitorias_visitante)

times = dados_2023["home"].unique()

for time in times:
  dados_time_mandante = dados_2023[dados_2023.home == time]
  dados_time_visitante = dados_2023[dados_2023.away == time]
  vitorias_mandante = dados_time_mandante.query("vitoria_mandante == True")
  vitorias_visitante = dados_time_visitante.query("vitoria_visitante == True")
  num_vitorias = len(vitorias_mandante) + len(vitorias_visitante)
  print(time + ": " + str(num_vitorias))












