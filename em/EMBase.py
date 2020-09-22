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
from FinalStateAnalysis.TagAndProbe.bTagSF2017 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class EMBase():
  tree = 'em/final/Ntuple'

  def __init__(self):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_mc = self.mcWeight.is_mc
    self.is_GluGlu = self.mcWeight.is_GluGlu
    self.is_VBF = self.mcWeight.is_VBF
    self.is_data = self.mcWeight.is_data
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_W = self.mcWeight.is_W
    self.is_TT = self.mcWeight.is_TT
    self.is_ST = self.mcWeight.is_ST
    self.is_VV = self.mcWeight.is_VV
    self.is_GluGlu = self.mcWeight.is_GluGlu
    self.is_VBF = self.mcWeight.is_VBF

    self.Emb = False
    self.is_recoilC = self.mcWeight.is_recoilC
    self.MetCorrection = self.mcWeight.MetCorrection
    if self.is_recoilC and self.MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
      self.MetSys = mcCorrections.MetSys

    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muTracking = mcCorrections.muonTracking
    self.eIDnoiso80 = mcCorrections.eIDnoiso80
    self.eReco = mcCorrections.eReco

    self.DYweight = self.mcWeight.DYweight
    self.Wweight = self.mcWeight.Wweight
   
    self.DYreweight = mcCorrections.DYreweight
    self.w1 = mcCorrections.w1
    self.rc = mcCorrections.rc

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight
    self.invert_case = Kinematics.invert_case
    self.Zeppenfeld = Kinematics.Zeppenfeld
    self.plotnames = Kinematics.plotnames
    #self.functor_vbf = Kinematics.functor_vbf
    self.functor_gg = Kinematics.functor_gg
    self.var_d_gg_0 = Kinematics.var_d_gg_0
    self.var_d_gg_1 = Kinematics.var_d_gg_1
    self.var_d_gg_2 = Kinematics.var_d_gg_2
    #self.var_d_vbf = Kinematics.var_d_vbf
    self.bdtnames = Kinematics.bdtnames
#    self.branches='mPt/F:ePt/F:e_m_Mass/F:type1_pfMetEt/F:itype/I:cat/I:weight/F'
    self.holders = []
    self.name='opttree'
    self.title='opttree'

    self.branches='Nj/F:mPt_Per_e_m_Mass/F:ePt_Per_e_m_Mass/F:e_m_Mass/F:emPt/F:emEta/F:mEta/F:eEta/F:j1Pt/F:j2Pt/F:j1Eta/F:j2Eta/F:DeltaEta_em_j1/F:DeltaPhi_em_j1/F:DeltaEta_em_j2/F:DeltaPhi_em_j2/F:DeltaEta_j1_j2/F:DeltaPhi_j1_j2/F:Zeppenfeld/F:j1_j2_mass/F:minDeltaPhi_em_j1j2/F:minDeltaEta_em_j1j2/F:m_met_mT/F:e_met_mT/F:DeltaPhi_e_met/F:DeltaPhi_m_met/F:DeltaEta_e_met/F:DeltaEta_m_met/F:MetEt/F:e_m_PZeta/F:R_pT/F:pT_cen/F:weight/F'

    self.cutparms = Kinematics.SensitivityParser()
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
    triggerm8e23 = row.mu8e23DZPass
    triggerm23e12 = row.mu23e12DZPass
    return bool(triggerm8e23 or triggerm23e12)

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
    for n in Kinematics.plotnames :
      self.book(n, 'emEta', 'Electron + Muon Eta', 200, -10, 10)
      self.book(n, 'DeltaEta_m_met', 'Delta Eta of Muon and MET', 25, 0, 2.5)
      self.book(n, 'DeltaEta_e_met', 'Delta Eta of Electron and MET', 25, 0, 2.5)
      self.book(n, 'DeltaPhi_m_met', 'Delta Phi of Muon and MET', 40, 0, 4)
      self.book(n, 'MetEt', 'MET E_T', 400, 0, 400)
      self.book(n, 'DeltaPhi_e_met', 'Delta Phi of Electron and MET', 40, 0, 4)
      self.book(n, 'emPt', 'Electron + Muon Pt', 300, 0, 300)
      self.book(n, 'ePt_Per_e_m_Mass', 'Electron pT per Electron + Muon Mass', 20, 0, 2)
      self.book(n, 'e_met_mT', 'Electron + MET Transverse Mass', 400, 0, 400)
      self.book(n, 'mPt_Per_e_m_Mass', 'Muon pT per Electron + Muon Mass', 20, 0, 2)
      self.book(n, 'm_met_mT', 'Muon + MET Transverse Mass', 400, 0, 400)
      self.book(n, 'e_m_PZeta', 'Electron + Muon PZeta', 600, -200, 400)
      self.book(n, 'DeltaPhi_em_j1', 'Delta Phi of Electron and Leading Jet', 35, 0, 3.5)
      self.book(n, 'j1Pt', 'Leading Jet pT', 1000, -500, 500)
      self.book(n, 'j2Pt', 'Subleading Jet pT', 1000, -500, 500)
      self.book(n, 'DeltaEta_em_j1', 'Delta Eta of Electron + Muon and Leading Jet', 80, 0, 8)
      self.book(n, 'DeltaEta_em_j2', 'Delta Eta of Electron + Muon and Subleading Jet', 80, 0, 8)
      self.book(n, 'DeltaPhi_em_j2', 'Delta Phi of Electron + Muon and Subleading Jet', 35, 0, 3.5)
      self.book(n, 'DeltaEta_j1_j2', 'Delta Eta of Jets', 60, 0, 6)
      self.book(n, 'DeltaPhi_j1_j2', 'Delta Phi of Jets', 35, 0, 3.5)
