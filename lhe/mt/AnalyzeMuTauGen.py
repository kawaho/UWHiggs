'''

Run LFV H->MuTau analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuTauBase import MuTauBase
import MuTauTree
import itertools
import os
import ROOT

class AnalyzeMuTauGen(MegaBase, MuTauBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuTauGen, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    MuTauBase.__init__(self)


  def begin(self):
    for f in self.gennames:
      self.book(f, "m_t_VisibleMass", "Ele + Muon Visible Mass", 60, 0, 300)


  def fill_histos(self, myMuon, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/m_t_VisibleMass'].Fill(self.visibleMass(myMuon, myTau), weight)

  def process(self):

    for row in self.tree:
      
      if row.tCharge*row.mCharge!=-1:
        continue

      weight = row.GenWeight*self.pucorrector[''](row.nTruePU)
 
      njets, mjj = row.jetVeto30, row.vbfMass

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tGenPt, row.tGenEta, row.tGenPhi, row.tMass)

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mGenPt, row.mGenEta, row.mGenPhi, row.mMass)

      self.fill_histos(myMuon, myTau, weight, 'TightOSAll')
      if njets==0:
        self.fill_histos(myMuon, myTau, weight, 'TightOS0JetAll')
      elif njets==1:
        self.fill_histos(myMuon, myTau, weight, 'TightOS1JetAll')
      elif njets==2 and mjj < 500:
        self.fill_histos(myMuon, myTau, weight, 'TightOS2JetAll')
      elif njets==2 and mjj > 500:
        self.fill_histos(myMuon, myTau, weight, 'TightOS2JetVBFAll')

      if row.tGenPt < 30 or abs(row.tGenEta) >= 2.3:
        continue

      if row.mGenPt < 26 or abs(row.mGenEta) >= 2.1:
        continue

      if self.deltaR(row.tGenPhi, row.mGenPhi, row.tGenEta, row.mGenEta) < 0.5:
        continue

      self.fill_histos(myMuon, myTau, weight, 'TightOS')
      if njets==0:
        self.fill_histos(myMuon, myTau, weight, 'TightOS0Jet')
      elif njets==1:
        self.fill_histos(myMuon, myTau, weight, 'TightOS1Jet')
      elif njets==2 and mjj < 500:
        self.fill_histos(myMuon, myTau, weight, 'TightOS2Jet')
      elif njets==2 and mjj > 500:
        self.fill_histos(myMuon, myTau, weight, 'TightOS2JetVBF')


  def finish(self):
    self.write_histos()
