# =============================================================
# ABS National Study of Mental Health and Wellbeing 2020-2022
# 03 - Analysis
# =============================================================
# Purpose:
#   Estimate 12-month prevalence of mental disorders by sex and age,
#   and compare females with males
# Input:
#   data/processed/mh_estimates_clean.csv (from 02_data_cleaning.R)
# Output:
#   outputs/tables/prevalence.csv
#   outputs/tables/sex_comparison.csv
# =============================================================

# 1. Load packages and clean data
library(dplyr)
library(tidyr)

mh_data <- read.csv("data/processed/mh_estimates_clean.csv",
                    fileEncoding = "UTF-8")

# 2. 12-month prevalence (%) = people with disorder / total population x 100
prevalence <- mh_data %>%
  mutate(
    across(c(anxiety, affective, substance, any_disorder),
           ~ round(.x / total * 100, 1),
           .names = "{.col}_pct")
  ) %>%
  select(sex, age_type, age_group, ends_with("_pct"))

# 3. Overall prevalence (ages 16-85) by sex
prevalence %>%
  filter(age_type == "Total")

# 4. Prevalence by detailed age group
prevalence %>%
  filter(age_type == "Detailed")

# 5. Compare females vs males: prevalence ratio (PR) and difference (PD)
#    PR = female prevalence / male prevalence
#    PD = female prevalence - male prevalence (percentage points)
#    Calculated from unrounded prevalence for accuracy
sex_compare <- mh_data %>%
  filter(sex != "Persons") %>%
  pivot_longer(c(anxiety, affective, substance, any_disorder),
               names_to = "disorder", values_to = "estimate") %>%
  mutate(prev = estimate / total * 100) %>%
  select(sex, age_type, age_group, disorder, prev) %>%
  pivot_wider(names_from = sex, values_from = prev) %>%
  mutate(
    prevalence_ratio = round(Females / Males, 2),
    prevalence_diff  = round(Females - Males, 1),
    Females = round(Females, 1),
    Males   = round(Males, 1)
  )

# 5a. Overall (ages 16-85)
sex_compare %>%
  filter(age_type == "Total")

# 5b. By detailed age group - does the sex gap change with age?
sex_compare %>%
  filter(age_type == "Detailed", disorder == "any_disorder")

# 6. Save results tables
dir.create("outputs/tables", showWarnings = FALSE)
write.csv(prevalence,  "outputs/tables/prevalence.csv",     row.names = FALSE)
write.csv(sex_compare, "outputs/tables/sex_comparison.csv", row.names = FALSE)

# =============================================================
# Key results (ages 16-85)
# =============================================================
# - 21.5% had a 12-month mental disorder (ABS published: 21.4%;
#     difference due to rounding and ABS random adjustment)
# - Females 24.6% vs males 18.3% (PR 1.34, PD 6.2 points)
# - Anxiety: PR 1.58 | Affective: PR 1.33 | Substance: PR 0.49
# - Prevalence fell from 38.8% (16-24) to 5.4% (75-85)
# - Highest: females aged 16-24 (45.6%)
# - Sex gap by age: PR stable (1.23-1.45); PD shrinks from 13.2 (16-24) to 1.1 (75-85)
# - Ratios based on very small prevalences (e.g. substance use at 65+)
#     are unreliable; female substance use at 75-85 is ABS "nil",
#     so its PR of 0 should not be interpreted
# - Point estimates only - confidence intervals still to be added
# =============================================================
