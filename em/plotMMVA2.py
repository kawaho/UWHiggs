from ROOT import Math, gROOT,TH1F, TH2F, TFile, TCanvas, gStyle, TLegend, TLine, gPad, TLatex, TProfile
import array 
import numpy as np
gROOT.SetBatch(True)

n = 5
xq = np.array([.2,.4,.6,.8,1])
yq = np.empty(n)

fFilenew = TFile("BDT_plot.root")
hmvaB = fFilenew.Get("mvaB")

#fFilenew2017 = TFile("../../UWHiggs2017/em/BDT_plot.root")
#hmvaB2017 = fFilenew2017.Get("mvaB")
#
#fFilenew2018 = TFile("../../UWHiggs/em/BDT_plot.root")
#hmvaB2018 = fFilenew2018.Get("mvaB")

#hmvaB.Add(hmvaB2017)
#hmvaB.Add(hmvaB2018)
hmvaB.GetQuantiles(n,yq,xq)
print yq
oldtree2 = fFilenew.Get("TreeBgg_120-130GeV")
nEntries2 = oldtree2.GetEntries()

gStyle.SetOptStat(False)
canvas = TCanvas('canvas','canvas',850,800)

MMVA1 = TH1F('MMVA1', ' ', 50, 110, 160)
MMVA2 = TH1F('MMVA2', ' ', 50, 110, 160)
MMVA3 = TH1F('MMVA3', ' ', 50, 110, 160)
MMVA4 = TH1F('MMVA4', ' ', 50, 110, 160)
MMVA5 = TH1F('MMVA5', ' ', 50, 110, 160)

mva1 = np.array([])
mva2 = np.array([])
mva3 = np.array([])
mva4 = np.array([])
mva5 = np.array([])

fFileplot = TFile("BDTVA.root","recreate")

for i in range(0, nEntries2):
  oldtree2.GetEntry(i)
  mva = oldtree2.mva
#  if oldtree2.e_m_Mass > 135 or oldtree2.e_m_Mass < 115: continue
  if mva < yq[0]:
    MMVA1.Fill(oldtree2.e_m_Mass, oldtree2.weight)
    mva1 = np.append(mva1,oldtree2.e_m_Mass) 
  elif mva < yq[1]:
    MMVA2.Fill(oldtree2.e_m_Mass, oldtree2.weight)
    mva2 = np.append(mva2,oldtree2.e_m_Mass) 
  elif mva < yq[2]:
    MMVA3.Fill(oldtree2.e_m_Mass, oldtree2.weight)
    mva3 = np.append(mva3,oldtree2.e_m_Mass) 
  elif mva < yq[3]:
    MMVA4.Fill(oldtree2.e_m_Mass, oldtree2.weight)
    mva4 = np.append(mva4,oldtree2.e_m_Mass) 
  elif mva < yq[4]:
    MMVA5.Fill(oldtree2.e_m_Mass, oldtree2.weight)
    mva5 = np.append(mva5,oldtree2.e_m_Mass) 
print "len", len(mva1)
print len(mva2)
print len(mva3)
print len(mva4)
print len(mva5)
print MMVA1.AndersonDarlingTest(MMVA2)
print MMVA1.AndersonDarlingTest(MMVA3)
print MMVA1.AndersonDarlingTest(MMVA4)
print MMVA1.AndersonDarlingTest(MMVA5)
print MMVA2.AndersonDarlingTest(MMVA3)
print MMVA2.AndersonDarlingTest(MMVA4)
print MMVA2.AndersonDarlingTest(MMVA5)
print MMVA3.AndersonDarlingTest(MMVA4)
print MMVA3.AndersonDarlingTest(MMVA5)
print MMVA4.AndersonDarlingTest(MMVA5)
#mva1 = np.sort(mva1)
#mva2 = np.sort(mva2)
#mva3 = np.sort(mva3)
#mva4 = np.sort(mva4)
#mva5 = np.sort(mva5)
#gof12 = Math.GoFTest(len(mva1),mva1,len(mva2),mva2)
#gof13 = Math.GoFTest(len(mva1),mva1,len(mva3),mva3)
#gof14 = Math.GoFTest(len(mva1),mva1,len(mva4),mva4)
#gof15 = Math.GoFTest(len(mva1),mva1,len(mva5),mva5)
#gof23 = Math.GoFTest(len(mva2),mva2,len(mva3),mva3)
#gof24 = Math.GoFTest(len(mva2),mva2,len(mva4),mva4)
#gof25 = Math.GoFTest(len(mva2),mva2,len(mva5),mva5)
#gof34 = Math.GoFTest(len(mva3),mva3,len(mva4),mva4)
#gof35 = Math.GoFTest(len(mva3),mva3,len(mva5),mva5)
#gof45 = Math.GoFTest(len(mva4),mva4,len(mva5),mva5)
#print gof12.AndersonDarling2SamplesTest()
#print gof13.AndersonDarling2SamplesTest()
#print gof14.AndersonDarling2SamplesTest()
#print gof15.AndersonDarling2SamplesTest()
#print gof23.AndersonDarling2SamplesTest()
#print gof24.AndersonDarling2SamplesTest()
#print gof25.AndersonDarling2SamplesTest()
#print gof34.AndersonDarling2SamplesTest()
#print gof35.AndersonDarling2SamplesTest()
#print gof45.AndersonDarling2SamplesTest()
MMVA1.Write()
MMVA2.Write()
MMVA3.Write()
MMVA4.Write()
MMVA5.Write()
