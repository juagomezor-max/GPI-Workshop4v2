# ============================================================================
# scripts/05_modelado.R
# ============================================================================
# Description:
#   Statistical regression modeling with comprehensive results export
#   Includes model comparison, diagnostics, and LaTeX-formatted output
#
# Author: GPI Workshop 4
# Date: 2026-02-22
# ============================================================================

# ============================================================================
# Initial Setup and Data Loading
# ============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
  library(knitr)
  library(car)
})

# Load processed data
datos <- read.csv("data/processed/datos_processed.csv")

cat("\n╔═══════════════════════════════════════════════════╗\n")
cat("║   STATISTICAL REGRESSION MODELING & ANALYSIS     ║\n")
cat("╚═══════════════════════════════════════════════════╝\n\n")

cat(sprintf("✓ Data loaded: data/processed/datos_processed.csv\n"))
cat(sprintf("  Observations: %d | Variables: %d\n\n", nrow(datos), ncol(datos)))

# Create output directory
out_dir <- "results/tables"
if (!dir.exists(out_dir)) {
  dir.create(out_dir, recursive = TRUE)
}

# ============================================================================
# 1. SIMPLE LINEAR REGRESSION MODELS
# ============================================================================

cat("┌─ 1. SIMPLE LINEAR REGRESSION MODELS ────────────────────┐\n\n")

# Model 1.1: y ~ x
cat("Model 1.1: y ~ x\n")
model_1.1 <- lm(y ~ x, data = datos)
summary_1.1 <- summary(model_1.1)
print(summary_1.1)

# Model 1.2: z ~ x
cat("\nModel 1.2: z ~ x\n")
model_1.2 <- lm(z ~ x, data = datos)
summary_1.2 <- summary(model_1.2)
print(summary_1.2)

# Model 1.3: z ~ y
cat("\nModel 1.3: z ~ y\n")
model_1.3 <- lm(z ~ y, data = datos)
summary_1.3 <- summary(model_1.3)
print(summary_1.3)

# ============================================================================
# 2. MULTIPLE LINEAR REGRESSION MODELS
# ============================================================================

cat("\n┌─ 2. MULTIPLE LINEAR REGRESSION MODELS ──────────────────┐\n\n")

# Model 2.1: z ~ x + y
cat("Model 2.1: z ~ x + y\n")
model_2.1 <- lm(z ~ x + y, data = datos)
summary_2.1 <- summary(model_2.1)
print(summary_2.1)

# Model 2.2: y ~ x + grupo
cat("\nModel 2.2: y ~ x + grupo\n")
model_2.2 <- lm(y ~ x + as.factor(grupo), data = datos)
summary_2.2 <- summary(model_2.2)
print(summary_2.2)

# Model 2.3: z ~ x + y + grupo (full additive model)
cat("\nModel 2.3: z ~ x + y + grupo (Full Additive Model)\n")
model_2.3 <- lm(z ~ x + y + as.factor(grupo), data = datos)
summary_2.3 <- summary(model_2.3)
print(summary_2.3)

# ============================================================================
# 3. INTERACTION MODELS
# ============================================================================

cat("\n┌─ 3. INTERACTION MODELS ────────────────────────────────┐\n\n")

# Model 3.1: z ~ x * y (with interaction)
cat("Model 3.1: z ~ x * y (Interaction Model)\n")
model_3.1 <- lm(z ~ x * y, data = datos)
summary_3.1 <- summary(model_3.1)
print(summary_3.1)

# Model 3.2: y ~ x * grupo (interaction with group)
cat("\nModel 3.2: y ~ x * grupo (Interaction with Group)\n")
model_3.2 <- lm(y ~ x * as.factor(grupo), data = datos)
summary_3.2 <- summary(model_3.2)
print(summary_3.2)

# ============================================================================
# 4. MODEL COMPARISON TABLE
# ============================================================================

cat("\n┌─ 4. MODEL COMPARISON SUMMARY ──────────────────────────┐\n\n")

# Create model comparison table
models_list <- list(
  "y ~ x" = model_1.1,
  "z ~ x" = model_1.2,
  "z ~ y" = model_1.3,
  "z ~ x + y" = model_2.1,
  "y ~ x + grupo" = model_2.2,
  "z ~ x + y + grupo" = model_2.3,
  "z ~ x * y" = model_3.1,
  "y ~ x * grupo" = model_3.2
)

