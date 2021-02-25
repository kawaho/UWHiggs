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
from FinalStateAnalysis.TagAndProbe.bTagSF2016 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class EMBase():
  tree = 'em/final/Ntuple'

  def __init__(self):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_eraG = self.mcWeight.is_eraG
    self.is_eraH = self.mcWeight.is_eraH
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_W = self.mcWeight.is_W
    self.is_TT = self.mcWeight.is_TT
    self.is_ST = self.mcWeight.is_ST
    self.is_VV = self.mcWeight.is_VV
    self.is_GluGlu = self.mcWeight.is_GluGlu
    self.is_VBF = self.mcWeight.is_VBF
    self.is_GluGlu120 = self.mcWeight.is_GluGlu120
    self.is_VBF120 = self.mcWeight.is_VBF120
    self.is_GluGlu130 = self.mcWeight.is_GluGlu130
    self.is_VBF130 = self.mcWeight.is_VBF130
    self.is_Signal = self.mcWeight.is_Signal
    self.Emb = False
    self.is_recoilC = self.mcWeight.is_recoilC
    self.MetCorrection = self.mcWeight.MetCorrection
    if self.is_recoilC and self.MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
      self.MetSys = mcCorrections.MetSys

    self.triggerEff24 = mcCorrections.muonTrigger24
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muTracking = mcCorrections.muonTracking
    self.eIDnoiso80 = mcCorrections.eIDnoiso80
    self.MESSys = mcCorrections.MESSys
    self.RecSys = mcCorrections.RecSys
 
    self.DYreweight = mcCorrections.DYreweight
    self.w1 = mcCorrections.w1
    self.rc = mcCorrections.rc

    self.DYweight = self.mcWeight.DYweight
    self.Wweight = self.mcWeight.Wweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.transverseMass = Kinematics.transverseMass
    self.invert_case = Kinematics.invert_case
    self.Zeppenfeld = Kinematics.Zeppenfeld
    self.RpT = Kinematics.RpT
    self.bdtcuts = Kinematics.bdtcuts
    self.functor_gg = Kinematics.functor_gg
    self.var_d_gg_0 = Kinematics.var_d_gg_0
    self.var_d_gg_1 = Kinematics.var_d_gg_1
    self.var_d_gg_2 = Kinematics.var_d_gg_2
#    self.functor_vbf = Kinematics.functor_vbf
#    self.var_d_vbf_2 = Kinematics.var_d_vbf_2
    self.bdtnames = Kinematics.bdtnames
    self.lhe = Kinematics.lhe
    self.catnames = Kinematics.catnames
    self.vbfnames = Kinematics.vbfnames
#    self.branches='mPt/F:ePt/F:e_m_Mass/F:type1_pfMetEt/F:itype/I:cat/I:weight/F'
    self.holders = []
    self.name='opttree'
    self.title='opttree'

    self.branches='e_met_mT_per_M/F:m_met_mT_per_M/F:ePt/F:mPt/F:ePt_Per_mPt/F:Nj/I:mPt_Per_e_m_Mass/F:ePt_Per_e_m_Mass/F:e_m_Mass/F:emPt/F:emRapidity/F:emEta/F:mEta/F:eEta/F:j1Pt/F:j2Pt/F:j1Eta/F:j2Eta/F:DeltaEta_e_m/F:DeltaPhi_e_m/F:DeltaEta_e_j1/F:DeltaPhi_e_j1/F:DeltaEta_m_j1/F:DeltaPhi_m_j1/F:DeltaEta_e_j2/F:DeltaPhi_e_j2/F:DeltaEta_m_j2/F:DeltaPhi_m_j2/F:DeltaEta_em_j1/F:DeltaPhi_em_j1/F:DeltaEta_em_j2/F:DeltaPhi_em_j2/F:DeltaEta_j1_j2/F:DeltaPhi_j1_j2/F:Zeppenfeld/F:Zeppenfeld_ver2/F:Zeppenfeld_ver3/F:j1_j2_mass/F:DeltaPhi_em_j1j2/F:DeltaEta_em_j1j2/F:minDeltaPhi_em_j1j2/F:minDeltaEta_em_j1j2/F:m_met_mT/F:e_met_mT/F:DeltaPhi_e_met/F:DeltaPhi_m_met/F:absEta_e/F:absEta_m/F:MetEt/F:e_m_PZeta/F:R_pT/F:pT_cen/F:pT_cen_ver2/F:pT_cen_ver3/F:cen/F:Ht/F:DeltaR_e_m/F:weight/F:cat/I:DeltaR_em_j1/F:DeltaR_em_j2/F:DeltaR_j1_j2/F:DeltaR_em_j1j2/F:DeltaR_e_j1/F:DeltaR_m_j1/F:DeltaR_e_j2/F:DeltaR_m_j2/F'
    self.jes = Kinematics.jes
    self.ues = Kinematics.ues
