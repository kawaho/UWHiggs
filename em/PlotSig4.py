import os
from ROOT import TLatex, gROOT, TFile, TH1F, TGraph, TCanvas, TLine, gPad, TMultiGraph, TPaveText
import sys
import glob
import math
import array 
import numpy as np

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
#fFileold = [TFile("BDT_wide.root"), TFile("../../UWHiggs2017/em/BDT_wide.root"), TFile("../../UWHiggs/em/BDT_wide.root")]
fFileold = [TFile("BDT.root"), TFile("../../UWHiggs2017/em/BDT.root"), TFile("../../UWHiggs/em/BDT.root")]
#fFileold = [TFile("BDT_narrow.root"), TFile("../../UWHiggs2017/em/BDT_narrow.root"), TFile("../../UWHiggs/em/BDT_narrow.root")]

n = 100
nyear = 3
xq = np.empty(n)
yq = np.empty(n)
for i in range(0, n):
  xq[i] = (i+1)/float(n)

hmvaS = []
hmvaB = []
for fFile in fFileold:
  hmvaS.append(fFile.Get("mvaS"))
  hmvaB.append(fFile.Get("mvaB"))

SigStep = [[1], [1], [1]]
for i in range(0, nyear):
  hmvaS[i].GetQuantiles(n,yq,xq)
  for j in range(0, n):
    SigStep[i].append(hmvaS[i].FindBin(yq[j]))
#print SigStep

run = True
cats = [[1, 2000], [1,2000], [1,2000]]
catsSig = []
catdiff = []

S = [0, 0]
B = [0, 0]
Bprev = []
Bprev2 = []
Sig = [0, 0]
maxCombprev = 0.01
maxComb = 0
maxCombpen = 0
Comb = 0
maxI = [-1,-1,-1]
maxSigI = -1

def BoundaryScan(screen, cats):
  for i in range(0, len(cats)-1):
    if screen > cats[i] and screen < cats[i+1]:
      return cats[i], cats[i+1], i, i+1
    elif screen == cats[i]:
      return cats[i], cats[i] + 1, -1, -1

def Initialize(lis_):
  for  i in range(0, len(lis_)):
    lis_[i] = 0

while run:    
  ncats = len(catdiff) + 1
  Sigx, Sigy = array.array('f'), array.array('f')
  for i in range(n):
    Initialize(S)
    Initialize(B)
    Initialize(Sig)
    Comb = 0
    pl = 0
    pr = 0
    pl2 = 0
    pr2 = 0
    for yr in range(0, nyear):

#      print "Scanning at ", 2016+yr
      Boundl, Boundr, Il, Ir = BoundaryScan(SigStep[yr][i], cats[yr])[0], BoundaryScan(SigStep[yr][i], cats[yr])[1], BoundaryScan(SigStep[yr][i], cats[yr])[2], BoundaryScan(SigStep[yr][i], cats[yr])[3]

      if (Il == -1):
        continue
    
#      print "Scanning at ", SigStep[yr][i]
#      print Boundl, Boundr, Il, Ir

      for s_b in range(0, len(S)):
        if (s_b == Il):
#          print "Boud of ", s_b
#          print Boundl, SigStep[yr][i]
          for j in range(Boundl, SigStep[yr][i]): 
            S[s_b]+=hmvaS[yr].GetBinContent(j)
            B[s_b]+=hmvaB[yr].GetBinContent(j)
          pl = B[s_b]/(hmvaB[0].Integral()+hmvaB[1].Integral()+hmvaB[2].Integral())
          pl2 = S[s_b]/(hmvaS[0].Integral()+hmvaS[1].Integral()+hmvaS[2].Integral())
        elif (s_b == Ir):
#          print "Boud of ", s_b
#          print SigStep[yr][i], Boundr
          for j in range(SigStep[yr][i], Boundr): 
            S[s_b]+=hmvaS[yr].GetBinContent(j)
            B[s_b]+=hmvaB[yr].GetBinContent(j)
          pr = B[s_b]/(hmvaB[0].Integral()+hmvaB[1].Integral()+hmvaB[2].Integral())
          pr2 = S[s_b]/(hmvaS[0].Integral()+hmvaS[1].Integral()+hmvaS[2].Integral())
        elif (s_b < Il):
#          print "Boud of ", s_b
#          print cats[yr][s_b], cats[yr][s_b+1]
          for j in range(cats[yr][s_b], cats[yr][s_b+1]):
            S[s_b]+=hmvaS[yr].GetBinContent(j) 
            B[s_b]+=hmvaB[yr].GetBinContent(j)
        elif (s_b > Ir):
