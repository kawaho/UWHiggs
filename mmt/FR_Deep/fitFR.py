import os
from ROOT import TCanvas, TF1, gROOT, TFile, gStyle, gPad
import sys
import glob
gROOT.SetStyle("Plain")
gStyle.SetOptFit()
gROOT.SetBatch(True)

files = []
files.extend(glob.glob('*.root')) 

canvas = TCanvas('canvas','canvas',800,800)

for f in files:
	file = TFile(f)
	f_title = f.replace('.root', '')
	hdy = file.Get('fakerate')
	title = 'Tau Fake Rate '+ f_title +';Tau Pt (GeV); Fake Rate'
	hdy.SetTitle(title)
	f1 = TF1("f1","[0]+x*[1]",0,200)
	f1.SetLineColor(4)
	hdy.Fit(f1)
	hdy.Draw()
        gPad.Update()
        graph = hdy.GetPaintedGraph() 
        graph.SetMinimum(0)
        graph.SetMaximum(1.5)
        gPad.Update()
	canvas.SaveAs(f_title + '.png')
