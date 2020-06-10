'''

Run LFV H->EMu analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from MuTauBase import MuTauBase
import MuTauTree
import itertools
import os
import ROOT
from cutflowtracker import cut_flow_tracker

cut_flow_step = ['allEvents', 'passFilters', 'passOppSign', 'passTrigger', 'passKinematics', 'passDeltaR', 'passNjets', 'passVetoes', 'passbjetVeto', 'passObj1id', 'passObj2id', 'passtDecayMode', 'passdimuonVeto', 'passObj2looseANDnottight']

class AnalyzeMuTauCF(MegaBase, MuTauBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):
    super(AnalyzeMuTauCF, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    MuTauBase.__init__(self)


  def begin(self):
    self.book('', 'CUT_FLOW', 'Cut Flow', len(cut_flow_step), 0, len(cut_flow_step))
    xaxis = self.histograms['CUT_FLOW'].GetXaxis()
    self.cut_flow_histo = self.histograms['CUT_FLOW']
    self.cut_flow_map = {}
    for i, name in enumerate(cut_flow_step):
      xaxis.SetBinLabel(i+1, name)
      self.cut_flow_map[name] = i+0.5


  def process(self):

    cut_flow_histo = self.cut_flow_histo
    cut_flow_trk   = cut_flow_tracker(cut_flow_histo)

    for row in self.tree:

      cut_flow_trk.new_row(row.run, row.lumi, row.evt)
      cut_flow_trk.Fill('allEvents')

      # MET Filters
      if self.filters(row):
        continue
      cut_flow_trk.Fill('passFilters')

      # Lepton Opposite Sign
      if not self.oppositesign(row):
        continue
      cut_flow_trk.Fill('passOppSign')

      # Trigger
      if not self.trigger(row):
        continue
      cut_flow_trk.Fill('passTrigger')

      # Kinematics
      if not self.kinematics(row):
        continue
      cut_flow_trk.Fill('passKinematics')

      # DeltaR
      if self.deltaR(row.tPhi, row.mPhi, row.tEta, row.mEta) < 0.5:
        continue
      cut_flow_trk.Fill('passDeltaR')

      # NJets
      if row.jetVeto30 > 2:
        continue
      cut_flow_trk.Fill('passNjets')

      # Vetoes
      if not self.vetos(row):
        continue
      cut_flow_trk.Fill('passVetoes')

      # b-tag Veto
      if row.bjetDeepCSVVeto20Medium_2018_DR0p5 > 0:
        continue
      cut_flow_trk.Fill('passbjetVeto')

      # Electron ID
      if not self.obj1_id(row):
        continue
      cut_flow_trk.Fill('passObj1id')

      # Muon ID
      if not self.obj2_id(row):
        continue
      cut_flow_trk.Fill('passObj2id')

      if row.tDecayMode==5 or row.tDecayMode==6:
        continue
      cut_flow_trk.Fill('passtDecayMode')
      
      if not self.dimuonveto(row):
        continue
      cut_flow_trk.Fill('passdimuonVeto')
#      # Electron Iso
#      if not self.obj1_tight(row):
#        continue
#      cut_flow_trk.Fill('passObj1tight')
#      # Muon Iso
      if not  bool(self.obj2_loose(row) and not self.obj2_tight(row)):
        continue
      cut_flow_trk.Fill('passObj2looseANDnottight')



  def finish(self):
    self.write_histos()
