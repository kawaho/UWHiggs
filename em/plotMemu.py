import os
from ROOT import TCanvas, TF1, gROOT, TFile, gStyle, gPad, TLatex
import sys
import glob
gROOT.SetStyle("Plain")
gStyle.SetOptFit()
gROOT.SetBatch(True)

files = []
files.extend(glob.glob('results/Data2017JEC/AnalyzeEMCut/data.root')) 

canvas = TCanvas('canvas','canvas',800,800)

for f in files:
  f_title = f.replace('.root', '').replace('results/Data2017JEC/AnalyzeEM/', '')
  file = TFile(f)
  file.cd()
  for f in file.GetListOfKeys():
    f = f.ReadObj()
    f.cd()
    for h in f.GetListOfKeys():
      if h.GetName() == 'e_m_Mass':
        hm = h.ReadObj()
        hm.GetXaxis().SetRangeUser(105, 165)
        cat = f.GetName().replace('TightOS', '')
        title = cat + ';M_{e#mu} (GeV/c^{2})' +';Events / ( 1 GeV/c^{2} )'
        hm.SetTitle(title)
        hm.Draw()
	canvas.SaveAs('dataPlot/' + f.GetName() + '.png')

