# ============================================================================
# src/Utilidades.R
# ============================================================================
# Description:
#   Utility functions for data analysis, statistics, and common operations
#
# Author: GPI Workshop 4
# Date: 2026-02-22
# ============================================================================

# ============================================================================
# 1. DATA LOADING AND VALIDATION UTILITIES
# ============================================================================

#' Load and Validate Data File
#'
#' @param file_path Path to the CSV file
#' @param verbose Print messages (default: TRUE)
#'
#' @return Data frame if successful, NULL otherwise
load_data <- function(file_path, verbose = TRUE) {
  if (!file.exists(file_path)) {
    if (verbose) cat(sprintf("ERROR: File not found: %s\n", file_path))
    return(NULL)
  }
  
  tryCatch({
    data <- read.csv(file_path)
    if (verbose) {
      cat(sprintf("✓ Data loaded successfully: %s\n", file_path))
      cat(sprintf("  Dimensions: %d rows × %d columns\n", nrow(data), ncol(data)))
    }
    return(data)
  }, error = function(e) {
    if (verbose) cat(sprintf("ERROR loading file: %s\n", e$message))
    return(NULL)
  })
}

#' Check for Missing Values
#'
#' @param data Data frame to check
#'
#' @return Data frame with missing value summary
check_missing_values <- function(data) {
  missing_summary <- data.frame(
    Variable = names(data),
    Missing_Count = colSums(is.na(data)),
    Missing_Percentage = (colSums(is.na(data)) / nrow(data)) * 100
  )
  
  return(missing_summary[missing_summary$Missing_Count > 0, ])
}

#' Remove Duplicates
#'
#' @param data Data frame
#'
#' @return Data frame without duplicates
remove_duplicates <- function(data) {
  n_before <- nrow(data)
  data_clean <- data[!duplicated(data), ]
  n_removed <- n_before - nrow(data_clean)
  
  if (n_removed > 0) {
    cat(sprintf("Removed %d duplicate rows\n", n_removed))
  }
  
  return(data_clean)
}

# ============================================================================
# 2. STATISTICAL ANALYSIS UTILITIES
# ============================================================================

#' Calculate Comprehensive Summary Statistics
#'
#' @param x Numeric vector
#'
#' @return List with summary statistics
summary_stats <- function(x) {
  x_clean <- na.omit(x)
  
  return(list(
    n = length(x_clean),
    mean = mean(x_clean),
    median = median(x_clean),
    sd = sd(x_clean),
    var = var(x_clean),
    min = min(x_clean),
    max = max(x_clean),
    q1 = quantile(x_clean, 0.25),
    q3 = quantile(x_clean, 0.75),
    iqr = IQR(x_clean),
    skewness = (mean(x_clean) - median(x_clean)) / sd(x_clean),
    cv = (sd(x_clean) / mean(x_clean)) * 100
  ))
}

#' Standard Error
#'
#' @param x Numeric vector
#'
#' @return Standard error
standard_error <- function(x) {
  return(sd(x, na.rm = TRUE) / sqrt(length(na.omit(x))))
}

#' Confidence Interval (95%)
#'
#' @param x Numeric vector
#' @param conf_level Confidence level (default: 0.95)
#'
#' @return List with lower and upper bounds
confidence_interval <- function(x, conf_level = 0.95) {
  x_clean <- na.omit(x)
  n <- length(x_clean)
  t_crit <- qt((1 + conf_level) / 2, df = n - 1)
  se <- standard_error(x)
  mean_val <- mean(x_clean)
  
  return(list(
    mean = mean_val,
    lower = mean_val - (t_crit * se),
    upper = mean_val + (t_crit * se),
    se = se
  ))
}

#' Outlier Detection (IQR method)
#'
#' @param x Numeric vector
#' @param multiplier IQR multiplier (default: 1.5)
#'
#' @return Indices of outliers
detect_outliers <- function(x, multiplier = 1.5) {
  q1 <- quantile(x, 0.25)
  q3 <- quantile(x, 0.75)
  iqr <- q3 - q1
  
  lower_bound <- q1 - (multiplier * iqr)
  upper_bound <- q3 + (multiplier * iqr)
  
  outliers <- which(x < lower_bound | x > upper_bound)
  return(outliers)
}

# ============================================================================
# 3. DATA TRANSFORMATION UTILITIES
# ============================================================================

#' Standardize (Z-score normalization)
#'
#' @param x Numeric vector
#'
#' @return Standardized vector
standardize <- function(x) {
  return((x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE))
}

#' Normalize (0-1 scale)
#'
#' @param x Numeric vector
#'
#' @return Normalized vector (0-1)
normalize <- function(x) {
  return((x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)))
}

#' Discretize Continuous Variable
#'
#' @param x Numeric vector
#' @param breaks Number of breaks
#' @param labels Custom labels (optional)
#'
#' @return Categorized vector
discretize <- function(x, breaks = 3, labels = NULL) {
  if (is.null(labels)) {
    labels <- paste0("Q", 1:breaks)
  }
  
  return(cut(x, breaks = breaks, labels = labels, include.lowest = TRUE))
}

