# Mental Health in Australia: 12-Month Prevalence by Age and Sex

Epidemiological analysis of 12-month mental disorder prevalence among
Australians aged 16–85, using data from the ABS National Study of Mental
Health and Wellbeing 2020–2022. Built in R.

## Key findings

- **21.5%** of Australians aged 16–85 had a 12-month mental disorder
  (matching the ABS published estimate of 21.4%)
- Females had higher prevalence than males (24.6% vs 18.3%;
  prevalence ratio 1.34), driven mainly by anxiety disorders (PR 1.58)
- Substance use disorders were about half as common in females (PR 0.49)
- Prevalence declined steeply with age, from 38.8% at 16–24 to 5.4% at
  75–85; the highest prevalence was among females aged 16–24 (45.6%)
- The relative sex gap was broadly stable across age groups (PR 1.23–1.45),
  while the absolute gap narrowed from 13.2 percentage points at 16–24
  to 1.1 at 75–85

## Data

Australian Bureau of Statistics, *National Study of Mental Health and
Wellbeing: Summary Results, 2020–2022*, Table 3.
Values are weighted population estimates in thousands ('000).

## Methods

- 12-month prevalence (%) = estimated persons with disorder ÷ population × 100
- Female vs male comparisons using prevalence ratios (PR) and prevalence
  differences (PD, percentage points)
- Results validated against ABS published headline figures

## Project structure

```
R/01_data_inventory.R    Inspect raw ABS table and document its structure
R/02_data_cleaning.R     Clean and reshape into a tidy dataset
R/03_analysis.R          Prevalence, prevalence ratios and differences
data/raw/                Original ABS file (unchanged)
data/processed/          Clean dataset
outputs/tables/          Results tables (prevalence, sex comparison)
```

## How to reproduce

Open `ABS_Mental_Health_R_Portfolio.Rproj` in RStudio and run the scripts
in `R/` in numbered order. Packages: `readxl`, `dplyr`, `tidyr`.

## Data notes and limitations

- "Persons" includes people who reported another term for their sex, so
  Persons ≠ Males + Females
- ABS randomly adjusts cells to protect confidentiality; small
  discrepancies between components and totals are expected
- Ratios based on very small prevalences (e.g. substance use at 65+) are
  unreliable and should not be interpreted
- Cross-sectional data: associations only, no causal conclusions

## In progress

- Confidence intervals using ABS margins of error
- Age-standardised comparison of females and males
- Visualisations (ggplot2) and a full Quarto report

## Author

**Rabiyatul Adawiyah**, DVM, MPH (Health Promotion)
[LinkedIn](https://www.linkedin.com/in/rabiyatul)