#    self.names = Kinematics.names
#    self.ssnames = Kinematics.ssnames
#    self.sys = Kinematics.sys
#    self.recSys = Kinematics.recSys
#    self.sssys = Kinematics.sssys
#    self.qcdsys = Kinematics.qcdsys
    self.sys = Kinematics.sys
#    self.functor = Kinematics.functor
#    self.var_d = Kinematics.var_d

    self.workspace = ROOT.RooWorkspace("CMS_emu_workspace")
  
  def imp(self, obj, recycle = False):
        # helper function to import objects into the output workspace
        if recycle:
            getattr(self.workspace,'import')(obj, ROOT.RooFit.RecycleConflictNodes())
        else:
            getattr(self.workspace,'import')(obj)

  # Requirement on the charge of the leptons
  def oppositesign(self, row):
    if row.eCharge*row.mCharge!=-1:
      return False
    return True

  # Trigger
  def trigger(self, row):
    trigger24 = row.IsoMu24Pass and row.mMatchesIsoMu24Filter and row.mMatchesIsoMu24Path and row.mPt > 26
    if self.is_eraG or self.is_eraH:
      triggerm8e23 = row.mu8e23DZPass
      triggerm23e12 = row.mu23e12DZPass
    else:
      triggerm8e23 = row.mu8e23Pass
      triggerm23e12 = row.mu23e12Pass
    return bool(trigger24 or (triggerm8e23 and triggerm23e12))

  # Trigger
  def trigger24(self, row):
    trigger24 = row.IsoMu24Pass and row.mMatchesIsoMu24Filter and row.mMatchesIsoMu24Path and row.mPt > 26
    return trigger24

  # Trigger
  def triggerEG(self, row):
    if self.is_eraG or self.is_eraH:
      triggerm8e23 = row.mu8e23DZPass
      triggerm23e12 = row.mu23e12DZPass
    else:
      triggerm8e23 = row.mu8e23Pass
      triggerm23e12 = row.mu23e12Pass
    return bool(triggerm8e23 and triggerm23e12)

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

  def cuts(self, row, cat):
    tmp = self.cutparms[cat]  
    if tmp['geo'] == 'EB-MB':
      geobool = bool(abs(row.mEta) < 0.8 and abs(row.eEta) < 1.5)
    elif tmp['geo'] == 'EB-ME':
      geobool = bool (abs(row.mEta) > 0.8 and abs(row.eEta) < 1.5)
    elif tmp['geo'] == 'EE':
      geobool = bool (abs(row.eEta) > 1.5)
    elif tmp['geo'] == None:
      geobool = True
    ept_min = tmp['cuts'].get('ept_min')
    mpt_min = tmp['cuts'].get('mpt_min')
    met_max = tmp['cuts'].get('met_max')
    return geobool and bool(row.ePt > ept_min) and bool(row.mPt > mpt_min) and bool(row.type1_pfMetEt < met_max) 
   
  # Book histograms
  def begin(self):
    for n in Kinematics.yieldnames:
      self.book(n, 'bdtDiscriminator', 'BDT Discriminator', 2000, -1.0, 1.0)
#      self.book(n, 'ePt_Per_e_m_Mass', 'Electron pT per Electron + Muon Mass', 200, 0, 2)
#      self.book(n, 'mPt_Per_e_m_Mass', 'Muon pT per Electron + Muon Mass', 200, 0, 2)
#      self.book(n, 'emEta', 'Electron + Muon Eta', 140, -7, 7)
#      self.book(n, 'DeltaR_e_m', 'Delta R of Electron and Muon', 45, 0, 4.5)
#      self.book(n, 'm_met_mT_Per_e_m_Mass', 'Muon + MET Transverse Mass', 350, 0, 3.5)
#      self.book(n, 'e_met_mT_Per_e_m_Mass', 'Electron + MET Transverse Mass', 350, 0, 3.5)
      self.book(n, 'MetEt', 'MET E_T', 400, 0, 400)
      self.book(n, 'nTruePU', 'nTruePU', 80, 0, 80)
      self.book(n,'nTruePU_MetEt', 'MetEt vs nTruePU', 80, 0, 80, 400, 0, 400, type=ROOT.TH2F)
