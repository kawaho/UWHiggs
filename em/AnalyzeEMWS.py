'

Run LFV H->EM analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import EMTree
import ROOT

class AnalyzeEMWS(MegaBase, EMBase):
  tree = 'em/final/Ntuple'
  weightVar = ROOT.RooRealVar("weight","weight",1)
  datasets = {}
  ncats = 10

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMWS, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)
 
    self.mass = ROOT.RooRealVar("CMS_emu_mass", "m_{e#mu}", 125, 110, 160)
    self.mass.setUnit("GeV/c^{2}")
    self.set = ROOT.RooArgSet("set")
    self.set.add(self.mass)

    for cat in range(self.ncats):
      histname = 'Data_13TeV_%i'%cat
      self.datasets[histname] = ROOT.RooDataSet(histname, histname, self.set) #massWithWeight, self.weightVar.GetName())


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
        continue

      weight = self.corrFact(row, myEle, myMuon)
      njets = row.jetVeto30WoNoisyJets
      mjj = row.vbfMassWoNoisyJets

      self.weightVar.setVal(weight)
      self.mass.setVal(self.visibleMass(myEle, myMuon))

      if self.oppositesign(row):
        if njets==0:
          if abs(myMuon.Eta()) < 0.8 and abs(myEle.Eta()) < 1.5:
            self.datasets['Data_13TeV_0'].add(self.set, weight)
          elif abs(myMuon.Eta()) > 0.8 and abs(myEle.Eta()) < 1.5:
            self.datasets['Data_13TeV_1'].add(self.set, weight)
          elif abs(myEle.Eta()) > 1.5:
            self.datasets['Data_13TeV_2'].add(self.set, weight)
        elif njets==1:
          if abs(myMuon.Eta()) < 0.8 and abs(myEle.Eta()) < 1.5:
            self.datasets['Data_13TeV_3'].add(self.set, weight)
          elif abs(myMuon.Eta()) > 0.8 and abs(myEle.Eta()) < 1.5:
            self.datasets['Data_13TeV_4'].add(self.set, weight)
          elif abs(myEle.Eta()) > 1.5:
            self.datasets['Data_13TeV_5'].add(self.set, weight)
        elif njets==2 and mjj < 500:
          if abs(myMuon.Eta()) < 0.8 and abs(myEle.Eta()) < 1.5:
            self.datasets['Data_13TeV_6'].add(self.set, weight)
          elif abs(myMuon.Eta()) > 0.8 and abs(myEle.Eta()) < 1.5:
            self.datasets['Data_13TeV_7'].add(self.set, weight)
          elif abs(myEle.Eta()) > 1.5:
            self.datasets['Data_13TeV_8'].add(self.set, weight)
          elif mjj > 500:
            self.datasets['Data_13TeV_9'].add(self.set, weight)
    
  def finish(self):
    self.imp(self.mass)
    lumi = ROOT.RooConstVar("Lumi", "Integrated luminosity", 41859.515)
    sqrts = ROOT.RooConstVar("SqrtS","Center of Mass Energy", 13)
    self.imp(lumi, True)
    self.imp(sqrts, True)
    for data in self.datasets.values():
      self.imp(data)
#      data.Print('v')
    self.workspace.writeToFile("ws_emu_data.root")
    self.write_histos()
