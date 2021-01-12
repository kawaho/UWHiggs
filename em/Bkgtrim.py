import os
from ROOT import gROOT, TFile
import sys
import glob
import math

gROOT.SetBatch(True)

fFileold = TFile("others.root")
oldtree2 = fFileold.Get("TreeB")
newtree2 = oldtree2.CloneTree()
newtree2.SetName("TreeB")

fFileold2 = TFile("Diboson.root")
oldtree22 = fFileold2.Get("TreeB")
newtree22 = oldtree22.CloneTree()
newtree22.SetName("TreeS")

fFilenew = TFile("BDT_Diboson.root","recreate")

newtree2.Write()
newtree22.Write()