#      self.book(n, 'j1Pt', 'Leading Jet pT', 470, 30, 500)
#      self.book(n, 'j1Eta', 'j1Eta', 100, -5, 5)
#      self.book(n, 'DeltaR_em_j1', 'Delta R of Electron-Muon and leading Jet', 80, 0, 8)
#      self.book(n, 'j2Pt', 'Subleading Jet pT', 200, 30, 200)
#      self.book(n, 'j2Eta', 'j2Eta', 100, -5, 5)
#      self.book(n, 'DeltaR_em_j2', 'Delta R of Electron-Muon and sub-leading Jet', 70, 0, 7)
#      self.book(n, 'R_pT', 'pT Balance Ratio', 100, 0, 1)
#      self.book(n, 'DeltaEta_j1_j2', 'Delta Eta of Jets', 80, 0, 8)
#      self.book(n, 'Ht', 'Scalar Sum of Jets Pt', 1000, 0, 1000)

#      self.book(n,'MVA_ePt_Per_e_m_Mass', 'Electron pT per Electron + Muon Mass', 200, -1, 1, 20, 0, 2, type=ROOT.TH2F)
#      self.book(n,'MVA_mPt_Per_e_m_Mass', 'Muon pT per Electron + Muon Mass', 200, -1, 1, 20, 0, 2, type=ROOT.TH2F)
#      self.book(n,'MVA_emEta', 'Electron + Muon Eta', 200, -1, 1, 140, -7, 7, type=ROOT.TH2F)
#      self.book(n,'MVA_DeltaR_e_m', 'Delta R of Electron and Muon', 200, -1, 1, 45, 0, 4.5, type=ROOT.TH2F)
#      self.book(n,'MVA_m_met_mT_Per_e_m_Mass', 'Muon + MET Transverse Mass', 200, -1, 1, 35, 0, 3.5, type=ROOT.TH2F)
#      self.book(n,'MVA_e_met_mT_Per_e_m_Mass', 'Electron + MET Transverse Mass', 200, -1, 1, 35, 0, 3.5, type=ROOT.TH2F)
      self.book(n,'MVA_MetEt', 'MET E_T', 200, -1, 1, 400, 0, 400, type=ROOT.TH2F)
      self.book(n,'MVA_PU', 'MET E_T', 200, -1, 1, 80, 0, 80, type=ROOT.TH2F)
#      self.book(n,'MVA_j1Pt', 'Leading Jet pT', 200, -1, 1, 470, 30, 500, type=ROOT.TH2F)
#      self.book(n,'MVA_j1Eta', 'j1Eta', 200, -1, 1, 100, -5, 5, type=ROOT.TH2F)
#      self.book(n,'MVA_DeltaR_em_j1', 'Delta R of Electron-Muon and leading Jet', 200, -1, 1, 80, 0, 8, type=ROOT.TH2F)
#      self.book(n,'MVA_j2Pt', 'Subleading Jet pT', 200, -1, 1, 200, 30, 200, type=ROOT.TH2F)
#      self.book(n,'MVA_j2Eta', 'j2Eta', 200, -1, 1, 100, -5, 5, type=ROOT.TH2F)
#      self.book(n,'MVA_DeltaR_em_j2', 'Delta R of Electron-Muon and sub-leading Jet', 200, -1, 1, 70, 0, 7, type=ROOT.TH2F)
#      self.book(n,'MVA_R_pT', 'pT Balance Ratio', 200, -1, 1, 10, 0, 1, type=ROOT.TH2F)
#      self.book(n,'MVA_DeltaEta_j1_j2', 'Delta Eta of Jets', 200, -1, 1, 80, 0, 8, type=ROOT.TH2F)
#      self.book(n,'MVA_Ht', 'Scalar Sum of Jets Pt', 200, -1, 1, 1000, 0, 1000, type=ROOT.TH2F)

