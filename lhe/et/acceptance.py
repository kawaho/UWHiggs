import os
import Kinematics
from ROOT import TF1, gROOT, TFile
import sys
import glob
cmsbase = '/afs/hep.wisc.edu/home/kaho/CMSSW_10_2_16_UL/src/'
rootfiles = ['GluGlu_LFV_HToETau', 'VBFHToTauTau', 'GluGluHToTauTau', 'VBFHToWWTo2L2Nu', 'GluGluHToWWTo2L2Nu', 'VBF_LFV_HToETau']
result = open("acceptance_ET.csv", "w")
years = [cmsbase + 'UWHiggs2016/lhe2016/et/results/MCLHE2016/AnalyzeETauGen/', cmsbase + 'UWHiggs2017/lhe/et/results/MCLHE/AnalyzeETauGen/', 'results/MCLHE2018/AnalyzeETauGen/']
result.write(',2016,2017,2018\n')
Integral = {}
accep = {}
for rf in rootfiles:
 accep[rf] = {}
for y in years:
  files = []
  files.extend(glob.glob(y + '*.root'))
  for f in files:
    for rf in rootfiles:
      if rf in f:
        channel = rf
    file = TFile(f)
    Integral[y] = {} 
    for g in Kinematics.gennames:
      h = file.Get(g+'/e_t_VisibleMass')
      bmax = h.GetXaxis().FindBin(300)
      Integral[y][g] = h.Integral(0, bmax)
    accep[channel][y] = {}
    for n in Kinematics.names:
      accep[channel][y][n] =  Integral[y][n]/Integral[y][n+'All']
for rf in rootfiles:
  result.write(rf+'\n')
  for n in Kinematics.names:
    result.write(n)
    for y in years:
     result.write(','+str(accep[rf][y][n]))
    result.write('\n')
