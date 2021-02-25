import os
from ROOT import gROOT, TFile, TH1F, TH2F, TGraph
from Kinematics import functor_gg
import sys
import glob
import math
import array 
import time
start_time = time.time()
gROOT.SetBatch(True)

mva = array.array('f', [0])

var_d_star = ["mPt_Per_e_m_Mass","ePt_Per_e_m_Mass","emEta","DeltaR_e_m","m_met_mT_per_M","e_met_mT_per_M","MetEt","j1Pt","j1Eta","DeltaR_em_j1","j2Eta","DeltaR_em_j2","DeltaEta_j1_j2","R_pT","Nj","Ht","j1_j2_mass","weight","e_m_Mass"]


#def var_d_vbf(tree):
#  return {"mPt_Per_e_m_Mass":tree.mPt_Per_e_m_Mass,"ePt_Per_e_m_Mass":tree.ePt_Per_e_m_Mass,"emEta":tree.emEta,"DeltaR_e_m":tree.DeltaR_e_m,"m_met_mT_per_M":tree.m_met_mT_per_M,"e_met_mT_per_M":tree.e_met_mT_per_M,"MetEt":tree.MetEt,"j1Eta":tree.j1Eta,"DeltaR_em_j1":tree.DeltaR_em_j1,"DeltaEta_j1_j2":tree.DeltaEta_j1_j2,"j2Eta":tree.j2Eta,"DeltaR_em_j2":tree.DeltaR_em_j2,"R_pT":tree.R_pT,"Ht":tree.Ht,"j1Pt":tree.j1Pt}
#
def var_d_gg(tree):
#  return {"mPt_Per_e_m_Mass":tree.mPt_Per_e_m_Mass,"ePt_Per_e_m_Mass":tree.ePt_Per_e_m_Mass,"emEta":tree.emEta,"DeltaR_e_m":tree.DeltaR_e_m,"j1Pt":tree.j1Pt,"j1Eta":tree.j1Eta,"DeltaR_em_j1":tree.DeltaR_em_j1,"DeltaEta_j1_j2":tree.DeltaEta_j1_j2,"j2Eta":tree.j2Eta,"DeltaR_em_j2":tree.DeltaR_em_j2,"R_pT":tree.R_pT,"Nj":tree.Nj}
  return {"mPt_Per_e_m_Mass":tree.mPt_Per_e_m_Mass,"ePt_Per_e_m_Mass":tree.ePt_Per_e_m_Mass,"emEta":tree.emEta,"DeltaR_e_m":tree.DeltaR_e_m,"m_met_mT_per_M":tree.m_met_mT_per_M,"e_met_mT_per_M":tree.e_met_mT_per_M,"MetEt":tree.MetEt,"j1Pt":tree.j1Pt,"j1Eta":tree.j1Eta,"DeltaR_em_j1":tree.DeltaR_em_j1,"DeltaEta_j1_j2":tree.DeltaEta_j1_j2,"j2Eta":tree.j2Eta,"DeltaR_em_j2":tree.DeltaR_em_j2,"R_pT":tree.R_pT,"Nj":tree.Nj}
#  return {'e_m_Mass': tree.e_m_Mass, 'DeltaPhi_e_m': tree.DeltaPhi_e_m, 'DeltaEta_e_m': tree.DeltaEta_e_m,'emEta': tree.emEta, 'DeltaEta_m_met': tree.DeltaEta_m_met, 'DeltaEta_e_met': tree.DeltaEta_e_met, 'MetEt': tree.MetEt, 'DeltaPhi_e_met': tree.DeltaPhi_e_met, 'emEta': tree.emEta, 'DeltaPhi_em_j1': tree.DeltaPhi_em_j1, 'j1Pt': tree.j1Pt, 'DeltaEta_em_j1': tree.DeltaEta_em_j1, 'DeltaPhi_m_met': tree.DeltaPhi_m_met, 'e_met_mT_per_M' : tree.e_met_mT_per_M,'m_met_mT_per_M' :tree.m_met_mT_per_M, 'emPt' : tree.emPt, 'j2Pt': tree.j2Pt,'DeltaEta_em_j2': tree.DeltaEta_em_j2,'DeltaPhi_em_j2': tree.DeltaPhi_em_j2,'DeltaEta_j1_j2':tree.DeltaEta_j1_j2,'DeltaPhi_j1_j2': tree.DeltaPhi_j1_j2,'j1_j2_mass':tree.j1_j2_mass ,'e_m_PZeta':tree.e_m_PZeta} 

fFileold = TFile("BDT/BDT_or2_jets.root")
oldtree1 = fFileold.Get("TreeS")
oldtree2 = fFileold.Get("TreeB")
oldtree1.SetBranchStatus("*", 0)
oldtree2.SetBranchStatus("*", 0)
for var in var_d_star:
  oldtree1.SetBranchStatus(var, 1)
  oldtree2.SetBranchStatus(var, 1)
fFilenew = TFile("BDT_sig.root","recreate")
#fFilenew = TFile("BDThj.root","recreate")

newtree1 = oldtree1.CloneTree(0)
newtree1.SetName("TreeSgg_120-130GeV") 

newtree2 = oldtree2.CloneTree(0)
newtree2.SetName("TreeBgg_120-130GeV") 

nEntries1 = oldtree1.GetEntries()
nEntries2 = oldtree2.GetEntries()

newBranch1 =  newtree1.Branch("mva", mva, "mva/F")
newBranch2 =  newtree2.Branch("mva", mva, "mva/F")

