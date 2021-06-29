'''

Run LFV H->EMu analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class EMBase():
  tree = 'mm/final/Ntuple'

  def __init__(self):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY

    self.muonTightID = mcCorrections.muonID_tight
    self.triggerEff27 = mcCorrections.muonTrigger27
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid

    self.DYreweight = mcCorrections.DYreweight
    self.rc = mcCorrections.rc

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.transverseMass = Kinematics.transverseMass
    self.invert_case = Kinematics.invert_case
    self.Zeppenfeld = Kinematics.Zeppenfeld
    self.RpT = Kinematics.RpT
    self.plotnames = Kinematics.plotnames
    self.ptbinning = Kinematics.ptbinning
    self.mbinning = Kinematics.mbinning

  # Requirement on the charge of the leptons
  def oppositesign(self, row):
    if row.m1Charge*row.m2Charge!=-1:
      return False
    return True

  # Trigger
  def trigger(self, row):
    trigger27 = row.IsoMu27Pass and ((row.m1MatchesIsoMu27Filter and row.m1MatchesIsoMu27Path and row.m1Pt > 29) or (row.m2MatchesIsoMu27Filter and row.m2MatchesIsoMu27Path and row.m2Pt > 29))
    return bool(trigger27)

  # Kinematics requirements on both the leptons
  def kinematics(self, row):
    if row.m1Pt < 15 or row.m1Pt > 120 or abs(row.m1Eta) >= 2.4:
      return False
    if row.m2Pt < 15 or row.m2Pt > 120 or abs(row.m2Eta) >= 2.4:
      return False
    return True

  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadPFMuonDzFilter or bool(self.is_data and row.Flag_eeBadScFilter) or row.Flag_ecalBadCalibFilter:
      return True
    return False

  # Muon Identification
  def obj_id(self, row):
    return (bool(row.m1PFIDTight) and bool(abs(row.m1PVDZ) < 0.2) and bool(abs(row.m1PVDXY) < 0.045) and bool(row.m2PFIDTight) and bool(abs(row.m2PVDZ) < 0.2) and bool(abs(row.m2PVDXY) < 0.045))

  # Muon Isolation
  def obj_iso(self, row):
    return (bool(row.m1RelPFIsoDBDefaultR04 < 0.15) and bool(row.m2RelPFIsoDBDefaultR04 < 0.15))

  # Third lepton veto
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPtDeepVtx < 0.5)

  # Book histograms
  def begin(self):
    for n in self.plotnames:
      self.book(n, 'pt', 'pt', len(self.ptbinning)-1, self.ptbinning)
      self.book(n, 'M', 'M', len(self.mbinning)-1, self.mbinning)
      self.book(n, 'M_pt', 'M_pt', len(self.mbinning)-1, self.mbinning, len(self.ptbinning)-1, self.ptbinning, type=ROOT.TH2F)

  def fill_histos(self, myMuon1, myMuon2, weight, name=''):
    histos = self.histograms
    histos[name+'/pt'].Fill((myMuon1+myMuon2).Pt(), weight)
    histos[name+'/M'].Fill((myMuon1+myMuon2).M(), weight)
    histos[name+'/M_pt'].Fill((myMuon1+myMuon2).M(), (myMuon1+myMuon2).Pt(), weight)
   
  # Selections
  def eventSel(self, row):
    njets = row.jetVeto30
    if self.filters(row):
      return False
    elif not self.trigger(row):
      return False
    elif not self.kinematics(row):
      return False
    elif self.deltaR(row.m1Phi, row.m2Phi, row.m1Eta, row.m2Eta) < 0.3:
      return False
#    elif njets > 2:
#      return False
    elif not self.obj_id(row):
      return False
    elif not self.obj_iso(row):
      return False
    elif not self.vetos(row):
      return False
    else:
      return True

  def jetVec(self,row):
    myJet1 = ROOT.TLorentzVector()
    myJet1.SetPtEtaPhiM(row.j1pt, row.j1eta, row.j1phi, 0)
    myJet2 = ROOT.TLorentzVector()
    myJet2.SetPtEtaPhiM(row.j2pt, row.j2eta, row.j2phi, 0)
    return [myJet1, myJet2]
    
  # TVector
  def lepVec(self, row):
    myMET = ROOT.TLorentzVector()
    myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)
    myMuon1 = ROOT.TLorentzVector()
    myMuon1.SetPtEtaPhiM(row.m1Pt, row.m1Eta, row.m1Phi, row.m1Mass)
    myMuon2 = ROOT.TLorentzVector()
    myMuon2.SetPtEtaPhiM(row.m2Pt, row.m2Eta, row.m2Phi, row.m2Mass)

    if self.is_data:
      myMuon1 = myMuon1 * self.rc.kScaleDT(row.m1Charge, myMuon1.Pt(), myMuon1.Eta(), myMuon1.Phi(), 0, 0)
      myMuon2 = myMuon2 * self.rc.kScaleDT(row.m2Charge, myMuon2.Pt(), myMuon2.Eta(), myMuon2.Phi(), 0, 0)
    else:
      myMETpx = myMET.Px() + myMuon1.Px() + myMuon2.Px()
      myMETpy = myMET.Py() + myMuon1.Py() + myMuon2.Py()
      if self.is_mc:
        myMuon1 = myMuon1 * self.rc.kSpreadMC(row.m1Charge, myMuon1.Pt(), myMuon1.Eta(), myMuon1.Phi(), row.m1GenPt, 0, 0)
        myMuon2 = myMuon2 * self.rc.kSpreadMC(row.m2Charge, myMuon2.Pt(), myMuon2.Eta(), myMuon2.Phi(), row.m2GenPt, 0, 0)
      myMETpx = myMETpx - myMuon1.Px() - myMuon2.Px()
      myMETpy = myMETpy - myMuon1.Py() - myMuon2.Py()
      myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
    return [myMuon1, myMET, myMuon2]

  def corrFact(self, row, myMuon1, myMuon2):
    # Apply all the various corrections to the MC samples
    weight = 1.0
    if self.is_mc:
      m1ID = self.muonTightID(myMuon1.Pt(), abs(myMuon1.Eta()))
      m1Iso = self.muonTightIsoTightID(myMuon1.Pt(), abs(myMuon1.Eta()))
      m2ID = self.muonTightID(myMuon2.Pt(), abs(myMuon2.Eta()))
      m2Iso = self.muonTightIsoTightID(myMuon2.Pt(), abs(myMuon2.Eta()))
      tEff = 1
      if (row.m1MatchesIsoMu27Filter and row.m1MatchesIsoMu27Path):
        tEff *= self.triggerEff27(myMuon1.Pt(), abs(myMuon1.Eta()))[0]
      if (row.m2MatchesIsoMu27Filter and row.m2MatchesIsoMu27Path):
        tEff *= self.triggerEff27(myMuon2.Pt(), abs(myMuon2.Eta()))[0]
      weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*m1ID*m1Iso*m2ID*m2Iso*tEff*row.prefiring_weight
      weight = self.mcWeight.lumiWeight(weight)

      if weight > 10:
        weight = 0
    return weight

