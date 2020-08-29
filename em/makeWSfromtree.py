import ROOT

workspace = ROOT.RooWorkspace("CMS_emu_workspace")
mass = ROOT.RooRealVar("CMS_emu_Mass", "M_{e#mu}", 125, 110, 160)
mass.setUnit("GeV/c^{2}")
set = ROOT.RooArgSet("set")
set.add(mass)

gcs = []
datasets = {}
ncats = 10

#histname = 'Data_13TeV_1'
#dataset1 = ROOT.RooDataSet(histname, histname, set)

for cat in range(ncats):
  histname = 'Data_13TeV_%i'%(cat+1)
  datasets[histname] = ROOT.RooDataSet(histname, histname, set)

file = ROOT.TFile('datatree.root')
tree = file.Get('opttree')

#mass.setVal(125)
#dataset1.add(set, 10)

for row in tree:
  mass.setVal(row.e_m_Mass)
  histname = 'Data_13TeV_' + str(row.cat)
  if row.weight != 0:
    datasets[histname].add(set, row.weight)


getattr(workspace,'import')(mass)

lumi = ROOT.RooConstVar("Lumi", "Integrated luminosity", 41859.515)
sqrts = ROOT.RooConstVar("SqrtS","Center of Mass Energy", 13)

getattr(workspace,'import')(lumi, ROOT.RooFit.RecycleConflictNodes())
getattr(workspace,'import')(sqrts, ROOT.RooFit.RecycleConflictNodes())

for data in datasets.values():
  getattr(workspace,'import')(data)

workspace.writeToFile("trial.root")