#      self.book(n, 'Zeppenfeld', 'Zeppenfeld Variable', 100, -5, 5)
#      self.book(n, 'R_pT', 'pT Balance Ratio', 10, 0, 1)
      self.book(n, 'e_m_Mass', 'Electron + Muon Mass', 500, 110, 160)
      self.book(n, 'deltaR', 'DeltaR Electron and Muon', 40, 0, 4)
      self.book(n, 'MET', 'MET', 400, 0, 400)
      self.book(n, 'ePt', 'Electron pT', 100, 0, 100)
      self.book(n, 'mPt', 'Muon pT', 100, 0, 100)
      self.book(n, 'deltaEta', 'DeltaEta Jets', 5, 0, 5)
      self.book(n, 'Mjj', 'Jet + Jet Mass', 1000, 0, 1000)
      self.book(n, 'j2Eta', 'j2Eta', 10, -5, 5)

#  def fill_histos(self, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, name=''):
#    histos = self.histograms
#    if (njets!=0):
#      histos[name+'/j1Pt'].Fill(myJet1.Pt(), weight)
#    if (njets==2):
#      histos[name+'/j2Pt'].Fill(myJet2.Pt(), weight)



  def fill_histos(self, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, name=''):
    histos = self.histograms
    histos[name+'/emEta'].Fill((myEle + myMuon).Eta(), weight)
    histos[name+'/DeltaEta_m_met'].Fill(self.deltaEta(myMuon.Eta(), myMET.Eta()), weight)
    histos[name+'/DeltaEta_e_met'].Fill(self.deltaEta(myEle.Eta(), myMET.Eta()), weight)
    histos[name+'/DeltaPhi_m_met'].Fill(self.deltaPhi(myMuon.Phi(), myMET.Phi()), weight)
    histos[name+'/MetEt'].Fill(myMET.Et(), weight)
    histos[name+'/DeltaPhi_e_met'].Fill(self.deltaPhi(myEle.Phi(), myMET.Phi()), weight)
    histos[name+'/emPt'].Fill((myEle + myMuon).Pt(), weight)
    histos[name+'/ePt_Per_e_m_Mass'].Fill(myEle.Pt()/self.visibleMass(myEle, myMuon), weight)
    histos[name+'/e_met_mT'].Fill(self.transverseMass(myEle, myMET), weight)
    histos[name+'/mPt_Per_e_m_Mass'].Fill(myMuon.Pt()/self.visibleMass(myEle, myMuon), weight)
    histos[name+'/m_met_mT'].Fill(self.transverseMass(myMuon, myMET), weight)
    histos[name+'/e_m_PZeta'].Fill(e_m_PZeta, weight)
    if (njets!=0):
      histos[name+'/DeltaPhi_em_j1'].Fill(self.deltaPhi((myEle + myMuon).Phi(), myJet1.Phi()), weight)
      histos[name+'/j1Pt'].Fill(myJet1.Pt(), weight)
      histos[name+'/DeltaEta_em_j1'].Fill(self.deltaEta((myEle + myMuon).Eta(), myJet1.Eta()), weight)
    if (njets==2):
      histos[name+'/DeltaEta_em_j2'].Fill(self.deltaEta((myEle + myMuon).Eta(), myJet2.Eta()), weight)
      histos[name+'/DeltaPhi_em_j2'].Fill(self.deltaPhi((myEle + myMuon).Phi(), myJet2.Phi()), weight)
      histos[name+'/DeltaEta_j1_j2'].Fill(self.deltaEta(myJet1.Eta(), myJet2.Eta()) , weight)
      histos[name+'/DeltaPhi_j1_j2'].Fill(self.deltaPhi(myJet1.Phi(), myJet2.Phi()), weight)
