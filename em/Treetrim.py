import os
from ROOT import gROOT, TFile, TH1F, TGraph
from Kinematics import functor_gg
import sys
import glob
import math
import array 

gROOT.SetBatch(True)

mva = array.array('f', [0])

def var_d_gg(tree):
  return {"mPt_Per_e_m_Mass":tree.mPt_Per_e_m_Mass,"ePt_Per_e_m_Mass":tree.ePt_Per_e_m_Mass,"emEta":tree.emEta,"DeltaR_e_m":tree.DeltaR_e_m,"m_met_mT_per_M":tree.m_met_mT_per_M,"e_met_mT_per_M":tree.e_met_mT_per_M,"MetEt":tree.MetEt,"j1Pt":tree.j1Pt,"j1Eta":tree.j1Eta,"DeltaR_em_j1":tree.DeltaR_em_j1,"j2Pt":tree.j2Pt,"j2Eta":tree.j2Eta,"DeltaR_em_j2":tree.DeltaR_em_j2,"R_pT":tree.R_pT}
#  return {'e_m_Mass': tree.e_m_Mass, 'DeltaPhi_e_m': tree.DeltaPhi_e_m, 'DeltaEta_e_m': tree.DeltaEta_e_m,'emEta': tree.emEta, 'DeltaEta_m_met': tree.DeltaEta_m_met, 'DeltaEta_e_met': tree.DeltaEta_e_met, 'MetEt': tree.MetEt, 'DeltaPhi_e_met': tree.DeltaPhi_e_met, 'emEta': tree.emEta, 'DeltaPhi_em_j1': tree.DeltaPhi_em_j1, 'j1Pt': tree.j1Pt, 'DeltaEta_em_j1': tree.DeltaEta_em_j1, 'DeltaPhi_m_met': tree.DeltaPhi_m_met, 'e_met_mT_per_M' : tree.e_met_mT_per_M,'m_met_mT_per_M' :tree.m_met_mT_per_M, 'emPt' : tree.emPt, 'j2Pt': tree.j2Pt,'DeltaEta_em_j2': tree.DeltaEta_em_j2,'DeltaPhi_em_j2': tree.DeltaPhi_em_j2,'DeltaEta_j1_j2':tree.DeltaEta_j1_j2,'DeltaPhi_j1_j2': tree.DeltaPhi_j1_j2,'j1_j2_mass':tree.j1_j2_mass ,'e_m_PZeta':tree.e_m_PZeta} 

fFileold = TFile("BDT/BDT_single.root")
oldtree1 = fFileold.Get("TreeS")
oldtree2 = fFileold.Get("TreeB")

#fFilenew = TFile("BDT_narrow.root","recreate")
fFilenew = TFile("BDT_plot.root","recreate")

newtree1 = oldtree1.CloneTree(0)
newtree1.SetName("TreeSgg_120-130GeV") 

newtree2 = oldtree2.CloneTree(0)
newtree2.SetName("TreeBgg_120-130GeV") 

nEntries1 = oldtree1.GetEntries()
nEntries2 = oldtree2.GetEntries()

newBranch1 =  newtree1.Branch("mva", mva, "mva/F")
newBranch2 =  newtree2.Branch("mva", mva, "mva/F")

hmvaS = TH1F("mvaS", "Signal MVA", 2000, -1, 1)
hmvaB = TH1F("mvaB", "Background MVA", 2000, -1, 1)
hmvaSEff = TH1F("mvaEff", "Signal Efficiency / MVA", 200, 0, 200)

emM, mva_emM = array.array('f'), array.array('f')

for i in range(nEntries2):
  oldtree2.GetEntry(i)
  if not (oldtree2.Nj==2 and oldtree2.j1_j2_mass>400 and oldtree2.DeltaEta_j1_j2>2.5):
#  if  oldtree2.e_m_Mass < 130 and oldtree2.e_m_Mass > 120 and not (oldtree2.Nj==2 and oldtree2.j1_j2_mass>400 and oldtree2.DeltaEta_j1_j2>2.5):
    mva[0] = functor_gg(**var_d_gg(oldtree2)) 
    mva_emM.append(mva[0])
    emM.append(oldtree2.e_m_Mass)
    newtree2.Fill()
    if oldtree2.weight!=0:
      hmvaB.Fill(mva[0], oldtree2.weight)

gr = TGraph(len(emM), emM, mva_emM)
print "Passing Background Rate: ", float(newtree2.GetEntries())/nEntries2
newtree2.Write()
hmvaB.Write()
#gr.Write()

for i in range(nEntries1):
  oldtree1.GetEntry(i)
  if not (oldtree1.Nj==2 and oldtree1.j1_j2_mass>400 and oldtree1.DeltaEta_j1_j2>2.5):
#  if  oldtree1.e_m_Mass < 130 and oldtree1.e_m_Mass > 120 and not (oldtree1.Nj==2 and oldtree1.j1_j2_mass>400 and oldtree1.DeltaEta_j1_j2>2.5):
    mva[0] = functor_gg(**var_d_gg(oldtree1)) 
    newtree1.Fill()
    if oldtree1.weight!=0:
      hmvaS.Fill(mva[0], oldtree1.weight)

print "Passing Signal Rate: ", float(newtree1.GetEntries())/nEntries1
newtree1.Write()
hmvaS.Write()

totalSig = 0
for i in range(1, hmvaS.GetNbinsX()+1):
  PassingSig = 0
  for j in range(i, hmvaS.GetNbinsX()+1):
    if (i==1):
      totalSig += hmvaS.GetBinContent(j) 
    PassingSig += hmvaS.GetBinContent(j)
  hmvaSEff.Fill(i-0.5, PassingSig/totalSig)
hmvaSEff.Write() 


