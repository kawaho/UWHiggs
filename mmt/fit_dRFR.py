import os
from ROOT import TCanvas, TF1, gROOT, TFile, gStyle, gPad, TLatex
import sys
import glob
gROOT.SetStyle("Plain")
gStyle.SetOptFit()
gROOT.SetBatch(True)

files = []
files.extend(glob.glob('dRFR/*.root')) 

canvas = TCanvas('canvas','canvas',800,800)

for f in files:
	file = TFile(f)
	f_title = f.replace('.root', '').replace('dRFR/', '')
        print f_title
        f_title2 = "#Delta R"
	hdy = file.Get('fakerate')
	title = '  Tau Fake Rate '+ f_title + ' ;'+ f_title2 +'; Fake Rate'
	hdy.SetTitle(title)
#	f1 = TF1("f1","[0]+x*[1]",0,200)
#	f1.SetLineColor(4)
#	hdy.Fit(f1)
	hdy.Draw()
        latex = TLatex()
        latex.SetNDC()
        latex.SetTextFont(43)
        latex.SetTextSize(24)
        latex.SetTextAlign(31)
        latex.SetTextAlign(11)
        latex.DrawLatex(0.14, 0.84, "#bf{#mu#mu#tau_{h}}")
#        latex.SetTextSize(22)
#        latex.DrawLatex(0.63, 0.91, "59.3 fb^{-1} (2018, 13 TeV)")
        gPad.Update()
        graph = hdy.GetPaintedGraph() 
        graph.SetMinimum(0)
        graph.SetMaximum(1.5)
        graph.GetYaxis().SetTitleOffset(1.2)
#        graph.GetXaxis().SetTitleFont(42)
#        graph.GetYaxis().SetTitleFont(42) 
#        graph.GetYaxis().SetLabelFont(42)
#        graph.GetXaxis().SetLabelFont(42)
        gPad.Update()
	canvas.SaveAs(f_title + '_mmt2016.png')