#          print "Boud of ", s_b
#          print cats[yr][s_b-1], cats[yr][s_b]
          for j in range(cats[yr][s_b-1], cats[yr][s_b]):
            S[s_b]+=hmvaS[yr].GetBinContent(j)
            B[s_b]+=hmvaB[yr].GetBinContent(j)
    for s_b in range(0, len(Sig)):
      if B[s_b]!=0:
        Sig[s_b] = S[s_b]*S[s_b]/B[s_b]
        Comb += Sig[s_b]
#        print "Sig at ", s_b
#        print Sig[s_b]

      
    if Comb != 0:
      Sigx.append(1-xq[i])
      Sigy.append(math.sqrt(Comb))
    Combpen = Comb #*(1+0.5*(pl*(1-pl)+pr*(1-pr)+pl2*(1-pl2)+pr2*(1-pr2)))
#    if ncats == 4:
#      print "Hello"
#      Combpen = Combpen*(1+.5*(pl*(1-pl)+pr*(1-pr)+pl2*(1-pl2)+pr2*(1-pr2)))

  #  if (pl+pr) != 0 and (pl2+pr2) !=0:
  #    Combpen = Comb*(1+pl*pr/((pl+pr)**2)+pl2*pr2/((pl2+pr2)**2))
  #  else:
  #    Combpen = Comb
    if Combpen > maxCombpen: 
      maxCombpen = Combpen
      maxComb = Comb
      Bprev = B[:]
#      print "maxCombpen: ", maxCombpen
#      print "maxComb: ", maxComb
      maxI = [SigStep[0][i], SigStep[1][i], SigStep[2][i]]
      maxSigI = xq[i]
#      print "maxI ", maxI

    if i == n-1: #len(Sigx) > 0:
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
      Multigr = TMultiGraph()
      gr = TGraph(len(Sigx), Sigx, Sigy)
      gr.GetXaxis().SetRangeUser(0, 1)
      gr.GetXaxis().SetTitle("Signal Efficiency")
      gr.GetYaxis().SetTitle("Sensitivity")
      gr.GetXaxis().SetTitleFont(42)
      gr.GetYaxis().SetTitleFont(42)
      gr.GetXaxis().SetTitleSize(0.05)
      gr.GetYaxis().SetTitleSize(0.05)
      gr.GetXaxis().SetLabelSize(0.045)
      gr.GetYaxis().SetLabelSize(0.045)
      gr.GetYaxis().SetTitleOffset(1.60)
#      gr.GetYaxis().SetNdivisions(7)
      canvas.SetLeftMargin(0.16)
      canvas.SetRightMargin(0.05)
      canvas.SetBottomMargin(0.13)
      gr.SetTitle("")
#    gr.GetYaxis().SetRangeUser(np.max(Sigy)-20,  np.max(Sigy)+5)
  #  gr.SetMarkerSize(5)
      gr.SetMarkerStyle(8)
      Multigr.Add(gr, 'ap')

      for cat in catsSig:
        line = TGraph(2)
        line.SetPoint(0, cat ,0)
        line.SetPoint(1, cat ,np.max(Sigy)+50)
        Multigr.Add(line, 'l')
        line.SetLineWidth(3)

  if maxComb == 0:
    continue

  diff = abs(math.sqrt(maxComb) - math.sqrt(maxCombprev))/math.sqrt(maxCombprev)
  if diff > 0.015:
    Bprev2 = Bprev[:]
    S.append(0)
    B.append(0)
    Sig.append(0)
    catdiff.append(diff)
    catsSig.append(1-maxSigI)
    for yr in range(0, nyear):
#      print "hello", yr
#      print cats[yr]
#      print maxI[yr]
      cats[yr].append(maxI[yr])
#      print "hello", yr
      cats[yr].sort()
    line = TGraph(2)
    line.SetPoint(0, 1-maxSigI ,0)
    line.SetPoint(1, 1-maxSigI ,np.max(Sigy)+15)
    line.SetLineColor(2)
    line.SetLineWidth(3)
    Multigr.Add(line, 'l')
    Multigr.Draw()
    l1 = add_lumi()
    l1.Draw("same")
    l2 = add_CMS()
    l2.Draw("same")
    l3 = add_Preliminary()
    l3.Draw("same")
    canvas.SaveAs('Sig/' + str(ncats) + '.png')
    
    maxCombprev = maxComb
#    print "Cat: ", cats
    run = True
  else: 
    print "Final Cats ", cats
    print "Cat Diff ", catdiff
    run = False
    Multigr.Draw()

    canvas.SaveAs('Sig/' + str(ncats) + '.png')
    print "Final Sig: ", math.sqrt(maxComb)
cats_mva = [[], [], []]
print "MVA Score: "
for yr in range(0, nyear):
  print "Year ", 2016+yr
  for cat in cats[yr]:
    cats_mva[yr].append(cat*0.001-0.0005-1)
    #cats_mva[yr].append(cat*0.01-0.005-1)
  print cats_mva[yr]
print "Signal Efficiency: ", catsSig
print "BBB: ", Bprev2
