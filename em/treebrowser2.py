import os
from ROOT import gROOT, TFile
import sys
import glob
import math
import numpy as np

gROOT.SetBatch(True)

fFile = TFile("BDT/BDT_Sys.root")
fTreeS = fFile.Get("JetRelativeSampleDown_TreeS")
fTreeB = fFile.Get("JetRelativeSampleDown_TreeB")
nEntriesS = fTreeS.GetEntries()
nEntriesB = fTreeB.GetEntries()

for i in range(0, nEntriesS):
  fTreeS.GetEntry(i)
#  if fTreeS.j1Pt > 9000:
  if fTreeS.DeltaEta_em_j1 > 10:
    print "Hellos ", fTreeS.DeltaEta_em_j1
    print fTreeS.Nj
    print fTreeS.j1_j2_mass
    print fTreeS.j1Pt
    print fTreeS.j1Eta
 

for i in range(0, nEntriesB):
  fTreeB.GetEntry(i)
#  if fTreeS.j1Pt > 9000:
  if fTreeB.DeltaEta_em_j1 > 10 :
    print "hellob", fTreeB.DeltaEta_em_j1
    print fTreeB.Nj
    print fTreeB.j1_j2_mass
    print fTreeB.j1Pt
    print fTreeS.j1Eta
 

