#!/bin/bash
# Script to produce hcalnano from RAW files
# This will be used at the condor node.
# Syntax: . BashFile.sh <CMSSW version> <input RAW ROOT> <Output file location>

CMSSWVer=$1
InRoot=$2
OutLoc=$3
OutRoot=${OutLoc}/$(basename $InRoot)

source /cvmfs/cms.cern.ch/cmsset_default.sh
scram p $CMSSWVer
cd $CMSSWVer/src
cmsenv
cd -

date
ls -alht

# Make NanoAOD (Global runs)
time cmsDriver.py step2\
     -s RAW2DIGI,RECO,USER:DPGAnalysis/HcalNanoAOD/hcalNano_cff.hcalNanoTask\
     --conditions auto:run3_data_prompt -n -1\
     --era Run3 --geometry DB:Extended --processName USER\
     --datatier NANOAOD --eventcontent NANOAOD\
     --filein $InRoot --fileout file:$OutRoot

# # Make NanoAOD (Calibration gap)
# time cmsDriver.py step2\
#      -s RAW2DIGI,RECO,USER:DPGAnalysis/HcalNanoAOD/hcalNano_cff.hcalNanoTask\
#      --conditions auto:run3_data_prompt -n -1\
#      --era Run3 --geometry DB:Extended --processName USER\
#      --datatier NANOAOD --eventcontent NANOAOD\
#      --customise DPGAnalysis/HcalNanoAOD/hcalNano_cff.customiseHcalCalib\
#      --filein $InRoot  --fileout file:$OutRoot

date
ls -alht
