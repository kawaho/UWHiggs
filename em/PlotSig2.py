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
#hmvaS = []
#hmvaB = []
#for fFile in fFileold:
#  hmvaS.append(fFile.Get("mvaS"))
#  hmvaB.append(fFile.Get("mvaS"))

hmvaS = fFileold[0].Get("mvaS")
hmvaB = fFileold[0].Get("mvaB")

fFileold2017 = TFile("../../UWHiggs2017/em/BDT.root")
hmvaS2017 = fFileold2017.Get("mvaS")
hmvaB2017 = fFileold[0].Get("mvaB")

n = 100
xq = np.empty(n)
yq = np.empty(n)
SigStep = []

for i in range(0, n):
  xq[i] = (i+1)/float(n)

hmvaS.GetQuantiles(n,yq,xq)
print xq, yq
SigStep = [1]
for i in range(0, n):
  SigStep.append(int(hmvaS.FindBin(yq[i])))
print SigStep

hmvaS2017.GetQuantiles(n,yq,xq)
print xq, yq
SigStep2017 = [1]
for i in range(0, n):
  SigStep2017.append(int(hmvaS2017.FindBin(yq[i])))
print SigStep2017


run = True
cats = [1, 200]
catsSig = []
catdiff = []
cats2017 = [1, 200]
catsSig2017 = []
catdiff2017 = []
S = [0, 0]
B = [0, 0]
Bprev = []

Bprev2 = []
Sig = [0, 0]
maxCombprev = 0.01
maxComb = 0
maxCombpen = 0
Comb = 0
maxI = -1
maxSigI = -1
plty = 10

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
  for i in range(0, len(SigStep)-1):
    Boundl, Boundr, Il, Ir = BoundaryScan(SigStep[i], cats)[0], BoundaryScan(SigStep[i], cats)[1], BoundaryScan(SigStep[i], cats)[2], BoundaryScan(SigStep[i], cats)[3]
    Boundl2017, Boundr2017, Il2017, Ir2017 = BoundaryScan(SigStep2017[i], cats2017)[0], BoundaryScan(SigStep2017[i], cats2017)[1], BoundaryScan(SigStep2017[i], cats2017)[2], BoundaryScan(SigStep2017[i], cats2017)[3]
    Comb = 0

    if (Il == -1):
      continue
    
    Initialize(S)
    Initialize(B)
    Initialize(Sig)
    print "Scanning at ", SigStep[i]
    print "S length",  len(S)
    print Boundl, Boundr, Il, Ir

    for s_b in range(0, len(S)):
      if (s_b == Il):
        print "Boud of ", s_b
        print Boundl, SigStep[i]
        for j in range(Boundl, SigStep[i]): 
          S[s_b]+=hmvaS.GetBinContent(j)
          B[s_b]+=hmvaB.GetBinContent(j)
      elif (s_b == Ir):
        print "Boud of ", s_b
        print SigStep[i], Boundr
        for j in range(SigStep[i], Boundr): 
          S[s_b]+=hmvaS.GetBinContent(j)
          B[s_b]+=hmvaB.GetBinContent(j)
      elif (s_b < Il):
        print "Boud of ", s_b
        print cats[s_b], cats[s_b+1]
        for j in range(cats[s_b], cats[s_b+1]):
          S[s_b]+=hmvaS.GetBinContent(j) 
          B[s_b]+=hmvaB.GetBinContent(j)
      elif (s_b > Ir):
        print "Boud of ", s_b
        print cats[s_b-1], cats[s_b]
        for j in range(cats[s_b-1], cats[s_b]):
          S[s_b]+=hmvaS.GetBinContent(j)
          B[s_b]+=hmvaB.GetBinContent(j)


      if (s_b == Il2017):
        print "Boud of ", s_b
        print Boundl2017, SigStep2017[i]
        for j in range(Boundl2017, SigStep2017[i]): 
          S[s_b]+=hmvaS2017.GetBinContent(j)
          B[s_b]+=hmvaB2017.GetBinContent(j)
      elif (s_b == Ir2017):
        print "Boud of ", s_b
        print SigStep2017[i], Boundr2017
        for j in range(SigStep2017[i], Boundr2017): 
          S[s_b]+=hmvaS2017.GetBinContent(j)
          B[s_b]+=hmvaB2017.GetBinContent(j)
      elif (s_b < Il):
        print "Boud of ", s_b
        print cats2017[s_b], cats2017[s_b+1]
        for j in range(cats2017[s_b], cats2017[s_b+1]):
          S[s_b]+=hmvaS2017.GetBinContent(j) 
          B[s_b]+=hmvaB2017.GetBinContent(j)
      elif (s_b > Ir):
        print "Boud of ", s_b
        print cats2017[s_b-1], cats2017[s_b]
        for j in range(cats2017[s_b-1], cats2017[s_b]):
          S[s_b]+=hmvaS2017.GetBinContent(j)
          B[s_b]+=hmvaB2017.GetBinContent(j)

      if B[s_b]!=0:
        Sig[s_b] = S[s_b]/math.sqrt(B[s_b])
        print "Sig at ", s_b
        print Sig[s_b]

    for s_b in range(0, len(Sig)):
      if Sig[s_b] == 0:
        Comb = 0
        break
      Comb += Sig[s_b]/math.sqrt(len(Sig))
      
    if Comb >= 1:
      Sigx.append(xq[i])
      Sigy.append(Comb)
    print "Int: ", hmvaB.Integral("width")
    Combpen = Comb #*(1+p2*(1-p2)) #*(1+ min(p2*(1-p2), p3*(1-p3))) #(-1math.exp(math.exp(p-1)-1))

    if Combpen > maxCombpen: # and Pass:
        maxCombpen = Combpen
        maxComb = Comb
        Bprev = B[:]
        print "maxCombpen: ", maxCombpen
        print "maxComb: ", maxComb
        maxI = SigStep[i]
        maxI2017 = SigStep2017[i]
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
  if diff > 0.03:
    Bprev2 = Bprev[:]
    S.append(0)
    B.append(0)
    Sig.append(0)
    catdiff.append(abs(maxComb - maxCombprev)/maxCombprev)
    cats.append(maxI)
    cats2017.append(maxI2017)
    catsSig.append(maxSigI)
    cats.sort()
    cats2017.sort()
    line = TGraph(2)
    line.SetPoint(0, maxSigI ,0)
    line.SetPoint(1, maxSigI ,np.max(Sigy)+5)
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
cats_mva2017 = []
cats_mva = []
cats_sig = []
for cat in cats:
  cats_mva.append(cat*0.01-0.005-1)
for cat in cats2017:
  cats_mva2017.append(cat*0.01-0.005-1)
print "Signal Efficiency: ", catsSig
print "MVA Score: ",cats_mva
print "MVA Score 2017: ",cats_mva2017
print "BBB: ", Bprev2
