'''

Run LFV H->EM analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import EMTree
import mcCorrections
import ROOT
import math
import array
import os

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeEMYield(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMYield, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)

  def begin(self):
    self.book('TightOS', 'ePt', 'ePt', 40, 24, 200)
    self.book('TightOS', 'mPt', 'mPt', 40, 29, 200)
    self.book('TightOS', 'mEta', 'mEta', 50, -2.4, 2.4)
    self.book('TightOS', 'eEta', 'eEta', 50, -2.5, 2.5)
    self.book('TightOS', 'j1Pt', 'j1Pt', 47, 30, 500)
    self.book('TightOS', 'j2Pt', 'j2Pt', 34, 30, 200)
    self.book('TightOS', 'j2Eta', 'j2Eta', 50, -5, 5)
    self.book('TightOS', 'j1Eta', 'j1Eta', 50, -5, 5)

  def fill_histos(self, myEle, myMuon, myJet1, myJet2, njets, weight, name=''):
    histos = self.histograms
    histos[name+'/ePt'].Fill(myEle.Pt(), weight)
    histos[name+'/mPt'].Fill(myMuon.Pt(), weight)
    histos[name+'/eEta'].Fill(myEle.Eta(), weight)
    histos[name+'/mEta'].Fill(myMuon.Eta(), weight)
    if (njets>0):
      histos[name+'/j1Pt'].Fill(myJet1.Pt(), weight)
      histos[name+'/j1Eta'].Fill(myJet1.Eta(), weight)
    if (njets>1):
      histos[name+'/j2Pt'].Fill(myJet2.Pt(), weight)
      histos[name+'/j2Eta'].Fill(myJet2.Eta(), weight) 

  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      if math.isnan(row.vbfMassWoNoisyJets):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]
      myJet1, myJet2 = self.jetVec(row)[0], self.jetVec(row)[1]
      njets = row.jetVeto30WoNoisyJets
      mjj = row.vbfMassWoNoisyJets

      weight = self.corrFact(row, myEle, myMuon)[0]

      tEff_Iso = self.triggerEff27(myMuon.Pt(), abs(myMuon.Eta()))

      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
       continue

      if self.visibleMass(myEle, myMuon) < 135 and self.visibleMass(myEle, myMuon) > 115 and self.is_data:
       continue

      if self.oppositesign(row):
        if self.is_mc:
          self.fill_histos(myEle, myMuon, myJet1, myJet2, njets, weight*tEff_Iso, 'TightOS')
        else:
          self.fill_histos(myEle, myMuon, myJet1, myJet2, njets, weight, 'TightOS')

  def finish(self):
     self.write_histos()  
