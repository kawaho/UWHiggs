'''

Run LFV H->EMu analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuEBase import MuEBase
import EMTree
import itertools
import os
import ROOT

class AnalyzeMuEGen(MegaBase, MuEBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuEGen, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    MuEBase.__init__(self)


  def begin(self):
    for f in self.gennames:
      self.book(f, "m_e_VisibleMass", "Ele + Muon Visible Mass", 60, 0, 300)


  def fill_histos(self, myEle, myMuon, weight, name=''):
    histos = self.histograms
    histos[name+'/m_e_VisibleMass'].Fill(self.visibleMass(myEle, myMuon), weight)

  def process(self):

    for row in self.tree:
      
      if row.eCharge*row.mCharge!=-1:
        continue

      weight = row.GenWeight*self.pucorrector[''](row.nTruePU)
 
      njets, mjj = row.jetVeto30, row.vbfMass

      myEle = ROOT.TLorentzVector()
      myEle.SetPtEtaPhiM(row.eGenPt, row.eGenEta, row.eGenPhi, row.eMass)

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mGenPt, row.mGenEta, row.mGenPhi, row.mMass)

      self.fill_histos(myEle, myMuon, weight, 'TightOSAll')
      if njets==0:
        self.fill_histos(myEle, myMuon, weight, 'TightOS0JetAll')
      elif njets==1:
        self.fill_histos(myEle, myMuon, weight, 'TightOS1JetAll')
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMuon, weight, 'TightOS2JetAll')
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myMuon, weight, 'TightOS2JetVBFAll')

      if row.eGenPt < 13 or abs(row.eGenEta) >= 2.5:
        continue

      if row.mGenPt < 24 or abs(row.mGenEta) >= 2.4:
        continue

      if self.deltaR(row.eGenPhi, row.mGenPhi, row.eGenEta, row.mGenEta) < 0.3:
        continue

      self.fill_histos(myEle, myMuon, weight, 'TightOS')
      if njets==0:
        self.fill_histos(myEle, myMuon, weight, 'TightOS0Jet')
      elif njets==1:
        self.fill_histos(myEle, myMuon, weight, 'TightOS1Jet')
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myMuon, weight, 'TightOS2Jet')
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myMuon, weight, 'TightOS2JetVBF')


  def finish(self):
    self.write_histos()
