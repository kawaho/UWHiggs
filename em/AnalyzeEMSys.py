'''

Run LFV H->EM analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import EMTree
import ROOT
import math

class AnalyzeEMSys(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMSys, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)

  def eval_mva(self, njets, myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta):
    if njets == 0:
      return self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta))
    elif njets == 1:
       return self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta))
    else:
       return  self.functor_gg(**self.var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta))
    

  def fill_categories(self, mva, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, name=''):
    if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
      self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, 'TightOSvbf'+name)
    else:
      self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, 'TightOSgg'+name)
      if mva < 0.085:
        self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, 'TightOSggcat0'+name)
      elif mva < 0.125:
        self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, 'TightOSggcat1'+name)
      else:
        self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, 'TightOSggcat2'+name)

  def fill_SysNames(self, mva, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, sysNames):
    for s in sysNames:
      self.fill_categories(mva, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, s)

  def fill_sys(self, row, myEle, myMuon, myMET, myJet1, myJet2, weight):

    njets = row.jetVeto30
    mjj = row.vbfMass
    e_m_PZeta = row.e_m_PZeta

    if self.is_mc:
      mva = self.eval_mva(njets, myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta)

      self.fill_categories(mva, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, '')

      tmpEle = ROOT.TLorentzVector()
      tmpMuon = ROOT.TLorentzVector()
 
      tmpMET = ROOT.TLorentzVector()
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle = myEle * ROOT.Double(row.eEnergyScaleUp/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(mva, tmpEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, '/eesUp')
  
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle = myEle * ROOT.Double(row.eEnergyScaleDown/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(mva, tmpEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, '/eesDown')
  
      me = self.MESSys(myMuon.Eta())[0]
      mes = self.MESSys(myMuon.Eta())[1]
      myMETpx = myMET.Px() - me * myMuon.Px()
      myMETpy = myMET.Py() - me * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(1.000 + me)
      self.fill_categories(mva, myEle, tmpMuon, tmpMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, mes[0])
  
      myMETpx = myMET.Px() + me * myMuon.Px()
      myMETpy = myMET.Py() + me * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(1.000 - me)
      self.fill_categories(mva, myEle, tmpMuon, tmpMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, mes[1])
  
      mSys = [x for x in self.mesSys if x not in mes]
      self.fill_SysNames(mva, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, mSys)

  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]
      myJet1, myJet2 = self.jetVec(row)[0], self.jetVec(row)[1]

      weight = self.corrFact(row, myEle, myMuon)[0]


      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
        continue

      if self.oppositesign(row):
        self.fill_sys(row, myEle, myMuon, myMET, myJet1, myJet2, weight)

  def finish(self):
    self.write_histos()
