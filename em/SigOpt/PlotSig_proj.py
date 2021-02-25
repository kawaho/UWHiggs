import os
import time
from ROOT import TLatex, gROOT, gPad, TFile, TH1F, TH2F, TGraph, TCanvas, TLine, gPad, TMultiGraph, TPaveText
from writedatacard import writedatacard
from fitSB_proj import fit
import sys
import glob
import math
import array 
import numpy as np
import random as rd

gROOT.SetBatch(True)
canvas = TCanvas("canvas","",0,0,800,800)
runCut = False
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

def run(cmd):
  print "%s\n\n"%cmd
  os.system(cmd)

def checkBkg(lis_):
  pass_ = True
  for i in lis_:
    if i < 10*hmvaS2D[0].GetNbinsY(): pass_ = False
  return pass_

def PlotSig(Multigr, Sigx, Sigy):
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
   gr = TGraph(len(Sigx), Sigx, Sigy)
   gr.GetXaxis().SetRangeUser(0, 1)
   gr.GetXaxis().SetTitle("Signal Efficiency")
   gr.GetYaxis().SetTitle("Significance")
   gr.GetXaxis().SetTitleFont(42)
   gr.GetYaxis().SetTitleFont(42)
   gr.GetXaxis().SetTitleSize(0.05)
   gr.GetYaxis().SetTitleSize(0.05)
   gr.GetXaxis().SetLabelSize(0.045)
   gr.GetYaxis().SetLabelSize(0.045)
   gr.GetYaxis().SetTitleOffset(1.60)
#  gr.GetYaxis().SetNdivisions(7)
   canvas.SetLeftMargin(0.16)
   canvas.SetRightMargin(0.05)
   canvas.SetBottomMargin(0.13)
   gr.SetTitle("")
#  gr.GetYaxis().SetRangeUser(np.max(Sigy)-20,  np.max(Sigy)+5)
#  gr.SetMarkerSize(5)
   gr.SetMarkerStyle(8)
   Multigr.Add(gr, 'ap')
   return gr.GetYaxis().GetXmax()
def PlotCat(Multigr, catsSig, ymax_):
  for cat in catsSig:
    line = TGraph(2)
    line.SetPoint(0, cat, 0)
    line.SetPoint(1, cat, ymax_)
    Multigr.Add(line, 'l')
    line.SetLineWidth(3)

def PlotMax(Multigr, maxSigI, ymax_):
  line = TGraph(2)
  line.SetPoint(0, 1-maxSigI, 0)
  line.SetPoint(1, 1-maxSigI, ymax_)
  line.SetLineColor(2)
  line.SetLineWidth(3)
  Multigr.Add(line, 'l')

def DrawNSave(Multigr, ncats):
  Multigr.Draw()
  l1 = add_lumi()
  l1.Draw("same")
  l2 = add_CMS()
  l2.Draw("same")
  l3 = add_Preliminary()
  l3.Draw("same")
  canvas.SaveAs('Graphs/' + str(ncats) + '.png')

def BoundaryScan(screen, cats):
  for i in range(len(cats)-1):
    if screen > cats[i] and screen < cats[i+1]:
      return cats[i], cats[i+1], i, i+1
    elif screen == cats[i]:
      return cats[i], cats[i] + 1, -1, -1

def Initialize(lis_):
  for  i in range(len(lis_)):
    lis_[i] = 0

class hitCat(Exception): pass

fFileS = [TFile("2016/signal.root"), TFile("2017/signal.root"), TFile("2018/signal.root")]

n = 100
nyear = 3
xq = np.empty(n)
yq = np.empty(n)
for i in range(n):
  xq[i] = (i+1)/float(n)

hmvaS = []
for fS in fFileS:
  hmvaS.append(fS.Get("TightOSgg/MVA"))
SigStep = [[1], [1], [1]]
for i in range(nyear):
  hmvaS[i].GetQuantiles(n,yq,xq)
  for j in range(n):
    SigStep[i].append(hmvaS[i].FindBin(yq[j]))
print SigStep
run = 1 #True
cats = [[1, 2000], [1,2000], [1,2000]]
catsSig = []
catdiff = []

maxCombprev = 0.01
maxComb = 0
maxI = [-1,-1,-1]
maxSigI = -1

