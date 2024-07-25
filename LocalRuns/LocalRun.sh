#!/bin/bash
# Script to produce hcalnano from RAW files
# Syntax: . LocalRun.sh <run number> <Output file location>
# Example: . LocalRun.sh 383596 $PWD
nRun=$1
OutLoc=$2

# Setup CMSSW env
CMSSWVer=$(ls -1 .. | grep CMSSW)
cd ../$CMSSWVer/src
cmsenv
cd -

# Get the list of RAW files
FileList=$(ls -1 /eos/cms/store/group/dpg_hcal/comm_hcal/USC/run${nRun}/*.root)

# Make NanoAOD
for InRoot in ${FileList[*]};do
    OutRoot=${OutLoc}/$(basename $InRoot)
    echo $InRoot , $OutRoot

    # time cmsDriver.py step2\
    # 	 --customise DPGAnalysis/HcalNanoAOD/hcalNano_cff.customiseHcalLocal\
    # 	 --conditions auto:run3_data_prompt -n -1\
    # 	 --era Run3 --geometry DB:Extended\
    # 	 --datatier NANOAOD --eventcontent NANOAOD\
    # 	 --filein file:$InRoot --fileout file:$OutRoot

    # Works
    time cmsDriver.py step2\
	 -s RAW2DIGI,USER:DPGAnalysis/HcalNanoAOD/hcalNano_cff.hcalNanoDigiTask\
	 --conditions auto:run3_data_prompt -n -1 --era Run3\
	 --datatier NANOAOD --eventcontent NANOAOD\
	 --customise DPGAnalysis/HcalNanoAOD/hcalNano_cff.customiseHcalLocal\
	 --filein file:$InRoot --fileout file:$OutRoot

    # time cmsDriver.py step2\
    # 	 --customise DPGAnalysis/HcalNanoAOD/hcalNano_cff.customiseHcalLocal\
    # 	 --conditions auto:run3_data_prompt -n -1\
    # 	 --era Run3 --geometry DB:Extended\
    # 	 --datatier NANOAOD --eventcontent NANOAOD\
    # 	 --filein file:$InRoot --fileout file:$OutRoot

done
# -s RAW2DIGI,RECO,USER:DPGAnalysis/HcalNanoAOD/hcalNano_cff.hcalNanoTask\
# --no_exec\
