# ============================================================================
# runall.ps1
# Description:
#   PowerShell script to automate the execution of the entire workflow for the GPI Workshop

# R scripts in the correct order
Rscript scripts/01_simulacion.R
Rscript scripts/02_procesamiento.R
Rscript scripts/03_analisis.R
Rscript scripts/04_plots.R

