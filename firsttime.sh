#!/bin/bash

# create the necessary folders
mkdir StdOut
mkdir StdErr
mkdir Log
mkdir ConfFiles

# Initialize the latest stable CMSSW
MyCMSSW=CMSSW_14_1_0_pre0
export SCRAM_ARCH=el8_amd64_gcc12
scram p $MyCMSSW

# Create CMSSW environment
cd $MyCMSSW/src
cmsenv

# Get the main processing scripts
runTheMatrix.py -l 1060.1 --dryRun # Global
runTheMatrix.py -l 1060.2 --dryRun # Calibration gap (Local)
scram b -j8 --ignore-arch

# Generate the Global cfg
cd 1060.1_RunZeroBias2022D/
cp cmdLog cmdLog.sh
. cmdLog.sh

# Generate the Local cfg
cd ../1060.2_TestEnablesEcalHcal2023C/
cp cmdLog cmdLog.sh
. cmdLog.sh

# Return to the working directory
cd ../../../
