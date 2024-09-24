#### Preamble ####
# Purpose: Simulates a year of paramedic dispatch data
# Author: Muhammad Abdullah Motasim
# Date: 18 September 2024
# Contact: abdullah.motasim@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, janitor, lubridate, truncnorm
# Any other information needed: None


#### Workspace setup ####
set.seed(1009067563)
library(tidyverse)
library(janitor)
library(lubridate)
library(truncnorm)

#### Simulate data ####

# There are around 27 000  entries for each year
# We will generate 30 000 entries to simulate data for the 2023 year
size <- 30000

# Create a sequence of dates and times within the 2023 year to choose from
datetime_sequence <- seq(from = as.POSIXct("2023-01-01 00:00"), 
                         to = as.POSIXct("2023-12-31 23:59"), 
                         by = "min")

# Format sequence to match data from Open Data Toronto
datetime_sequence <- format(datetime_sequence, format = "%Y-%m-%d %H:%M")

# Different calls have different priorities which are predetermined by the MDPS system
# A weighted sampling is used to account for this disparity 
priority_numbers = c(1, 3, 4, 5, 9, 11, 12, 13, 14)
priority_numbers_weights <- c(0.15, 0.2, 0.3, 0.2, 0.1, 0.05, 0.04, 0.03, 0.03)

# Different types of incidents occur more than others
# A weighted sampling is used to account for this disparity 
incident_types <- c("Medical", "Motor Vehicle Accident", "Emergency Transfer", 
                    "Fire", "Airport Standby", "Other")
incident_types_weights <- c(0.3, 0.3, 0.05, 0.1, 0.03, 0.2)

# There are a different amount of dispatchers sent for each call
# I assume there are typically 5 dispatchers sent per call
# We sample from a truncated normal distribution to account for this disparity 
max_dispactchers <- 22
min_dispactchers <- 0
mean <- 5
sd <- 3
  
  
simulated_data <-
  tibble(
    "id" = 1:size,
    
    "dispatch_time" = sample(x=datetime_sequence, size=size, replace=FALSE),

    "incident_type" = sample(x = incident_types, size = size, replace = TRUE, 
                             prob=incident_types_weights),
    
    "priority_number" = sample(x = priority_numbers, size=size, replace=TRUE, 
                               prob=priority_numbers_weights),
    
    "units_arrived_at_scene" = round(rtruncnorm(n = size, a = min_dispactchers,
                                                 b = max_dispactchers, mean = mean, sd = sd))
)

#### Write_csv
write_csv(simulated_data, file = "data/raw_data/simulated_ambulance_response_data.csv")
