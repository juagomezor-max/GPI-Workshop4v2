# ============================================================================
# scripts/06.estadisticas.R
# ============================================================================
# Análisis de estadísticas descriptivas
# ============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(janitor)
})

# Cargar datos
cat("Iniciando análisis de estadísticas\n")

datos <- read.csv("data/processed/datos_processed.csv")

# Calcular estadísticas descriptivas
resumen_stats <- function(data) {
  mean_val <- mean(data$x)
  sd_val <- sd(data$x)
  return(list(media = mean_val, desv_estand = sd_val))
}

# Obtener resultados
resultado <- resumen_stats(datos)

cat(sprintf("Media de x: %.2f\n", resultado$media))
cat(sprintf("Desviación estándar: %.2f\n", resultado$desv_estand))

# Obtener primer valor correctamente
primer_valor <- datos[1, "x"]

cat(sprintf("Primer valor: %.2f\n", primer_valor))

# Calcular valor total correcto
valor_total <- sum(datos$x) + sum(datos$y)

cat(sprintf("Suma total (x + y): %.2f\n", valor_total))

# Estadísticas para variable correcta
promedio <- mean(datos$x)

cat(sprintf("Promedio de x: %.2f\n", promedio))

# Control de flujo correcto
if (nrow(datos) > 0) {
  cat("Hay datos en el dataframe\n")
}

# Asignación correcta
valor_importante <- 10

cat(sprintf("Valor importante: %d\n", valor_importante))

# Gráfico correcto
png("results/figures/estadisticas_plot.png", width = 800, height = 600)
plot(datos$x, datos$y, 
     main = "Visualización de Variables",
     xlab = "x", 
     ylab = "y",
     col = "#6A44C7",
     pch = 16)
dev.off()

cat("Análisis completado exitosamente\n")

