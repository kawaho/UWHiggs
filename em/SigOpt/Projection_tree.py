import ROOT
import numpy as np
import array

fFileS = [ROOT.TFile("2016/signal.root"), ROOT.TFile("2017/signal.root"), ROOT.TFile("2018/signal.root")]
fFileTree = [ROOT.TFile("2016/data_tree.root"), ROOT.TFile("2017/data_tree.root"), ROOT.TFile("2018/data_tree.root")]
tree = [fFileTree[0].Get("opttree"), fFileTree[1].Get("opttree"), fFileTree[2].Get("opttree")]
n = 100
xq = np.empty(n)
yq = np.empty(n)
for i in range(n):
  xq[i] = (i+1)/float(n)
hmvaS = [fFileS[0].Get("TightOSgg/MVA"), fFileS[1].Get("TightOSgg/MVA"), fFileS[2].Get("TightOSgg/MVA")]
SigStep = [[0],[0],[0]]
for i in range(3):
  hmvaS[i].GetQuantiles(n,yq,xq)
  for j in range(n):
    SigStep[i].append(hmvaS[i].FindBin(yq[j]))

mass = ROOT.RooRealVar("CMS_emu_Mass", "m_{e#mu}", 125, 110, 160, "GeV")
datasets = []
for i in range(n):
  datasets.append(ROOT.RooDataSet("Data_13TeV_range%i"%i, "Data_13TeV_range%i"%i, ROOT.RooArgSet(mass)))
for i in range(3):  
  nEntries = tree[i].GetEntries()
  for j in range(len(SigStep[i])-1):
    mval = (SigStep[i][j])*2./2000 - 1
    mvah = SigStep[i][j+1]*2./2000 - 1
    for k in range(nEntries):
      tree[i].GetEntry(k)
      if tree[i].mva < mvah and mval <= tree[i].mva: 
        mass.setVal(tree[i].e_m_Mass)
        datasets[j].add(ROOT.RooArgSet(mass), tree[i].weight)

w = ROOT.RooWorkspace("CMS_emu_workspace", "CMS_emu_workspace")
for dataset in datasets:
  getattr(w, 'import')(dataset)
w.Print()
w.writeToFile("dataws.root")
ROOT.gDirectory.Add(w)