while run<5:    
#while run:    
  ncats = len(catdiff) + 2
  Sigx, Sigy = array.array('f'), array.array('f')
  for i in range(1,n-1):
    start_time = time.time()
    print "---Scanning steps %i---"%i

    open('Hem_shape_sys.csv', 'w').close()
#cats = [ggcat0,ggcat1]
#bins = [[[],[],[]], [[],[],[]]]
#bins_proj = [[effl, effh], [effl, effh]]
    bins = [[] for _ in range(ncats)]
    try:
      for yr in range(nyear):
        Boundl, Boundr, Il, Ir = BoundaryScan(SigStep[yr][i], cats[yr])[0], BoundaryScan(SigStep[yr][i], cats[yr])[1], BoundaryScan(SigStep[yr][i], cats[yr])[2], BoundaryScan(SigStep[yr][i], cats[yr])[3]
        print ", , , ,", Boundl, Boundr, Il, Ir
        if (Il == -1):
          raise hitCat()

        for c in range(ncats):
          if (c == Il):
            binl, binh = Boundl, SigStep[yr][i]
          elif (c == Ir):
            binl, binh = SigStep[yr][i], Boundr
          elif (c < Il):
            binl, binh = cats[yr][c], cats[yr][c+1]
          elif (c > Ir):
            binl, binh = cats[yr][c-1], cats[yr][c]
          bins[c].append([binl, binh])
          print "Hello",SigStep[yr].index(binl),SigStep[yr].index(binh)
          print binl, binh
    except hitCat:
      continue
    catname = []
    combinestr = ''
    fitstatus = 0
    for c in range(ncats):
      fitstatus += fit([SigStep[2].index(bins[c][2][0]),SigStep[2].index(bins[c][2][1])],'ggcat%i'%c)
      catname.append('ggcat%i'%c)
      combinestr += 'Name%i=datacard_%i.txt '%(c+1,c)
    print cats
    print catname, bins
    writedatacard(catname, bins) 
    if fitstatus != 0:
      print "--- Fit Failed --- Skipping this Scan ---"
      continue
### Atlas Limit: 6.2*10^{-5} (5.9*10^{-5}).
    #run("combineCards.py " + combinestr + "> datacard_comb.txt")
    #run("combine -M Significance datacard_comb.txt -m 125 -t -1 --expectSignal=1")
    #input_ = TFile("higgsCombineTest.Significance.mH125.root")
    #limitTree = input_.Get("limit")
    #limitTree.GetEntry(0)
    #Comb = limitTree.limit
    Comb = rd.randint(0, 500) 

    Sigx.append(1-xq[i])
    Sigy.append(Comb)
    print("--- %s seconds ---" % (time.time() - start_time))

  Multigr = TMultiGraph()
  ymax_ = PlotSig(Multigr, Sigx, Sigy)
  PlotCat(Multigr, catsSig, ymax_)
  maxComb_idx = np.argmax(Sigy)
  maxComb = np.max(Sigy)
  maxI = [SigStep[0][maxComb_idx+1], SigStep[1][maxComb_idx+1], SigStep[2][maxComb_idx+1]]
  maxSigI = xq[maxComb_idx+1]

  diff = abs((maxComb - maxCombprev)/maxCombprev)
  if diff >= 0.01:
    catdiff.append(diff)
    catsSig.append(1-maxSigI)
    for yr in range(nyear):
      cats[yr].append(maxI[yr])
      cats[yr].sort()
    PlotMax(Multigr, maxSigI, ymax_)
    DrawNSave(Multigr, ncats)
    maxCombprev = maxComb
    run += 1
    #run = False
  else: 
    run += 1
    #run = False
    DrawNSave(Multigr, ncats)
    print "Final Cats ", cats
    print "Cat Diff ", catdiff
    print "Final Sig: ", math.sqrt(maxCombprev)

cats_mva = [[], [], []]
for yr in range(nyear):
  print "Year ", 2016+yr
  for cat in cats[yr]:
    cats_mva[yr].append(round(cat*0.001-0.0005-1,4))
  print "MVA Score: ", cats_mva[yr]
catsSig.sort()
print "Signal Efficiency: ", catsSig
