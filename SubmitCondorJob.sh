#!/bin/bash
# Script to submit condor jobs
# Syntax: . SubmitCondorJob2.sh <text file containing list of input root file paths> <Output location (Preferably eos area)>
# Example:. SubmitCondorJob2.sh FilePaths/ExpressPhysics_370772.txt /eos/user/n/ngogate/PFG_Task/NanoAod/ExpressPhysics_FEVT_Express-v2_370772/

# Define variables
FPATH=$1
OutPath=$2
GT=$3
FNAME=$(basename $FPATH)
FKEY=`echo "$FNAME" | cut -d'.' -f1`
echo $FKEY
CondFile=ConfFiles/$FKEY.jdl

# Make condor config file
echo "universe = workday" > $CondFile
echo "Executable = BashFile.sh" >> $CondFile
echo "should_transfer_files = YES" >> $CondFile
echo "WhenToTransferOutput = ON_EXIT" >>$CondFile
echo "Transfer_Input_Files = step2_RAW2DIGI_RECO_USER.py" >> $CondFile
printf "Output = StdOut/${FKEY}_%s(Cluster)_%s(ProcId).stdout\n" $ $>> $CondFile
printf "Error = StdErr/${FKEY}_%s(Cluster)_%s(ProcId).stderr\n" $ $>> $CondFile
printf "Log = Log/${FKEY}_%s(Cluster)_%s(ProcId).log\n" $ $>> $CondFile
printf "Arguments = root://cmsxrootd.fnal.gov/%s(InRootFile) ${OutPath}\n" $ >> $CondFile
echo "queue InRootFile from $FPATH" >> $CondFile

# submit condor jobs
condor_submit $CondFile
