from ROOT import TH1F, TFile, TH2F
import numpy as np
path = "/afs/hep.wisc.edu/home/kaho/CMSSW_10_2_16_UL/src/UWHiggs/em/results/Data2018_em/AnalyzeEMValid2/"

fFileData = TFile(path+"QCD_Pt-20toInf_MuEnrichedPt15_TuneCP5_13TeV_pythia8_v14-v1.root")
os_data = fFileData.Get("TightOS/eEta")#.Rebin(5)
ss_data = fFileData.Get("TightSS/eEta")#.Rebin(5)

fFileBkg = TFile(path+"others.root")
os_bkg = fFileBkg.Get("TightOS/eEta")#.Rebin(5)
ss_bkg = fFileBkg.Get("TightSS/eEta")#.Rebin(5)

fFileWW = TFile(path+"WW_TuneCP5_13TeV-pythia8_-102X_upgrade2018_realistic_v15-v2.root")
os_ww = fFileWW.Get("TightOS/eEta")#.Rebin(5)
ss_ww = fFileWW.Get("TightSS/eEta")#.Rebin(5)
#os_data.Rebin2D(5,5)
#ss_data.Rebin2D(5,5)
#os_bkg.Rebin2D(5,5)
#ss_bkg.Rebin2D(5,5)
#os_ww.Rebin2D(5,5)
#ss_ww.Rebin2D(5,5)

#fFileWW_weight = TFile("WW_weight.root", "recreate")
##WW_weight = TH2F("WW_weight", "WW_weight", 25, 0, 25, 25, 0, 25)
#WW_weight = TH1F("WW_weight", "WW_weight", 50, 0, 50)

total_data = os_data.Integral()
total_bkg = os_bkg.Integral()
total_ww = os_ww.Integral()

total_qcd = 0
for i in range(1, os_data.GetNbinsX()+1):
  if (ss_data.GetBinContent(i) - ss_bkg.GetBinContent(i) - ss_ww.GetBinContent(i)) > 0:
    total_qcd = total_qcd + ss_data.GetBinContent(i) - ss_bkg.GetBinContent(i) - ss_ww.GetBinContent(i)
diff = total_data - total_bkg - total_qcd - total_ww
#sf = 1 - diff/total_ww
#print sf
print "Orig diff: ", diff
if diff < 0:
  list_ = np.arange(0, 1, 0.0001)
else:
  list_ = np.arange(1, 2, 0.0001)
minf = 0
mindiff = 9999
for f in list_: 
  total_qcd = 0
  for i in range(1, os_data.GetNbinsX()+1):
    if (ss_data.GetBinContent(i) - ss_bkg.GetBinContent(i) - f*ss_ww.GetBinContent(i)) > 0:
      total_qcd = total_qcd + ss_data.GetBinContent(i) - ss_bkg.GetBinContent(i) - f*ss_ww.GetBinContent(i)
  diff = total_data - total_bkg - total_qcd - f*total_ww
  if abs(diff) < abs(mindiff):
    minf = f
    mindiff = diff
print minf, mindiff

#for i in range(1, os_data.GetNbinsX()+1):
#  mindiff = 9999
#  minf = 1
#  if (ss_data.GetBinContent(i) - ss_bkg.GetBinContent(i) - ss_ww.GetBinContent(i)) > 0:
#    diff = os_data.GetBinContent(i) - os_bkg.GetBinContent(i) - os_ww.GetBinContent(i) - ss_data.GetBinContent(i) + ss_bkg.GetBinContent(i) + ss_ww.GetBinContent(i)
#  else:
#    diff = os_data.GetBinContent(i) - os_bkg.GetBinContent(i) - os_ww.GetBinContent(i)
#  print "Orig diff: ", diff
#  if diff < 0:
#    list_ = np.arange(0, 1, 0.0001)
#  else:
#    list_ = np.arange(1, 2, 0.0001)
#  for f in list_: 
#    if (ss_data.GetBinContent(i) - ss_bkg.GetBinContent(i) - f*ss_ww.GetBinContent(i)) > 0:
#      diff = os_data.GetBinContent(i) - os_bkg.GetBinContent(i) - f*os_ww.GetBinContent(i) - ss_data.GetBinContent(i) + ss_bkg.GetBinContent(i) + f*ss_ww.GetBinContent(i)
#    else:
#      diff = os_data.GetBinContent(i) - os_bkg.GetBinContent(i) - f*os_ww.GetBinContent(i)
#  
#    if abs(diff) < abs(mindiff):
#      minf = f
#      mindiff = diff
#  WW_weight.Fill(i-1,minf)
#  print i, minf, mindiff
#WW_weight.Write()
#for i in range(1, os_data.GetNbinsX()+1):
#  for j in range(1, os_data.GetNbinsY()+1):
#    mindiff = 9999
#    minf = 1
#    if (ss_data.GetBinContent(i,j) - ss_bkg.GetBinContent(i,j) - ss_ww.GetBinContent(i,j)) > 0:
#      diff = os_data.GetBinContent(i,j) - os_bkg.GetBinContent(i,j) - os_ww.GetBinContent(i,j) - ss_data.GetBinContent(i,j) + ss_bkg.GetBinContent(i,j) + ss_ww.GetBinContent(i,j)
#    else:
#      diff = os_data.GetBinContent(i,j) - os_bkg.GetBinContent(i,j) - os_ww.GetBinContent(i,j)
#    print "Orig diff: ", diff
#    if diff < 0:
#      list_ = np.arange(0, 1, 0.0001)
#    else:
#      list_ = np.arange(1, 2, 0.0001)
#    for f in list_: 
#      if (ss_data.GetBinContent(i,j) - ss_bkg.GetBinContent(i,j) - f*ss_ww.GetBinContent(i,j)) > 0:
#        diff = os_data.GetBinContent(i,j) - os_bkg.GetBinContent(i,j) - f*os_ww.GetBinContent(i,j) - ss_data.GetBinContent(i,j) + ss_bkg.GetBinContent(i,j) + f*ss_ww.GetBinContent(i,j)
#      else:
#        diff = os_data.GetBinContent(i,j) - os_bkg.GetBinContent(i,j) - f*os_ww.GetBinContent(i,j)
#    
#      if abs(diff) < abs(mindiff):
#        minf = f
#        mindiff = diff
#    WW_weight.Fill(i-1,j-1,minf)
#    print 'Original Weights: ', i, j, os_ww.GetBinContent(i,j) 
#    print 'Factor, diff: ', minf, mindiff
#WW_weight.Write()
