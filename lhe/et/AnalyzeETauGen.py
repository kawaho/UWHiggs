'''

Run LFV H->EMu analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from ETauBase import ETauBase
import ETauTree
import itertools
import os
import ROOT

class AnalyzeETauGen(MegaBase, ETauBase):
  tree = 'et/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeETauGen, self).__init__(tree, outfile, **kwargs)
    self.tree = ETauTree.ETauTree(tree)
    self.out = outfile
    ETauBase.__init__(self)


  def begin(self):
    for f in self.gennames:
      self.book(f, "e_t_VisibleMass", "Ele + Tau Visible Mass", 60, 0, 300)


  def fill_histos(self, myEle, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/e_t_VisibleMass'].Fill(self.visibleMass(myEle, myTau), weight)

  def process(self):

    for row in self.tree:
      
      if row.eCharge*row.tCharge!=-1:
        continue

      weight = row.GenWeight*self.pucorrector[''](row.nTruePU)
 
      njets, mjj = row.jetVeto30, row.vbfMass

      myEle = ROOT.TLorentzVector()
      myEle.SetPtEtaPhiM(row.eGenPt, row.eGenEta, row.eGenPhi, row.eMass)

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tGenPt, row.tGenEta, row.tGenPhi, row.tMass)

      self.fill_histos(myEle, myTau, weight, 'TightOSAll')
      if njets==0:
        self.fill_histos(myEle, myTau, weight, 'TightOS0JetAll')
      elif njets==1:
        self.fill_histos(myEle, myTau, weight, 'TightOS1JetAll')
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myTau, weight, 'TightOS2JetAll')
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myTau, weight, 'TightOS2JetVBFAll')

      if row.eGenPt < 25 or abs(row.eGenEta) >= 2.1:
        continue

      if row.tGenPt < 30 or abs(row.tGenEta) >= 2.3:
        continue

      if self.deltaR(row.eGenPhi, row.tGenPhi, row.eGenEta, row.tGenEta) < 0.5:
        continue

      self.fill_histos(myEle, myTau, weight, 'TightOS')
      if njets==0:
        self.fill_histos(myEle, myTau, weight, 'TightOS0Jet')
      elif njets==1:
        self.fill_histos(myEle, myTau, weight, 'TightOS1Jet')
      elif njets==2 and mjj < 500:
        self.fill_histos(myEle, myTau, weight, 'TightOS2Jet')
      elif njets==2 and mjj > 500:
        self.fill_histos(myEle, myTau, weight, 'TightOS2JetVBF')


  def finish(self):
    self.write_histos()
