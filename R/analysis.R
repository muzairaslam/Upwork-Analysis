library(tidyverse)
library(janitor)
library(scales)

# Turn scientific numbers off
options(scipen = 999)

# Data Loading ----

data_raw <- read_csv("data/data.csv")

# Data Cleaning ----


# select columns for analysis
data_selected <- data_raw |>
  clean_names() |>
  select(job_title, 
         search_keyword,
         category_1,
         category_2,
         payment_situation,
         client_country,
         new_connects_num,
         applicants_num,
         payment_type,
         job_cost,
         start_rate,
         end_rate)

# correct data types
data_selected$search_keyword <- factor(data_selected$search_keyword)

# Data cleaning ---

# If job is fixed price it should have job cost
# If job is hourly it should have start rate and end rate.
# Other cases to be removed

data_cleaned <- data_selected |>
  mutate(
    job_verified = case_when(
      payment_type == "Fixed-price" & is.na(job_cost) == FALSE ~ "Yes",
      payment_type == "Hourly" & (start_rate > 0 & end_rate < 300) ~  "Yes"
    )
  ) |>
  filter(job_verified == "Yes", job_cost < 20000)

# write cleaned data
write.csv(x = data_cleaned, file = "data/data_cleaned.csv")









