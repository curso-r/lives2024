import pandas as pd
import numpy as np

mtcars = pd.read_csv('2024-05-27/mtcars.csv')

# número de carros por am

mtcars.am.value_counts()
mtcars.cyl.value_counts()

mtcars["am"].value_counts()

# mpg médio por cyl

mtcars.groupby("cyl").mpg.agg("mean")
mtcars.groupby("cyl").wt.agg("mean")

# mpg, wt e disp médios

mtcars.agg(
  {'mpg': ["min", "mean", "max"], 
  'wt': ["min", "mean", "max"], 
  'disp': ["min", "mean", "max"]}
)

tab = mtcars.groupby("cyl").agg(
  {'mpg': ["min", "mean", "max"], 
  'wt': ["min", "mean", "max"], 
  'disp': ["min", "mean", "max"]}
)

tab.mpg["min"].iloc[0]
tab.disp["min"].iloc[2]
