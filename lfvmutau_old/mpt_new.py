import os
from sys import argv, stdout, stderr
import ROOT
import sys
from FinalStateAnalysis.PlotTools.MegaBase import make_dirs

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)
ROOT.gStyle.SetOptTitle(0)
ROOT.gStyle.SetTitle("Muon Pt for SM and LFV")
ROOT.gStyle.SetOptTitle(1)
ROOT.TGaxis.SetMaxDigits(2)

canvas = ROOT.TCanvas("canvas","canvas",800,800)
legend = ROOT.TLegend(0.52,0.7,0.9,0.9)

lfvfilelist = ['results/LFV_mutau/LFVMuTauAnalyserGen/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8_v6-v1.root','results/LFV_mutau/LFVMuTauAnalyserGen/GluGluHToTauTau_M125_13TeV_powheg_pythia8_v6-v1.root']# , 'results/LFV_mutau/LFVMuTauAnalyserGen/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8_v6-v1.root']

filepath = 'plots/LFV_mutau/LFVMuTauAnalyserGen/'

lumi_lfv = 514721.021207
lumi_sm = 482953.847811
#events_lfv = 250000
#events_sm = 1471061

file1 = lfvfilelist[1]	
TauTaufile = ROOT.TFile(file1)
histo_sm = TauTaufile.Get('fromHiggs/mGenPt')
histo_sm.Scale(1./lumi_sm)
histo_sm.Rebin(5)
histo_sm.SetLineWidth(2)
histo_sm.SetLineColor(2)
histo_sm.SetMaximum(1.1*histo_sm.GetMaximum())
histo_sm.GetXaxis().SetRange(5,20)
histo_sm.GetXaxis().SetTitle("Energy(GeV)")
histo_sm.GetYaxis().SetTitle("Normalised to Luminosity")
histo_sm.SetTitle("Muon Pt for SM and LFV")
histo_sm.Draw("hist")


file = lfvfilelist[0]	
MuTaufile = ROOT.TFile(file)
lfv_histo = MuTaufile.Get('fromHiggs/mGenPt')
if lfv_histo.Integral() != 0:
	lfv_histo.Scale(1./lumi_lfv)
	lfv_histo.Rebin(5)
	lfv_histo.SetLineWidth(2)
	lfv_histo.Draw("hist SAME")

legend.AddEntry(lfv_histo,"H to #mu #tau","l")			
legend.AddEntry(histo_sm,"H to #tau(#mu) #tau","l")		      
legend.Draw()
canvas.SaveAs(filepath+'mPt_new.png')
