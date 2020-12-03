from ROOT import TFile, TH1
import Kinematics 
import itertools
import os

#file_gg = TFile('results/Data2016JEC/AnalyzeEMSys/GluGlu_LFV_HToEMu_M125_13TeV_powheg_pythia8_v3-PUMoriond17_94X_mcRun2_asymptotic_v3-v2.root')
#file_vbf = TFile('results/Data2016JEC/AnalyzeEMSys/VBF_LFV_HToEMu_M125_13TeV_powheg_pythia8_v3-PUMoriond17_94X_mcRun2_asymptotic_v3-v2.root')

file_gg = TFile('results/Data2016JEC/AnalyzeEMSys/SignalGG.root')
file_vbf = TFile('results/Data2016JEC/AnalyzeEMSys/SignalVBF.root')
hgg = file_gg.Get('TightOS/e_m_Mass').Integral()
hvbf = file_vbf.Get('TightOS/e_m_Mass').Integral()

hgg_gg = file_gg.Get('TightOSgg/e_m_Mass').Integral()
hvbf_gg = file_vbf.Get('TightOSgg/e_m_Mass').Integral()

hgg_vbf = file_gg.Get('TightOSvbf/e_m_Mass').Integral()
hvbf_vbf = file_vbf.Get('TightOSvbf/e_m_Mass').Integral()


print 'ggcat_ggproc', hgg_gg*100/hgg, 'vbfcat_ggproc', hgg_vbf*100/hgg
print 'ggcat_vbfproc', hvbf_gg*100/hvbf, 'vbfcat_vbfproc', hvbf_vbf*100/hvbf
