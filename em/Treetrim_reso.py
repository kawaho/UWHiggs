import os
from ROOT import gROOT, TFile, TH1F
from Kinematics import functor_gg
import sys
import glob
import math
import array 
weight = array.array('f',[0])
gROOT.SetBatch(True)

fFileold = TFile("BDT/BDT.root")
oldtree1 = fFileold.Get("TreeS")
oldtree2 = fFileold.Get("TreeB")

fFilenew = TFile("BDT_reso.root","recreate")

newtree1 = oldtree1.CloneTree(0)
newtree1.SetName("TreeS") 

newtree2 = oldtree2.CloneTree(0)
newtree2.SetName("TreeB") 

nEntries1 = oldtree1.GetEntries()
nEntries2 = oldtree2.GetEntries()

weight = array.array('f', [0])  
newBranch1 =  newtree1.Branch("new_weight", weight, "new_weight/F")
newBranch2 =  newtree2.Branch("new_weight", weight, "new_weight/F")

for i in range(0, nEntries1):
  oldtree1.GetEntry(i)
  if oldtree1.Nj == 0:
    if oldtree1.mEta < 0.8 and oldtree1.eEta < 1.5:
      weight[0] = oldtree1.weight*0.01/1.9
    elif oldtree1.mEta > 0.8 and oldtree1.eEta < 1.5:
      weight[0] = oldtree1.weight*0.01/2.356
    elif oldtree1.mEta > 0.8 and oldtree1.eEta > 1.5:
      weight[0] = oldtree1.weight*0.01/3.268
    else:
      weight[0] = oldtree1.weight*0.01/3.413
  if oldtree1.Nj == 1:
    if oldtree1.mEta < 0.8 and oldtree1.eEta < 1.5:
      weight[0] = oldtree1.weight*0.01/1.906
    elif oldtree1.mEta > 0.8 and oldtree1.eEta < 1.5:
      weight[0] = oldtree1.weight*0.01/2.353
    elif oldtree1.mEta > 0.8 and oldtree1.eEta > 1.5:
      weight[0] = oldtree1.weight*0.01/3.2
    else:
      weight[0] = oldtree1.weight*0.01/3.464
  else:
    if oldtree1.mEta < 0.8 and oldtree1.eEta < 1.5:
      weight[0] = oldtree1.weight*0.01/1.893
    elif oldtree1.mEta > 0.8 and oldtree1.eEta < 1.5:
      weight[0] = oldtree1.weight*0.01/2.36
    elif oldtree1.mEta > 0.8 and oldtree1.eEta > 1.5:
      weight[0] = oldtree1.weight*0.01/3.121
    else:
      weight[0] = oldtree1.weight*0.01/3.452
  newtree1.Fill()
newtree1.Write()

for i in range(0, nEntries2):
  oldtree2.GetEntry(i)
  if oldtree2.Nj == 0:
    if oldtree2.mEta < 0.8 and oldtree2.eEta < 1.5:
      weight[0] = oldtree2.weight*0.01/1.9
    elif oldtree2.mEta > 0.8 and oldtree2.eEta < 1.5:
      weight[0] = oldtree2.weight*0.01/2.356
    elif oldtree2.mEta > 0.8 and oldtree2.eEta > 1.5:
      weight[0] = oldtree2.weight*0.01/3.268
    else:
      weight[0] = oldtree2.weight*0.01/3.413
  if oldtree2.Nj == 1:
    if oldtree2.mEta < 0.8 and oldtree2.eEta < 1.5:
      weight[0] = oldtree2.weight*0.01/1.906
    elif oldtree2.mEta > 0.8 and oldtree2.eEta < 1.5:
      weight[0] = oldtree2.weight*0.01/2.353
    elif oldtree2.mEta > 0.8 and oldtree2.eEta > 1.5:
      weight[0] = oldtree2.weight*0.01/3.2
    else:
      weight[0] = oldtree2.weight*0.01/3.464
  else:
    if oldtree2.mEta < 0.8 and oldtree2.eEta < 1.5:
      weight[0] = oldtree2.weight*0.01/1.893
    elif oldtree2.mEta > 0.8 and oldtree2.eEta < 1.5:
      weight[0] = oldtree2.weight*0.01/2.36
    elif oldtree2.mEta > 0.8 and oldtree2.eEta > 1.5:
      weight[0] = oldtree2.weight*0.01/3.121
    else:
      weight[0] = oldtree2.weight*0.01/3.452
  newtree2.Fill()
newtree2.Write()

