#!/bin/bash
# Script to get a text file containing the list of raw data files from given run
# Syntax: . GetFiles.sh <Run number> <RAW Dataset> <Dataset tag> <no. of files to keep>
# Example: . GetFiles.sh 381516 /ZeroBias/Run2024E-v1/RAW MyFirstHcalNano 30

nRun=$1
Dataset=$2
DatasetName=$3
nFiles=$4
nFiles=$((nFiles+1))

# text files to save the RAW file paths
OutTxt=FilePaths/${DatasetName}_${nRun}
BigFile="${OutTxt}_full.txt"
SmallFile="${OutTxt}.txt"

# Shuffling, Writing the RAW file paths
dasgoclient -query="file dataset=${Dataset} run=${nRun}" | shuf > $BigFile
nTotal=$(wc -l < $BigFile)
sed "${nFiles},${nTotal}d" $BigFile > $SmallFile
