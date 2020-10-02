import os
from ROOT import gROOT, TFile, TH1F
from Kinematics import functor_gg
import sys
import glob
import math
import array 

gROOT.SetBatch(True)

fFileold = TFile("BDT.root")
hmvaSEff = fFileold.Get("mvaEff")
hmvaS = fFileold.Get("mvaS")
hmvaB = fFileold.Get("mvaB")
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

cat = []
run = True
Sig = 0
S = 0
B = 0
Sprev = 0
Bprev = 0
for i in range(0, len(SigStep)-1):
  Sigprev = Sig
  Sprev = S
  Bprev = B
  S = 0
  B = 0
  for j in range(SigStep[i], SigStep[i+1]):
    S+=hmvaS.GetBinContent(j)
    B+=hmvaB.GetBinContent(j)
  if B!=0:
    Sig=S/math.sqrt(B)
  if run:
    run = False
    continue
  if (abs(Sig-Sigprev)*2/(Sig+Sigprev) > 0.25):
    print "Now ", Sig
    print "Prev ", Sigprev
    cat.append(i)
    run = True
  else:
    S+=Sprev
    B+=Bprev
    if B!=0:
      Sig=S/math.sqrt(B)
print cat 
