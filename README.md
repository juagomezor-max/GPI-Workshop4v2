# GPI Workshop 4 - Data Analysis Project

**[English](#english) | [Español](#español)**

---

<a id="english"></a>

## English Version

# GPI Workshop 4 - Data Analysis

Data analysis and simulation project for GPI Workshop 4. This repository contains a complete processing, analysis, and visualization workflow.

## 📋 Description

This project implements an analysis pipeline that includes:
- **Data Simulation**: Generation of synthetic data
- **Processing**: Data cleaning and transformation
- **Analysis**: Statistical calculations and correlations
- **Visualization**: Generation of graphs and result tables

## 📁 Project Structure

```
GPI-Workshop4v2/
├── README.md                 # This file
├── Runall.ps1              # Script to run the entire pipeline
├── data/                   # Project data
│   ├── raw/               # Original raw data
│   └── processed/         # Processed and clean data
├── scripts/               # R analysis scripts
│   ├── packages.R         # Dependency installation
│   ├── 01_simulacion.R    # Data generation
│   ├── 02_procesamiento.R # Cleaning and transformation
│   ├── 03_analisis.R      # Statistical analysis
│   └── 04_plots.R         # Visualization generation
├── results/               # Analysis results
│   ├── figures/          # Generated graphs
│   └── tables/           # Result tables
├── renv/                 # Dependency management (renv)
└── src/                  # Additional source code
```

## 🔧 Requirements

- **R** 4.5 or higher
- **PowerShell** (to run Runall.ps1)
- R dependencies automatically managed via `renv`

### Main Dependencies:
- tidyverse (dplyr, ggplot2, tidyr, readr)
- janitor
- readxl
- lubridate
- broom
- And more (see `renv/settings.json`)

## 🚀 Installation and Setup

### 1. Clone the repository
```bash
git clone <REPOSITORY-URL>
cd GPI-Workshop4v2
```

### 2. Restore dependencies
Dependencies will be automatically restored when running the scripts. To do it manually, in R:
```r
renv::restore()
```

## 📊 Execution

### Option 1: Run everything at once (Recommended)
```powershell
.\Runall.ps1
```

### Option 2: Run scripts individually

In PowerShell or R terminal:

**Step 1**: Install/load dependencies
```r
source("scripts/packages.R")
```

**Step 2**: Simulate data
```r
source("scripts/01_simulacion.R")
```

**Step 3**: Process data
```r
source("scripts/02_procesamiento.R")
```

**Step 4**: Statistical analysis
```r
source("scripts/03_analisis.R")
```

**Step 5**: Generate visualizations
```r
source("scripts/04_plots.R")
```

## 📈 Script Descriptions

| Script | Description |
|--------|-------------|
| `packages.R` | Sets up and installs all required libraries |
| `01_simulacion.R` | Generates simulated data for analysis |
| `02_procesamiento.R` | Cleans, transforms, and prepares the data |
| `03_analisis.R` | Performs statistical analysis (correlations, summaries) |
| `04_plots.R` | Creates visualizations and graphs |

## 📊 Results

Analysis results are saved in:

- **Tables**: `results/tables/`
  - `correlation_matrix.csv` - Correlation matrix
  - `summary_statistics.csv` - Descriptive statistics

- **Figures**: `results/figures/`
  - Generated charts during analysis

## 🔄 Dependency Management

This project uses `renv` to ensure reproducibility:

```r
# Check dependency status
renv::status()

# Update dependencies
renv::update()

# Take a snapshot of current dependencies
renv::snapshot()
```

## 📝 Notes

- Raw data is in `data/raw/`
- Processed data is saved in `data/processed/`
- Results are automatically updated when running the pipeline
- Ensure you have write permissions in `data/processed/` and `results/` folders

## 🤝 Contributions

To contribute to the project:
1. Create a branch for your feature
2. Make your changes
3. Document appropriately
4. Submit a pull request

## 📄 License

[Specify the project license]

## ✉️ Contact

[Author/maintainer contact information]

---

<a id="español"></a>

## Versión en Español

# GPI Workshop 4 - Análisis de Datos

Proyecto de análisis de datos y simulación para el Workshop 4 de GPI. Este repositorio contiene un flujo completo de procesamiento, análisis y visualización de datos.

## 📋 Descripción

Este proyecto implementa un pipeline de análisis que incluye:
- **Simulación de datos**: Generación de datos sintéticos
- **Procesamiento**: Limpieza y transformación de datos
- **Análisis**: Cálculo de estadísticas y correlaciones
- **Visualización**: Generación de gráficos y tablas de resultados

## 📁 Estructura del Proyecto

```
GPI-Workshop4v2/
├── README.md                 # Este archivo
├── Runall.ps1              # Script para ejecutar todo el pipeline
├── data/                   # Datos del proyecto
│   ├── raw/               # Datos crudos originales
│   └── processed/         # Datos procesados y limpios
├── scripts/               # Scripts R del análisis
│   ├── packages.R         # Instalación de dependencias
│   ├── 01_simulacion.R    # Generación de datos
│   ├── 02_procesamiento.R # Limpieza y transformación
│   ├── 03_analisis.R      # Análisis estadístico
│   └── 04_plots.R         # Generación de visualizaciones
├── results/               # Resultados del análisis
│   ├── figures/          # Gráficos generados
│   └── tables/           # Tablas de resultados
├── renv/                 # Gestión de dependencias (renv)
└── src/                  # Código fuente adicional
```

## 🔧 Requisitos

- **R** 4.5 o superior
- **PowerShell** (para ejecutar Runall.ps1)
- Dependencias R gestionadas automáticamente mediante `renv`

### Dependencias principales:
- tidyverse (dplyr, ggplot2, tidyr, readr)
- janitor
- readxl
- lubridate
- broom
- Y más (ver `renv/settings.json`)

## 🚀 Instalación y Setup

### 1. Clonar el repositorio
```bash
git clone <URL-DEL-REPOSITORIO>
cd GPI-Workshop4v2
```

### 2. Restaurar dependencias
Las dependencias se restaurarán automáticamente al ejecutar los scripts. Si necesitas hacerlo manualmente, en R:
```r
renv::restore()
```

## 📊 Ejecución

### Opción 1: Ejecutar todo de una vez (Recomendado)
```powershell
.\Runall.ps1
```

### Opción 2: Ejecutar scripts individualmente

En PowerShell o terminal de R:

**Paso 1**: Instalar/cargar dependencias
```r
source("scripts/packages.R")
```

**Paso 2**: Simular datos
```r
source("scripts/01_simulacion.R")
```

**Paso 3**: Procesar datos
```r
source("scripts/02_procesamiento.R")
```

**Paso 4**: Análisis estadístico
```r
source("scripts/03_analisis.R")
```

**Paso 5**: Generar visualizaciones
```r
source("scripts/04_plots.R")
```

## 📈 Descripción de Scripts

| Script | Descripción |
|--------|-------------|
| `packages.R` | Configura e instala todas las librerías necesarias |
| `01_simulacion.R` | Genera datos simulados para el análisis |
| `02_procesamiento.R` | Limpia, transforma y prepara los datos |
| `03_analisis.R` | Realiza análisis estadísticos (correlaciones, resúmenes) |
| `04_plots.R` | Crea visualizaciones y gráficos |

## 📊 Resultados

Los resultados del análisis se guardan en:

- **Tablas**: `results/tables/`
  - `correlation_matrix.csv` - Matriz de correlaciones
  - `summary_statistics.csv` - Estadísticas descriptivas

- **Figuras**: `results/figures/`
  - Gráficos generados durante el análisis

## 🔄 Gestión de Dependencias

Este proyecto utiliza `renv` para asegurar reproducibilidad:

```r
# Ver estado de dependencias
renv::status()

# Actualizar dependencias
renv::update()

# Tomar snapshot de dependencias actuales
renv::snapshot()
```

## 📝 Notas

- Los datos crudos están en `data/raw/`
- Los datos procesados se guardan en `data/processed/`
- Los resultados se actualizan automáticamente al ejecutar el pipeline
- Asegúrate de tener permisos de escritura en las carpetas `data/processed/` y `results/`

## 🤝 Contribuciones

Para contribuir al proyecto:
1. Crea una rama para tu feature
2. Realiza los cambios
3. Documenta adecuadamente
4. Envía un pull request

## 📄 Licencia

[Especifica la licencia del proyecto]

## ✉️ Contacto

[Información de contacto del autor/responsable]

---

**Última actualización**: Febrero 2026
