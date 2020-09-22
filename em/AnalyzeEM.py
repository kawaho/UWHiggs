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
      myJet1, myJet2 = self.jetVec(row)[0], self.jetVec(row)[1]

      weight = self.corrFact(row, myEle, myMuon)[0]

      njets = row.jetVeto30WoNoisyJets
      mjj = row.vbfMassWoNoisyJets
      j1eta = row.j1etaWoNoisyJets 
      j2eta =  row.j2etaWoNoisyJets

      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
        continue

      if self.oppositesign(row):
        self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOS')
        if njets==1:
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOS1Jet')
        elif njets==2:
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOS2Jet')

  def finish(self):
    self.write_histos()
