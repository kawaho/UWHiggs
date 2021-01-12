import os
from ROOT import gROOT, TFile
import sys
import glob
import math
import numpy as np

def whichproc(f):
 if f.startswith('DY'):
   return 'DY'
 elif f.startswith('EWK'):
   return 'EWK'
 elif 'HToTauTau' in f or 'HToWW' in f:
   return 'SMH'
 elif f.startswith('TT') or f.startswith('ST'):
   return 'TOP'
 elif f.startswith('ZZ') or f.startswith('WZ') or f.startswith('WW'):
   return 'Diboson'
 elif f.startswith('QCD') or f.startswith('W1') or f.startswith('W2') or f.startswith('W3') or f.startswith('W4') or f.startswith('WGToLNuG') or f.startswith('WJetsToLNu') :
   return 'QCD'
 else:
   print f
   return ''


gROOT.SetBatch(True)
files = []
files.extend(glob.glob('results/Data2017JEC/AnalyzeEMBDT/*root')) 
fFile = TFile('BDT/BDT_single.root')
fTreeS = fFile.Get("TreeB")
nEntriesS = fTreeS.GetEntries()
totalweight = 0
weights_prop = {'': 0., 'DY':0. ,'EWK':0. , 'SMH':0. ,'TOP':0., 'Diboson': 0., 'QCD': 0. }
for i in range(nEntriesS):
  fTreeS.GetEntry(i)
  totalweight+=fTreeS.weight

for f in files:
  if 'data' in f or 'LFV' in f: continue
  fFile = TFile(f)
  f = f.replace('results/Data2017JEC/AnalyzeEMBDT/','')
  fTreeS = fFile.Get("TreeB")
  nEntriesS = fTreeS.GetEntries()
  n = 0
  for i in range(nEntriesS):
    fTreeS.GetEntry(i)
    n+=fTreeS.weight*100/totalweight
    weights_prop[whichproc(f)] += fTreeS.weight*100/totalweight
   #   n+=100./nEntriesS
#  print f.replace('results/Data2017JEC/AnalyzeEMBDT/',''), n
#print totalweight
print weights_prop
