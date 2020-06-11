import os
import Kinematics
from ROOT import TF1, gROOT, TFile
import sys
import glob

result = open("acceptance2017_EM.txt", "w")
files = []
files.extend(glob.glob('results/MCLHE/AnalyzeEMuGen/*.root')) 

for f in files:
	Dict = {} 
	file = TFile(f)
	for g in Kinematics.gennames:	
		h = file.Get(g+'/e_m_VisibleMass')
		bmax = h.GetXaxis().FindBin(300)
		Dict[g] = h.Integral(0, bmax)
	result.write(f.replace('results/MCLHE2018/AnalyzeEMuGen/', '')+'\n')
	for k in Kinematics.names:
		p =  Dict[k]/Dict[k+'All']
		result.write ('Acceptance for ' + k + '\n')
		result.write (str(p) + '\n')
	result.write ('---------------------------------------------\n')
