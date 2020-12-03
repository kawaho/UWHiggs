from ROOT import  Math, TMath, gROOT,TH1F, TH2F, TFile, TCanvas, gStyle, TLegend, TLine, gPad, TLatex, TProfile
from Kinematics import functor_gg
import array 
import numpy as np
gROOT.SetBatch(True)
def var_d_gg(tree):
  return {'DeltaPhi_e_m': tree.DeltaPhi_e_m, 'DeltaEta_e_m': tree.DeltaEta_e_m,  'DeltaEta_m_met': tree.DeltaEta_m_met, 'DeltaEta_e_met': tree.DeltaEta_e_met, 'MetEt': tree.MetEt, 'DeltaPhi_e_met': tree.DeltaPhi_e_met, 'emEta':tree.emEta, 'DeltaPhi_em_j1': tree.DeltaPhi_em_j1, 'j1Pt': tree.j1Pt, 'DeltaEta_em_j1': tree.DeltaEta_em_j1, 'DeltaPhi_m_met': tree.DeltaPhi_m_met} 

mva120 = np.array([])
mva125 = np.array([])
mva130 = np.array([])

f120 = TFile("results/Data2016JEC/AnalyzeEMBDT/Signal_120.root")
f125 = TFile("results/Data2016JEC/AnalyzeEMBDT/Signal_125.root")
f130 = TFile("results/Data2016JEC/AnalyzeEMBDT/Signal_130.root")
tree120 = f120.Get("TreeS")
n120 = tree120.GetEntries()
tree125 = f125.Get("TreeS")
n125 = tree125.GetEntries()
tree130 = f130.Get("TreeS")
n130 = tree130.GetEntries()

for i in range(n120):
  tree120.GetEntry(i)
  if  not (tree120.Nj==2 and tree120.j1_j2_mass>400 and tree120.DeltaEta_j1_j2>2.5):
    mva = functor_gg(**var_d_gg(tree120))
    mva120 = np.append(mva120,mva) 
for i in range(n125):
  tree125.GetEntry(i)
  if  not (tree125.Nj==2 and tree125.j1_j2_mass>400 and tree125.DeltaEta_j1_j2>2.5):
    mva = functor_gg(**var_d_gg(tree125))
    mva125 = np.append(mva125,mva) 
for i in range(n130):
  tree130.GetEntry(i)
  if  not (tree130.Nj==2 and tree130.j1_j2_mass>400 and tree130.DeltaEta_j1_j2>2.5):
    mva = functor_gg(**var_d_gg(tree130))
    mva130 = np.append(mva130,mva) 
mva120 = np.sort(mva120)
mva125 = np.sort(mva125)
mva130 = np.sort(mva130)
gof120 = Math.GoFTest(len(mva120),mva120,len(mva125),mva125)
gof130 = Math.GoFTest(len(mva130),mva130,len(mva125),mva125)
print gof120.AndersonDarling2SamplesTest()
print gof130.AndersonDarling2SamplesTest()
#print TMath.KolmogorovTest(len(mva120),mva120,len(mva125),mva125,'D')
#print TMath.KolmogorovTest(len(mva130),mva130,len(mva125),mva125,'D')
