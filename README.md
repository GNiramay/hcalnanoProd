# hcalnanoProd
Repository for submitting condor jobs on CERN lxplus to produce hcalnano files from RAW

## Installation
1. Put the desired CMSSW version on line 10 of `firsttime.sh`
2. Put the same CMSSW version on line 9 of `BashFile.sh`
3. Execute `source firsttime.sh`

## Scripts and their usage
* `FindDataset.sh`: Prints the available datasets for the given run. Syntax: `. FindDataset.sh <run number>`
* `GetFiles.sh`: Writes the RAW file paths to a text file. Processing an entire run can consume huge space. So it is recommended to process a small portion of the run. The script randomizes the order of the file paths and writes the specified number of RAW files to the destintion text file. The full list of file paths is also written to the text file with extension `_full.txt`.  Syntax: `. GetFiles.sh <run number> <dataset> <dataset tag> <no. of files to keep> `
* `SubmitCondorJob.sh`: Submits 1 condor job for each RAW file path found in the specified text file. The script also requires to be provided a global tag, although it's not used anywhere. Syntax: `. SubmitCondorJob.sh <text file containing list of input root file paths> <Output location (Preferably eos area)> <Global tag>`

[NOTE: Make sure your GRID certificate is valid, before using the code.]

## Example
```
voms-proxy-init -valid 192:00 -voms cms
. FindDataset.sh 370772 | grep ZeroBias
. GetFiles.sh 370772 /ZeroBias/Run2023D-v1/RAW ZeroBias_Example 30
. SubmitCondorJob.sh FilePaths/ZeroBias_Example_370772.txt /eos/user/n/ngogate/PFG_Task/NanoAod/ExpressPhysics_FEVT_Express-v2_370772/ 140X_dataRun3_HLT_v3
```
