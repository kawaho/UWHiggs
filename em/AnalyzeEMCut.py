'''

Run LFV H->EM analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import EMTree

class AnalyzeEMCut(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMCut, self).__init__(tree, outfile, **kwargs)
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
#        self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS')
#        if myMuon.Eta() < 0.8 and myEle.Eta() < 1.5:
#          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOSEB-MB')
#        elif myMuon.Eta() > 0.8 and myEle.Eta() < 1.5:
#          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOSEB-ME')
#        elif myMuon.Eta() < 0.8 and myEle.Eta() > 1.5:
#          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOSEE-MB')
#        elif myMuon.Eta() > 0.8 and myEle.Eta() > 1.5:
#          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOSEE-ME')
        if njets==0:     
          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS0Jet')
          if self.cuts(row, '0'):
              self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS0JetEB-MB')
          elif self.cuts(row, '1'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS0JetEB-ME')
          elif self.cuts(row, '2'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS0JetEE-MB')
          elif self.cuts(row, '3'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS0JetEE-ME')
        elif njets==1:
          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS1Jet')
          if self.cuts(row, '4'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS1JetEB-MB')
          elif self.cuts(row, '5'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS1JetEB-ME')
          elif self.cuts(row, '6'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS1JetEE-MB')
          elif self.cuts(row, '7'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS1JetEE-ME')
        elif njets==2 and mjj < 500:
          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2Jet')
          if self.cuts(row, '8'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetEB-MB')
          elif self.cuts(row, '9'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetEB-ME')
          elif self.cuts(row, '10'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetEE-MB')
          elif self.cuts(row, '11'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetEE-ME')
        elif njets==2 and mjj > 500:
          self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetVBF')
          if self.cuts(row, '12'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetVBFEB-MB')
          elif self.cuts(row, '13'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetVBFEB-ME')
          elif self.cuts(row, '14'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetVBFEE-MB')
          elif self.cuts(row, '15'):
            self.fill_histos(myEle, myMuon, myMET, weight, 'TightOS2JetVBFEE-ME')

  def finish(self):
    self.write_histos()
