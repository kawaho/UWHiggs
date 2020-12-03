from ROOT import gROOT,TH1F, TH2F, TFile, TCanvas, gStyle, TLegend, TLine, gPad, TLatex, TProfile
import array 
import numpy as np
gROOT.SetBatch(True)
canvas = TCanvas('canvas','canvas',850,800)
fFilenew = TFile("BDTVA_COM.root")
MMVA1 = fFilenew.Get("MMVA1") 
MMVA2 = fFilenew.Get("MMVA2") 
MMVA3 = fFilenew.Get("MMVA3") 
MMVA4 = fFilenew.Get("MMVA4") 
MMVA5 = fFilenew.Get("MMVA5") 
MMVA11 = fFilenew.Get("MMVA11") 
MMVA21 = fFilenew.Get("MMVA21") 
MMVA31 = fFilenew.Get("MMVA31") 
MMVA41 = fFilenew.Get("MMVA41") 
MMVA51 = fFilenew.Get("MMVA51") 
MMVA1.SetLineColor(1)
MMVA2.SetLineColor(2)
MMVA3.SetLineColor(3)
MMVA4.SetLineColor(4)
MMVA5.SetLineColor(6)
MMVA11.SetLineColor(7)
MMVA21.SetLineColor(8)
MMVA31.SetLineColor(9)
MMVA41.SetLineColor(11)
MMVA51.SetLineColor(12)
MMVA1.Scale( 1./MMVA1.Integral())
MMVA2.Scale( 1./MMVA2.Integral())
MMVA3.Scale( 1./MMVA3.Integral())
MMVA4.Scale( 1./MMVA4.Integral())
MMVA5.Scale( 1./MMVA5.Integral())
MMVA11.Scale( 1./MMVA11.Integral())
MMVA21.Scale( 1./MMVA21.Integral())
MMVA31.Scale( 1./MMVA31.Integral())
MMVA41.Scale( 1./MMVA41.Integral())
MMVA51.Scale( 1./MMVA51.Integral())
MMVA1.Draw('HIST')
MMVA1.SetXTitle("m_{e#mu} (GeV)")
MMVA1.SetXTitle("m_{e#mu} (GeV)")
MMVA1.GetYaxis().SetRangeUser(0., .04)
MMVA2.Draw('HIST,same')
MMVA3.Draw('HIST,same')
MMVA4.Draw('HIST,same')
MMVA5.Draw('HIST,same')
MMVA11.Draw('HIST,same')
MMVA21.Draw('HIST,same')
MMVA31.Draw('HIST,same')
MMVA41.Draw('HIST,same')
MMVA51.Draw('HIST,same')
legend = TLegend(0.62,0.62,0.88,0.88)
legend.AddEntry("MMVA1","-1 < BDT < -0.172","l");
legend.AddEntry("MMVA2","-0.172 < BDT < -0.089","l");
legend.AddEntry("MMVA3","-0.089 < BDT < -0.015","l");
legend.AddEntry("MMVA4","-0.015 < BDT < 0.057","l");
legend.AddEntry("MMVA5","0.057 < BDT < 1","l");
legend.AddEntry("MMVA11","-1 < BDT < -0.172","l");
legend.AddEntry("MMVA21","-0.172 < BDT < -0.089","l");
legend.AddEntry("MMVA31","-0.089 < BDT < -0.015","l");
legend.AddEntry("MMVA41","-0.015 < BDT < 0.057","l");
legend.AddEntry("MMVA51","0.057 < BDT < 1","l");
legend.SetBorderSize(0)
legend.Draw()
canvas.SaveAs('MMMMMVA.png')
