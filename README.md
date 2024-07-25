# hcalnanoProd
Repository for producing hcalnanos from RAW for local and global runs.

## Requirements
1. Access to CERN lxplus
2. Valid GRID certificate - Get it with the command `voms-proxy-init -valid 192:00 -voms cms`
3. The run number for which the files are to be generated.

## Installation
1. Put the desired CMSSW version on line 10 of `firsttime.sh`
2. Execute `source firsttime.sh` - This should be executed only once. If a different CMSSW version is required, delete the previous CMSSW folder, edit line 10, and execute it again.

[NOTE: Make sure your GRID certificate is valid, before using the code.]

## Global runs
1. Get the list of available datasets using `. FindDataset.sh <run number>`
2. Copy the desired dataset from the output. This will be needed in the next step
3. Save the file paths using `. GetFiles.sh <run number> <dataset> <dataset tag> <no. of files to keep>`
  - Dataset tag is some keyword that'll be used while saving the hcalnano files, file paths etc.
  - The command creates two text files in `FilePaths/`. One with `_full.txt` contains all the files for the given run. In general, one doesn't need to process the entire dataset. A few files may suffice. So a small number of files (For example 10 or 15) can be selected at random from the list and saved separately (filename: `FilePaths/<dataset tag>_<run number>.txt`). This no. of files to keep, is the last argument for the command.
4. Submit condor jobs for each of the available RAW files using `. SubmitCondorJob.sh <text file containing list of input root file paths> <Output location (Preferably eos area)>`.
  - First argument should be one of the text files saved in `FilePaths/`. To process the whole dataset, choose the files of the form `FilePaths/<dataset tag>_<run number>_full.txt`.
  - Second argument specifies the location where the hcalnano files will be saved. Please use the physical path here. In case the files need to be saved outside of lxplus, be smart in editing line 26 of `BashFile.sh`. In this case, you may wanto change `--fileout file:$OutRoot` to `--fileout $OutRoot` and give the second argument of the form `root://cmsxrootd.fnal.gov//<rest of the path>`

### Example
```
voms-proxy-init -valid 192:00 -voms cms
. FindDataset.sh 370772 | grep ZeroBias
. GetFiles.sh 370772 /ZeroBias/Run2023D-v1/RAW ZeroBias_Example 30
. SubmitCondorJob.sh FilePaths/ZeroBias_Example_370772.txt /eos/user/n/ngogate/PFG_Task/NanoAod/ExpressPhysics_FEVT_Express-v2_370772/ 140X_dataRun3_HLT_v3
```

## Local runs
The script assumes that the RAW files for the given run are saved at `/eos/cms/store/group/dpg_hcal/comm_hcal/USC/run<run number>/`. If that is not the case, be smart in writing the custom path at line 15 of `LocalRuns/LocalRun.sh`.

1. Go to the folder `LocalRuns/`
2. Use `LocalRun.sh <run number> <Output file path>`

Generally just a few files are generated for the local runs, so instead of submitting the condor jobs, they are processed locally. In case there are a lot of events to process, one should edit `SubmitCondorJob.sh`, `BashFile.sh` to submit condor jobs. Seek help from experts, to make the changes.

### Example
```
voms-proxy-init -valid 192:00 -voms cms
cd LocalRuns/
. LocalRun.sh 383596 .
```

Developer - Niramay Gogate. (mattermost @ngogate)
