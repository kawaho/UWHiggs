import os
from ROOT import gROOT, TFile, TH2F
import sys
import glob
import math
import numpy as np

gROOT.SetBatch(True)

fFile = TFile("BDT_allyear_trim.root")
fTreeS = fFile.Get("TreeS")
fTreeB = fFile.Get("TreeB")
nEntriesS = fTreeS.GetEntries()
nEntriesB = fTreeB.GetEntries()

fnew = TFile("vbf_check1.root", "recreate")
senplot = TH2F("","",50,0,5,20,350,550)
mjj = 350
eta = 0
while mjj < 551:
  while eta < 5.1:
    S_vbf = 0
    B_vbf = 0
    S_gg = 0
    B_gg = 0
    print "Checking mjj = %f and Deta = %f"%(mjj,eta)
    for i in range(nEntriesS):
      fTreeB.GetEntry(i)
      if fTreeB.Nj == 2 and fTreeB.j1_j2_mass > mjj and fTreeB.DeltaEta_j1_j2 > eta:
        B_vbf += fTreeB.weight
      else: 
        B_gg += fTreeB.weight

    for i in range(nEntriesS):
      fTreeS.GetEntry(i)
      if fTreeS.Nj == 2 and fTreeS.j1_j2_mass > mjj and fTreeS.DeltaEta_j1_j2 > eta:
        S_vbf += fTreeS.weight
      else: 
        S_gg += fTreeS.weight
    sen = math.sqrt(S_vbf**2/B_vbf + S_gg**2/B_gg)
    senplot.Fill(eta,mjj,sen)
    eta += 0.1
  eta = 0
  mjj += 10
senplot.Write()
fnew.Write()