#     histos[name+'/Zeppenfeld'].Fill(self.Zeppenfeld(myEle, myMuon, myJet1, myJet2), weight)
#     histos[name+'/R_pT'].Fill(abs((myMuon+myEle+myJet1+myJet2).Pt())/(myMuon.Pt()+myEle.Pt()+myJet1.Pt()+myJet2.Pt()), weight)

    histos[name+'/e_m_Mass'].Fill(self.visibleMass(myEle, myMuon), weight)
    histos[name+'/deltaR'].Fill(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()), weight)
    histos[name+'/MET'].Fill(myMET.Pt(), weight)
    histos[name+'/ePt'].Fill(myEle.Pt(), weight)
    histos[name+'/mPt'].Fill(myMuon.Pt(), weight)
    histos[name+'/deltaEta'].Fill(self.deltaEta(myJet1.Eta(), myJet2.Eta()), weight)
    histos[name+'/j2Eta'].Fill(myJet2.Eta(), weight)
    histos[name+'/Mjj'].Fill(mjj, weight) 
   
  # Selections
  def eventSel(self, row):
    njets = row.jetVeto30WoNoisyJets
    if self.filters(row):
      return False
    elif not self.trigger(row):
      return False
    elif not self.kinematics(row):
      return False
    elif self.deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.5:
      return False
    elif self.Emb and self.is_DY and not bool(row.isZmumu or row.isZee):
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
    # Recoil
    if self.is_recoilC and self.MetCorrection:
      if self.is_W:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30WoNoisyJets + 1)))
      else:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30WoNoisyJets)))
        
      myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)
    # Electron Scale Correction
    if self.is_data:
      myEle = myEle * ROOT.Double(row.eCorrectedEt/myEle.E())
    else:
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      if self.is_mc:
        myEle = myEle * ROOT.Double(row.eCorrectedEt/myEle.E())
      myMETpx = myMETpx - myEle.Px()
      myMETpy = myMETpy - myEle.Py()
      myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
    return [myEle, myMET, myMuon]

  def corrFact(self, row, myEle, myMuon):
    # Apply all the various corrections to the MC samples
    weight = 1.0
    if self.is_mc:
      self.w1.var('e_pt').setVal(myEle.Pt())
      self.w1.var('e_eta').setVal(myEle.Eta())
      self.w1.var('m_pt').setVal(myMuon.Pt())
      self.w1.var('m_eta').setVal(myMuon.Eta())
      eff_trg_data = self.w1.function('e_trg_23_ic_data').getVal()*self.w1.function('m_trg_23_ic_data').getVal()
      eff_trg_mc = self.w1.function('e_trg_23_ic_mc').getVal()*self.w1.function('m_trg_23_ic_mc').getVal()
      tEff = 0 if eff_trg_mc==0 else eff_trg_data/eff_trg_mc
      eID = self.eIDnoiso80(myEle.Eta(), myEle.Pt())
      eReco = self.eReco(myEle.Eta(), myEle.Pt())
      mID = self.muonTightID(myMuon.Pt(), abs(myMuon.Eta()))
      mIso = self.muonTightIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
      mTrk = self.muTracking(myMuon.Eta())[0]
      zvtx = 0.991
      mcSF = self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
      weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*eID*eReco*mID*mIso*mTrk*zvtx*mcSF*row.prefiring_weight
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
#      if self.is_TT:
#        topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
#        weight = weight*topweight
      weight = self.mcWeight.lumiWeight(weight)

    njets = row.jetVeto30WoNoisyJets
    mjj = row.vbfMassWoNoisyJets

    self.w1.var('njets').setVal(njets)
    self.w1.var('dR').setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()))
    self.w1.var('e_pt').setVal(myEle.Pt())
    self.w1.var('m_pt').setVal(myMuon.Pt())
    osss = self.w1.function('em_qcd_osss').getVal()

    # b-tag
    nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
    if nbtag > 2:
      nbtag = 2
    if (self.is_mc and nbtag > 0):
      btagweight = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 0, 0)
      weight = weight * btagweight
    if (bool(self.is_data or self.is_embed) and nbtag > 0):
      weight = 0

    return [weight, osss]

