from ROOT import TH2F, TFile, TCanvas, gStyle, TLegend, TLine, gPad, TLatex, TProfile
from Kinematics import functor_gg
import array 

def var_d_gg(tree):
  return {'m_met_mT': tree.m_met_mT,'e_met_mT': tree.e_met_mT, 'emEta': tree.emEta, 'DeltaEta_m_met': tree.DeltaEta_m_met, 'DeltaEta_e_met': tree.DeltaEta_e_met, 'MetEt': tree.MetEt, 'DeltaPhi_e_met': tree.DeltaPhi_e_met, 'emPt': tree.emPt, 'DeltaPhi_em_j1': tree.DeltaPhi_em_j1, 'ePt_Per_e_m_Mass': tree.ePt_Per_e_m_Mass , 'mPt_Per_e_m_Mass': tree.mPt_Per_e_m_Mass,'j1Pt': tree.j1Pt, 'DeltaEta_em_j1': tree.DeltaEta_em_j1, 'e_m_PZeta': tree.e_m_PZeta, 'DeltaPhi_m_met': tree.DeltaPhi_m_met} 

fFileold = TFile("BDT/BDT.root")
oldtree2 = fFileold.Get("TreeB")
nEntries2 = oldtree2.GetEntries()

gStyle.SetOptStat(False)
canvas = TCanvas('canvas','canvas',850,800)
MMVA = TH2F('MMVA', ' ', 70, -0.4, 0.3, 50, 110, 160)
MMVAP = TProfile('MMVA', ' ', 70, -0.4, 0.3, 110, 160)

for i in range(0, nEntries2):
  oldtree2.GetEntry(i)
  if  not (oldtree2.Nj==2 and oldtree2.j1_j2_mass>400 and oldtree2.DeltaEta_j1_j2>2.5):
    mva = functor_gg(**var_d_gg(oldtree2)) 
    MMVA.Fill(mva, oldtree2.e_m_Mass, oldtree2.weight)
    MMVAP.Fill(mva, oldtree2.e_m_Mass, oldtree2.weight)


MMVA.SetXTitle("BDT Discriminator")
MMVA.SetYTitle("m_{e#mu} (GeV)")
MMVA.Draw("COLZ")

latex = TLatex()
latex.SetNDC()
latex.SetTextFont(43)
latex.SetTextSize(20)
latex.SetTextAlign(31)
latex.SetTextAlign(11)
label_text = "#bf{CMS Preliminary}"
data_text = ("41.5 fb^{-1}")
data_text += " (2017,"
data_text += " %i TeV)" % 13
jets_text = "e#mu"
latex.DrawLatex(0.12, 0.91, label_text)
latex.DrawLatex(0.66, 0.91, data_text)

canvas.SaveAs("MMVA.png")

MMVAP.SetXTitle("BDT Discriminator")
MMVAP.SetYTitle("Profile of m_{e#mu} (GeV)")
MMVAP.GetYaxis().SetRangeUser(110, 160);
MMVAP.Draw()

latex = TLatex()
latex.SetNDC()
latex.SetTextFont(43)
latex.SetTextSize(20)
latex.SetTextAlign(31)
latex.SetTextAlign(11)
label_text = "#bf{CMS Preliminary}"
data_text = ("41.5 fb^{-1}")
data_text += " (2017,"
data_text += " %i TeV)" % 13
jets_text = "e#mu"
latex.DrawLatex(0.12, 0.91, label_text)
latex.DrawLatex(0.66, 0.91, data_text)

canvas.SaveAs("MMVAP.png")

