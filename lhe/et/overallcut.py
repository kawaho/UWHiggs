from ROOT import TFile, gROOT, TF1
import glob

#names = ['GluGlu_LFV*root', 'VBF_LFV*root']

#names = ['TotalBkg.root', 'Diboson.root', 'TTbar.root', 'SingleT.root', 'Embedded.root']

names = ['DataEstimatedBkg.root', 'TotalBkg.root']

#cut_flow_step = ['allEvents', 'passFilters', 'passOppSign', 'passTrigger', 'passKinematics', 'passDeltaR', 'passNjets', 'passVetoes', 'passbjetVeto', 'passObj1id', 'passObj2id', 'passtDecayMode', 'passdieleVeto', 'passObj2looseANDnottight']

#cut_flow_step = ['allEvents', 'passFilters', 'passOppSign', 'passTrigger', 'passKinematics', 'passDeltaR', 'passNjets', 'passVetoes', 'passbjetVeto', 'passObj1id', 'passObj2id', 'passtDecayMode', 'passdieleVeto', 'passObj1tight', 'passObj2tight']

#eff = ['Filter', 'OppSign', 'Trigger', 'Kinematics', 'DeltaR', 'NJets', 'Vetoes', 'bjestVeto', 'Obj1 ID', 'Obj2 ID', 'tDecayMode', 'dieleVeto', 'Obj2 loose + not tight', 'Overall Cut']

cmsbase = '/afs/hep.wisc.edu/home/kaho/CMSSW_10_2_16_UL/src/'

years = [cmsbase + 'UWHiggs2016/lhe2016/et/results/MCLHE2016/AnalyzeETauCF/', cmsbase + 'UWHiggs2017/lhe/et/results/MCLHE/AnalyzeETauCF/', 'results/MCLHE2018/AnalyzeETauCF/']

result = open("OverallBkgCF_ET.csv", "w")
cuts = [None] * 3
result.write(',2016,2017,2018\n')
for j, y in enumerate(years):   
  files = []
  for n in names:
    files.extend(glob.glob(y + n))
  file1 = TFile(files[0])
  file2 = TFile(files[1])
  cutflowhisto1 = file1.Get('./CUT_FLOW')
  cutflowhisto2 = file2.Get('./CUT_FLOW')
  max1 = cutflowhisto1.GetNbinsX()
  max2 = cutflowhisto2.GetNbinsX()
  print max1, max2
  cuts[j] = round ((cutflowhisto1.GetBinContent(max1) + cutflowhisto2.GetBinContent(max2))/ (cutflowhisto1.GetBinContent(1) + cutflowhisto2.GetBinContent(1)), 3)
result.write('Overall Efficiency')
for j in range(3):
  result.write(',' + str(cuts[j]))
result.write('\n')
