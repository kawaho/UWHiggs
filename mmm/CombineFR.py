from ROOT import TFile
import glob
import os

jobid = os.environ['jobid']  
print jobid 

mc_samples = ['DYJ*', 'DY1*', 'DY2*', 'DY3*', 'DY4*', 'WZ*', 'WW*', 'ZZ*', 'data*']
files = []
for x in mc_samples:
	print x
	files.extend(glob.glob('results_c/%s/AnalyzeMMM/%s' % (jobid, x)))

dirs = ['initial', 'muontight','muonloose']
for file_ in files:
	file_m = TFile(file_, "UPDATE")
	if !file_.startswith(data):
		file_e = TFile('ee_'+file_)
	else
		file_e = TFile('ee_'+file_.replace('SingleMuon', 'EGamma')
	for dir_ in dirs:
		hist_ePt = file_e.Get(dir_+'/mPt')
		hist_mPt = file_m.Get(dir_+'/m3Pt')
		hist_mPt = hist_ePt + hist_mPt
		hist_em = file_e.Get(dir_+'/e1_e2_Mass')
                hist_mm = file_m.Get(dir_+'/m1_m2_Mass')
                hist_mm = hist_em + hist_mm
		file_m.Write("",TObject::kOverwrite);
			

