import os
from ROOT import gROOT, TFile, TH1F, TGraph, TCanvas, TLine, gPad, TMultiGraph
import sys
import glob
import math
import array 
import numpy as np

gROOT.SetBatch(True)
canvas = TCanvas('canvas','canvas',850,800)

fFileold = [TFile("BDT.root"), TFile("../../UWHiggs2017/em/BDT.root")]

n = 100
nyear = 2
xq = np.empty(n)
yq = np.empty(n)
for i in range(0, n):
  xq[i] = (i+1)/float(n)

hmvaS = []
hmvaB = []
for fFile in fFileold:
  hmvaS.append(fFile.Get("mvaS"))
  hmvaB.append(fFile.Get("mvaB"))

SigStep = [[1], [1]]
for i in range(0, nyear):
  hmvaS[i].GetQuantiles(n,yq,xq)
  for j in range(0, n):
    SigStep[i].append(hmvaS[i].FindBin(yq[j]))
print SigStep

run = True
cats = [[1, 200], [1,200]]
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
maxI = [-1,-1]
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
  for i in range(1, n):
    Initialize(S)
    Initialize(B)
    Initialize(Sig)
    Comb = 0

    for yr in range(0, nyear):

      print "Scanning at ", 2016+yr
      Boundl, Boundr, Il, Ir = BoundaryScan(SigStep[yr][i], cats[yr])[0], BoundaryScan(SigStep[yr][i], cats[yr])[1], BoundaryScan(SigStep[yr][i], cats[yr])[2], BoundaryScan(SigStep[yr][i], cats[yr])[3]

      if (Il == -1):
        continue
    
      print "Scanning at ", SigStep[yr][i]
      print Boundl, Boundr, Il, Ir

      for s_b in range(0, len(S)):
        if (s_b == Il):
          print "Boud of ", s_b
          print Boundl, SigStep[yr][i]
          for j in range(Boundl, SigStep[yr][i]): 
            S[s_b]+=hmvaS[yr].GetBinContent(j)
            B[s_b]+=hmvaB[yr].GetBinContent(j)
        elif (s_b == Ir):
          print "Boud of ", s_b
          print SigStep[yr][i], Boundr
          for j in range(SigStep[yr][i], Boundr): 
            S[s_b]+=hmvaS[yr].GetBinContent(j)
            B[s_b]+=hmvaB[yr].GetBinContent(j)
        elif (s_b < Il):
          print "Boud of ", s_b
          print cats[yr][s_b], cats[yr][s_b+1]
          for j in range(cats[yr][s_b], cats[yr][s_b+1]):
            S[s_b]+=hmvaS[yr].GetBinContent(j) 
            B[s_b]+=hmvaB[yr].GetBinContent(j)
        elif (s_b > Ir):
          print "Boud of ", s_b
          print cats[yr][s_b-1], cats[yr][s_b]
          for j in range(cats[yr][s_b-1], cats[yr][s_b]):
            S[s_b]+=hmvaS[yr].GetBinContent(j)
            B[s_b]+=hmvaB[yr].GetBinContent(j)

    for s_b in range(0, len(Sig)):
      if B[s_b]!=0:
        Sig[s_b] = S[s_b]/math.sqrt(B[s_b])
        Comb += Sig[s_b]/math.sqrt(len(Sig))
        print "Sig at ", s_b
        print Sig[s_b]

      
    if Comb >= 1:
      Sigx.append(1-xq[i])
      Sigy.append(Comb)

    Combpen = Comb 
    if Combpen > maxCombpen: 
      maxCombpen = Combpen
      maxComb = Comb
      Bprev = B[:]
      print "maxCombpen: ", maxCombpen
      print "maxComb: ", maxComb
      maxI = [SigStep[0][i], SigStep[1][i]]
      maxSigI = xq[i]
      print "maxI ", maxI

    print Sigx
    print Sigy

    Multigr = TMultiGraph()
    gr = TGraph(len(Sigx), Sigx, Sigy)
    gr.GetXaxis().SetRangeUser(0, 1)
    gr.GetXaxis().SetTitle("Siganl Efficiency")
    gr.GetYaxis().SetTitle("Combined Sensitivity")
    gr.SetTitle("")
    gr.GetYaxis().SetRangeUser(np.min(Sigy)-1,  np.max(Sigy)+1)
  #  gr.SetMarkerSize(5)
    gr.SetMarkerStyle(8)
    Multigr.Add(gr, 'ap')

    for cat in catsSig:
      line = TGraph(2)
      line.SetPoint(0, cat ,0)
      line.SetPoint(1, cat ,np.max(Sigy)+5)
      Multigr.Add(line, 'l')

  if maxComb == 0:
    continue

  diff = abs(maxComb - maxCombprev)/maxCombprev
  if diff > 0.065:
    Bprev2 = Bprev[:]
    S.append(0)
    B.append(0)
    Sig.append(0)
    catdiff.append(abs(maxComb - maxCombprev)/maxCombprev)
    catsSig.append(1-maxSigI)
    for yr in range(0, nyear):
      cats[yr].append(maxI[yr])
      cats[yr].sort()
    line = TGraph(2)
    line.SetPoint(0, 1-maxSigI ,0)
    line.SetPoint(1, 1-maxSigI ,np.max(Sigy)+5)
    line.SetLineColor(2)
    Multigr.Add(line, 'l')
    Multigr.Draw()
    canvas.SaveAs('Sig/' + str(ncats) + '.png')
    
    maxCombprev = maxComb
    print "Cat: ", cats
    run = True
  else: 
    print "Final Cats ", cats
    print "Cat Diff ", catdiff
    run = False
    Multigr.Draw()

    canvas.SaveAs('Sig/' + str(ncats) + '.png')
    print "Final Sig: ", maxComb
cats_mva = [[], []]
print "MVA Score: "
for yr in range(0, nyear):
  print "Year ", 2016+yr
  for cat in cats[yr]:
    cats_mva[yr].append(cat*0.01-0.005-1)
  print cats_mva[yr]
print "Signal Efficiency: ", catsSig
print "BBB: ", Bprev2
