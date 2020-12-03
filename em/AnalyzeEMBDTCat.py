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
#        if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf00')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg00')
#        if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf10')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg10')
#        if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>3:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf20')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg20')
#        if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>3.5:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf30')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg30')
#        if njets==2 and mjj>450 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf01')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg01')
#        if njets==2 and mjj>450 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf11')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg11')
#        if njets==2 and mjj>450 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>3:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf21')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg21')
#        if njets==2 and mjj>450 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>3.5:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf31')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg31')
#        if njets==2 and mjj>500 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf02')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg02')
#        if njets==2 and mjj>500 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf12')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg12')
#        if njets==2 and mjj>500 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>3:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf22')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg22')
#        if njets==2 and mjj>500 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>3.5:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf32')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg32')
#        if njets==2 and mjj>550 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf03')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg03')
#        if njets==2 and mjj>550 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf13')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg13')
#        if njets==2 and mjj>550 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>3:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf23')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg23')
#        if njets==2 and mjj>550 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>3.5:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf33')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg33')
#        if njets==2 and mjj>600 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf04')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg04')
#        if njets==2 and mjj>600 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf14')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg14')
#        if njets==2 and mjj>600 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>3:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf24')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg24')
#        if njets==2 and mjj>600 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>3.5:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf34')
#        else:
#          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg34')

        self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOS')
        if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf')
        else:
          if njets == 0:
            mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, row.e_m_PZeta))
          else:
            mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, row.e_m_PZeta))
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg')
          if mva < 0.0245:
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSggcat0')
              
          elif mva < 0.0925:
            if abs(myEle.Eta()) < 1.48 and abs(myMuon.Eta()) < 0.8:
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSggcat1_B')
            else:
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSggcat1_EC')

          elif mva < 0.1465:
            if abs(myEle.Eta()) < 1.48 and abs(myMuon.Eta()) < 0.8:
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSggcat2_B')
            else:
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSggcat2_EC')
          else:
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSggcat3')

  def finish(self):
    self.write_histos()
