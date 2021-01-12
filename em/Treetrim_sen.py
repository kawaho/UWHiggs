import os
from ROOT import gROOT, TFile, TH1F
from Kinematics import functor_gg
import sys
import glob
import math
import array 

gROOT.SetBatch(True)

fFileold = TFile("BDT/BDT.root")
oldtree1 = fFileold.Get("TreeS")
oldtree2 = fFileold.Get("TreeB")

nEntries1 = oldtree1.GetEntries()
nEntries2 = oldtree2.GetEntries()

S = 0
B = 0

for i in range(0, nEntries1):
  oldtree1.GetEntry(i)
  if oldtree1.e_m_Mass < 130 and oldtree1.e_m_Mass > 120 and (oldtree1.Nj==2 and oldtree1.j1_j2_mass>400 and oldtree1.DeltaEta_j1_j2>2.5):
    S+=oldtree1.weight

for i in range(0, nEntries2):
  oldtree2.GetEntry(i)
  if oldtree2.e_m_Mass < 130 and oldtree2.e_m_Mass > 120 and (oldtree2.Nj==2 and oldtree2.j1_j2_mass>400 and oldtree2.DeltaEta_j1_j2>2.5):
    B+=oldtree2.weight
print S/math.sqrt(B)

