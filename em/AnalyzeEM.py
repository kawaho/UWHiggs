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

      if self.oppositesign(row):
        self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS')
        if myMuon.Eta() < 0.8 and myEle.Eta() < 1.5:
          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOSEB-MB')
        elif myMuon.Eta() > 0.8 and myEle.Eta() < 1.5:
          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOSEB-ME')
        elif myMuon.Eta() < 0.8 and myEle.Eta() > 1.5:
          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOSEE-MB')
        elif myMuon.Eta() > 0.8 and myEle.Eta() > 1.5:
          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOSEE-ME')
        if njets==0:
          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS0Jet')
          if myMuon.Eta() < 0.8 and myEle.Eta() < 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS0JetEB-MB')
          elif myMuon.Eta() > 0.8 and myEle.Eta() < 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS0JetEB-ME')
          elif myMuon.Eta() < 0.8 and myEle.Eta() > 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS0JetEE-MB')
          elif myMuon.Eta() > 0.8 and myEle.Eta() > 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS0JetEE-ME')
        elif njets==1:
          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS1Jet')
          if myMuon.Eta() < 0.8 and myEle.Eta() < 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS1JetEB-MB')
          elif myMuon.Eta() > 0.8 and myEle.Eta() < 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS1JetEB-ME')
          elif myMuon.Eta() < 0.8 and myEle.Eta() > 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS1JetEE-MB')
          elif myMuon.Eta() > 0.8 and myEle.Eta() > 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS1JetEE-ME')
        elif njets==2 and mjj < 500:
          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2Jet')
          if myMuon.Eta() < 0.8 and myEle.Eta() < 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetEB-MB')
          elif myMuon.Eta() > 0.8 and myEle.Eta() < 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetEB-ME')
          elif myMuon.Eta() < 0.8 and myEle.Eta() > 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetEE-MB')
          elif myMuon.Eta() > 0.8 and myEle.Eta() > 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetEE-ME')
        elif njets==2 and mjj > 500:
          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetVBF')
          if myMuon.Eta() < 0.8 and myEle.Eta() < 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetVBFEB-MB')
          elif myMuon.Eta() > 0.8 and myEle.Eta() < 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetVBFEB-ME')
          elif myMuon.Eta() < 0.8 and myEle.Eta() > 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetVBFEE-MB')
          elif myMuon.Eta() > 0.8 and myEle.Eta() > 1.5:
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetVBFEE-ME')

  def finish(self):
    self.write_histos()
