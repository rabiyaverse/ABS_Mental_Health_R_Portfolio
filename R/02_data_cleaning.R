# =============================================================
# ABS National Study of Mental Health and Wellbeing 2020-2022
# 02 - Data Cleaning
# =============================================================
# Purpose:
#   Turn raw ABS Table 3.1 into a tidy dataset for analysis.
#   The reasons for each step are in 01_data_inventory.R
# Output:
#   data/processed/mh_estimates_clean.csv
# =============================================================

# 1. load package
library(readxl)
library(dplyr)

file_path <- "data/raw/Table 3 - 12-month disorder groups by age and sex.xlsx"

# 2. import and rename columns
raw_data <-read_excel(file_path, sheet = "Table 3.1 Estimates", skip = 7) %>%
  rename(
    age_sex_group = 1,
    anxiety       = 2,
    affective     = 3,
    substance     = 4,
    any_disorder  = 5,
    no_disorder   = 6,
    total         = 7
  )

# 3. Add sex and age-group type
#    Each "Total ..." row ends a block: Persons -> Males -> Females
mh_data <- raw_data %>%
  mutate(
    block = cumsum(lag(grepl("^Total", age_sex_group), default = FALSE)),
    sex = case_when(
      block == 0 ~ "Persons",
      block == 1 ~ "Males",
      block == 2 ~ "Females"
    ),
    age_type = case_when(
      grepl("^Total", age_sex_group)                ~ "Total",
      grepl("^(16.34|35.64|65.85)$", age_sex_group) ~ "Broad",
      TRUE                                          ~ "Detailed"
    ),
    age_group = if_else(age_type == "Total", "16–85", age_sex_group)
  ) %>%

# 4. Keep data rows only (drops headings, sex labels, blanks, footnotes)
  filter(!is.na(total))

# 5. Convert anxiety and substance to numbers
#    They were read as text because the Males/Females label rows sit in
#    the anxiety column. Checked: no * or ** reliability markers in this
#    sheet. ABS uses "—" for nil, which is converted to 0.
mh_data <- mh_data %>%
  mutate(
    across(c(anxiety, substance),
           ~ if_else(grepl("—", .x), 0, as.numeric(gsub("[^0-9.]", "", .x))))
  ) %>%
  select(sex, age_type, age_group,
         anxiety, affective, substance,
         any_disorder, no_disorder, total)

# 6. Checks
count(mh_data, sex, age_type)    # expect 3 Broad, 7 Detailed, 1 Total per sex
str(mh_data)                     # all disorder columns should be "num"
stopifnot(nrow(mh_data) == 33)   # stops with an error if rows are missing

# 7. Save the clean dataset
write.csv(mh_data, "data/processed/mh_estimates_clean.csv", row.names = FALSE)
