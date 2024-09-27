#### Preamble ####
# Purpose: Cleans the raw ambulance dispatch response data
# Author: Muhammad Abdullah Motasim
# Date: 22 September 2024
# Contact: abdullah.motasim@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, dplyr, raw_ambulance_response_data.csv
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(dplyr)

#### Clean data ####
raw_data <- read_csv("data/raw_data/raw_ambulance_response_data.csv")

cleaned_data <- suppressWarnings(
  raw_data[,2:5] |>
  janitor::clean_names() |>
  # Remove columns which are not used in analysis
  # select(-forward_sortation_area, -field_name, -desctiption_definition, -comments_examples) |>
    
  na.omit() |>
  # Convert date and time variables
  separate(col = dispatch_time,
           into = c("date", "time"),
           sep = " ") |> 
  # Separate date variable 
  separate(col = date,
           into = c("year", "month", "day"),
           sep = "-") |>
  # Separate time variable
  separate(col = time,
           into = c("hour", "minute", "second"),
           sep = ":") |>
  # Ensure we keep values which are at time 00:00:00
  mutate(
    hour = ifelse(is.na(hour), "00", hour),
    minute = ifelse(is.na(minute), "00", minute),
    second = ifelse(is.na(second), "00", second)) |>
  # create a new date column
  mutate(dispatch_time = lubridate::ymd_hms(paste(year, month, day, hour, minute, second, sep = "-"))) |>
  # Remove unneeded columns which describe date
  select(-hour, -minute, -second, -day, -month) |>
  #Reorder columns
  select(dispatch_time, incident_type, priority_number, units_arrived_at_scene, year))

#### Test data ####

# Test for no negative number of dispatchers
paste("Negative Number of Dispatchers Test: ", cleaned_data$units_arrived_at_scene |> min() < 0)

# test for dates within range specified
years <- c(2017, 2018, 2019, 2020, 2021, 2022)
paste("Dispatch Time out-of-range Test: ", any(!cleaned_data$year %in% years))

# test for priority level meets requirements
priority_levels <- c(1, 3, 4, 5, 9, 11, 12, 13, 14)
paste("Priority Level Outside of Range Test: ", any(!cleaned_data$priority_number %in% priority_levels))

# test for missing values
any_NA_values <- all(is.na(cleaned_data$dispatch_time))
any_NA_values <- all(is.na(cleaned_data$incident_type))
any_NA_values <- all(is.na(cleaned_data$priority_number))
any_NA_values <- all(is.na(cleaned_data$units_arrived_at_scene))
paste("Any NA Values Test: ", any_NA_values)

#### Save data ####
write_csv(cleaned_data, "data/analysis_data/cleaned_ambulance_response_data.csv")
