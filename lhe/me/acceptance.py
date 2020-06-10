import os
import Kinematics
from collections import OrderedDict 
from ROOT import TF1, gROOT, TFile
import sys
import glob
cmsbase = '/afs/hep.wisc.edu/home/kaho/CMSSW_10_2_16_UL/src/'
rootfiles = ['GluGlu_LFV_HToMuTau', 'VBFHToTauTau', 'GluGluHToTauTau', 'VBFHToWWTo2L2Nu', 'GluGluHToWWTo2L2Nu', 'VBF_LFV_HToMuTau']
result = open("acceptance_ME.csv", "w")
years = [cmsbase + 'UWHiggs2016/lhe2016/me/results/MCLHE2016/AnalyzeMuEGen/', cmsbase + 'UWHiggs2017/lhe/me/results/MCLHE/AnalyzeMuEGen/', 'results/MCLHE2018/AnalyzeMuEGen/']
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
    print f
    Integral[y] = {} 
    for g in Kinematics.gennames:
      h = file.Get(g+'/m_e_VisibleMass')
      bmax = h.GetXaxis().FindBin(300)
      Integral[y][g] = h.Integral(0, bmax)
      print y
      print g
      print Integral[y][g]
    accep[channel][y] = {}
    for n in Kinematics.names:
      accep[channel][y][n] =  Integral[y][n]/Integral[y][n+'All']
for rf in rootfiles:
  result.write(rf+'\n')
  for n in Kinematics.names:
    result.write(n)
    for y in years:
     print rf
     print y
     print n
     result.write(','+str(accep[rf][y][n]))
    result.write('\n')
