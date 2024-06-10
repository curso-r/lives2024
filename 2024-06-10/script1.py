import pandas as pd
import numpy as np

dados = pd.read_csv("2024-06-10/dados.csv")

# pandas

# No dplyr a gente tem os verbos básicos
# select()
# filter()
# arrange()
# mutate()
# group_by() + summarise()
# |>

# No pandas
# select(): .filter
# filter(): .query
# arrange(): .sort_values
# mutate(): .assign
# group_by() + summarise(): .groupby + .agg

def verificar_vitoria_mandante(placar):
   res = placar.split(sep = "x")[0] >  placar.split(sep = "x")[1]
   return(res)

def verificar_vitoria_visitante(placar):
   res = placar.split(sep = "x")[0] <  placar.split(sep = "x")[1]
   return(res)


temporada = 2023

def avaliar_vitoria(mando, flag_mand, flag_vis):
  if mando == "home" and flag_mand == True:
    return(True)
  elif mando == "away" and flag_vis == True:
    return(True)
  else:
    return(False)

avaliar_vitoria("away", False, True)


dados \
  .assign(
    flag_vit_mandante = lambda x: x.score.apply(verificar_vitoria_mandante),
    flag_vit_visitante = lambda x: x.score.apply(verificar_vitoria_visitante)
  ) \
  .reset_index(drop = True) \
  .melt(
    id_vars = ["id_match", "season", "flag_vit_mandante", "flag_vit_visitante"],
    value_vars = ["home", "away"],
    var_name = "mando",
    value_name = "time"
  ) \
  .assign(
    flag_vitoria = lambda x: x.apply(
      lambda y: avaliar_vitoria(y.mando, y.flag_vit_mandante, y.flag_vit_visitante),
      axis = 1
    )
  ) \
  .groupby(["season", "time"]) \
  .agg(num_vitorias = ("flag_vitoria", "sum")) \
  .sort_values(["season", "num_vitorias"], ascending = False)

#######
  
string = "2x1"
string.split(sep = "x")[0] >  string.split(sep = "x")[1]

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

num_vitorias = []

for time in times:
  dados_time_mandante = dados_2023[dados_2023.home == time]
  dados_time_visitante = dados_2023[dados_2023.away == time]
  vitorias_mandante = dados_time_mandante.query("vitoria_mandante == True")
  vitorias_visitante = dados_time_visitante.query("vitoria_visitante == True")
  n = len(vitorias_mandante) + len(vitorias_visitante)
  num_vitorias = np.concatenate([num_vitorias, [n]])

d = {'time': times, 'num_vitorias': num_vitorias}
dados_vitorias = pd.DataFrame(data = d)

dados_vitorias.sort_values(by = "num_vitorias", ascending = False)


