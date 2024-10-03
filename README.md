# Increased Emergency Medical Response Wait Times: The Impact of Higher Call Volume and More Severe Cases Post-COVID-19

## Overview

This repo contains all the data and scripts required to analyze the response time of Toronto Paramedic Services from 2017 to 2022. Overall, it was found that after COVID-19 there was an increase in the frequency and severity of calls to the Toronto Paramedic Services.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from OpenDataToronto.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `other` contains details about LLM chat interactions and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.

## User Guide
- Run scripts/00-simulate_data.R to simulate the data
- Run scripts/01-download_data.R to download data from openDataToronto website to the data/raw_data folder
- Run scripts/02-data_cleaning to clean the data in raw_folder and save it to the data/analysis folder
- Run scripts/02-test_data to run tests on simulated data
- Render paper/paper.qmd to render a pdf of the paper

## Statement on LLM usage

Aspects of the abstract, title, and code such as the simulation script, cleaning script, testing script, and R code within the quorto paper were written with the help of chatGPTand the entire chat history is available in other/llms/usage.txt.
