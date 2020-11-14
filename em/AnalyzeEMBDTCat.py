'''

Run LFV H->EM analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import EMTree

class AnalyzeEMBDTCat(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMBDTCat, self).__init__(tree, outfile, **kwargs)
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

      njets = row.jetVeto30
      mjj = row.vbfMass

      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
        continue

      if self.oppositesign(row):
        self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOS')
        if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf')
        else:
          if njets == 0:
            mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, row.e_m_PZeta))
          else:
            mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, row.e_m_PZeta))
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg')
          if mva < 0.075:
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSggcat0')
          elif mva < 0.125:
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSggcat1')
          elif mva < 0.165:
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSggcat2')
          else:
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSggcat3')

  def finish(self):
    self.write_histos()