massrange = [120,130]
binning = 1
hmvaS_gg = TH1F("mvaS_gg", "Signal MVA", 2000, -1, 1)
hmvaB_gg = TH1F("mvaB_gg", "Background MVA", 2000, -1, 1)
hmvaS_gg2D = TH2F("mvaS_gg2D", "Signal MVA", 2000, -1, 1, (massrange[1]-massrange[0])/binning, massrange[0], massrange[1])
hmvaB_gg2D = TH2F("mvaB_gg2D", "Background MVA", 2000, -1, 1, (massrange[1]-massrange[0])/binning, massrange[0], massrange[1] )
#hmvaS_vbf = TH1F("mvaS_vbf", "Signal MVA", 2000, -1, 1)
#hmvaB_vbf = TH1F("mvaB_vbf", "Background MVA", 2000, -1, 1)
#hmvaSEff_gg = TH1F("mvaEff_gg", "Signal Efficiency / MVA", 2000, 0, 2000)
#hmvaSEff_vbf = TH1F("mvaEff_vbf", "Signal Efficiency / MVA", 200, 0, 200)

#emM, mva_emM = array.array('f'), array.array('f')

for i in range(nEntries1):
  oldtree1.GetEntry(i)
  if not (oldtree1.e_m_Mass < massrange[1] and oldtree1.e_m_Mass >= massrange[0]):
    continue
  if oldtree1.Nj<=2 and not (oldtree1.Nj==2 and oldtree1.j1_j2_mass>400 and oldtree1.DeltaEta_j1_j2>2.5):
    mva[0] = functor_gg(**var_d_gg(oldtree1)) 
    newtree1.Fill()
    if oldtree1.weight!=0:
      hmvaS_gg.Fill(mva[0], oldtree1.weight)
      hmvaS_gg2D.Fill(mva[0], oldtree1.e_m_Mass, oldtree1.weight)
#  if oldtree1.Nj>2:
#    mva[0] = functor_vbf(**var_d_vbf(oldtree1)) 
#    newtree1.Fill()
#    if oldtree1.weight!=0:
#      hmvaS_vbf.Fill(mva[0], oldtree1.weight)

print "Passing Signal Rate: ", float(newtree1.GetEntries())/nEntries1
newtree1.Write()
hmvaS_gg.Write()
hmvaS_gg2D.Write()
#hmvaS_vbf.Write()

for i in range(nEntries2):
  oldtree2.GetEntry(i)
  if not (oldtree2.e_m_Mass < massrange[1] and oldtree2.e_m_Mass >= massrange[0]):
    continue
  if oldtree2.Nj<=2 and not (oldtree2.Nj==2 and oldtree2.j1_j2_mass>400 and oldtree2.DeltaEta_j1_j2>2.5):
    mva[0] = functor_gg(**var_d_gg(oldtree2)) 
#    mva_emM.append(mva[0])
#    emM.append(oldtree2.e_m_Mass)
    newtree2.Fill()
    if oldtree2.weight!=0:
      hmvaB_gg.Fill(mva[0], oldtree2.weight)
      hmvaB_gg2D.Fill(mva[0], oldtree2.e_m_Mass, oldtree2.weight)
#  if oldtree2.Nj>2:
#    mva[0] = functor_vbf(**var_d_vbf(oldtree2)) 
#    newtree2.Fill()
#    if oldtree2.weight!=0:
#      hmvaB_vbf.Fill(mva[0], oldtree2.weight)

#gr = TGraph(len(emM), emM, mva_emM)
print "Passing Background Rate: ", float(newtree2.GetEntries())/nEntries2
newtree2.Write()
hmvaB_gg.Write()
hmvaB_gg2D.Write()
#hmvaB_vbf.Write()
print("--- %s seconds ---" % (time.time() - start_time))
#gr.Write()

#totalSig = 0
#for i in range(1, hmvaS_gg.GetNbinsX()+1):
#  PassingSig = 0
#  for j in range(i, hmvaS_gg.GetNbinsX()+1):
#    if (i==1):
#      totalSig += hmvaS_gg.GetBinContent(j) 
#    PassingSig += hmvaS_gg.GetBinContent(j)
#  hmvaSEff_gg.Fill(i-0.5, PassingSig/totalSig)
#hmvaSEff_gg.Write() 

#a = 2
#b = 5
#for i in range(1, hmvaS_gg.GetNbinsX()+1):
#  B = hmvaB_gg.Integral(i,hmvaB_gg.GetNbinsX())
#  Seff = hmvaS_gg.Integral(i,hmvaS_gg.GetNbinsX())/hmvaS_gg.Integral()
#  if Seff!=0:
#    hmvaSEff_gg.Fill(i-0.5, (a**2/8+9*b**2/13+a*math.sqrt(B)+b*math.sqrt(b**2+4*a*math.sqrt(B)+4*B)/2)/Seff)
#hmvaSEff_gg.Write() 
#totalSig = 0
#for i in range(1, hmvaS_vbf.GetNbinsX()+1):
#  PassingSig = 0
#  for j in range(i, hmvaS_vbf.GetNbinsX()+1):
#    if (i==1):
#      totalSig += hmvaS_vbf.GetBinContent(j) 
#    PassingSig += hmvaS_vbf.GetBinContent(j)
#  hmvaSEff_vbf.Fill(i-0.5, PassingSig/totalSig)
#hmvaSEff_vbf.Write() 
#
