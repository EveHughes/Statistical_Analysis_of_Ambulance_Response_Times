#### Preamble ####
# Purpose: Sanity checks simulated response data
# Author: Muhammad Abdullah Motasim
# Date: 22 September 2024
# Contact: abdullah.motasim@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, simulated_ambulance_response_data
# Any other information needed: None


#### Workspace setup ####
library(tidyverse)
data <- read_csv("data/raw_data/simulated_ambulance_response_data.csv")

#### Test data ####

# Test for no negative number of dispatchers
paste("Negative Number of Dispatchers Test: ", data$units_arrived_at_scene |> min() < 0)

# test for dates within range specified
paste("Dispatch Time out-of-range Test: ", all(year(data$dispatch_time) != 2023))

# test for priority level meets requirements
priority_levels <- c(1, 3, 4, 5, 9, 11, 12, 13, 14)
paste("Priority Level Outside of Range Test: ", any(!data$priority_number %in% priority_levels))

# test for missing values
any_NA_values <- all(is.na(data$id))
any_NA_values <- all(is.na(data$dispatch_time))
any_NA_values <- all(is.na(data$incident_type))
any_NA_values <- all(is.na(data$priority_number))
any_NA_values <- all(is.na(data$units_arrived_at_scene))

paste("Any NA Values Test: ", any_NA_values)
