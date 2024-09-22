#### Preamble ####
# Purpose: Downloads and saves the data from opendatatoronto
# Author: Muhammad Abdullah Motasim
# Date: 21 September 2024
# Contact: abdullah.motasim@mail.utoronto.ca
# License: MIT
# Pre-requisites: purrr, tidyverse, opendatatoronto
# Any other information needed: None


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(purrr)

# get package
package <- show_package("c21f3bd1-e016-4469-abf5-c58bb8e8b5ce")
package

#### Download data ####
all_dispatch_data <-
  list_package_resources("c21f3bd1-e016-4469-abf5-c58bb8e8b5ce") |>
  filter(name ==
           "paramedic-services-incident-data-2017-2022") |>
  get_resource()

# Combine the data for all the years into a single dataframe
combined_data <- bind_rows(all_dispatch_data)

#### Save data ####

write_csv(
  x = combined_data,
  file = "data/raw_data/raw_ambulance_response_data.csv"
)

head(combined_data)
