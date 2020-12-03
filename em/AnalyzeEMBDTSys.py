'''

Run LFV H->EM analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import mcCorrections
import os
import EMTree
import ROOT
import math
import array
from FinalStateAnalysis.TagAndProbe.bTagSF2016 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeEMBDTSys(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMBDTSys, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)


  def begin(self):
    self.trees = {}
    branch_names = self.branches.split(':')
    for sys in self.bdtSys:
      self.trees[sys] = [ROOT.TTree(sys+"TreeS", sys+"TreeS"), ROOT.TTree(sys+"TreeB", sys+"TreeB"), ROOT.TTree(sys+"TreeSss", sys+"TreeSss"), ROOT.TTree(sys+"TreeBss", sys+"TreeBss")]   
    for name in branch_names:
      try:
          varname, vartype = tuple(name.split('/'))
      except:
        raise ValueError('Problem parsing %s' % name)
      inverted_type = self.invert_case(vartype.rsplit("_", 1)[0])
      self.holders.append((varname, array.array(inverted_type, [0])))
    for name, varinfo in zip(branch_names, self.holders):
      varname, holder = varinfo
      for treelist in self.trees.values():
        for tree in treelist:
          tree.Branch(varname, holder, name)

  def filltree(self, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, itype, sign, name):
    for varname, holder in self.holders:
      if varname=="mPt_Per_e_m_Mass":
        holder[0] = myMuon.Pt()/self.visibleMass(myEle, myMuon)
      elif varname=="ePt_Per_e_m_Mass":
        holder[0] = myEle.Pt()/self.visibleMass(myEle, myMuon)
      elif varname=="e_m_Mass":
        holder[0] = self.visibleMass(myEle, myMuon)
      elif varname=="emPt":
        holder[0] = (myEle + myMuon).Pt()
      elif varname=="emEta":
        holder[0] = (myEle + myMuon).Eta() 
      elif varname=="mEta":
        holder[0] = myMuon.Eta() 
      elif varname=="eEta":
        holder[0] = myEle.Eta() 
      elif varname=="j1Pt":
        if njets == 0:
          holder[0] = -1
        else:
          holder[0] = myJet1.Pt()
      elif varname=="j2Pt":
        if njets == 2:
          holder[0] = myJet2.Pt()
        else:
          holder[0] = -1
      elif varname=="j1Eta":
        if njets == 0:
          holder[0] = -10
        else:
          holder[0] = myJet1.Eta()
      elif varname=="j2Eta":
        if njets == 2:
          holder[0] = myJet2.Eta()
        else:
          holder[0] = -10
      elif varname=="DeltaEta_em_j1":
        if njets == 0:
          holder[0] = -1
        else:
          holder[0] = self.deltaEta((myEle + myMuon).Eta(), myJet1.Eta())
      elif varname=="DeltaPhi_em_j1":
        if njets == 0:
          holder[0] = -1
        else:
          holder[0] = self.deltaPhi((myEle + myMuon).Phi(), myJet1.Phi())
      elif varname=="DeltaEta_em_j2":
        if njets == 2:
          holder[0] = self.deltaEta((myEle + myMuon).Eta(), myJet2.Eta())
        else:
          holder[0] = -1
      elif varname=="DeltaPhi_em_j2":
        if njets == 2:
          holder[0] = self.deltaPhi((myEle + myMuon).Phi(), myJet2.Phi())
        else:
          holder[0] = -1
      elif varname=="DeltaEta_j1_j2":
        if njets == 2: 
          holder[0] = self.deltaEta(myJet1.Eta(), myJet2.Eta())
        else:
          holder[0] = -1
      elif varname=="DeltaPhi_j1_j2":
        if njets == 2:
          holder[0] = self.deltaPhi(myJet1.Phi(), myJet2.Phi())
        else:
          holder[0] = -1
      elif varname=="Zeppenfeld":
        if njets == 2:
          holder[0] = self.Zeppenfeld(myEle, myMuon, myJet1, myJet2)
        else:
          holder[0] = -10
      elif varname=="j1_j2_mass":
        if njets == 2:
          holder[0] = mjj
        else:
          holder[0] = 0
      elif varname=="minDeltaPhi_em_j1j2":
        if njets == 2:
          holder[0] = min(self.deltaPhi((myEle + myMuon).Phi(), myJet1.Phi()), self.deltaPhi((myEle + myMuon).Phi(), myJet2.Phi()))
        else: 
          holder[0] = -1
      elif varname=="minDeltaEta_em_j1j2":
        if njets == 2: 
          holder[0] =  min(self.deltaEta((myEle + myMuon).Eta(), myJet1.Eta()), self.deltaEta((myEle + myMuon).Eta(), myJet2.Eta()))
        else:
          holder[0] = -1
      elif varname=="Nj":
        holder[0] = njets
      elif varname=="e_met_mT":
        holder[0] = self.transverseMass(myEle, myMET)
      elif varname=="m_met_mT":
        holder[0] = self.transverseMass(myMuon, myMET)
      elif varname=="DeltaPhi_e_met":
        holder[0] = self.deltaPhi(myEle.Phi(), myMET.Phi())
      elif varname=="DeltaPhi_m_met":
        holder[0] = self.deltaPhi(myMuon.Phi(), myMET.Phi())
      elif varname=="DeltaEta_e_met":
        holder[0] = self.deltaEta(myEle.Eta(), myMET.Eta())
      elif varname=="DeltaEta_m_met":
        holder[0] = self.deltaEta(myMuon.Eta(), myMET.Eta())
      elif varname=="MetEt":
        holder[0] = myMET.Et()
      elif varname=="e_m_PZeta":
        holder[0] = e_m_PZeta
      elif varname=="R_pT":
        if njets == 2:
          holder[0] = abs((myMuon+myEle+myJet1+myJet2).Pt())/(myMuon.Pt()+myEle.Pt()+myJet1.Pt()+myJet2.Pt())
        else:
          holder[0] = 0
      elif varname=="pT_cen":
        if njets == 2: 
          holder[0] = ((myMuon+myEle).Pt() - abs((myJet1+myJet2).Pt())/2)/abs((myJet1-myJet2).Pt())
        else:
          holder[0] = -50
      elif varname=="weight":
        holder[0] = weight
    if (sign == 0):
      if (itype == 0):
        self.trees[name][1].Fill()
      elif (itype == 1):
        self.trees[name][0].Fill()
    else:
      if (itype == 0):
        self.trees[name][3].Fill()
      elif (itype == 1):
        self.trees[name][2].Fill()


  def fill_categories(self, row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, osss, name):
    if self.oppositesign(row):
      if self.is_VBF or self.is_GluGlu:
        self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, 1, 0, name)
      elif self.is_mc:
        self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, 0, 0, name)
    else: 
      if self.is_mc and not (self.is_VBF or self.is_GluGlu):
        self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, -weight*osss, 0, 1, name)
      elif self.is_data :
        self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight*osss, 0, 1, name)

  def fill_SysNames(self, row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, osss, sysNames):
    for s in sysNames:
      s = s.replace("/","")
      s = s + '_'
      self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, osss, s)

  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]
      myJet1, myJet2 = self.jetVec(row)[0], self.jetVec(row)[1]
      njets = row.jetVeto30
      mjj = row.vbfMass

      weight = self.corrFact(row, myEle, myMuon)[0]
      osss = self.corrFact(row, myEle, myMuon)[1]

      if math.isnan(row.vbfMass):
        continue
      
      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
       continue

      tmpEle = ROOT.TLorentzVector()
      tmpMuon = ROOT.TLorentzVector()
      tmpMET = ROOT.TLorentzVector()

      self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, osss, '')

      if self.is_mc:
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle = myEle * ROOT.Double(row.eEnergyScaleUp/row.eCorrectedEt)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(row, tmpEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, osss, 'eesUp_')
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle = myEle * ROOT.Double(row.eEnergyScaleDown/row.eCorrectedEt)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(row, tmpEle, myMuon, tmpMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, osss, 'eesDown_')
  
        # Muon Energy Scale
        me = self.MESSys(myMuon.Eta())[0]
        mes = self.MESSys(myMuon.Eta())[1]
        myMETpx = myMET.Px() - me * myMuon.Px()
        myMETpy = myMET.Py() - me * myMuon.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpMuon = myMuon * ROOT.Double(1.000 + me)
        self.fill_categories(row, myEle, tmpMuon, tmpMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, osss, mes[0].replace('/','')+'_')
        myMETpx = myMET.Px() + me * myMuon.Px()
        myMETpy = myMET.Py() + me * myMuon.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpMuon = myMuon * ROOT.Double(1.000 - me)
        self.fill_categories(row, myEle, tmpMuon, tmpMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, osss, mes[1].replace('/','')+'_')
        mSys = [x for x in self.mesSys if x not in mes] 
        self.fill_SysNames(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, osss, mSys)
  
        puweightUp = pucorrector['puUp'](row.nTruePU)
        puweightDown = pucorrector['puDown'](row.nTruePU)
        puweight = pucorrector[''](row.nTruePU)
        if puweight==0:
          self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, 0, osss, 'puUp_')
          self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, 0, osss, 'puDown_')
        else:
          self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*puweightUp/puweight, osss, 'puUp_')
          self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*puweightDown/puweight, osss, 'puDown_')
  
        nbtag = row.bjetDeepCSVVeto20Medium_2016_DR0p5
        if nbtag > 2:
          nbtag = 2
        if nbtag==0:
          self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, osss, 'bTagUp_')
          self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, osss, 'bTagDown_')
        if nbtag > 0:
          btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 0)
          btagweightup = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 1, 0)
          btagweightdown = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, -1, 0)
          self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*btagweightup/btagweight, osss, 'bTagUp_')
          self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*btagweightdown/btagweight, osss, 'bTagDown_')
  
        self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*row.prefiring_weight_up/row.prefiring_weight, osss, 'pfUp_')
        self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*row.prefiring_weight_down/row.prefiring_weight, osss, 'pfDown_')
  
        njets_orig = njets
        if not (self.is_recoilC and self.MetCorrection):
          for u in self.ues:
            myMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+u), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+u), 0)
            self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, osss, u+'_')
          for j in self.jes:
            myMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
            njets = getattr(row, 'jetVeto30_'+j)
            if njets_orig == 0 and njets > 0:
              continue
            mjj = getattr(row, 'vbfMass_'+j)
            myJet1 = ROOT.TLorentzVector()
            myJet1.SetPtEtaPhiM(getattr(row, 'j1pt_'+j), row.j1eta, row.j1phi, 0)
            myJet2 = ROOT.TLorentzVector()
            myJet2.SetPtEtaPhiM(getattr(row, 'j2pt_'+j), row.j2eta, row.j2phi, 0)    
            self.fill_categories(row, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, osss, j+'_')
       
  def finish(self):
    for treelist in self.trees.values():
      for tree in treelist:
        tree.Write()
    self.write_histos()  
