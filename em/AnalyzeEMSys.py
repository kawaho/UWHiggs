'''

Run LFV H->EM analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import EMTree
import mcCorrections
import os
import EMTree
import ROOT
import math
import array
import itertools
from FinalStateAnalysis.TagAndProbe.bTagSF2017 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeEMSys(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMSys, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)

  def begin(self):
    folder = []
    for tuple_path in itertools.product(self.catnames, self.sys):
      folder.append(os.path.join(*tuple_path))
    for tuple_path_jes in itertools.product(self.catnames, self.jes):
      folder.append(os.path.join(*tuple_path_jes))
    for tuple_path_ues in itertools.product(self.catnames, self.ues):
      folder.append(os.path.join(*tuple_path_ues))
    for f in folder:
      if 'year' in f or 'Ues' in f or 'Unclustered' in f or 'RelativeSample' in f or 'JER' in f:
        self.book(f+'2016', 'e_m_Mass', 'Electron + Muon Mass', 5000, 110, 160)
        self.book(f+'2017', 'e_m_Mass', 'Electron + Muon Mass', 5000, 110, 160)
        self.book(f+'2018', 'e_m_Mass', 'Electron + Muon Mass', 5000, 110, 160)
      else:
        self.book(f, 'e_m_Mass', 'Electron + Muon Mass', 5000, 110, 160)

  def fill_histos(self, myEle, myMuon, weight, name=''):
    histos = self.histograms
    histos[name+'/e_m_Mass'].Fill(self.visibleMass(myEle, myMuon), weight)

  def fill_categories(self, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, name=''):
    self.fill_histos(myEle, myMuon, weight, 'TightOS'+name)
    if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
      self.fill_histos(myEle, myMuon, weight, 'TightOSvbf'+name)
    else:
      if njets == 0:
        mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta, mjj))
      elif njets == 1:
        mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta, mjj))
      else:
        mva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta, mjj))
      self.fill_histos(myEle, myMuon, weight, 'TightOSgg'+name)
      if mva < 0.0175:
        self.fill_histos(myEle, myMuon, weight, 'TightOSggcat0'+name)
      elif mva < 0.0975:
        self.fill_histos(myEle, myMuon, weight, 'TightOSggcat1'+name)
      elif mva < 0.1305:
        self.fill_histos(myEle, myMuon, weight, 'TightOSggcat2'+name)
      elif mva < 0.1635:
        self.fill_histos(myEle, myMuon, weight, 'TightOSggcat3'+name)
      else:
        self.fill_histos(myEle, myMuon, weight, 'TightOSggcat4'+name)

  def fill_sys(self, row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight):    

    tmpEle = ROOT.TLorentzVector()
    tmpMuon = ROOT.TLorentzVector()
    tmpMET = ROOT.TLorentzVector()

    if self.is_mc:
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '')

      #electron energy scale
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle = myEle * ROOT.Double(row.eEnergyScaleUp/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(tmpEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/eesUp')

      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle = myEle * ROOT.Double(row.eEnergyScaleDown/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(tmpEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/eesDown')
  
      #muon energy scale + reso
      mcSFerror = self.rc.kSpreadMCerror(row.mCharge, row.mPt, row.mEta, row.mPhi, row.mGenPt)

      myMETpx = myMET.Px() + myMuon.Px()
      myMETpy = myMET.Py() + myMuon.Py()
      tmpMuon = myMuon * (1 + mcSFerror)
      myMETpx = myMETpx - tmpMuon.Px()
      myMETpy = myMETpy - tmpMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(myEle, tmpMuon, tmpMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, '/meUp') 

      myMETpx = myMET.Px() + myMuon.Px()
      myMETpy = myMET.Py() + myMuon.Py()
      tmpMuon = myMuon * (1 - mcSFerror)
      myMETpx = myMETpx - tmpMuon.Px()
      myMETpy = myMETpy - tmpMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(myEle, tmpMuon, tmpMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, '/meDown')

      #electron energy reso
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle = myEle * ROOT.Double(row.eEnergySigmaUp/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(tmpEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, '/eerUp') 

      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle = myEle * ROOT.Double(row.eEnergySigmaDown/row.eCorrectedEt)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(tmpEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, '/eerDown')

      #PU
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/puUp2018')
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/puDown2018')
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/puUp2016')
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/puDown2016')
      puweightUp = pucorrector['puUp'](row.nTruePU)
      puweightDown = pucorrector['puDown'](row.nTruePU)
      puweight = pucorrector[''](row.nTruePU)
      if puweight==0:
        self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, 0, '/puUp2017')
        self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, 0, '/puDown2017')
      else:
        self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*puweightUp/puweight, '/puUp2017')
        self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*puweightDown/puweight, '/puDown2017')
  
      #bTag
      nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/bTagUp2018')
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/bTagDown2018')
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/bTagUp2016')
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/bTagDown2016')
      if nbtag > 2:
        nbtag = 2
      if nbtag==0:
        self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/bTagUp2017')
        self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/bTagDown2017')
      if nbtag > 0:
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 0, 0)
        btagweightup = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 1, 0)
        btagweightdown = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, -1, 0)
        self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*btagweightup/btagweight, '/bTagUp2017')
        self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*btagweightdown/btagweight, '/bTagDown2017')
  
      #pre-firing
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/pfUp2016')
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/pfDown2016')
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*row.prefiring_weight_up/row.prefiring_weight, '/pfUp2017')
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*row.prefiring_weight_down/row.prefiring_weight, '/pfDown2017')
  

      #jes+ues
      if not (self.is_recoilC and self.MetCorrection):
        for u in self.ues:
          tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+u), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+u), 0)
          self.fill_categories(myEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/'+u+"2017")
          self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/'+u+"2016")
          self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/'+u+"2018")
        for j in self.jes:
          tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
          if 'JetRelativeBal' in j:
            tmpnjets = getattr(row, 'jetVeto30WoNoisyJets_'+j+'WoNoisyJets')
          else:  
            tmpnjets = getattr(row, 'jetVeto30WoNoisyJets_'+j)
          tmpmjj = getattr(row, 'vbfMassWoNoisyJets_'+j)
          tmpJet1 = ROOT.TLorentzVector()
          tmpJet1.SetPtEtaPhiM(getattr(row, 'j1ptWoNoisyJets_'+j), getattr(row, 'j1etaWoNoisyJets_'+j), getattr(row, 'j1phiWoNoisyJets_'+j), 0)
          tmpJet2 = ROOT.TLorentzVector()
          tmpJet2.SetPtEtaPhiM(getattr(row, 'j2ptWoNoisyJets_'+j), getattr(row, 'j2etaWoNoisyJets_'+j), getattr(row, 'j2phiWoNoisyJets_'+j), 0)   
          if 'year' in j or 'RelativeSample' in j or 'JER' in j:  
            self.fill_categories(myEle, myMuon, tmpMET, tmpJet1, tmpJet2, tmpnjets, tmpmjj, row.e_m_PZeta, weight, '/'+j+"2017")
            self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/'+j+"2016")
            self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, '/'+j+"2018")
          else:
            self.fill_categories(myEle, myMuon, tmpMET, tmpJet1, tmpJet2, tmpnjets, tmpmjj, row.e_m_PZeta, weight, '/'+j)
            
  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]
      myJet1, myJet2 = self.jetVec(row)[0], self.jetVec(row)[1]

      weight = self.corrFact(row, myEle, myMuon)[0]

      njets = row.jetVeto30WoNoisyJets
      mjj = row.vbfMassWoNoisyJets

      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
        continue

      if self.oppositesign(row):
        self.fill_sys(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight)

  def finish(self):
    self.write_histos()
