# ============================================================================
# scripts/02_procesamiento.R
# ============================================================================
# Description:
#   Processing script to transform raw data into a cleaned/processed dataset.
#
# Author: Julio Gómez
# Date: 2026-02-22
# ============================================================================

# ============================================================================
# Initial Configuration
# ============================================================================
source("scripts/packages.R")
library(dplyr)

# Create 'data/processed' directory if it does not exist
if (!dir.exists("data/processed")) {
  dir.create("data/processed", recursive = TRUE)
}
cat("\n=== START: Data processing ===\n")
# Load raw data
datos_raw <- read.csv("data/raw/datos_raw.csv")
cat("✓ Raw data loaded: data/raw/datos_raw.csv\n")
cat(sprintf("  Dimensions: %d rows × %d columns\n", nrow(datos_raw), ncol(datos_raw)))

# ============================================================================
# Data Cleaning and Transformation
# ============================================================================
# Example transformations:
# - Handle missing values (if any)
# - Create new variables (e.g., log transformation, interaction terms)
# - Filter outliers (if necessary)
# For this synthetic dataset, we will perform a simple transformation: create a new variable 'y_log' as the log of 'y' (after adding a small constant to avoid log(0))
datos_processed <- datos_raw %>%
  mutate(
    y_log = log(y + 1)  # Log transformation of 'y'
  )
cat("✓ Data transformed: new variable 'y_log' created\n")

# ============================================================================
# Save Processed Data
# ============================================================================
write.csv(datos_processed, "data/processed/datos_processed.csv", row.names = FALSE)
cat("\n✓ Processed data saved: data/processed/datos_processed.csv\n")
cat(sprintf("  Dimensions: %d rows × %d columns\n", nrow(datos_processed), ncol(datos_processed)))
cat("=== END: Data processing completed ===\n\n")

# Note: In a real-world scenario, the processing steps would be more complex and tailored to the specific requirements of the analysis.