import os
from ROOT import gROOT, TFile
import sys
import glob
import math
import numpy as np

gROOT.SetBatch(True)

fFile = TFile("data_single2017.root")
fTree = fFile.Get("opttree")
nEntries = fTree.GetEntries()

numofvbf = 0
for i in range(0, nEntries):
  fTree.GetEntry(i)
  if fTree.cat == 5 and not (fTree.e_m_Mass > 120 and fTree.e_m_Mass < 130):
    numofvbf+=1
print numofvbf
 
