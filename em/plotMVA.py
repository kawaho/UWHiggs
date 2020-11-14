from ROOT import TH1F, TFile, TCanvas, gStyle, TLegend, TLine, gPad
import array
import numpy as np
gStyle.SetOptStat(False)
canvas = TCanvas('canvas','canvas',850,800)

n = 2
xq = np.array([1-0.61, 1-0.32])
yq = np.empty(n)
lines = []
for i in range(n):
  lines.append(TLine())
fFilenew = TFile("BDT_plot.root")
hmvaS = fFilenew.Get("mvaS")
hmvaB = fFilenew.Get("mvaB")
hmvaSEff = fFilenew.Get("mvaEff")

fFilenew2017 = TFile("../../UWHiggs2017/em/BDT_plot.root")
hmvaS2017 = fFilenew2017.Get("mvaS")
hmvaB2017 = fFilenew2017.Get("mvaB")
hmvaSEff2017 = fFilenew2017.Get("mvaEff")

fFilenew2018 = TFile("../../UWHiggs/em/BDT_plot.root")
hmvaS2018 = fFilenew2018.Get("mvaS")
hmvaB2018 = fFilenew2018.Get("mvaB")
hmvaSEff2018 = fFilenew2018.Get("mvaEff")

hmvaS.Add(hmvaS2017)
hmvaS.Add(hmvaS2018)
hmvaB.Add(hmvaB2017)
hmvaB.Add(hmvaB2018)
hmvaS.GetQuantiles(n,yq,xq)
print yq

hmvaS.GetXaxis().SetRangeUser(-0.5, 0.5)
hmvaB.GetXaxis().SetRangeUser(-0.5, 0.5)
#hmvaS.SetMarkerStyle(0)
hmvaS.SetLineColor(2)
hmvaS.SetFillColor(10)
#hmvaS.SetFillStyle(3002)
#hmvaS.SetFillColor(1)
#hmvaB.SetMarkerStyle(0)
hmvaB.SetLineColor(4)
hmvaB.SetMinimum(0.001)
#hmvaB.SetFillStyle(3002)
#hmvaB.SetFillColor(1)
hmvaS.SetTitle(" ")
hmvaS.SetXTitle("BDT Discriminator")
hmvaS.SetYTitle("Events per 0.01 BDT Discriminator")
hmvaS.Draw('HIST')
hmvaB.Draw("HIST,same")
legend = TLegend(0.65, 0.65, .85, .85)
legend.SetBorderSize(0)
legend.AddEntry(hmvaS,"Signal")
legend.AddEntry(hmvaB,"Background")
legend.Draw()
print canvas.GetUymax()
print canvas.GetUymin()
gPad.Modified()
gPad.Update()
for i in range(n):
  print i
  lines[i] = TLine(yq[i],canvas.GetUymin(),yq[i],canvas.GetUymax())
  lines[i].SetLineStyle(9)
  #line.SetNDC(True)
  lines[i].Draw("same")
canvas.SaveAs("MVA.png")
