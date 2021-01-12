from ROOT import  gROOT,TH1F, TH2F, TFile, TCanvas, gStyle, TLegend, TLine, gPad, TLatex, TProfile
from Kinematics import functor_gg
import array 
import numpy as np
gROOT.SetBatch(True)
def var_d_gg(tree):
  return {'DeltaPhi_e_m': tree.DeltaPhi_e_m, 'DeltaEta_e_m': tree.DeltaEta_e_m, 'm_met_mT': tree.m_met_mT,'e_met_mT': tree.e_met_mT, 'emEta': tree.emEta, 'DeltaEta_m_met': tree.DeltaEta_m_met, 'DeltaEta_e_met': tree.DeltaEta_e_met, 'MetEt': tree.MetEt, 'DeltaPhi_e_met': tree.DeltaPhi_e_met, 'emPt': tree.emPt, 'DeltaPhi_em_j1': tree.DeltaPhi_em_j1, 'j1Pt': tree.j1Pt, 'DeltaEta_em_j1': tree.DeltaEta_em_j1, 'e_m_PZeta': tree.e_m_PZeta, 'DeltaPhi_m_met': tree.DeltaPhi_m_met} 

n = 5
xq = np.array([.2,.4,.6,.8,1])
yq = np.empty(n)

fFilenew = TFile("BDT_plot.root")
hmvaB = fFilenew.Get("mvaB")

fFilenew2017 = TFile("../../UWHiggs2017/em/BDT_plot.root")
hmvaB2017 = fFilenew2017.Get("mvaB")

fFilenew2018 = TFile("../../UWHiggs/em/BDT_plot.root")
hmvaB2018 = fFilenew2018.Get("mvaB")

hmvaB.Add(hmvaB2017)
hmvaB.Add(hmvaB2018)
hmvaB.GetQuantiles(n,yq,xq)

fFileold = TFile("BDT/BDT.root")
oldtree2 = fFileold.Get("TreeB")
nEntries2 = oldtree2.GetEntries()

gStyle.SetOptStat(False)
canvas = TCanvas('canvas','canvas',850,800)

MMVA1 = TH1F('MMVA1', ' ', 50, 110, 160)
MMVA2 = TH1F('MMVA2', ' ', 50, 110, 160)
MMVA3 = TH1F('MMVA3', ' ', 50, 110, 160)
MMVA4 = TH1F('MMVA4', ' ', 50, 110, 160)
MMVA5 = TH1F('MMVA5', ' ', 50, 110, 160)

fFileplot = TFile("BDTVA.root","recreate")

for i in range(0, nEntries2):
  oldtree2.GetEntry(i)
  if  not (oldtree2.Nj==2 and oldtree2.j1_j2_mass>400 and oldtree2.DeltaEta_j1_j2>2.5):
    mva = functor_gg(**var_d_gg(oldtree2)) 
    if mva < yq[0]:
      MMVA1.Fill(oldtree2.e_m_Mass, oldtree2.weight)
    elif mva < yq[1]:
      MMVA2.Fill(oldtree2.e_m_Mass, oldtree2.weight)
    elif mva < yq[2]:
      MMVA3.Fill(oldtree2.e_m_Mass, oldtree2.weight)
    elif mva < yq[3]:
      MMVA4.Fill(oldtree2.e_m_Mass, oldtree2.weight)
    elif mva < yq[4]:
      MMVA5.Fill(oldtree2.e_m_Mass, oldtree2.weight)

MMVA1.Write()
MMVA2.Write()
MMVA3.Write()
MMVA4.Write()
MMVA5.Write()
