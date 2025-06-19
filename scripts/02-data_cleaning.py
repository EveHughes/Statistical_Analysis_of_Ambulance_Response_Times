#### Preamble ####
# Purpose: Cleans the raw ambulance dispatch response data
# Author: Muhammad Abdullah Motasim
# Date: 22 September 2024
# Contact: abdullah.motasim@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, dplyr, raw_ambulance_response_data.csv
# Any other information needed? None

#### Workspace setup ####
import pandas as pd
import numpy as np

#### Clean data ####
raw_data = pd.read_csv("data/raw_data/raw_ambulance_response_data.csv")

# Select columns 2 to 5 (Python uses 0-based indexing, so 1:5)
data = raw_data.iloc[:, 1:5].copy()

# Drop missing rows
data = data.dropna()

# Split 'dispatch_time' into date and time
date_time_split = data["dispatch_time"].str.split(" ", expand=True)
data["date"] = date_time_split[0]
data["time"] = date_time_split[1]

# Split date into year, month, day
date_parts = data["date"].str.split("-", expand=True)
data["year"] = date_parts[0]
data["month"] = date_parts[1]
data["day"] = date_parts[2]

# Split time into hour, minute, second
time_parts = data["time"].str.split(":", expand=True)
data["hour"] = time_parts[0].fillna("00")
data["minute"] = time_parts[1].fillna("00")
data["second"] = time_parts[2].fillna("00")

# Create dispatch_time column as datetime
data["dispatch_time"] = pd.to_datetime(
    data["year"] + "-" + data["month"] + "-" + data["day"] + " " +
    data["hour"] + ":" + data["minute"] + ":" + data["second"],
    errors="coerce"
)

# Keep and reorder necessary columns
cleaned_data = data[[
    "dispatch_time",
    "incident_type",
    "priority_number",
    "units_arrived_at_scene",
    "year"
]]

#### Test data ####

# Test for no negative number of dispatchers
print("Negative Number of Dispatchers Test: ", cleaned_data["units_arrived_at_scene"].min() < 0)

# Test for dates within expected year range
years = ['2017', '2018', '2019', '2020', '2021', '2022']
print("Dispatch Time out-of-range Test: ", any(~cleaned_data["year"].isin(years)))

# Test for priority level meets requirements
priority_levels = [1, 3, 4, 5, 9, 11, 12, 13, 14]
print("Priority Level Outside of Range Test: ", any(~cleaned_data["priority_number"].isin(priority_levels)))

# Test for missing values
print("Any NA Values Test: ", cleaned_data.isna().any().any())

#### Save data ####
cleaned_data.to_csv("data/analysis_data/cleaned_ambulance_response_data.csv", index=False)
