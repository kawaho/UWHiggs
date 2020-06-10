import os
from ROOT import TCanvas, TF1, gROOT, TFile, gStyle, gPad
import sys
gROOT.SetStyle("Plain")
gStyle.SetOptFit()
gROOT.SetBatch(True)

canvas = TCanvas('canvas','canvas',800,800)

file = TFile('fakerate.root')
hdy = file.Get('fakerate')
hdy.SetTitle('Electron Fake Rate;Electron Pt (GeV); Fake Rate')
f1 = TF1("f1","tanh([0]+x*[1])",0,200)
f1.SetLineColor(4)
hdy.Fit(f1)
hdy.Draw()
gPad.Update(); 
graph = hdy.GetPaintedGraph()
graph.SetMinimum(0)
graph.SetMaximum(1.5)
gPad.Update() 
canvas.SaveAs('EFR_EE.png')