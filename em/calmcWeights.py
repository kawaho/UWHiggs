import json
import glob
import os

mcWeights = {"MuonEG":{},"SingleMu":{}}
DYWeights = {"MuonEG":{},"SingleMu":{}}
WWeights = {"MuonEG":{},"SingleMu":{}}

DYNNLO = 6077.22/5343
WNNLO = 61526.7/50206

DYXS = {"DYJ":5343, "DY1":877.8, "DY2":304.4, "DY3":111.5, "DY4":44.04}
WXS = {"WJ":50206, "W1":9644.5, "W2":3144.5, "W3":954.8, "W4":485.6}

mcfiles = glob.glob("inputs/"+os.environ["jobid"]+"/*.lumicalc.sum")
dyfiles = glob.glob("inputs/"+os.environ["jobid"]+"/DY*M-50*.meta.json")
wfiles = glob.glob("inputs/"+os.environ["jobid"]+"/W*Jet*.meta.json")

for dataset in ["MuonEG","SingleMu"]:
  datafiles = glob.glob("inputs/"+os.environ["jobid"]+"/*"+dataset+"*.lumicalc.sum")
  datalumi = 0
  for datafile in datafiles:
    f = open(datafile, "r")
    datalumi+=float(f.readlines()[0]) 
  print "Lumi for dataset "+dataset+" is "+str(datalumi)
  for mcfile in mcfiles:
    if "data" in mcfile: continue
    f = open(mcfile, "r")
    mcWeights[dataset][os.path.basename(mcfile).replace(".lumicalc.sum","")]  = datalumi/float(f.readlines()[0])
  #DY weights
  for dyfile in dyfiles:
    f = open(dyfile, "r")
    print dyfile
    mcWeights[dataset][os.path.basename(dyfile).replace(".meta.json","")] = json.load(f)['n_evts']/DYXS[os.path.basename(dyfile)[:3]]
    if "DYJ" in dyfile: dyLumi = mcWeights[dataset][os.path.basename(dyfile).replace(".meta.json","")]
  #W weights
  for wfile in wfiles:
    f = open(wfile, "r")
    mcWeights[dataset][os.path.basename(wfile).replace(".meta.json","")] = json.load(f)['n_evts']/WXS[os.path.basename(wfile)[:2]]
    if "WJ" in wfile: wLumi = mcWeights[dataset][os.path.basename(wfile).replace(".meta.json","")]

  for mc in mcWeights[dataset]:
    if "DYJ" in mc and not "M-10to50" in mc:
      mcWeights[dataset][mc] = DYNNLO*datalumi/dyLumi
    elif "DY" in mc and not "M-10to50" in mc:
      mcWeights[dataset][mc] = DYNNLO*datalumi/(mcWeights[dataset][mc]+dyLumi)
    elif "WJ" in mc: 
      mcWeights[dataset][mc] = WNNLO*datalumi/wLumi
    elif "W" in mc and "Jet" in mc:
      mcWeights[dataset][mc] = WNNLO*datalumi/(mcWeights[dataset][mc]+wLumi)

print mcWeights
with open("weights.json", "w") as outfile: 
    json.dump(mcWeights, outfile)
