'''

Run LFV H->EM analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import EMTree
import ROOT
import math
import array

class AnalyzeEMValid2(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMValid2, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)

  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]
      myJet1, myJet2 = self.jetVec(row)[0], self.jetVec(row)[1]
      njets = row.jetVeto30
      mjj = row.vbfMass

      weight = self.corrFact(row, myEle, myMuon)[0]
      osss = self.corrFact(row, myEle, myMuon)[1]

      if math.isnan(row.vbfMassWoNoisyJets):
        continue
     
      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
       continue

      if self.visibleMass(myEle, myMuon) < 130 and self.visibleMass(myEle, myMuon) > 120 and self.is_data:
       continue

      if self.oppositesign(row):
        self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOS')
        if njets==2 and mjj>400 :
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSvbf')
        else:
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOSgg')
      else:
        self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*osss, 'TightSS')
        if njets==2 and mjj>400 :
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*osss, 'TightSSvbf')
        else:
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*osss, 'TightSSgg')
  def finish(self):
     self.write_histos()  
