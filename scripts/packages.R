# --- IGNORE ---
# This script is used to load the necessary packages for the project. It checks if the packages are installed and installs them if they are not. Then it loads the packages into the R session.
# scripts/packages.R
# This script is sourced in the .Rprofile file, so it runs every time you start an R session in this project.
pkgs <- c(
  "here",
  "dplyr",
  "readr",
  "ggplot2",
  "tidyverse",
  "car"
)

# Check if packages are installed and install them if they are not
to_install <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(to_install) > 0) install.packages(to_install)

# Load the packages
invisible(lapply(pkgs, library, character.only = TRUE))