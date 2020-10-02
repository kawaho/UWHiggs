'''

Run LFV H->EM analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import EMTree

class AnalyzeEM(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEM, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myEle, myMuon)

      njets = row.jetVeto30WoNoisyJets
      mjj = row.vbfMassWoNoisyJets
      j1eta = row.j1etaWoNoisyJets 
      j2eta =  row.j2etaWoNoisyJets

      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
        continue

      if self.oppositesign(row):
        self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS')
        if abs(myMuon.Eta()) < 0.8 and abs(myEle.Eta()) < 1.5:
          self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOSEB-MB')
        elif abs(myMuon.Eta()) > 0.8 and abs(myEle.Eta()) < 1.5:
          self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOSEB-ME')
        elif abs(myEle.Eta()) > 1.5:
          self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOSEE')
        if njets==0:
          self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS0Jet')
          if abs(myMuon.Eta()) < 0.8 and abs(myEle.Eta()) < 1.5:
            self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS0JetEB-MB')
          elif abs(myMuon.Eta()) > 0.8 and abs(myEle.Eta()) < 1.5:
            self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS0JetEB-ME')
          elif abs(myEle.Eta()) > 1.5:
            self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS0JetEE')
        elif njets==1:
          self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS1Jet')
          if abs(myMuon.Eta()) < 0.8 and abs(myEle.Eta()) < 1.5:
            self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS1JetEB-MB')
          elif abs(myMuon.Eta()) > 0.8 and abs(myEle.Eta()) < 1.5:
            self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS1JetEB-ME')
          elif abs(myEle.Eta()) > 1.5:
            self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS1JetEE')
        elif njets==2:
          self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS2Jet')
          if mjj < 500:
            self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS2JetGG')
            if abs(myMuon.Eta()) < 0.8 and abs(myEle.Eta()) < 1.5:
              self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS2JetGGEB-MB')
            elif abs(myMuon.Eta()) > 0.8 and abs(myEle.Eta()) < 1.5:
              self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS2JetGGEB-ME')
            elif abs(myEle.Eta()) > 1.5:
              self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS2JetGGEE')
          elif mjj > 500:
            self.fill_histos(myEle, myMuon, myMET, j1eta, j2eta, mjj, weight, 'TightOS2JetVBF')

  def finish(self):
    self.write_histos()
