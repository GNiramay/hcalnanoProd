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

# Get the main processing script (Global runs)
runTheMatrix.py -l 1060.1 --dryRun
cd 1060.1_RunZeroBias2022D/
scram b -j8 --ignore-arch
cp cmdLog cmdLog.sh
. cmdLog.sh
