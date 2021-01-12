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
      if varname=="e_m_Mass":
        holder[0] = self.visibleMass(myEle, myMuon)
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
      njets = row.jetVeto30WoNoisyJets
      mjj = row.vbfMassWoNoisyJets

      weight = self.corrFact(row, myEle, myMuon)[0]

      if math.isnan(row.vbfMass):
        continue
     
      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
        continue

      if self.oppositesign(row):
        if not (njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2):
          continue

        self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 42)
        for i in range(500,710,10):
          if mjj>i:        
            self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, (i-500)*2/10)
          else:
            self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, (i-500)*2/10+1)
#        self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 6)
#        if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
#          self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 5)
#        else:
#          if njets == 0:
#            mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, row.e_m_PZeta, mjj))
#          elif njets == 1:
#            mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, row.e_m_PZeta, mjj))
#          else:
#            mva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, row.e_m_PZeta, mjj))
#          if mva < 0.0175:
#            self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 0)
#          elif mva < 0.0975:
#            self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 1)
#          elif mva < 0.1305:
#            self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 2)
#          elif mva < 0.1635:
#            self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 3)
#          else:
#            self.filltree(myEle, myMuon, myMET, myJet1, myJet2, njets, mjj, row.e_m_PZeta, weight, 4)


  def finish(self):
     self.tree1.Write()
     self.write_histos()  