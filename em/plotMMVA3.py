from ROOT import TPad, gROOT,TH1F, TH2F, TFile, TCanvas, gStyle, TLegend, TLine, gPad, TLatex, TProfile, TPaveText
import array 
import numpy as np
gROOT.SetBatch(True)
def add_lumi():
    lowX=0.67
    lowY=0.83
    lumi  = TPaveText(lowX,lowY, lowX+0.30, lowY+0.2, "NDC")
    lumi.SetBorderSize(   0 )
    lumi.SetFillStyle(    0 )
    lumi.SetTextAlign(   12 )
    lumi.SetTextColor(    1 )
    lumi.SetTextSize(0.038)
    lumi.SetTextFont (   42 )
    lumi.AddText("41.5 fb^{-1} (13 TeV)")
    return lumi

def add_CMS():
    lowX=0.18
    lowY=0.71
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
    lowX=0.30
    lowY=0.71
    lumi  = TPaveText(lowX, lowY+0.05, lowX+0.15, lowY+0.15, "NDC")
    lumi.SetTextFont(52)
    lumi.SetTextSize(0.055*0.8*0.76)
    lumi.SetBorderSize(   0 )
    lumi.SetFillStyle(    0 )
    lumi.SetTextAlign(   12 )
    lumi.SetTextColor(    1 )
    lumi.AddText("Preliminary")
    return lumi
canvas = TCanvas("canvas","",0,0,800,800)
fFilenew = TFile("BDTVA.root") #_COM.root")
MMVA1 = fFilenew.Get("MMVA1") 
MMVA2 = fFilenew.Get("MMVA2") 
MMVA3 = fFilenew.Get("MMVA3") 
MMVA4 = fFilenew.Get("MMVA4") 
MMVA5 = fFilenew.Get("MMVA5") 
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
MMVA1.SetLineColor(1)
MMVA1.SetLineWidth(3);
MMVA2.SetLineColor(4)
MMVA2.SetLineWidth(3);
MMVA3.SetLineColor(2)
MMVA3.SetLineWidth(3);
MMVA4.SetLineColor(42)
MMVA4.SetLineWidth(3);
MMVA5.SetLineColor(8)
MMVA5.SetLineWidth(3);
MMVA1.Scale( 1./MMVA1.Integral())
MMVA2.Scale( 1./MMVA2.Integral())
MMVA3.Scale( 1./MMVA3.Integral())
MMVA4.Scale( 1./MMVA4.Integral())
MMVA5.Scale( 1./MMVA5.Integral())
MMVA1.Draw('HIST')
MMVA1.SetXTitle("m_{e#mu} [GeV]")
MMVA1.SetYTitle("a.u.")

MMVA1.GetXaxis().SetTitleFont(42)
MMVA1.GetYaxis().SetTitleFont(42)
MMVA1.GetXaxis().SetTitleSize(0.05)
MMVA1.GetYaxis().SetTitleSize(0.05)
MMVA1.GetXaxis().SetLabelSize(0.045)
MMVA1.GetYaxis().SetLabelSize(0.045)
MMVA1.GetXaxis().SetNdivisions(505)
#MMVA1.GetYaxis().SetNdivisions(5)

canvas.SetLeftMargin(0.16)
canvas.SetRightMargin(0.05)
canvas.SetBottomMargin(0.14)
#MMVA1.GetXaxis().SetRangeUser(115, 135)
MMVA1.GetYaxis().SetTitleOffset(1.6)
MMVA1.GetXaxis().SetTitleOffset(1.2)
MMVA1.GetYaxis().SetRangeUser(0., .045)
MMVA2.Draw('HIST,same')
MMVA3.Draw('HIST,same')
MMVA4.Draw('HIST,same')
MMVA5.Draw('HIST,same')
legend = TLegend(0.58,0.58,0.89,0.89)
legend.AddEntry("MMVA1","-1 < BDT < -0.150","l");
legend.AddEntry("MMVA2","-0.150 < BDT < -0.073","l");
legend.AddEntry("MMVA3","-0.073 < BDT < -0.008","l");
legend.AddEntry("MMVA4","-0.008 < BDT < 0.060","l");
legend.AddEntry("MMVA5","0.060 < BDT < 1","l");
legend.SetBorderSize(0)
legend.SetTextFont(61)
legend.SetTextSize(0.03)
legend.Draw()
l1 = add_lumi()
l1.Draw("same")
l2 = add_CMS()
l2.Draw("same")
l3 = add_Preliminary()
l3.Draw("same")
canvas.SaveAs('MMMMMVA.png')
