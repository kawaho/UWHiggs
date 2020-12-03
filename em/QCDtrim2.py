import os
from ROOT import gROOT, TFile
import sys
import glob
import math
import Kinematics
gROOT.SetBatch(True)

fFileold = TFile("results/Data2016JEC/AnalyzeEMBDTSys/QCD.root")
fFilenew = TFile("results/Data2016JEC/AnalyzeEMBDTSys/QCDtrim.root","recreate")

for sys in Kinematics.bdtSys:
  oldtree1 = fFileold.Get("TreeS")
  oldtree2 = fFileold.Get("TreeB")
  oldtree3 = fFileold.Get("TreeSss")
  oldtree4 = fFileold.Get("TreeBss")

  newtree4 = oldtree4.CloneTree(0)
  newtree4.SetName(sys+"TreeB")
  newtree3 = oldtree3.CloneTree(0)
  newtree3.SetName(sys+"TreeBss")
  newtree2 = oldtree2.CloneTree(0)
  newtree2.SetName(sys+"TreeS")
  newtree1 = oldtree1.CloneTree(0)
  newtree1.SetName(sys+"TreeSss")

  nEntries = oldtree4.GetEntries()
  for i in range(0, nEntries):
    oldtree4.GetEntry(i)
    if oldtree4.weight >=0:
      newtree4.Fill()

  newtree1.Write()
  newtree2.Write()
  newtree3.Write()
  newtree4.Write()

