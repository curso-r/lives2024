import pandas as pd

excel = pd.ExcelFile("2024-05-06/dados.xlsx")

abas = excel.sheet_names

dados = pd.read_excel("2024-05-06/dados.xlsx", sheet_name = abas[0])

for aba in abas[1:len(abas)]:
  tab = pd.read_excel("2024-05-06/dados.xlsx", sheet_name = aba)
  dados = pd.concat([dados, tab])

dados
