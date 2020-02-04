'''

Run LFV H->MuTau analysis in the mu+tau_h channel.

Authors: Prasanna Siddireddy

'''

import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import array
import mcCorrections
import mcWeights
import Kinematics
import FakeRate
from bTagSF import bTagEventWeight

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = False

class AnalyzeMuTauBDT(MegaBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_DY = self.mcWeight.is_DY
    self.is_TT = self.mcWeight.is_TT
    self.is_mc = self.mcWeight.is_mc
    self.is_GluGlu = self.mcWeight.is_GluGlu
    self.is_VBF = self.mcWeight.is_VBF

    self.is_recoilC = self.mcWeight.is_recoilC
    if self.is_recoilC and MetCorrection:
      self.Metcorected = mcCorrections.Metcorected

    self.triggerEff22 = mcCorrections.muonTrigger22
    self.triggerEff24 = mcCorrections.muonTrigger24
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muonLooseIsoTightID = mcCorrections.muonIso_loose_tightid
    self.muTracking = mcCorrections.muonTracking
    self.deepTauVSe = mcCorrections.deepTauVSe
    self.deepTauVSmu = mcCorrections.deepTauVSmu
    self.deepTauVSjet_tight = mcCorrections.deepTauVSjet_tight
    self.deepTauVSjet_vloose = mcCorrections.deepTauVSjet_vloose
    self.deepTauVSjet_Emb_tight = mcCorrections.deepTauVSjet_Emb_tight
    self.deepTauVSjet_Emb_vloose = mcCorrections.deepTauVSjet_Emb_vloose
    self.esTau = mcCorrections.esTau
    self.FesTau = mcCorrections.FesTau
    self.ScaleTau = mcCorrections.ScaleTau
    self.DYreweight = mcCorrections.DYreweight
    self.w1 = mcCorrections.w1
    self.rc = mcCorrections.rc

    self.fakeRate = FakeRate.fakerateDeep_weight
    self.fakeRateMuon = FakeRate.fakerateMuon_weight

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight
    self.invert_case = Kinematics.invert_case

    self.branches='mPt/F:tPt/F:dPhiMuTau/F:dEtaMuTau/F:type1_pfMetEt/F:m_t_collinearMass/F:MTTauMET/F:dPhiTauMET/F:dPhiMuMET/F:m_t_visibleMass/F:m_t_PZeta/F:MTMuMET/F:njets/I:vbfMass/F:weight/F'

    self.holders = []
    if self.is_GluGlu or self.is_VBF:
      self.name='TreeS'
      self.title='TreeS'
    else:
      self.name='TreeB'
      self.title='TreeB'

    super(AnalyzeMuTauBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.mCharge*row.tCharge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 26 or abs(row.mEta) >= 2.1:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False


  def obj1_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))


  def obj1_tight(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)


  def obj1_loose(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.25)


  def obj2_id(self, row):
    return (bool(row.tDecayModeFindingNewDMs > 0.5) and bool(row.tVLooseDeepTau2017v2p1VSe > 0.5) and bool(row.tTightDeepTau2017v2p1VSmu > 0.5) and bool(abs(row.tPVDZ) < 0.2))


  def obj2_tight(self, row):
    return bool(row.tTightDeepTau2017v2p1VSjet > 0.5)


  def obj2_loose(self, row):
    return bool(row.tVLooseDeepTau2017v2p1VSjet > 0.5)


  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def dimuonveto(self, row):
    return bool(row.dimuonVeto < 0.5)


  def begin(self):
    branch_names = self.branches.split(':')
    self.tree1 = ROOT.TTree(self.name, self.title)
    for name in branch_names:
      try:
        varname, vartype = tuple(name.split('/'))
      except:
        raise ValueError('Problem parsing %s' % name)
      inverted_type = self.invert_case(vartype.rsplit('_', 1)[0])
      self.holders.append((varname, array.array(inverted_type, [0])))
    for name, varinfo in zip(branch_names, self.holders):
      varname, holder = varinfo
      self.tree1.Branch(varname, holder, name)


  def filltree(self, row, myMuon, myMET, myTau, weight):
    for varname, holder in self.holders:
      if varname=='mPt':
        holder[0] = myMuon.Pt()
      elif varname=='tPt':
        holder[0] = myTau.Pt()
      elif varname=='dPhiMuTau':
        holder[0] = self.deltaPhi(myMuon.Phi(), myTau.Phi())
      elif varname=='dEtaMuTau':
        holder[0] = self.deltaPhi(myMuon.Eta(), myTau.Eta())
      elif varname=='type1_pfMetEt':
        holder[0] = myMET.Et()
      elif varname=='m_t_collinearMass':
        holder[0] = self.collMass(myMuon, myMET, myTau)
      elif varname=='MTTauMET':
        holder[0] = self.transverseMass(myTau, myMET)
      elif varname=='dPhiTauMET':
        holder[0] = self.deltaPhi(myTau.Phi(), myMET.Phi())
      elif varname=='dPhiMuMET':
        holder[0] = self.deltaPhi(myMuon.Phi(), myMET.Phi())
      elif varname=='m_t_visibleMass':
        holder[0] = self.visibleMass(myMuon, myTau)
      elif varname=='m_t_PZeta':
        holder[0] = row.m_t_PZeta
      elif varname=='MTMuMET':
        holder[0] = self.transverseMass(myMuon, myMET)
      elif varname=='njets':
        holder[0] = int(row.jetVeto30)
      elif varname=='vbfMass':
        holder[0] = row.vbfMass
      elif varname=='weight':
        holder[0] = weight
    self.tree1.Fill()

  # Tau pT correction
  def tauPtC(self, row, myMET, myTau):
    tmpMET = myMET
    tmpTau = myTau
    if self.is_mc and not self.is_DY and row.tZTTGenMatching==5:
      es = self.esTau(row.tDecayMode)
      myMETpx = myMET.Px() + (1 - es[0]) * myTau.Px()
      myMETpy = myMET.Py() + (1 - es[0]) * myTau.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpTau = myTau * ROOT.Double(es[0])
    if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
      fes = self.FesTau(myTau.Eta(), row.tDecayMode)
      myMETpx = myMET.Px() + (1 - fes[0]) * myTau.Px()
      myMETpy = myMET.Py() + (1 - fes[0]) * myTau.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpTau = myTau * ROOT.Double(fes[0])
    return [tmpMET, tmpTau]


  def process(self):

    for row in self.tree:

      trigger24 = row.IsoMu24Pass and row.mMatchesIsoMu24Filter and row.mMatchesIsoMu24Path and row.mPt > 26

      if self.filters(row):
        continue

      if not bool(trigger24):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.tPhi, row.mPhi, row.tEta, row.mEta) < 0.5:
        continue

      if Emb and self.is_DY:
        if not bool(row.isZmumu or row.isZee):
          continue

      njets = row.jetVeto30
      if njets > 2:
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj2_id(row):
        continue

      if row.tDecayMode==5 or row.tDecayMode==6:
        continue

      if not self.vetos(row):
        continue

      if not self.dimuonveto(row):
        continue

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
        myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      myMET = self.tauPtC(row, myMET, myTau)[0]
      myTau = self.tauPtC(row, myMET, myTau)[1]

      weight = 1.0
      if self.is_mc:
        tEff = self.triggerEff24(myMuon.Pt(), abs(myMuon.Eta()))[0]
        mID = self.muonTightID(myMuon.Eta(), myMuon.Pt())
        if self.obj1_tight(row):
          mIso = self.muonTightIsoTightID(myMuon.Eta(), myMuon.Pt())
        else:
          mIso = self.muonLooseIsoTightID(myMuon.Eta(), myMuon.Pt())
        mTrk = self.muTracking(myMuon.Eta())[0]
        mcSF = self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
        weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mIso*mTrk*mcSF*row.prefiring_weight
        # Anti-Muon Discriminator Scale Factors
        if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
          weight = weight * self.deepTauVSmu(myTau.Eta())[0]
        # Anti-Electron Discriminator Scale Factors
        elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
          weight = weight * self.deepTauVSe(myTau.Eta())[0]
        # Tau ID Scale Factor
        elif row.tZTTGenMatching==5:
          if self.obj2_tight(row):
            weight = weight * self.deepTauVSjet_tight(myTau.Pt())[0]
          elif self.obj2_loose(row):
            weight = weight * self.deepTauVSjet_vloose(myTau.Pt())[0]
        if self.is_DY:
          # DY pT reweighting
          dyweight = self.DYreweight(row.genMass, row.genpT)
          weight = weight * dyweight
          if row.numGenJets < 5:
            weight = weight * self.DYweight[row.numGenJets]
          else:
            weight = weight * self.DYweight[0]
        if self.is_TT:
          topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*topweight
          if row.mZTTGenMatching > 2 and row.mZTTGenMatching < 6 and row.tZTTGenMatching > 2 and row.tZTTGenMatching < 6 and Emb:
            continue
        weight = self.mcWeight.lumiWeight(weight)

      nbtag = row.bjetDeepCSVVeto20Medium_2016_DR0p5
      if nbtag > 2:
        nbtag = 2
      if (self.is_mc and nbtag > 0):
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 0)
        weight = weight * btagweight
      if (bool(self.is_data) and nbtag > 0):
        weight = 0

      if self.is_data:
        if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
          frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
          frMuon = self.fakeRateMuon(myMuon.Pt())
          weight =  weight * frTau * frMuon * -1
          if not self.oppositesign(row):
            self.filltree(row, myMuon, myMET, myTau, weight)

        if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
          frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
          weight = weight * frTau
          if not self.oppositesign(row):
            self.filltree(row, myMuon, myMET, myTau, weight)

        if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
          frMuon = self.fakeRateMuon(myMuon.Pt())
          weight = weight * frMuon
          if not self.oppositesign(row):
            self.filltree(row, myMuon, myMET, myTau, weight)

      if self.is_mc:
        if self.obj2_tight(row) and self.obj1_tight(row):
          if self.oppositesign(row):
            self.filltree(row, myMuon, myMET, myTau, weight)


  def finish(self):
    self.tree1.Write()
    self.write_histos()
