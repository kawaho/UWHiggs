'''

Run LFV H->EMu analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import EMTree
import itertools
import os
import ROOT

class AnalyzeEMLHE(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMLHE, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)


  def begin(self):
    folder = []
    for tuple_path in itertools.product(self.catnames, self.lhe):
      folder.append(os.path.join(*tuple_path))
    for f in folder:
      self.book(f, "e_m_VisibleMass", "Ele + Muon Visible Mass", 50, 110, 160)
#      self.book(f, "e_m_GenVisibleMass", "Ele + Muon Gen Visible Mass", 50, 110, 160)


  def fill_histos(self, row, myEle, myMuon, weight, name=''):
    histos = self.histograms
    for i in range(120):
      lheweight = getattr(row, 'lheweight' + str(i))
      histos[name+'/lhe'+str(i)+'/e_m_VisibleMass'].Fill((myEle+myMuon).M(), weight*lheweight)
#      genMuon = ROOT.TLorentzVector()
#      genMuon.SetPtEtaPhiM(row.mGenPt, row.mGenEta, row.mGenPhi, row.mMass)
#      genEle = ROOT.TLorentzVector()
#      genEle.SetPtEtaPhiM(row.eGenPt, row.eGenEta, row.eGenPhi, row.eMass)
#      histos[name+'/lhe'+str(i)+'_2016/e_m_GenVisibleMass'].Fill((genEle+genMuon).M(), weight*lheweight)
#      histos[name+'/lhe'+str(i)+'_2017/e_m_GenVisibleMass'].Fill((genEle+genMuon).M(), weight)
#      histos[name+'/lhe'+str(i)+'_2018/e_m_GenVisibleMass'].Fill((genEle+genMuon).M(), weight)


  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]
      myJet1, myJet2 = self.jetVec(row)[0], self.jetVec(row)[1]

      weight = self.corrFact(row, myMuon, myEle)[0]

      njets, mjj = row.jetVeto30, row.vbfMass

      if self.oppositesign(row):
        self.fill_histos(row, myEle, myMuon, weight, 'TightOS')
        if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
          self.fill_histos(row, myEle, myMuon, weight, 'TightOSvbf')
        else:
          if njets == 0:
            mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, row.e_m_PZeta, mjj))
          elif njets == 1:
            mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, row.e_m_PZeta, mjj))
          else:
            mva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, row.e_m_PZeta, mjj))
          if mva < 0.0255:
            self.fill_histos(row, myEle, myMuon, weight, 'TightOSggcat0')
          elif mva < 0.0975:
            self.fill_histos(row, myEle, myMuon, weight, 'TightOSggcat1')
          elif mva < 0.1245:
            self.fill_histos(row, myEle, myMuon, weight, 'TightOSggcat2')
          elif mva < 0.1545:
            self.fill_histos(row, myEle, myMuon, weight, 'TightOSggcat3')
          else:
            self.fill_histos(row, myEle, myMuon, weight, 'TightOSggcat4')

  def finish(self):
    self.write_histos()
