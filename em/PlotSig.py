import os
from ROOT import gROOT, TFile, TH1F, TGraph, TCanvas, TLine, gPad, TMultiGraph
import sys
import glob
import math
import array 
import numpy as np

gROOT.SetBatch(True)
canvas = TCanvas('canvas','canvas',850,800)
fFileold = TFile("BDT.root")

hmvaS = fFileold.Get("mvaS")
hmvaB = fFileold.Get("mvaB")
hmvaSEff = fFileold.Get("mvaEff")

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

#cut = 1
#prevcut = 0
#run = True
#while run:
#  for j in range(cut+1, hmvaSEff.GetNbinsX()+1):
#    if j == hmvaSEff.GetNbinsX()  or hmvaSEff.GetBinContent(j) <= 0.01:
#      run = False
#      break
#    if (hmvaSEff.GetBinContent(cut)-hmvaSEff.GetBinContent(j))>=0.01:
#      cut = j
#      SigStep.append(cut)
#      print hmvaSEff.GetBinContent(j)
#      break

#if SigStep[len(SigStep)-1] != 200:
#  SigStep.append(200)
#print SigStep

#while run:
#  for j in range(cut+1, hmvaSEff.GetNbinsX()+1):
#     if hmvaSEff.GetBinContent(cut) != 0:
#       print cut, j, hmvaSEff.GetBinContent(cut), hmvaSEff.GetBinContent(j)
#       dSEff = abs(hmvaSEff.GetBinContent(cut)-hmvaSEff.GetBinContent(j))/hmvaSEff.GetBinContent(cut)
#     else: 
#       dSEff = 0
#     if j == hmvaSEff.GetNbinsX():
#       run = False
#     if (dSEff>=0.01):
#       print "dSEff", dSEff
#       cut = j
#       if hmvaSEff.GetBinContent(cut) < 0.01:
#         run = False
#         break
#       SigStep.append(cut)
#       break
#
#if SigStep[len(SigStep)-1] != 200:
#  SigStep.append(200)
#print SigStep

 
#for i in range(0, len(SigStep)):
#  print "Siggg", hmvaSEff.GetBinContent(SigStep[i])

run = True
cats = [1, 200]
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
maxI = -1
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
          S[s_b]+=hmvaS.GetBinContent(j) #*hmvaS.GetBinWidth(j)
          B[s_b]+=hmvaB.GetBinContent(j) #*hmvaB.GetBinWidth(j)
      elif (s_b == Ir):
        print "Boud of ", s_b
        print SigStep[i], Boundr
        for j in range(SigStep[i], Boundr): 
          S[s_b]+=hmvaS.GetBinContent(j) #*hmvaS.GetBinWidth(j)
          B[s_b]+=hmvaB.GetBinContent(j) #*hmvaB.GetBinWidth(j)
      elif (s_b < Il):
        print "Boud of ", s_b
        print cats[s_b], cats[s_b+1]
        for j in range(cats[s_b], cats[s_b+1]):
          S[s_b]+=hmvaS.GetBinContent(j) #*hmvaS.GetBinWidth(j)
          B[s_b]+=hmvaB.GetBinContent(j) #*hmvaB.GetBinWidth(j)
      elif (s_b > Ir):
        print "Boud of ", s_b
        print cats[s_b-1], cats[s_b]
        for j in range(cats[s_b-1], cats[s_b]):
          S[s_b]+=hmvaS.GetBinContent(j) #*hmvaS.GetBinWidth(j)
          B[s_b]+=hmvaB.GetBinContent(j) #*hmvaB.GetBinWidth(j)

      if B[s_b]!=0:
        Sig[s_b] = S[s_b]/math.sqrt(B[s_b])
        print "Sig at ", s_b
        print Sig[s_b]

#    p2 = 0
    for s_b in range(0, len(Sig)):
      if Sig[s_b] == 0:
        Comb = 0
        break
      Comb += Sig[s_b]/math.sqrt(len(Sig))
#      p2 += B[s_b]**2/hmvaB.Integral("width")**2
      
    if Comb >= 1:
      Sigx.append(hmvaSEff.GetBinContent(SigStep[i]))
      Sigy.append(Comb)
    print "Int: ", hmvaB.Integral("width")
#    p = max(abs(B[Il]-hmvaB.Integral("width")/len(B))*2/(B[Il]+hmvaB.Integral("width")/len(B)), abs(B[Ir]-hmvaB.Integral("width")/len(B))*2/(B[Ir]+hmvaB.Integral("width")/len(B)))
#    print "lr, ll", B[Ir], B[Il]
#    print "pvalue", p
#    p2 = B[Ir]/hmvaB.Integral()
#    p3 = B[Il]/hmvaB.Integral()
    Combpen = Comb #*(1+p2*(1-p2)) #*(1+ min(p2*(1-p2), p3*(1-p3))) #(-1math.exp(math.exp(p-1)-1))
#    Pass = True
#    if 2*(max(B) - min(B))/(min(B) + max(B)) > 1:
#        Pass = False

    if Combpen > maxCombpen: # and Pass:
        maxCombpen = Combpen
        maxComb = Comb
        Bprev = B[:]
        print "maxCombpen: ", maxCombpen
        print "maxComb: ", maxComb
        maxI = SigStep[i]
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
  for cat in cats:
    if cat == 1 or cat == 200:
      continue 
    line = TGraph(2)
    line.SetPoint(0, hmvaSEff.GetBinContent(cat) ,0)
    line.SetPoint(1, hmvaSEff.GetBinContent(cat) ,np.max(Sigy)+5)
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
    cats.append(maxI)
    cats.sort()
    line = TGraph(2)
    line.SetPoint(0,hmvaSEff.GetBinContent(maxI) ,0)
    line.SetPoint(1, hmvaSEff.GetBinContent(maxI) ,np.max(Sigy)+5)
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
cats_mva = []
cats_sig = []
for cat in cats:
  cats_sig.append(hmvaSEff.GetBinContent(cat))
  cats_mva.append(cat*0.01-0.005-1)
print "Signal Efficiency: ", cats_sig
print "MVA Score: ",cats_mva
print "BBB: ", Bprev2
