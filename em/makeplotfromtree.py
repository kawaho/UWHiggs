import os
from ROOT import gROOT, TFile, TH1F, TGraph
from Kinematics import functor_gg
import sys
import glob
import math
import array 

gROOT.SetBatch(True)
fFile = TFile("bkhchekc.root")
tree = fFile.Get("opttree")
hvbf = TH1F("memvbf", "m_{e#mu}", 50, 110, 160)
hgg0 = TH1F("memgg0", "m_{e#mu}", 50, 110, 160)
hgg1 = TH1F("memgg1", "m_{e#mu}", 50, 110, 160)
hgg2 = TH1F("memgg2", "m_{e#mu}", 50, 110, 160)
entries = tree.GetEntries()
fFilenew = TFile("bkgcheck.root","recreate")

for i in range(0, entries):
  tree.GetEntry(i)
  if tree.cat == 0:
    hgg0.Fill(tree.e_m_Mass, tree.weight)
  elif tree.cat == 1:
    hgg1.Fill(tree.e_m_Mass, tree.weight)
  elif tree.cat == 2:
    hgg2.Fill(tree.e_m_Mass, tree.weight)
  elif tree.cat == 3:
    hvbf.Fill(tree.e_m_Mass, tree.weight)

hgg0.Write()
hgg1.Write()
hgg2.Write()
hvbf.Write()
fFilenew.Write()


