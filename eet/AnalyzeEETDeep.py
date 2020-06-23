'''

Tau Fake Rate calculation in the Z+Jets control region.

Authors: Prasanna Siddireddy

'''

import EETauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
from bTagSF import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeEETDeep(MegaBase):
  tree = 'eet/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY

    self.Ele32or35 = mcCorrections.Ele32or35
    self.EleIdIso = mcCorrections.EleIdIso
    self.DYreweight = mcCorrections.DYreweight
    self.DYreweightReco = mcCorrections.DYreweightReco

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass

    super(AnalyzeEETDeep, self).__init__(tree, outfile, **kwargs)
    self.tree = EETauTree.EETauTree(tree)
    self.out = outfile
    self.histograms = {}

  # Charge requirement for the electrons to be coming from Z-decay
  def oppositesign(self,row):
    if row.e1Charge * row.e2Charge!=-1:
      return False
    return True

  # Kinematic Selections
  def kinematics(self, row):
    if row.e1Pt < 10 or abs(row.e1Eta) >= 2.1:
      return False
    if row.e2Pt < 10 or abs(row.e2Eta) >= 2.1:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
      return False
    return True

  # MET Filters
  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False

  # MVA Identification along with Primary Vertex matching for Electron 1
  def obj1_id(self, row):
    return (bool(row.e1MVANoisoWP80) and bool(abs(row.e1PVDZ) < 0.2) and bool(abs(row.e1PVDXY) < 0.045) and bool(row.e1PassesConversionVeto) and bool(row.e1MissingHits < 2))
 
  # Isolation requirement using Effective Area method for Electron 1
  def obj1_iso(self, row):
    return bool(row.e1RelPFIsoRho < 0.15)

  # MVA Identification along with Primary Vertex matching for Electron 2
  def obj2_id(self, row):
    return (bool(row.e2MVANoisoWP80) and bool(abs(row.e2PVDZ) < 0.2) and bool(abs(row.e2PVDXY) < 0.045) and bool(row.e2PassesConversionVeto) and bool(row.e2MissingHits < 2))

  # Isolation requirement using Effective Area method for Electron 2
  def obj2_iso(self, row):
    return bool(row.e2RelPFIsoRho < 0.15)

  # Tau decay mode finding along with discrimination against electron and muon, and primary vertex matching
  def tau_id(self, row):
    return bool(row.tDecayModeFindingNewDMs > 0.5) and bool(row.tTightDeepTau2017v2p1VSe > 0.5) and bool(row.tLooseDeepTau2017v2p1VSmu > 0.5) and bool(abs(row.tPVDZ) < 0.2)
  # Tight Working Point(WP) for Isolation for tau
  def tau_tight(self, row):
    return bool(row.tTightDeepTau2017v2p1VSjet > 0.5)

  # Very Loose Working Point(WP) for Isolation for tau
  def tau_vloose(self, row):
    return bool(row.tVLooseDeepTau2017v2p1VSjet > 0.5)

  # Veto of events with additional leptons coming from the primary vertex
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def begin(self):
    names = ['initial', 'loose', 'LEBDM0', 'LEBDM1', 'LEBDM10', 'LEBDM11', 'LEEDM0', 'LEEDM1', 'LEEDM10', 'LEEDM11', 'tight', 'TEBDM0', 'TEBDM1', 'TEBDM10', 'TEBDM11', 'TEEDM0', 'TEEDM1', 'TEEDM10', 'TEEDM11']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "tPt", "Tau Pt", 20, 0, 200)
      self.book(names[x], "tEta", "Tau Eta", 20, -3, 3)
      self.book(names[x], "tDecayMode", "Tau Decay Mode", 20, 0, 20)
      self.book(names[x], "e1_e2_Mass", "Invariant Electron Mass", 10, 50, 150)
      self.book(names[x], "e1Pt", "Electron 1 Pt", 20, 0, 200)
      self.book(names[x], "e1Eta", "Electron 1 Eta", 20, -3, 3)
      self.book(names[x], "e2Pt", "Electron 2 Pt", 20, 0, 200)
      self.book(names[x], "e2Eta", "Electron 2 Eta", 20, -3, 3)
      self.book(names[x], 'numOfJets', 'Number of Jets', 5, 0, 5)

  def fill_histos(self, row, myEle1, myEle2, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/tPt'].Fill(myTau.Pt(), weight)
    histos[name+'/tEta'].Fill(myTau.Eta(), weight)
    histos[name+'/tDecayMode'].Fill(row.tDecayMode, weight)
    histos[name+'/e1_e2_Mass'].Fill(self.visibleMass(myEle1, myEle2), weight)
    histos[name+'/e1Pt'].Fill(myEle1.Pt(), weight)
    histos[name+'/e1Eta'].Fill(myEle1.Eta(), weight)
    histos[name+'/e2Pt'].Fill(myEle2.Pt(), weight)
    histos[name+'/e2Eta'].Fill(myEle2.Eta(), weight)
    histos[name+'/numOfJets'].Fill(row.jetVeto30, weight)
  # Tau energy scale correction
  def tauPtC(self, row, myTau):
    tmpTau = myTau
    if self.is_mc and row.tZTTGenMatching==5:
      if row.tDecayMode == 0:
        tmpTau = myTau * ROOT.Double(0.994)
      elif row.tDecayMode == 1:
        tmpTau = myTau * ROOT.Double(0.995)
      elif row.tDecayMode == 10:
        tmpTau = myTau * ROOT.Double(1.000)
    if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
      if abs(myTau.Eta()) < 1.448:
        if row.tDecayMode == 0:
          tmpTau = myTau * ROOT.Double(1.0139181)
        elif row.tDecayMode == 1:
          tmpTau = myTau * ROOT.Double(1.01945)
      elif abs(myTau.Eta()) > 1.558:
        if row.tDecayMode == 0:
          tmpTau = myTau * ROOT.Double(0.96903)
        elif row.tDecayMode == 1:
          tmpTau = myTau * ROOT.Double(0.985)
    return tmpTau   

  
  def process(self):

    for row in self.tree:

      trigger32e1 = row.Ele32WPTightPass and row.e1MatchesEle32Filter and row.e1MatchesEle32Path and row.e1Pt > 33
      trigger35e1 = row.Ele35WPTightPass and row.e1MatchesEle35Filter and row.e1MatchesEle35Path and row.e1Pt > 36
      trigger32e2 = row.Ele32WPTightPass and row.e2MatchesEle32Filter and row.e2MatchesEle32Path and row.e2Pt > 33
      trigger35e2 = row.Ele35WPTightPass and row.e2MatchesEle35Filter and row.e2MatchesEle35Path and row.e2Pt > 36 
      e1tautrigger2430 = row.Ele24LooseTau30Pass and row.e1MatchEmbeddedFilterEle24Tau30 and row.tMatchEmbeddedFilterEle24Tau30 and row.e1Pt > 25 and row.e1Pt < 33 and row.tPt > 32 and abs(row.tEta) < 2.1
      e2tautrigger2430 = row.Ele24LooseTau30Pass and row.e2MatchEmbeddedFilterEle24Tau30 and row.tMatchEmbeddedFilterEle24Tau30 and row.e2Pt > 25 and row.e2Pt < 33 and row.tPt > 32 and abs(row.tEta) < 2.1

      if self.filters(row):
        continue

      if not bool(trigger32e1 or trigger32e2 or trigger35e1 or trigger35e2 or e1tautrigger2430 or e2tautrigger2430):
        continue

      if not self.kinematics(row):
        continue

      if not self.oppositesign(row):
        continue

      if not self.vetos(row):
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj1_iso(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.obj2_iso(row):
        continue

      myEle1 = ROOT.TLorentzVector()
      myEle1.SetPtEtaPhiM(row.e1Pt, row.e1Eta, row.e1Phi, row.e1Mass)
      myEle2 = ROOT.TLorentzVector()
      myEle2.SetPtEtaPhiM(row.e2Pt, row.e2Eta, row.e2Phi, row.e2Mass)
      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)
      myTau = self.tauPtC(row, myTau)

      if self.visibleMass(myEle1, myEle2) < 70 or self.visibleMass(myEle1, myEle2) > 110:
        continue

      if not self.tau_id(row):
        continue
    
      if row.tDecayMode==5 or row.tDecayMode==6:
        continue
      
      weight = 1.0
      if self.is_mc:
        # Trigger Scale Factors
        if trigger32e1 or trigger35e1:
          self.w1.var('e_pt').setVal(myEle1.Pt())
          self.w1.var('e_eta').setVal(myEle1.Eta())
          tEff = self.w1.function('e_trg32_trg35_binned_kit_ratio').getVal() 
        if trigger32e2 or trigger35e2:
          self.w1.var('e_pt').setVal(myEle2.Pt())
          self.w1.var('e_eta').setVal(myEle2.Eta())
          tEff = self.w1.function('e_trg32_trg35_binned_kit_ratio').getVal()   
        if e1tautrigger2430:
          self.w1.var('e_pt').setVal(myEle1.Pt())
          self.w1.var('e_eta').setVal(myEle1.Eta())
          tEff = self.w1.function('e_trg_EleTau_Ele24Leg_desy_ratio').getVal()
          if row.tDecayMode==11:
            tEff = tEff * self.tauSF.getTriggerScaleFactor(myTau.Pt(), myTau.Eta(), myTau.Phi(), 10)
          else:
            tEff = tEff * self.tauSF.getTriggerScaleFactor(myTau.Pt(), myTau.Eta(), myTau.Phi(), row.tDecayMode)
        if e2tautrigger2430:
          self.w1.var('e_pt').setVal(myEle2.Pt())
          self.w1.var('e_eta').setVal(myEle2.Eta())
          tEff = self.w1.function('e_trg_EleTau_Ele24Leg_desy_ratio').getVal() 
          if row.tDecayMode==11:
            tEff = tEff * self.tauSF.getTriggerScaleFactor(myTau.Pt(), myTau.Eta(), myTau.Phi(), 10)
          else:
            tEff = tEff * self.tauSF.getTriggerScaleFactor(myTau.Pt(), myTau.Eta(), myTau.Phi(), row.tDecayMode)
        # Electron 1 Scale Factors
        e1IdIso = self.EleIdIso(row.e1Pt, abs(row.e1Eta))[0]
        # ELectron 2 Scale Factors
        e2IdIso = self.EleIdIso(row.e2Pt, abs(row.e2Eta))[0]
        weight = weight * row.GenWeight * pucorrector[''](row.nTruePU) * e1IdIso * e2IdIso
        # Anti-Muon and Anti-Electron Discriminator Scale Factors
        if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
          if self.tau_tight(row):
            if abs(row.tEta) < 0.4:
              weight = weight * 0.76752001
            elif abs(row.tEta) < 0.8:
              weight = weight * 1.255064
            elif abs(row.tEta) < 1.2:
              weight = weight * 0.901968
            elif abs(row.tEta) < 1.7:
              weight = weight * 0.833875
            else:
              weight = weight * 4.4357042
          if self.tau_vloose(row):
            if abs(row.tEta) < 0.4:
              weight = weight * 0.95378399
            elif abs(row.tEta) < 0.8:
              weight = weight * 1.0085959
            elif abs(row.tEta) < 1.2:
              weight = weight * 1.028736
            elif abs(row.tEta) < 1.7:
              weight = weight * 0.928222
            else:
              weight = weight * 5.0001121
        elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3: 
          if self.tau_vloose(row):
            if abs(row.tEta) < 1.448: # Corrected
              weight = weight * 0.94999999
            elif abs(row.tEta) > 1.558:
              weight = weight * 0.8000001
          if self.tau_tight(row):
            if abs(row.tEta) < 1.448: # Corrected
              weight = weight * 1.47
            elif abs(row.tEta) > 1.558:
              weight = weight * 0.66000003
        # Tau ID Scale Factor
        elif row.tZTTGenMatching==5:
          if row.tPt <= 25:
            weight = weight * 0.94948
          elif row.tPt <= 30:
            weight = weight * 1.004693
          elif row.tPt <= 35:
            weight = weight * 0.92511
          elif row.tPt <= 40:
            weight = weight * 0.9000217
          else:
            weight = weight * 0.990344154161
      if self.is_DY:
         # DY pT reweighting
         dyweight = self.DYreweight(row.genMass, row.genpT)
         weight = weight * dyweight
         if row.numGenJets < 5:
           weight = weight * self.DYweight[row.numGenJets]
         else:
           weight = weight * self.DYweight[0]
      weight = self.mcWeight.lumiWeight(weight)

      # B-Jet Veto using b-tagging event weight method
      nbtag = row.bjetDeepCSVVeto20Medium_2018_DR0p5
      if nbtag > 2:
        nbtag = 2
      if (self.is_mc and nbtag > 0):
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2018, row.jb1hadronflavor_2018, row.jb2pt_2018, row.jb2hadronflavor_2018, 1, 0, 0)
        weight = weight * btagweight
      if (bool(self.is_data) and nbtag > 0):
        weight = 0

      # Fill the plots based on the tau decay mode, eta, and isolation
      self.fill_histos(row, myEle1, myEle2, myTau, weight, 'initial')

      if self.tau_vloose(row):
        self.fill_histos(row, myEle1, myEle2, myTau, weight, 'loose')
        if abs(row.tEta) < 1.5:
          if row.tDecayMode == 0:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEBDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEBDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEBDM10')
          elif row.tDecayMode == 11:                                         
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEBDM11')
        else:
          if row.tDecayMode == 0:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEEDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEEDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEEDM10')
          elif row.tDecayMode == 11:                                         
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEEDM11')

      if self.tau_tight(row):
        self.fill_histos(row, myEle1, myEle2, myTau, weight, 'tight')
        if abs(row.tEta) < 1.5:
          if row.tDecayMode == 0:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEBDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEBDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEBDM10')
          elif row.tDecayMode == 11:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEBDM11')
        else:
          if row.tDecayMode == 0:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEEDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEEDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEEDM10')
          elif row.tDecayMode == 11:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEEDM11')
  def finish(self):
    self.write_histos()
