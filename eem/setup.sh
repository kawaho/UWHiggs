#!/bin/bash

# Get the data
export datasrc=/hdfs/store/user/kaho
export MEGAPATH=/hdfs/store/user/kaho

source jobid.sh

#export afile=`find $datasrc/$jobid | grep root | head -n 1`

# Build the cython wrappers
#rake "make_wrapper[$afile, eem/final/Ntuple, EEMuTree]"

#ls *pyx | sed "s|pyx|so|" | xargs rake 
#ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake

rake "meta:getinputs[$jobid, $datasrc, eem/metaInfo, eem/summedWeights]"
#rake "meta:getmeta[inputs/$jobid, eem/metaInfo, 13, eem/summedWeights]"


