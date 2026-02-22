# This script is responsible for installing (not attaching) useful packages.
# Avoids conflicts by keeping packages available via pkg::function.
# Usage: this is just for reference, all packages shall be charged in renv.lock,
# so you do not need to run this script directly.

packages <- c(
	"broom",
	"dplyr",
	"forcats",
	"fs",
	"ggplot2",
	"glue",
	"here",
	"janitor",
	"lubridate",
	"purrr",
	"readr",
	"readxl",
	"stringr",
	"tibble",
	"tidyr"
)

to_install <- setdiff(packages, rownames(installed.packages()))
if (length(to_install) > 0) {
	install.packages(to_install)
}

invisible(lapply(packages, requireNamespace, quietly = TRUE))