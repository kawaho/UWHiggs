import os
from ROOT import gROOT, TFile
import sys
import glob
import math
import numpy as np

gROOT.SetBatch(True)

fFile = TFile("BDT/BDT_single.root")
fTreeS = fFile.Get("TreeS")
fTreeB = fFile.Get("TreeB")
nEntriesS = fTreeS.GetEntries()
nEntriesB = fTreeB.GetEntries()

for i in range(0, nEntriesS):
  fTreeS.GetEntry(i)
  print "Nj", fTreeS.Nj
  print "j1", fTreeS.j1Pt
  print "j2", fTreeS.j2Pt
  print "Ht", fTreeS.Ht
#Siggg = 0
#Sigeffgg = 0
#Bkgrejgg = 0
#
#
#totalSgg = 0
#totalBgg = 0
#Sgg = 0
#Bgg = 0
# 
#
#mvauppergg = 1
#
#for mvascan in np.linspace(1, -1, 10):
#  print "Scanning Lower Limit at MVA = ", mvascan
#  Sigggprev = Siggg
#  Sgg = 0
#  Bgg = 0
#
#  print "Upper MVA = ", mvauppergg
#
#  for i in range(0, nEntriesS):
#    fTreeS.GetEntry(i)
#    if (mvascan==1):
#      totalSgg += fTreeS.weight
#    mva = fTreeS.mva
#    if mva >= mvascan and mva < mvauppergg:
#      Sgg += fTreeS.weight
#  
#  Sigeffgg = Sgg/totalSgg
#  print "Passing Signal = ", Sgg
#  print "Total Signal = ", totalSgg 
#  print "Signal Eff = ", Sigeffgg
#
#  for i in range(0, nEntriesB):
#    fTreeB.GetEntry(i)
#    if (mvascan==1):
#      totalBgg += fTreeB.weight
#    mva = fTreeB.mva 
#    if mva >= mvascan and mva < mvauppergg:
#      Bgg += fTreeB.weight
#
#  Bkgrejgg = 1-Bgg/totalBgg
#  print "Passing Background = ", Bgg 
#  print "Total Background = ", totalBgg
#  print "Background Rejection = ",  Bkgrejgg
#
#  if (Bgg!=0):
#    Siggg = Sgg/math.sqrt(Bgg)
#
#  print "Significance = ", Siggg
#  
#  if (Sigggprev!=0):
#    if (2*abs(Siggg-Sigggprev)/(Sigggprev+Siggg) > 0.3):
#      mvauppergg = mvascan
#      print "mvauppergg", mvauppergg 


