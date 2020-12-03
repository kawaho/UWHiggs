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
fTreeS.SetBranchStatus("*",0)
fTreeS.SetBranchStatus("Nj",1)
fTreeS.SetBranchStatus("j1_j2_mass",1)
fTreeS.SetBranchStatus("DeltaEta_j1_j2",1)
fTreeS.SetBranchStatus("weight",1)
fTreeB.SetBranchStatus("*",0)
fTreeB.SetBranchStatus("Nj",1)
fTreeB.SetBranchStatus("j1_j2_mass",1)
fTreeB.SetBranchStatus("DeltaEta_j1_j2",1)
fTreeB.SetBranchStatus("weight",1)

fnew = TFile("vbf_check.root", "recreate")
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
    for i in fTreeB:
      if i.Nj == 2 and i.j1_j2_mass > mjj and i.DeltaEta_j1_j2 > eta:
        B_vbf += i.weight
      else: 
        B_gg += i.weight
    for i in fTreeS:
      if i.Nj == 2 and i.j1_j2_mass > mjj and i.DeltaEta_j1_j2 > eta:
        S_vbf += i.weight
      else: 
        S_gg += i.weight
    sen = math.sqrt(S_vbf**2/B_vbf + S_gg**2/B_gg)
    senplot.Fill(eta,mjj,sen)
    eta += 0.1
  eta = 0
  mjj += 10
senplot.Write()
fnew.Write()
