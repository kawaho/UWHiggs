import ROOT as r
import os

def positivize(histogram):
  output = histogram.Clone()
  for i in range(output.GetSize()):
    if output.GetArray()[i] < 0:
      output.AddAt(0, i)
  return output

def getExtrapolation(histogram):
  output = histogram.Clone()
  EF = 0
  EF_idx = 0
  for i in range(output.GetSize()):
    if output.GetArray()[i] > 0:
      EF+=output.GetArray()[i]
      EF_idx+=1
  return EF/EF_idx

data_file = r.TFile('results/'+os.environ['jobid']+'/AnalyzeEMYield/data.root')
mc_file = r.TFile('results/'+os.environ['jobid']+'/AnalyzeEMYield/MC.root')

data_SS = data_file.Get('ZSS/M_pt')
mc_SS = mc_file.Get('ZSS/M_pt')

data_OS = data_file.Get('ZOS/M_pt')
mc_OS = mc_file.Get('ZOS/M_pt')

QCD_SS = data_SS.Add(mc_SS, -1).Clone()
QCD_OS = data_OS.Add(mc_SS, -1).Clone()

QCD_SS = positivize(QCD_SS)
QCD_OS = positivize(QCD_OS)

QCDF_hist = QCD_OS.Divide(QCD_SS).Clone()

print getExtrapolation(QCDF_hist)
