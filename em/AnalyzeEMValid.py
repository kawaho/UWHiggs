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

class AnalyzeEMValid(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMValid, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)


  def begin(self):
    for n in self.bdtnames:
      self.book(n, 'bdtDiscriminator', 'BDT Discriminator', 200, -1.0, 1.0)
      self.book(n, 'bdtDiscriminator_scaledBkg', 'BDT Discriminator_scaledBkg', 200, 0, 3)
      self.book(n, 'bdtDiscriminator_scaledSig', 'BDT Discriminator_scaledSig', 200, 0, 3)

  def fill_histos(self, myEle, myMuon, myMET, myJet1, myJet2, njets, e_m_PZeta, weight, name=''):
    histos = self.histograms
    if njets == 0:
      mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta))
    elif njets == 1:
      mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta))
    else:
      mva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)
    histos[name+'/bdtDiscriminator_scaledBkg'].Fill(math.atanh((1-mva)/2), weight)
    histos[name+'/bdtDiscriminator_scaledSig'].Fill(math.atanh((1+mva)/2), weight)

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

      if math.isnan(row.vbfMass):
        continue
     
      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
       continue

      if self.visibleMass(myEle, myMuon) < 130 and self.visibleMass(myEle, myMuon) > 120:
       continue

      if self.oppositesign(row):
        if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
          continue
        else:
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, row.e_m_PZeta, weight, 'TightOSgg')
      else:
        if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
          continue
        else:
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, row.e_m_PZeta, weight*osss, 'TightSSgg')
  def finish(self):
     self.write_histos()  
