import os
from ROOT import gROOT, TFile, TH1F, TH2F, TProfile
from Kinematics import functor_gg
import sys
import glob
import math
import array 
import numpy as np
gROOT.SetBatch(True)

mva = array.array('f', [0])

def var_d_gg(tree):
  return {'m_met_mT': tree.m_met_mT,'e_met_mT': tree.e_met_mT, 'emEta': tree.emEta, 'DeltaEta_m_met': tree.DeltaEta_m_met, 'DeltaEta_e_met': tree.DeltaEta_e_met, 'MetEt': tree.MetEt, 'DeltaPhi_e_met': tree.DeltaPhi_e_met, 'emPt': tree.emPt, 'DeltaPhi_em_j1': tree.DeltaPhi_em_j1, 'ePt_Per_e_m_Mass': tree.ePt_Per_e_m_Mass , 'mPt_Per_e_m_Mass': tree.mPt_Per_e_m_Mass,'j1Pt': tree.j1Pt, 'DeltaEta_em_j1': tree.DeltaEta_em_j1, 'e_m_PZeta': tree.e_m_PZeta, 'DeltaPhi_m_met': tree.DeltaPhi_m_met} 
#  return {'eEta': tree.eEta, 'mEta': tree.mEta, 'm_met_mT': tree.m_met_mT,'e_met_mT': tree.e_met_mT, 'emEta': tree.emEta, 'DeltaEta_m_met': tree.DeltaEta_m_met, 'DeltaEta_e_met': tree.DeltaEta_e_met, 'MetEt': tree.MetEt, 'DeltaPhi_e_met': tree.DeltaPhi_e_met, 'emPt': tree.emPt, 'DeltaPhi_em_j1': tree.DeltaPhi_em_j1, 'ePt_Per_e_m_Mass': tree.ePt_Per_e_m_Mass , 'mPt_Per_e_m_Mass': tree.mPt_Per_e_m_Mass,'j1Pt': tree.j1Pt, 'DeltaEta_em_j1': tree.DeltaEta_em_j1, 'e_m_PZeta': tree.e_m_PZeta, 'DeltaPhi_m_met': tree.DeltaPhi_m_met} 

fFileold = TFile("BDT/BDT.root")
oldtree1 = fFileold.Get("TreeS")

fFilenew = TFile("bdteta.root","recreate")

nEntries1 = oldtree1.GetEntries()
mdetectorrange = np.array([-2.4, -0.8, 0.8, 2.4])
edetectorrange = np.array([-2.5, -1.5, 1.5, 2.5])
hm = TH2F("hm", "hm", 50, -0.2, 0.3, 50, -2.5, 2.5)
hmp = TProfile('hmp', ' ', 3, mdetectorrange)
he = TH2F("he", "he", 50, -0.2, 0.3, 50, -2.5, 2.5)
hep = TProfile('hep', ' ', 3, edetectorrange)

for i in range(0, nEntries1):
  oldtree1.GetEntry(i)
  if  not (oldtree1.Nj==2 and oldtree1.j1_j2_mass>400 and oldtree1.DeltaEta_j1_j2>2.5):
    mva[0] = functor_gg(**var_d_gg(oldtree1)) 
    hm.Fill(mva[0], oldtree1.mEta, oldtree1.weight)
    he.Fill(mva[0], oldtree1.eEta, oldtree1.weight)
    hmp.Fill(oldtree1.mEta, mva[0], oldtree1.weight)
    hep.Fill(oldtree1.eEta, mva[0], oldtree1.weight)
hm.Write()
he.Write()
hmp.Write()
hep.Write()

