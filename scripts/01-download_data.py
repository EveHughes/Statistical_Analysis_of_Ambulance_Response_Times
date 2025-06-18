#### Preamble ####
# Purpose: Downloads and saves the data from opendatatoronto
# Author: Muhammad Abdullah Motasim
# Date: 21 September 2024
# Contact: abdullah.motasim@mail.utoronto.ca
# License: MIT
# Pre-requisites: purrr, tidyverse, opendatatoronto
# Any other information needed: None

import requests
import pandas as pd
from io import BytesIO

print("Step 1: Requesting package metadata...")
base_url = "https://ckan0.cf.opendata.inter.prod-toronto.ca"
url = base_url + "/api/3/action/package_show"
params = { "id": "paramedic-services-incident-data" }
package = requests.get(url, params=params).json()

for resource in package["result"]["resources"]:
    if not resource["datastore_active"] and resource["format"].lower() == "xlsx":
        print(f"Step 2: Downloading resource: {resource['name']}")
        resource_url = resource["url"]
        response = requests.get(resource_url)

        print("Step 3: Reading Excel file...")
        xls = pd.ExcelFile(BytesIO(response.content))  # <-- likely bottleneck
        print(f"Step 3.5: Found sheets: {xls.sheet_names}")

        all_dfs = []
        for sheet in xls.sheet_names:
            print(f"Step 4: Reading sheet: {sheet}")
            df = xls.parse(sheet)
            print(f"Loaded {len(df)} rows from {sheet}")
            all_dfs.append(df)

        combined_df = pd.concat(all_dfs, ignore_index=True)
        print("Step 5: Saving CSV...")
        combined_df.to_csv("data/raw_data/raw_ambulance_data.csv", index=False)
        print("Done.")
        break
            