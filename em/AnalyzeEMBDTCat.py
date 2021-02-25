'''

Run LFV H->EM analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from EMBase import EMBase
import EMTree
import ROOT

class AnalyzeEMBDTCat(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMBDTCat, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)

  def begin(self):
    self.book('TightOSgg', 'MVA_e_m_Mass', 'MVA_e_m_Mass', 2000, -1, 1, 5000, 110, 160, type=ROOT.TH2F)

  def fill_histos(self, myEle, myMuon, mva, weight, name=''):
    histos = self.histograms
    histos[name+'/MVA_e_m_Mass'].Fill(mva, self.visibleMass(myEle, myMuon), weight)

  def process(self):

    for row in self.tree:

      if not self.eventSel(row):
        continue

      myEle, myMET, myMuon = self.lepVec(row)[0], self.lepVec(row)[1], self.lepVec(row)[2]
      myJet1, myJet2 = self.jetVec(row)[0], self.jetVec(row)[1]

      weight = self.corrFact(row, myEle, myMuon)[0]

      njets = row.jetVeto30
      mjj = row.vbfMass

      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
        continue

      if self.oppositesign(row):
        if njets<=2 and not (njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5):
          if njets == 0:
            mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
          elif njets == 1:
            mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
          else:
            mva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
          self.fill_histos(myEle, myMuon, mva, weight, 'TightOSgg')

#        if njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5:
#          RpT = self.RpT(myEle, myMuon, myJet1, myJet2)
#          if RpT>.2:        
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, 0, row.Ht, weight, 'TightOSvbfcat0')
#          else:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, 0, row.Ht, weight, 'TightOSvbfcat1')
#        elif njets<=2:
#          if njets == 0:
#            mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
#          elif njets == 1:
#            mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
#          else:
#            mva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
#          if mva < self.bdtcuts[0]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat0')
#          elif mva < self.bdtcuts[1]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat1')
#          elif mva < self.bdtcuts[2]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat2')
#          elif mva < self.bdtcuts[3]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat3')
#          else:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat4')
          
#          if RpT>0.2:        
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, 0, row.Ht, weight, 'TightOSvbfcat0')
#          else:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, 0, row.Ht, weight, 'TightOSvbfcat1')
#	elif njets<=2:
#          if njets == 0:
#            mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
#          elif njets == 1:
#            mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
#          else:
#            mva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
##[-0.9995, 0.0535000000000001, 0.10250000000000004, 0.12650000000000006, 0.15349999999999997, 0.9995]
#[-0.9995, 0.044499999999999984, 0.10250000000000004, 0.15349999999999997, 0.9995]
#          if mva < -0.0706996:
#            continue
#          elif mva < 0.0535:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat0')
#          elif mva < 0.1025:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat1')
#          elif mva < 0.1265:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat2')
#          elif mva < 0.1535:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat3')
#          else:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat4')


  def finish(self):
    self.write_histos()
