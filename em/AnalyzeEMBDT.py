'''

Run LFV H->EM analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import EMTree
import ROOT
import math
import array

class AnalyzeEMBDT(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)


  def begin(self):
    self.trees = {}
    branch_names = self.branches.split(':')
    self.treeS = ROOT.TTree("TreeS", "TreeS")
    self.treeB = ROOT.TTree("TreeB", "TreeB")
    self.treeSss = ROOT.TTree("TreeSss", "TreeSss")
    self.treeBss = ROOT.TTree("TreeBss", "TreeBss")
    for name in branch_names:
      try:
          varname, vartype = tuple(name.split('/'))
      except:
        raise ValueError('Problem parsing %s' % name)
      inverted_type = self.invert_case(vartype.rsplit("_", 1)[0])
      self.holders.append((varname, array.array(inverted_type, [0])))
    for name, varinfo in zip(branch_names, self.holders):
      varname, holder = varinfo
      self.treeS.Branch(varname, holder, name)
      self.treeB.Branch(varname, holder, name)
      self.treeSss.Branch(varname, holder, name)
      self.treeBss.Branch(varname, holder, name)

  def filltree(self, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, Ht, weight, itype, sign):
    for varname, holder in self.holders:
      if varname=="mPt_Per_e_m_Mass":
        holder[0] = myMuon.Pt()/self.visibleMass(myEle, myMuon)
      elif varname=="ePt_Per_e_m_Mass":
        holder[0] = myEle.Pt()/self.visibleMass(myEle, myMuon)
      elif varname=="ePt_Per_mPt":
        holder[0] = myEle.Pt()/myMuon.Pt()
      elif varname=="e_m_Mass":
        holder[0] = self.visibleMass(myEle, myMuon)
      elif varname=="emPt":
        holder[0] = (myEle + myMuon).Pt()
      elif varname=="emEta":
        holder[0] = (myEle + myMuon).Eta() 
      elif varname=="emRapidity":
        if not math.isnan((myEle + myMuon).Rapidity()):
          holder[0] = (myEle + myMuon).Rapidity()
        else:
          holder[0] = -10
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
      elif varname=="DeltaEta_e_m":
        holder[0] = self.deltaEta(myEle.Eta(), myMuon.Eta())
      elif varname=="DeltaPhi_e_m":
        holder[0] = self.deltaPhi(myEle.Phi(), myMuon.Phi())
      elif varname=="DeltaR_e_m":
        holder[0] = self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta())
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
      elif varname=="DeltaR_em_j1":
        if njets == 0:
          holder[0] = -1
        else:
          holder[0] = self.deltaR((myEle + myMuon).Phi(), myJet1.Phi(), (myEle + myMuon).Eta(), myJet1.Eta())
      elif varname=="DeltaR_em_j2":
        if njets == 2:
          holder[0] = self.deltaR((myEle + myMuon).Phi(), myJet2.Phi(), (myEle + myMuon).Eta(), myJet2.Eta())
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
      elif varname=="DeltaR_j1_j2":
        if njets == 2:
          holder[0] = self.deltaR(myJet1.Phi(), myJet2.Phi(), myJet1.Eta(), myJet2.Eta())
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
      elif varname=="DeltaPhi_em_j1j2":
        if njets == 2:
          holder[0] = self.deltaPhi((myEle + myMuon).Phi(), (myJet1 + myJet2).Phi())
        else: 
          holder[0] = -1
      elif varname=="DeltaEta_em_j1j2":
        if njets == 2: 
          holder[0] =  self.deltaEta((myEle + myMuon).Eta(), (myJet1 + myJet2).Eta())
        else:
          holder[0] = -1
      elif varname=="DeltaR_em_j1j2":
        if njets == 2:
          holder[0] = self.deltaR((myEle + myMuon).Phi(), (myJet1 + myJet2).Phi(), (myEle + myMuon).Eta(), (myJet1 + myJet2).Eta())
        else:
          holder[0] = -1
      elif varname=="Nj":
        holder[0] = njets
      elif varname=="e_met_mT":
        holder[0] = self.transverseMass(myEle, myMET)
      elif varname=="m_met_mT":
        holder[0] = self.transverseMass(myMuon, myMET)
      elif varname=="e_met_mT_per_M":
        holder[0] = self.transverseMass(myEle, myMET)/self.visibleMass(myEle, myMuon)
      elif varname=="m_met_mT_per_M":
        holder[0] = self.transverseMass(myMuon, myMET)/self.visibleMass(myEle, myMuon)
      elif varname=="DeltaPhi_e_met":
        holder[0] = self.deltaPhi(myEle.Phi(), myMET.Phi())
      elif varname=="DeltaPhi_m_met":
        holder[0] = self.deltaPhi(myMuon.Phi(), myMET.Phi())
      elif varname=="absEta_e":
        holder[0] = abs(myEle.Eta())
      elif varname=="absEta_m":
        holder[0] = abs(myMuon.Eta())
      elif varname=="DeltaPhi_e_j1":
        if njets != 0:
          holder[0] = self.deltaPhi(myEle.Phi(), myJet1.Phi())
        else:
          holder[0] = -1
      elif varname=="DeltaPhi_m_j1":
        if njets != 0:
          holder[0] = self.deltaPhi(myMuon.Phi(), myJet1.Phi())
        else:
          holder[0] = -1
      elif varname=="DeltaEta_e_j1":
        if njets != 0:
          holder[0] = self.deltaEta(myEle.Eta(), myJet1.Eta())
        else:
          holder[0] = -1
      elif varname=="DeltaEta_m_j1":
        if njets != 0:
          holder[0] = self.deltaEta(myMuon.Eta(), myJet1.Eta())
        else:
          holder[0] = -1
      elif varname=="DeltaPhi_e_j2":
        if njets == 2:
          holder[0] = self.deltaPhi(myEle.Phi(), myJet2.Phi())
        else:
          holder[0] = -1
      elif varname=="DeltaPhi_m_j2":
        if njets == 2:
          holder[0] = self.deltaPhi(myMuon.Phi(), myJet2.Phi())
        else:
          holder[0] = -1
      elif varname=="DeltaEta_e_j2":
        if njets == 2:
          holder[0] = self.deltaEta(myEle.Eta(), myJet2.Eta())
        else:
          holder[0] = -1
      elif varname=="DeltaEta_m_j2":
        if njets == 2:
          holder[0] = self.deltaEta(myMuon.Eta(), myJet2.Eta())
        else:
          holder[0] = -1
      elif varname=="DeltaR_e_j2":
        if njets == 2:
          holder[0] = self.deltaR(myEle.Phi(), myJet2.Phi(), myEle.Eta(), myJet2.Eta())
        else:
          holder[0] = -1
      elif varname=="DeltaR_m_j2":
        if njets == 2:
          holder[0] = self.deltaR(myMuon.Phi(), myJet2.Phi(), myMuon.Eta(), myJet2.Eta())
        else:
          holder[0] = -1
      elif varname=="DeltaR_e_j1":
        if njets != 0:
          holder[0] = self.deltaR(myEle.Phi(), myJet1.Phi(), myEle.Eta(), myJet1.Eta())
        else:
          holder[0] = -1
      elif varname=="DeltaR_m_j1":
        if njets != 0:
          holder[0] = self.deltaR(myMuon.Phi(), myJet1.Phi(), myMuon.Eta(), myJet1.Eta())
        else:
          holder[0] = -1
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
      elif varname=="cen":
        if njets == 2: 
          holder[0] = math.exp(self.Zeppenfeld(myEle, myMuon, myJet1, myJet2)**2*-4/((myJet1.Eta()-myJet2.Eta())**2))
        else:
          holder[0] = -1
      elif varname=="Ht":
        holder[0] = Ht 
      elif varname=="weight":
        holder[0] = weight
    if (sign == 0):
      if (itype == 0):
        self.treeB.Fill()
      elif (itype == 1):
        self.treeS.Fill()
    else:
      if (itype == 0):
        self.treeBss.Fill()
      elif (itype == 1):
        self.treeSss.Fill()
  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]
      myJet1, myJet2 = self.jetVec(row)[0], self.jetVec(row)[1]
      njets = int(row.jetVeto30)
      mjj = row.vbfMass

      weight = self.corrFact(row, myEle, myMuon)[0]
      osss = self.corrFact(row, myEle, myMuon)[1]

      if math.isnan(row.vbfMass):
        continue
     
      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
       continue

      if self.oppositesign(row):
        if self.is_VBF or self.is_GluGlu:
          self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, row.Ht, weight, 1, 0)
        elif self.is_mc:
          self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, row.Ht, weight, 0, 0)
      else: 
        if self.is_mc and not (self.is_VBF or self.is_GluGlu):
          self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, row.Ht, -weight*osss, 0, 1)
        elif self.is_data :
          self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, row.Ht, weight*osss, 0, 1)

  def finish(self):
     self.treeS.Write()
     self.treeB.Write()
     self.treeSss.Write()
     self.treeBss.Write()
     self.write_histos()  
