'''

Run LFV H->MuTau analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuTauBase import MuTauBase
import MuTauTree
import ROOT
import math

class AnalyzeMuTauTT(MegaBase, MuTauBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuTauWJets, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile 
    MuTauBase.__init__(self)
 
  def fill_histos_gen(self, row, myMuon, myMET, myTau, weight, name):
    njets = row.jetVeto30
    mjj = row.vbfMass 
    if self.oppositesign(row):
      self.fill_histos(row, myMuon, myMET, myTau, weight, name)
      if njets==0:
        self.fill_histos(row, myMuon, myMET, myTau, weight, name+'0Jet')
      elif njets==1:
        self.fill_histos(row, myMuon, myMET, myTau, weight, name+'1Jet')
      elif njets==2 and mjj < 550:
        self.fill_histos(row, myMuon, myMET, myTau, weight, name+'2Jet')
      elif njets==2 and mjj > 550:
        self.fill_histos(row, myMuon, myMET, myTau, weight, name+'2JetVBF')
 
   def process(self):

    for row in self.tree:
        
      if not self.eventSel(row):
        continue

      njets = row.jetVeto30
      nbtag = row.bjetDeepCSVVeto20Medium_2016_DR0p5
      if nbtag!=njets:
        continue
      if nbtag > 2:
        continue
      myMuon, myMET, myTau = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]
      weight = self.corrFact(row, myMuon, myTau)

      if bool(self.is_mc):
        if nbtag==0:
          btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 0)
          weight = weight * btagweight
        elif nbtag==1:
          btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 1)
          weight = weight * btagweight
        elif nbtag==2:
          btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 2)
          weight = weight * btagweight
      if nbtag < 1:
        weight = 0

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        weight = weight*frTau
        self.fill_histos_gen(row, myMuon, myMET, myTau, weight, 'TauLooseWOS')

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frMuon = self.fakeRateMuon(myMuon.Pt())
        weight = weight*frMuon
        self.fill_histos_gen(row, myMuon, myMET, myTau, weight, 'MuonLooseWOS')

      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frMuon = self.fakeRateMuon(myMuon.Pt())
        weight = weight*frMuon*frTau
        self.fill_histos_gen(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseWOS')

      if self.obj2_tight(row) and self.obj1_tight(row):
        self.fill_histos_gen(row, myMuon, myMET, myTau, weight, 'TightWOS')

  def finish(self):
    self.write_histos()
    
