from ROOT import TFile, gROOT, TF1
import glob

#names = ['GluGlu_LFV*root', 'VBF_LFV*root']

names = ['DataEstimatedBkg.root']

#names = ['TotalBkg.root', 'Diboson.root', 'TTbar.root', 'SingleT.root', 'Embedded.root']

#cut_flow_step = ['allEvents', 'passFilters', 'passOppSign', 'passTrigger', 'passKinematics', 'passDeltaR', 'passNjets', 'passVetoes', 'passbjetVeto', 'passObj1id', 'passObj2id', 'passtDecayMode', 'passdimuonVeto', 'passObj1tight', 'passObj2tight']

cut_flow_step = ['allEvents', 'passFilters', 'passOppSign', 'passTrigger', 'passKinematics', 'passDeltaR', 'passNjets', 'passVetoes', 'passbjetVeto', 'passObj1id', 'passObj2id', 'passtDecayMode', 'passdieleVeto', 'passObj2looseANDnottight']

eff = ['Filter', 'OppSign', 'Trigger', 'Kinematics', 'DeltaR', 'NJets', 'Vetoes', 'bjestVeto', 'Obj1 ID', 'Obj2 ID', 'tDecayMode', 'dimuonVeto', 'Obj2 loose + not tight', 'Overall Cut']

cmsbase = '/afs/hep.wisc.edu/home/kaho/CMSSW_10_2_16_UL/src/'

years = [cmsbase + 'UWHiggs2016/lhe2016/mt/results/MCLHE2016_NEW/AnalyzeMuTauCF/', cmsbase + 'UWHiggs2017/lhe/mt/results/MCLHE/AnalyzeMuTauCF/', 'results/MCLHE2018/AnalyzeMuTauCF/']

result = open("DataEstimatedBkgCF_MT.csv", "w")

for n in names:
  cuts = []
  result.write(n.replace('.root', '') + ',2016,2017,2018\n')
  for j, y in enumerate(years):
    files = []
    cuts.append([])
    files.extend(glob.glob(y + n))
    MuTaufile = TFile(files[0])
    cutflowhisto = MuTaufile.Get('./CUT_FLOW')
    max1 = cutflowhisto.GetNbinsX()
    for i, name in enumerate(cut_flow_step): 
      if i == 0:
        cuts[j].append(0)
      else:
        cuts[j].append(round (cutflowhisto.GetBinContent(i+1)/cutflowhisto.GetBinContent(i), 3))
    cuts[j].append(round (cutflowhisto.GetBinContent(max1)/cutflowhisto.GetBinContent(1), 3))
  for i, name in enumerate(eff):
    result.write(name + ' Efficiency')
    for j in range(3):
      result.write(',' + str(cuts[j][i+1]))
    result.write('\n')
  result.write('\n')