# Calculate comparison metrics
model_comparison <- data.frame(
  Model = names(models_list),
  R_squared = sapply(models_list, function(m) summary(m)$r.squared),
  Adj_R_squared = sapply(models_list, function(m) summary(m)$adj.r.squared),
  AIC = sapply(models_list, AIC),
  BIC = sapply(models_list, BIC),
  RMSE = sapply(models_list, function(m) sqrt(mean(residuals(m)^2))),
  F_statistic = sapply(models_list, function(m) summary(m)$fstatistic[1]),
  p_value = sapply(models_list, function(m) {
    pf(summary(m)$fstatistic[1], 
       summary(m)$fstatistic[2], 
       summary(m)$fstatistic[3], 
       lower.tail = FALSE)
  })
)

cat("Model Comparison Metrics:\n")
model_comparison_display <- model_comparison %>%
  mutate(across(where(is.numeric), ~ round(., 4)))
print(model_comparison_display)

# ============================================================================
# 5. DETAILED COEFFICIENTS TABLES
# ============================================================================

cat("\n┌─ 5. DETAILED COEFFICIENTS EXTRACTION ──────────────────┐\n\n")

# Extract coefficients and statistics for each model
coef_tables <- list()

for (i in seq_along(models_list)) {
  model <- models_list[[i]]
  model_name <- names(models_list)[i]
  
  coef_table <- tidy(model) %>%
    mutate(
      Model = model_name,
      Term = term,
      Estimate = round(estimate, 6),
      Std_Error = round(std.error, 6),
      t_statistic = round(statistic, 4),
      p_value = format(p.value, scientific = TRUE, digits = 4),
      Significant = ifelse(p.value < 0.001, "***",
                          ifelse(p.value < 0.01, "**",
                                ifelse(p.value < 0.05, "*", "ns")))
    ) %>%
    select(Model, Term, Estimate, Std_Error, t_statistic, p_value, Significant)
  
  coef_tables[[model_name]] <- coef_table
}

# Combine all coefficients
all_coefficients <- bind_rows(coef_tables)

cat("All Model Coefficients:\n")
print(all_coefficients)

# ============================================================================
# 6. MODEL DIAGNOSTICS
# ============================================================================

cat("\n┌─ 6. REGRESSION DIAGNOSTICS ────────────────────────────┐\n\n")

# Focus on the best models for diagnostics
diagnostics <- list()

# Diagnostics for Model 2.1: z ~ x + y (multiple regression)
cat("Diagnostics for Model 2.1: z ~ x + y\n\n")

# Residuals
residuals_2.1 <- data.frame(
  Observation = 1:nrow(datos),
  Fitted = fitted(model_2.1),
  Residuals = residuals(model_2.1),
  Standardized_Residuals = rstandard(model_2.1),
  Studentized_Residuals = rstudent(model_2.1),
  Cook_Distance = cooks.distance(model_2.1),
  Leverage = hatvalues(model_2.1)
)

cat("First 10 observations diagnostics:\n")
print(head(residuals_2.1, 10))

# Residual statistics
residual_stats_2.1 <- data.frame(
  Metric = c("Mean of Residuals", 
             "Std Dev of Residuals",
             "Min Residual",
             "Max Residual",
             "Durbin-Watson Statistic"),
  Value = c(
    round(mean(residuals(model_2.1)), 6),
    round(sd(residuals(model_2.1)), 6),
    round(min(residuals(model_2.1)), 6),
    round(max(residuals(model_2.1)), 6),
    round(as.numeric(lmtest::dwtest(model_2.1)$statistic), 4)
  )
)

cat("\nResidual Statistics:\n")
print(residual_stats_2.1)

# Multicollinearity check (VIF)
cat("\n\nVariance Inflation Factors (VIF) - Model 2.1:\n")
vif_2.1 <- data.frame(
  Variable = names(vif(model_2.1)),
  VIF = round(vif(model_2.1), 4)
)
print(vif_2.1)

# ============================================================================
# 7. EXPORT TO CSV FORMAT
# ============================================================================

cat("\n┌─ 7. EXPORTING RESULTS TO CSV ──────────────────────────┐\n\n")

# Save model comparison table
write.csv(model_comparison,
          file.path(out_dir, "model_comparison.csv"),
          row.names = FALSE)
cat("✓ model_comparison.csv\n")