#      self.book(n, 'emPt', 'Electron + Muon Pt', 240, 0, 240)
#      self.book(n, 'DeltaEta_e_m', 'Delta Eta of Electron and Muon', 35, 0, 3.5)
#      self.book(n, 'DeltaEta_em_j1', 'Delta Eta of Electron + Muon and Leading Jet', 60, 0, 6)
#      self.book(n, 'DeltaPhi_em_j1', 'Delta Phi of Electron and Leading Jet', 32, 0, 3.2)
#      self.book(n, 'DeltaEta_em_j2', 'Delta Eta of Electron + Muon and Subleading Jet', 50, 0, 5)
#      self.book(n, 'DeltaPhi_em_j2', 'Delta Phi of Electron + Muon and Subleading Jet', 32, 0, 3.2)
#      self.book(n, 'DeltaEta_e_m', 'Delta Eta of Electron and Muon', 35, 0, 3.5)
#      self.book(n, 'DeltaPhi_e_m', 'Delta Phi of Muon and Electron', 32, 0, 3.2)
#      self.book(n, 'DeltaPhi_j1_j2', 'Delta Phi of Jets', 32, 0, 3.2)
#      self.book(n, 'Mjj', 'Jet + Jet Mass', 800, 0, 800)
#      self.book(n, 'cen', 'Cen', 10, 0, 1.05)
#      self.book(n, 'DeltaPhi_e_met', 'Delta Phi of Electron and MET', 32, 0, 3.2)
#      self.book(n, 'DeltaPhi_m_met', 'Delta Phi of Muon and MET', 32, 0, 3.2)
#      self.book(n, 'DeltaEta_e_met', 'Delta Eta of Electron and MET', 26, 0, 2.6)
#      self.book(n, 'DeltaEta_m_met', 'Delta Eta of Muon and MET', 25, 0, 2.5)
#      self.book(n, 'e_m_PZeta', 'Electron + Muon PZeta', 550, -200, 350)

#      self.book(n, 'mEta', 'Muon Eta', 50, -2.5, 2.5)
#      self.book(n, 'eEta', 'Electron Eta', 50, -2.5, 2.5)
#      self.book(n, 'AbsmEta', 'Muon Eta', 25, 0, 2.5)
#      self.book(n, 'AbseEta', 'Electron Eta', 25, 0, 2.5)
#      self.book(n, 'emEta', 'emEta', 50, -2.5, 2.5, 50, -2.5, 2.5, type=ROOT.TH2F)
#      self.book(n, 'AbsemEta', 'emEta', 25, 0, 2.5, 25, 0, 2.5, type=ROOT.TH2F)
##      self.book(n, 'Zeppenfeld', 'Zeppenfeld Variable', 100, -5, 5)
#      self.book(n, 'e_m_Mass', 'Electron + Muon Mass', 5000, 110, 160)

#      self.book(n, 'ePt', 'Electron pT', 200, 0, 200)
#      self.book(n, 'mPt', 'Muon pT', 200, 0, 200)
#      self.book(n, 'deltaEta', 'DeltaEta Jets', 5, 0, 5)

  def fill_histos(self, myEle, myMuon, myMET, myJet1, myJet2, njets, mva, PU, weight, name=''):
    histos = self.histograms
