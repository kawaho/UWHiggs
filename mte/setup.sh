#!/bin/bash

# Get the data
export datasrc=/hdfs/store/user/ndev
export MEGAPATH=/hdfs/store/user/ndev

source jobid.sh
export jobid=$jobidem

#export afile=`find $datasrc/$jobid | grep root | head -n 1`

## Build the cython wrappers
#rake "make_wrapper[$afile, em/final/Ntuple, EMTree]"

#ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake

#rake "meta:getinputs[$jobid, $datasrc, em/metaInfo, em/summedWeights]"
rake "meta:getmeta[inputs/$jobid, em/metaInfo, 13, em/summedWeights]"

