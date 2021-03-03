import os
import time
from ROOT import TLatex, gROOT, gPad, TFile, TH1F, TH2F, TGraph, TCanvas, TLine, gPad, TMultiGraph, TPaveText
from writedatacard import writedatacard
from fitSB_tree import fit
import sys
import glob
import math
import array 
import numpy as np
import random as rd
from multiprocessing import Pool, cpu_count
import argparse
parser = argparse.ArgumentParser(
    "Optimizer for LFV H analysis")
parser.add_argument(
    "--limit",
    action='store_true'
    )
args = parser.parse_args()

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

def runCMD(cmd):
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
   if args.limit:
     gr.GetYaxis().SetTitle("95% CL Expected Limit, 10^{-4}")
   else:
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
  line.SetPoint(0, maxSigI, 0)
  line.SetPoint(1, maxSigI, ymax_)
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
  if args.limit:
    canvas.SaveAs('Graphs/' + str(ncats) + '_limit.png')
  else:
    canvas.SaveAs('Graphs/' + str(ncats) + '.png')

def BoundaryScan(screen, cats):
  for i in range(len(cats)-1):
    if screen == cats[i]-1:
#      print "Hello Hitcats, i", cats, screen
      return cats[i], cats[i] + 1, -1, -1
  for i in range(len(cats)-1):
    if screen > cats[i]-1 and screen < cats[i+1]:
      return cats[i], cats[i+1], i, i+1

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
SigStep = [[0], [0], [0]]
for i in range(nyear):
  hmvaS[i].GetQuantiles(n,yq,xq)
  for j in range(n):
    SigStep[i].append(hmvaS[i].FindBin(yq[j]))
#print "Hello",SigStep
run = True
cats = [[1, 2001], [1,2001], [1,2001]]
catsSig = []
catdiff = []

maxCombprev = 0.000001
maxComb = 0
maxI = [-1,-1,-1]
maxSigI = -1
#open('Hem_shape_sys.csv', 'w').close()
def SigScan(i):
  ncats = len(catdiff) + 2
  bins = [[] for _ in range(ncats)]
  ranges = [[] for _ in range(ncats)]
  try:
    for yr in range(nyear):
      Boundl, Boundr, Il, Ir = BoundaryScan(SigStep[yr][i], cats[yr])[0], BoundaryScan(SigStep[yr][i], cats[yr])[1], BoundaryScan(SigStep[yr][i], cats[yr])[2], BoundaryScan(SigStep[yr][i], cats[yr])[3]
      if (Il == -1):
#        print "Hello Hitcats, i", cats, i
        raise hitCat()

      for c in range(ncats):
        if (c == Il):
          binl, binh = Boundl, SigStep[yr][i]
          rangel, rangeh = SigStep[yr].index(Boundl-1), SigStep[yr].index(SigStep[yr][i])
        elif (c == Ir):
          binl, binh = SigStep[yr][i]+1, Boundr-1
          rangel, rangeh = SigStep[yr].index(SigStep[yr][i]), SigStep[yr].index(Boundr-1)
        elif (c < Il):
          binl, binh = cats[yr][c], cats[yr][c+1]-1
          rangel, rangeh = SigStep[yr].index(cats[yr][c]-1), SigStep[yr].index(cats[yr][c+1]-1)
        elif (c > Ir):
          binl, binh = cats[yr][c-1], cats[yr][c]-1
          rangel, rangeh = SigStep[yr].index(cats[yr][c-1]-1), SigStep[yr].index(cats[yr][c]-1)
        bins[c].append([binl, binh])
        ranges[c].append([rangel, rangeh])
    print "Hello cats, i, bins, ranges", cats, i, bins, ranges 
  except hitCat:
    return -1
  catname = []
  combinestr = ''
  fitstatus = 0
  for c in range(ncats):
    fitstatus = fit([ranges[c][2][0],ranges[c][2][1]],'ggcat%i_%i'%(c,i))
    catname.append('ggcat%i_%i'%(c,i))
    combinestr += 'Name%i=Datacards/datacard_ggcat%i_%i.txt '%(c+1,c,i)
  writedatacard(catname, bins) 
