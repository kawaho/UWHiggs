import os
from ROOT import gROOT, TFile
import sys
import glob
import math
import numpy as np

gROOT.SetBatch(True)

fFile = TFile("BDT.root")
fTreeS = fFile.Get("TreeSgg_120-130GeV")
fTreeB = fFile.Get("TreeBgg_120-130GeV")
nEntriesS = fTreeS.GetEntries()
nEntriesB = fTreeB.GetEntries()

Siggg = 0
Sigeffgg = 0
Bkgrejgg = 0


totalSgg = 0
totalBgg = 0
Sgg = 0
Bgg = 0
 

mvauppergg = 1

for mvascan in np.linspace(1, -1, 10):
  print "Scanning Lower Limit at MVA = ", mvascan
  Sigggprev = Siggg
  Sgg = 0
  Bgg = 0

  print "Upper MVA = ", mvauppergg

  for i in range(0, nEntriesS):
    fTreeS.GetEntry(i)
    if (mvascan==1):
      totalSgg += fTreeS.weight
    mva = fTreeS.mva
    if mva >= mvascan and mva < mvauppergg:
      Sgg += fTreeS.weight
  
  Sigeffgg = Sgg/totalSgg
  print "Passing Signal = ", Sgg
  print "Total Signal = ", totalSgg 
  print "Signal Eff = ", Sigeffgg

  for i in range(0, nEntriesB):
    fTreeB.GetEntry(i)
    if (mvascan==1):
      totalBgg += fTreeB.weight
    mva = fTreeB.mva 
    if mva >= mvascan and mva < mvauppergg:
      Bgg += fTreeB.weight

  Bkgrejgg = 1-Bgg/totalBgg
  print "Passing Background = ", Bgg 
  print "Total Background = ", totalBgg
  print "Background Rejection = ",  Bkgrejgg

  if (Bgg!=0):
    Siggg = Sgg/math.sqrt(Bgg)

  print "Significance = ", Siggg
  
  if (Sigggprev!=0):
    if (2*abs(Siggg-Sigggprev)/(Sigggprev+Siggg) > 0.3):
      mvauppergg = mvascan
      print "mvauppergg", mvauppergg 

#    fTree.mPt_Per_e_m_Mass,
#    fTree.ePt_Per_e_m_Mass,
#    fTree.e_m_Mass,
#    fTree.emPt,
#    fTree.emEta,
#    fTree.mEta,
#    fTree.eEta,
#    fTree.j1Pt,
#    fTree.j2Pt,
#    fTree.j1Eta,
#    fTree.j2Eta,
#    fTree.DeltaEta_em_j1,
#    fTree.DeltaPhi_em_j1,
#    fTree.DeltaEta_em_j2,
#    fTree.DeltaPhi_em_j2,
#    fTree.DeltaEta_j1_j2,
#    fTree.DeltaPhi_j1_j2,
#    fTree.Zeppenfeld,
#    fTree.j1_j2_mass,
#    fTree.minDeltaPhi_em_j1j2,
#    fTree.minDeltaEta_em_j1j2,
#    fTree.Nj
#    fTree.e_met_mT,
#    fTree.m_met_mT,
#    fTree.DeltaPhi_e_met,
#    fTree.DeltaPhi_m_met,
#    fTree.DeltaEta_e_met,
#    fTree.DeltaEta_m_met,
#    fTree.MetEt,
#    fTree.e_m_PZeta,
#    fTree.R_pT,
#    fTree.pT_cen,
#    fTree.weight

