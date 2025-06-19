#### Preamble ####
# Purpose: Sanity checks simulated response data
# Author: Muhammad Abdullah Motasim
# Date: 22 September 2024
# Contact: abdullah.motasim@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, simulated_ambulance_response_data
# Any other information needed: None


#### Workspace setup ####
import pandas as pd
import numpy as np

data = pd.read_csv("data/raw_data/simulated_ambulance_response_data.csv")
# Ensure dispatch_time is parsed as a datetime column
data["dispatch_time"] = pd.to_datetime(data["dispatch_time"], errors="coerce")

#### Test data ####

# Test for no negative number of dispatchers
print("Negative Number of Dispatchers Test: ", data["units_arrived_at_scene"].min() < 0)

# Test for dates within range specified (no rows from calendar year 2023)
print(
    "Dispatch Time out-of-range Test: ",
    (data["dispatch_time"].dt.year != 2023).all()
)

# Test for priority level meets requirements
priority_levels = [1, 3, 4, 5, 9, 11, 12, 13, 14]
print(
    "Priority Level Outside of Range Test: ",
    (~data["priority_number"].isin(priority_levels)).any()
)

# Test for missing values
any_NA_values = data[
    ["id", "dispatch_time", "incident_type", "priority_number", "units_arrived_at_scene"]
].isna().any().any()
print("Any NA Values Test: ", any_NA_values)