#    histos[name+'/ePt_Per_e_m_Mass'].Fill(myEle.Pt()/self.visibleMass(myEle, myMuon), weight)
#    histos[name+'/mPt_Per_e_m_Mass'].Fill(myMuon.Pt()/self.visibleMass(myEle, myMuon), weight)
#    histos[name+'/emEta'].Fill((myEle + myMuon).Eta(), weight)
#    histos[name+'/DeltaR_e_m'].Fill(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()), weight)
#    histos[name+'/m_met_mT_Per_e_m_Mass'].Fill(self.transverseMass(myMuon, myMET)/self.visibleMass(myEle, myMuon), weight)
#    histos[name+'/e_met_mT_Per_e_m_Mass'].Fill(self.transverseMass(myEle, myMET)/self.visibleMass(myEle, myMuon), weight)
    histos[name+'/MetEt'].Fill(myMET.Et(), weight)
    histos[name+'/nTruePU'].Fill(PU, weight)
    histos[name+'/nTruePU_MetEt'].Fill(PU, myMET.Et(), weight)
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)
#    if (njets!=0):
#      histos[name+'/j1Pt'].Fill(myJet1.Pt(), weight)
#      histos[name+'/j1Eta'].Fill(myJet1.Eta(), weight)
#      histos[name+'/DeltaR_em_j1'].Fill(self.deltaR((myEle + myMuon).Phi(), myJet1.Phi(), (myEle + myMuon).Eta(), myJet1.Eta()), weight)
#    if (njets>=2):
#      histos[name+'/j2Pt'].Fill(myJet2.Pt(), weight)
#      histos[name+'/j2Eta'].Fill(myJet2.Eta(), weight)
#      histos[name+'/DeltaR_em_j2'].Fill(self.deltaR((myEle + myMuon).Phi(), myJet2.Phi(), (myEle + myMuon).Eta(), myJet2.Eta()), weight)
#      histos[name+'/DeltaEta_j1_j2'].Fill(self.deltaEta(myJet1.Eta(), myJet2.Eta()) , weight)
#      histos[name+'/R_pT'].Fill(abs((myMuon+myEle+myJet1+myJet2).Pt())/(myMuon.Pt()+myEle.Pt()+myJet1.Pt()+myJet2.Pt()), weight)
#    if (njets>2):
#      histos[name+'/Ht'].Fill(Ht, weight)
#
#    histos[name+'/MVA_ePt_Per_e_m_Mass'].Fill(mva, myEle.Pt()/self.visibleMass(myEle, myMuon), weight)
#    histos[name+'/MVA_mPt_Per_e_m_Mass'].Fill(mva, myMuon.Pt()/self.visibleMass(myEle, myMuon), weight)
#    histos[name+'/MVA_emEta'].Fill(mva, (myEle + myMuon).Eta(), weight)
#    histos[name+'/MVA_DeltaR_e_m'].Fill(mva, self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()), weight)
#    histos[name+'/MVA_m_met_mT_Per_e_m_Mass'].Fill(mva, self.transverseMass(myMuon, myMET)/self.visibleMass(myEle, myMuon), weight)
#    histos[name+'/MVA_e_met_mT_Per_e_m_Mass'].Fill(mva, self.transverseMass(myEle, myMET)/self.visibleMass(myEle, myMuon), weight)
    histos[name+'/MVA_MetEt'].Fill(mva, myMET.Et(), weight)
    histos[name+'/MVA_PU'].Fill(mva, PU, weight)
#    if (njets!=0):
#      histos[name+'/MVA_j1Pt'].Fill(mva, myJet1.Pt(), weight)
#      histos[name+'/MVA_j1Eta'].Fill(mva, myJet1.Eta(), weight)
#      histos[name+'/MVA_DeltaR_em_j1'].Fill(mva, self.deltaR((myEle + myMuon).Phi(), myJet1.Phi(), (myEle + myMuon).Eta(), myJet1.Eta()), weight)
#    if (njets>=2):
#      histos[name+'/MVA_j2Pt'].Fill(mva, myJet2.Pt(), weight)
#      histos[name+'/MVA_j2Eta'].Fill(mva, myJet2.Eta(), weight)
#      histos[name+'/MVA_DeltaR_em_j2'].Fill(mva, self.deltaR((myEle + myMuon).Phi(), myJet2.Phi(), (myEle + myMuon).Eta(), myJet2.Eta()), weight)
#      histos[name+'/MVA_DeltaEta_j1_j2'].Fill(mva, self.deltaEta(myJet1.Eta(), myJet2.Eta()) , weight)
#      histos[name+'/MVA_R_pT'].Fill(mva, abs((myMuon+myEle+myJet1+myJet2).Pt())/(myMuon.Pt()+myEle.Pt()+myJet1.Pt()+myJet2.Pt()), weight)
#    if (njets>2):
#      histos[name+'/MVA_Ht'].Fill(mva, Ht, weight)
##      histos[name+'/DeltaEta_em_j1'].Fill(self.deltaEta((myEle + myMuon).Eta(), myJet1.Eta()), weight)
##      histos[name+'/DeltaPhi_em_j1'].Fill(self.deltaPhi((myEle + myMuon).Phi(), myJet1.Phi()), weight)
#      histos[name+'/cen'].Fill(math.exp(self.Zeppenfeld(myEle, myMuon, myJet1, myJet2)**2*-4/((myJet1.Eta()-myJet2.Eta())**2)), weight)
#      histos[name+'/Mjj'].Fill(mjj, weight) 
#      histos[name+'/DeltaEta_em_j2'].Fill(self.deltaEta((myEle + myMuon).Eta(), myJet2.Eta()), weight)
#      histos[name+'/DeltaPhi_em_j2'].Fill(self.deltaPhi((myEle + myMuon).Phi(), myJet2.Phi()), weight)
#      histos[name+'/DeltaPhi_j1_j2'].Fill(self.deltaPhi(myJet1.Phi(), myJet2.Phi()), weight)

