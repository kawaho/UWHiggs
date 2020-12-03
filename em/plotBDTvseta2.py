import os
from ROOT import TCanvas, TLegend, gStyle, gROOT, TFile, TH1F, TH2F, TProfile
from Kinematics import functor_gg
import sys
import glob
import math
import array 
import numpy as np
gROOT.SetBatch(True)
gStyle.SetOptStat(False)
canvas = TCanvas('canvas','canvas',850,800)

f = TFile("bdteta.root")
fnarrow = TFile("bdteta_narrow.root")
fwide = TFile("bdteta_noEta.root")
feta = TFile("bdteta_eta.root")

hm = f.Get("hmp")
hm.SetLineColor(2)
bin1 = hm.GetBinContent(1)
bin2 = hm.GetBinContent(2)
bin3 = hm.GetBinContent(3)
print "original mu"
print 2*(bin2-bin1)/(bin2+bin1)
print 2*(bin2-bin3)/(bin3+bin1)
he = f.Get("hep")
he.SetLineColor(2)
bin1 = he.GetBinContent(1)
bin2 = he.GetBinContent(2)
bin3 = he.GetBinContent(3)
print "original e"
print 2*(bin2-bin1)/(bin2+bin1)
print 2*(bin2-bin3)/(bin3+bin1)

hmwide = fwide.Get("hmp")
hmwide.SetLineColor(1)
bin1 = hmwide.GetBinContent(1)
bin2 = hmwide.GetBinContent(2)
bin3 = hmwide.GetBinContent(3)
print "wide mu"
print 2*(bin2-bin1)/(bin2+bin1)
print 2*(bin2-bin3)/(bin3+bin1)
hewide = fwide.Get("hep")
hewide.SetLineColor(1)
bin1 = hewide.GetBinContent(1)
bin2 = hewide.GetBinContent(2)
bin3 = hewide.GetBinContent(3)
print "wide e"
print 2*(bin2-bin1)/(bin2+bin1)
print 2*(bin2-bin3)/(bin3+bin1)

hmeta = feta.Get("hmp")
bin1 = hmeta.GetBinContent(1)
bin2 = hmeta.GetBinContent(2)
bin3 = hmeta.GetBinContent(3)
print "eta m"
print 2*(bin2-bin1)/(bin2+bin1)
print 2*(bin2-bin3)/(bin3+bin1)
hmeta.SetLineColor(4)
heeta = feta.Get("hep")
bin1 = heeta.GetBinContent(1)
bin2 = heeta.GetBinContent(2)
bin3 = heeta.GetBinContent(3)
print "eta e"
print 2*(bin2-bin1)/(bin2+bin1)
print 2*(bin2-bin3)/(bin3+bin1)
heeta.SetLineColor(4)

hmnarrow = fnarrow.Get("hmp")
hmnarrow.SetLineColor(3)
bin1 = hmnarrow.GetBinContent(1)
bin2 = hmnarrow.GetBinContent(2)
bin3 = hmnarrow.GetBinContent(3)
print "narrow mu"
print 2*(bin2-bin1)/(bin2+bin1)
print 2*(bin2-bin3)/(bin3+bin1)
henarrow = fnarrow.Get("hep")
henarrow.SetLineColor(3)
bin1 = henarrow.GetBinContent(1)
bin2 = henarrow.GetBinContent(2)
bin3 = henarrow.GetBinContent(3)
print "narrow e"
print 2*(bin2-bin1)/(bin2+bin1)
print 2*(bin2-bin3)/(bin3+bin1)

hm.SetXTitle("#eta^{#mu}")
hm.SetYTitle("Profile of BDT score (2016)")
hm.GetYaxis().SetRangeUser(0.08, 0.12)
hm.Draw()
hmnarrow.Draw('same')
hmwide.Draw('same')
hmeta.Draw('same')
legend = TLegend(0.65,0.7,0.8,0.9)
legend.AddEntry(hm,"original","l")
legend.AddEntry(hmnarrow,"narrow training range","l")
legend.AddEntry(hmwide,"wide training range","l")
legend.AddEntry(hmeta,"include leptons\' etas","l")
legend.Draw()
canvas.SetLeftMargin(0.15)
canvas.SaveAs("m_etaMVAP.png")

he.SetXTitle("#eta^{e}")
he.SetYTitle("Profile of BDT score (2016)")
he.GetYaxis().SetRangeUser(0.06, 0.12)
he.Draw()
henarrow.Draw('same')
hewide.Draw('same')
heeta.Draw('same')
legend = TLegend(0.65,0.7,0.9,0.9)
legend.AddEntry(he,"original","l")
legend.AddEntry(henarrow,"narrow training range","l")
legend.AddEntry(hewide,"wide training range","l")
legend.AddEntry(heeta,"include leptons\' etas","l")
legend.Draw()
canvas.SetLeftMargin(0.15)
canvas.SaveAs("e_etaMVAP.png")
