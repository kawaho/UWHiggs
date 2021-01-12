import os
from ROOT import gROOT, TFile, TH1F
from Kinematics import functor_gg
import sys
import glob
import math
import array 

gROOT.SetBatch(True)

fFileold = TFile("BDT.root")
hmvaS = fFileold.Get("mvaS")
hmvaB = fFileold.Get("mvaB")
hmvaSEff = fFileold.Get("mvaEff")
fFilenew = TFile("BDTSig.root", "RECREATE")
hmvaSig = TH1F("Sig", "Sig", 200, 0, 200)
hmvaSig2 = TH1F("Sig2", "Sig2", 200, 0, 200)
hmvaSig3 = TH1F("Sig3", "Sig3", 200, 0, 200)
#hEffS = TH1F("SigS", "Sig", 100, 0, 1)
#hEffB = TH1F("SigB", "Sig", 100, 0, 1)

SigStep = [1]
cut = 1
run = True
while run:
  for j in range(cut+1, hmvaSEff.GetNbinsX()+1):
     if hmvaSEff.GetBinContent(cut) != 0:
       dSEff = 2*abs(hmvaSEff.GetBinContent(cut)-hmvaSEff.GetBinContent(j))/(hmvaSEff.GetBinContent(cut)+hmvaSEff.GetBinContent(j))
     else: 
       dSEff = 0
     if j == hmvaSEff.GetNbinsX():
       run = False
     if (dSEff>=0.01):
       cut = j
       SigStep.append(cut)
       break
if SigStep[len(SigStep)-1] != 200:
  SigStep.append(200)
print SigStep

#for i in range(1, hmvaS.GetNbinsX()+1):
#  hEffS.Fill(1-hmvaSEff.GetBinContent(i), hmvaS.GetBinContent(i))

#for i in range(1, hmvaB.GetNbinsX()+1):
#  hEffB.Fill(1-hmvaSEff.GetBinContent(i), hmvaB.GetBinContent(i))

#hEffS.Write()
#hEffB.Write()

run = True
cats = [1, 200]
catdiff = []
mvacatbin = []
S = [0, 0]
B = [0, 0]
Sig = [0, 0]
maxCombprev = 0
maxComb = 0
Comb = 0
maxI = -1

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

      if B[s_b]!=0:
        Sig[s_b] = S[s_b]/math.sqrt(B[s_b])
        print "Sig at ", s_b
        print Sig[s_b]

    for s_b in range(0, len(Sig)):
      if Sig[s_b] == 0:
        Comb = 0
        break
      Comb += Sig[s_b]/math.sqrt(len(Sig))

    if Comb > maxComb:
        maxComb = Comb
        print "maxComb: ", maxComb
        maxI = SigStep[i]

  if maxComb == 0:
    continue
  if 2*abs(maxComb - maxCombprev)/(maxComb + maxCombprev) > 0.02:
    S.append(0)
    B.append(0)
    Sig.append(0)
    catdiff.append(2*abs(maxComb - maxCombprev)/(maxComb + maxCombprev))
    cats.append(maxI)
    cats.sort()
    maxCombprev = maxComb
    print "Cat: ", cats
    run = True
  else: 
    print "Final Cats ", cats
    print "Cat Diff ", catdiff
    run = False

