set.seed(123)  # Set seed for reproducibility

# Define the number of entries to simulate
n <- 1000

# Simulate data
synthetic_data <- data.frame(
  YEAR = sample(1950:2020, n, replace = TRUE),  # Random years between 1950 and 2020
  AGE = sample(c('10-14 years', '15-24 years', '25-44 years', '45-64 years', '65 years and over'), n, replace = TRUE),
  SEX = sample(c('Male', 'Female'), n, replace = TRUE),
  RACE = sample(c('White', 'Black or African American', 'Asian or Pacific Islander', 'American Indian or Alaska Native'), n, replace = TRUE),
  ESTIMATE = rnorm(n, mean = 12, sd = 5)  # Normal distribution, mean = 12, sd = 5
)

# Quick summary and head of the synthetic data to verify
summary(synthetic_data)
head(synthetic_data)
