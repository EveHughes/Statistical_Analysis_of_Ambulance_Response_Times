#### Preamble ####
# Purpose: Simulates a year of paramedic dispatch data
# Author: Muhammad Abdullah Motasim
# Date: 18 September 2024
# Contact: abdullah.motasim@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, janitor, lubridate 


#### Workspace setup ####
library(tidyverse)
library(janitor)
library(lubridate)

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

simulated_data <-
  tibble(
    "ID" = 1:size,
    
    "Dispatch_Time" = sample(
      x=datetime_sequence,
      size=size,
      replace=TRUE
    ),
    
    # Randomly pick an option, with replacement, size times
    "Incident_Type" = sample(
      x = c("Medical", "Motor Vehicle Accident", "Emergency Transfer", 
            "Fire", "Airport Standby", "Other"),
      size = size,
      replace = TRUE),
    
    # This value defines the priority level of the call
    # These values are predetermined by the MDPS system
    "Priority_Number" = sample(
      x = c(1, 3, 4, 5, 9, 11, 12, 13, 14),
      size=size, 
      replace=TRUE),
    
    # These values range from 0 to 47, but on average the max value per year is 20
    # Thus we have chosen to take a maximum value of 22
    "Units_Arrived_At_Scene" = sample(
      x = c(0:22),
      size=size, 
      replace=TRUE)
  )
