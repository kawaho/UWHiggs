from ROOT import TH1F, gROOT, TLatex, TFile, TCanvas, gStyle, TLegend, TLine, gPad, TPaveText
import array
import numpy as np
gStyle.SetOptStat(False)
gROOT.SetBatch(True)
canvas = TCanvas("canvas","",0,0,800,800)
def add_lumi():
    lowX=0.65
    lowY=0.82
    lumi  = TPaveText(lowX,lowY, lowX+0.30, lowY+0.2, "NDC")
    lumi.SetBorderSize(   0 )
    lumi.SetFillStyle(    0 )
    lumi.SetTextAlign(   12 )
    lumi.SetTextColor(    1 )
    lumi.SetTextSize(0.038)
    lumi.SetTextFont (   42 )
    lumi.AddText("137.2 fb^{-1} (13 TeV)")
    return lumi

def add_CMS():
    lowX=0.16
    lowY=0.82
    lumi  = TPaveText(lowX, lowY+0.06, lowX+0.15, lowY+0.16, "NDC")
    lumi.SetTextFont(61)
    lumi.SetTextSize(0.055)
    lumi.SetBorderSize(   0 )
    lumi.SetFillStyle(    0 )
    lumi.SetTextAlign(   12 )
    lumi.SetTextColor(    1 )
    lumi.AddText("CMS")
    return lumi

def add_Preliminary():
    lowX=0.28
    lowY=0.82
    lumi  = TPaveText(lowX, lowY+0.05, lowX+0.15, lowY+0.15, "NDC")
    lumi.SetTextFont(52)
    lumi.SetTextSize(0.055*0.8*0.76)
    lumi.SetBorderSize(   0 )
    lumi.SetFillStyle(    0 )
    lumi.SetTextAlign(   12 )
    lumi.SetTextColor(    1 )
    lumi.AddText("Preliminary")
    return lumi
n = 4
xq = np.array([1-0.96, 1-0.53, 1-0.32, 1-0.11])
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

gPad.SetFillColor(0)
gPad.SetBorderMode(0)
gPad.SetBorderSize(10)
gPad.SetTickx(1)
gPad.SetTicky(1)
gPad.SetFrameFillStyle(0)
gPad.SetFrameLineStyle(0)
gPad.SetFrameLineWidth(3)
gPad.SetFrameBorderMode(0)
gPad.SetFrameBorderSize(10)
hmvaS.Add(hmvaS2017)
hmvaS.Add(hmvaS2018)
hmvaB.Add(hmvaB2017)
hmvaB.Add(hmvaB2018)

hmvaS.Rebin(10)
hmvaB.Rebin(10)
hmvaS.GetQuantiles(n,yq,xq)
#print yq

hmvaS.GetXaxis().SetRangeUser(-0.4, 0.3)
hmvaB.GetXaxis().SetRangeUser(-0.4, 0.3)
#hmvaS.SetMarkerStyle(0)
hmvaS.SetLineColor(2)
hmvaS.SetFillColor(10)
hmvaS.SetMinimum(0.001)
#hmvaS.SetFillStyle(3002)
#hmvaS.SetFillColor(1)
#hmvaB.SetMarkerStyle(0)
hmvaB.SetLineColor(4)
hmvaB.SetMinimum(0.001)
#hmvaB.SetFillStyle(3002)
#hmvaB.SetFillColor(1)
hmvaS.SetTitle(" ")
hmvaS.SetXTitle("BDT Discriminator")
hmvaS.SetYTitle("Events/bin")
hmvaS.GetXaxis().SetTitleFont(42)
hmvaS.GetYaxis().SetTitleFont(42)
hmvaS.GetXaxis().SetTitleSize(0.05)
hmvaS.GetYaxis().SetTitleSize(0.05)
hmvaS.GetXaxis().SetLabelSize(0.045)
hmvaS.GetYaxis().SetLabelSize(0.045)
hmvaS.GetYaxis().SetTitleOffset(1.60)
hmvaS.SetLineWidth(3);
hmvaB.SetLineWidth(3);
canvas.SetLeftMargin(0.16)
canvas.SetRightMargin(0.05)
canvas.SetBottomMargin(0.13)
hmvaS.Draw('HIST')
hmvaB.Draw("HIST,same")
legend = TLegend(0.18, 0.7, .38, .89)
legend.SetBorderSize(0)
legend.AddEntry(hmvaS,"Signal")
legend.AddEntry(hmvaB,"Background")
legend.SetTextFont(62)
legend.SetTextSize(0.045)
legend.Draw()
l1 = add_lumi()
l1.Draw("same")
l2 = add_CMS()
l2.Draw("same")
l3 = add_Preliminary()
l3.Draw("same")
#print canvas.GetUymax()
#print canvas.GetUymin()
gPad.Modified()
gPad.Update()
for i in range(n):
  #print i
  lines[i] = TLine(yq[i],canvas.GetUymin(),yq[i],canvas.GetUymax())
  lines[i].SetLineWidth(3)
  #line.SetNDC(True)
  lines[i].Draw("same")
canvas.SaveAs("MVA.png")
