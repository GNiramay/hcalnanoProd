#!/bin/bash
# Script that prints all the available RAW datasets for the given run.
# One should choose from the available datasets, and then use it with GetFiles.sh to get the actual file paths
# Syntax: . FindDataset.sh <run number>
# Example: . FindDataset.sh 381516
nRun=$1
dasgoclient -query="dataset run=${nRun}" | grep RAW
