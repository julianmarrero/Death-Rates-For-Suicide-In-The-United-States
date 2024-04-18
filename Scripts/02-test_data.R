# This script is designed to test data processing and model functionalities for the dataset
# "Death rates for suicide, by sex, race, Hispanic origin, and age, United States".
# It leverages the `testthat` package for unit testing to ensure that data manipulations
# and model outputs are accurate and reliable. The script also incorporates the `dplyr` and
# `stats` libraries for data manipulation and statistical modeling, respectively.
# The sample data provided mimics the real dataset structure to validate the process_and_model
# function's capability to filter, process, and model the data correctly.

# Load the testthat library
if (!require("testthat")) install.packages("testthat")
if (!requireNamespace("here", quietly = TRUE)) {
  install.packages("here")
}
library(here)
library(testthat)

# Sample data to mimic the real dataset
data <- data.frame(
  INDICATOR = rep("Death rates for suicide", 6),
  UNIT = rep("Deaths per 100,000 resident population, age-adjusted", 6),
  STUB_NAME = c("Total", "Sex, age and race", "Sex, age and race", "Sex", "Age", "Sex, age and race"),
  STUB_LABEL = c("All persons", "Male: White: 15-24 years", "Female: Black or African American: 25-44 years", "Female", "15-24 years", "Male: Asian or Pacific Islander: 65 years and over"),
  YEAR = 2000:2005,
  AGE = c("All ages", "15-24 years", "25-44 years", "All ages", "15-24 years", "65 years and over"),
  ESTIMATE = c(13.2, 8.6, 5.4, 12.5, 13.1, 2.3)
)

# Your processing and model script, encapsulated into a function for testing
process_and_model <- function(data) {
  library(dplyr)
  library(stats)
  
  # Filter and process data
  filtered_data <- data %>%
    filter(STUB_NAME == "Sex, age and race") %>%
    select(YEAR, STUB_LABEL, AGE, ESTIMATE) %>%
    na.omit()
  
  # Split labels
  filtered_data <- filtered_data %>%
    mutate(Sex = sub(":.*", "", STUB_LABEL),
           Race = sub(".*: (.*?):.*", "\\1", STUB_LABEL),
           Age_Group = sub(".*: ", "", STUB_LABEL)) %>%
    select(-STUB_LABEL)
  
  # Clean up formatting
  filtered_data$Race <- trimws(filtered_data$Race)
  filtered_data$Age_Group <- trimws(filtered_data$Age_Group)
  
  # Regression analysis
  model <- lm(ESTIMATE ~ factor(Sex) + factor(Race) + factor(Age_Group), data = filtered_data)
  return(list(model = summary(model), data = filtered_data))
}

# Test the function
test_that("Data is filtered correctly", {
  result <- process_and_model(data)
  expect_equal(nrow(result$data), 3) # Expect 3 rows after filtering
})

test_that("Model runs and coefficients are calculated", {
  result <- process_and_model(data)
  expect_true("coefficients" %in% names(summary(result$model)))
  expect_true(length(coef(result$model)) > 0)
})

test_that("Correct categories are created", {
  result <- process_and_model(data)
  expect_equal(unique(result$data$Sex), c("Male", "Female"))
  expect_equal(unique(result$data$Race), c("White", "Black or African American", "Asian or Pacific Islander"))
  expect_equal(unique(result$data$Age_Group), c("15-24 years", "25-44 years", "65 years and over"))
})

# Run all tests
test_dir(here())