#' Log Transformation
#'
#' @param x Numeric vector
#' @param base Logarithm base (default: natural log)
#'
#' @return Log-transformed vector
log_transform <- function(x, base = exp(1)) {
  if (any(x <= 0, na.rm = TRUE)) {
    cat("WARNING: Negative or zero values detected. Adding offset.\n")
    x <- x + abs(min(x, na.rm = TRUE)) + 1
  }
  return(log(x, base = base))
}

# ============================================================================
# 4. DATA QUALITY UTILITIES
# ============================================================================

#' Data Quality Report
#'
#' @param data Data frame
#'
#' @return Printed quality report
data_quality_report <- function(data) {
  cat("\n╔════════════════════════════════════════╗\n")
  cat("║        DATA QUALITY REPORT            ║\n")
  cat("╚════════════════════════════════════════╝\n\n")
  
  cat(sprintf("Total Observations: %d\n", nrow(data)))
  cat(sprintf("Total Variables: %d\n", ncol(data)))
  cat(sprintf("Missing Values: %d (%.2f%%)\n", 
              sum(is.na(data)), 
              (sum(is.na(data)) / (nrow(data) * ncol(data))) * 100))
  
  duplicates <- sum(duplicated(data))
  cat(sprintf("Duplicate Rows: %d\n", duplicates))
  
  cat("\nVariable Types:\n")
  data_types <- table(sapply(data, class))
  print(data_types)
  
  missing_by_var <- check_missing_values(data)
  if (nrow(missing_by_var) > 0) {
    cat("\nVariables with Missing Values:\n")
    print(missing_by_var)
  }
}

# ============================================================================
# 5. VISUALIZATION UTILITIES
# ============================================================================

#' Create Directory for Output
#'
#' @param dir_path Directory path
#' @param verbose Print messages (default: TRUE)
#'
#' @return TRUE if successful
create_output_dir <- function(dir_path, verbose = TRUE) {
  if (!dir.exists(dir_path)) {
    dir.create(dir_path, recursive = TRUE)
    if (verbose) cat(sprintf("✓ Directory created: %s\n", dir_path))
  }
  return(TRUE)
}

#' Heatmap for Correlation Matrix
#'
#' @param corr_matrix Correlation matrix
#' @param title Plot title
#' @param output_path Path to save (optional)
plot_correlation_heatmap <- function(corr_matrix, title = "Correlation Matrix", 
                                     output_path = NULL) {
  if (!is.null(output_path)) {
    png(output_path, width = 800, height = 600)
  }
  
  heatmap(corr_matrix, 
          main = title,
          col = colorRampPalette(c("blue", "white", "red"))(50),
          Rowv = NA, Colv = NA,
          margins = c(5, 5))
  
  if (!is.null(output_path)) {
    dev.off()
    cat(sprintf("✓ Plot saved: %s\n", output_path))
  }
}

# ============================================================================
# 6. COMPARISON AND TESTING UTILITIES
# ============================================================================

#' Compare Two Groups (t-test wrapper)
#'
#' @param group1 First group vector
#' @param group2 Second group vector
#' @param alternative "two.sided", "less", or "greater"
#'
#' @return t-test results with interpretation
compare_groups <- function(group1, group2, alternative = "two.sided") {
  test <- t.test(group1, group2, alternative = alternative)
  
  result <- data.frame(
    Mean_Group1 = mean(group1, na.rm = TRUE),
    Mean_Group2 = mean(group2, na.rm = TRUE),
    t_statistic = round(test$statistic, 4),
    p_value = format(test$p.value, scientific = TRUE, digits = 4),
    Significant = ifelse(test$p.value < 0.05, "Yes *", "No"),
    Interpretation = ifelse(test$p.value < 0.05,
                           "Groups are significantly different",
                           "No significant difference between groups")
  )
  
  return(result)
}

# ============================================================================
# 7. FILE EXPORT UTILITIES
# ============================================================================

#' Export Results Table
#'
#' @param data Data frame to export
#' @param file_path Output file path
#' @param format "csv" or "latex"
export_results <- function(data, file_path, format = "csv") {
  if (format == "csv") {
    write.csv(data, file_path, row.names = FALSE)
  } else if (format == "latex") {
    latex_table <- knitr::kable(data, format = "latex", booktabs = TRUE)
    writeLines(latex_table, file_path)
  }
  
  cat(sprintf("✓ File saved: %s\n", file_path))
  return(invisible(NULL))
}

# ============================================================================
# 8. UTILITY FUNCTIONS
# ============================================================================

#' Print Progress Message
#'
#' @param message Message to print
#' @param section Section number (optional)
print_progress <- function(message, section = NULL) {
  if (!is.null(section)) {
    cat(sprintf("\n[Section %d] %s\n", section, message))
  } else {
    cat(sprintf("\n%s\n", message))
  }
}

#' Generate Timestamp
#'
#' @return Character string with current timestamp
get_timestamp <- function() {
  return(format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
}

#' Session Summary
#'
#' @return Printed session information
session_summary <- function() {
  cat("\n╔════════════════════════════════════════╗\n")
  cat("║        SESSION INFORMATION             ║\n")
  cat("╚════════════════════════════════════════╝\n\n")
  
  cat(sprintf("R Version: %s\n", R.version$version.string))
  cat(sprintf("Platform: %s\n", R.version$platform))
  cat(sprintf("Working Directory: %s\n", getwd()))
  cat(sprintf("Timestamp: %s\n", get_timestamp()))
}

# ============================================================================
# End of Utilities
# ============================================================================
