# carregar os pacotes dplyr e ggplot2
library(dplyr)
library(ggplot2)

# Manipulação

## usando o dplyr, devolver apenas carros com am = 1

mtcars |>
  dplyr::filter(am == 1) |>
  View()

# Gráficos

## usando o ggplot2, criar um gráfico de dispersão do mpg contra o wt

ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
  ggplot2::geom_point()


# q: qual a definição de média aritimética?
# r: a média aritmética é a soma de todos os valores dividido pelo número de valores

# q: qual a definição de mediana?
# r: a mediana é o valor que separa a metade superior da metade inferior de uma distribuição de dados

# q: qual função eu uso no R para juntar duas strings?
# r: paste()

# q: qual função no R devolve o código utilizado para gerar um determinado valor?
# r: deparse(substitute())

dput(unique(dplyr::starwars$name))


# crie uma função para formatar um num seguindo o padrao brasileiro

formatar_num <- function(num) {
  num <- formatC(num, big.mark = ".", decimal.mark = ",")
  num
}

formatar_num <- function(x) {
  format(x, big.mark = ".", decimal.mark = ",")
}

dplyr::















