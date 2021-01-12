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

class AnalyzeEMDB(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMDB, self).__init__(tree, outfile, **kwargs)
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
     
      if self.visibleMass(myEle, myMuon) > 100: # or myEle.Pt() > 80 or myMuon.Pt() > 80 or 
        continue

      if self.oppositesign(row):
        self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 'TightOS')
      else:
        self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*osss, 'TightSS')
  def finish(self):
     self.write_histos()  
