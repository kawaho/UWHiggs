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
  tree = 'em/final/Ntuple'

  def __init__(self):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY

    self.muonTightID = mcCorrections.muonID_tight
    self.triggerEff27 = mcCorrections.muonTrigger27
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.eIDnoiso80 = mcCorrections.eIDnoiso80

    self.DYreweight = mcCorrections.DYreweight
    self.rc = mcCorrections.rc

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight
    self.invert_case = Kinematics.invert_case
    self.Zeppenfeld = Kinematics.Zeppenfeld
    self.RpT = Kinematics.RpT
    self.plotnames = Kinematics.plotnames

  # Requirement on the charge of the leptons
  def oppositesign(self, row):
    if row.eCharge*row.mCharge!=-1:
      return False
    return True

  # Trigger
  def trigger(self, row):
    trigger27 = row.IsoMu27Pass and row.mMatchesIsoMu27Filter and row.mMatchesIsoMu27Path and row.mPt > 29
    return bool(trigger27)

  # Kinematics requirements on both the leptons
  def kinematics(self, row):
    if row.ePt < 24 or abs(row.eEta) >= 2.5:
      return False
    if row.mPt < 24 or abs(row.mEta) >= 2.4:
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

  # Muon Identification
  def obj2_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))

  # Muon Isolation
  def obj2_iso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)

  # Third lepton veto
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPtDeepVtx < 0.5)

  # Book histograms
  def begin(self):
    for n in Kinematics.bdtnames:
      self.book(n, 'bdtDiscriminator', 'BDT Discriminator', 2000, -1.0, 1.0)
      self.book(n,'MVA_emEta', 'Electron + Muon Eta', 200, -1, 1, 140, -7, 7, type=ROOT.TH2F)

  def fill_histos(self, myEle, myMuon, myMET, myJet1, myJet2, njets, mva, PU, weight, name=''):
    histos = self.histograms
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)
    histos[name+'/DeltaR_em_j1'].Fill(self.deltaR((myEle + myMuon).Phi(), myJet1.Phi(), (myEle + myMuon).Eta(), myJet1.Eta()), weight)
   
  # Selections
  def eventSel(self, row):
    njets = row.jetVeto30WoNoisyJets
    if self.filters(row):
      return False
    elif not self.trigger(row):
      return False
    elif not self.kinematics(row):
      return False
    elif self.deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.3:
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

  def jetVec(self,row):
    myJet1 = ROOT.TLorentzVector()
    myJet1.SetPtEtaPhiM(row.j1ptWoNoisyJets, row.j1etaWoNoisyJets, row.j1phiWoNoisyJets, 0)
    myJet2 = ROOT.TLorentzVector()
    myJet2.SetPtEtaPhiM(row.j2ptWoNoisyJets, row.j2etaWoNoisyJets, row.j2phiWoNoisyJets, 0)
    return [myJet1, myJet2]
    
  # TVector
  def lepVec(self, row):
    myEle = ROOT.TLorentzVector()
    myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
    myMET = ROOT.TLorentzVector()
    myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)
    myMuon = ROOT.TLorentzVector()
    myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

    # Electron Scale Correction
    if self.is_data:
      myEle = myEle * ROOT.Double(row.eCorrectedEt/myEle.E())
      myMuon = myMuon * self.rc.kScaleDT(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), 0, 0)
    else:
      myMETpx = myMET.Px() + myEle.Px() + myMuon.Px()
      myMETpy = myMET.Py() + myEle.Py() + myMuon.Py()
      if self.is_mc:
        myEle = myEle * ROOT.Double(row.eCorrectedEt/myEle.E())
        myMuon = myMuon * self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
      myMETpx = myMETpx - myEle.Px() - myMuon.Px()
      myMETpy = myMETpy - myEle.Py() - myMuon.Py()
      myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
    return [myEle, myMET, myMuon]

  def corrFact(self, row, myEle, myMuon):
    # Apply all the various corrections to the MC samples
    weight = 1.0
    if self.is_mc:
      self.w1.var('m_pt').setVal(myMuon.Pt())
      self.w1.var('m_eta').setVal(myMuon.Eta())
      self.w1.var('m_iso').setVal(row.mRelPFIsoDBDefaultR04)
      self.w1.var('e_pt').setVal(myEle.Pt())
      self.w1.var('e_eta').setVal(myEle.Eta())
      eID = self.eIDnoiso80(myEle.Eta(), myEle.Pt())
      eReco = self.eReco(myEle.Eta(), myEle.Pt())

      mID = self.muonTightID(myMuon.Pt(), abs(myMuon.Eta()))
      mIso = self.muonTightIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
      mTrk = self.muTracking(myMuon.Eta())[0]
      weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*eID*eReco*mID*mIso*mTrk*row.prefiring_weight
      if self.is_DY:
        # DY pT reweighting
        dyweight = self.DYreweight(row.genMass, row.genpT)
        weight = weight * dyweight
      weight = self.mcWeight.lumiWeight(weight)

      if weight > 10:
        weight = 0
    njets = row.jetVeto30WoNoisyJets
    mjj = row.vbfMassWoNoisyJets

    return weight

