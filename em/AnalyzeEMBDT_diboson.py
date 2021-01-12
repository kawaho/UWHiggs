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

class AnalyzeEMBDT_diboson(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMBDT_diboson, self).__init__(tree, outfile, **kwargs)
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

  def filltree(self, myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, e_m_PZeta, weight, itype, sign):
    for varname, holder in self.holders:
      if varname=="mPt_Per_e_m_Mass":
        holder[0] = myMuon.Pt()
      elif varname=="ePt_Per_e_m_Mass":
        holder[0] = myEle.Pt()
      elif varname=="e_m_Mass":
        holder[0] = self.visibleMass(myEle, myMuon)
      elif varname=="DeltaPhi_e_m":
        holder[0] = self.deltaPhi(myEle.Phi(), myMuon.Phi())
      elif varname=="e_met_mT":
        holder[0] = self.transverseMass(myEle, myMET)
      elif varname=="m_met_mT":
        holder[0] = self.transverseMass(myMuon, myMET)
      elif varname=="DeltaPhi_e_met":
        holder[0] = self.deltaPhi(myEle.Phi(), myMET.Phi())
      elif varname=="DeltaPhi_m_met":
        holder[0] = self.deltaPhi(myMuon.Phi(), myMET.Phi())
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
      njets = row.jetVeto30
      mjj = row.vbfMass

      weight = self.corrFact(row, myEle, myMuon)[0]
      osss = self.corrFact(row, myEle, myMuon)[1]

      if math.isnan(row.vbfMass):
        continue
     
      if self.visibleMass(myEle, myMuon) > 100:
       continue

      if self.oppositesign(row):
        if self.is_VV:
          self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 1, 0)
        elif self.is_mc:
          self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 0, 0)
      else: 
        if self.is_mc:
          self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, -weight*osss, 0, 1)
        elif self.is_data:
          self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight*osss, 0, 1)

  def finish(self):
     self.treeS.Write()
     self.treeB.Write()
     self.treeSss.Write()
     self.treeBss.Write()
     self.write_histos()  