#    histos[name+'/emPt'].Fill((myEle + myMuon).Pt(), weight)
#    histos[name+'/DeltaEta_e_m'].Fill(self.deltaEta(myEle.Eta(), myMuon.Eta()), weight)
#    histos[name+'/DeltaPhi_e_m'].Fill(self.deltaPhi(myEle.Phi(), myMuon.Phi()), weight)
#    histos[name+'/DeltaPhi_e_met'].Fill(self.deltaPhi(myEle.Phi(), myMET.Phi()), weight)
#    histos[name+'/DeltaPhi_m_met'].Fill(self.deltaPhi(myMuon.Phi(), myMET.Phi()), weight)
#    histos[name+'/DeltaEta_e_met'].Fill(self.deltaEta(myEle.Eta(), myMET.Eta()), weight)
#    histos[name+'/DeltaEta_m_met'].Fill(self.deltaEta(myMuon.Eta(), myMET.Eta()), weight)
#    histos[name+'/e_m_PZeta'].Fill(e_m_PZeta, weight)

#    histos[name+'/AbsemEta'].Fill(abs(myEle.Eta()), abs(myMuon.Eta()), weight)
#    histos[name+'/Zeppenfeld'].Fill(self.Zeppenfeld(myEle, myMuon, myJet1, myJet2), weight)

#    histos[name+'/e_m_Mass'].Fill(self.visibleMass(myEle, myMuon), weight)
#    histos[name+'/eEta'].Fill(myEle.Eta(), weight)
#    histos[name+'/AbseEta'].Fill(abs(myEle.Eta()), weight)
#    histos[name+'/mEta'].Fill(myMuon.Eta(), weight)
#    histos[name+'/AbsmEta'].Fill(abs(myMuon.Eta()), weight)
#    histos[name+'/ePt'].Fill(myEle.Pt(), weight)
#    histos[name+'/mPt'].Fill(myMuon.Pt(), weight)
#    histos[name+'/deltaEta'].Fill(self.deltaEta(myJet1.Eta(), myJet2.Eta()), weight)
   
  # Selections
  def eventSel(self, row):
    njets = row.jetVeto30
    if self.filters(row):
      return False
    elif not self.trigger(row):
      return False
    elif not self.kinematics(row):
      return False
    elif self.deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.3:
      return False
    elif self.Emb and self.is_DY and not bool(row.isZmumu or row.isZee):
      return False
#    elif njets > 2:
#      return False
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

#  def vbfSel(self, row):
#    if self.Zeppenfeld(row.eEta, row.mEta, row.j1etaWoNoisyJets, row.j2etaWoNoisyJets) > 2.5:
#      return False
#    elif self.deltaEta(row.j1etaWoNoisyJets, row.j2etaWoNoisyJets) < 3:
#      return False
#    elif self.deltaPhi(self.sumPhi(row.ePhi, row.mPhi), self.sumPhi(row.j1phiWoNoisyJets, row.j2phiWoNoisyJets)) < 2.6:
#      return False
#    else:
#      return True
    
  def jetVec(self,row):
    myJet1 = ROOT.TLorentzVector()
    myJet1.SetPtEtaPhiM(row.j1pt, row.j1eta, row.j1phi, 0)
    myJet2 = ROOT.TLorentzVector()
    myJet2.SetPtEtaPhiM(row.j2pt, row.j2eta, row.j2phi, 0)
    return [myJet1, myJet2]
    
  # TVector
  def lepVec(self, row):
    myEle = ROOT.TLorentzVector()
    myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
    myMET = ROOT.TLorentzVector()
    myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)
    myMuon = ROOT.TLorentzVector()
    myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)
    # Recoil
    if self.is_recoilC and self.MetCorrection:
      if self.is_W:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30 + 1)))
      else:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
      myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)
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
      self.w1.var('e_pt').setVal(myEle.Pt())
      self.w1.var('e_eta').setVal(myEle.Eta())
      eID = self.eIDnoiso80(myEle.Eta(), myEle.Pt())

      eff_trg_data = 0
      eff_trg_mc = 0
      if self.is_eraG or self.is_eraH:
        triggerm8e23 = row.mu8e23DZPass
        triggerm23e12 = row.mu23e12DZPass
      else:
        triggerm8e23 = row.mu8e23Pass
        triggerm23e12 = row.mu23e12Pass

      if triggerm8e23 and triggerm23e12:
        eff_trg_data += self.w1.function('e_trg_23_ic_data').getVal()*self.w1.function('m_trg_23_ic_data').getVal()
        eff_trg_mc += self.w1.function('e_trg_23_ic_mc').getVal()*self.w1.function('m_trg_23_ic_mc').getVal()

      if self.trigger24(row):
        eff_trg_data += self.triggerEff24(myMuon.Pt(), abs(myMuon.Eta()))[1]
        eff_trg_mc += self.triggerEff24(myMuon.Pt(), abs(myMuon.Eta()))[2]
    
      if triggerm8e23 and triggerm23e12 and self.trigger24(row):
        eff_trg_data -= self.w1.function('e_trg_23_ic_data').getVal()*self.triggerEff24(myMuon.Pt(), abs(myMuon.Eta()))[1]
        eff_trg_mc -= self.w1.function('e_trg_23_ic_mc').getVal()*self.triggerEff24(myMuon.Pt(), abs(myMuon.Eta()))[2]

      tEff = 0 if eff_trg_mc==0 else eff_trg_data/eff_trg_mc




