import os
from ROOT import gROOT, TFile, TH1F, TGraph
from Kinematics import functor_gg
import sys
import glob
import math
import array 
import numpy as np

gROOT.SetBatch(True)

mva = array.array('f', [0])

def var_d_gg(tree):
#  return {'m_met_mT': tree.m_met_mT,'e_met_mT': tree.e_met_mT, 'emEta': tree.emEta, 'DeltaEta_m_met': tree.DeltaEta_m_met, 'DeltaEta_e_met': tree.DeltaEta_e_met, 'MetEt': tree.MetEt, 'DeltaPhi_e_met': tree.DeltaPhi_e_met, 'emPt': tree.emPt, 'DeltaPhi_em_j1': tree.DeltaPhi_em_j1, 'ePt_Per_e_m_Mass': tree.ePt_Per_e_m_Mass , 'mPt_Per_e_m_Mass': tree.mPt_Per_e_m_Mass,'j1Pt': tree.j1Pt, 'DeltaEta_em_j1': tree.DeltaEta_em_j1, 'e_m_PZeta': tree.e_m_PZeta, 'DeltaPhi_m_met': tree.DeltaPhi_m_met} 
  return {'mEta': tree.mEta, 'eEta': tree.eEta, 'm_met_mT': tree.m_met_mT,'e_met_mT': tree.e_met_mT, 'emEta': tree.emEta, 'DeltaEta_m_met': tree.DeltaEta_m_met, 'DeltaEta_e_met': tree.DeltaEta_e_met, 'MetEt': tree.MetEt, 'DeltaPhi_e_met': tree.DeltaPhi_e_met, 'emPt': tree.emPt, 'DeltaPhi_em_j1': tree.DeltaPhi_em_j1, 'ePt_Per_e_m_Mass': tree.ePt_Per_e_m_Mass , 'mPt_Per_e_m_Mass': tree.mPt_Per_e_m_Mass,'j1Pt': tree.j1Pt, 'DeltaEta_em_j1': tree.DeltaEta_em_j1, 'e_m_PZeta': tree.e_m_PZeta, 'DeltaPhi_m_met': tree.DeltaPhi_m_met} 

fFileold = TFile("BDT/BDT.root")
treeS = fFileold.Get("TreeS")
nEntriesS = treeS.GetEntries()

fFile = TFile("Reso_BDT.root", "recreate")
newtreeS = treeS.CloneTree(0)
newtreeS.SetName("TreeSgg") 
newBranch1 = newtreeS.Branch("mva", mva, "mva/F")
hmvaS = TH1F("mvaS", "Signal MVA", 200, -1, 1)

hm = []
for i in range(10):
  hm.append(TH1F("e_m_Mass_%i"%i, "e_m_Mass", 100, 110, 140))

for i in range(0, nEntriesS):
  if i%10000 == 0:
    print "Loop over old tree of %i/%i events..."%(i, nEntriesS-1)
  treeS.GetEntry(i)
  if  not (treeS.Nj==2 and treeS.j1_j2_mass>400 and treeS.DeltaEta_j1_j2>2.5):
    mva[0] = functor_gg(**var_d_gg(treeS)) 
    hmvaS.Fill(mva[0], treeS.weight)
    newtreeS.Fill()
hmvaS.Write()
nEntriesS = newtreeS.GetEntries()
totalSig = 0

n = 10
xq = np.empty(n)
yq = np.empty(n)
for i in range(n):
  xq[i] = (i+1)/float(n)

SigStep = [1]
mvaStep = []
hmvaS.GetQuantiles(n,yq,xq)
for j in range(n):
  SigStep.append(hmvaS.FindBin(yq[j]))
print SigStep
for sig in SigStep:
  mvaStep.append(sig*0.01-0.005-1) 
for i in range(0, nEntriesS):
  if i%10000 == 0:
    print "Loop over new tree of %i/%i events..."%(i, nEntriesS-1)
  newtreeS.GetEntry(i)
  for j in range(10):
    lower_ = mvaStep[j]
    upper_ = mvaStep[j+1]
    if (newtreeS.mva > lower_ and newtreeS.mva < upper_):
      hm[j].Fill(newtreeS.e_m_Mass, newtreeS.weight)
for i in range(10):
  hm[i].Write()
