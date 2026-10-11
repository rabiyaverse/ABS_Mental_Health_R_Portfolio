# =============================================================
# ABS National Study of Mental Health and Wellbeing 2020 - 2022 
# Data Inventory 
# =============================================================


# Purpose : 
# Inspect the raw ABS dataset before data cleaning
# 
# Workflow: 
# Raw data - Data cleaning - EDA - Descriptive statistics - Visualisation
# Hypothesis testing - Regression - Model visualisation - Interpretation
# ==============================================================

    
# 1. load package 

library(readxl)
library(dplyr)

# 2. checks sheets in the file

excel_sheets("data/raw/Table 3 - 12-month disorder groups by age and sex.xlsx")

# 3. Import real table (skip ABS headers) 
raw_data <- read_excel(
"data/raw/Table 3 - 12-month disorder groups by age and sex.xlsx",
sheet = "Table 3.1 Estimates",
skip = 7
)

# 4. header inspection - find true names for ..2,..3,etc
temp <-read_excel("data/raw/Table 3 - 12-month disorder groups by age and sex.xlsx",
sheet = "Table 3.1 Estimates",
col_names = FALSE
)
View(temp) #shows Anxiety, Affective, etc in row 5

# 5. final clean column name 

raw_data_clean <- raw_data %>%
  rename(
    age_sex_group = 1,
    anxiety = 2,
    affective = 3, 
    substance = 4, 
    any_disorder = 5, 
    no_disorder = 6, 
    total =7
  )
View(raw_data_clean)


# 6. Inspect clean data set structure
names(raw_data_clean)
str(raw_data_clean)                          
summary(raw_data_clean)
head(raw_data_clean, 10)

# 7. Identify section headers and missing data
raw_data_clean %>%
  filter(is.na(total)) %>%
  select(age_sex_group)

# 8. List all row tables to see the table structure
raw_data_clean$age_sex_group

# =============================================================
# Key findings (to address in 02_data_cleaning.R)
# =============================================================
# - 49 rows: 33 data rows + 16 non-data rows
#     (section headings, blank rows, ABS footnotes)
# - Table has 3 blocks: Persons (rows 1-12), Males (14-26),
#     Females (28-40); no "Males"/"Females" label rows -
#     each block ends with a "Total ... aged 16-85 years" row
# - Broad age groups (16-34, 35-64, 65-85) overlap with
#     detailed groups - must not be summed together
# - anxiety and substance are stored as text because of ABS
#     reliability markers (* and **) and "—" (nil)
# - Values are weighted population estimates ('000)
# =============================================================