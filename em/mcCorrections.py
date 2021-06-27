import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.EGammaPOGCorrections as EGammaPOGCorrections
import FinalStateAnalysis.TagAndProbe.DYCorrection as DYCorrection
import FinalStateAnalysis.TagAndProbe.RoccoR as RoccoR
import ROOT

year = '2017'

pu_distributions = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu.root'))
pu_distributionsUp = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu_up.root'))
pu_distributionsDown = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu_down.root'))

def make_puCorrector():
    return PileupWeight.PileupWeight(year, *pu_distributions)

def make_puCorrectorUp():
    return PileupWeight.PileupWeight(year, *pu_distributionsUp)

def make_puCorrectorDown():
    return PileupWeight.PileupWeight(year, *pu_distributionsDown)

def puCorrector(target=''):
    pucorrector = {'' : make_puCorrector(), 'puUp': make_puCorrectorUp(), 'puDown': make_puCorrectorDown()}
    return pucorrector

rc = RoccoR.RoccoR('2017/RoccoR/RoccoR2017.txt')

DYreweight = DYCorrection.make_DYreweight_2017()

muonID_tight = MuonPOGCorrections.make_muon_pog_PFTight_2017()
muonIso_tight_tightid = MuonPOGCorrections.make_muon_pog_TightIso_2017()
muonTrigger27 = MuonPOGCorrections.make_muon_pog_IsoMu27_2017()

eIDnoiso80 = EGammaPOGCorrections.make_egamma_pog_electronID80noiso_2017()
eReco = EGammaPOGCorrections.make_egamma_pog_Reco_2017()