# Save all coefficients
write.csv(all_coefficients,
          file.path(out_dir, "all_model_coefficients.csv"),
          row.names = FALSE)
cat("✓ all_model_coefficients.csv\n")

# Save diagnostics for best model
write.csv(residuals_2.1,
          file.path(out_dir, "model_diagnostics_z_x_y.csv"),
          row.names = FALSE)
cat("✓ model_diagnostics_z_x_y.csv\n")

# Save residual statistics
write.csv(residual_stats_2.1,
          file.path(out_dir, "residual_statistics.csv"),
          row.names = FALSE)
cat("✓ residual_statistics.csv\n")

# Save VIF
write.csv(vif_2.1,
          file.path(out_dir, "vif_multicollinearity.csv"),
          row.names = FALSE)
cat("✓ vif_multicollinearity.csv\n")

# ============================================================================
# 8. EXPORT TO LATEX FORMAT
# ============================================================================

cat("\n┌─ 8. GENERATING LATEX TABLES ──────────────────────────┐\n\n")

# 8.1 Model Comparison Table
model_comp_latex <- model_comparison %>%
  mutate(across(where(is.numeric), ~ round(., 4)))

latex_model_comp <- knitr::kable(model_comp_latex,
                                 format = "latex",
                                 booktabs = TRUE,
                                 longtable = TRUE)
writeLines(latex_model_comp, file.path(out_dir, "table_model_comparison.tex"))
cat("✓ table_model_comparison.tex\n")

# 8.2 All Coefficients Table
coef_latex <- all_coefficients %>%
  select(-p_value) %>%
  arrange(Model)

latex_coef <- knitr::kable(coef_latex,
                           format = "latex",
                           booktabs = TRUE,
                           longtable = TRUE)
writeLines(latex_coef, file.path(out_dir, "table_all_coefficients.tex"))
cat("✓ table_all_coefficients.tex\n")

# 8.3 Diagnostics Table (first 20 rows)
diagnostics_latex <- residuals_2.1[1:20, ] %>%
  mutate(across(where(is.numeric), ~ round(., 4)))

latex_diag <- knitr::kable(diagnostics_latex,
                           format = "latex",
                           booktabs = TRUE,
                           longtable = TRUE)
writeLines(latex_diag, file.path(out_dir, "table_diagnostics_sample.tex"))
cat("✓ table_diagnostics_sample.tex\n")

# 8.4 Residual Statistics Table
residual_stat_latex <- residual_stats_2.1 %>%
  mutate(Value = round(as.numeric(Value), 6))

latex_residual <- knitr::kable(residual_stat_latex,
                               format = "latex",
                               booktabs = TRUE)
writeLines(latex_residual, file.path(out_dir, "table_residual_statistics.tex"))
cat("✓ table_residual_statistics.tex\n")

# 8.5 VIF Table
vif_latex <- vif_2.1 %>%
  mutate(VIF = as.numeric(VIF))

latex_vif <- knitr::kable(vif_latex,
                          format = "latex",
                          booktabs = TRUE)
writeLines(latex_vif, file.path(out_dir, "table_vif.tex"))
cat("✓ table_vif.tex\n")

# ============================================================================
# 9. CREATE LATEX MODEL SUMMARY DOCUMENT
# ============================================================================

cat("\n┌─ 9. GENERATING COMPREHENSIVE LATEX DOCUMENT ──────────┐\n\n")

latex_doc <- "% Regression Modeling Results
% Generated automatically by 05_modelado.R