#      if triggerm23e12:
#        eff_trg_data = eff_trg_data + self.w1.function("m_trg_23_ic_data").getVal()*self.w1.function("e_trg_12_ic_data").getVal()
#        eff_trg_mc = eff_trg_mc + self.w1.function("m_trg_23_ic_mc").getVal()*self.w1.function("e_trg_12_ic_mc").getVal()
#      if triggerm8e23:
#        eff_trg_data = eff_trg_data + self.w1.function("m_trg_8_ic_data").getVal()*self.w1.function("e_trg_23_ic_data").getVal()
#        eff_trg_mc = eff_trg_mc + self.w1.function("m_trg_8_ic_mc").getVal()*self.w1.function("e_trg_23_ic_mc").getVal()
#      if triggerm23e12 and triggerm8e23:
#        eff_trg_data = eff_trg_data - self.w1.function("m_trg_23_ic_data").getVal()*self.w1.function("e_trg_23_ic_data").getVal()
#        eff_trg_mc = eff_trg_mc - self.w1.function("m_trg_23_ic_mc").getVal()*self.w1.function("e_trg_23_ic_mc").getVal()



#      tEff = self.triggerEff24(myMuon.Pt(), abs(myMuon.Eta()))[0]
#      eff_trg_data = self.w1.function('e_trg_23_ic_data').getVal()*self.w1.function('m_trg_23_ic_data').getVal()
#      eff_trg_mc = self.w1.function('e_trg_23_ic_mc').getVal()*self.w1.function('m_trg_23_ic_mc').getVal()
#      tEff = 0 if eff_trg_mc==0 else eff_trg_data/eff_trg_mc
      mID = self.muonTightID(myMuon.Eta(), myMuon.Pt())
      mIso = self.muonTightIsoTightID(myMuon.Eta(), myMuon.Pt())
      mTrk = self.muTracking(myMuon.Eta())[0]
      weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*eID*mID*mIso*mTrk*row.prefiring_weight
      if self.is_DY:
        # DY pT reweighting
        dyweight = self.DYreweight(row.genMass, row.genpT)
        weight = weight * dyweight
        if row.numGenJets < 5:
          weight = weight*self.DYweight[row.numGenJets]
        else:
          weight = weight*self.DYweight[0]
      if self.is_W:
        if row.numGenJets < 5:
          weight = weight*self.Wweight[row.numGenJets]
        else:
          weight = weight*self.Wweight[0]
      weight = self.mcWeight.lumiWeight(weight)
      if weight > 10:
        weight = 0

    njets = row.jetVeto30
    mjj = row.vbfMass


    self.w1.var('njets').setVal(njets)
    self.w1.var('dR').setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()))
    self.w1.var('e_pt').setVal(myEle.Pt())
    self.w1.var('m_pt').setVal(myMuon.Pt())
    osss = self.w1.function('em_qcd_osss').getVal()

    # b-tag
    nbtag = row.bjetDeepCSVVeto20Medium_2016_DR0p5
    if nbtag > 2:
      nbtag = 2
    if (self.is_mc and nbtag > 0):
      btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 0)
      weight = weight * btagweight
    if (bool(self.is_data or self.is_embed) and nbtag > 0):
      weight = 0

    return [weight, osss]

