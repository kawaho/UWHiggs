'''

Run LFV H->EMu analysis in the e+tau_mu channel.

Authors: Prasanna Siddireddy

'''

import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
from FinalStateAnalysis.TagAndProbe.bTagSF2018 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
#pucorrector = mcCorrections.puCorrector(target)

class EMuBase():
  tree = 'em/final/Ntuple'

  def __init__(self):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.gennames = Kinematics.gennames
    self.pucorrector = mcCorrections.puCorrector(target)
    self.is_recoilC = self.mcWeight.is_recoilC
    self.MetCorrection = self.mcWeight.MetCorrection
    if self.is_recoilC and self.MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
      self.MetSys = mcCorrections.MetSys

    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muTracking = mcCorrections.muonTracking
    self.eID = mcCorrections.eID
    self.rc = mcCorrections.rc
    self.w1 = mcCorrections.w1

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass

    self.names = Kinematics.names
    self.lhe = Kinematics.lhe

  # Requirement on the charge of the leptons
  def oppositesign(self, row):
    if row.eCharge*row.mCharge!=-1:
      return False
    return True

  # Trigger
  def trigger(self, row):
    triggerm8e23 = row.mu8e23DZPass and row.mPt > 10 and row.ePt > 24# and row.eMatchesMu8e23DZFilter and row.eMatchesMu8e23DZPath and row.mMatchesMu8e23DZFilter and row.mMatchesMu8e23DZPath
    return bool(triggerm8e23)

  # Kinematics requirements on both the leptons
  def kinematics(self, row):
    if row.ePt < 24 or abs(row.eEta) >= 2.5:
      return False
    if row.mPt < 10 or abs(row.mEta) >= 2.4:
      return False
    return True

  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False

  # Electron Identification
  def obj1_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))

  # Electron Isolation
  def obj1_iso(self, row):
    return bool(row.eRelPFIsoRho < 0.1)

  # Electron Tight Isolation
  def obj1_tight(self, row):
    return bool(row.eRelPFIsoRho < 0.1)

  # Electron Loose Isolation
  def obj1_loose(self, row):
    return bool(row.eRelPFIsoRho < 0.5)

  # Muon Identification
  def obj2_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))

  # Muon Isolation
  def obj2_iso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)

  # Third lepton veto
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)

  # Selections
  def eventSel(self, row):
    njets = row.jetVeto30
    if self.filters(row):
      return False
    elif not self.trigger(row):
      return False
    elif not self.kinematics(row):
      return False
    elif self.deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.4:
      return False
    elif njets > 2:
      return False
    elif not self.obj1_id(row):
      return False
    elif not self.obj2_id(row):
      return False
    elif not self.obj1_iso(row):
      return False
    elif not self.obj2_iso(row):
      return False
    elif not self.vetos(row):
      return False
    else:
      return True

  # TVector
  def lepVec(self, row):
    myEle = ROOT.TLorentzVector()
    myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
    myMET = ROOT.TLorentzVector()
    myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)
    myMuon = ROOT.TLorentzVector()
    myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)
    if self.is_recoilC and self.MetCorrection:
      tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
      myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)
    return [myEle, myMET, myMuon]


  def corrFact(self, row, myEle, myMuon):
    # Apply all the various corrections to the MC samples
    weight = 1.0
    njets = row.jetVeto30
    self.w1.var("e_pt").setVal(myEle.Pt())
    self.w1.var("e_eta").setVal(myEle.Eta())
    self.w1.var("e_iso").setVal(row.eRelPFIsoRho)
    self.w1.var("m_pt").setVal(myMuon.Pt())
    self.w1.var("m_eta").setVal(myMuon.Eta())
    eff_trg_data = self.w1.function("e_trg_23_data").getVal()*self.w1.function("m_trg_8_data").getVal()
    eff_trg_mc = self.w1.function("e_trg_23_mc").getVal()*self.w1.function("m_trg_8_mc").getVal()
    tEff = 0 if eff_trg_mc==0 else eff_trg_data/eff_trg_mc
    eID = self.w1.function("e_id80_kit_ratio").getVal()
    eIso = self.w1.function("e_iso_kit_ratio").getVal()
    eReco = self.w1.function('e_trk_ratio').getVal()
    #eID = self.eID(myEle.Eta(), myEle.Pt())
    mID = self.muonTightID(myMuon.Pt(), abs(myMuon.Eta()))
    mIso = self.muonTightIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
    mTrk = self.muTracking(myMuon.Eta())[0]
    mcSF = self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
    weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*eID*eIso*eReco*mID*mIso*mTrk*mcSF
    weight = self.mcWeight.lumiWeight(weight)

    self.w1.var("njets").setVal(njets)
    self.w1.var("dR").setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()))
    self.w1.var("e_pt").setVal(myEle.Pt())
    self.w1.var("m_pt").setVal(myMuon.Pt())
    osss = self.w1.function("em_qcd_osss_binned").getVal()

    # b-tag
    nbtag = row.bjetDeepCSVVeto20Medium_2018_DR0p5
    if nbtag > 2:
      nbtag = 2
    if (nbtag > 0):
      btagweight = bTagEventWeight(nbtag, row.jb1pt_2018, row.jb1hadronflavor_2018, row.jb2pt_2018, row.jb2hadronflavor_2018, 1, 0, 0)
      weight = weight * btagweight

    return [weight, osss]
