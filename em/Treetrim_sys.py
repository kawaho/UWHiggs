import os
from ROOT import gROOT, TFile, TH1F, TGraph
from Kinematics import var_d_star_gg, bdtSys
import sys
import glob
import math
import array 
import numpy as np 
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA

gROOT.SetBatch(True)

mva = array.array('f', [0])

def var_d_gg(tree):
  return {'m_met_mT': tree.m_met_mT,'e_met_mT': tree.e_met_mT, 'emEta': tree.emEta, 'DeltaEta_m_met': tree.DeltaEta_m_met, 'DeltaEta_e_met': tree.DeltaEta_e_met, 'MetEt': tree.MetEt, 'DeltaPhi_e_met': tree.DeltaPhi_e_met, 'emPt': tree.emPt, 'DeltaPhi_em_j1': tree.DeltaPhi_em_j1, 'ePt_Per_e_m_Mass': tree.ePt_Per_e_m_Mass , 'mPt_Per_e_m_Mass': tree.mPt_Per_e_m_Mass,'j1Pt': tree.j1Pt, 'DeltaEta_em_j1': tree.DeltaEta_em_j1, 'e_m_PZeta': tree.e_m_PZeta, 'DeltaPhi_m_met': tree.DeltaPhi_m_met} 

fFileold = TFile("BDT/BDT_Sys.root")
fFilenew = TFile("BDT_Sys.root","recreate")

for sys in bdtSys:

  xml_name_gg = os.path.join(os.getcwd(), "dataset/weights/TMVAClassification_BDT_gg_sys_"+sys.replace("_","")+".weights.xml")
  functor_gg = FunctorFromMVA('BDT method', xml_name_gg, *var_d_star_gg)


  oldtree1 = fFileold.Get(sys+"TreeS")
  oldtree2 = fFileold.Get(sys+"TreeB")

  newtree1 = oldtree1.CloneTree(0)
  newtree1.SetName(sys+"TreeSgg_120-130GeV") 

  newtree2 = oldtree2.CloneTree(0)
  newtree2.SetName(sys+"TreeBgg_120-130GeV") 

  nEntries1 = oldtree1.GetEntries()
  nEntries2 = oldtree2.GetEntries()

  newBranch1 =  newtree1.Branch("mva", mva, "mva/F")
  newBranch2 =  newtree2.Branch("mva", mva, "mva/F")

  hmvaS = TH1F(sys+"_mvaS", "Signal MVA", 200, -1, 1)
  hmvaB = TH1F(sys+"_mvaB", "Background MVA", 200, -1, 1)

  emM, mva_emM = array.array('f'), array.array('f')

  for i in range(0, nEntries2):
    oldtree2.GetEntry(i)
    if  oldtree2.e_m_Mass < 130 and oldtree2.e_m_Mass > 120 and not (oldtree2.Nj==2 and oldtree2.j1_j2_mass>400 and oldtree2.DeltaEta_j1_j2>2.5):
      mva[0] = functor_gg(**var_d_gg(newtree2)) 
      mva_emM.append(mva[0])
      emM.append(oldtree2.e_m_Mass)
      newtree2.Fill()
      if oldtree2.weight!=0:
        hmvaB.Fill(mva[0], oldtree2.weight)

  print "Passing Background Rate of ", sys, ": ", newtree2.GetEntries()/nEntries2
  newtree2.Write()
  hmvaB.Write()

  for i in range(0, nEntries1):
    oldtree1.GetEntry(i)
    if  oldtree1.e_m_Mass < 130 and oldtree1.e_m_Mass > 120 and not (oldtree1.Nj==2 and oldtree1.j1_j2_mass>400 and oldtree1.DeltaEta_j1_j2>2.5):
      mva[0] = functor_gg(**var_d_gg(oldtree1)) 
      newtree1.Fill()
      if oldtree1.weight!=0:
        hmvaS.Fill(mva[0], oldtree1.weight)
  
  print "Passing Signal Rate of ", sys, ": ", newtree1.GetEntries()/nEntries1
  newtree1.Write()
  hmvaS.Write()

  xq = np.array([1-0.61, 1-0.31])
  yq = np.empty(2)
  hmvaS.GetQuantiles(2,yq,xq)
  print sys, hmvaS.FindBin(yq[0])*0.01-0.005-1
  print sys, hmvaS.FindBin(yq[1])*0.01-0.005-1
