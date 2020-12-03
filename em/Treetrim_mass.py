import os
from ROOT import gROOT, TFile, TH1F, TGraph
from Kinematics import functor_gg
import sys
import glob
import math
import array 

gROOT.SetBatch(True)

fFileold = TFile("BDT_allyear.root")
oldtree1 = fFileold.Get("TreeS")
oldtree2 = fFileold.Get("TreeB")

fFilenew = TFile("BDT_allyear_trim.root","recreate")

newtree1 = oldtree1.CloneTree(0)
newtree1.SetName("TreeS") 

newtree2 = oldtree2.CloneTree(0)
newtree2.SetName("TreeB") 

nEntries1 = oldtree1.GetEntries()
nEntries2 = oldtree2.GetEntries()

for i in range(nEntries2):
  oldtree2.GetEntry(i)
  if  oldtree2.e_m_Mass < 130 and oldtree2.e_m_Mass > 120:
    newtree2.Fill()
newtree2.Write()

for i in range(nEntries1):
  oldtree1.GetEntry(i)
  if  oldtree1.e_m_Mass < 130 and oldtree1.e_m_Mass > 120:
    newtree1.Fill()
newtree1.Write()