#  if fitstatus != 0:
#    return -1
### Atlas Limit: 6.2*10^{-5} (5.9*10^{-5}).
  runCMD("combineCards.py " + combinestr + "> Datacards/datacard_comb_%i.txt"%i)
  #runCMD("combine -M Significance Datacards/datacard_ggcat0_%i.txt -m 125 -t -1 --expectSignal=0.006 --name %i"%(i,i))
  #runCMD("combine -M Significance Datacards/datacard_ggcat1_%i.txt -m 125 -t -1 --expectSignal=0.006 --name %i"%(i,i))
#  runCMD("combine -M AsymptoticLimits -m 125 Datacards/datacard_comb_%i.txt --name %i"%(i,i))
  #runCMD("combine -M Significance Datacards/datacard_comb_%i.txt -m 125 --name %i"%(i,i))
  if args.limit:
    runCMD("combine -M AsymptoticLimits -m 125 Datacards/datacard_comb_%i.txt --run blind --name %i"%(i,i))
    input_ = TFile("higgsCombine%i.AsymptoticLimits.mH125.root"%i)
    limitTree = input_.Get("limit")
    limitTree.GetEntry(2)
    sig = limitTree.limit
  else:
    runCMD("combine -M Significance Datacards/datacard_comb_%i.txt -m 125 -t -1 --expectSignal=0.006 --name %i"%(i,i))
    input_ = TFile("higgsCombine%i.Significance.mH125.root"%i)
    limitTree = input_.Get("limit")
    limitTree.GetEntry(0)
    sig = limitTree.limit
#  sig = rd.randint(0, 500)
  return [sig,1] 
#while run < 3:    
while run:    
  ncats = len(catdiff) + 2
  Sigx, Sigy = array.array('f'), array.array('f')
  pool = Pool(processes=cpu_count())
  #Comb = pool.map(SigScan, range(3,4)) 
  #Comb = pool.map(SigScan, range(90,91)) 
  Comb = pool.map(SigScan, range(1,n)) 
  print Comb
  for i in range(len(Comb)):
    if Comb[i] == -1: continue
    Sigx.append(1-xq[i])
    Sigy.append(Comb[i][0])

  Multigr = TMultiGraph()
  ymax_ = PlotSig(Multigr, Sigx, Sigy)
  PlotCat(Multigr, catsSig, ymax_)
  if args.limit:
    maxComb_idx = np.argmin(Sigy)
    maxComb = np.min(Sigy)
  else:
    maxComb_idx = np.argmax(Sigy)
    maxComb = np.max(Sigy)
  maxI = [SigStep[0][maxComb_idx+1], SigStep[1][maxComb_idx+1], SigStep[2][maxComb_idx+1]]
  maxSigI = Sigx[maxComb_idx]

  diff = abs((maxComb - maxCombprev)/maxCombprev)
  if diff >= 0.01:
    catdiff.append(diff)
    catsSig.append(maxSigI)
    for yr in range(nyear):
      cats[yr].append(maxI[yr]+1)
      cats[yr].sort()
    PlotMax(Multigr, maxSigI, ymax_)
    DrawNSave(Multigr, ncats)
    maxCombprev = maxComb
#    open('Hem_shape_sys.csv', 'w').close()
#    run += 1
    run = True
  else: 
#    run += 1
    run = False
    DrawNSave(Multigr, ncats)
    print "Final Cats ", cats
    print "Cat Diff ", catdiff
    print "Final Sig: ", maxCombprev

cats_mva = [[], [], []]
for yr in range(nyear):
  print "Year ", 2016+yr
  for cat in cats[yr]:
    cats_mva[yr].append(round(cat*0.001-0.0005-1,4))
  print "MVA Score: ", cats_mva[yr]
catsSig.sort()
print "Signal Efficiency: ", catsSig
