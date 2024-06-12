#!/bin/bash
# Script to produce hcalnano from RAW files
# This will be used at the condor node.
# Syntax: . BashFile.sh <input RAW ROOT> <Output file location>

InRoot=$1
OutLoc=$2
OutRoot=${OutLoc}/$(basename $InRoot)
MyCMSSW=CMSSW_14_1_0_pre0

source /cvmfs/cms.cern.ch/cmsset_default.sh
scram p $MyCMSSW
cd $MyCMSSW/src
cmsenv
cd -

date
ls -alht

# Make NanoAOD
time cmsDriver.py step2\
     -s RAW2DIGI,RECO,USER:DPGAnalysis/HcalNanoAOD/hcalNano_cff.hcalNanoTask\
     --conditions auto:run3_data_prompt -n -1\
     --era Run3 --geometry DB:Extended\
     --datatier NANOAOD --eventcontent NANOAOD\
     --filein $InRoot --fileout file:$OutRoot

date
ls -alht
