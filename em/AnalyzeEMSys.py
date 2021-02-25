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
from FinalStateAnalysis.TagAndProbe.bTagSF2016 import bTagEventWeight
import numpy as np

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
    for tuple_path in itertools.product(self.bdtnames, self.sys):
      folder.append(os.path.join(*tuple_path))
    for tuple_path_jes in itertools.product(self.bdtnames, self.jes):
      folder.append(os.path.join(*tuple_path_jes))
    for tuple_path_ues in itertools.product(self.bdtnames, self.ues):
      folder.append(os.path.join(*tuple_path_ues))
    for tuple_path_lhe in itertools.product(self.bdtnames, self.lhe):
      folder.append(os.path.join(*tuple_path_lhe))
    for f in folder:
      if 'ee' in f or 'me' in f or f=='TightOSgg/':
        self.book(f, 'MVA_e_m_Mass', 'MVA_e_m_Mass', 2000, -1, 1, 5000, 110, 160, type=ROOT.TH2F)
      if 'year' in f or 'Ues' in f or 'Unclustered' in f or 'RelativeSample' in f or 'JER' in f:
        self.book(f+'2016','MVA', 'MVA', 2000, -1, 1)
        self.book(f+'2017','MVA', 'MVA', 2000, -1, 1)
        self.book(f+'2018','MVA', 'MVA', 2000, -1, 1)
      else:
        self.book(f,'MVA', 'MVA', 2000, -1, 1)

  def fill_histos(self, myEle, myMuon, mva, weight, name=''):
    histos = self.histograms
    if 'ee' in name or 'me' in name or name=='TightOSgg':
      histos[name+'/MVA_e_m_Mass'].Fill(mva, self.visibleMass(myEle, myMuon), weight)
    histos[name+'/MVA'].Fill(mva, weight)

  def fill_categories(self, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, Ht, weight, name=''):
    if not (njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5):
      if njets == 0:
        mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, Ht, mjj, njets))
      elif njets == 1:
        mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, Ht, mjj, njets))
      else:
        mva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, Ht, mjj, njets))
      self.fill_histos(myEle, myMuon, mva, weight, 'TightOSgg'+name)


  def fill_sys(self, row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, Ht, weight):    

    tmpEle = ROOT.TLorentzVector()
    tmpMuon = ROOT.TLorentzVector()
    tmpMET = ROOT.TLorentzVector()

    self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '')

    #Theory
    for i in range(120):
      lheweight = getattr(row, 'lheweight' + str(i))
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight*lheweight, '/lhe'+str(i))
    #electron energy scale
    myMETpx = myMET.Px() + myEle.Px()
    myMETpy = myMET.Py() + myEle.Py()
    tmpEle = myEle * ROOT.Double(row.eEnergyScaleUp/row.eCorrectedEt)
    myMETpx = myMETpx - tmpEle.Px()
    myMETpy = myMETpy - tmpEle.Py()
    tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
    self.fill_categories(tmpEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/eesUp')

    myMETpx = myMET.Px() + myEle.Px()
    myMETpy = myMET.Py() + myEle.Py()
    tmpEle = myEle * ROOT.Double(row.eEnergyScaleDown/row.eCorrectedEt)
    myMETpx = myMETpx - tmpEle.Px()
    myMETpy = myMETpy - tmpEle.Py()
    tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
    self.fill_categories(tmpEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/eesDown')
  
    #muon energy scale + reso
    mcSFerror = self.rc.kSpreadMCerror(row.mCharge, row.mPt, row.mEta, row.mPhi, row.mGenPt)

    myMETpx = myMET.Px() + myMuon.Px()
    myMETpy = myMET.Py() + myMuon.Py()
    tmpMuon = myMuon * (1 + mcSFerror)
    myMETpx = myMETpx - tmpMuon.Px()
    myMETpy = myMETpy - tmpMuon.Py()
    tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
    self.fill_categories(myEle, tmpMuon, tmpMET, myJet1, myJet2, njets, mjj, Ht, weight, '/meUp') 

    myMETpx = myMET.Px() + myMuon.Px()
    myMETpy = myMET.Py() + myMuon.Py()
    tmpMuon = myMuon * (1 - mcSFerror)
    myMETpx = myMETpx - tmpMuon.Px()
    myMETpy = myMETpy - tmpMuon.Py()
    tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
    self.fill_categories(myEle, tmpMuon, tmpMET, myJet1, myJet2, njets, mjj, Ht, weight, '/meDown')

    #electron energy reso
    myMETpx = myMET.Px() + myEle.Px()
    myMETpy = myMET.Py() + myEle.Py()
    tmpEle = myEle * ROOT.Double(row.eEnergySigmaUp/row.eCorrectedEt)
    myMETpx = myMETpx - tmpEle.Px()
    myMETpy = myMETpy - tmpEle.Py()
    tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
    self.fill_categories(tmpEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, Ht, weight, '/eerUp') 

    myMETpx = myMET.Px() + myEle.Px()
    myMETpy = myMET.Py() + myEle.Py()
    tmpEle = myEle * ROOT.Double(row.eEnergySigmaDown/row.eCorrectedEt)
    myMETpx = myMETpx - tmpEle.Px()
    myMETpy = myMETpy - tmpEle.Py()
    tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
    self.fill_categories(tmpEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, Ht, weight, '/eerDown')

    #PU
    self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/puUp2018')
    self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/puDown2018')
    self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/puUp2017')
    self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/puDown2017')
    puweightUp = pucorrector['puUp'](row.nTruePU)
    puweightDown = pucorrector['puDown'](row.nTruePU)
    puweight = pucorrector[''](row.nTruePU)
    if puweight==0:
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, 0, '/puUp2016')
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, 0, '/puDown2016')
    else:
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight*puweightUp/puweight, '/puUp2016')
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight*puweightDown/puweight, '/puDown2016')
  
    #bTag
    nbtag = row.bjetDeepCSVVeto20Medium_2016_DR0p5
    self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/bTagUp2018')
    self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/bTagDown2018')
    self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/bTagUp2017')
    self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/bTagDown2017')
    if nbtag > 2:
      nbtag = 2
    if nbtag==0:
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/bTagUp2016')
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/bTagDown2016')
    if nbtag > 0:
      btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 0)
      btagweightup = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 1, 0)
      btagweightdown = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, -1, 0)
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight*btagweightup/btagweight, '/bTagUp2016')
      self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight*btagweightdown/btagweight, '/bTagDown2016')
  
    #pre-firing
    self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/pfUp2017')
    self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/pfDown2017')
    self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight*row.prefiring_weight_up/row.prefiring_weight, '/pfUp2016')
    self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight*row.prefiring_weight_down/row.prefiring_weight, '/pfDown2016')
  

    #jes+ues
    if not (self.is_recoilC and self.MetCorrection):
      for u in self.ues:
        tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+u), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+u), 0)
        self.fill_categories(myEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/'+u+"2016")
        self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/'+u+"2017")
        self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/'+u+"2018")
      for j in self.jes:
        tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
        tmpnjets = getattr(row, 'jetVeto30_'+j)
        tmpmjj = getattr(row, 'vbfMass_'+j)
        tmpJet1 = ROOT.TLorentzVector()
        tmpJet1.SetPtEtaPhiM(getattr(row, 'j1pt_'+j), getattr(row, 'j1eta_'+j), getattr(row, 'j1phi_'+j), 0)
        tmpJet2 = ROOT.TLorentzVector()
        tmpJet2.SetPtEtaPhiM(getattr(row, 'j2pt_'+j), getattr(row, 'j2eta_'+j), getattr(row, 'j2phi_'+j), 0)   
        if 'year' in j or 'RelativeSample' in j or 'JER' in j:  
          self.fill_categories(myEle, myMuon, tmpMET, tmpJet1, tmpJet2, tmpnjets, tmpmjj, row.Ht, weight, '/'+j+"2016")
          self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/'+j+"2017")
          self.fill_categories(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight, '/'+j+"2018")
        else:
          self.fill_categories(myEle, myMuon, tmpMET, tmpJet1, tmpJet2, tmpnjets, tmpmjj, row.Ht, weight, '/'+j)
            
  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]
      myJet1, myJet2 = self.jetVec(row)[0], self.jetVec(row)[1]

      weight = self.corrFact(row, myEle, myMuon)[0]

      njets = row.jetVeto30
      mjj = row.vbfMass

      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
        continue

      if njets>2:
        continue
      if self.oppositesign(row):
        self.fill_sys(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.Ht, weight)

  def finish(self):
    self.write_histos()