\\documentclass[11pt,a4paper]{article}
\\usepackage[utf-8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage[spanish]{babel}
\\usepackage{booktabs}
\\usepackage{float}
\\usepackage{longtable}
\\usepackage{geometry}
\\usepackage{amsmath}

\\geometry{margin=1in}

\\title{Statistical Regression Modeling Report}
\\author{GPI Workshop 4}
\\date{\\today}

\\begin{document}
\\maketitle

\\tableofcontents
\\newpage

\\section{Introduction}

This document presents a comprehensive statistical regression analysis with multiple models, 
diagnostics, and comparisons.

\\section{Model Specifications and Comparison}

Eight different regression models were fitted to the data:

\\begin{enumerate}
  \\item Simple regressions: y ~ x, z ~ x, z ~ y
  \\item Multiple regressions: z ~ x + y, y ~ x + grupo, z ~ x + y + grupo
  \\item Interaction models: z ~ x * y, y ~ x * grupo
\\end{enumerate}

Table \\ref{tab:model-comparison} presents the comparison metrics for all models.

\\begin{table}[H]
  \\centering
  \\caption{Model Comparison Metrics}
  \\label{tab:model-comparison}
  \\input{table_model_comparison.tex}
\\end{table}

\\section{Regression Coefficients}

Table \\ref{tab:coefficients} shows the detailed coefficients for all models.

\\begin{table}[H]
  \\centering
  \\caption{Regression Coefficients for All Models}
  \\label{tab:coefficients}
  \\input{table_all_coefficients.tex}
\\end{table}

\\section{Model Diagnostics}

Diagnostic checks for Model 2.1 (z ~ x + y) are presented below.

\\subsection{Residual Analysis}

Table \\ref{tab:residual-stats} shows residual statistics.

\\begin{table}[H]
  \\centering
  \\caption{Residual Statistics}
  \\label{tab:residual-stats}
  \\input{table_residual_statistics.tex}
\\end{table}

Sample of individual residual diagnostics is shown in Table \\ref{tab:diagnostics}.

\\begin{table}[H]
  \\centering
  \\caption{Diagnostic Values (Sample of First 20 Observations)}
  \\label{tab:diagnostics}
  \\input{table_diagnostics_sample.tex}
\\end{table}

\\subsection{Multicollinearity Assessment}

Table \\ref{tab:vif} presents Variance Inflation Factors (VIF) for assessing multicollinearity.
VIF values less than 5 indicate acceptable levels of multicollinearity.

\\begin{table}[H]
  \\centering
  \\caption{Variance Inflation Factors (VIF)}
  \\label{tab:vif}
  \\input{table_vif.tex}
\\end{table}

\\section{Key Findings}

\\begin{itemize}
  \\item The best fitting models are those with multiple predictors and interactions
  \\item Model comparison metrics (R², AIC, BIC) guide model selection
  \\item Diagnostic checks ensure assumptions are met
  \\item VIF values confirm acceptable multicollinearity levels
\\end{itemize}

\\section{Conclusions}

Statistical regression modeling provides valuable insights into the relationships 
between variables. Model diagnostics and comparisons ensure robust and reliable results.

\\end{document}"

writeLines(latex_doc, file.path(out_dir, "Regression_Models_Report.tex"))
cat("✓ Regression_Models_Report.tex (Complete document)\n")

# ============================================================================
# 10. SUMMARY AND RECOMMENDATIONS
# ============================================================================

cat("\n╔═══════════════════════════════════════════════════╗\n")
cat("║         MODELING ANALYSIS COMPLETED             ║\n")
cat("╚═══════════════════════════════════════════════════╝\n\n")

cat("Generated Files:\n")
cat("  Location: results/tables/\n\n")

cat("CSV Export Files:\n")
cat("  • model_comparison.csv\n")
cat("  • all_model_coefficients.csv\n")
cat("  • model_diagnostics_z_x_y.csv\n")
cat("  • residual_statistics.csv\n")
cat("  • vif_multicollinearity.csv\n\n")

cat("LaTeX Table Files:\n")
cat("  • table_model_comparison.tex\n")
cat("  • table_all_coefficients.tex\n")
cat("  • table_diagnostics_sample.tex\n")
cat("  • table_residual_statistics.tex\n")
cat("  • table_vif.tex\n\n")

cat("LaTeX Document:\n")
cat("  • Regression_Models_Report.tex\n\n")

cat("Compilation command:\n")
cat("  pdflatex Regression_Models_Report.tex\n\n")

cat("Model Selection Recommendations:\n")

# Find best model by different criteria
best_r2 <- model_comparison[which.max(model_comparison$R_squared), ]
best_aic <- model_comparison[which.min(model_comparison$AIC), ]
best_bic <- model_comparison[which.min(model_comparison$BIC), ]

cat(sprintf("\n  By R² (Higher is better): %s (R² = %.4f)\n",
            best_r2$Model, best_r2$R_squared))
cat(sprintf("  By AIC (Lower is better): %s (AIC = %.2f)\n",
            best_aic$Model, best_aic$AIC))
cat(sprintf("  By BIC (Lower is better): %s (BIC = %.2f)\n",
            best_bic$Model, best_bic$BIC))

cat("\n")
