# ============================================================================
# scripts/01_simulation.R
# ============================================================================
# Description:
#   Simulation script to generate realistic synthetic data that will be used
#   as the basis for subsequent analyses in the workshop.
#   
# Author: GPI Workshop 4
# Date: 2026-02-22
# ============================================================================
# Initial Configuration
# ============================================================================

# Set seed for reproducibility
set.seed(202315618)
source("scripts/packages.R")
# Number of observations to generate
n <- 200

cat("\n=== START: Data simulation ===\n")
cat(sprintf("Number of observations: %d\n", n))

# ============================================================================
# Synthetic Data Generation
# ============================================================================
# Multivariate structured data will be simulated including:
# - Correlated continuous variables
# - Realistic trend and dispersion components
# - Representative characteristics of real-world data

# Generate base independent variable
x <- rnorm(n, mean = 50, sd = 10)

# Generate dependent variable with linear relationship + error
# y = 2*x + error, with positive correlation
y <- 2 * x + rnorm(n, mean = 0, sd = 15)

# Generate additional variables for greater complexity
z <- rnorm(n, mean = 100, sd = 20)  # Variable with no direct correlation
grupo <- rep(c("A", "B", "C"), length.out = n)  # Categorical variable
tiempo <- 1:n  # Temporal/sequential sequence

# Create data frame with all variables
datos <- data.frame(
  id = 1:n,
  x = x,
  y = y,
  z = z,
  grupo = grupo,
  tiempo = tiempo
)

# ============================================================================
# Create Directory and Save Data
# ============================================================================

# Create 'data/raw' directory if it does not exist
if (!dir.exists("data/raw")) {
  dir.create("data/raw", recursive = TRUE)
}

# Save data in CSV format
write.csv(datos, "data/raw/datos_raw.csv", row.names = FALSE)

cat("\n✓ Data saved: data/raw/datos_raw.csv\n")
cat(sprintf("  Dimensions: %d rows × %d columns\n", nrow(datos), ncol(datos)))
cat("=== END: Data simulation completed ===\n\n")