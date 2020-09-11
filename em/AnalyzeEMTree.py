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


  def filltree(self, myEle, myMET, myMuon, itype, cat, weight):
    for varname, holder in self.holders:
      if varname=="mPt":
        holder[0] = myMuon.Pt()
      elif varname=="ePt":
        holder[0] = myEle.Pt()
      elif varname=="e_m_Mass":
        holder[0] = self.visibleMass(myEle, myMuon)
      elif varname=="type1_pfMetEt":
        holder[0] = myMET.Et()
      elif varname=="itype":
        holder[0] = itype
      elif varname=="cat":
        holder[0] = cat
      elif varname=="weight":
        holder[0] = weight
    self.tree1.Fill()

  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]
      njets = row.jetVeto30WoNoisyJets
      mjj = row.vbfMassWoNoisyJets

      weight = self.corrFact(row, myEle, myMuon)

      if math.isnan(row.vbfMassWoNoisyJets):
        continue
     
      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
       continue

      if self.oppositesign(row):
        if njets==0:
          if self.cuts(row, '0'):
            if self.is_data:
              self.filltree(myEle, myMET, myMuon, 0, 1, weight)
            else:
              self.filltree(myEle, myMET, myMuon, -1, 1, weight)

          elif self.cuts(row, '1'):
            if self.is_data:
              self.filltree(myEle, myMET, myMuon, 0, 2, weight)
            else:
              self.filltree(myEle, myMET, myMuon, -1, 2, weight)

          elif self.cuts(row, '2'):
            if self.is_data:
              self.filltree(myEle, myMET, myMuon, 0, 3, weight)
            else:
              self.filltree(myEle, myMET, myMuon, -1, 3, weight)

        elif njets==1:
          if self.cuts(row, '3'):
            if self.is_data:
              self.filltree(myEle, myMET, myMuon, 0, 4, weight)
            else:
              self.filltree(myEle, myMET, myMuon, -1, 4, weight)

          if self.cuts(row, '4'):
            if self.is_data:
              self.filltree(myEle, myMET, myMuon, 0, 5, weight)
            else:
              self.filltree(myEle, myMET, myMuon, -1, 5, weight)

          elif self.cuts(row, '5'):
            if self.is_data:
              self.filltree(myEle, myMET, myMuon, 0, 6, weight)
            else:
              self.filltree(myEle, myMET, myMuon, -1, 6, weight)

        elif njets==2 and mjj < 500:
          if self.cuts(row, '6'):
            if self.is_data:
              self.filltree(myEle, myMET, myMuon, 0, 7, weight)
            else:
              self.filltree(myEle, myMET, myMuon, -1, 7, weight)

          if self.cuts(row, '7'):
            if self.is_data:
              self.filltree(myEle, myMET, myMuon, 0, 8, weight)
            else:
              self.filltree(myEle, myMET, myMuon, -1, 8, weight)

          elif self.cuts(row, '8'):
            if self.is_data:
              self.filltree(myEle, myMET, myMuon, 0, 9, weight)
            else:
              self.filltree(myEle, myMET, myMuon, -1, 9, weight)


        elif njets==2 and mjj > 500 and self.cuts(row, '9'): 
          if self.is_data:
            self.filltree(myEle, myMET, myMuon, 0, 10, weight)
          else:
            self.filltree(myEle, myMET, myMuon, -1, 10, weight)

  def finish(self):
     self.tree1.Write()
     self.write_histos()  
