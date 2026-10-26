# =============================================================
# ABS National Study of Mental Health and Wellbeing 2020-2022
# 04 - Visualisation
# =============================================================
# Purpose:
#   Visualise 12-month prevalence by age and sex
# Input:
#   outputs/tables/prevalence.csv (from 03_analysis.R)
# Output:
#   outputs/figures/prevalence_any_by_age_sex.png
# =============================================================

# 1. Load packages and results
library(dplyr)
library(ggplot2)

prevalence <- read.csv("outputs/tables/prevalence.csv",
                       fileEncoding = "UTF-8")

# 2. Prepare data: detailed age groups, males and females only
plot_data <- prevalence %>%
  filter(age_type == "Detailed", sex != "Persons")

# 3. Line chart: any disorder by age and sex
p_any <- ggplot(plot_data,
                aes(x = age_group, y = any_disorder_pct,
                    colour = sex, group = sex)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  expand_limits(y = 0) +
  labs(
    title    = "12-month prevalence of any mental disorder by age and sex",
    subtitle = "Australians aged 16–85, 2020–2022",
    x        = "Age group (years)",
    y        = "Prevalence (%)",
    colour   = NULL,
    caption  = "Source: ABS National Study of Mental Health and Wellbeing 2020–22"
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "top")

p_any

# 4. Save the figure
ggsave("outputs/figures/prevalence_any_by_age_sex.png",
       p_any, width = 8, height = 5, dpi = 300)
