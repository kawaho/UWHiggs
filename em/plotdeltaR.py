from ROOT import TCanvas, TF1, gROOT, TFile, gStyle, gPad, TLatex
gROOT.SetStyle("Plain")
gROOT.SetBatch(True)
canvas = TCanvas('canvas','canvas',800,800)
file = TFile('vbf_gg.root')
hdr = file.Get('TightOS/deltaR')
title = 'gg+vbf #DeltaR_{e#mu} distribution;'+ '#DeltaR_{e#mu}' 
hdr.SetTitle(title)
hdr.Draw()
canvas.SaveAs('deltaR.png') 
