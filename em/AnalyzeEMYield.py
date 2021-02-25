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
import os
import mcCorrections
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeEMYield(MegaBase, EMBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeEMYield, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    EMBase.__init__(self)

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

      if math.isnan(row.vbfMassWoNoisyJets):
        continue

      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
       continue

      if self.visibleMass(myEle, myMuon) < 130 and self.visibleMass(myEle, myMuon) > 120 and self.is_data:
       continue
      puweightUp = pucorrector['puUp'](row.nTruePU)
      puweightDown = pucorrector['puDown'](row.nTruePU)
      puweight = pucorrector[''](row.nTruePU)

      if njets == 0:
        mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
      elif njets == 1:
        mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
      else:
        mva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))

      if self.oppositesign(row):
        if njets<=2 and not (njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5) and not self.is_data:
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightOSgg')
          if not (self.is_recoilC and self.MetCorrection):
            tmpMET = ROOT.TLorentzVector()
            for u in self.ues:
              tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+u), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+u), 0)
              if njets == 0:
                tmpmva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, tmpMET, myJet1, myJet2, row.Ht, mjj, njets))
              elif njets == 1:
                tmpmva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, tmpMET, myJet1, myJet2, row.Ht, mjj, njets))
              else:
                tmpmva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, tmpMET, myJet1, myJet2, row.Ht, mjj, njets))
              self.fill_histos(myEle, myMuon, tmpMET, myJet1, myJet2, njets, tmpmva, row.nTruePU, weight, 'TightOSgg/'+u+"2016")
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightOSgg/'+u+"2018")
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightOSgg/'+u+"2017")
          else:
            for u in self.ues:
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightOSgg/'+u+"2018")
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightOSgg/'+u+"2016")
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightOSgg/'+u+"2017")
          if puweight==0:
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, 0, 'TightOSgg/puUp')
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, 0, 'TightOSgg/puDown')
          else:
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight*puweightUp/puweight, 'TightOSgg/puUp')
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight*puweightDown/puweight, 'TightOSgg/puDown')
      else:
        if njets<=2 and not (njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5):
          self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightSSgg')
          if self.is_data:
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightSSgg/puUp')
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightSSgg/puDown')
          elif puweight==0:
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, 0, 'TightSSgg/puUp')
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, 0, 'TightSSgg/puDown')
          else:
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight*puweightUp/puweight, 'TightSSgg/puUp')
            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight*puweightDown/puweight, 'TightSSgg/puDown')
          if not (self.is_recoilC and self.MetCorrection) and not self.is_data:
            tmpMET = ROOT.TLorentzVector()
            for u in self.ues:
              tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+u), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+u), 0)
              if njets == 0:
                tmpmva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, tmpMET, myJet1, myJet2, row.Ht, mjj, njets))
              elif njets == 1:
                tmpmva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, tmpMET, myJet1, myJet2, row.Ht, mjj, njets))
              else:
                tmpmva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, tmpMET, myJet1, myJet2, row.Ht, mjj, njets))
              self.fill_histos(myEle, myMuon, tmpMET, myJet1, myJet2, njets, tmpmva, row.nTruePU, weight, 'TightSSgg/'+u+"2016")
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightSSgg/'+u+"2018")
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightSSgg/'+u+"2017")
          else: 
            for u in self.ues:
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightSSgg/'+u+"2016")
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightSSgg/'+u+"2018")
              self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.nTruePU, weight, 'TightSSgg/'+u+"2017")

#      if self.visibleMass(myEle, myMuon) > 160 or self.visibleMass(myEle, myMuon) < 110:
#        continue
#
#      if self.visibleMass(myEle, myMuon) < 130 and self.visibleMass(myEle, myMuon) > 120: # and self.is_data:
#       continue
#      if self.is_Signal:
#        mvagg = [0.06039297,0.09334121,0.11689808,0.14265084]
#        mvahj = [0.01396251,0.07548274,0.12745545,0.19094225]
#      else:
#        mvagg = [-0.16190984,-0.06922302,0.00745924,0.07314398]
#        mvahj = [-0.26980058,-0.18273639,-0.10398284,-0.02387099]
#      if self.oppositesign(row):
#        if njets<=2 and not (njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5):
#          if njets == 0:
#            mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
#          elif njets == 1:
#            mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
#          else:
#            mva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
#          if mva < mvagg[0]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat0')
#          elif mva < mvagg[1]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat1')
#          elif mva < mvagg[2]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat2')
#          elif mva < mvagg[3]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat3')
#          else:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOSggcat4')
#        elif njets>2:
#          mva = self.functor_vbf(**self.var_d_vbf_2(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
#          if mva < mvahj[0]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOShjcat0')
#          elif mva < mvahj[1]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOShjcat1')
#          elif mva < mvahj[2]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOShjcat2')
#          elif mva < mvahj[3]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOShjcat3')
#          else:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight, 'TightOShjcat4')
#      else:
#        if njets<=2 and not (njets==2 and mjj>400 and self.deltaEta(myJet1.Eta(), myJet2.Eta())>2.5):
#          if njets == 0:
#            mva = self.functor_gg(**self.var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
#          elif njets == 1:
#            mva = self.functor_gg(**self.var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
#          else:
#            mva = self.functor_gg(**self.var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
#          if mva < mvagg[0]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight*osss, 'TightSSggcat0')
#          elif mva < mvagg[1]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight*osss, 'TightSSggcat1')
#          elif mva < mvagg[2]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight*osss, 'TightSSggcat2')
#          elif mva < mvagg[3]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight*osss, 'TightSSggcat3')
#          else:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight*osss, 'TightSSggcat4')
#        elif njets>2:
#          mva = self.functor_vbf(**self.var_d_vbf_2(myEle, myMuon, myMET, myJet1, myJet2, row.Ht, mjj, njets))
#          if mva < mvahj[0]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight*osss, 'TightSShjcat0')
#          elif mva < mvahj[1]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight*osss, 'TightSShjcat1')
#          elif mva < mvahj[2]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight*osss, 'TightSShjcat2')
#          elif mva < mvahj[3]:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight*osss, 'TightSShjcat3')
#          else:
#            self.fill_histos(myEle, myMuon, myMET, myJet1, myJet2, njets, mva, row.Ht, weight*osss, 'TightSShjcat4')
  def finish(self):
     self.write_histos()  
