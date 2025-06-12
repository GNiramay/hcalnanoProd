#!/bin/bash
# Script to submit condor jobs
# Syntax: . SubmitCondorJob.sh <text file containing list of input root file paths> <Output location (Preferably eos area)>
# Example:. SubmitCondorJob.sh FilePaths/ExpressPhysics_370772.txt /eos/user/n/ngogate/PFG_Task/NanoAod/ExpressPhysics_FEVT_Express-v2_370772/

# Define variables
FPATH=$1
OutPath=$2
# CMSSWVer=$(ls -1 | grep CMSSW)
CMSSWVer=CMSSW_15_0_6

# # Locate the config file for making hcalnano
# CfgFile=${CMSSWVer}/src/1060.1_RunZeroBias2022D/step2_RAW2DIGI_RECO_USER.py

FNAME=$(basename $FPATH)
FKEY=`echo "$FNAME" | cut -d'.' -f1`
echo $FKEY
CondFile=ConfFiles/$FKEY.jdl

# Make condor config file
echo "universe = vanilla" > $CondFile
echo "Executable = BashFile.sh" >> $CondFile
echo "should_transfer_files = YES" >> $CondFile
echo "WhenToTransferOutput = ON_EXIT" >>$CondFile
echo "+MaxRuntime = 30000" >>$CondFile
# echo "Transfer_Input_Files = ${CfgFile}" >> $CondFile
printf "Output = StdOut/${FKEY}_%s(Cluster)_%s(ProcId).stdout\n" $ $>> $CondFile
printf "Error = StdErr/${FKEY}_%s(Cluster)_%s(ProcId).stderr\n" $ $>> $CondFile
printf "Log = Log/${FKEY}_%s(Cluster)_%s(ProcId).log\n" $ $>> $CondFile
printf "Arguments = ${CMSSWVer} root://xrootd-cms.infn.it/%s(InRootFile) ${OutPath}\n" $ >> $CondFile
echo "queue InRootFile from $FPATH" >> $CondFile

# submit condor jobs
condor_submit $CondFile
