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

class AnalyzeEMTree(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMTree, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)


  def begin(self):
    self.trees = {}
    branch_names = self.branches.split(':')
    self.tree1 = ROOT.TTree(self.name, self.title)
    for name in branch_names:
      try:
          varname, vartype = tuple(name.split('/'))
      except:
        raise ValueError('Problem parsing %s' % name)
      inverted_type = self.invert_case(vartype.rsplit("_", 1)[0])
      self.holders.append((varname, array.array(inverted_type, [0])))
    for name, varinfo in zip(branch_names, self.holders):
      varname, holder = varinfo
      self.tree1.Branch(varname, holder, name)

  def filltree(self, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, cat):
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
      elif varname=="cat":
        holder[0] = cat
    self.tree1.Fill()

  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]
      myJet1, myJet2 = self.jetVec(row)[0], self.jetVec(row)[1]
      njets = row.jetVeto30
      mjj = row.vbfMass

      weight = self.corrFact(row, myEle, myMuon)[0]

      if math.isnan(row.vbfMass):
        continue
     
      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
        continue

#      if self.is_data and self.visibleMass(myEle, myMuon) > 120 and self.visibleMass(myEle, myMuon) < 130:
#        continue


      if self.oppositesign(row):
        if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
          self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 3)
        else:
          if njets == 0:
            mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, row.e_m_PZeta))
          elif njets == 1:
            mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, row.e_m_PZeta))
          else:
            mva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, row.e_m_PZeta))
          if mva < 0.085:
            self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 0)
          elif mva < 0.125:
            self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 1)
          else:
            self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 2)


  def finish(self):
     self.tree1.Write()
     self.write_histos()  
