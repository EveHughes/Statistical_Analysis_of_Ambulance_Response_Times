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
  raw_data |>
  janitor::clean_names() |>
  # Remove unneeded columns which describe data types
  select(-field_name, -desctiption_definition, -comments_examples) |>
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
  mutate(date = lubridate::ymd_hms(paste(year, month, day, hour, minute, second, sep = "-"))) |>
  # Remove unneeded columns which describe data types
  select(-hour, -minute, -second, -day) |>
  #Reorder columns
  select(id, date, incident_type, priority_number, units_arrived_at_scene, forward_sortation_area, everything()))

#### Save data ####
write_csv(cleaned_data, "data/analysis_data/cleaned_ambulance_response_data.csv")
