# Load necessary libraries
if (!require("readr")) install.packages("readr")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("dplyr")) install.packages("dplyr")
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("stats")) install.packages("stats")
library(tidyverse)
library(readr)
library(dplyr)
library(ggplot2)
library(stats)

# Prompt user to select the CSV file
data <- read_csv("../Data/Death_rates_for_suicide__by_sex__race__Hispanic_origin__and_age__United_States.csv")  # Load the data

# Assuming the dataset is loaded into a data frame named 'data'
# Filter data for relevant demographic breakdowns
filtered_data <- data %>%
  filter(STUB_NAME == "Sex, age and race") %>%
  select(YEAR, STUB_LABEL, AGE, ESTIMATE) %>%
  na.omit()

# Split the 'STUB_LABEL' into 'Sex', 'Race', and 'Age_Group'
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
summary(model)

# Plotting
# Plot 1: Suicide Rates by Sex and Age Group
ggplot(filtered_data, aes(x = Age_Group, y = ESTIMATE, fill = Sex)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(title = "Suicide Rates by Sex and Age Group", x = "Age Group", y = "Death Rate per 100,000 (Age-adjusted)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Plot 2: Suicide Rates by Race
ggplot(filtered_data, aes(x = Race, y = ESTIMATE, fill = Race)) +
  geom_bar(stat = "identity") +
  labs(title = "Suicide Rates by Race", x = "Race", y = "Death Rate per 100,000 (Age-adjusted)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

