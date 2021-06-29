'''

Run LFV H->EM analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import EMTree
import mcCorrections
import ROOT
import math
import array
import os

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeEMYield(MegaBase, EMBase):
  tree = 'mm/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMYield, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)

  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      if math.isnan(row.vbfMass):
        continue

      myMuon1, myMET, myMuon2 = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]

      weight = self.corrFact(row, myMuon1, myMuon2)

      if self.visibleMass(myMuon1, myMuon2) > self.mbinning[-1] or self.visibleMass(myMuon1, myMuon2) < self.mbinning[0]:
       continue

      if (myMuon1+myMuon2).Pt() > self.ptbinning[-1] and (myMuon1+myMuon2).Pt() < self.ptbinning[0]:
       continue

      if self.oppositesign(row):
        self.fill_histos(myMuon1, myMuon2, weight, 'ZOS')
        if self.is_DY:
          # DY pT reweighting
          dyweight = self.DYreweight(row.genM, row.genpT)
          weight = weight * dyweight
          self.fill_histos(myMuon1, myMuon2, weight, 'ZOSC')
        else:
          self.fill_histos(myMuon1, myMuon2, weight, 'ZOSC')

      else:
        self.fill_histos(myMuon2, myMuon2, weight, 'ZSS')

  def finish(self):
     self.write_histos()  
