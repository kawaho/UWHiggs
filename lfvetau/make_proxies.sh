#!/bin/bash

# Generate the cython proxies used in the analyses

source jobid.sh

export jobid=$jobid13

#export datasrc=/hdfs/store/user/ndev/$jobid
export datasrc=/hdfs/store/user/$USER/$jobid
#export datasrc=`ls -d /nfs_scratch/taroni/$jobid | head -n 1`

if [ -z $1 ]; then
    export afile=`find $datasrc | grep data | grep root | head -n 1`
else
    export afile=$1
fi

echo "Building cython wrappers from file: $afile"
#rake "make_wrapper[$afile, et/final/Ntuple, ETauTree]"
#ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake 

#echo "Building cython wrappers from file: $afile"
rake "make_wrapper[$afile, eet/final/Ntuple, EETauTree]"
ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake 

rake "make_wrapper[$afile, eee/final/Ntuple, EEETree]"
ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake 


export jobid='LFV_sep16_v2'
export datasrc=/hdfs/store/user/$USER/$jobid

if [ -z $1 ]; then
    export afile=`find $datasrc | grep data | grep root | head -n 1`
else
    export afile=$1
fi

echo "Building cython wrappers from file: $afile"
#rake "make_wrapper[$afile, mmt/final/Ntuple, MMTauTree]"
#ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake 

#rake "make_wrapper[$afile, emm/final/Ntuple, MMETree]"
#ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake 


#echo "Building cython wrappers from file: $afile"
#rake "make_wrapper[$afile, eee/final/Ntuple, EEETree]"
#ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake 


#export jobid='LFV_808v1'
#export datasrc=/hdfs/store/user/ndev/$jobid
#if [ -z $1 ]; then
#    export afile=`find $datasrc/ | grep root | head -n 1`
#else
#    export afile=$1
#fi

#echo "Building cython wrappers from file: $afile"
#rake "make_wrapper[$afile, mt/final/Ntuple, MuTauTree]"
#ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake 
#rake "make_wrapper[$afile, em/final/Ntuple, MuETree]"
#ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake 
