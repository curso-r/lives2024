library(torch) # framework para deep learning (port do pytorch para R)
library(luz) # funções em alto nível para implementar modelos em torch
library(torchvision) # datasets e funções para problemas de visão computacional

# create a dataset --------------------------------------------------------

root <- "./datasets/mnist"
raw_mnist <- mnist_dataset(root, download = TRUE)

class(raw_mnist)
length(raw_mnist)

raw_mnist[1]
str(raw_mnist[[1]])
plot(as.raster(raw_mnist[1]$x, max = 255))

raw_mnist[2]
plot(as.raster(raw_mnist[2]$x, max = 255))


transform <- function(x) {
  x |>
    # transforma a imagem em um tensor (valores ficam entre 0 e 1)
    transform_to_tensor() |>
    # transforma a estrutra de matrix 28x28 em um vetor de tamanho 784
    torch_flatten()
}

train_ds <- mnist_dataset(root, transform = transform, download = TRUE)
length(train_ds)

test_ds <- mnist_dataset(root, transform = transform, train = FALSE)
length(test_ds)

# Define the neural net ---------------------------------------------------

net <- nn_module(
  "MLP", # Multi Layer Perceptron
  initialize = function(in_features, out_features) {
    self$linear1 <- nn_linear(in_features, 512)
    self$linear2 <- nn_linear(512, 256)
    self$linear3 <- nn_linear(256, out_features)
    self$relu <- nn_relu()
  },
  forward = function(x) {
    x |>
      self$linear1() |>
      self$relu() |>
      self$linear2() |>
      self$relu() |>
      self$linear3()
  }
)

# fit with luz ------------------------------------------------------------

fitted <- net |>
  setup(
    loss = nnf_cross_entropy, # função de perda
    optim = optim_adam, # algoritmo de otimização
    metrics = list(
      luz_metric_accuracy() # métrica de avaliação
    )
  ) |>
  set_hparams(in_features = 784, out_features = 10) |>
  set_opt_hparams(lr = 1e-3) |> # hiperparâmetros da otimização
  fit(train_ds, valid_data = 0.2, epochs = 2)


fitted |>
  evaluate(test_ds)

predictions <- fitted |>
  predict(test_ds)

predictions

plot(as.raster(matrix(as.array(test_ds[1]$x), 28, 28,  byrow = TRUE)))
test_ds[1]$y

predictions[1, ] |>
  nnf_softmax(dim = 1) |>
  as.array() |>
  round(5)


# Matriz de confundimento

valores_preditos <- apply(as.array(predictions), 1, which.max) - 1
valores_verdadeiros <- test_ds$targets - 1

table(valores_preditos, valores_verdadeiros)



indices <- which(valores_preditos == 8 & valores_verdadeiros == 1)

for(i in indices) {
  plot(as.raster(matrix(as.array(test_ds[i]$x), 28, 28,  byrow = TRUE)))
}


indices <- which(valores_preditos == 0 & valores_verdadeiros == 9)

for(i in indices) {
  plot(as.raster(matrix(as.array(test_ds[i]$x), 28, 28,  byrow = TRUE)))
}


# overfitting
# técnicas de interpretação dos resultados






