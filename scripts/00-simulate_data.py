#### Preamble ####
# Purpose: Simulates a year of paramedic dispatch data (no scipy)
# Author: Muhammad Abdullah Motasim (translated to Python)
# Date: 18 September 2024

import pandas as pd
import numpy as np
from datetime import datetime

np.random.seed(1009067563)

#### Simulate data ####

size = 30000  # number of entries

# Create a datetime sequence for every minute in 2023
start = datetime(2023, 1, 1, 0, 0)
end = datetime(2023, 12, 31, 23, 59)
datetime_sequence = pd.date_range(start=start, end=end, freq="T").strftime("%Y-%m-%d %H:%M").tolist()

# Priority levels and weights
priority_numbers = [1, 3, 4, 5, 9, 11, 12, 13, 14]
priority_weights = [0.15, 0.2, 0.3, 0.2, 0.1, 0.05, 0.04, 0.03, 0.03]

# Incident types and weights
incident_types = ["Medical", "Motor Vehicle Accident", "Emergency Transfer",
                  "Fire", "Airport Standby", "Other"]
incident_weights = [0.3, 0.3, 0.05, 0.1, 0.03, 0.2]

# Simulate number of dispatchers using clipped normal distribution
mean = 5
sd = 3
min_dispatchers = 0
max_dispatchers = 22

dispatchers = np.random.normal(loc=mean, scale=sd, size=size)
dispatchers_clipped = np.clip(dispatchers, min_dispatchers, max_dispatchers).round().astype(int)

# Build the dataset
simulated_data = pd.DataFrame({
    "id": np.arange(1, size + 1),
    "dispatch_time": np.random.choice(datetime_sequence, size=size, replace=False),
    "incident_type": np.random.choice(incident_types, size=size, p=incident_weights),
    "priority_number": np.random.choice(priority_numbers, size=size, p=priority_weights),
    "units_arrived_at_scene": dispatchers_clipped
})

# Save to CSV
simulated_data.to_csv("data/raw_data/simulated_ambulance_response_data.csv", index=False)
