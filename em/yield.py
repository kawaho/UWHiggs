import os
import glob
import Kinematics
from ROOT import TFile
files = []
files.extend(glob.glob('./AnalyzeEMYield/*.root'))
paths = ['TightOSgg','TightOSvbf','TightOSggjets','TightOSvbfjets']
for f in files:
  if "MC" in f or "LFV" in f:
    tf = TFile(f)
    hist = []
    for path in paths:
      hist.append(tf.Get(path+"/e_m_Mass"))
    for p,h in zip(paths,hist):
      events = h.Integral(h.FindFixBin(115), h.FindFixBin(135))
      print f, p, events


dataf = TFile("./AnalyzeEMYield/data.root")
mcf = TFile("./AnalyzeEMYield/MC.root")

paths = ['TightSSgg','TightSSvbf','TightSSggjets','TightSSvbfjets']
for p in paths:
  hist_data = dataf.Get(p+"/e_m_Mass")
  hist_MC = mcf.Get(p+"/e_m_Mass")
  hist_QCD = hist_data.Clone()
  hist_QCD.Add(hist_MC,-1)
  for i in range(1,hist_QCD.GetNbinsX()+1):
    if hist_QCD.GetBinContent(i) < 0:
       hist_QCD.SetBinContent(i,0)
  events = hist_QCD.Integral(h.FindFixBin(115), h.FindFixBin(135))
  print "QCD", p, events


