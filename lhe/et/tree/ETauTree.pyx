

# Load relevant ROOT C++ headers
cdef extern from "TObject.h":
    cdef cppclass TObject:
        pass

cdef extern from "TBranch.h":
    cdef cppclass TBranch:
        int GetEntry(long, int)
        void SetAddress(void*)

cdef extern from "TTree.h":
    cdef cppclass TTree:
        TTree()
        int GetEntry(long, int)
        long LoadTree(long)
        long GetEntries()
        TTree* GetTree()
        int GetTreeNumber()
        TBranch* GetBranch(char*)

cdef extern from "TFile.h":
    cdef cppclass TFile:
        TFile(char*, char*, char*, int)
        TObject* Get(char*)

# Used for filtering with a string
cdef extern from "TTreeFormula.h":
    cdef cppclass TTreeFormula:
        TTreeFormula(char*, char*, TTree*)
        double EvalInstance(int, char**)
        void UpdateFormulaLeaves()
        void SetTree(TTree*)

from cpython cimport PyCObject_AsVoidPtr
import warnings
def my_warning_format(message, category, filename, lineno, line=""):
    return "%s:%s\n" % (category.__name__, message)
warnings.formatwarning = my_warning_format

cdef class ETauTree:
    # Pointers to tree (may be a chain), current active tree, and current entry
    # localentry is the entry in the current tree of the chain
    cdef TTree* tree
    cdef TTree* currentTree
    cdef int currentTreeNumber
    cdef long ientry
    cdef long localentry
    # Keep track of missing branches we have complained about.
    cdef public set complained

    # Branches and address for all

    cdef TBranch* DoubleMediumHPSTau35Pass_branch
    cdef float DoubleMediumHPSTau35Pass_value

    cdef TBranch* DoubleMediumHPSTau35TightIDPass_branch
    cdef float DoubleMediumHPSTau35TightIDPass_value

    cdef TBranch* DoubleMediumHPSTau40Pass_branch
    cdef float DoubleMediumHPSTau40Pass_value

    cdef TBranch* DoubleMediumHPSTau40TightIDPass_branch
    cdef float DoubleMediumHPSTau40TightIDPass_value

    cdef TBranch* DoubleMediumTau35Pass_branch
    cdef float DoubleMediumTau35Pass_value

    cdef TBranch* DoubleMediumTau35TightIDPass_branch
    cdef float DoubleMediumTau35TightIDPass_value

    cdef TBranch* DoubleMediumTau40Pass_branch
    cdef float DoubleMediumTau40Pass_value

    cdef TBranch* DoubleMediumTau40TightIDPass_branch
    cdef float DoubleMediumTau40TightIDPass_value

    cdef TBranch* DoubleTightHPSTau35Pass_branch
    cdef float DoubleTightHPSTau35Pass_value

    cdef TBranch* DoubleTightHPSTau35TightIDPass_branch
    cdef float DoubleTightHPSTau35TightIDPass_value

    cdef TBranch* DoubleTightHPSTau40Pass_branch
    cdef float DoubleTightHPSTau40Pass_value

    cdef TBranch* DoubleTightHPSTau40TightIDPass_branch
    cdef float DoubleTightHPSTau40TightIDPass_value

    cdef TBranch* DoubleTightTau35Pass_branch
    cdef float DoubleTightTau35Pass_value

    cdef TBranch* DoubleTightTau35TightIDPass_branch
    cdef float DoubleTightTau35TightIDPass_value

    cdef TBranch* DoubleTightTau40Pass_branch
    cdef float DoubleTightTau40Pass_value

    cdef TBranch* DoubleTightTau40TightIDPass_branch
    cdef float DoubleTightTau40TightIDPass_value

    cdef TBranch* Ele24LooseHPSTau30Pass_branch
    cdef float Ele24LooseHPSTau30Pass_value

    cdef TBranch* Ele24LooseHPSTau30TightIDPass_branch
    cdef float Ele24LooseHPSTau30TightIDPass_value

    cdef TBranch* Ele24LooseTau30Pass_branch
    cdef float Ele24LooseTau30Pass_value

    cdef TBranch* Ele24LooseTau30TightIDPass_branch
    cdef float Ele24LooseTau30TightIDPass_value

    cdef TBranch* Ele27WPTightPass_branch
    cdef float Ele27WPTightPass_value

    cdef TBranch* Ele32WPTightPass_branch
    cdef float Ele32WPTightPass_value

    cdef TBranch* Ele35WPTightPass_branch
    cdef float Ele35WPTightPass_value

    cdef TBranch* Ele38WPTightPass_branch
    cdef float Ele38WPTightPass_value

    cdef TBranch* Ele40WPTightPass_branch
    cdef float Ele40WPTightPass_value

    cdef TBranch* EmbPtWeight_branch
    cdef float EmbPtWeight_value

    cdef TBranch* Eta_branch
    cdef float Eta_value

    cdef TBranch* Flag_BadChargedCandidateFilter_branch
    cdef float Flag_BadChargedCandidateFilter_value

    cdef TBranch* Flag_BadPFMuonFilter_branch
    cdef float Flag_BadPFMuonFilter_value

    cdef TBranch* Flag_EcalDeadCellTriggerPrimitiveFilter_branch
    cdef float Flag_EcalDeadCellTriggerPrimitiveFilter_value

    cdef TBranch* Flag_HBHENoiseFilter_branch
    cdef float Flag_HBHENoiseFilter_value

    cdef TBranch* Flag_HBHENoiseIsoFilter_branch
    cdef float Flag_HBHENoiseIsoFilter_value

    cdef TBranch* Flag_ecalBadCalibFilter_branch
    cdef float Flag_ecalBadCalibFilter_value

    cdef TBranch* Flag_globalTightHalo2016Filter_branch
    cdef float Flag_globalTightHalo2016Filter_value

    cdef TBranch* Flag_goodVertices_branch
    cdef float Flag_goodVertices_value

    cdef TBranch* GenWeight_branch
    cdef float GenWeight_value

    cdef TBranch* Ht_branch
    cdef float Ht_value

    cdef TBranch* IsoMu24Pass_branch
    cdef float IsoMu24Pass_value

    cdef TBranch* IsoMu27Pass_branch
    cdef float IsoMu27Pass_value

    cdef TBranch* LT_branch
    cdef float LT_value

    cdef TBranch* Mass_branch
    cdef float Mass_value

    cdef TBranch* MassError_branch
    cdef float MassError_value

    cdef TBranch* MassErrord1_branch
    cdef float MassErrord1_value

    cdef TBranch* MassErrord2_branch
    cdef float MassErrord2_value

    cdef TBranch* MassErrord3_branch
    cdef float MassErrord3_value

    cdef TBranch* MassErrord4_branch
    cdef float MassErrord4_value

    cdef TBranch* Mt_branch
    cdef float Mt_value

    cdef TBranch* Mu20LooseHPSTau27Pass_branch
    cdef float Mu20LooseHPSTau27Pass_value

    cdef TBranch* Mu20LooseHPSTau27TightIDPass_branch
    cdef float Mu20LooseHPSTau27TightIDPass_value

    cdef TBranch* Mu20LooseTau27Pass_branch
    cdef float Mu20LooseTau27Pass_value

    cdef TBranch* Mu20LooseTau27TightIDPass_branch
    cdef float Mu20LooseTau27TightIDPass_value

    cdef TBranch* Mu50Pass_branch
    cdef float Mu50Pass_value

    cdef TBranch* NUP_branch
    cdef float NUP_value

    cdef TBranch* Phi_branch
    cdef float Phi_value

    cdef TBranch* Pt_branch
    cdef float Pt_value

    cdef TBranch* VBFDoubleLooseHPSTau20Pass_branch
    cdef float VBFDoubleLooseHPSTau20Pass_value

    cdef TBranch* VBFDoubleLooseTau20Pass_branch
    cdef float VBFDoubleLooseTau20Pass_value

    cdef TBranch* VBFDoubleMediumHPSTau20Pass_branch
    cdef float VBFDoubleMediumHPSTau20Pass_value

    cdef TBranch* VBFDoubleMediumTau20Pass_branch
    cdef float VBFDoubleMediumTau20Pass_value

    cdef TBranch* VBFDoubleTightHPSTau20Pass_branch
    cdef float VBFDoubleTightHPSTau20Pass_value

    cdef TBranch* VBFDoubleTightTau20Pass_branch
    cdef float VBFDoubleTightTau20Pass_value

    cdef TBranch* bjetDeepCSVVeto20Loose_2016_DR0p5_branch
    cdef float bjetDeepCSVVeto20Loose_2016_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Loose_2017_DR0p5_branch
    cdef float bjetDeepCSVVeto20Loose_2017_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Loose_2018_DR0p5_branch
    cdef float bjetDeepCSVVeto20Loose_2018_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Medium_branch
    cdef float bjetDeepCSVVeto20Medium_value

    cdef TBranch* bjetDeepCSVVeto20MediumWoNoisyJets_branch
    cdef float bjetDeepCSVVeto20MediumWoNoisyJets_value

    cdef TBranch* bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch
    cdef float bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2016_DR0_branch
    cdef float bjetDeepCSVVeto20Medium_2016_DR0_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2016_DR0p5_branch
    cdef float bjetDeepCSVVeto20Medium_2016_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2017_DR0_branch
    cdef float bjetDeepCSVVeto20Medium_2017_DR0_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2017_DR0p5_branch
    cdef float bjetDeepCSVVeto20Medium_2017_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2018_DR0_branch
    cdef float bjetDeepCSVVeto20Medium_2018_DR0_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2018_DR0p5_branch
    cdef float bjetDeepCSVVeto20Medium_2018_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Tight_2016_DR0p5_branch
    cdef float bjetDeepCSVVeto20Tight_2016_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Tight_2017_DR0p5_branch
    cdef float bjetDeepCSVVeto20Tight_2017_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Tight_2018_DR0p5_branch
    cdef float bjetDeepCSVVeto20Tight_2018_DR0p5_value

    cdef TBranch* charge_branch
    cdef float charge_value

    cdef TBranch* dielectronVeto_branch
    cdef float dielectronVeto_value

    cdef TBranch* dimu9ele9Pass_branch
    cdef float dimu9ele9Pass_value

    cdef TBranch* dimuonVeto_branch
    cdef float dimuonVeto_value

    cdef TBranch* doubleE25Pass_branch
    cdef float doubleE25Pass_value

    cdef TBranch* doubleE33Pass_branch
    cdef float doubleE33Pass_value

    cdef TBranch* doubleE_23_12Pass_branch
    cdef float doubleE_23_12Pass_value

    cdef TBranch* doubleMuDZminMass3p8Pass_branch
    cdef float doubleMuDZminMass3p8Pass_value

    cdef TBranch* doubleMuDZminMass8Pass_branch
    cdef float doubleMuDZminMass8Pass_value

    cdef TBranch* doubleMuSingleEPass_branch
    cdef float doubleMuSingleEPass_value

    cdef TBranch* doubleTau35Pass_branch
    cdef float doubleTau35Pass_value

    cdef TBranch* doubleTauCmbIso35RegPass_branch
    cdef float doubleTauCmbIso35RegPass_value

    cdef TBranch* eCBIDLoose_branch
    cdef float eCBIDLoose_value

    cdef TBranch* eCBIDMedium_branch
    cdef float eCBIDMedium_value

    cdef TBranch* eCBIDTight_branch
    cdef float eCBIDTight_value

    cdef TBranch* eCBIDVeto_branch
    cdef float eCBIDVeto_value

    cdef TBranch* eCharge_branch
    cdef float eCharge_value

    cdef TBranch* eChargeIdLoose_branch
    cdef float eChargeIdLoose_value

    cdef TBranch* eChargeIdMed_branch
    cdef float eChargeIdMed_value

    cdef TBranch* eChargeIdTight_branch
    cdef float eChargeIdTight_value

    cdef TBranch* eComesFromHiggs_branch
    cdef float eComesFromHiggs_value

    cdef TBranch* eCorrectedEt_branch
    cdef float eCorrectedEt_value

    cdef TBranch* eE1x5_branch
    cdef float eE1x5_value

    cdef TBranch* eE2x5Max_branch
    cdef float eE2x5Max_value

    cdef TBranch* eE5x5_branch
    cdef float eE5x5_value

    cdef TBranch* eEcalIsoDR03_branch
    cdef float eEcalIsoDR03_value

    cdef TBranch* eEnergyError_branch
    cdef float eEnergyError_value

    cdef TBranch* eEnergyScaleDown_branch
    cdef float eEnergyScaleDown_value

    cdef TBranch* eEnergyScaleGainDown_branch
    cdef float eEnergyScaleGainDown_value

    cdef TBranch* eEnergyScaleGainUp_branch
    cdef float eEnergyScaleGainUp_value

    cdef TBranch* eEnergyScaleStatDown_branch
    cdef float eEnergyScaleStatDown_value

    cdef TBranch* eEnergyScaleStatUp_branch
    cdef float eEnergyScaleStatUp_value

    cdef TBranch* eEnergyScaleSystDown_branch
    cdef float eEnergyScaleSystDown_value

    cdef TBranch* eEnergyScaleSystUp_branch
    cdef float eEnergyScaleSystUp_value

    cdef TBranch* eEnergyScaleUp_branch
    cdef float eEnergyScaleUp_value

    cdef TBranch* eEnergySigmaDown_branch
    cdef float eEnergySigmaDown_value

    cdef TBranch* eEnergySigmaPhiDown_branch
    cdef float eEnergySigmaPhiDown_value

    cdef TBranch* eEnergySigmaPhiUp_branch
    cdef float eEnergySigmaPhiUp_value

    cdef TBranch* eEnergySigmaRhoDown_branch
    cdef float eEnergySigmaRhoDown_value

    cdef TBranch* eEnergySigmaRhoUp_branch
    cdef float eEnergySigmaRhoUp_value

    cdef TBranch* eEnergySigmaUp_branch
    cdef float eEnergySigmaUp_value

    cdef TBranch* eEta_branch
    cdef float eEta_value

    cdef TBranch* eGenCharge_branch
    cdef float eGenCharge_value

    cdef TBranch* eGenEnergy_branch
    cdef float eGenEnergy_value

    cdef TBranch* eGenEta_branch
    cdef float eGenEta_value

    cdef TBranch* eGenMotherPdgId_branch
    cdef float eGenMotherPdgId_value

    cdef TBranch* eGenParticle_branch
    cdef float eGenParticle_value

    cdef TBranch* eGenPdgId_branch
    cdef float eGenPdgId_value

    cdef TBranch* eGenPhi_branch
    cdef float eGenPhi_value

    cdef TBranch* eGenPrompt_branch
    cdef float eGenPrompt_value

    cdef TBranch* eGenPromptTauDecay_branch
    cdef float eGenPromptTauDecay_value

    cdef TBranch* eGenPt_branch
    cdef float eGenPt_value

    cdef TBranch* eGenTauDecay_branch
    cdef float eGenTauDecay_value

    cdef TBranch* eGenVZ_branch
    cdef float eGenVZ_value

    cdef TBranch* eGenVtxPVMatch_branch
    cdef float eGenVtxPVMatch_value

    cdef TBranch* eHadronicDepth1OverEm_branch
    cdef float eHadronicDepth1OverEm_value

    cdef TBranch* eHadronicDepth2OverEm_branch
    cdef float eHadronicDepth2OverEm_value

    cdef TBranch* eHadronicOverEM_branch
    cdef float eHadronicOverEM_value

    cdef TBranch* eHcalIsoDR03_branch
    cdef float eHcalIsoDR03_value

    cdef TBranch* eIP3D_branch
    cdef float eIP3D_value

    cdef TBranch* eIP3DErr_branch
    cdef float eIP3DErr_value

    cdef TBranch* eJetArea_branch
    cdef float eJetArea_value

    cdef TBranch* eJetBtag_branch
    cdef float eJetBtag_value

    cdef TBranch* eJetDR_branch
    cdef float eJetDR_value

    cdef TBranch* eJetEtaEtaMoment_branch
    cdef float eJetEtaEtaMoment_value

    cdef TBranch* eJetEtaPhiMoment_branch
    cdef float eJetEtaPhiMoment_value

    cdef TBranch* eJetEtaPhiSpread_branch
    cdef float eJetEtaPhiSpread_value

    cdef TBranch* eJetHadronFlavour_branch
    cdef float eJetHadronFlavour_value

    cdef TBranch* eJetPFCISVBtag_branch
    cdef float eJetPFCISVBtag_value

    cdef TBranch* eJetPartonFlavour_branch
    cdef float eJetPartonFlavour_value

    cdef TBranch* eJetPhiPhiMoment_branch
    cdef float eJetPhiPhiMoment_value

    cdef TBranch* eJetPt_branch
    cdef float eJetPt_value

    cdef TBranch* eLowestMll_branch
    cdef float eLowestMll_value

    cdef TBranch* eMVAIsoWP80_branch
    cdef float eMVAIsoWP80_value

    cdef TBranch* eMVAIsoWP90_branch
    cdef float eMVAIsoWP90_value

    cdef TBranch* eMVAIsoWPHZZ_branch
    cdef float eMVAIsoWPHZZ_value

    cdef TBranch* eMVAIsoWPLoose_branch
    cdef float eMVAIsoWPLoose_value

    cdef TBranch* eMVANoisoWP80_branch
    cdef float eMVANoisoWP80_value

    cdef TBranch* eMVANoisoWP90_branch
    cdef float eMVANoisoWP90_value

    cdef TBranch* eMVANoisoWPLoose_branch
    cdef float eMVANoisoWPLoose_value

    cdef TBranch* eMass_branch
    cdef float eMass_value

    cdef TBranch* eMatchesEle24Tau30Filter_branch
    cdef float eMatchesEle24Tau30Filter_value

    cdef TBranch* eMatchesEle24Tau30Path_branch
    cdef float eMatchesEle24Tau30Path_value

    cdef TBranch* eMatchesEle27Filter_branch
    cdef float eMatchesEle27Filter_value

    cdef TBranch* eMatchesEle27Path_branch
    cdef float eMatchesEle27Path_value

    cdef TBranch* eMatchesEle32Filter_branch
    cdef float eMatchesEle32Filter_value

    cdef TBranch* eMatchesEle32Path_branch
    cdef float eMatchesEle32Path_value

    cdef TBranch* eMatchesEle35Filter_branch
    cdef float eMatchesEle35Filter_value

    cdef TBranch* eMatchesEle35Path_branch
    cdef float eMatchesEle35Path_value

    cdef TBranch* eMatchesMu23e12DZFilter_branch
    cdef float eMatchesMu23e12DZFilter_value

    cdef TBranch* eMatchesMu23e12DZPath_branch
    cdef float eMatchesMu23e12DZPath_value

    cdef TBranch* eMatchesMu8e23DZFilter_branch
    cdef float eMatchesMu8e23DZFilter_value

    cdef TBranch* eMatchesMu8e23DZPath_branch
    cdef float eMatchesMu8e23DZPath_value

    cdef TBranch* eMissingHits_branch
    cdef float eMissingHits_value

    cdef TBranch* eNearMuonVeto_branch
    cdef float eNearMuonVeto_value

    cdef TBranch* eNearestMuonDR_branch
    cdef float eNearestMuonDR_value

    cdef TBranch* eNearestZMass_branch
    cdef float eNearestZMass_value

    cdef TBranch* ePFChargedIso_branch
    cdef float ePFChargedIso_value

    cdef TBranch* ePFNeutralIso_branch
    cdef float ePFNeutralIso_value

    cdef TBranch* ePFPUChargedIso_branch
    cdef float ePFPUChargedIso_value

    cdef TBranch* ePFPhotonIso_branch
    cdef float ePFPhotonIso_value

    cdef TBranch* ePVDXY_branch
    cdef float ePVDXY_value

    cdef TBranch* ePVDZ_branch
    cdef float ePVDZ_value

    cdef TBranch* ePassesConversionVeto_branch
    cdef float ePassesConversionVeto_value

    cdef TBranch* ePhi_branch
    cdef float ePhi_value

    cdef TBranch* ePt_branch
    cdef float ePt_value

    cdef TBranch* eRelIso_branch
    cdef float eRelIso_value

    cdef TBranch* eRelPFIsoDB_branch
    cdef float eRelPFIsoDB_value

    cdef TBranch* eRelPFIsoRho_branch
    cdef float eRelPFIsoRho_value

    cdef TBranch* eRho_branch
    cdef float eRho_value

    cdef TBranch* eSCEnergy_branch
    cdef float eSCEnergy_value

    cdef TBranch* eSCEta_branch
    cdef float eSCEta_value

    cdef TBranch* eSCEtaWidth_branch
    cdef float eSCEtaWidth_value

    cdef TBranch* eSCPhi_branch
    cdef float eSCPhi_value

    cdef TBranch* eSCPhiWidth_branch
    cdef float eSCPhiWidth_value

    cdef TBranch* eSCPreshowerEnergy_branch
    cdef float eSCPreshowerEnergy_value

    cdef TBranch* eSCRawEnergy_branch
    cdef float eSCRawEnergy_value

    cdef TBranch* eSIP2D_branch
    cdef float eSIP2D_value

    cdef TBranch* eSIP3D_branch
    cdef float eSIP3D_value

    cdef TBranch* eSigmaIEtaIEta_branch
    cdef float eSigmaIEtaIEta_value

    cdef TBranch* eTrkIsoDR03_branch
    cdef float eTrkIsoDR03_value

    cdef TBranch* eVZ_branch
    cdef float eVZ_value

    cdef TBranch* eVetoHZZPt5_branch
    cdef float eVetoHZZPt5_value

    cdef TBranch* eVetoMVAIso_branch
    cdef float eVetoMVAIso_value

    cdef TBranch* eVetoZTTp001dxyz_branch
    cdef float eVetoZTTp001dxyz_value

    cdef TBranch* eVetoZTTp001dxyzR0_branch
    cdef float eVetoZTTp001dxyzR0_value

    cdef TBranch* eZTTGenMatching_branch
    cdef float eZTTGenMatching_value

    cdef TBranch* e_t_DR_branch
    cdef float e_t_DR_value

    cdef TBranch* e_t_Mass_branch
    cdef float e_t_Mass_value

    cdef TBranch* e_t_PZeta_branch
    cdef float e_t_PZeta_value

    cdef TBranch* e_t_PZetaVis_branch
    cdef float e_t_PZetaVis_value

    cdef TBranch* edeltaEtaSuperClusterTrackAtVtx_branch
    cdef float edeltaEtaSuperClusterTrackAtVtx_value

    cdef TBranch* edeltaPhiSuperClusterTrackAtVtx_branch
    cdef float edeltaPhiSuperClusterTrackAtVtx_value

    cdef TBranch* eeSuperClusterOverP_branch
    cdef float eeSuperClusterOverP_value

    cdef TBranch* eecalEnergy_branch
    cdef float eecalEnergy_value

    cdef TBranch* efBrem_branch
    cdef float efBrem_value

    cdef TBranch* etrackMomentumAtVtxP_branch
    cdef float etrackMomentumAtVtxP_value

    cdef TBranch* evt_branch
    cdef unsigned long evt_value

    cdef TBranch* genHTT_branch
    cdef float genHTT_value

    cdef TBranch* genpX_branch
    cdef float genpX_value

    cdef TBranch* genpY_branch
    cdef float genpY_value

    cdef TBranch* isWenu_branch
    cdef float isWenu_value

    cdef TBranch* isWmunu_branch
    cdef float isWmunu_value

    cdef TBranch* isWtaunu_branch
    cdef float isWtaunu_value

    cdef TBranch* isZee_branch
    cdef float isZee_value

    cdef TBranch* isZmumu_branch
    cdef float isZmumu_value

    cdef TBranch* isZtautau_branch
    cdef float isZtautau_value

    cdef TBranch* isdata_branch
    cdef int isdata_value

    cdef TBranch* isembed_branch
    cdef int isembed_value

    cdef TBranch* jb1eta_branch
    cdef float jb1eta_value

    cdef TBranch* jb1hadronflavor_branch
    cdef float jb1hadronflavor_value

    cdef TBranch* jb1pt_branch
    cdef float jb1pt_value

    cdef TBranch* jetVeto20_branch
    cdef float jetVeto20_value

    cdef TBranch* jetVeto20WoNoisyJets_branch
    cdef float jetVeto20WoNoisyJets_value

    cdef TBranch* jetVeto20_JetEnDown_branch
    cdef float jetVeto20_JetEnDown_value

    cdef TBranch* jetVeto20_JetEnUp_branch
    cdef float jetVeto20_JetEnUp_value

    cdef TBranch* jetVeto30_branch
    cdef float jetVeto30_value

    cdef TBranch* jetVeto30WoNoisyJets_branch
    cdef float jetVeto30WoNoisyJets_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEnDown_branch
    cdef float jetVeto30WoNoisyJets_JetEnDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEnUp_branch
    cdef float jetVeto30WoNoisyJets_JetEnUp_value

    cdef TBranch* jetVeto30_JetEnDown_branch
    cdef float jetVeto30_JetEnDown_value

    cdef TBranch* jetVeto30_JetEnUp_branch
    cdef float jetVeto30_JetEnUp_value

    cdef TBranch* lheweight0_branch
    cdef float lheweight0_value

    cdef TBranch* lheweight1_branch
    cdef float lheweight1_value

    cdef TBranch* lheweight10_branch
    cdef float lheweight10_value

    cdef TBranch* lheweight100_branch
    cdef float lheweight100_value

    cdef TBranch* lheweight101_branch
    cdef float lheweight101_value

    cdef TBranch* lheweight102_branch
    cdef float lheweight102_value

    cdef TBranch* lheweight103_branch
    cdef float lheweight103_value

    cdef TBranch* lheweight104_branch
    cdef float lheweight104_value

    cdef TBranch* lheweight105_branch
    cdef float lheweight105_value

    cdef TBranch* lheweight106_branch
    cdef float lheweight106_value

    cdef TBranch* lheweight107_branch
    cdef float lheweight107_value

    cdef TBranch* lheweight108_branch
    cdef float lheweight108_value

    cdef TBranch* lheweight109_branch
    cdef float lheweight109_value

    cdef TBranch* lheweight11_branch
    cdef float lheweight11_value

    cdef TBranch* lheweight110_branch
    cdef float lheweight110_value

    cdef TBranch* lheweight111_branch
    cdef float lheweight111_value

    cdef TBranch* lheweight112_branch
    cdef float lheweight112_value

    cdef TBranch* lheweight113_branch
    cdef float lheweight113_value

    cdef TBranch* lheweight114_branch
    cdef float lheweight114_value

    cdef TBranch* lheweight115_branch
    cdef float lheweight115_value

    cdef TBranch* lheweight116_branch
    cdef float lheweight116_value

    cdef TBranch* lheweight117_branch
    cdef float lheweight117_value

    cdef TBranch* lheweight118_branch
    cdef float lheweight118_value

    cdef TBranch* lheweight119_branch
    cdef float lheweight119_value

    cdef TBranch* lheweight12_branch
    cdef float lheweight12_value

    cdef TBranch* lheweight120_branch
    cdef float lheweight120_value

    cdef TBranch* lheweight121_branch
    cdef float lheweight121_value

    cdef TBranch* lheweight122_branch
    cdef float lheweight122_value

    cdef TBranch* lheweight123_branch
    cdef float lheweight123_value

    cdef TBranch* lheweight124_branch
    cdef float lheweight124_value

    cdef TBranch* lheweight125_branch
    cdef float lheweight125_value

    cdef TBranch* lheweight126_branch
    cdef float lheweight126_value

    cdef TBranch* lheweight127_branch
    cdef float lheweight127_value

    cdef TBranch* lheweight128_branch
    cdef float lheweight128_value

    cdef TBranch* lheweight129_branch
    cdef float lheweight129_value

    cdef TBranch* lheweight13_branch
    cdef float lheweight13_value

    cdef TBranch* lheweight130_branch
    cdef float lheweight130_value

    cdef TBranch* lheweight131_branch
    cdef float lheweight131_value

    cdef TBranch* lheweight132_branch
    cdef float lheweight132_value

    cdef TBranch* lheweight133_branch
    cdef float lheweight133_value

    cdef TBranch* lheweight134_branch
    cdef float lheweight134_value

    cdef TBranch* lheweight135_branch
    cdef float lheweight135_value

    cdef TBranch* lheweight136_branch
    cdef float lheweight136_value

    cdef TBranch* lheweight137_branch
    cdef float lheweight137_value

    cdef TBranch* lheweight138_branch
    cdef float lheweight138_value

    cdef TBranch* lheweight139_branch
    cdef float lheweight139_value

    cdef TBranch* lheweight14_branch
    cdef float lheweight14_value

    cdef TBranch* lheweight140_branch
    cdef float lheweight140_value

    cdef TBranch* lheweight141_branch
    cdef float lheweight141_value

    cdef TBranch* lheweight142_branch
    cdef float lheweight142_value

    cdef TBranch* lheweight143_branch
    cdef float lheweight143_value

    cdef TBranch* lheweight144_branch
    cdef float lheweight144_value

    cdef TBranch* lheweight145_branch
    cdef float lheweight145_value

    cdef TBranch* lheweight146_branch
    cdef float lheweight146_value

    cdef TBranch* lheweight147_branch
    cdef float lheweight147_value

    cdef TBranch* lheweight148_branch
    cdef float lheweight148_value

    cdef TBranch* lheweight149_branch
    cdef float lheweight149_value

    cdef TBranch* lheweight15_branch
    cdef float lheweight15_value

    cdef TBranch* lheweight150_branch
    cdef float lheweight150_value

    cdef TBranch* lheweight151_branch
    cdef float lheweight151_value

    cdef TBranch* lheweight152_branch
    cdef float lheweight152_value

    cdef TBranch* lheweight153_branch
    cdef float lheweight153_value

    cdef TBranch* lheweight154_branch
    cdef float lheweight154_value

    cdef TBranch* lheweight155_branch
    cdef float lheweight155_value

    cdef TBranch* lheweight156_branch
    cdef float lheweight156_value

    cdef TBranch* lheweight157_branch
    cdef float lheweight157_value

    cdef TBranch* lheweight158_branch
    cdef float lheweight158_value

    cdef TBranch* lheweight159_branch
    cdef float lheweight159_value

    cdef TBranch* lheweight16_branch
    cdef float lheweight16_value

    cdef TBranch* lheweight160_branch
    cdef float lheweight160_value

    cdef TBranch* lheweight161_branch
    cdef float lheweight161_value

    cdef TBranch* lheweight162_branch
    cdef float lheweight162_value

    cdef TBranch* lheweight163_branch
    cdef float lheweight163_value

    cdef TBranch* lheweight164_branch
    cdef float lheweight164_value

    cdef TBranch* lheweight165_branch
    cdef float lheweight165_value

    cdef TBranch* lheweight166_branch
    cdef float lheweight166_value

    cdef TBranch* lheweight167_branch
    cdef float lheweight167_value

    cdef TBranch* lheweight168_branch
    cdef float lheweight168_value

    cdef TBranch* lheweight169_branch
    cdef float lheweight169_value

    cdef TBranch* lheweight17_branch
    cdef float lheweight17_value

    cdef TBranch* lheweight170_branch
    cdef float lheweight170_value

    cdef TBranch* lheweight171_branch
    cdef float lheweight171_value

    cdef TBranch* lheweight172_branch
    cdef float lheweight172_value

    cdef TBranch* lheweight173_branch
    cdef float lheweight173_value

    cdef TBranch* lheweight174_branch
    cdef float lheweight174_value

    cdef TBranch* lheweight175_branch
    cdef float lheweight175_value

    cdef TBranch* lheweight176_branch
    cdef float lheweight176_value

    cdef TBranch* lheweight177_branch
    cdef float lheweight177_value

    cdef TBranch* lheweight178_branch
    cdef float lheweight178_value

    cdef TBranch* lheweight179_branch
    cdef float lheweight179_value

    cdef TBranch* lheweight18_branch
    cdef float lheweight18_value

    cdef TBranch* lheweight180_branch
    cdef float lheweight180_value

    cdef TBranch* lheweight181_branch
    cdef float lheweight181_value

    cdef TBranch* lheweight182_branch
    cdef float lheweight182_value

    cdef TBranch* lheweight183_branch
    cdef float lheweight183_value

    cdef TBranch* lheweight184_branch
    cdef float lheweight184_value

    cdef TBranch* lheweight185_branch
    cdef float lheweight185_value

    cdef TBranch* lheweight186_branch
    cdef float lheweight186_value

    cdef TBranch* lheweight187_branch
    cdef float lheweight187_value

    cdef TBranch* lheweight188_branch
    cdef float lheweight188_value

    cdef TBranch* lheweight189_branch
    cdef float lheweight189_value

    cdef TBranch* lheweight19_branch
    cdef float lheweight19_value

    cdef TBranch* lheweight190_branch
    cdef float lheweight190_value

    cdef TBranch* lheweight191_branch
    cdef float lheweight191_value

    cdef TBranch* lheweight192_branch
    cdef float lheweight192_value

    cdef TBranch* lheweight193_branch
    cdef float lheweight193_value

    cdef TBranch* lheweight194_branch
    cdef float lheweight194_value

    cdef TBranch* lheweight195_branch
    cdef float lheweight195_value

    cdef TBranch* lheweight196_branch
    cdef float lheweight196_value

    cdef TBranch* lheweight197_branch
    cdef float lheweight197_value

    cdef TBranch* lheweight198_branch
    cdef float lheweight198_value

    cdef TBranch* lheweight199_branch
    cdef float lheweight199_value

    cdef TBranch* lheweight2_branch
    cdef float lheweight2_value

    cdef TBranch* lheweight20_branch
    cdef float lheweight20_value

    cdef TBranch* lheweight200_branch
    cdef float lheweight200_value

    cdef TBranch* lheweight201_branch
    cdef float lheweight201_value

    cdef TBranch* lheweight202_branch
    cdef float lheweight202_value

    cdef TBranch* lheweight203_branch
    cdef float lheweight203_value

    cdef TBranch* lheweight204_branch
    cdef float lheweight204_value

    cdef TBranch* lheweight205_branch
    cdef float lheweight205_value

    cdef TBranch* lheweight206_branch
    cdef float lheweight206_value

    cdef TBranch* lheweight207_branch
    cdef float lheweight207_value

    cdef TBranch* lheweight208_branch
    cdef float lheweight208_value

    cdef TBranch* lheweight209_branch
    cdef float lheweight209_value

    cdef TBranch* lheweight21_branch
    cdef float lheweight21_value

    cdef TBranch* lheweight210_branch
    cdef float lheweight210_value

    cdef TBranch* lheweight211_branch
    cdef float lheweight211_value

    cdef TBranch* lheweight212_branch
    cdef float lheweight212_value

    cdef TBranch* lheweight213_branch
    cdef float lheweight213_value

    cdef TBranch* lheweight214_branch
    cdef float lheweight214_value

    cdef TBranch* lheweight215_branch
    cdef float lheweight215_value

    cdef TBranch* lheweight216_branch
    cdef float lheweight216_value

    cdef TBranch* lheweight217_branch
    cdef float lheweight217_value

    cdef TBranch* lheweight218_branch
    cdef float lheweight218_value

    cdef TBranch* lheweight219_branch
    cdef float lheweight219_value

    cdef TBranch* lheweight22_branch
    cdef float lheweight22_value

    cdef TBranch* lheweight220_branch
    cdef float lheweight220_value

    cdef TBranch* lheweight221_branch
    cdef float lheweight221_value

    cdef TBranch* lheweight23_branch
    cdef float lheweight23_value

    cdef TBranch* lheweight24_branch
    cdef float lheweight24_value

    cdef TBranch* lheweight25_branch
    cdef float lheweight25_value

    cdef TBranch* lheweight26_branch
    cdef float lheweight26_value

    cdef TBranch* lheweight27_branch
    cdef float lheweight27_value

    cdef TBranch* lheweight28_branch
    cdef float lheweight28_value

    cdef TBranch* lheweight29_branch
    cdef float lheweight29_value

    cdef TBranch* lheweight3_branch
    cdef float lheweight3_value

    cdef TBranch* lheweight30_branch
    cdef float lheweight30_value

    cdef TBranch* lheweight31_branch
    cdef float lheweight31_value

    cdef TBranch* lheweight32_branch
    cdef float lheweight32_value

    cdef TBranch* lheweight33_branch
    cdef float lheweight33_value

    cdef TBranch* lheweight34_branch
    cdef float lheweight34_value

    cdef TBranch* lheweight35_branch
    cdef float lheweight35_value

    cdef TBranch* lheweight36_branch
    cdef float lheweight36_value

    cdef TBranch* lheweight37_branch
    cdef float lheweight37_value

    cdef TBranch* lheweight38_branch
    cdef float lheweight38_value

    cdef TBranch* lheweight39_branch
    cdef float lheweight39_value

    cdef TBranch* lheweight4_branch
    cdef float lheweight4_value

    cdef TBranch* lheweight40_branch
    cdef float lheweight40_value

    cdef TBranch* lheweight41_branch
    cdef float lheweight41_value

    cdef TBranch* lheweight42_branch
    cdef float lheweight42_value

    cdef TBranch* lheweight43_branch
    cdef float lheweight43_value

    cdef TBranch* lheweight44_branch
    cdef float lheweight44_value

    cdef TBranch* lheweight45_branch
    cdef float lheweight45_value

    cdef TBranch* lheweight46_branch
    cdef float lheweight46_value

    cdef TBranch* lheweight47_branch
    cdef float lheweight47_value

    cdef TBranch* lheweight48_branch
    cdef float lheweight48_value

    cdef TBranch* lheweight49_branch
    cdef float lheweight49_value

    cdef TBranch* lheweight5_branch
    cdef float lheweight5_value

    cdef TBranch* lheweight50_branch
    cdef float lheweight50_value

    cdef TBranch* lheweight51_branch
    cdef float lheweight51_value

    cdef TBranch* lheweight52_branch
    cdef float lheweight52_value

    cdef TBranch* lheweight53_branch
    cdef float lheweight53_value

    cdef TBranch* lheweight54_branch
    cdef float lheweight54_value

    cdef TBranch* lheweight55_branch
    cdef float lheweight55_value

    cdef TBranch* lheweight56_branch
    cdef float lheweight56_value

    cdef TBranch* lheweight57_branch
    cdef float lheweight57_value

    cdef TBranch* lheweight58_branch
    cdef float lheweight58_value

    cdef TBranch* lheweight59_branch
    cdef float lheweight59_value

    cdef TBranch* lheweight6_branch
    cdef float lheweight6_value

    cdef TBranch* lheweight60_branch
    cdef float lheweight60_value

    cdef TBranch* lheweight61_branch
    cdef float lheweight61_value

    cdef TBranch* lheweight62_branch
    cdef float lheweight62_value

    cdef TBranch* lheweight63_branch
    cdef float lheweight63_value

    cdef TBranch* lheweight64_branch
    cdef float lheweight64_value

    cdef TBranch* lheweight65_branch
    cdef float lheweight65_value

    cdef TBranch* lheweight66_branch
    cdef float lheweight66_value

    cdef TBranch* lheweight67_branch
    cdef float lheweight67_value

    cdef TBranch* lheweight68_branch
    cdef float lheweight68_value

    cdef TBranch* lheweight69_branch
    cdef float lheweight69_value

    cdef TBranch* lheweight7_branch
    cdef float lheweight7_value

    cdef TBranch* lheweight70_branch
    cdef float lheweight70_value

    cdef TBranch* lheweight71_branch
    cdef float lheweight71_value

    cdef TBranch* lheweight72_branch
    cdef float lheweight72_value

    cdef TBranch* lheweight73_branch
    cdef float lheweight73_value

    cdef TBranch* lheweight74_branch
    cdef float lheweight74_value

    cdef TBranch* lheweight75_branch
    cdef float lheweight75_value

    cdef TBranch* lheweight76_branch
    cdef float lheweight76_value

    cdef TBranch* lheweight77_branch
    cdef float lheweight77_value

    cdef TBranch* lheweight78_branch
    cdef float lheweight78_value

    cdef TBranch* lheweight79_branch
    cdef float lheweight79_value

    cdef TBranch* lheweight8_branch
    cdef float lheweight8_value

    cdef TBranch* lheweight80_branch
    cdef float lheweight80_value

    cdef TBranch* lheweight81_branch
    cdef float lheweight81_value

    cdef TBranch* lheweight82_branch
    cdef float lheweight82_value

    cdef TBranch* lheweight83_branch
    cdef float lheweight83_value

    cdef TBranch* lheweight84_branch
    cdef float lheweight84_value

    cdef TBranch* lheweight85_branch
    cdef float lheweight85_value

    cdef TBranch* lheweight86_branch
    cdef float lheweight86_value

    cdef TBranch* lheweight87_branch
    cdef float lheweight87_value

    cdef TBranch* lheweight88_branch
    cdef float lheweight88_value

    cdef TBranch* lheweight89_branch
    cdef float lheweight89_value

    cdef TBranch* lheweight9_branch
    cdef float lheweight9_value

    cdef TBranch* lheweight90_branch
    cdef float lheweight90_value

    cdef TBranch* lheweight91_branch
    cdef float lheweight91_value

    cdef TBranch* lheweight92_branch
    cdef float lheweight92_value

    cdef TBranch* lheweight93_branch
    cdef float lheweight93_value

    cdef TBranch* lheweight94_branch
    cdef float lheweight94_value

    cdef TBranch* lheweight95_branch
    cdef float lheweight95_value

    cdef TBranch* lheweight96_branch
    cdef float lheweight96_value

    cdef TBranch* lheweight97_branch
    cdef float lheweight97_value

    cdef TBranch* lheweight98_branch
    cdef float lheweight98_value

    cdef TBranch* lheweight99_branch
    cdef float lheweight99_value

    cdef TBranch* lumi_branch
    cdef int lumi_value

    cdef TBranch* mu12e23DZPass_branch
    cdef float mu12e23DZPass_value

    cdef TBranch* mu12e23Pass_branch
    cdef float mu12e23Pass_value

    cdef TBranch* mu23e12DZPass_branch
    cdef float mu23e12DZPass_value

    cdef TBranch* mu23e12Pass_branch
    cdef float mu23e12Pass_value

    cdef TBranch* mu8diele12DZPass_branch
    cdef float mu8diele12DZPass_value

    cdef TBranch* mu8diele12Pass_branch
    cdef float mu8diele12Pass_value

    cdef TBranch* mu8e23DZPass_branch
    cdef float mu8e23DZPass_value

    cdef TBranch* mu8e23Pass_branch
    cdef float mu8e23Pass_value

    cdef TBranch* muGlbIsoVetoPt10_branch
    cdef float muGlbIsoVetoPt10_value

    cdef TBranch* muVeto5_branch
    cdef float muVeto5_value

    cdef TBranch* muVetoZTTp001dxyz_branch
    cdef float muVetoZTTp001dxyz_value

    cdef TBranch* muVetoZTTp001dxyzR0_branch
    cdef float muVetoZTTp001dxyzR0_value

    cdef TBranch* nTruePU_branch
    cdef float nTruePU_value

    cdef TBranch* numGenJets_branch
    cdef float numGenJets_value

    cdef TBranch* nvtx_branch
    cdef float nvtx_value

    cdef TBranch* prefiring_weight_branch
    cdef float prefiring_weight_value

    cdef TBranch* processID_branch
    cdef float processID_value

    cdef TBranch* puppiMetEt_branch
    cdef float puppiMetEt_value

    cdef TBranch* puppiMetPhi_branch
    cdef float puppiMetPhi_value

    cdef TBranch* pvChi2_branch
    cdef float pvChi2_value

    cdef TBranch* pvDX_branch
    cdef float pvDX_value

    cdef TBranch* pvDY_branch
    cdef float pvDY_value

    cdef TBranch* pvDZ_branch
    cdef float pvDZ_value

    cdef TBranch* pvIsFake_branch
    cdef int pvIsFake_value

    cdef TBranch* pvIsValid_branch
    cdef int pvIsValid_value

    cdef TBranch* pvNormChi2_branch
    cdef float pvNormChi2_value

    cdef TBranch* pvRho_branch
    cdef float pvRho_value

    cdef TBranch* pvX_branch
    cdef float pvX_value

    cdef TBranch* pvY_branch
    cdef float pvY_value

    cdef TBranch* pvZ_branch
    cdef float pvZ_value

    cdef TBranch* pvndof_branch
    cdef float pvndof_value

    cdef TBranch* recoilDaught_branch
    cdef float recoilDaught_value

    cdef TBranch* recoilWithMet_branch
    cdef float recoilWithMet_value

    cdef TBranch* rho_branch
    cdef float rho_value

    cdef TBranch* run_branch
    cdef int run_value

    cdef TBranch* singleE25eta2p1TightPass_branch
    cdef float singleE25eta2p1TightPass_value

    cdef TBranch* singleIsoMu22Pass_branch
    cdef float singleIsoMu22Pass_value

    cdef TBranch* singleIsoMu22eta2p1Pass_branch
    cdef float singleIsoMu22eta2p1Pass_value

    cdef TBranch* singleIsoTkMu22Pass_branch
    cdef float singleIsoTkMu22Pass_value

    cdef TBranch* singleIsoTkMu22eta2p1Pass_branch
    cdef float singleIsoTkMu22eta2p1Pass_value

    cdef TBranch* singleMu19eta2p1LooseTau20Pass_branch
    cdef float singleMu19eta2p1LooseTau20Pass_value

    cdef TBranch* singleMu19eta2p1LooseTau20singleL1Pass_branch
    cdef float singleMu19eta2p1LooseTau20singleL1Pass_value

    cdef TBranch* tAgainstElectronLooseMVA6_branch
    cdef float tAgainstElectronLooseMVA6_value

    cdef TBranch* tAgainstElectronMVA6Raw_branch
    cdef float tAgainstElectronMVA6Raw_value

    cdef TBranch* tAgainstElectronMVA6category_branch
    cdef float tAgainstElectronMVA6category_value

    cdef TBranch* tAgainstElectronMediumMVA6_branch
    cdef float tAgainstElectronMediumMVA6_value

    cdef TBranch* tAgainstElectronTightMVA6_branch
    cdef float tAgainstElectronTightMVA6_value

    cdef TBranch* tAgainstElectronTightMVA62018_branch
    cdef float tAgainstElectronTightMVA62018_value

    cdef TBranch* tAgainstElectronVLooseMVA6_branch
    cdef float tAgainstElectronVLooseMVA6_value

    cdef TBranch* tAgainstElectronVLooseMVA62018_branch
    cdef float tAgainstElectronVLooseMVA62018_value

    cdef TBranch* tAgainstElectronVTightMVA6_branch
    cdef float tAgainstElectronVTightMVA6_value

    cdef TBranch* tAgainstMuonLoose3_branch
    cdef float tAgainstMuonLoose3_value

    cdef TBranch* tAgainstMuonTight3_branch
    cdef float tAgainstMuonTight3_value

    cdef TBranch* tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch
    cdef float tByCombinedIsolationDeltaBetaCorrRaw3Hits_value

    cdef TBranch* tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch
    cdef float tByIsolationMVArun2v1DBdR03oldDMwLTraw_value

    cdef TBranch* tByIsolationMVArun2v1DBnewDMwLTraw_branch
    cdef float tByIsolationMVArun2v1DBnewDMwLTraw_value

    cdef TBranch* tByIsolationMVArun2v1DBoldDMwLTraw_branch
    cdef float tByIsolationMVArun2v1DBoldDMwLTraw_value

    cdef TBranch* tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch
    cdef float tByLooseCombinedIsolationDeltaBetaCorr3Hits_value

    cdef TBranch* tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByLooseIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByLooseIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch
    cdef float tByMediumCombinedIsolationDeltaBetaCorr3Hits_value

    cdef TBranch* tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByMediumIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByMediumIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByPhotonPtSumOutsideSignalCone_branch
    cdef float tByPhotonPtSumOutsideSignalCone_value

    cdef TBranch* tByTightCombinedIsolationDeltaBetaCorr3Hits_branch
    cdef float tByTightCombinedIsolationDeltaBetaCorr3Hits_value

    cdef TBranch* tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByTightIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByTightIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByTightIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByTightIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByTightIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByVVTightIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByVVTightIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByVVTightIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByVVTightIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tCharge_branch
    cdef float tCharge_value

    cdef TBranch* tChargedIsoPtSum_branch
    cdef float tChargedIsoPtSum_value

    cdef TBranch* tChargedIsoPtSumdR03_branch
    cdef float tChargedIsoPtSumdR03_value

    cdef TBranch* tComesFromHiggs_branch
    cdef float tComesFromHiggs_value

    cdef TBranch* tDecayMode_branch
    cdef float tDecayMode_value

    cdef TBranch* tDecayModeFinding_branch
    cdef float tDecayModeFinding_value

    cdef TBranch* tDecayModeFindingNewDMs_branch
    cdef float tDecayModeFindingNewDMs_value

    cdef TBranch* tEta_branch
    cdef float tEta_value

    cdef TBranch* tFootprintCorrection_branch
    cdef float tFootprintCorrection_value

    cdef TBranch* tFootprintCorrectiondR03_branch
    cdef float tFootprintCorrectiondR03_value

    cdef TBranch* tGenCharge_branch
    cdef float tGenCharge_value

    cdef TBranch* tGenDecayMode_branch
    cdef float tGenDecayMode_value

    cdef TBranch* tGenEnergy_branch
    cdef float tGenEnergy_value

    cdef TBranch* tGenEta_branch
    cdef float tGenEta_value

    cdef TBranch* tGenJetEta_branch
    cdef float tGenJetEta_value

    cdef TBranch* tGenJetPt_branch
    cdef float tGenJetPt_value

    cdef TBranch* tGenMotherEnergy_branch
    cdef float tGenMotherEnergy_value

    cdef TBranch* tGenMotherEta_branch
    cdef float tGenMotherEta_value

    cdef TBranch* tGenMotherPdgId_branch
    cdef float tGenMotherPdgId_value

    cdef TBranch* tGenMotherPhi_branch
    cdef float tGenMotherPhi_value

    cdef TBranch* tGenMotherPt_branch
    cdef float tGenMotherPt_value

    cdef TBranch* tGenPdgId_branch
    cdef float tGenPdgId_value

    cdef TBranch* tGenPhi_branch
    cdef float tGenPhi_value

    cdef TBranch* tGenPt_branch
    cdef float tGenPt_value

    cdef TBranch* tGenStatus_branch
    cdef float tGenStatus_value

    cdef TBranch* tJetArea_branch
    cdef float tJetArea_value

    cdef TBranch* tJetBtag_branch
    cdef float tJetBtag_value

    cdef TBranch* tJetDR_branch
    cdef float tJetDR_value

    cdef TBranch* tJetEtaEtaMoment_branch
    cdef float tJetEtaEtaMoment_value

    cdef TBranch* tJetEtaPhiMoment_branch
    cdef float tJetEtaPhiMoment_value

    cdef TBranch* tJetEtaPhiSpread_branch
    cdef float tJetEtaPhiSpread_value

    cdef TBranch* tJetHadronFlavour_branch
    cdef float tJetHadronFlavour_value

    cdef TBranch* tJetPFCISVBtag_branch
    cdef float tJetPFCISVBtag_value

    cdef TBranch* tJetPartonFlavour_branch
    cdef float tJetPartonFlavour_value

    cdef TBranch* tJetPhiPhiMoment_branch
    cdef float tJetPhiPhiMoment_value

    cdef TBranch* tJetPt_branch
    cdef float tJetPt_value

    cdef TBranch* tLeadTrackPt_branch
    cdef float tLeadTrackPt_value

    cdef TBranch* tLowestMll_branch
    cdef float tLowestMll_value

    cdef TBranch* tMass_branch
    cdef float tMass_value

    cdef TBranch* tMatchesEle24Tau30Filter_branch
    cdef float tMatchesEle24Tau30Filter_value

    cdef TBranch* tMatchesEle24Tau30Path_branch
    cdef float tMatchesEle24Tau30Path_value

    cdef TBranch* tNChrgHadrIsolationCands_branch
    cdef float tNChrgHadrIsolationCands_value

    cdef TBranch* tNChrgHadrSignalCands_branch
    cdef float tNChrgHadrSignalCands_value

    cdef TBranch* tNGammaSignalCands_branch
    cdef float tNGammaSignalCands_value

    cdef TBranch* tNNeutralHadrSignalCands_branch
    cdef float tNNeutralHadrSignalCands_value

    cdef TBranch* tNSignalCands_branch
    cdef float tNSignalCands_value

    cdef TBranch* tNearestZMass_branch
    cdef float tNearestZMass_value

    cdef TBranch* tNeutralIsoPtSum_branch
    cdef float tNeutralIsoPtSum_value

    cdef TBranch* tNeutralIsoPtSumWeight_branch
    cdef float tNeutralIsoPtSumWeight_value

    cdef TBranch* tNeutralIsoPtSumWeightdR03_branch
    cdef float tNeutralIsoPtSumWeightdR03_value

    cdef TBranch* tNeutralIsoPtSumdR03_branch
    cdef float tNeutralIsoPtSumdR03_value

    cdef TBranch* tPVDXY_branch
    cdef float tPVDXY_value

    cdef TBranch* tPVDZ_branch
    cdef float tPVDZ_value

    cdef TBranch* tPhi_branch
    cdef float tPhi_value

    cdef TBranch* tPhotonPtSumOutsideSignalCone_branch
    cdef float tPhotonPtSumOutsideSignalCone_value

    cdef TBranch* tPhotonPtSumOutsideSignalConedR03_branch
    cdef float tPhotonPtSumOutsideSignalConedR03_value

    cdef TBranch* tPt_branch
    cdef float tPt_value

    cdef TBranch* tPuCorrPtSum_branch
    cdef float tPuCorrPtSum_value

    cdef TBranch* tRerunMVArun2v2DBoldDMwLTLoose_branch
    cdef float tRerunMVArun2v2DBoldDMwLTLoose_value

    cdef TBranch* tRerunMVArun2v2DBoldDMwLTTight_branch
    cdef float tRerunMVArun2v2DBoldDMwLTTight_value

    cdef TBranch* tRerunMVArun2v2DBoldDMwLTVLoose_branch
    cdef float tRerunMVArun2v2DBoldDMwLTVLoose_value

    cdef TBranch* tVZ_branch
    cdef float tVZ_value

    cdef TBranch* tZTTGenMatching_branch
    cdef float tZTTGenMatching_value

    cdef TBranch* tauVetoPt20Loose3HitsVtx_branch
    cdef float tauVetoPt20Loose3HitsVtx_value

    cdef TBranch* tauVetoPt20LooseMVALTVtx_branch
    cdef float tauVetoPt20LooseMVALTVtx_value

    cdef TBranch* tauVetoPt20TightMVALTVtx_branch
    cdef float tauVetoPt20TightMVALTVtx_value

    cdef TBranch* tripleEPass_branch
    cdef float tripleEPass_value

    cdef TBranch* tripleMu10_5_5Pass_branch
    cdef float tripleMu10_5_5Pass_value

    cdef TBranch* tripleMu12_10_5Pass_branch
    cdef float tripleMu12_10_5Pass_value

    cdef TBranch* type1_pfMetEt_branch
    cdef float type1_pfMetEt_value

    cdef TBranch* type1_pfMetPhi_branch
    cdef float type1_pfMetPhi_value

    cdef TBranch* vbfDeta_branch
    cdef float vbfDeta_value

    cdef TBranch* vbfJetVeto20_branch
    cdef float vbfJetVeto20_value

    cdef TBranch* vbfJetVeto30_branch
    cdef float vbfJetVeto30_value

    cdef TBranch* vbfMass_branch
    cdef float vbfMass_value

    cdef TBranch* vbfMassWoNoisyJets_branch
    cdef float vbfMassWoNoisyJets_value

    cdef TBranch* vbfNJets20_branch
    cdef float vbfNJets20_value

    cdef TBranch* vbfNJets30_branch
    cdef float vbfNJets30_value

    cdef TBranch* vbfj1eta_branch
    cdef float vbfj1eta_value

    cdef TBranch* vbfj1pt_branch
    cdef float vbfj1pt_value

    cdef TBranch* vbfj2eta_branch
    cdef float vbfj2eta_value

    cdef TBranch* vbfj2pt_branch
    cdef float vbfj2pt_value

    cdef TBranch* vispX_branch
    cdef float vispX_value

    cdef TBranch* vispY_branch
    cdef float vispY_value

    cdef TBranch* idx_branch
    cdef int idx_value


    def __cinit__(self, ttree):
        #print "cinit"
        # Constructor from a ROOT.TTree
        from ROOT import AsCObject
        self.tree = <TTree*>PyCObject_AsVoidPtr(AsCObject(ttree))
        self.ientry = 0
        self.currentTreeNumber = -1
        #print self.tree.GetEntries()
        #self.load_entry(0)
        self.complained = set([])

    cdef load_entry(self, long i):
        #print "load", i
        # Load the correct tree and setup the branches
        self.localentry = self.tree.LoadTree(i)
        #print "local", self.localentry
        new_tree = self.tree.GetTree()
        #print "tree", <long>(new_tree)
        treenum = self.tree.GetTreeNumber()
        #print "num", treenum
        if treenum != self.currentTreeNumber or new_tree != self.currentTree:
            #print "New tree!"
            self.currentTree = new_tree
            self.currentTreeNumber = treenum
            self.setup_branches(new_tree)

    cdef setup_branches(self, TTree* the_tree):
        #print "setup"

        #print "making DoubleMediumHPSTau35Pass"
        self.DoubleMediumHPSTau35Pass_branch = the_tree.GetBranch("DoubleMediumHPSTau35Pass")
        #if not self.DoubleMediumHPSTau35Pass_branch and "DoubleMediumHPSTau35Pass" not in self.complained:
        if not self.DoubleMediumHPSTau35Pass_branch and "DoubleMediumHPSTau35Pass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35Pass")
        else:
            self.DoubleMediumHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35Pass_value)

        #print "making DoubleMediumHPSTau35TightIDPass"
        self.DoubleMediumHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau35TightIDPass")
        #if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35TightIDPass")
        else:
            self.DoubleMediumHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35TightIDPass_value)

        #print "making DoubleMediumHPSTau40Pass"
        self.DoubleMediumHPSTau40Pass_branch = the_tree.GetBranch("DoubleMediumHPSTau40Pass")
        #if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass" not in self.complained:
        if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40Pass")
        else:
            self.DoubleMediumHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40Pass_value)

        #print "making DoubleMediumHPSTau40TightIDPass"
        self.DoubleMediumHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau40TightIDPass")
        #if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40TightIDPass")
        else:
            self.DoubleMediumHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40TightIDPass_value)

        #print "making DoubleMediumTau35Pass"
        self.DoubleMediumTau35Pass_branch = the_tree.GetBranch("DoubleMediumTau35Pass")
        #if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass" not in self.complained:
        if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35Pass")
        else:
            self.DoubleMediumTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumTau35Pass_value)

        #print "making DoubleMediumTau35TightIDPass"
        self.DoubleMediumTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau35TightIDPass")
        #if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35TightIDPass")
        else:
            self.DoubleMediumTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau35TightIDPass_value)

        #print "making DoubleMediumTau40Pass"
        self.DoubleMediumTau40Pass_branch = the_tree.GetBranch("DoubleMediumTau40Pass")
        #if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass" not in self.complained:
        if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40Pass")
        else:
            self.DoubleMediumTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumTau40Pass_value)

        #print "making DoubleMediumTau40TightIDPass"
        self.DoubleMediumTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau40TightIDPass")
        #if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40TightIDPass")
        else:
            self.DoubleMediumTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau40TightIDPass_value)

        #print "making DoubleTightHPSTau35Pass"
        self.DoubleTightHPSTau35Pass_branch = the_tree.GetBranch("DoubleTightHPSTau35Pass")
        #if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass" not in self.complained:
        if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass":
            warnings.warn( "ETauTree: Expected branch DoubleTightHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35Pass")
        else:
            self.DoubleTightHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35Pass_value)

        #print "making DoubleTightHPSTau35TightIDPass"
        self.DoubleTightHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau35TightIDPass")
        #if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleTightHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35TightIDPass")
        else:
            self.DoubleTightHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35TightIDPass_value)

        #print "making DoubleTightHPSTau40Pass"
        self.DoubleTightHPSTau40Pass_branch = the_tree.GetBranch("DoubleTightHPSTau40Pass")
        #if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass" not in self.complained:
        if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass":
            warnings.warn( "ETauTree: Expected branch DoubleTightHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40Pass")
        else:
            self.DoubleTightHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40Pass_value)

        #print "making DoubleTightHPSTau40TightIDPass"
        self.DoubleTightHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau40TightIDPass")
        #if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleTightHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40TightIDPass")
        else:
            self.DoubleTightHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40TightIDPass_value)

        #print "making DoubleTightTau35Pass"
        self.DoubleTightTau35Pass_branch = the_tree.GetBranch("DoubleTightTau35Pass")
        #if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass" not in self.complained:
        if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass":
            warnings.warn( "ETauTree: Expected branch DoubleTightTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35Pass")
        else:
            self.DoubleTightTau35Pass_branch.SetAddress(<void*>&self.DoubleTightTau35Pass_value)

        #print "making DoubleTightTau35TightIDPass"
        self.DoubleTightTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightTau35TightIDPass")
        #if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass" not in self.complained:
        if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleTightTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35TightIDPass")
        else:
            self.DoubleTightTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau35TightIDPass_value)

        #print "making DoubleTightTau40Pass"
        self.DoubleTightTau40Pass_branch = the_tree.GetBranch("DoubleTightTau40Pass")
        #if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass" not in self.complained:
        if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass":
            warnings.warn( "ETauTree: Expected branch DoubleTightTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40Pass")
        else:
            self.DoubleTightTau40Pass_branch.SetAddress(<void*>&self.DoubleTightTau40Pass_value)

        #print "making DoubleTightTau40TightIDPass"
        self.DoubleTightTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightTau40TightIDPass")
        #if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass" not in self.complained:
        if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleTightTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40TightIDPass")
        else:
            self.DoubleTightTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau40TightIDPass_value)

        #print "making Ele24LooseHPSTau30Pass"
        self.Ele24LooseHPSTau30Pass_branch = the_tree.GetBranch("Ele24LooseHPSTau30Pass")
        #if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass" not in self.complained:
        if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass":
            warnings.warn( "ETauTree: Expected branch Ele24LooseHPSTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30Pass")
        else:
            self.Ele24LooseHPSTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30Pass_value)

        #print "making Ele24LooseHPSTau30TightIDPass"
        self.Ele24LooseHPSTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseHPSTau30TightIDPass")
        #if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass":
            warnings.warn( "ETauTree: Expected branch Ele24LooseHPSTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30TightIDPass")
        else:
            self.Ele24LooseHPSTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30TightIDPass_value)

        #print "making Ele24LooseTau30Pass"
        self.Ele24LooseTau30Pass_branch = the_tree.GetBranch("Ele24LooseTau30Pass")
        #if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass" not in self.complained:
        if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass":
            warnings.warn( "ETauTree: Expected branch Ele24LooseTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30Pass")
        else:
            self.Ele24LooseTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseTau30Pass_value)

        #print "making Ele24LooseTau30TightIDPass"
        self.Ele24LooseTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseTau30TightIDPass")
        #if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass":
            warnings.warn( "ETauTree: Expected branch Ele24LooseTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30TightIDPass")
        else:
            self.Ele24LooseTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseTau30TightIDPass_value)

        #print "making Ele27WPTightPass"
        self.Ele27WPTightPass_branch = the_tree.GetBranch("Ele27WPTightPass")
        #if not self.Ele27WPTightPass_branch and "Ele27WPTightPass" not in self.complained:
        if not self.Ele27WPTightPass_branch and "Ele27WPTightPass":
            warnings.warn( "ETauTree: Expected branch Ele27WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele27WPTightPass")
        else:
            self.Ele27WPTightPass_branch.SetAddress(<void*>&self.Ele27WPTightPass_value)

        #print "making Ele32WPTightPass"
        self.Ele32WPTightPass_branch = the_tree.GetBranch("Ele32WPTightPass")
        #if not self.Ele32WPTightPass_branch and "Ele32WPTightPass" not in self.complained:
        if not self.Ele32WPTightPass_branch and "Ele32WPTightPass":
            warnings.warn( "ETauTree: Expected branch Ele32WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele32WPTightPass")
        else:
            self.Ele32WPTightPass_branch.SetAddress(<void*>&self.Ele32WPTightPass_value)

        #print "making Ele35WPTightPass"
        self.Ele35WPTightPass_branch = the_tree.GetBranch("Ele35WPTightPass")
        #if not self.Ele35WPTightPass_branch and "Ele35WPTightPass" not in self.complained:
        if not self.Ele35WPTightPass_branch and "Ele35WPTightPass":
            warnings.warn( "ETauTree: Expected branch Ele35WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele35WPTightPass")
        else:
            self.Ele35WPTightPass_branch.SetAddress(<void*>&self.Ele35WPTightPass_value)

        #print "making Ele38WPTightPass"
        self.Ele38WPTightPass_branch = the_tree.GetBranch("Ele38WPTightPass")
        #if not self.Ele38WPTightPass_branch and "Ele38WPTightPass" not in self.complained:
        if not self.Ele38WPTightPass_branch and "Ele38WPTightPass":
            warnings.warn( "ETauTree: Expected branch Ele38WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele38WPTightPass")
        else:
            self.Ele38WPTightPass_branch.SetAddress(<void*>&self.Ele38WPTightPass_value)

        #print "making Ele40WPTightPass"
        self.Ele40WPTightPass_branch = the_tree.GetBranch("Ele40WPTightPass")
        #if not self.Ele40WPTightPass_branch and "Ele40WPTightPass" not in self.complained:
        if not self.Ele40WPTightPass_branch and "Ele40WPTightPass":
            warnings.warn( "ETauTree: Expected branch Ele40WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele40WPTightPass")
        else:
            self.Ele40WPTightPass_branch.SetAddress(<void*>&self.Ele40WPTightPass_value)

        #print "making EmbPtWeight"
        self.EmbPtWeight_branch = the_tree.GetBranch("EmbPtWeight")
        #if not self.EmbPtWeight_branch and "EmbPtWeight" not in self.complained:
        if not self.EmbPtWeight_branch and "EmbPtWeight":
            warnings.warn( "ETauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "ETauTree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "ETauTree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making Flag_BadPFMuonFilter"
        self.Flag_BadPFMuonFilter_branch = the_tree.GetBranch("Flag_BadPFMuonFilter")
        #if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter" not in self.complained:
        if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter":
            warnings.warn( "ETauTree: Expected branch Flag_BadPFMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonFilter")
        else:
            self.Flag_BadPFMuonFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonFilter_value)

        #print "making Flag_EcalDeadCellTriggerPrimitiveFilter"
        self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch = the_tree.GetBranch("Flag_EcalDeadCellTriggerPrimitiveFilter")
        #if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter" not in self.complained:
        if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter":
            warnings.warn( "ETauTree: Expected branch Flag_EcalDeadCellTriggerPrimitiveFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_EcalDeadCellTriggerPrimitiveFilter")
        else:
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.SetAddress(<void*>&self.Flag_EcalDeadCellTriggerPrimitiveFilter_value)

        #print "making Flag_HBHENoiseFilter"
        self.Flag_HBHENoiseFilter_branch = the_tree.GetBranch("Flag_HBHENoiseFilter")
        #if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter" not in self.complained:
        if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter":
            warnings.warn( "ETauTree: Expected branch Flag_HBHENoiseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseFilter")
        else:
            self.Flag_HBHENoiseFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseFilter_value)

        #print "making Flag_HBHENoiseIsoFilter"
        self.Flag_HBHENoiseIsoFilter_branch = the_tree.GetBranch("Flag_HBHENoiseIsoFilter")
        #if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter" not in self.complained:
        if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter":
            warnings.warn( "ETauTree: Expected branch Flag_HBHENoiseIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseIsoFilter")
        else:
            self.Flag_HBHENoiseIsoFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseIsoFilter_value)

        #print "making Flag_ecalBadCalibFilter"
        self.Flag_ecalBadCalibFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibFilter")
        #if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter" not in self.complained:
        if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter":
            warnings.warn( "ETauTree: Expected branch Flag_ecalBadCalibFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibFilter")
        else:
            self.Flag_ecalBadCalibFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibFilter_value)

        #print "making Flag_globalTightHalo2016Filter"
        self.Flag_globalTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalTightHalo2016Filter")
        #if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter":
            warnings.warn( "ETauTree: Expected branch Flag_globalTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalTightHalo2016Filter")
        else:
            self.Flag_globalTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalTightHalo2016Filter_value)

        #print "making Flag_goodVertices"
        self.Flag_goodVertices_branch = the_tree.GetBranch("Flag_goodVertices")
        #if not self.Flag_goodVertices_branch and "Flag_goodVertices" not in self.complained:
        if not self.Flag_goodVertices_branch and "Flag_goodVertices":
            warnings.warn( "ETauTree: Expected branch Flag_goodVertices does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_goodVertices")
        else:
            self.Flag_goodVertices_branch.SetAddress(<void*>&self.Flag_goodVertices_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "ETauTree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "ETauTree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

        #print "making IsoMu24Pass"
        self.IsoMu24Pass_branch = the_tree.GetBranch("IsoMu24Pass")
        #if not self.IsoMu24Pass_branch and "IsoMu24Pass" not in self.complained:
        if not self.IsoMu24Pass_branch and "IsoMu24Pass":
            warnings.warn( "ETauTree: Expected branch IsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24Pass")
        else:
            self.IsoMu24Pass_branch.SetAddress(<void*>&self.IsoMu24Pass_value)

        #print "making IsoMu27Pass"
        self.IsoMu27Pass_branch = the_tree.GetBranch("IsoMu27Pass")
        #if not self.IsoMu27Pass_branch and "IsoMu27Pass" not in self.complained:
        if not self.IsoMu27Pass_branch and "IsoMu27Pass":
            warnings.warn( "ETauTree: Expected branch IsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu27Pass")
        else:
            self.IsoMu27Pass_branch.SetAddress(<void*>&self.IsoMu27Pass_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "ETauTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "ETauTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "ETauTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "ETauTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "ETauTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "ETauTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "ETauTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "ETauTree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making Mu20LooseHPSTau27Pass"
        self.Mu20LooseHPSTau27Pass_branch = the_tree.GetBranch("Mu20LooseHPSTau27Pass")
        #if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass" not in self.complained:
        if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass":
            warnings.warn( "ETauTree: Expected branch Mu20LooseHPSTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27Pass")
        else:
            self.Mu20LooseHPSTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27Pass_value)

        #print "making Mu20LooseHPSTau27TightIDPass"
        self.Mu20LooseHPSTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseHPSTau27TightIDPass")
        #if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass":
            warnings.warn( "ETauTree: Expected branch Mu20LooseHPSTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27TightIDPass")
        else:
            self.Mu20LooseHPSTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27TightIDPass_value)

        #print "making Mu20LooseTau27Pass"
        self.Mu20LooseTau27Pass_branch = the_tree.GetBranch("Mu20LooseTau27Pass")
        #if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass" not in self.complained:
        if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass":
            warnings.warn( "ETauTree: Expected branch Mu20LooseTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27Pass")
        else:
            self.Mu20LooseTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseTau27Pass_value)

        #print "making Mu20LooseTau27TightIDPass"
        self.Mu20LooseTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseTau27TightIDPass")
        #if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass":
            warnings.warn( "ETauTree: Expected branch Mu20LooseTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27TightIDPass")
        else:
            self.Mu20LooseTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseTau27TightIDPass_value)

        #print "making Mu50Pass"
        self.Mu50Pass_branch = the_tree.GetBranch("Mu50Pass")
        #if not self.Mu50Pass_branch and "Mu50Pass" not in self.complained:
        if not self.Mu50Pass_branch and "Mu50Pass":
            warnings.warn( "ETauTree: Expected branch Mu50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Pass")
        else:
            self.Mu50Pass_branch.SetAddress(<void*>&self.Mu50Pass_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "ETauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "ETauTree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "ETauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making VBFDoubleLooseHPSTau20Pass"
        self.VBFDoubleLooseHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseHPSTau20Pass")
        #if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass":
            warnings.warn( "ETauTree: Expected branch VBFDoubleLooseHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseHPSTau20Pass")
        else:
            self.VBFDoubleLooseHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseHPSTau20Pass_value)

        #print "making VBFDoubleLooseTau20Pass"
        self.VBFDoubleLooseTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseTau20Pass")
        #if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass":
            warnings.warn( "ETauTree: Expected branch VBFDoubleLooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseTau20Pass")
        else:
            self.VBFDoubleLooseTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseTau20Pass_value)

        #print "making VBFDoubleMediumHPSTau20Pass"
        self.VBFDoubleMediumHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumHPSTau20Pass")
        #if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass":
            warnings.warn( "ETauTree: Expected branch VBFDoubleMediumHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumHPSTau20Pass")
        else:
            self.VBFDoubleMediumHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumHPSTau20Pass_value)

        #print "making VBFDoubleMediumTau20Pass"
        self.VBFDoubleMediumTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumTau20Pass")
        #if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass":
            warnings.warn( "ETauTree: Expected branch VBFDoubleMediumTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumTau20Pass")
        else:
            self.VBFDoubleMediumTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumTau20Pass_value)

        #print "making VBFDoubleTightHPSTau20Pass"
        self.VBFDoubleTightHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightHPSTau20Pass")
        #if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass":
            warnings.warn( "ETauTree: Expected branch VBFDoubleTightHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightHPSTau20Pass")
        else:
            self.VBFDoubleTightHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightHPSTau20Pass_value)

        #print "making VBFDoubleTightTau20Pass"
        self.VBFDoubleTightTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightTau20Pass")
        #if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass" not in self.complained:
        if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass":
            warnings.warn( "ETauTree: Expected branch VBFDoubleTightTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightTau20Pass")
        else:
            self.VBFDoubleTightTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightTau20Pass_value)

        #print "making bjetDeepCSVVeto20Loose_2016_DR0p5"
        self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Loose_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2017_DR0p5"
        self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Loose_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2018_DR0p5"
        self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Loose_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium"
        self.bjetDeepCSVVeto20Medium_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium")
        #if not self.bjetDeepCSVVeto20Medium_branch and "bjetDeepCSVVeto20Medium" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_branch and "bjetDeepCSVVeto20Medium":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium")
        else:
            self.bjetDeepCSVVeto20Medium_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_value)

        #print "making bjetDeepCSVVeto20MediumWoNoisyJets"
        self.bjetDeepCSVVeto20MediumWoNoisyJets_branch = the_tree.GetBranch("bjetDeepCSVVeto20MediumWoNoisyJets")
        #if not self.bjetDeepCSVVeto20MediumWoNoisyJets_branch and "bjetDeepCSVVeto20MediumWoNoisyJets" not in self.complained:
        if not self.bjetDeepCSVVeto20MediumWoNoisyJets_branch and "bjetDeepCSVVeto20MediumWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20MediumWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20MediumWoNoisyJets")
        else:
            self.bjetDeepCSVVeto20MediumWoNoisyJets_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20MediumWoNoisyJets_value)

        #print "making bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5"
        self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch and "bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch and "bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0"
        self.bjetDeepCSVVeto20Medium_2016_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0p5"
        self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0"
        self.bjetDeepCSVVeto20Medium_2017_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0p5"
        self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0"
        self.bjetDeepCSVVeto20Medium_2018_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0p5"
        self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2016_DR0p5"
        self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Tight_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2017_DR0p5"
        self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Tight_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2018_DR0p5"
        self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Tight_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2018_DR0p5_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "ETauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "ETauTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimu9ele9Pass"
        self.dimu9ele9Pass_branch = the_tree.GetBranch("dimu9ele9Pass")
        #if not self.dimu9ele9Pass_branch and "dimu9ele9Pass" not in self.complained:
        if not self.dimu9ele9Pass_branch and "dimu9ele9Pass":
            warnings.warn( "ETauTree: Expected branch dimu9ele9Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimu9ele9Pass")
        else:
            self.dimu9ele9Pass_branch.SetAddress(<void*>&self.dimu9ele9Pass_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "ETauTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making doubleE25Pass"
        self.doubleE25Pass_branch = the_tree.GetBranch("doubleE25Pass")
        #if not self.doubleE25Pass_branch and "doubleE25Pass" not in self.complained:
        if not self.doubleE25Pass_branch and "doubleE25Pass":
            warnings.warn( "ETauTree: Expected branch doubleE25Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE25Pass")
        else:
            self.doubleE25Pass_branch.SetAddress(<void*>&self.doubleE25Pass_value)

        #print "making doubleE33Pass"
        self.doubleE33Pass_branch = the_tree.GetBranch("doubleE33Pass")
        #if not self.doubleE33Pass_branch and "doubleE33Pass" not in self.complained:
        if not self.doubleE33Pass_branch and "doubleE33Pass":
            warnings.warn( "ETauTree: Expected branch doubleE33Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE33Pass")
        else:
            self.doubleE33Pass_branch.SetAddress(<void*>&self.doubleE33Pass_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "ETauTree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleMuDZminMass3p8Pass"
        self.doubleMuDZminMass3p8Pass_branch = the_tree.GetBranch("doubleMuDZminMass3p8Pass")
        #if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass" not in self.complained:
        if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass":
            warnings.warn( "ETauTree: Expected branch doubleMuDZminMass3p8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass3p8Pass")
        else:
            self.doubleMuDZminMass3p8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass3p8Pass_value)

        #print "making doubleMuDZminMass8Pass"
        self.doubleMuDZminMass8Pass_branch = the_tree.GetBranch("doubleMuDZminMass8Pass")
        #if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass" not in self.complained:
        if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass":
            warnings.warn( "ETauTree: Expected branch doubleMuDZminMass8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass8Pass")
        else:
            self.doubleMuDZminMass8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass8Pass_value)

        #print "making doubleMuSingleEPass"
        self.doubleMuSingleEPass_branch = the_tree.GetBranch("doubleMuSingleEPass")
        #if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass" not in self.complained:
        if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass":
            warnings.warn( "ETauTree: Expected branch doubleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPass")
        else:
            self.doubleMuSingleEPass_branch.SetAddress(<void*>&self.doubleMuSingleEPass_value)

        #print "making doubleTau35Pass"
        self.doubleTau35Pass_branch = the_tree.GetBranch("doubleTau35Pass")
        #if not self.doubleTau35Pass_branch and "doubleTau35Pass" not in self.complained:
        if not self.doubleTau35Pass_branch and "doubleTau35Pass":
            warnings.warn( "ETauTree: Expected branch doubleTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Pass")
        else:
            self.doubleTau35Pass_branch.SetAddress(<void*>&self.doubleTau35Pass_value)

        #print "making doubleTauCmbIso35RegPass"
        self.doubleTauCmbIso35RegPass_branch = the_tree.GetBranch("doubleTauCmbIso35RegPass")
        #if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass" not in self.complained:
        if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass":
            warnings.warn( "ETauTree: Expected branch doubleTauCmbIso35RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPass")
        else:
            self.doubleTauCmbIso35RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPass_value)

        #print "making eCBIDLoose"
        self.eCBIDLoose_branch = the_tree.GetBranch("eCBIDLoose")
        #if not self.eCBIDLoose_branch and "eCBIDLoose" not in self.complained:
        if not self.eCBIDLoose_branch and "eCBIDLoose":
            warnings.warn( "ETauTree: Expected branch eCBIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDLoose")
        else:
            self.eCBIDLoose_branch.SetAddress(<void*>&self.eCBIDLoose_value)

        #print "making eCBIDMedium"
        self.eCBIDMedium_branch = the_tree.GetBranch("eCBIDMedium")
        #if not self.eCBIDMedium_branch and "eCBIDMedium" not in self.complained:
        if not self.eCBIDMedium_branch and "eCBIDMedium":
            warnings.warn( "ETauTree: Expected branch eCBIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDMedium")
        else:
            self.eCBIDMedium_branch.SetAddress(<void*>&self.eCBIDMedium_value)

        #print "making eCBIDTight"
        self.eCBIDTight_branch = the_tree.GetBranch("eCBIDTight")
        #if not self.eCBIDTight_branch and "eCBIDTight" not in self.complained:
        if not self.eCBIDTight_branch and "eCBIDTight":
            warnings.warn( "ETauTree: Expected branch eCBIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDTight")
        else:
            self.eCBIDTight_branch.SetAddress(<void*>&self.eCBIDTight_value)

        #print "making eCBIDVeto"
        self.eCBIDVeto_branch = the_tree.GetBranch("eCBIDVeto")
        #if not self.eCBIDVeto_branch and "eCBIDVeto" not in self.complained:
        if not self.eCBIDVeto_branch and "eCBIDVeto":
            warnings.warn( "ETauTree: Expected branch eCBIDVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDVeto")
        else:
            self.eCBIDVeto_branch.SetAddress(<void*>&self.eCBIDVeto_value)

        #print "making eCharge"
        self.eCharge_branch = the_tree.GetBranch("eCharge")
        #if not self.eCharge_branch and "eCharge" not in self.complained:
        if not self.eCharge_branch and "eCharge":
            warnings.warn( "ETauTree: Expected branch eCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCharge")
        else:
            self.eCharge_branch.SetAddress(<void*>&self.eCharge_value)

        #print "making eChargeIdLoose"
        self.eChargeIdLoose_branch = the_tree.GetBranch("eChargeIdLoose")
        #if not self.eChargeIdLoose_branch and "eChargeIdLoose" not in self.complained:
        if not self.eChargeIdLoose_branch and "eChargeIdLoose":
            warnings.warn( "ETauTree: Expected branch eChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdLoose")
        else:
            self.eChargeIdLoose_branch.SetAddress(<void*>&self.eChargeIdLoose_value)

        #print "making eChargeIdMed"
        self.eChargeIdMed_branch = the_tree.GetBranch("eChargeIdMed")
        #if not self.eChargeIdMed_branch and "eChargeIdMed" not in self.complained:
        if not self.eChargeIdMed_branch and "eChargeIdMed":
            warnings.warn( "ETauTree: Expected branch eChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdMed")
        else:
            self.eChargeIdMed_branch.SetAddress(<void*>&self.eChargeIdMed_value)

        #print "making eChargeIdTight"
        self.eChargeIdTight_branch = the_tree.GetBranch("eChargeIdTight")
        #if not self.eChargeIdTight_branch and "eChargeIdTight" not in self.complained:
        if not self.eChargeIdTight_branch and "eChargeIdTight":
            warnings.warn( "ETauTree: Expected branch eChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdTight")
        else:
            self.eChargeIdTight_branch.SetAddress(<void*>&self.eChargeIdTight_value)

        #print "making eComesFromHiggs"
        self.eComesFromHiggs_branch = the_tree.GetBranch("eComesFromHiggs")
        #if not self.eComesFromHiggs_branch and "eComesFromHiggs" not in self.complained:
        if not self.eComesFromHiggs_branch and "eComesFromHiggs":
            warnings.warn( "ETauTree: Expected branch eComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eComesFromHiggs")
        else:
            self.eComesFromHiggs_branch.SetAddress(<void*>&self.eComesFromHiggs_value)

        #print "making eCorrectedEt"
        self.eCorrectedEt_branch = the_tree.GetBranch("eCorrectedEt")
        #if not self.eCorrectedEt_branch and "eCorrectedEt" not in self.complained:
        if not self.eCorrectedEt_branch and "eCorrectedEt":
            warnings.warn( "ETauTree: Expected branch eCorrectedEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCorrectedEt")
        else:
            self.eCorrectedEt_branch.SetAddress(<void*>&self.eCorrectedEt_value)

        #print "making eE1x5"
        self.eE1x5_branch = the_tree.GetBranch("eE1x5")
        #if not self.eE1x5_branch and "eE1x5" not in self.complained:
        if not self.eE1x5_branch and "eE1x5":
            warnings.warn( "ETauTree: Expected branch eE1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE1x5")
        else:
            self.eE1x5_branch.SetAddress(<void*>&self.eE1x5_value)

        #print "making eE2x5Max"
        self.eE2x5Max_branch = the_tree.GetBranch("eE2x5Max")
        #if not self.eE2x5Max_branch and "eE2x5Max" not in self.complained:
        if not self.eE2x5Max_branch and "eE2x5Max":
            warnings.warn( "ETauTree: Expected branch eE2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE2x5Max")
        else:
            self.eE2x5Max_branch.SetAddress(<void*>&self.eE2x5Max_value)

        #print "making eE5x5"
        self.eE5x5_branch = the_tree.GetBranch("eE5x5")
        #if not self.eE5x5_branch and "eE5x5" not in self.complained:
        if not self.eE5x5_branch and "eE5x5":
            warnings.warn( "ETauTree: Expected branch eE5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE5x5")
        else:
            self.eE5x5_branch.SetAddress(<void*>&self.eE5x5_value)

        #print "making eEcalIsoDR03"
        self.eEcalIsoDR03_branch = the_tree.GetBranch("eEcalIsoDR03")
        #if not self.eEcalIsoDR03_branch and "eEcalIsoDR03" not in self.complained:
        if not self.eEcalIsoDR03_branch and "eEcalIsoDR03":
            warnings.warn( "ETauTree: Expected branch eEcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEcalIsoDR03")
        else:
            self.eEcalIsoDR03_branch.SetAddress(<void*>&self.eEcalIsoDR03_value)

        #print "making eEnergyError"
        self.eEnergyError_branch = the_tree.GetBranch("eEnergyError")
        #if not self.eEnergyError_branch and "eEnergyError" not in self.complained:
        if not self.eEnergyError_branch and "eEnergyError":
            warnings.warn( "ETauTree: Expected branch eEnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyError")
        else:
            self.eEnergyError_branch.SetAddress(<void*>&self.eEnergyError_value)

        #print "making eEnergyScaleDown"
        self.eEnergyScaleDown_branch = the_tree.GetBranch("eEnergyScaleDown")
        #if not self.eEnergyScaleDown_branch and "eEnergyScaleDown" not in self.complained:
        if not self.eEnergyScaleDown_branch and "eEnergyScaleDown":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleDown")
        else:
            self.eEnergyScaleDown_branch.SetAddress(<void*>&self.eEnergyScaleDown_value)

        #print "making eEnergyScaleGainDown"
        self.eEnergyScaleGainDown_branch = the_tree.GetBranch("eEnergyScaleGainDown")
        #if not self.eEnergyScaleGainDown_branch and "eEnergyScaleGainDown" not in self.complained:
        if not self.eEnergyScaleGainDown_branch and "eEnergyScaleGainDown":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleGainDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleGainDown")
        else:
            self.eEnergyScaleGainDown_branch.SetAddress(<void*>&self.eEnergyScaleGainDown_value)

        #print "making eEnergyScaleGainUp"
        self.eEnergyScaleGainUp_branch = the_tree.GetBranch("eEnergyScaleGainUp")
        #if not self.eEnergyScaleGainUp_branch and "eEnergyScaleGainUp" not in self.complained:
        if not self.eEnergyScaleGainUp_branch and "eEnergyScaleGainUp":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleGainUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleGainUp")
        else:
            self.eEnergyScaleGainUp_branch.SetAddress(<void*>&self.eEnergyScaleGainUp_value)

        #print "making eEnergyScaleStatDown"
        self.eEnergyScaleStatDown_branch = the_tree.GetBranch("eEnergyScaleStatDown")
        #if not self.eEnergyScaleStatDown_branch and "eEnergyScaleStatDown" not in self.complained:
        if not self.eEnergyScaleStatDown_branch and "eEnergyScaleStatDown":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleStatDown")
        else:
            self.eEnergyScaleStatDown_branch.SetAddress(<void*>&self.eEnergyScaleStatDown_value)

        #print "making eEnergyScaleStatUp"
        self.eEnergyScaleStatUp_branch = the_tree.GetBranch("eEnergyScaleStatUp")
        #if not self.eEnergyScaleStatUp_branch and "eEnergyScaleStatUp" not in self.complained:
        if not self.eEnergyScaleStatUp_branch and "eEnergyScaleStatUp":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleStatUp")
        else:
            self.eEnergyScaleStatUp_branch.SetAddress(<void*>&self.eEnergyScaleStatUp_value)

        #print "making eEnergyScaleSystDown"
        self.eEnergyScaleSystDown_branch = the_tree.GetBranch("eEnergyScaleSystDown")
        #if not self.eEnergyScaleSystDown_branch and "eEnergyScaleSystDown" not in self.complained:
        if not self.eEnergyScaleSystDown_branch and "eEnergyScaleSystDown":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleSystDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleSystDown")
        else:
            self.eEnergyScaleSystDown_branch.SetAddress(<void*>&self.eEnergyScaleSystDown_value)

        #print "making eEnergyScaleSystUp"
        self.eEnergyScaleSystUp_branch = the_tree.GetBranch("eEnergyScaleSystUp")
        #if not self.eEnergyScaleSystUp_branch and "eEnergyScaleSystUp" not in self.complained:
        if not self.eEnergyScaleSystUp_branch and "eEnergyScaleSystUp":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleSystUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleSystUp")
        else:
            self.eEnergyScaleSystUp_branch.SetAddress(<void*>&self.eEnergyScaleSystUp_value)

        #print "making eEnergyScaleUp"
        self.eEnergyScaleUp_branch = the_tree.GetBranch("eEnergyScaleUp")
        #if not self.eEnergyScaleUp_branch and "eEnergyScaleUp" not in self.complained:
        if not self.eEnergyScaleUp_branch and "eEnergyScaleUp":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleUp")
        else:
            self.eEnergyScaleUp_branch.SetAddress(<void*>&self.eEnergyScaleUp_value)

        #print "making eEnergySigmaDown"
        self.eEnergySigmaDown_branch = the_tree.GetBranch("eEnergySigmaDown")
        #if not self.eEnergySigmaDown_branch and "eEnergySigmaDown" not in self.complained:
        if not self.eEnergySigmaDown_branch and "eEnergySigmaDown":
            warnings.warn( "ETauTree: Expected branch eEnergySigmaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaDown")
        else:
            self.eEnergySigmaDown_branch.SetAddress(<void*>&self.eEnergySigmaDown_value)

        #print "making eEnergySigmaPhiDown"
        self.eEnergySigmaPhiDown_branch = the_tree.GetBranch("eEnergySigmaPhiDown")
        #if not self.eEnergySigmaPhiDown_branch and "eEnergySigmaPhiDown" not in self.complained:
        if not self.eEnergySigmaPhiDown_branch and "eEnergySigmaPhiDown":
            warnings.warn( "ETauTree: Expected branch eEnergySigmaPhiDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaPhiDown")
        else:
            self.eEnergySigmaPhiDown_branch.SetAddress(<void*>&self.eEnergySigmaPhiDown_value)

        #print "making eEnergySigmaPhiUp"
        self.eEnergySigmaPhiUp_branch = the_tree.GetBranch("eEnergySigmaPhiUp")
        #if not self.eEnergySigmaPhiUp_branch and "eEnergySigmaPhiUp" not in self.complained:
        if not self.eEnergySigmaPhiUp_branch and "eEnergySigmaPhiUp":
            warnings.warn( "ETauTree: Expected branch eEnergySigmaPhiUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaPhiUp")
        else:
            self.eEnergySigmaPhiUp_branch.SetAddress(<void*>&self.eEnergySigmaPhiUp_value)

        #print "making eEnergySigmaRhoDown"
        self.eEnergySigmaRhoDown_branch = the_tree.GetBranch("eEnergySigmaRhoDown")
        #if not self.eEnergySigmaRhoDown_branch and "eEnergySigmaRhoDown" not in self.complained:
        if not self.eEnergySigmaRhoDown_branch and "eEnergySigmaRhoDown":
            warnings.warn( "ETauTree: Expected branch eEnergySigmaRhoDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaRhoDown")
        else:
            self.eEnergySigmaRhoDown_branch.SetAddress(<void*>&self.eEnergySigmaRhoDown_value)

        #print "making eEnergySigmaRhoUp"
        self.eEnergySigmaRhoUp_branch = the_tree.GetBranch("eEnergySigmaRhoUp")
        #if not self.eEnergySigmaRhoUp_branch and "eEnergySigmaRhoUp" not in self.complained:
        if not self.eEnergySigmaRhoUp_branch and "eEnergySigmaRhoUp":
            warnings.warn( "ETauTree: Expected branch eEnergySigmaRhoUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaRhoUp")
        else:
            self.eEnergySigmaRhoUp_branch.SetAddress(<void*>&self.eEnergySigmaRhoUp_value)

        #print "making eEnergySigmaUp"
        self.eEnergySigmaUp_branch = the_tree.GetBranch("eEnergySigmaUp")
        #if not self.eEnergySigmaUp_branch and "eEnergySigmaUp" not in self.complained:
        if not self.eEnergySigmaUp_branch and "eEnergySigmaUp":
            warnings.warn( "ETauTree: Expected branch eEnergySigmaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaUp")
        else:
            self.eEnergySigmaUp_branch.SetAddress(<void*>&self.eEnergySigmaUp_value)

        #print "making eEta"
        self.eEta_branch = the_tree.GetBranch("eEta")
        #if not self.eEta_branch and "eEta" not in self.complained:
        if not self.eEta_branch and "eEta":
            warnings.warn( "ETauTree: Expected branch eEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEta")
        else:
            self.eEta_branch.SetAddress(<void*>&self.eEta_value)

        #print "making eGenCharge"
        self.eGenCharge_branch = the_tree.GetBranch("eGenCharge")
        #if not self.eGenCharge_branch and "eGenCharge" not in self.complained:
        if not self.eGenCharge_branch and "eGenCharge":
            warnings.warn( "ETauTree: Expected branch eGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenCharge")
        else:
            self.eGenCharge_branch.SetAddress(<void*>&self.eGenCharge_value)

        #print "making eGenEnergy"
        self.eGenEnergy_branch = the_tree.GetBranch("eGenEnergy")
        #if not self.eGenEnergy_branch and "eGenEnergy" not in self.complained:
        if not self.eGenEnergy_branch and "eGenEnergy":
            warnings.warn( "ETauTree: Expected branch eGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEnergy")
        else:
            self.eGenEnergy_branch.SetAddress(<void*>&self.eGenEnergy_value)

        #print "making eGenEta"
        self.eGenEta_branch = the_tree.GetBranch("eGenEta")
        #if not self.eGenEta_branch and "eGenEta" not in self.complained:
        if not self.eGenEta_branch and "eGenEta":
            warnings.warn( "ETauTree: Expected branch eGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEta")
        else:
            self.eGenEta_branch.SetAddress(<void*>&self.eGenEta_value)

        #print "making eGenMotherPdgId"
        self.eGenMotherPdgId_branch = the_tree.GetBranch("eGenMotherPdgId")
        #if not self.eGenMotherPdgId_branch and "eGenMotherPdgId" not in self.complained:
        if not self.eGenMotherPdgId_branch and "eGenMotherPdgId":
            warnings.warn( "ETauTree: Expected branch eGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenMotherPdgId")
        else:
            self.eGenMotherPdgId_branch.SetAddress(<void*>&self.eGenMotherPdgId_value)

        #print "making eGenParticle"
        self.eGenParticle_branch = the_tree.GetBranch("eGenParticle")
        #if not self.eGenParticle_branch and "eGenParticle" not in self.complained:
        if not self.eGenParticle_branch and "eGenParticle":
            warnings.warn( "ETauTree: Expected branch eGenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenParticle")
        else:
            self.eGenParticle_branch.SetAddress(<void*>&self.eGenParticle_value)

        #print "making eGenPdgId"
        self.eGenPdgId_branch = the_tree.GetBranch("eGenPdgId")
        #if not self.eGenPdgId_branch and "eGenPdgId" not in self.complained:
        if not self.eGenPdgId_branch and "eGenPdgId":
            warnings.warn( "ETauTree: Expected branch eGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPdgId")
        else:
            self.eGenPdgId_branch.SetAddress(<void*>&self.eGenPdgId_value)

        #print "making eGenPhi"
        self.eGenPhi_branch = the_tree.GetBranch("eGenPhi")
        #if not self.eGenPhi_branch and "eGenPhi" not in self.complained:
        if not self.eGenPhi_branch and "eGenPhi":
            warnings.warn( "ETauTree: Expected branch eGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPhi")
        else:
            self.eGenPhi_branch.SetAddress(<void*>&self.eGenPhi_value)

        #print "making eGenPrompt"
        self.eGenPrompt_branch = the_tree.GetBranch("eGenPrompt")
        #if not self.eGenPrompt_branch and "eGenPrompt" not in self.complained:
        if not self.eGenPrompt_branch and "eGenPrompt":
            warnings.warn( "ETauTree: Expected branch eGenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPrompt")
        else:
            self.eGenPrompt_branch.SetAddress(<void*>&self.eGenPrompt_value)

        #print "making eGenPromptTauDecay"
        self.eGenPromptTauDecay_branch = the_tree.GetBranch("eGenPromptTauDecay")
        #if not self.eGenPromptTauDecay_branch and "eGenPromptTauDecay" not in self.complained:
        if not self.eGenPromptTauDecay_branch and "eGenPromptTauDecay":
            warnings.warn( "ETauTree: Expected branch eGenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPromptTauDecay")
        else:
            self.eGenPromptTauDecay_branch.SetAddress(<void*>&self.eGenPromptTauDecay_value)

        #print "making eGenPt"
        self.eGenPt_branch = the_tree.GetBranch("eGenPt")
        #if not self.eGenPt_branch and "eGenPt" not in self.complained:
        if not self.eGenPt_branch and "eGenPt":
            warnings.warn( "ETauTree: Expected branch eGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPt")
        else:
            self.eGenPt_branch.SetAddress(<void*>&self.eGenPt_value)

        #print "making eGenTauDecay"
        self.eGenTauDecay_branch = the_tree.GetBranch("eGenTauDecay")
        #if not self.eGenTauDecay_branch and "eGenTauDecay" not in self.complained:
        if not self.eGenTauDecay_branch and "eGenTauDecay":
            warnings.warn( "ETauTree: Expected branch eGenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenTauDecay")
        else:
            self.eGenTauDecay_branch.SetAddress(<void*>&self.eGenTauDecay_value)

        #print "making eGenVZ"
        self.eGenVZ_branch = the_tree.GetBranch("eGenVZ")
        #if not self.eGenVZ_branch and "eGenVZ" not in self.complained:
        if not self.eGenVZ_branch and "eGenVZ":
            warnings.warn( "ETauTree: Expected branch eGenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenVZ")
        else:
            self.eGenVZ_branch.SetAddress(<void*>&self.eGenVZ_value)

        #print "making eGenVtxPVMatch"
        self.eGenVtxPVMatch_branch = the_tree.GetBranch("eGenVtxPVMatch")
        #if not self.eGenVtxPVMatch_branch and "eGenVtxPVMatch" not in self.complained:
        if not self.eGenVtxPVMatch_branch and "eGenVtxPVMatch":
            warnings.warn( "ETauTree: Expected branch eGenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenVtxPVMatch")
        else:
            self.eGenVtxPVMatch_branch.SetAddress(<void*>&self.eGenVtxPVMatch_value)

        #print "making eHadronicDepth1OverEm"
        self.eHadronicDepth1OverEm_branch = the_tree.GetBranch("eHadronicDepth1OverEm")
        #if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm" not in self.complained:
        if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm":
            warnings.warn( "ETauTree: Expected branch eHadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth1OverEm")
        else:
            self.eHadronicDepth1OverEm_branch.SetAddress(<void*>&self.eHadronicDepth1OverEm_value)

        #print "making eHadronicDepth2OverEm"
        self.eHadronicDepth2OverEm_branch = the_tree.GetBranch("eHadronicDepth2OverEm")
        #if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm" not in self.complained:
        if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm":
            warnings.warn( "ETauTree: Expected branch eHadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth2OverEm")
        else:
            self.eHadronicDepth2OverEm_branch.SetAddress(<void*>&self.eHadronicDepth2OverEm_value)

        #print "making eHadronicOverEM"
        self.eHadronicOverEM_branch = the_tree.GetBranch("eHadronicOverEM")
        #if not self.eHadronicOverEM_branch and "eHadronicOverEM" not in self.complained:
        if not self.eHadronicOverEM_branch and "eHadronicOverEM":
            warnings.warn( "ETauTree: Expected branch eHadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicOverEM")
        else:
            self.eHadronicOverEM_branch.SetAddress(<void*>&self.eHadronicOverEM_value)

        #print "making eHcalIsoDR03"
        self.eHcalIsoDR03_branch = the_tree.GetBranch("eHcalIsoDR03")
        #if not self.eHcalIsoDR03_branch and "eHcalIsoDR03" not in self.complained:
        if not self.eHcalIsoDR03_branch and "eHcalIsoDR03":
            warnings.warn( "ETauTree: Expected branch eHcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHcalIsoDR03")
        else:
            self.eHcalIsoDR03_branch.SetAddress(<void*>&self.eHcalIsoDR03_value)

        #print "making eIP3D"
        self.eIP3D_branch = the_tree.GetBranch("eIP3D")
        #if not self.eIP3D_branch and "eIP3D" not in self.complained:
        if not self.eIP3D_branch and "eIP3D":
            warnings.warn( "ETauTree: Expected branch eIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIP3D")
        else:
            self.eIP3D_branch.SetAddress(<void*>&self.eIP3D_value)

        #print "making eIP3DErr"
        self.eIP3DErr_branch = the_tree.GetBranch("eIP3DErr")
        #if not self.eIP3DErr_branch and "eIP3DErr" not in self.complained:
        if not self.eIP3DErr_branch and "eIP3DErr":
            warnings.warn( "ETauTree: Expected branch eIP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIP3DErr")
        else:
            self.eIP3DErr_branch.SetAddress(<void*>&self.eIP3DErr_value)

        #print "making eJetArea"
        self.eJetArea_branch = the_tree.GetBranch("eJetArea")
        #if not self.eJetArea_branch and "eJetArea" not in self.complained:
        if not self.eJetArea_branch and "eJetArea":
            warnings.warn( "ETauTree: Expected branch eJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetArea")
        else:
            self.eJetArea_branch.SetAddress(<void*>&self.eJetArea_value)

        #print "making eJetBtag"
        self.eJetBtag_branch = the_tree.GetBranch("eJetBtag")
        #if not self.eJetBtag_branch and "eJetBtag" not in self.complained:
        if not self.eJetBtag_branch and "eJetBtag":
            warnings.warn( "ETauTree: Expected branch eJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetBtag")
        else:
            self.eJetBtag_branch.SetAddress(<void*>&self.eJetBtag_value)

        #print "making eJetDR"
        self.eJetDR_branch = the_tree.GetBranch("eJetDR")
        #if not self.eJetDR_branch and "eJetDR" not in self.complained:
        if not self.eJetDR_branch and "eJetDR":
            warnings.warn( "ETauTree: Expected branch eJetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetDR")
        else:
            self.eJetDR_branch.SetAddress(<void*>&self.eJetDR_value)

        #print "making eJetEtaEtaMoment"
        self.eJetEtaEtaMoment_branch = the_tree.GetBranch("eJetEtaEtaMoment")
        #if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment" not in self.complained:
        if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment":
            warnings.warn( "ETauTree: Expected branch eJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaEtaMoment")
        else:
            self.eJetEtaEtaMoment_branch.SetAddress(<void*>&self.eJetEtaEtaMoment_value)

        #print "making eJetEtaPhiMoment"
        self.eJetEtaPhiMoment_branch = the_tree.GetBranch("eJetEtaPhiMoment")
        #if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment" not in self.complained:
        if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment":
            warnings.warn( "ETauTree: Expected branch eJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiMoment")
        else:
            self.eJetEtaPhiMoment_branch.SetAddress(<void*>&self.eJetEtaPhiMoment_value)

        #print "making eJetEtaPhiSpread"
        self.eJetEtaPhiSpread_branch = the_tree.GetBranch("eJetEtaPhiSpread")
        #if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread" not in self.complained:
        if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread":
            warnings.warn( "ETauTree: Expected branch eJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiSpread")
        else:
            self.eJetEtaPhiSpread_branch.SetAddress(<void*>&self.eJetEtaPhiSpread_value)

        #print "making eJetHadronFlavour"
        self.eJetHadronFlavour_branch = the_tree.GetBranch("eJetHadronFlavour")
        #if not self.eJetHadronFlavour_branch and "eJetHadronFlavour" not in self.complained:
        if not self.eJetHadronFlavour_branch and "eJetHadronFlavour":
            warnings.warn( "ETauTree: Expected branch eJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetHadronFlavour")
        else:
            self.eJetHadronFlavour_branch.SetAddress(<void*>&self.eJetHadronFlavour_value)

        #print "making eJetPFCISVBtag"
        self.eJetPFCISVBtag_branch = the_tree.GetBranch("eJetPFCISVBtag")
        #if not self.eJetPFCISVBtag_branch and "eJetPFCISVBtag" not in self.complained:
        if not self.eJetPFCISVBtag_branch and "eJetPFCISVBtag":
            warnings.warn( "ETauTree: Expected branch eJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPFCISVBtag")
        else:
            self.eJetPFCISVBtag_branch.SetAddress(<void*>&self.eJetPFCISVBtag_value)

        #print "making eJetPartonFlavour"
        self.eJetPartonFlavour_branch = the_tree.GetBranch("eJetPartonFlavour")
        #if not self.eJetPartonFlavour_branch and "eJetPartonFlavour" not in self.complained:
        if not self.eJetPartonFlavour_branch and "eJetPartonFlavour":
            warnings.warn( "ETauTree: Expected branch eJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPartonFlavour")
        else:
            self.eJetPartonFlavour_branch.SetAddress(<void*>&self.eJetPartonFlavour_value)

        #print "making eJetPhiPhiMoment"
        self.eJetPhiPhiMoment_branch = the_tree.GetBranch("eJetPhiPhiMoment")
        #if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment" not in self.complained:
        if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment":
            warnings.warn( "ETauTree: Expected branch eJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPhiPhiMoment")
        else:
            self.eJetPhiPhiMoment_branch.SetAddress(<void*>&self.eJetPhiPhiMoment_value)

        #print "making eJetPt"
        self.eJetPt_branch = the_tree.GetBranch("eJetPt")
        #if not self.eJetPt_branch and "eJetPt" not in self.complained:
        if not self.eJetPt_branch and "eJetPt":
            warnings.warn( "ETauTree: Expected branch eJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPt")
        else:
            self.eJetPt_branch.SetAddress(<void*>&self.eJetPt_value)

        #print "making eLowestMll"
        self.eLowestMll_branch = the_tree.GetBranch("eLowestMll")
        #if not self.eLowestMll_branch and "eLowestMll" not in self.complained:
        if not self.eLowestMll_branch and "eLowestMll":
            warnings.warn( "ETauTree: Expected branch eLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eLowestMll")
        else:
            self.eLowestMll_branch.SetAddress(<void*>&self.eLowestMll_value)

        #print "making eMVAIsoWP80"
        self.eMVAIsoWP80_branch = the_tree.GetBranch("eMVAIsoWP80")
        #if not self.eMVAIsoWP80_branch and "eMVAIsoWP80" not in self.complained:
        if not self.eMVAIsoWP80_branch and "eMVAIsoWP80":
            warnings.warn( "ETauTree: Expected branch eMVAIsoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIsoWP80")
        else:
            self.eMVAIsoWP80_branch.SetAddress(<void*>&self.eMVAIsoWP80_value)

        #print "making eMVAIsoWP90"
        self.eMVAIsoWP90_branch = the_tree.GetBranch("eMVAIsoWP90")
        #if not self.eMVAIsoWP90_branch and "eMVAIsoWP90" not in self.complained:
        if not self.eMVAIsoWP90_branch and "eMVAIsoWP90":
            warnings.warn( "ETauTree: Expected branch eMVAIsoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIsoWP90")
        else:
            self.eMVAIsoWP90_branch.SetAddress(<void*>&self.eMVAIsoWP90_value)

        #print "making eMVAIsoWPHZZ"
        self.eMVAIsoWPHZZ_branch = the_tree.GetBranch("eMVAIsoWPHZZ")
        #if not self.eMVAIsoWPHZZ_branch and "eMVAIsoWPHZZ" not in self.complained:
        if not self.eMVAIsoWPHZZ_branch and "eMVAIsoWPHZZ":
            warnings.warn( "ETauTree: Expected branch eMVAIsoWPHZZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIsoWPHZZ")
        else:
            self.eMVAIsoWPHZZ_branch.SetAddress(<void*>&self.eMVAIsoWPHZZ_value)

        #print "making eMVAIsoWPLoose"
        self.eMVAIsoWPLoose_branch = the_tree.GetBranch("eMVAIsoWPLoose")
        #if not self.eMVAIsoWPLoose_branch and "eMVAIsoWPLoose" not in self.complained:
        if not self.eMVAIsoWPLoose_branch and "eMVAIsoWPLoose":
            warnings.warn( "ETauTree: Expected branch eMVAIsoWPLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIsoWPLoose")
        else:
            self.eMVAIsoWPLoose_branch.SetAddress(<void*>&self.eMVAIsoWPLoose_value)

        #print "making eMVANoisoWP80"
        self.eMVANoisoWP80_branch = the_tree.GetBranch("eMVANoisoWP80")
        #if not self.eMVANoisoWP80_branch and "eMVANoisoWP80" not in self.complained:
        if not self.eMVANoisoWP80_branch and "eMVANoisoWP80":
            warnings.warn( "ETauTree: Expected branch eMVANoisoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANoisoWP80")
        else:
            self.eMVANoisoWP80_branch.SetAddress(<void*>&self.eMVANoisoWP80_value)

        #print "making eMVANoisoWP90"
        self.eMVANoisoWP90_branch = the_tree.GetBranch("eMVANoisoWP90")
        #if not self.eMVANoisoWP90_branch and "eMVANoisoWP90" not in self.complained:
        if not self.eMVANoisoWP90_branch and "eMVANoisoWP90":
            warnings.warn( "ETauTree: Expected branch eMVANoisoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANoisoWP90")
        else:
            self.eMVANoisoWP90_branch.SetAddress(<void*>&self.eMVANoisoWP90_value)

        #print "making eMVANoisoWPLoose"
        self.eMVANoisoWPLoose_branch = the_tree.GetBranch("eMVANoisoWPLoose")
        #if not self.eMVANoisoWPLoose_branch and "eMVANoisoWPLoose" not in self.complained:
        if not self.eMVANoisoWPLoose_branch and "eMVANoisoWPLoose":
            warnings.warn( "ETauTree: Expected branch eMVANoisoWPLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANoisoWPLoose")
        else:
            self.eMVANoisoWPLoose_branch.SetAddress(<void*>&self.eMVANoisoWPLoose_value)

        #print "making eMass"
        self.eMass_branch = the_tree.GetBranch("eMass")
        #if not self.eMass_branch and "eMass" not in self.complained:
        if not self.eMass_branch and "eMass":
            warnings.warn( "ETauTree: Expected branch eMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMass")
        else:
            self.eMass_branch.SetAddress(<void*>&self.eMass_value)

        #print "making eMatchesEle24Tau30Filter"
        self.eMatchesEle24Tau30Filter_branch = the_tree.GetBranch("eMatchesEle24Tau30Filter")
        #if not self.eMatchesEle24Tau30Filter_branch and "eMatchesEle24Tau30Filter" not in self.complained:
        if not self.eMatchesEle24Tau30Filter_branch and "eMatchesEle24Tau30Filter":
            warnings.warn( "ETauTree: Expected branch eMatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24Tau30Filter")
        else:
            self.eMatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.eMatchesEle24Tau30Filter_value)

        #print "making eMatchesEle24Tau30Path"
        self.eMatchesEle24Tau30Path_branch = the_tree.GetBranch("eMatchesEle24Tau30Path")
        #if not self.eMatchesEle24Tau30Path_branch and "eMatchesEle24Tau30Path" not in self.complained:
        if not self.eMatchesEle24Tau30Path_branch and "eMatchesEle24Tau30Path":
            warnings.warn( "ETauTree: Expected branch eMatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24Tau30Path")
        else:
            self.eMatchesEle24Tau30Path_branch.SetAddress(<void*>&self.eMatchesEle24Tau30Path_value)

        #print "making eMatchesEle27Filter"
        self.eMatchesEle27Filter_branch = the_tree.GetBranch("eMatchesEle27Filter")
        #if not self.eMatchesEle27Filter_branch and "eMatchesEle27Filter" not in self.complained:
        if not self.eMatchesEle27Filter_branch and "eMatchesEle27Filter":
            warnings.warn( "ETauTree: Expected branch eMatchesEle27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle27Filter")
        else:
            self.eMatchesEle27Filter_branch.SetAddress(<void*>&self.eMatchesEle27Filter_value)

        #print "making eMatchesEle27Path"
        self.eMatchesEle27Path_branch = the_tree.GetBranch("eMatchesEle27Path")
        #if not self.eMatchesEle27Path_branch and "eMatchesEle27Path" not in self.complained:
        if not self.eMatchesEle27Path_branch and "eMatchesEle27Path":
            warnings.warn( "ETauTree: Expected branch eMatchesEle27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle27Path")
        else:
            self.eMatchesEle27Path_branch.SetAddress(<void*>&self.eMatchesEle27Path_value)

        #print "making eMatchesEle32Filter"
        self.eMatchesEle32Filter_branch = the_tree.GetBranch("eMatchesEle32Filter")
        #if not self.eMatchesEle32Filter_branch and "eMatchesEle32Filter" not in self.complained:
        if not self.eMatchesEle32Filter_branch and "eMatchesEle32Filter":
            warnings.warn( "ETauTree: Expected branch eMatchesEle32Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle32Filter")
        else:
            self.eMatchesEle32Filter_branch.SetAddress(<void*>&self.eMatchesEle32Filter_value)

        #print "making eMatchesEle32Path"
        self.eMatchesEle32Path_branch = the_tree.GetBranch("eMatchesEle32Path")
        #if not self.eMatchesEle32Path_branch and "eMatchesEle32Path" not in self.complained:
        if not self.eMatchesEle32Path_branch and "eMatchesEle32Path":
            warnings.warn( "ETauTree: Expected branch eMatchesEle32Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle32Path")
        else:
            self.eMatchesEle32Path_branch.SetAddress(<void*>&self.eMatchesEle32Path_value)

        #print "making eMatchesEle35Filter"
        self.eMatchesEle35Filter_branch = the_tree.GetBranch("eMatchesEle35Filter")
        #if not self.eMatchesEle35Filter_branch and "eMatchesEle35Filter" not in self.complained:
        if not self.eMatchesEle35Filter_branch and "eMatchesEle35Filter":
            warnings.warn( "ETauTree: Expected branch eMatchesEle35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle35Filter")
        else:
            self.eMatchesEle35Filter_branch.SetAddress(<void*>&self.eMatchesEle35Filter_value)

        #print "making eMatchesEle35Path"
        self.eMatchesEle35Path_branch = the_tree.GetBranch("eMatchesEle35Path")
        #if not self.eMatchesEle35Path_branch and "eMatchesEle35Path" not in self.complained:
        if not self.eMatchesEle35Path_branch and "eMatchesEle35Path":
            warnings.warn( "ETauTree: Expected branch eMatchesEle35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle35Path")
        else:
            self.eMatchesEle35Path_branch.SetAddress(<void*>&self.eMatchesEle35Path_value)

        #print "making eMatchesMu23e12DZFilter"
        self.eMatchesMu23e12DZFilter_branch = the_tree.GetBranch("eMatchesMu23e12DZFilter")
        #if not self.eMatchesMu23e12DZFilter_branch and "eMatchesMu23e12DZFilter" not in self.complained:
        if not self.eMatchesMu23e12DZFilter_branch and "eMatchesMu23e12DZFilter":
            warnings.warn( "ETauTree: Expected branch eMatchesMu23e12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23e12DZFilter")
        else:
            self.eMatchesMu23e12DZFilter_branch.SetAddress(<void*>&self.eMatchesMu23e12DZFilter_value)

        #print "making eMatchesMu23e12DZPath"
        self.eMatchesMu23e12DZPath_branch = the_tree.GetBranch("eMatchesMu23e12DZPath")
        #if not self.eMatchesMu23e12DZPath_branch and "eMatchesMu23e12DZPath" not in self.complained:
        if not self.eMatchesMu23e12DZPath_branch and "eMatchesMu23e12DZPath":
            warnings.warn( "ETauTree: Expected branch eMatchesMu23e12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23e12DZPath")
        else:
            self.eMatchesMu23e12DZPath_branch.SetAddress(<void*>&self.eMatchesMu23e12DZPath_value)

        #print "making eMatchesMu8e23DZFilter"
        self.eMatchesMu8e23DZFilter_branch = the_tree.GetBranch("eMatchesMu8e23DZFilter")
        #if not self.eMatchesMu8e23DZFilter_branch and "eMatchesMu8e23DZFilter" not in self.complained:
        if not self.eMatchesMu8e23DZFilter_branch and "eMatchesMu8e23DZFilter":
            warnings.warn( "ETauTree: Expected branch eMatchesMu8e23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8e23DZFilter")
        else:
            self.eMatchesMu8e23DZFilter_branch.SetAddress(<void*>&self.eMatchesMu8e23DZFilter_value)

        #print "making eMatchesMu8e23DZPath"
        self.eMatchesMu8e23DZPath_branch = the_tree.GetBranch("eMatchesMu8e23DZPath")
        #if not self.eMatchesMu8e23DZPath_branch and "eMatchesMu8e23DZPath" not in self.complained:
        if not self.eMatchesMu8e23DZPath_branch and "eMatchesMu8e23DZPath":
            warnings.warn( "ETauTree: Expected branch eMatchesMu8e23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8e23DZPath")
        else:
            self.eMatchesMu8e23DZPath_branch.SetAddress(<void*>&self.eMatchesMu8e23DZPath_value)

        #print "making eMissingHits"
        self.eMissingHits_branch = the_tree.GetBranch("eMissingHits")
        #if not self.eMissingHits_branch and "eMissingHits" not in self.complained:
        if not self.eMissingHits_branch and "eMissingHits":
            warnings.warn( "ETauTree: Expected branch eMissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMissingHits")
        else:
            self.eMissingHits_branch.SetAddress(<void*>&self.eMissingHits_value)

        #print "making eNearMuonVeto"
        self.eNearMuonVeto_branch = the_tree.GetBranch("eNearMuonVeto")
        #if not self.eNearMuonVeto_branch and "eNearMuonVeto" not in self.complained:
        if not self.eNearMuonVeto_branch and "eNearMuonVeto":
            warnings.warn( "ETauTree: Expected branch eNearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearMuonVeto")
        else:
            self.eNearMuonVeto_branch.SetAddress(<void*>&self.eNearMuonVeto_value)

        #print "making eNearestMuonDR"
        self.eNearestMuonDR_branch = the_tree.GetBranch("eNearestMuonDR")
        #if not self.eNearestMuonDR_branch and "eNearestMuonDR" not in self.complained:
        if not self.eNearestMuonDR_branch and "eNearestMuonDR":
            warnings.warn( "ETauTree: Expected branch eNearestMuonDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearestMuonDR")
        else:
            self.eNearestMuonDR_branch.SetAddress(<void*>&self.eNearestMuonDR_value)

        #print "making eNearestZMass"
        self.eNearestZMass_branch = the_tree.GetBranch("eNearestZMass")
        #if not self.eNearestZMass_branch and "eNearestZMass" not in self.complained:
        if not self.eNearestZMass_branch and "eNearestZMass":
            warnings.warn( "ETauTree: Expected branch eNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearestZMass")
        else:
            self.eNearestZMass_branch.SetAddress(<void*>&self.eNearestZMass_value)

        #print "making ePFChargedIso"
        self.ePFChargedIso_branch = the_tree.GetBranch("ePFChargedIso")
        #if not self.ePFChargedIso_branch and "ePFChargedIso" not in self.complained:
        if not self.ePFChargedIso_branch and "ePFChargedIso":
            warnings.warn( "ETauTree: Expected branch ePFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFChargedIso")
        else:
            self.ePFChargedIso_branch.SetAddress(<void*>&self.ePFChargedIso_value)

        #print "making ePFNeutralIso"
        self.ePFNeutralIso_branch = the_tree.GetBranch("ePFNeutralIso")
        #if not self.ePFNeutralIso_branch and "ePFNeutralIso" not in self.complained:
        if not self.ePFNeutralIso_branch and "ePFNeutralIso":
            warnings.warn( "ETauTree: Expected branch ePFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFNeutralIso")
        else:
            self.ePFNeutralIso_branch.SetAddress(<void*>&self.ePFNeutralIso_value)

        #print "making ePFPUChargedIso"
        self.ePFPUChargedIso_branch = the_tree.GetBranch("ePFPUChargedIso")
        #if not self.ePFPUChargedIso_branch and "ePFPUChargedIso" not in self.complained:
        if not self.ePFPUChargedIso_branch and "ePFPUChargedIso":
            warnings.warn( "ETauTree: Expected branch ePFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFPUChargedIso")
        else:
            self.ePFPUChargedIso_branch.SetAddress(<void*>&self.ePFPUChargedIso_value)

        #print "making ePFPhotonIso"
        self.ePFPhotonIso_branch = the_tree.GetBranch("ePFPhotonIso")
        #if not self.ePFPhotonIso_branch and "ePFPhotonIso" not in self.complained:
        if not self.ePFPhotonIso_branch and "ePFPhotonIso":
            warnings.warn( "ETauTree: Expected branch ePFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFPhotonIso")
        else:
            self.ePFPhotonIso_branch.SetAddress(<void*>&self.ePFPhotonIso_value)

        #print "making ePVDXY"
        self.ePVDXY_branch = the_tree.GetBranch("ePVDXY")
        #if not self.ePVDXY_branch and "ePVDXY" not in self.complained:
        if not self.ePVDXY_branch and "ePVDXY":
            warnings.warn( "ETauTree: Expected branch ePVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDXY")
        else:
            self.ePVDXY_branch.SetAddress(<void*>&self.ePVDXY_value)

        #print "making ePVDZ"
        self.ePVDZ_branch = the_tree.GetBranch("ePVDZ")
        #if not self.ePVDZ_branch and "ePVDZ" not in self.complained:
        if not self.ePVDZ_branch and "ePVDZ":
            warnings.warn( "ETauTree: Expected branch ePVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDZ")
        else:
            self.ePVDZ_branch.SetAddress(<void*>&self.ePVDZ_value)

        #print "making ePassesConversionVeto"
        self.ePassesConversionVeto_branch = the_tree.GetBranch("ePassesConversionVeto")
        #if not self.ePassesConversionVeto_branch and "ePassesConversionVeto" not in self.complained:
        if not self.ePassesConversionVeto_branch and "ePassesConversionVeto":
            warnings.warn( "ETauTree: Expected branch ePassesConversionVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePassesConversionVeto")
        else:
            self.ePassesConversionVeto_branch.SetAddress(<void*>&self.ePassesConversionVeto_value)

        #print "making ePhi"
        self.ePhi_branch = the_tree.GetBranch("ePhi")
        #if not self.ePhi_branch and "ePhi" not in self.complained:
        if not self.ePhi_branch and "ePhi":
            warnings.warn( "ETauTree: Expected branch ePhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhi")
        else:
            self.ePhi_branch.SetAddress(<void*>&self.ePhi_value)

        #print "making ePt"
        self.ePt_branch = the_tree.GetBranch("ePt")
        #if not self.ePt_branch and "ePt" not in self.complained:
        if not self.ePt_branch and "ePt":
            warnings.warn( "ETauTree: Expected branch ePt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt")
        else:
            self.ePt_branch.SetAddress(<void*>&self.ePt_value)

        #print "making eRelIso"
        self.eRelIso_branch = the_tree.GetBranch("eRelIso")
        #if not self.eRelIso_branch and "eRelIso" not in self.complained:
        if not self.eRelIso_branch and "eRelIso":
            warnings.warn( "ETauTree: Expected branch eRelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelIso")
        else:
            self.eRelIso_branch.SetAddress(<void*>&self.eRelIso_value)

        #print "making eRelPFIsoDB"
        self.eRelPFIsoDB_branch = the_tree.GetBranch("eRelPFIsoDB")
        #if not self.eRelPFIsoDB_branch and "eRelPFIsoDB" not in self.complained:
        if not self.eRelPFIsoDB_branch and "eRelPFIsoDB":
            warnings.warn( "ETauTree: Expected branch eRelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoDB")
        else:
            self.eRelPFIsoDB_branch.SetAddress(<void*>&self.eRelPFIsoDB_value)

        #print "making eRelPFIsoRho"
        self.eRelPFIsoRho_branch = the_tree.GetBranch("eRelPFIsoRho")
        #if not self.eRelPFIsoRho_branch and "eRelPFIsoRho" not in self.complained:
        if not self.eRelPFIsoRho_branch and "eRelPFIsoRho":
            warnings.warn( "ETauTree: Expected branch eRelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRho")
        else:
            self.eRelPFIsoRho_branch.SetAddress(<void*>&self.eRelPFIsoRho_value)

        #print "making eRho"
        self.eRho_branch = the_tree.GetBranch("eRho")
        #if not self.eRho_branch and "eRho" not in self.complained:
        if not self.eRho_branch and "eRho":
            warnings.warn( "ETauTree: Expected branch eRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRho")
        else:
            self.eRho_branch.SetAddress(<void*>&self.eRho_value)

        #print "making eSCEnergy"
        self.eSCEnergy_branch = the_tree.GetBranch("eSCEnergy")
        #if not self.eSCEnergy_branch and "eSCEnergy" not in self.complained:
        if not self.eSCEnergy_branch and "eSCEnergy":
            warnings.warn( "ETauTree: Expected branch eSCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEnergy")
        else:
            self.eSCEnergy_branch.SetAddress(<void*>&self.eSCEnergy_value)

        #print "making eSCEta"
        self.eSCEta_branch = the_tree.GetBranch("eSCEta")
        #if not self.eSCEta_branch and "eSCEta" not in self.complained:
        if not self.eSCEta_branch and "eSCEta":
            warnings.warn( "ETauTree: Expected branch eSCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEta")
        else:
            self.eSCEta_branch.SetAddress(<void*>&self.eSCEta_value)

        #print "making eSCEtaWidth"
        self.eSCEtaWidth_branch = the_tree.GetBranch("eSCEtaWidth")
        #if not self.eSCEtaWidth_branch and "eSCEtaWidth" not in self.complained:
        if not self.eSCEtaWidth_branch and "eSCEtaWidth":
            warnings.warn( "ETauTree: Expected branch eSCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEtaWidth")
        else:
            self.eSCEtaWidth_branch.SetAddress(<void*>&self.eSCEtaWidth_value)

        #print "making eSCPhi"
        self.eSCPhi_branch = the_tree.GetBranch("eSCPhi")
        #if not self.eSCPhi_branch and "eSCPhi" not in self.complained:
        if not self.eSCPhi_branch and "eSCPhi":
            warnings.warn( "ETauTree: Expected branch eSCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhi")
        else:
            self.eSCPhi_branch.SetAddress(<void*>&self.eSCPhi_value)

        #print "making eSCPhiWidth"
        self.eSCPhiWidth_branch = the_tree.GetBranch("eSCPhiWidth")
        #if not self.eSCPhiWidth_branch and "eSCPhiWidth" not in self.complained:
        if not self.eSCPhiWidth_branch and "eSCPhiWidth":
            warnings.warn( "ETauTree: Expected branch eSCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhiWidth")
        else:
            self.eSCPhiWidth_branch.SetAddress(<void*>&self.eSCPhiWidth_value)

        #print "making eSCPreshowerEnergy"
        self.eSCPreshowerEnergy_branch = the_tree.GetBranch("eSCPreshowerEnergy")
        #if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy" not in self.complained:
        if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy":
            warnings.warn( "ETauTree: Expected branch eSCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPreshowerEnergy")
        else:
            self.eSCPreshowerEnergy_branch.SetAddress(<void*>&self.eSCPreshowerEnergy_value)

        #print "making eSCRawEnergy"
        self.eSCRawEnergy_branch = the_tree.GetBranch("eSCRawEnergy")
        #if not self.eSCRawEnergy_branch and "eSCRawEnergy" not in self.complained:
        if not self.eSCRawEnergy_branch and "eSCRawEnergy":
            warnings.warn( "ETauTree: Expected branch eSCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCRawEnergy")
        else:
            self.eSCRawEnergy_branch.SetAddress(<void*>&self.eSCRawEnergy_value)

        #print "making eSIP2D"
        self.eSIP2D_branch = the_tree.GetBranch("eSIP2D")
        #if not self.eSIP2D_branch and "eSIP2D" not in self.complained:
        if not self.eSIP2D_branch and "eSIP2D":
            warnings.warn( "ETauTree: Expected branch eSIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSIP2D")
        else:
            self.eSIP2D_branch.SetAddress(<void*>&self.eSIP2D_value)

        #print "making eSIP3D"
        self.eSIP3D_branch = the_tree.GetBranch("eSIP3D")
        #if not self.eSIP3D_branch and "eSIP3D" not in self.complained:
        if not self.eSIP3D_branch and "eSIP3D":
            warnings.warn( "ETauTree: Expected branch eSIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSIP3D")
        else:
            self.eSIP3D_branch.SetAddress(<void*>&self.eSIP3D_value)

        #print "making eSigmaIEtaIEta"
        self.eSigmaIEtaIEta_branch = the_tree.GetBranch("eSigmaIEtaIEta")
        #if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta" not in self.complained:
        if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta":
            warnings.warn( "ETauTree: Expected branch eSigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSigmaIEtaIEta")
        else:
            self.eSigmaIEtaIEta_branch.SetAddress(<void*>&self.eSigmaIEtaIEta_value)

        #print "making eTrkIsoDR03"
        self.eTrkIsoDR03_branch = the_tree.GetBranch("eTrkIsoDR03")
        #if not self.eTrkIsoDR03_branch and "eTrkIsoDR03" not in self.complained:
        if not self.eTrkIsoDR03_branch and "eTrkIsoDR03":
            warnings.warn( "ETauTree: Expected branch eTrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTrkIsoDR03")
        else:
            self.eTrkIsoDR03_branch.SetAddress(<void*>&self.eTrkIsoDR03_value)

        #print "making eVZ"
        self.eVZ_branch = the_tree.GetBranch("eVZ")
        #if not self.eVZ_branch and "eVZ" not in self.complained:
        if not self.eVZ_branch and "eVZ":
            warnings.warn( "ETauTree: Expected branch eVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVZ")
        else:
            self.eVZ_branch.SetAddress(<void*>&self.eVZ_value)

        #print "making eVetoHZZPt5"
        self.eVetoHZZPt5_branch = the_tree.GetBranch("eVetoHZZPt5")
        #if not self.eVetoHZZPt5_branch and "eVetoHZZPt5" not in self.complained:
        if not self.eVetoHZZPt5_branch and "eVetoHZZPt5":
            warnings.warn( "ETauTree: Expected branch eVetoHZZPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoHZZPt5")
        else:
            self.eVetoHZZPt5_branch.SetAddress(<void*>&self.eVetoHZZPt5_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "ETauTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "ETauTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making eVetoZTTp001dxyzR0"
        self.eVetoZTTp001dxyzR0_branch = the_tree.GetBranch("eVetoZTTp001dxyzR0")
        #if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0" not in self.complained:
        if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0":
            warnings.warn( "ETauTree: Expected branch eVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyzR0")
        else:
            self.eVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.eVetoZTTp001dxyzR0_value)

        #print "making eZTTGenMatching"
        self.eZTTGenMatching_branch = the_tree.GetBranch("eZTTGenMatching")
        #if not self.eZTTGenMatching_branch and "eZTTGenMatching" not in self.complained:
        if not self.eZTTGenMatching_branch and "eZTTGenMatching":
            warnings.warn( "ETauTree: Expected branch eZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eZTTGenMatching")
        else:
            self.eZTTGenMatching_branch.SetAddress(<void*>&self.eZTTGenMatching_value)

        #print "making e_t_DR"
        self.e_t_DR_branch = the_tree.GetBranch("e_t_DR")
        #if not self.e_t_DR_branch and "e_t_DR" not in self.complained:
        if not self.e_t_DR_branch and "e_t_DR":
            warnings.warn( "ETauTree: Expected branch e_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_DR")
        else:
            self.e_t_DR_branch.SetAddress(<void*>&self.e_t_DR_value)

        #print "making e_t_Mass"
        self.e_t_Mass_branch = the_tree.GetBranch("e_t_Mass")
        #if not self.e_t_Mass_branch and "e_t_Mass" not in self.complained:
        if not self.e_t_Mass_branch and "e_t_Mass":
            warnings.warn( "ETauTree: Expected branch e_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Mass")
        else:
            self.e_t_Mass_branch.SetAddress(<void*>&self.e_t_Mass_value)

        #print "making e_t_PZeta"
        self.e_t_PZeta_branch = the_tree.GetBranch("e_t_PZeta")
        #if not self.e_t_PZeta_branch and "e_t_PZeta" not in self.complained:
        if not self.e_t_PZeta_branch and "e_t_PZeta":
            warnings.warn( "ETauTree: Expected branch e_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_PZeta")
        else:
            self.e_t_PZeta_branch.SetAddress(<void*>&self.e_t_PZeta_value)

        #print "making e_t_PZetaVis"
        self.e_t_PZetaVis_branch = the_tree.GetBranch("e_t_PZetaVis")
        #if not self.e_t_PZetaVis_branch and "e_t_PZetaVis" not in self.complained:
        if not self.e_t_PZetaVis_branch and "e_t_PZetaVis":
            warnings.warn( "ETauTree: Expected branch e_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_PZetaVis")
        else:
            self.e_t_PZetaVis_branch.SetAddress(<void*>&self.e_t_PZetaVis_value)

        #print "making edeltaEtaSuperClusterTrackAtVtx"
        self.edeltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaEtaSuperClusterTrackAtVtx")
        #if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "ETauTree: Expected branch edeltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaEtaSuperClusterTrackAtVtx")
        else:
            self.edeltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaEtaSuperClusterTrackAtVtx_value)

        #print "making edeltaPhiSuperClusterTrackAtVtx"
        self.edeltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaPhiSuperClusterTrackAtVtx")
        #if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "ETauTree: Expected branch edeltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaPhiSuperClusterTrackAtVtx")
        else:
            self.edeltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaPhiSuperClusterTrackAtVtx_value)

        #print "making eeSuperClusterOverP"
        self.eeSuperClusterOverP_branch = the_tree.GetBranch("eeSuperClusterOverP")
        #if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP" not in self.complained:
        if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP":
            warnings.warn( "ETauTree: Expected branch eeSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eeSuperClusterOverP")
        else:
            self.eeSuperClusterOverP_branch.SetAddress(<void*>&self.eeSuperClusterOverP_value)

        #print "making eecalEnergy"
        self.eecalEnergy_branch = the_tree.GetBranch("eecalEnergy")
        #if not self.eecalEnergy_branch and "eecalEnergy" not in self.complained:
        if not self.eecalEnergy_branch and "eecalEnergy":
            warnings.warn( "ETauTree: Expected branch eecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eecalEnergy")
        else:
            self.eecalEnergy_branch.SetAddress(<void*>&self.eecalEnergy_value)

        #print "making efBrem"
        self.efBrem_branch = the_tree.GetBranch("efBrem")
        #if not self.efBrem_branch and "efBrem" not in self.complained:
        if not self.efBrem_branch and "efBrem":
            warnings.warn( "ETauTree: Expected branch efBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("efBrem")
        else:
            self.efBrem_branch.SetAddress(<void*>&self.efBrem_value)

        #print "making etrackMomentumAtVtxP"
        self.etrackMomentumAtVtxP_branch = the_tree.GetBranch("etrackMomentumAtVtxP")
        #if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP" not in self.complained:
        if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP":
            warnings.warn( "ETauTree: Expected branch etrackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("etrackMomentumAtVtxP")
        else:
            self.etrackMomentumAtVtxP_branch.SetAddress(<void*>&self.etrackMomentumAtVtxP_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "ETauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "ETauTree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "ETauTree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "ETauTree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isWenu"
        self.isWenu_branch = the_tree.GetBranch("isWenu")
        #if not self.isWenu_branch and "isWenu" not in self.complained:
        if not self.isWenu_branch and "isWenu":
            warnings.warn( "ETauTree: Expected branch isWenu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWenu")
        else:
            self.isWenu_branch.SetAddress(<void*>&self.isWenu_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "ETauTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "ETauTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZee"
        self.isZee_branch = the_tree.GetBranch("isZee")
        #if not self.isZee_branch and "isZee" not in self.complained:
        if not self.isZee_branch and "isZee":
            warnings.warn( "ETauTree: Expected branch isZee does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZee")
        else:
            self.isZee_branch.SetAddress(<void*>&self.isZee_value)

        #print "making isZmumu"
        self.isZmumu_branch = the_tree.GetBranch("isZmumu")
        #if not self.isZmumu_branch and "isZmumu" not in self.complained:
        if not self.isZmumu_branch and "isZmumu":
            warnings.warn( "ETauTree: Expected branch isZmumu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZmumu")
        else:
            self.isZmumu_branch.SetAddress(<void*>&self.isZmumu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "ETauTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "ETauTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isembed"
        self.isembed_branch = the_tree.GetBranch("isembed")
        #if not self.isembed_branch and "isembed" not in self.complained:
        if not self.isembed_branch and "isembed":
            warnings.warn( "ETauTree: Expected branch isembed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isembed")
        else:
            self.isembed_branch.SetAddress(<void*>&self.isembed_value)

        #print "making jb1eta"
        self.jb1eta_branch = the_tree.GetBranch("jb1eta")
        #if not self.jb1eta_branch and "jb1eta" not in self.complained:
        if not self.jb1eta_branch and "jb1eta":
            warnings.warn( "ETauTree: Expected branch jb1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta")
        else:
            self.jb1eta_branch.SetAddress(<void*>&self.jb1eta_value)

        #print "making jb1hadronflavor"
        self.jb1hadronflavor_branch = the_tree.GetBranch("jb1hadronflavor")
        #if not self.jb1hadronflavor_branch and "jb1hadronflavor" not in self.complained:
        if not self.jb1hadronflavor_branch and "jb1hadronflavor":
            warnings.warn( "ETauTree: Expected branch jb1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor")
        else:
            self.jb1hadronflavor_branch.SetAddress(<void*>&self.jb1hadronflavor_value)

        #print "making jb1pt"
        self.jb1pt_branch = the_tree.GetBranch("jb1pt")
        #if not self.jb1pt_branch and "jb1pt" not in self.complained:
        if not self.jb1pt_branch and "jb1pt":
            warnings.warn( "ETauTree: Expected branch jb1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt")
        else:
            self.jb1pt_branch.SetAddress(<void*>&self.jb1pt_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "ETauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20WoNoisyJets"
        self.jetVeto20WoNoisyJets_branch = the_tree.GetBranch("jetVeto20WoNoisyJets")
        #if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets" not in self.complained:
        if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets":
            warnings.warn( "ETauTree: Expected branch jetVeto20WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20WoNoisyJets")
        else:
            self.jetVeto20WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto20WoNoisyJets_value)

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "ETauTree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "ETauTree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "ETauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30WoNoisyJets"
        self.jetVeto30WoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_value)

        #print "making jetVeto30WoNoisyJets_JetEnDown"
        self.jetVeto30WoNoisyJets_JetEnDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEnDown")
        #if not self.jetVeto30WoNoisyJets_JetEnDown_branch and "jetVeto30WoNoisyJets_JetEnDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEnDown_branch and "jetVeto30WoNoisyJets_JetEnDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEnDown")
        else:
            self.jetVeto30WoNoisyJets_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEnDown_value)

        #print "making jetVeto30WoNoisyJets_JetEnUp"
        self.jetVeto30WoNoisyJets_JetEnUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEnUp")
        #if not self.jetVeto30WoNoisyJets_JetEnUp_branch and "jetVeto30WoNoisyJets_JetEnUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEnUp_branch and "jetVeto30WoNoisyJets_JetEnUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEnUp")
        else:
            self.jetVeto30WoNoisyJets_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEnUp_value)

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making lheweight0"
        self.lheweight0_branch = the_tree.GetBranch("lheweight0")
        #if not self.lheweight0_branch and "lheweight0" not in self.complained:
        if not self.lheweight0_branch and "lheweight0":
            warnings.warn( "ETauTree: Expected branch lheweight0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight0")
        else:
            self.lheweight0_branch.SetAddress(<void*>&self.lheweight0_value)

        #print "making lheweight1"
        self.lheweight1_branch = the_tree.GetBranch("lheweight1")
        #if not self.lheweight1_branch and "lheweight1" not in self.complained:
        if not self.lheweight1_branch and "lheweight1":
            warnings.warn( "ETauTree: Expected branch lheweight1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight1")
        else:
            self.lheweight1_branch.SetAddress(<void*>&self.lheweight1_value)

        #print "making lheweight10"
        self.lheweight10_branch = the_tree.GetBranch("lheweight10")
        #if not self.lheweight10_branch and "lheweight10" not in self.complained:
        if not self.lheweight10_branch and "lheweight10":
            warnings.warn( "ETauTree: Expected branch lheweight10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight10")
        else:
            self.lheweight10_branch.SetAddress(<void*>&self.lheweight10_value)

        #print "making lheweight100"
        self.lheweight100_branch = the_tree.GetBranch("lheweight100")
        #if not self.lheweight100_branch and "lheweight100" not in self.complained:
        if not self.lheweight100_branch and "lheweight100":
            warnings.warn( "ETauTree: Expected branch lheweight100 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight100")
        else:
            self.lheweight100_branch.SetAddress(<void*>&self.lheweight100_value)

        #print "making lheweight101"
        self.lheweight101_branch = the_tree.GetBranch("lheweight101")
        #if not self.lheweight101_branch and "lheweight101" not in self.complained:
        if not self.lheweight101_branch and "lheweight101":
            warnings.warn( "ETauTree: Expected branch lheweight101 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight101")
        else:
            self.lheweight101_branch.SetAddress(<void*>&self.lheweight101_value)

        #print "making lheweight102"
        self.lheweight102_branch = the_tree.GetBranch("lheweight102")
        #if not self.lheweight102_branch and "lheweight102" not in self.complained:
        if not self.lheweight102_branch and "lheweight102":
            warnings.warn( "ETauTree: Expected branch lheweight102 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight102")
        else:
            self.lheweight102_branch.SetAddress(<void*>&self.lheweight102_value)

        #print "making lheweight103"
        self.lheweight103_branch = the_tree.GetBranch("lheweight103")
        #if not self.lheweight103_branch and "lheweight103" not in self.complained:
        if not self.lheweight103_branch and "lheweight103":
            warnings.warn( "ETauTree: Expected branch lheweight103 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight103")
        else:
            self.lheweight103_branch.SetAddress(<void*>&self.lheweight103_value)

        #print "making lheweight104"
        self.lheweight104_branch = the_tree.GetBranch("lheweight104")
        #if not self.lheweight104_branch and "lheweight104" not in self.complained:
        if not self.lheweight104_branch and "lheweight104":
            warnings.warn( "ETauTree: Expected branch lheweight104 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight104")
        else:
            self.lheweight104_branch.SetAddress(<void*>&self.lheweight104_value)

        #print "making lheweight105"
        self.lheweight105_branch = the_tree.GetBranch("lheweight105")
        #if not self.lheweight105_branch and "lheweight105" not in self.complained:
        if not self.lheweight105_branch and "lheweight105":
            warnings.warn( "ETauTree: Expected branch lheweight105 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight105")
        else:
            self.lheweight105_branch.SetAddress(<void*>&self.lheweight105_value)

        #print "making lheweight106"
        self.lheweight106_branch = the_tree.GetBranch("lheweight106")
        #if not self.lheweight106_branch and "lheweight106" not in self.complained:
        if not self.lheweight106_branch and "lheweight106":
            warnings.warn( "ETauTree: Expected branch lheweight106 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight106")
        else:
            self.lheweight106_branch.SetAddress(<void*>&self.lheweight106_value)

        #print "making lheweight107"
        self.lheweight107_branch = the_tree.GetBranch("lheweight107")
        #if not self.lheweight107_branch and "lheweight107" not in self.complained:
        if not self.lheweight107_branch and "lheweight107":
            warnings.warn( "ETauTree: Expected branch lheweight107 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight107")
        else:
            self.lheweight107_branch.SetAddress(<void*>&self.lheweight107_value)

        #print "making lheweight108"
        self.lheweight108_branch = the_tree.GetBranch("lheweight108")
        #if not self.lheweight108_branch and "lheweight108" not in self.complained:
        if not self.lheweight108_branch and "lheweight108":
            warnings.warn( "ETauTree: Expected branch lheweight108 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight108")
        else:
            self.lheweight108_branch.SetAddress(<void*>&self.lheweight108_value)

        #print "making lheweight109"
        self.lheweight109_branch = the_tree.GetBranch("lheweight109")
        #if not self.lheweight109_branch and "lheweight109" not in self.complained:
        if not self.lheweight109_branch and "lheweight109":
            warnings.warn( "ETauTree: Expected branch lheweight109 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight109")
        else:
            self.lheweight109_branch.SetAddress(<void*>&self.lheweight109_value)

        #print "making lheweight11"
        self.lheweight11_branch = the_tree.GetBranch("lheweight11")
        #if not self.lheweight11_branch and "lheweight11" not in self.complained:
        if not self.lheweight11_branch and "lheweight11":
            warnings.warn( "ETauTree: Expected branch lheweight11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight11")
        else:
            self.lheweight11_branch.SetAddress(<void*>&self.lheweight11_value)

        #print "making lheweight110"
        self.lheweight110_branch = the_tree.GetBranch("lheweight110")
        #if not self.lheweight110_branch and "lheweight110" not in self.complained:
        if not self.lheweight110_branch and "lheweight110":
            warnings.warn( "ETauTree: Expected branch lheweight110 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight110")
        else:
            self.lheweight110_branch.SetAddress(<void*>&self.lheweight110_value)

        #print "making lheweight111"
        self.lheweight111_branch = the_tree.GetBranch("lheweight111")
        #if not self.lheweight111_branch and "lheweight111" not in self.complained:
        if not self.lheweight111_branch and "lheweight111":
            warnings.warn( "ETauTree: Expected branch lheweight111 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight111")
        else:
            self.lheweight111_branch.SetAddress(<void*>&self.lheweight111_value)

        #print "making lheweight112"
        self.lheweight112_branch = the_tree.GetBranch("lheweight112")
        #if not self.lheweight112_branch and "lheweight112" not in self.complained:
        if not self.lheweight112_branch and "lheweight112":
            warnings.warn( "ETauTree: Expected branch lheweight112 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight112")
        else:
            self.lheweight112_branch.SetAddress(<void*>&self.lheweight112_value)

        #print "making lheweight113"
        self.lheweight113_branch = the_tree.GetBranch("lheweight113")
        #if not self.lheweight113_branch and "lheweight113" not in self.complained:
        if not self.lheweight113_branch and "lheweight113":
            warnings.warn( "ETauTree: Expected branch lheweight113 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight113")
        else:
            self.lheweight113_branch.SetAddress(<void*>&self.lheweight113_value)

        #print "making lheweight114"
        self.lheweight114_branch = the_tree.GetBranch("lheweight114")
        #if not self.lheweight114_branch and "lheweight114" not in self.complained:
        if not self.lheweight114_branch and "lheweight114":
            warnings.warn( "ETauTree: Expected branch lheweight114 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight114")
        else:
            self.lheweight114_branch.SetAddress(<void*>&self.lheweight114_value)

        #print "making lheweight115"
        self.lheweight115_branch = the_tree.GetBranch("lheweight115")
        #if not self.lheweight115_branch and "lheweight115" not in self.complained:
        if not self.lheweight115_branch and "lheweight115":
            warnings.warn( "ETauTree: Expected branch lheweight115 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight115")
        else:
            self.lheweight115_branch.SetAddress(<void*>&self.lheweight115_value)

        #print "making lheweight116"
        self.lheweight116_branch = the_tree.GetBranch("lheweight116")
        #if not self.lheweight116_branch and "lheweight116" not in self.complained:
        if not self.lheweight116_branch and "lheweight116":
            warnings.warn( "ETauTree: Expected branch lheweight116 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight116")
        else:
            self.lheweight116_branch.SetAddress(<void*>&self.lheweight116_value)

        #print "making lheweight117"
        self.lheweight117_branch = the_tree.GetBranch("lheweight117")
        #if not self.lheweight117_branch and "lheweight117" not in self.complained:
        if not self.lheweight117_branch and "lheweight117":
            warnings.warn( "ETauTree: Expected branch lheweight117 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight117")
        else:
            self.lheweight117_branch.SetAddress(<void*>&self.lheweight117_value)

        #print "making lheweight118"
        self.lheweight118_branch = the_tree.GetBranch("lheweight118")
        #if not self.lheweight118_branch and "lheweight118" not in self.complained:
        if not self.lheweight118_branch and "lheweight118":
            warnings.warn( "ETauTree: Expected branch lheweight118 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight118")
        else:
            self.lheweight118_branch.SetAddress(<void*>&self.lheweight118_value)

        #print "making lheweight119"
        self.lheweight119_branch = the_tree.GetBranch("lheweight119")
        #if not self.lheweight119_branch and "lheweight119" not in self.complained:
        if not self.lheweight119_branch and "lheweight119":
            warnings.warn( "ETauTree: Expected branch lheweight119 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight119")
        else:
            self.lheweight119_branch.SetAddress(<void*>&self.lheweight119_value)

        #print "making lheweight12"
        self.lheweight12_branch = the_tree.GetBranch("lheweight12")
        #if not self.lheweight12_branch and "lheweight12" not in self.complained:
        if not self.lheweight12_branch and "lheweight12":
            warnings.warn( "ETauTree: Expected branch lheweight12 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight12")
        else:
            self.lheweight12_branch.SetAddress(<void*>&self.lheweight12_value)

        #print "making lheweight120"
        self.lheweight120_branch = the_tree.GetBranch("lheweight120")
        #if not self.lheweight120_branch and "lheweight120" not in self.complained:
        if not self.lheweight120_branch and "lheweight120":
            warnings.warn( "ETauTree: Expected branch lheweight120 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight120")
        else:
            self.lheweight120_branch.SetAddress(<void*>&self.lheweight120_value)

        #print "making lheweight121"
        self.lheweight121_branch = the_tree.GetBranch("lheweight121")
        #if not self.lheweight121_branch and "lheweight121" not in self.complained:
        if not self.lheweight121_branch and "lheweight121":
            warnings.warn( "ETauTree: Expected branch lheweight121 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight121")
        else:
            self.lheweight121_branch.SetAddress(<void*>&self.lheweight121_value)

        #print "making lheweight122"
        self.lheweight122_branch = the_tree.GetBranch("lheweight122")
        #if not self.lheweight122_branch and "lheweight122" not in self.complained:
        if not self.lheweight122_branch and "lheweight122":
            warnings.warn( "ETauTree: Expected branch lheweight122 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight122")
        else:
            self.lheweight122_branch.SetAddress(<void*>&self.lheweight122_value)

        #print "making lheweight123"
        self.lheweight123_branch = the_tree.GetBranch("lheweight123")
        #if not self.lheweight123_branch and "lheweight123" not in self.complained:
        if not self.lheweight123_branch and "lheweight123":
            warnings.warn( "ETauTree: Expected branch lheweight123 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight123")
        else:
            self.lheweight123_branch.SetAddress(<void*>&self.lheweight123_value)

        #print "making lheweight124"
        self.lheweight124_branch = the_tree.GetBranch("lheweight124")
        #if not self.lheweight124_branch and "lheweight124" not in self.complained:
        if not self.lheweight124_branch and "lheweight124":
            warnings.warn( "ETauTree: Expected branch lheweight124 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight124")
        else:
            self.lheweight124_branch.SetAddress(<void*>&self.lheweight124_value)

        #print "making lheweight125"
        self.lheweight125_branch = the_tree.GetBranch("lheweight125")
        #if not self.lheweight125_branch and "lheweight125" not in self.complained:
        if not self.lheweight125_branch and "lheweight125":
            warnings.warn( "ETauTree: Expected branch lheweight125 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight125")
        else:
            self.lheweight125_branch.SetAddress(<void*>&self.lheweight125_value)

        #print "making lheweight126"
        self.lheweight126_branch = the_tree.GetBranch("lheweight126")
        #if not self.lheweight126_branch and "lheweight126" not in self.complained:
        if not self.lheweight126_branch and "lheweight126":
            warnings.warn( "ETauTree: Expected branch lheweight126 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight126")
        else:
            self.lheweight126_branch.SetAddress(<void*>&self.lheweight126_value)

        #print "making lheweight127"
        self.lheweight127_branch = the_tree.GetBranch("lheweight127")
        #if not self.lheweight127_branch and "lheweight127" not in self.complained:
        if not self.lheweight127_branch and "lheweight127":
            warnings.warn( "ETauTree: Expected branch lheweight127 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight127")
        else:
            self.lheweight127_branch.SetAddress(<void*>&self.lheweight127_value)

        #print "making lheweight128"
        self.lheweight128_branch = the_tree.GetBranch("lheweight128")
        #if not self.lheweight128_branch and "lheweight128" not in self.complained:
        if not self.lheweight128_branch and "lheweight128":
            warnings.warn( "ETauTree: Expected branch lheweight128 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight128")
        else:
            self.lheweight128_branch.SetAddress(<void*>&self.lheweight128_value)

        #print "making lheweight129"
        self.lheweight129_branch = the_tree.GetBranch("lheweight129")
        #if not self.lheweight129_branch and "lheweight129" not in self.complained:
        if not self.lheweight129_branch and "lheweight129":
            warnings.warn( "ETauTree: Expected branch lheweight129 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight129")
        else:
            self.lheweight129_branch.SetAddress(<void*>&self.lheweight129_value)

        #print "making lheweight13"
        self.lheweight13_branch = the_tree.GetBranch("lheweight13")
        #if not self.lheweight13_branch and "lheweight13" not in self.complained:
        if not self.lheweight13_branch and "lheweight13":
            warnings.warn( "ETauTree: Expected branch lheweight13 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight13")
        else:
            self.lheweight13_branch.SetAddress(<void*>&self.lheweight13_value)

        #print "making lheweight130"
        self.lheweight130_branch = the_tree.GetBranch("lheweight130")
        #if not self.lheweight130_branch and "lheweight130" not in self.complained:
        if not self.lheweight130_branch and "lheweight130":
            warnings.warn( "ETauTree: Expected branch lheweight130 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight130")
        else:
            self.lheweight130_branch.SetAddress(<void*>&self.lheweight130_value)

        #print "making lheweight131"
        self.lheweight131_branch = the_tree.GetBranch("lheweight131")
        #if not self.lheweight131_branch and "lheweight131" not in self.complained:
        if not self.lheweight131_branch and "lheweight131":
            warnings.warn( "ETauTree: Expected branch lheweight131 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight131")
        else:
            self.lheweight131_branch.SetAddress(<void*>&self.lheweight131_value)

        #print "making lheweight132"
        self.lheweight132_branch = the_tree.GetBranch("lheweight132")
        #if not self.lheweight132_branch and "lheweight132" not in self.complained:
        if not self.lheweight132_branch and "lheweight132":
            warnings.warn( "ETauTree: Expected branch lheweight132 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight132")
        else:
            self.lheweight132_branch.SetAddress(<void*>&self.lheweight132_value)

        #print "making lheweight133"
        self.lheweight133_branch = the_tree.GetBranch("lheweight133")
        #if not self.lheweight133_branch and "lheweight133" not in self.complained:
        if not self.lheweight133_branch and "lheweight133":
            warnings.warn( "ETauTree: Expected branch lheweight133 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight133")
        else:
            self.lheweight133_branch.SetAddress(<void*>&self.lheweight133_value)

        #print "making lheweight134"
        self.lheweight134_branch = the_tree.GetBranch("lheweight134")
        #if not self.lheweight134_branch and "lheweight134" not in self.complained:
        if not self.lheweight134_branch and "lheweight134":
            warnings.warn( "ETauTree: Expected branch lheweight134 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight134")
        else:
            self.lheweight134_branch.SetAddress(<void*>&self.lheweight134_value)

        #print "making lheweight135"
        self.lheweight135_branch = the_tree.GetBranch("lheweight135")
        #if not self.lheweight135_branch and "lheweight135" not in self.complained:
        if not self.lheweight135_branch and "lheweight135":
            warnings.warn( "ETauTree: Expected branch lheweight135 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight135")
        else:
            self.lheweight135_branch.SetAddress(<void*>&self.lheweight135_value)

        #print "making lheweight136"
        self.lheweight136_branch = the_tree.GetBranch("lheweight136")
        #if not self.lheweight136_branch and "lheweight136" not in self.complained:
        if not self.lheweight136_branch and "lheweight136":
            warnings.warn( "ETauTree: Expected branch lheweight136 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight136")
        else:
            self.lheweight136_branch.SetAddress(<void*>&self.lheweight136_value)

        #print "making lheweight137"
        self.lheweight137_branch = the_tree.GetBranch("lheweight137")
        #if not self.lheweight137_branch and "lheweight137" not in self.complained:
        if not self.lheweight137_branch and "lheweight137":
            warnings.warn( "ETauTree: Expected branch lheweight137 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight137")
        else:
            self.lheweight137_branch.SetAddress(<void*>&self.lheweight137_value)

        #print "making lheweight138"
        self.lheweight138_branch = the_tree.GetBranch("lheweight138")
        #if not self.lheweight138_branch and "lheweight138" not in self.complained:
        if not self.lheweight138_branch and "lheweight138":
            warnings.warn( "ETauTree: Expected branch lheweight138 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight138")
        else:
            self.lheweight138_branch.SetAddress(<void*>&self.lheweight138_value)

        #print "making lheweight139"
        self.lheweight139_branch = the_tree.GetBranch("lheweight139")
        #if not self.lheweight139_branch and "lheweight139" not in self.complained:
        if not self.lheweight139_branch and "lheweight139":
            warnings.warn( "ETauTree: Expected branch lheweight139 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight139")
        else:
            self.lheweight139_branch.SetAddress(<void*>&self.lheweight139_value)

        #print "making lheweight14"
        self.lheweight14_branch = the_tree.GetBranch("lheweight14")
        #if not self.lheweight14_branch and "lheweight14" not in self.complained:
        if not self.lheweight14_branch and "lheweight14":
            warnings.warn( "ETauTree: Expected branch lheweight14 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight14")
        else:
            self.lheweight14_branch.SetAddress(<void*>&self.lheweight14_value)

        #print "making lheweight140"
        self.lheweight140_branch = the_tree.GetBranch("lheweight140")
        #if not self.lheweight140_branch and "lheweight140" not in self.complained:
        if not self.lheweight140_branch and "lheweight140":
            warnings.warn( "ETauTree: Expected branch lheweight140 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight140")
        else:
            self.lheweight140_branch.SetAddress(<void*>&self.lheweight140_value)

        #print "making lheweight141"
        self.lheweight141_branch = the_tree.GetBranch("lheweight141")
        #if not self.lheweight141_branch and "lheweight141" not in self.complained:
        if not self.lheweight141_branch and "lheweight141":
            warnings.warn( "ETauTree: Expected branch lheweight141 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight141")
        else:
            self.lheweight141_branch.SetAddress(<void*>&self.lheweight141_value)

        #print "making lheweight142"
        self.lheweight142_branch = the_tree.GetBranch("lheweight142")
        #if not self.lheweight142_branch and "lheweight142" not in self.complained:
        if not self.lheweight142_branch and "lheweight142":
            warnings.warn( "ETauTree: Expected branch lheweight142 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight142")
        else:
            self.lheweight142_branch.SetAddress(<void*>&self.lheweight142_value)

        #print "making lheweight143"
        self.lheweight143_branch = the_tree.GetBranch("lheweight143")
        #if not self.lheweight143_branch and "lheweight143" not in self.complained:
        if not self.lheweight143_branch and "lheweight143":
            warnings.warn( "ETauTree: Expected branch lheweight143 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight143")
        else:
            self.lheweight143_branch.SetAddress(<void*>&self.lheweight143_value)

        #print "making lheweight144"
        self.lheweight144_branch = the_tree.GetBranch("lheweight144")
        #if not self.lheweight144_branch and "lheweight144" not in self.complained:
        if not self.lheweight144_branch and "lheweight144":
            warnings.warn( "ETauTree: Expected branch lheweight144 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight144")
        else:
            self.lheweight144_branch.SetAddress(<void*>&self.lheweight144_value)

        #print "making lheweight145"
        self.lheweight145_branch = the_tree.GetBranch("lheweight145")
        #if not self.lheweight145_branch and "lheweight145" not in self.complained:
        if not self.lheweight145_branch and "lheweight145":
            warnings.warn( "ETauTree: Expected branch lheweight145 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight145")
        else:
            self.lheweight145_branch.SetAddress(<void*>&self.lheweight145_value)

        #print "making lheweight146"
        self.lheweight146_branch = the_tree.GetBranch("lheweight146")
        #if not self.lheweight146_branch and "lheweight146" not in self.complained:
        if not self.lheweight146_branch and "lheweight146":
            warnings.warn( "ETauTree: Expected branch lheweight146 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight146")
        else:
            self.lheweight146_branch.SetAddress(<void*>&self.lheweight146_value)

        #print "making lheweight147"
        self.lheweight147_branch = the_tree.GetBranch("lheweight147")
        #if not self.lheweight147_branch and "lheweight147" not in self.complained:
        if not self.lheweight147_branch and "lheweight147":
            warnings.warn( "ETauTree: Expected branch lheweight147 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight147")
        else:
            self.lheweight147_branch.SetAddress(<void*>&self.lheweight147_value)

        #print "making lheweight148"
        self.lheweight148_branch = the_tree.GetBranch("lheweight148")
        #if not self.lheweight148_branch and "lheweight148" not in self.complained:
        if not self.lheweight148_branch and "lheweight148":
            warnings.warn( "ETauTree: Expected branch lheweight148 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight148")
        else:
            self.lheweight148_branch.SetAddress(<void*>&self.lheweight148_value)

        #print "making lheweight149"
        self.lheweight149_branch = the_tree.GetBranch("lheweight149")
        #if not self.lheweight149_branch and "lheweight149" not in self.complained:
        if not self.lheweight149_branch and "lheweight149":
            warnings.warn( "ETauTree: Expected branch lheweight149 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight149")
        else:
            self.lheweight149_branch.SetAddress(<void*>&self.lheweight149_value)

        #print "making lheweight15"
        self.lheweight15_branch = the_tree.GetBranch("lheweight15")
        #if not self.lheweight15_branch and "lheweight15" not in self.complained:
        if not self.lheweight15_branch and "lheweight15":
            warnings.warn( "ETauTree: Expected branch lheweight15 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight15")
        else:
            self.lheweight15_branch.SetAddress(<void*>&self.lheweight15_value)

        #print "making lheweight150"
        self.lheweight150_branch = the_tree.GetBranch("lheweight150")
        #if not self.lheweight150_branch and "lheweight150" not in self.complained:
        if not self.lheweight150_branch and "lheweight150":
            warnings.warn( "ETauTree: Expected branch lheweight150 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight150")
        else:
            self.lheweight150_branch.SetAddress(<void*>&self.lheweight150_value)

        #print "making lheweight151"
        self.lheweight151_branch = the_tree.GetBranch("lheweight151")
        #if not self.lheweight151_branch and "lheweight151" not in self.complained:
        if not self.lheweight151_branch and "lheweight151":
            warnings.warn( "ETauTree: Expected branch lheweight151 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight151")
        else:
            self.lheweight151_branch.SetAddress(<void*>&self.lheweight151_value)

        #print "making lheweight152"
        self.lheweight152_branch = the_tree.GetBranch("lheweight152")
        #if not self.lheweight152_branch and "lheweight152" not in self.complained:
        if not self.lheweight152_branch and "lheweight152":
            warnings.warn( "ETauTree: Expected branch lheweight152 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight152")
        else:
            self.lheweight152_branch.SetAddress(<void*>&self.lheweight152_value)

        #print "making lheweight153"
        self.lheweight153_branch = the_tree.GetBranch("lheweight153")
        #if not self.lheweight153_branch and "lheweight153" not in self.complained:
        if not self.lheweight153_branch and "lheweight153":
            warnings.warn( "ETauTree: Expected branch lheweight153 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight153")
        else:
            self.lheweight153_branch.SetAddress(<void*>&self.lheweight153_value)

        #print "making lheweight154"
        self.lheweight154_branch = the_tree.GetBranch("lheweight154")
        #if not self.lheweight154_branch and "lheweight154" not in self.complained:
        if not self.lheweight154_branch and "lheweight154":
            warnings.warn( "ETauTree: Expected branch lheweight154 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight154")
        else:
            self.lheweight154_branch.SetAddress(<void*>&self.lheweight154_value)

        #print "making lheweight155"
        self.lheweight155_branch = the_tree.GetBranch("lheweight155")
        #if not self.lheweight155_branch and "lheweight155" not in self.complained:
        if not self.lheweight155_branch and "lheweight155":
            warnings.warn( "ETauTree: Expected branch lheweight155 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight155")
        else:
            self.lheweight155_branch.SetAddress(<void*>&self.lheweight155_value)

        #print "making lheweight156"
        self.lheweight156_branch = the_tree.GetBranch("lheweight156")
        #if not self.lheweight156_branch and "lheweight156" not in self.complained:
        if not self.lheweight156_branch and "lheweight156":
            warnings.warn( "ETauTree: Expected branch lheweight156 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight156")
        else:
            self.lheweight156_branch.SetAddress(<void*>&self.lheweight156_value)

        #print "making lheweight157"
        self.lheweight157_branch = the_tree.GetBranch("lheweight157")
        #if not self.lheweight157_branch and "lheweight157" not in self.complained:
        if not self.lheweight157_branch and "lheweight157":
            warnings.warn( "ETauTree: Expected branch lheweight157 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight157")
        else:
            self.lheweight157_branch.SetAddress(<void*>&self.lheweight157_value)

        #print "making lheweight158"
        self.lheweight158_branch = the_tree.GetBranch("lheweight158")
        #if not self.lheweight158_branch and "lheweight158" not in self.complained:
        if not self.lheweight158_branch and "lheweight158":
            warnings.warn( "ETauTree: Expected branch lheweight158 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight158")
        else:
            self.lheweight158_branch.SetAddress(<void*>&self.lheweight158_value)

        #print "making lheweight159"
        self.lheweight159_branch = the_tree.GetBranch("lheweight159")
        #if not self.lheweight159_branch and "lheweight159" not in self.complained:
        if not self.lheweight159_branch and "lheweight159":
            warnings.warn( "ETauTree: Expected branch lheweight159 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight159")
        else:
            self.lheweight159_branch.SetAddress(<void*>&self.lheweight159_value)

        #print "making lheweight16"
        self.lheweight16_branch = the_tree.GetBranch("lheweight16")
        #if not self.lheweight16_branch and "lheweight16" not in self.complained:
        if not self.lheweight16_branch and "lheweight16":
            warnings.warn( "ETauTree: Expected branch lheweight16 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight16")
        else:
            self.lheweight16_branch.SetAddress(<void*>&self.lheweight16_value)

        #print "making lheweight160"
        self.lheweight160_branch = the_tree.GetBranch("lheweight160")
        #if not self.lheweight160_branch and "lheweight160" not in self.complained:
        if not self.lheweight160_branch and "lheweight160":
            warnings.warn( "ETauTree: Expected branch lheweight160 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight160")
        else:
            self.lheweight160_branch.SetAddress(<void*>&self.lheweight160_value)

        #print "making lheweight161"
        self.lheweight161_branch = the_tree.GetBranch("lheweight161")
        #if not self.lheweight161_branch and "lheweight161" not in self.complained:
        if not self.lheweight161_branch and "lheweight161":
            warnings.warn( "ETauTree: Expected branch lheweight161 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight161")
        else:
            self.lheweight161_branch.SetAddress(<void*>&self.lheweight161_value)

        #print "making lheweight162"
        self.lheweight162_branch = the_tree.GetBranch("lheweight162")
        #if not self.lheweight162_branch and "lheweight162" not in self.complained:
        if not self.lheweight162_branch and "lheweight162":
            warnings.warn( "ETauTree: Expected branch lheweight162 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight162")
        else:
            self.lheweight162_branch.SetAddress(<void*>&self.lheweight162_value)

        #print "making lheweight163"
        self.lheweight163_branch = the_tree.GetBranch("lheweight163")
        #if not self.lheweight163_branch and "lheweight163" not in self.complained:
        if not self.lheweight163_branch and "lheweight163":
            warnings.warn( "ETauTree: Expected branch lheweight163 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight163")
        else:
            self.lheweight163_branch.SetAddress(<void*>&self.lheweight163_value)

        #print "making lheweight164"
        self.lheweight164_branch = the_tree.GetBranch("lheweight164")
        #if not self.lheweight164_branch and "lheweight164" not in self.complained:
        if not self.lheweight164_branch and "lheweight164":
            warnings.warn( "ETauTree: Expected branch lheweight164 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight164")
        else:
            self.lheweight164_branch.SetAddress(<void*>&self.lheweight164_value)

        #print "making lheweight165"
        self.lheweight165_branch = the_tree.GetBranch("lheweight165")
        #if not self.lheweight165_branch and "lheweight165" not in self.complained:
        if not self.lheweight165_branch and "lheweight165":
            warnings.warn( "ETauTree: Expected branch lheweight165 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight165")
        else:
            self.lheweight165_branch.SetAddress(<void*>&self.lheweight165_value)

        #print "making lheweight166"
        self.lheweight166_branch = the_tree.GetBranch("lheweight166")
        #if not self.lheweight166_branch and "lheweight166" not in self.complained:
        if not self.lheweight166_branch and "lheweight166":
            warnings.warn( "ETauTree: Expected branch lheweight166 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight166")
        else:
            self.lheweight166_branch.SetAddress(<void*>&self.lheweight166_value)

        #print "making lheweight167"
        self.lheweight167_branch = the_tree.GetBranch("lheweight167")
        #if not self.lheweight167_branch and "lheweight167" not in self.complained:
        if not self.lheweight167_branch and "lheweight167":
            warnings.warn( "ETauTree: Expected branch lheweight167 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight167")
        else:
            self.lheweight167_branch.SetAddress(<void*>&self.lheweight167_value)

        #print "making lheweight168"
        self.lheweight168_branch = the_tree.GetBranch("lheweight168")
        #if not self.lheweight168_branch and "lheweight168" not in self.complained:
        if not self.lheweight168_branch and "lheweight168":
            warnings.warn( "ETauTree: Expected branch lheweight168 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight168")
        else:
            self.lheweight168_branch.SetAddress(<void*>&self.lheweight168_value)

        #print "making lheweight169"
        self.lheweight169_branch = the_tree.GetBranch("lheweight169")
        #if not self.lheweight169_branch and "lheweight169" not in self.complained:
        if not self.lheweight169_branch and "lheweight169":
            warnings.warn( "ETauTree: Expected branch lheweight169 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight169")
        else:
            self.lheweight169_branch.SetAddress(<void*>&self.lheweight169_value)

        #print "making lheweight17"
        self.lheweight17_branch = the_tree.GetBranch("lheweight17")
        #if not self.lheweight17_branch and "lheweight17" not in self.complained:
        if not self.lheweight17_branch and "lheweight17":
            warnings.warn( "ETauTree: Expected branch lheweight17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight17")
        else:
            self.lheweight17_branch.SetAddress(<void*>&self.lheweight17_value)

        #print "making lheweight170"
        self.lheweight170_branch = the_tree.GetBranch("lheweight170")
        #if not self.lheweight170_branch and "lheweight170" not in self.complained:
        if not self.lheweight170_branch and "lheweight170":
            warnings.warn( "ETauTree: Expected branch lheweight170 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight170")
        else:
            self.lheweight170_branch.SetAddress(<void*>&self.lheweight170_value)

        #print "making lheweight171"
        self.lheweight171_branch = the_tree.GetBranch("lheweight171")
        #if not self.lheweight171_branch and "lheweight171" not in self.complained:
        if not self.lheweight171_branch and "lheweight171":
            warnings.warn( "ETauTree: Expected branch lheweight171 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight171")
        else:
            self.lheweight171_branch.SetAddress(<void*>&self.lheweight171_value)

        #print "making lheweight172"
        self.lheweight172_branch = the_tree.GetBranch("lheweight172")
        #if not self.lheweight172_branch and "lheweight172" not in self.complained:
        if not self.lheweight172_branch and "lheweight172":
            warnings.warn( "ETauTree: Expected branch lheweight172 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight172")
        else:
            self.lheweight172_branch.SetAddress(<void*>&self.lheweight172_value)

        #print "making lheweight173"
        self.lheweight173_branch = the_tree.GetBranch("lheweight173")
        #if not self.lheweight173_branch and "lheweight173" not in self.complained:
        if not self.lheweight173_branch and "lheweight173":
            warnings.warn( "ETauTree: Expected branch lheweight173 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight173")
        else:
            self.lheweight173_branch.SetAddress(<void*>&self.lheweight173_value)

        #print "making lheweight174"
        self.lheweight174_branch = the_tree.GetBranch("lheweight174")
        #if not self.lheweight174_branch and "lheweight174" not in self.complained:
        if not self.lheweight174_branch and "lheweight174":
            warnings.warn( "ETauTree: Expected branch lheweight174 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight174")
        else:
            self.lheweight174_branch.SetAddress(<void*>&self.lheweight174_value)

        #print "making lheweight175"
        self.lheweight175_branch = the_tree.GetBranch("lheweight175")
        #if not self.lheweight175_branch and "lheweight175" not in self.complained:
        if not self.lheweight175_branch and "lheweight175":
            warnings.warn( "ETauTree: Expected branch lheweight175 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight175")
        else:
            self.lheweight175_branch.SetAddress(<void*>&self.lheweight175_value)

        #print "making lheweight176"
        self.lheweight176_branch = the_tree.GetBranch("lheweight176")
        #if not self.lheweight176_branch and "lheweight176" not in self.complained:
        if not self.lheweight176_branch and "lheweight176":
            warnings.warn( "ETauTree: Expected branch lheweight176 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight176")
        else:
            self.lheweight176_branch.SetAddress(<void*>&self.lheweight176_value)

        #print "making lheweight177"
        self.lheweight177_branch = the_tree.GetBranch("lheweight177")
        #if not self.lheweight177_branch and "lheweight177" not in self.complained:
        if not self.lheweight177_branch and "lheweight177":
            warnings.warn( "ETauTree: Expected branch lheweight177 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight177")
        else:
            self.lheweight177_branch.SetAddress(<void*>&self.lheweight177_value)

        #print "making lheweight178"
        self.lheweight178_branch = the_tree.GetBranch("lheweight178")
        #if not self.lheweight178_branch and "lheweight178" not in self.complained:
        if not self.lheweight178_branch and "lheweight178":
            warnings.warn( "ETauTree: Expected branch lheweight178 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight178")
        else:
            self.lheweight178_branch.SetAddress(<void*>&self.lheweight178_value)

        #print "making lheweight179"
        self.lheweight179_branch = the_tree.GetBranch("lheweight179")
        #if not self.lheweight179_branch and "lheweight179" not in self.complained:
        if not self.lheweight179_branch and "lheweight179":
            warnings.warn( "ETauTree: Expected branch lheweight179 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight179")
        else:
            self.lheweight179_branch.SetAddress(<void*>&self.lheweight179_value)

        #print "making lheweight18"
        self.lheweight18_branch = the_tree.GetBranch("lheweight18")
        #if not self.lheweight18_branch and "lheweight18" not in self.complained:
        if not self.lheweight18_branch and "lheweight18":
            warnings.warn( "ETauTree: Expected branch lheweight18 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight18")
        else:
            self.lheweight18_branch.SetAddress(<void*>&self.lheweight18_value)

        #print "making lheweight180"
        self.lheweight180_branch = the_tree.GetBranch("lheweight180")
        #if not self.lheweight180_branch and "lheweight180" not in self.complained:
        if not self.lheweight180_branch and "lheweight180":
            warnings.warn( "ETauTree: Expected branch lheweight180 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight180")
        else:
            self.lheweight180_branch.SetAddress(<void*>&self.lheweight180_value)

        #print "making lheweight181"
        self.lheweight181_branch = the_tree.GetBranch("lheweight181")
        #if not self.lheweight181_branch and "lheweight181" not in self.complained:
        if not self.lheweight181_branch and "lheweight181":
            warnings.warn( "ETauTree: Expected branch lheweight181 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight181")
        else:
            self.lheweight181_branch.SetAddress(<void*>&self.lheweight181_value)

        #print "making lheweight182"
        self.lheweight182_branch = the_tree.GetBranch("lheweight182")
        #if not self.lheweight182_branch and "lheweight182" not in self.complained:
        if not self.lheweight182_branch and "lheweight182":
            warnings.warn( "ETauTree: Expected branch lheweight182 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight182")
        else:
            self.lheweight182_branch.SetAddress(<void*>&self.lheweight182_value)

        #print "making lheweight183"
        self.lheweight183_branch = the_tree.GetBranch("lheweight183")
        #if not self.lheweight183_branch and "lheweight183" not in self.complained:
        if not self.lheweight183_branch and "lheweight183":
            warnings.warn( "ETauTree: Expected branch lheweight183 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight183")
        else:
            self.lheweight183_branch.SetAddress(<void*>&self.lheweight183_value)

        #print "making lheweight184"
        self.lheweight184_branch = the_tree.GetBranch("lheweight184")
        #if not self.lheweight184_branch and "lheweight184" not in self.complained:
        if not self.lheweight184_branch and "lheweight184":
            warnings.warn( "ETauTree: Expected branch lheweight184 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight184")
        else:
            self.lheweight184_branch.SetAddress(<void*>&self.lheweight184_value)

        #print "making lheweight185"
        self.lheweight185_branch = the_tree.GetBranch("lheweight185")
        #if not self.lheweight185_branch and "lheweight185" not in self.complained:
        if not self.lheweight185_branch and "lheweight185":
            warnings.warn( "ETauTree: Expected branch lheweight185 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight185")
        else:
            self.lheweight185_branch.SetAddress(<void*>&self.lheweight185_value)

        #print "making lheweight186"
        self.lheweight186_branch = the_tree.GetBranch("lheweight186")
        #if not self.lheweight186_branch and "lheweight186" not in self.complained:
        if not self.lheweight186_branch and "lheweight186":
            warnings.warn( "ETauTree: Expected branch lheweight186 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight186")
        else:
            self.lheweight186_branch.SetAddress(<void*>&self.lheweight186_value)

        #print "making lheweight187"
        self.lheweight187_branch = the_tree.GetBranch("lheweight187")
        #if not self.lheweight187_branch and "lheweight187" not in self.complained:
        if not self.lheweight187_branch and "lheweight187":
            warnings.warn( "ETauTree: Expected branch lheweight187 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight187")
        else:
            self.lheweight187_branch.SetAddress(<void*>&self.lheweight187_value)

        #print "making lheweight188"
        self.lheweight188_branch = the_tree.GetBranch("lheweight188")
        #if not self.lheweight188_branch and "lheweight188" not in self.complained:
        if not self.lheweight188_branch and "lheweight188":
            warnings.warn( "ETauTree: Expected branch lheweight188 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight188")
        else:
            self.lheweight188_branch.SetAddress(<void*>&self.lheweight188_value)

        #print "making lheweight189"
        self.lheweight189_branch = the_tree.GetBranch("lheweight189")
        #if not self.lheweight189_branch and "lheweight189" not in self.complained:
        if not self.lheweight189_branch and "lheweight189":
            warnings.warn( "ETauTree: Expected branch lheweight189 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight189")
        else:
            self.lheweight189_branch.SetAddress(<void*>&self.lheweight189_value)

        #print "making lheweight19"
        self.lheweight19_branch = the_tree.GetBranch("lheweight19")
        #if not self.lheweight19_branch and "lheweight19" not in self.complained:
        if not self.lheweight19_branch and "lheweight19":
            warnings.warn( "ETauTree: Expected branch lheweight19 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight19")
        else:
            self.lheweight19_branch.SetAddress(<void*>&self.lheweight19_value)

        #print "making lheweight190"
        self.lheweight190_branch = the_tree.GetBranch("lheweight190")
        #if not self.lheweight190_branch and "lheweight190" not in self.complained:
        if not self.lheweight190_branch and "lheweight190":
            warnings.warn( "ETauTree: Expected branch lheweight190 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight190")
        else:
            self.lheweight190_branch.SetAddress(<void*>&self.lheweight190_value)

        #print "making lheweight191"
        self.lheweight191_branch = the_tree.GetBranch("lheweight191")
        #if not self.lheweight191_branch and "lheweight191" not in self.complained:
        if not self.lheweight191_branch and "lheweight191":
            warnings.warn( "ETauTree: Expected branch lheweight191 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight191")
        else:
            self.lheweight191_branch.SetAddress(<void*>&self.lheweight191_value)

        #print "making lheweight192"
        self.lheweight192_branch = the_tree.GetBranch("lheweight192")
        #if not self.lheweight192_branch and "lheweight192" not in self.complained:
        if not self.lheweight192_branch and "lheweight192":
            warnings.warn( "ETauTree: Expected branch lheweight192 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight192")
        else:
            self.lheweight192_branch.SetAddress(<void*>&self.lheweight192_value)

        #print "making lheweight193"
        self.lheweight193_branch = the_tree.GetBranch("lheweight193")
        #if not self.lheweight193_branch and "lheweight193" not in self.complained:
        if not self.lheweight193_branch and "lheweight193":
            warnings.warn( "ETauTree: Expected branch lheweight193 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight193")
        else:
            self.lheweight193_branch.SetAddress(<void*>&self.lheweight193_value)

        #print "making lheweight194"
        self.lheweight194_branch = the_tree.GetBranch("lheweight194")
        #if not self.lheweight194_branch and "lheweight194" not in self.complained:
        if not self.lheweight194_branch and "lheweight194":
            warnings.warn( "ETauTree: Expected branch lheweight194 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight194")
        else:
            self.lheweight194_branch.SetAddress(<void*>&self.lheweight194_value)

        #print "making lheweight195"
        self.lheweight195_branch = the_tree.GetBranch("lheweight195")
        #if not self.lheweight195_branch and "lheweight195" not in self.complained:
        if not self.lheweight195_branch and "lheweight195":
            warnings.warn( "ETauTree: Expected branch lheweight195 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight195")
        else:
            self.lheweight195_branch.SetAddress(<void*>&self.lheweight195_value)

        #print "making lheweight196"
        self.lheweight196_branch = the_tree.GetBranch("lheweight196")
        #if not self.lheweight196_branch and "lheweight196" not in self.complained:
        if not self.lheweight196_branch and "lheweight196":
            warnings.warn( "ETauTree: Expected branch lheweight196 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight196")
        else:
            self.lheweight196_branch.SetAddress(<void*>&self.lheweight196_value)

        #print "making lheweight197"
        self.lheweight197_branch = the_tree.GetBranch("lheweight197")
        #if not self.lheweight197_branch and "lheweight197" not in self.complained:
        if not self.lheweight197_branch and "lheweight197":
            warnings.warn( "ETauTree: Expected branch lheweight197 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight197")
        else:
            self.lheweight197_branch.SetAddress(<void*>&self.lheweight197_value)

        #print "making lheweight198"
        self.lheweight198_branch = the_tree.GetBranch("lheweight198")
        #if not self.lheweight198_branch and "lheweight198" not in self.complained:
        if not self.lheweight198_branch and "lheweight198":
            warnings.warn( "ETauTree: Expected branch lheweight198 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight198")
        else:
            self.lheweight198_branch.SetAddress(<void*>&self.lheweight198_value)

        #print "making lheweight199"
        self.lheweight199_branch = the_tree.GetBranch("lheweight199")
        #if not self.lheweight199_branch and "lheweight199" not in self.complained:
        if not self.lheweight199_branch and "lheweight199":
            warnings.warn( "ETauTree: Expected branch lheweight199 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight199")
        else:
            self.lheweight199_branch.SetAddress(<void*>&self.lheweight199_value)

        #print "making lheweight2"
        self.lheweight2_branch = the_tree.GetBranch("lheweight2")
        #if not self.lheweight2_branch and "lheweight2" not in self.complained:
        if not self.lheweight2_branch and "lheweight2":
            warnings.warn( "ETauTree: Expected branch lheweight2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight2")
        else:
            self.lheweight2_branch.SetAddress(<void*>&self.lheweight2_value)

        #print "making lheweight20"
        self.lheweight20_branch = the_tree.GetBranch("lheweight20")
        #if not self.lheweight20_branch and "lheweight20" not in self.complained:
        if not self.lheweight20_branch and "lheweight20":
            warnings.warn( "ETauTree: Expected branch lheweight20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight20")
        else:
            self.lheweight20_branch.SetAddress(<void*>&self.lheweight20_value)

        #print "making lheweight200"
        self.lheweight200_branch = the_tree.GetBranch("lheweight200")
        #if not self.lheweight200_branch and "lheweight200" not in self.complained:
        if not self.lheweight200_branch and "lheweight200":
            warnings.warn( "ETauTree: Expected branch lheweight200 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight200")
        else:
            self.lheweight200_branch.SetAddress(<void*>&self.lheweight200_value)

        #print "making lheweight201"
        self.lheweight201_branch = the_tree.GetBranch("lheweight201")
        #if not self.lheweight201_branch and "lheweight201" not in self.complained:
        if not self.lheweight201_branch and "lheweight201":
            warnings.warn( "ETauTree: Expected branch lheweight201 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight201")
        else:
            self.lheweight201_branch.SetAddress(<void*>&self.lheweight201_value)

        #print "making lheweight202"
        self.lheweight202_branch = the_tree.GetBranch("lheweight202")
        #if not self.lheweight202_branch and "lheweight202" not in self.complained:
        if not self.lheweight202_branch and "lheweight202":
            warnings.warn( "ETauTree: Expected branch lheweight202 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight202")
        else:
            self.lheweight202_branch.SetAddress(<void*>&self.lheweight202_value)

        #print "making lheweight203"
        self.lheweight203_branch = the_tree.GetBranch("lheweight203")
        #if not self.lheweight203_branch and "lheweight203" not in self.complained:
        if not self.lheweight203_branch and "lheweight203":
            warnings.warn( "ETauTree: Expected branch lheweight203 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight203")
        else:
            self.lheweight203_branch.SetAddress(<void*>&self.lheweight203_value)

        #print "making lheweight204"
        self.lheweight204_branch = the_tree.GetBranch("lheweight204")
        #if not self.lheweight204_branch and "lheweight204" not in self.complained:
        if not self.lheweight204_branch and "lheweight204":
            warnings.warn( "ETauTree: Expected branch lheweight204 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight204")
        else:
            self.lheweight204_branch.SetAddress(<void*>&self.lheweight204_value)

        #print "making lheweight205"
        self.lheweight205_branch = the_tree.GetBranch("lheweight205")
        #if not self.lheweight205_branch and "lheweight205" not in self.complained:
        if not self.lheweight205_branch and "lheweight205":
            warnings.warn( "ETauTree: Expected branch lheweight205 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight205")
        else:
            self.lheweight205_branch.SetAddress(<void*>&self.lheweight205_value)

        #print "making lheweight206"
        self.lheweight206_branch = the_tree.GetBranch("lheweight206")
        #if not self.lheweight206_branch and "lheweight206" not in self.complained:
        if not self.lheweight206_branch and "lheweight206":
            warnings.warn( "ETauTree: Expected branch lheweight206 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight206")
        else:
            self.lheweight206_branch.SetAddress(<void*>&self.lheweight206_value)

        #print "making lheweight207"
        self.lheweight207_branch = the_tree.GetBranch("lheweight207")
        #if not self.lheweight207_branch and "lheweight207" not in self.complained:
        if not self.lheweight207_branch and "lheweight207":
            warnings.warn( "ETauTree: Expected branch lheweight207 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight207")
        else:
            self.lheweight207_branch.SetAddress(<void*>&self.lheweight207_value)

        #print "making lheweight208"
        self.lheweight208_branch = the_tree.GetBranch("lheweight208")
        #if not self.lheweight208_branch and "lheweight208" not in self.complained:
        if not self.lheweight208_branch and "lheweight208":
            warnings.warn( "ETauTree: Expected branch lheweight208 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight208")
        else:
            self.lheweight208_branch.SetAddress(<void*>&self.lheweight208_value)

        #print "making lheweight209"
        self.lheweight209_branch = the_tree.GetBranch("lheweight209")
        #if not self.lheweight209_branch and "lheweight209" not in self.complained:
        if not self.lheweight209_branch and "lheweight209":
            warnings.warn( "ETauTree: Expected branch lheweight209 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight209")
        else:
            self.lheweight209_branch.SetAddress(<void*>&self.lheweight209_value)

        #print "making lheweight21"
        self.lheweight21_branch = the_tree.GetBranch("lheweight21")
        #if not self.lheweight21_branch and "lheweight21" not in self.complained:
        if not self.lheweight21_branch and "lheweight21":
            warnings.warn( "ETauTree: Expected branch lheweight21 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight21")
        else:
            self.lheweight21_branch.SetAddress(<void*>&self.lheweight21_value)

        #print "making lheweight210"
        self.lheweight210_branch = the_tree.GetBranch("lheweight210")
        #if not self.lheweight210_branch and "lheweight210" not in self.complained:
        if not self.lheweight210_branch and "lheweight210":
            warnings.warn( "ETauTree: Expected branch lheweight210 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight210")
        else:
            self.lheweight210_branch.SetAddress(<void*>&self.lheweight210_value)

        #print "making lheweight211"
        self.lheweight211_branch = the_tree.GetBranch("lheweight211")
        #if not self.lheweight211_branch and "lheweight211" not in self.complained:
        if not self.lheweight211_branch and "lheweight211":
            warnings.warn( "ETauTree: Expected branch lheweight211 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight211")
        else:
            self.lheweight211_branch.SetAddress(<void*>&self.lheweight211_value)

        #print "making lheweight212"
        self.lheweight212_branch = the_tree.GetBranch("lheweight212")
        #if not self.lheweight212_branch and "lheweight212" not in self.complained:
        if not self.lheweight212_branch and "lheweight212":
            warnings.warn( "ETauTree: Expected branch lheweight212 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight212")
        else:
            self.lheweight212_branch.SetAddress(<void*>&self.lheweight212_value)

        #print "making lheweight213"
        self.lheweight213_branch = the_tree.GetBranch("lheweight213")
        #if not self.lheweight213_branch and "lheweight213" not in self.complained:
        if not self.lheweight213_branch and "lheweight213":
            warnings.warn( "ETauTree: Expected branch lheweight213 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight213")
        else:
            self.lheweight213_branch.SetAddress(<void*>&self.lheweight213_value)

        #print "making lheweight214"
        self.lheweight214_branch = the_tree.GetBranch("lheweight214")
        #if not self.lheweight214_branch and "lheweight214" not in self.complained:
        if not self.lheweight214_branch and "lheweight214":
            warnings.warn( "ETauTree: Expected branch lheweight214 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight214")
        else:
            self.lheweight214_branch.SetAddress(<void*>&self.lheweight214_value)

        #print "making lheweight215"
        self.lheweight215_branch = the_tree.GetBranch("lheweight215")
        #if not self.lheweight215_branch and "lheweight215" not in self.complained:
        if not self.lheweight215_branch and "lheweight215":
            warnings.warn( "ETauTree: Expected branch lheweight215 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight215")
        else:
            self.lheweight215_branch.SetAddress(<void*>&self.lheweight215_value)

        #print "making lheweight216"
        self.lheweight216_branch = the_tree.GetBranch("lheweight216")
        #if not self.lheweight216_branch and "lheweight216" not in self.complained:
        if not self.lheweight216_branch and "lheweight216":
            warnings.warn( "ETauTree: Expected branch lheweight216 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight216")
        else:
            self.lheweight216_branch.SetAddress(<void*>&self.lheweight216_value)

        #print "making lheweight217"
        self.lheweight217_branch = the_tree.GetBranch("lheweight217")
        #if not self.lheweight217_branch and "lheweight217" not in self.complained:
        if not self.lheweight217_branch and "lheweight217":
            warnings.warn( "ETauTree: Expected branch lheweight217 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight217")
        else:
            self.lheweight217_branch.SetAddress(<void*>&self.lheweight217_value)

        #print "making lheweight218"
        self.lheweight218_branch = the_tree.GetBranch("lheweight218")
        #if not self.lheweight218_branch and "lheweight218" not in self.complained:
        if not self.lheweight218_branch and "lheweight218":
            warnings.warn( "ETauTree: Expected branch lheweight218 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight218")
        else:
            self.lheweight218_branch.SetAddress(<void*>&self.lheweight218_value)

        #print "making lheweight219"
        self.lheweight219_branch = the_tree.GetBranch("lheweight219")
        #if not self.lheweight219_branch and "lheweight219" not in self.complained:
        if not self.lheweight219_branch and "lheweight219":
            warnings.warn( "ETauTree: Expected branch lheweight219 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight219")
        else:
            self.lheweight219_branch.SetAddress(<void*>&self.lheweight219_value)

        #print "making lheweight22"
        self.lheweight22_branch = the_tree.GetBranch("lheweight22")
        #if not self.lheweight22_branch and "lheweight22" not in self.complained:
        if not self.lheweight22_branch and "lheweight22":
            warnings.warn( "ETauTree: Expected branch lheweight22 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight22")
        else:
            self.lheweight22_branch.SetAddress(<void*>&self.lheweight22_value)

        #print "making lheweight220"
        self.lheweight220_branch = the_tree.GetBranch("lheweight220")
        #if not self.lheweight220_branch and "lheweight220" not in self.complained:
        if not self.lheweight220_branch and "lheweight220":
            warnings.warn( "ETauTree: Expected branch lheweight220 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight220")
        else:
            self.lheweight220_branch.SetAddress(<void*>&self.lheweight220_value)

        #print "making lheweight221"
        self.lheweight221_branch = the_tree.GetBranch("lheweight221")
        #if not self.lheweight221_branch and "lheweight221" not in self.complained:
        if not self.lheweight221_branch and "lheweight221":
            warnings.warn( "ETauTree: Expected branch lheweight221 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight221")
        else:
            self.lheweight221_branch.SetAddress(<void*>&self.lheweight221_value)

        #print "making lheweight23"
        self.lheweight23_branch = the_tree.GetBranch("lheweight23")
        #if not self.lheweight23_branch and "lheweight23" not in self.complained:
        if not self.lheweight23_branch and "lheweight23":
            warnings.warn( "ETauTree: Expected branch lheweight23 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight23")
        else:
            self.lheweight23_branch.SetAddress(<void*>&self.lheweight23_value)

        #print "making lheweight24"
        self.lheweight24_branch = the_tree.GetBranch("lheweight24")
        #if not self.lheweight24_branch and "lheweight24" not in self.complained:
        if not self.lheweight24_branch and "lheweight24":
            warnings.warn( "ETauTree: Expected branch lheweight24 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight24")
        else:
            self.lheweight24_branch.SetAddress(<void*>&self.lheweight24_value)

        #print "making lheweight25"
        self.lheweight25_branch = the_tree.GetBranch("lheweight25")
        #if not self.lheweight25_branch and "lheweight25" not in self.complained:
        if not self.lheweight25_branch and "lheweight25":
            warnings.warn( "ETauTree: Expected branch lheweight25 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight25")
        else:
            self.lheweight25_branch.SetAddress(<void*>&self.lheweight25_value)

        #print "making lheweight26"
        self.lheweight26_branch = the_tree.GetBranch("lheweight26")
        #if not self.lheweight26_branch and "lheweight26" not in self.complained:
        if not self.lheweight26_branch and "lheweight26":
            warnings.warn( "ETauTree: Expected branch lheweight26 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight26")
        else:
            self.lheweight26_branch.SetAddress(<void*>&self.lheweight26_value)

        #print "making lheweight27"
        self.lheweight27_branch = the_tree.GetBranch("lheweight27")
        #if not self.lheweight27_branch and "lheweight27" not in self.complained:
        if not self.lheweight27_branch and "lheweight27":
            warnings.warn( "ETauTree: Expected branch lheweight27 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight27")
        else:
            self.lheweight27_branch.SetAddress(<void*>&self.lheweight27_value)

        #print "making lheweight28"
        self.lheweight28_branch = the_tree.GetBranch("lheweight28")
        #if not self.lheweight28_branch and "lheweight28" not in self.complained:
        if not self.lheweight28_branch and "lheweight28":
            warnings.warn( "ETauTree: Expected branch lheweight28 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight28")
        else:
            self.lheweight28_branch.SetAddress(<void*>&self.lheweight28_value)

        #print "making lheweight29"
        self.lheweight29_branch = the_tree.GetBranch("lheweight29")
        #if not self.lheweight29_branch and "lheweight29" not in self.complained:
        if not self.lheweight29_branch and "lheweight29":
            warnings.warn( "ETauTree: Expected branch lheweight29 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight29")
        else:
            self.lheweight29_branch.SetAddress(<void*>&self.lheweight29_value)

        #print "making lheweight3"
        self.lheweight3_branch = the_tree.GetBranch("lheweight3")
        #if not self.lheweight3_branch and "lheweight3" not in self.complained:
        if not self.lheweight3_branch and "lheweight3":
            warnings.warn( "ETauTree: Expected branch lheweight3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight3")
        else:
            self.lheweight3_branch.SetAddress(<void*>&self.lheweight3_value)

        #print "making lheweight30"
        self.lheweight30_branch = the_tree.GetBranch("lheweight30")
        #if not self.lheweight30_branch and "lheweight30" not in self.complained:
        if not self.lheweight30_branch and "lheweight30":
            warnings.warn( "ETauTree: Expected branch lheweight30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight30")
        else:
            self.lheweight30_branch.SetAddress(<void*>&self.lheweight30_value)

        #print "making lheweight31"
        self.lheweight31_branch = the_tree.GetBranch("lheweight31")
        #if not self.lheweight31_branch and "lheweight31" not in self.complained:
        if not self.lheweight31_branch and "lheweight31":
            warnings.warn( "ETauTree: Expected branch lheweight31 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight31")
        else:
            self.lheweight31_branch.SetAddress(<void*>&self.lheweight31_value)

        #print "making lheweight32"
        self.lheweight32_branch = the_tree.GetBranch("lheweight32")
        #if not self.lheweight32_branch and "lheweight32" not in self.complained:
        if not self.lheweight32_branch and "lheweight32":
            warnings.warn( "ETauTree: Expected branch lheweight32 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight32")
        else:
            self.lheweight32_branch.SetAddress(<void*>&self.lheweight32_value)

        #print "making lheweight33"
        self.lheweight33_branch = the_tree.GetBranch("lheweight33")
        #if not self.lheweight33_branch and "lheweight33" not in self.complained:
        if not self.lheweight33_branch and "lheweight33":
            warnings.warn( "ETauTree: Expected branch lheweight33 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight33")
        else:
            self.lheweight33_branch.SetAddress(<void*>&self.lheweight33_value)

        #print "making lheweight34"
        self.lheweight34_branch = the_tree.GetBranch("lheweight34")
        #if not self.lheweight34_branch and "lheweight34" not in self.complained:
        if not self.lheweight34_branch and "lheweight34":
            warnings.warn( "ETauTree: Expected branch lheweight34 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight34")
        else:
            self.lheweight34_branch.SetAddress(<void*>&self.lheweight34_value)

        #print "making lheweight35"
        self.lheweight35_branch = the_tree.GetBranch("lheweight35")
        #if not self.lheweight35_branch and "lheweight35" not in self.complained:
        if not self.lheweight35_branch and "lheweight35":
            warnings.warn( "ETauTree: Expected branch lheweight35 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight35")
        else:
            self.lheweight35_branch.SetAddress(<void*>&self.lheweight35_value)

        #print "making lheweight36"
        self.lheweight36_branch = the_tree.GetBranch("lheweight36")
        #if not self.lheweight36_branch and "lheweight36" not in self.complained:
        if not self.lheweight36_branch and "lheweight36":
            warnings.warn( "ETauTree: Expected branch lheweight36 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight36")
        else:
            self.lheweight36_branch.SetAddress(<void*>&self.lheweight36_value)

        #print "making lheweight37"
        self.lheweight37_branch = the_tree.GetBranch("lheweight37")
        #if not self.lheweight37_branch and "lheweight37" not in self.complained:
        if not self.lheweight37_branch and "lheweight37":
            warnings.warn( "ETauTree: Expected branch lheweight37 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight37")
        else:
            self.lheweight37_branch.SetAddress(<void*>&self.lheweight37_value)

        #print "making lheweight38"
        self.lheweight38_branch = the_tree.GetBranch("lheweight38")
        #if not self.lheweight38_branch and "lheweight38" not in self.complained:
        if not self.lheweight38_branch and "lheweight38":
            warnings.warn( "ETauTree: Expected branch lheweight38 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight38")
        else:
            self.lheweight38_branch.SetAddress(<void*>&self.lheweight38_value)

        #print "making lheweight39"
        self.lheweight39_branch = the_tree.GetBranch("lheweight39")
        #if not self.lheweight39_branch and "lheweight39" not in self.complained:
        if not self.lheweight39_branch and "lheweight39":
            warnings.warn( "ETauTree: Expected branch lheweight39 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight39")
        else:
            self.lheweight39_branch.SetAddress(<void*>&self.lheweight39_value)

        #print "making lheweight4"
        self.lheweight4_branch = the_tree.GetBranch("lheweight4")
        #if not self.lheweight4_branch and "lheweight4" not in self.complained:
        if not self.lheweight4_branch and "lheweight4":
            warnings.warn( "ETauTree: Expected branch lheweight4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight4")
        else:
            self.lheweight4_branch.SetAddress(<void*>&self.lheweight4_value)

        #print "making lheweight40"
        self.lheweight40_branch = the_tree.GetBranch("lheweight40")
        #if not self.lheweight40_branch and "lheweight40" not in self.complained:
        if not self.lheweight40_branch and "lheweight40":
            warnings.warn( "ETauTree: Expected branch lheweight40 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight40")
        else:
            self.lheweight40_branch.SetAddress(<void*>&self.lheweight40_value)

        #print "making lheweight41"
        self.lheweight41_branch = the_tree.GetBranch("lheweight41")
        #if not self.lheweight41_branch and "lheweight41" not in self.complained:
        if not self.lheweight41_branch and "lheweight41":
            warnings.warn( "ETauTree: Expected branch lheweight41 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight41")
        else:
            self.lheweight41_branch.SetAddress(<void*>&self.lheweight41_value)

        #print "making lheweight42"
        self.lheweight42_branch = the_tree.GetBranch("lheweight42")
        #if not self.lheweight42_branch and "lheweight42" not in self.complained:
        if not self.lheweight42_branch and "lheweight42":
            warnings.warn( "ETauTree: Expected branch lheweight42 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight42")
        else:
            self.lheweight42_branch.SetAddress(<void*>&self.lheweight42_value)

        #print "making lheweight43"
        self.lheweight43_branch = the_tree.GetBranch("lheweight43")
        #if not self.lheweight43_branch and "lheweight43" not in self.complained:
        if not self.lheweight43_branch and "lheweight43":
            warnings.warn( "ETauTree: Expected branch lheweight43 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight43")
        else:
            self.lheweight43_branch.SetAddress(<void*>&self.lheweight43_value)

        #print "making lheweight44"
        self.lheweight44_branch = the_tree.GetBranch("lheweight44")
        #if not self.lheweight44_branch and "lheweight44" not in self.complained:
        if not self.lheweight44_branch and "lheweight44":
            warnings.warn( "ETauTree: Expected branch lheweight44 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight44")
        else:
            self.lheweight44_branch.SetAddress(<void*>&self.lheweight44_value)

        #print "making lheweight45"
        self.lheweight45_branch = the_tree.GetBranch("lheweight45")
        #if not self.lheweight45_branch and "lheweight45" not in self.complained:
        if not self.lheweight45_branch and "lheweight45":
            warnings.warn( "ETauTree: Expected branch lheweight45 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight45")
        else:
            self.lheweight45_branch.SetAddress(<void*>&self.lheweight45_value)

        #print "making lheweight46"
        self.lheweight46_branch = the_tree.GetBranch("lheweight46")
        #if not self.lheweight46_branch and "lheweight46" not in self.complained:
        if not self.lheweight46_branch and "lheweight46":
            warnings.warn( "ETauTree: Expected branch lheweight46 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight46")
        else:
            self.lheweight46_branch.SetAddress(<void*>&self.lheweight46_value)

        #print "making lheweight47"
        self.lheweight47_branch = the_tree.GetBranch("lheweight47")
        #if not self.lheweight47_branch and "lheweight47" not in self.complained:
        if not self.lheweight47_branch and "lheweight47":
            warnings.warn( "ETauTree: Expected branch lheweight47 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight47")
        else:
            self.lheweight47_branch.SetAddress(<void*>&self.lheweight47_value)

        #print "making lheweight48"
        self.lheweight48_branch = the_tree.GetBranch("lheweight48")
        #if not self.lheweight48_branch and "lheweight48" not in self.complained:
        if not self.lheweight48_branch and "lheweight48":
            warnings.warn( "ETauTree: Expected branch lheweight48 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight48")
        else:
            self.lheweight48_branch.SetAddress(<void*>&self.lheweight48_value)

        #print "making lheweight49"
        self.lheweight49_branch = the_tree.GetBranch("lheweight49")
        #if not self.lheweight49_branch and "lheweight49" not in self.complained:
        if not self.lheweight49_branch and "lheweight49":
            warnings.warn( "ETauTree: Expected branch lheweight49 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight49")
        else:
            self.lheweight49_branch.SetAddress(<void*>&self.lheweight49_value)

        #print "making lheweight5"
        self.lheweight5_branch = the_tree.GetBranch("lheweight5")
        #if not self.lheweight5_branch and "lheweight5" not in self.complained:
        if not self.lheweight5_branch and "lheweight5":
            warnings.warn( "ETauTree: Expected branch lheweight5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight5")
        else:
            self.lheweight5_branch.SetAddress(<void*>&self.lheweight5_value)

        #print "making lheweight50"
        self.lheweight50_branch = the_tree.GetBranch("lheweight50")
        #if not self.lheweight50_branch and "lheweight50" not in self.complained:
        if not self.lheweight50_branch and "lheweight50":
            warnings.warn( "ETauTree: Expected branch lheweight50 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight50")
        else:
            self.lheweight50_branch.SetAddress(<void*>&self.lheweight50_value)

        #print "making lheweight51"
        self.lheweight51_branch = the_tree.GetBranch("lheweight51")
        #if not self.lheweight51_branch and "lheweight51" not in self.complained:
        if not self.lheweight51_branch and "lheweight51":
            warnings.warn( "ETauTree: Expected branch lheweight51 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight51")
        else:
            self.lheweight51_branch.SetAddress(<void*>&self.lheweight51_value)

        #print "making lheweight52"
        self.lheweight52_branch = the_tree.GetBranch("lheweight52")
        #if not self.lheweight52_branch and "lheweight52" not in self.complained:
        if not self.lheweight52_branch and "lheweight52":
            warnings.warn( "ETauTree: Expected branch lheweight52 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight52")
        else:
            self.lheweight52_branch.SetAddress(<void*>&self.lheweight52_value)

        #print "making lheweight53"
        self.lheweight53_branch = the_tree.GetBranch("lheweight53")
        #if not self.lheweight53_branch and "lheweight53" not in self.complained:
        if not self.lheweight53_branch and "lheweight53":
            warnings.warn( "ETauTree: Expected branch lheweight53 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight53")
        else:
            self.lheweight53_branch.SetAddress(<void*>&self.lheweight53_value)

        #print "making lheweight54"
        self.lheweight54_branch = the_tree.GetBranch("lheweight54")
        #if not self.lheweight54_branch and "lheweight54" not in self.complained:
        if not self.lheweight54_branch and "lheweight54":
            warnings.warn( "ETauTree: Expected branch lheweight54 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight54")
        else:
            self.lheweight54_branch.SetAddress(<void*>&self.lheweight54_value)

        #print "making lheweight55"
        self.lheweight55_branch = the_tree.GetBranch("lheweight55")
        #if not self.lheweight55_branch and "lheweight55" not in self.complained:
        if not self.lheweight55_branch and "lheweight55":
            warnings.warn( "ETauTree: Expected branch lheweight55 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight55")
        else:
            self.lheweight55_branch.SetAddress(<void*>&self.lheweight55_value)

        #print "making lheweight56"
        self.lheweight56_branch = the_tree.GetBranch("lheweight56")
        #if not self.lheweight56_branch and "lheweight56" not in self.complained:
        if not self.lheweight56_branch and "lheweight56":
            warnings.warn( "ETauTree: Expected branch lheweight56 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight56")
        else:
            self.lheweight56_branch.SetAddress(<void*>&self.lheweight56_value)

        #print "making lheweight57"
        self.lheweight57_branch = the_tree.GetBranch("lheweight57")
        #if not self.lheweight57_branch and "lheweight57" not in self.complained:
        if not self.lheweight57_branch and "lheweight57":
            warnings.warn( "ETauTree: Expected branch lheweight57 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight57")
        else:
            self.lheweight57_branch.SetAddress(<void*>&self.lheweight57_value)

        #print "making lheweight58"
        self.lheweight58_branch = the_tree.GetBranch("lheweight58")
        #if not self.lheweight58_branch and "lheweight58" not in self.complained:
        if not self.lheweight58_branch and "lheweight58":
            warnings.warn( "ETauTree: Expected branch lheweight58 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight58")
        else:
            self.lheweight58_branch.SetAddress(<void*>&self.lheweight58_value)

        #print "making lheweight59"
        self.lheweight59_branch = the_tree.GetBranch("lheweight59")
        #if not self.lheweight59_branch and "lheweight59" not in self.complained:
        if not self.lheweight59_branch and "lheweight59":
            warnings.warn( "ETauTree: Expected branch lheweight59 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight59")
        else:
            self.lheweight59_branch.SetAddress(<void*>&self.lheweight59_value)

        #print "making lheweight6"
        self.lheweight6_branch = the_tree.GetBranch("lheweight6")
        #if not self.lheweight6_branch and "lheweight6" not in self.complained:
        if not self.lheweight6_branch and "lheweight6":
            warnings.warn( "ETauTree: Expected branch lheweight6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight6")
        else:
            self.lheweight6_branch.SetAddress(<void*>&self.lheweight6_value)

        #print "making lheweight60"
        self.lheweight60_branch = the_tree.GetBranch("lheweight60")
        #if not self.lheweight60_branch and "lheweight60" not in self.complained:
        if not self.lheweight60_branch and "lheweight60":
            warnings.warn( "ETauTree: Expected branch lheweight60 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight60")
        else:
            self.lheweight60_branch.SetAddress(<void*>&self.lheweight60_value)

        #print "making lheweight61"
        self.lheweight61_branch = the_tree.GetBranch("lheweight61")
        #if not self.lheweight61_branch and "lheweight61" not in self.complained:
        if not self.lheweight61_branch and "lheweight61":
            warnings.warn( "ETauTree: Expected branch lheweight61 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight61")
        else:
            self.lheweight61_branch.SetAddress(<void*>&self.lheweight61_value)

        #print "making lheweight62"
        self.lheweight62_branch = the_tree.GetBranch("lheweight62")
        #if not self.lheweight62_branch and "lheweight62" not in self.complained:
        if not self.lheweight62_branch and "lheweight62":
            warnings.warn( "ETauTree: Expected branch lheweight62 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight62")
        else:
            self.lheweight62_branch.SetAddress(<void*>&self.lheweight62_value)

        #print "making lheweight63"
        self.lheweight63_branch = the_tree.GetBranch("lheweight63")
        #if not self.lheweight63_branch and "lheweight63" not in self.complained:
        if not self.lheweight63_branch and "lheweight63":
            warnings.warn( "ETauTree: Expected branch lheweight63 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight63")
        else:
            self.lheweight63_branch.SetAddress(<void*>&self.lheweight63_value)

        #print "making lheweight64"
        self.lheweight64_branch = the_tree.GetBranch("lheweight64")
        #if not self.lheweight64_branch and "lheweight64" not in self.complained:
        if not self.lheweight64_branch and "lheweight64":
            warnings.warn( "ETauTree: Expected branch lheweight64 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight64")
        else:
            self.lheweight64_branch.SetAddress(<void*>&self.lheweight64_value)

        #print "making lheweight65"
        self.lheweight65_branch = the_tree.GetBranch("lheweight65")
        #if not self.lheweight65_branch and "lheweight65" not in self.complained:
        if not self.lheweight65_branch and "lheweight65":
            warnings.warn( "ETauTree: Expected branch lheweight65 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight65")
        else:
            self.lheweight65_branch.SetAddress(<void*>&self.lheweight65_value)

        #print "making lheweight66"
        self.lheweight66_branch = the_tree.GetBranch("lheweight66")
        #if not self.lheweight66_branch and "lheweight66" not in self.complained:
        if not self.lheweight66_branch and "lheweight66":
            warnings.warn( "ETauTree: Expected branch lheweight66 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight66")
        else:
            self.lheweight66_branch.SetAddress(<void*>&self.lheweight66_value)

        #print "making lheweight67"
        self.lheweight67_branch = the_tree.GetBranch("lheweight67")
        #if not self.lheweight67_branch and "lheweight67" not in self.complained:
        if not self.lheweight67_branch and "lheweight67":
            warnings.warn( "ETauTree: Expected branch lheweight67 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight67")
        else:
            self.lheweight67_branch.SetAddress(<void*>&self.lheweight67_value)

        #print "making lheweight68"
        self.lheweight68_branch = the_tree.GetBranch("lheweight68")
        #if not self.lheweight68_branch and "lheweight68" not in self.complained:
        if not self.lheweight68_branch and "lheweight68":
            warnings.warn( "ETauTree: Expected branch lheweight68 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight68")
        else:
            self.lheweight68_branch.SetAddress(<void*>&self.lheweight68_value)

        #print "making lheweight69"
        self.lheweight69_branch = the_tree.GetBranch("lheweight69")
        #if not self.lheweight69_branch and "lheweight69" not in self.complained:
        if not self.lheweight69_branch and "lheweight69":
            warnings.warn( "ETauTree: Expected branch lheweight69 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight69")
        else:
            self.lheweight69_branch.SetAddress(<void*>&self.lheweight69_value)

        #print "making lheweight7"
        self.lheweight7_branch = the_tree.GetBranch("lheweight7")
        #if not self.lheweight7_branch and "lheweight7" not in self.complained:
        if not self.lheweight7_branch and "lheweight7":
            warnings.warn( "ETauTree: Expected branch lheweight7 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight7")
        else:
            self.lheweight7_branch.SetAddress(<void*>&self.lheweight7_value)

        #print "making lheweight70"
        self.lheweight70_branch = the_tree.GetBranch("lheweight70")
        #if not self.lheweight70_branch and "lheweight70" not in self.complained:
        if not self.lheweight70_branch and "lheweight70":
            warnings.warn( "ETauTree: Expected branch lheweight70 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight70")
        else:
            self.lheweight70_branch.SetAddress(<void*>&self.lheweight70_value)

        #print "making lheweight71"
        self.lheweight71_branch = the_tree.GetBranch("lheweight71")
        #if not self.lheweight71_branch and "lheweight71" not in self.complained:
        if not self.lheweight71_branch and "lheweight71":
            warnings.warn( "ETauTree: Expected branch lheweight71 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight71")
        else:
            self.lheweight71_branch.SetAddress(<void*>&self.lheweight71_value)

        #print "making lheweight72"
        self.lheweight72_branch = the_tree.GetBranch("lheweight72")
        #if not self.lheweight72_branch and "lheweight72" not in self.complained:
        if not self.lheweight72_branch and "lheweight72":
            warnings.warn( "ETauTree: Expected branch lheweight72 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight72")
        else:
            self.lheweight72_branch.SetAddress(<void*>&self.lheweight72_value)

        #print "making lheweight73"
        self.lheweight73_branch = the_tree.GetBranch("lheweight73")
        #if not self.lheweight73_branch and "lheweight73" not in self.complained:
        if not self.lheweight73_branch and "lheweight73":
            warnings.warn( "ETauTree: Expected branch lheweight73 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight73")
        else:
            self.lheweight73_branch.SetAddress(<void*>&self.lheweight73_value)

        #print "making lheweight74"
        self.lheweight74_branch = the_tree.GetBranch("lheweight74")
        #if not self.lheweight74_branch and "lheweight74" not in self.complained:
        if not self.lheweight74_branch and "lheweight74":
            warnings.warn( "ETauTree: Expected branch lheweight74 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight74")
        else:
            self.lheweight74_branch.SetAddress(<void*>&self.lheweight74_value)

        #print "making lheweight75"
        self.lheweight75_branch = the_tree.GetBranch("lheweight75")
        #if not self.lheweight75_branch and "lheweight75" not in self.complained:
        if not self.lheweight75_branch and "lheweight75":
            warnings.warn( "ETauTree: Expected branch lheweight75 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight75")
        else:
            self.lheweight75_branch.SetAddress(<void*>&self.lheweight75_value)

        #print "making lheweight76"
        self.lheweight76_branch = the_tree.GetBranch("lheweight76")
        #if not self.lheweight76_branch and "lheweight76" not in self.complained:
        if not self.lheweight76_branch and "lheweight76":
            warnings.warn( "ETauTree: Expected branch lheweight76 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight76")
        else:
            self.lheweight76_branch.SetAddress(<void*>&self.lheweight76_value)

        #print "making lheweight77"
        self.lheweight77_branch = the_tree.GetBranch("lheweight77")
        #if not self.lheweight77_branch and "lheweight77" not in self.complained:
        if not self.lheweight77_branch and "lheweight77":
            warnings.warn( "ETauTree: Expected branch lheweight77 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight77")
        else:
            self.lheweight77_branch.SetAddress(<void*>&self.lheweight77_value)

        #print "making lheweight78"
        self.lheweight78_branch = the_tree.GetBranch("lheweight78")
        #if not self.lheweight78_branch and "lheweight78" not in self.complained:
        if not self.lheweight78_branch and "lheweight78":
            warnings.warn( "ETauTree: Expected branch lheweight78 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight78")
        else:
            self.lheweight78_branch.SetAddress(<void*>&self.lheweight78_value)

        #print "making lheweight79"
        self.lheweight79_branch = the_tree.GetBranch("lheweight79")
        #if not self.lheweight79_branch and "lheweight79" not in self.complained:
        if not self.lheweight79_branch and "lheweight79":
            warnings.warn( "ETauTree: Expected branch lheweight79 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight79")
        else:
            self.lheweight79_branch.SetAddress(<void*>&self.lheweight79_value)

        #print "making lheweight8"
        self.lheweight8_branch = the_tree.GetBranch("lheweight8")
        #if not self.lheweight8_branch and "lheweight8" not in self.complained:
        if not self.lheweight8_branch and "lheweight8":
            warnings.warn( "ETauTree: Expected branch lheweight8 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight8")
        else:
            self.lheweight8_branch.SetAddress(<void*>&self.lheweight8_value)

        #print "making lheweight80"
        self.lheweight80_branch = the_tree.GetBranch("lheweight80")
        #if not self.lheweight80_branch and "lheweight80" not in self.complained:
        if not self.lheweight80_branch and "lheweight80":
            warnings.warn( "ETauTree: Expected branch lheweight80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight80")
        else:
            self.lheweight80_branch.SetAddress(<void*>&self.lheweight80_value)

        #print "making lheweight81"
        self.lheweight81_branch = the_tree.GetBranch("lheweight81")
        #if not self.lheweight81_branch and "lheweight81" not in self.complained:
        if not self.lheweight81_branch and "lheweight81":
            warnings.warn( "ETauTree: Expected branch lheweight81 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight81")
        else:
            self.lheweight81_branch.SetAddress(<void*>&self.lheweight81_value)

        #print "making lheweight82"
        self.lheweight82_branch = the_tree.GetBranch("lheweight82")
        #if not self.lheweight82_branch and "lheweight82" not in self.complained:
        if not self.lheweight82_branch and "lheweight82":
            warnings.warn( "ETauTree: Expected branch lheweight82 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight82")
        else:
            self.lheweight82_branch.SetAddress(<void*>&self.lheweight82_value)

        #print "making lheweight83"
        self.lheweight83_branch = the_tree.GetBranch("lheweight83")
        #if not self.lheweight83_branch and "lheweight83" not in self.complained:
        if not self.lheweight83_branch and "lheweight83":
            warnings.warn( "ETauTree: Expected branch lheweight83 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight83")
        else:
            self.lheweight83_branch.SetAddress(<void*>&self.lheweight83_value)

        #print "making lheweight84"
        self.lheweight84_branch = the_tree.GetBranch("lheweight84")
        #if not self.lheweight84_branch and "lheweight84" not in self.complained:
        if not self.lheweight84_branch and "lheweight84":
            warnings.warn( "ETauTree: Expected branch lheweight84 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight84")
        else:
            self.lheweight84_branch.SetAddress(<void*>&self.lheweight84_value)

        #print "making lheweight85"
        self.lheweight85_branch = the_tree.GetBranch("lheweight85")
        #if not self.lheweight85_branch and "lheweight85" not in self.complained:
        if not self.lheweight85_branch and "lheweight85":
            warnings.warn( "ETauTree: Expected branch lheweight85 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight85")
        else:
            self.lheweight85_branch.SetAddress(<void*>&self.lheweight85_value)

        #print "making lheweight86"
        self.lheweight86_branch = the_tree.GetBranch("lheweight86")
        #if not self.lheweight86_branch and "lheweight86" not in self.complained:
        if not self.lheweight86_branch and "lheweight86":
            warnings.warn( "ETauTree: Expected branch lheweight86 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight86")
        else:
            self.lheweight86_branch.SetAddress(<void*>&self.lheweight86_value)

        #print "making lheweight87"
        self.lheweight87_branch = the_tree.GetBranch("lheweight87")
        #if not self.lheweight87_branch and "lheweight87" not in self.complained:
        if not self.lheweight87_branch and "lheweight87":
            warnings.warn( "ETauTree: Expected branch lheweight87 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight87")
        else:
            self.lheweight87_branch.SetAddress(<void*>&self.lheweight87_value)

        #print "making lheweight88"
        self.lheweight88_branch = the_tree.GetBranch("lheweight88")
        #if not self.lheweight88_branch and "lheweight88" not in self.complained:
        if not self.lheweight88_branch and "lheweight88":
            warnings.warn( "ETauTree: Expected branch lheweight88 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight88")
        else:
            self.lheweight88_branch.SetAddress(<void*>&self.lheweight88_value)

        #print "making lheweight89"
        self.lheweight89_branch = the_tree.GetBranch("lheweight89")
        #if not self.lheweight89_branch and "lheweight89" not in self.complained:
        if not self.lheweight89_branch and "lheweight89":
            warnings.warn( "ETauTree: Expected branch lheweight89 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight89")
        else:
            self.lheweight89_branch.SetAddress(<void*>&self.lheweight89_value)

        #print "making lheweight9"
        self.lheweight9_branch = the_tree.GetBranch("lheweight9")
        #if not self.lheweight9_branch and "lheweight9" not in self.complained:
        if not self.lheweight9_branch and "lheweight9":
            warnings.warn( "ETauTree: Expected branch lheweight9 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight9")
        else:
            self.lheweight9_branch.SetAddress(<void*>&self.lheweight9_value)

        #print "making lheweight90"
        self.lheweight90_branch = the_tree.GetBranch("lheweight90")
        #if not self.lheweight90_branch and "lheweight90" not in self.complained:
        if not self.lheweight90_branch and "lheweight90":
            warnings.warn( "ETauTree: Expected branch lheweight90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight90")
        else:
            self.lheweight90_branch.SetAddress(<void*>&self.lheweight90_value)

        #print "making lheweight91"
        self.lheweight91_branch = the_tree.GetBranch("lheweight91")
        #if not self.lheweight91_branch and "lheweight91" not in self.complained:
        if not self.lheweight91_branch and "lheweight91":
            warnings.warn( "ETauTree: Expected branch lheweight91 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight91")
        else:
            self.lheweight91_branch.SetAddress(<void*>&self.lheweight91_value)

        #print "making lheweight92"
        self.lheweight92_branch = the_tree.GetBranch("lheweight92")
        #if not self.lheweight92_branch and "lheweight92" not in self.complained:
        if not self.lheweight92_branch and "lheweight92":
            warnings.warn( "ETauTree: Expected branch lheweight92 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight92")
        else:
            self.lheweight92_branch.SetAddress(<void*>&self.lheweight92_value)

        #print "making lheweight93"
        self.lheweight93_branch = the_tree.GetBranch("lheweight93")
        #if not self.lheweight93_branch and "lheweight93" not in self.complained:
        if not self.lheweight93_branch and "lheweight93":
            warnings.warn( "ETauTree: Expected branch lheweight93 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight93")
        else:
            self.lheweight93_branch.SetAddress(<void*>&self.lheweight93_value)

        #print "making lheweight94"
        self.lheweight94_branch = the_tree.GetBranch("lheweight94")
        #if not self.lheweight94_branch and "lheweight94" not in self.complained:
        if not self.lheweight94_branch and "lheweight94":
            warnings.warn( "ETauTree: Expected branch lheweight94 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight94")
        else:
            self.lheweight94_branch.SetAddress(<void*>&self.lheweight94_value)

        #print "making lheweight95"
        self.lheweight95_branch = the_tree.GetBranch("lheweight95")
        #if not self.lheweight95_branch and "lheweight95" not in self.complained:
        if not self.lheweight95_branch and "lheweight95":
            warnings.warn( "ETauTree: Expected branch lheweight95 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight95")
        else:
            self.lheweight95_branch.SetAddress(<void*>&self.lheweight95_value)

        #print "making lheweight96"
        self.lheweight96_branch = the_tree.GetBranch("lheweight96")
        #if not self.lheweight96_branch and "lheweight96" not in self.complained:
        if not self.lheweight96_branch and "lheweight96":
            warnings.warn( "ETauTree: Expected branch lheweight96 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight96")
        else:
            self.lheweight96_branch.SetAddress(<void*>&self.lheweight96_value)

        #print "making lheweight97"
        self.lheweight97_branch = the_tree.GetBranch("lheweight97")
        #if not self.lheweight97_branch and "lheweight97" not in self.complained:
        if not self.lheweight97_branch and "lheweight97":
            warnings.warn( "ETauTree: Expected branch lheweight97 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight97")
        else:
            self.lheweight97_branch.SetAddress(<void*>&self.lheweight97_value)

        #print "making lheweight98"
        self.lheweight98_branch = the_tree.GetBranch("lheweight98")
        #if not self.lheweight98_branch and "lheweight98" not in self.complained:
        if not self.lheweight98_branch and "lheweight98":
            warnings.warn( "ETauTree: Expected branch lheweight98 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight98")
        else:
            self.lheweight98_branch.SetAddress(<void*>&self.lheweight98_value)

        #print "making lheweight99"
        self.lheweight99_branch = the_tree.GetBranch("lheweight99")
        #if not self.lheweight99_branch and "lheweight99" not in self.complained:
        if not self.lheweight99_branch and "lheweight99":
            warnings.warn( "ETauTree: Expected branch lheweight99 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight99")
        else:
            self.lheweight99_branch.SetAddress(<void*>&self.lheweight99_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "ETauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making mu12e23DZPass"
        self.mu12e23DZPass_branch = the_tree.GetBranch("mu12e23DZPass")
        #if not self.mu12e23DZPass_branch and "mu12e23DZPass" not in self.complained:
        if not self.mu12e23DZPass_branch and "mu12e23DZPass":
            warnings.warn( "ETauTree: Expected branch mu12e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23DZPass")
        else:
            self.mu12e23DZPass_branch.SetAddress(<void*>&self.mu12e23DZPass_value)

        #print "making mu12e23Pass"
        self.mu12e23Pass_branch = the_tree.GetBranch("mu12e23Pass")
        #if not self.mu12e23Pass_branch and "mu12e23Pass" not in self.complained:
        if not self.mu12e23Pass_branch and "mu12e23Pass":
            warnings.warn( "ETauTree: Expected branch mu12e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23Pass")
        else:
            self.mu12e23Pass_branch.SetAddress(<void*>&self.mu12e23Pass_value)

        #print "making mu23e12DZPass"
        self.mu23e12DZPass_branch = the_tree.GetBranch("mu23e12DZPass")
        #if not self.mu23e12DZPass_branch and "mu23e12DZPass" not in self.complained:
        if not self.mu23e12DZPass_branch and "mu23e12DZPass":
            warnings.warn( "ETauTree: Expected branch mu23e12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12DZPass")
        else:
            self.mu23e12DZPass_branch.SetAddress(<void*>&self.mu23e12DZPass_value)

        #print "making mu23e12Pass"
        self.mu23e12Pass_branch = the_tree.GetBranch("mu23e12Pass")
        #if not self.mu23e12Pass_branch and "mu23e12Pass" not in self.complained:
        if not self.mu23e12Pass_branch and "mu23e12Pass":
            warnings.warn( "ETauTree: Expected branch mu23e12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12Pass")
        else:
            self.mu23e12Pass_branch.SetAddress(<void*>&self.mu23e12Pass_value)

        #print "making mu8diele12DZPass"
        self.mu8diele12DZPass_branch = the_tree.GetBranch("mu8diele12DZPass")
        #if not self.mu8diele12DZPass_branch and "mu8diele12DZPass" not in self.complained:
        if not self.mu8diele12DZPass_branch and "mu8diele12DZPass":
            warnings.warn( "ETauTree: Expected branch mu8diele12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12DZPass")
        else:
            self.mu8diele12DZPass_branch.SetAddress(<void*>&self.mu8diele12DZPass_value)

        #print "making mu8diele12Pass"
        self.mu8diele12Pass_branch = the_tree.GetBranch("mu8diele12Pass")
        #if not self.mu8diele12Pass_branch and "mu8diele12Pass" not in self.complained:
        if not self.mu8diele12Pass_branch and "mu8diele12Pass":
            warnings.warn( "ETauTree: Expected branch mu8diele12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12Pass")
        else:
            self.mu8diele12Pass_branch.SetAddress(<void*>&self.mu8diele12Pass_value)

        #print "making mu8e23DZPass"
        self.mu8e23DZPass_branch = the_tree.GetBranch("mu8e23DZPass")
        #if not self.mu8e23DZPass_branch and "mu8e23DZPass" not in self.complained:
        if not self.mu8e23DZPass_branch and "mu8e23DZPass":
            warnings.warn( "ETauTree: Expected branch mu8e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23DZPass")
        else:
            self.mu8e23DZPass_branch.SetAddress(<void*>&self.mu8e23DZPass_value)

        #print "making mu8e23Pass"
        self.mu8e23Pass_branch = the_tree.GetBranch("mu8e23Pass")
        #if not self.mu8e23Pass_branch and "mu8e23Pass" not in self.complained:
        if not self.mu8e23Pass_branch and "mu8e23Pass":
            warnings.warn( "ETauTree: Expected branch mu8e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23Pass")
        else:
            self.mu8e23Pass_branch.SetAddress(<void*>&self.mu8e23Pass_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "ETauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muVeto5"
        self.muVeto5_branch = the_tree.GetBranch("muVeto5")
        #if not self.muVeto5_branch and "muVeto5" not in self.complained:
        if not self.muVeto5_branch and "muVeto5":
            warnings.warn( "ETauTree: Expected branch muVeto5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVeto5")
        else:
            self.muVeto5_branch.SetAddress(<void*>&self.muVeto5_value)

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "ETauTree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making muVetoZTTp001dxyzR0"
        self.muVetoZTTp001dxyzR0_branch = the_tree.GetBranch("muVetoZTTp001dxyzR0")
        #if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0" not in self.complained:
        if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0":
            warnings.warn( "ETauTree: Expected branch muVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyzR0")
        else:
            self.muVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.muVetoZTTp001dxyzR0_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "ETauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "ETauTree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "ETauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making prefiring_weight"
        self.prefiring_weight_branch = the_tree.GetBranch("prefiring_weight")
        #if not self.prefiring_weight_branch and "prefiring_weight" not in self.complained:
        if not self.prefiring_weight_branch and "prefiring_weight":
            warnings.warn( "ETauTree: Expected branch prefiring_weight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight")
        else:
            self.prefiring_weight_branch.SetAddress(<void*>&self.prefiring_weight_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "ETauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "ETauTree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "ETauTree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "ETauTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "ETauTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "ETauTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "ETauTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "ETauTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "ETauTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "ETauTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "ETauTree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "ETauTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "ETauTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "ETauTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "ETauTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "ETauTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "ETauTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "ETauTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "ETauTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleE25eta2p1TightPass"
        self.singleE25eta2p1TightPass_branch = the_tree.GetBranch("singleE25eta2p1TightPass")
        #if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass" not in self.complained:
        if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass":
            warnings.warn( "ETauTree: Expected branch singleE25eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPass")
        else:
            self.singleE25eta2p1TightPass_branch.SetAddress(<void*>&self.singleE25eta2p1TightPass_value)

        #print "making singleIsoMu22Pass"
        self.singleIsoMu22Pass_branch = the_tree.GetBranch("singleIsoMu22Pass")
        #if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass" not in self.complained:
        if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass":
            warnings.warn( "ETauTree: Expected branch singleIsoMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Pass")
        else:
            self.singleIsoMu22Pass_branch.SetAddress(<void*>&self.singleIsoMu22Pass_value)

        #print "making singleIsoMu22eta2p1Pass"
        self.singleIsoMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu22eta2p1Pass")
        #if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass":
            warnings.warn( "ETauTree: Expected branch singleIsoMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Pass")
        else:
            self.singleIsoMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Pass_value)

        #print "making singleIsoTkMu22Pass"
        self.singleIsoTkMu22Pass_branch = the_tree.GetBranch("singleIsoTkMu22Pass")
        #if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass" not in self.complained:
        if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass":
            warnings.warn( "ETauTree: Expected branch singleIsoTkMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Pass")
        else:
            self.singleIsoTkMu22Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22Pass_value)

        #print "making singleIsoTkMu22eta2p1Pass"
        self.singleIsoTkMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Pass")
        #if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass":
            warnings.warn( "ETauTree: Expected branch singleIsoTkMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Pass")
        else:
            self.singleIsoTkMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Pass_value)

        #print "making singleMu19eta2p1LooseTau20Pass"
        self.singleMu19eta2p1LooseTau20Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Pass")
        #if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass":
            warnings.warn( "ETauTree: Expected branch singleMu19eta2p1LooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Pass")
        else:
            self.singleMu19eta2p1LooseTau20Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Pass_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Pass"
        self.singleMu19eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass":
            warnings.warn( "ETauTree: Expected branch singleMu19eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Pass_value)

        #print "making tAgainstElectronLooseMVA6"
        self.tAgainstElectronLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronLooseMVA6")
        #if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6" not in self.complained:
        if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronLooseMVA6")
        else:
            self.tAgainstElectronLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronLooseMVA6_value)

        #print "making tAgainstElectronMVA6Raw"
        self.tAgainstElectronMVA6Raw_branch = the_tree.GetBranch("tAgainstElectronMVA6Raw")
        #if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw" not in self.complained:
        if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronMVA6Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6Raw")
        else:
            self.tAgainstElectronMVA6Raw_branch.SetAddress(<void*>&self.tAgainstElectronMVA6Raw_value)

        #print "making tAgainstElectronMVA6category"
        self.tAgainstElectronMVA6category_branch = the_tree.GetBranch("tAgainstElectronMVA6category")
        #if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category" not in self.complained:
        if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronMVA6category does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6category")
        else:
            self.tAgainstElectronMVA6category_branch.SetAddress(<void*>&self.tAgainstElectronMVA6category_value)

        #print "making tAgainstElectronMediumMVA6"
        self.tAgainstElectronMediumMVA6_branch = the_tree.GetBranch("tAgainstElectronMediumMVA6")
        #if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6" not in self.complained:
        if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronMediumMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMediumMVA6")
        else:
            self.tAgainstElectronMediumMVA6_branch.SetAddress(<void*>&self.tAgainstElectronMediumMVA6_value)

        #print "making tAgainstElectronTightMVA6"
        self.tAgainstElectronTightMVA6_branch = the_tree.GetBranch("tAgainstElectronTightMVA6")
        #if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6" not in self.complained:
        if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronTightMVA6")
        else:
            self.tAgainstElectronTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronTightMVA6_value)

        #print "making tAgainstElectronTightMVA62018"
        self.tAgainstElectronTightMVA62018_branch = the_tree.GetBranch("tAgainstElectronTightMVA62018")
        #if not self.tAgainstElectronTightMVA62018_branch and "tAgainstElectronTightMVA62018" not in self.complained:
        if not self.tAgainstElectronTightMVA62018_branch and "tAgainstElectronTightMVA62018":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronTightMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronTightMVA62018")
        else:
            self.tAgainstElectronTightMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronTightMVA62018_value)

        #print "making tAgainstElectronVLooseMVA6"
        self.tAgainstElectronVLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronVLooseMVA6")
        #if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6" not in self.complained:
        if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronVLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVLooseMVA6")
        else:
            self.tAgainstElectronVLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVLooseMVA6_value)

        #print "making tAgainstElectronVLooseMVA62018"
        self.tAgainstElectronVLooseMVA62018_branch = the_tree.GetBranch("tAgainstElectronVLooseMVA62018")
        #if not self.tAgainstElectronVLooseMVA62018_branch and "tAgainstElectronVLooseMVA62018" not in self.complained:
        if not self.tAgainstElectronVLooseMVA62018_branch and "tAgainstElectronVLooseMVA62018":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronVLooseMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVLooseMVA62018")
        else:
            self.tAgainstElectronVLooseMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronVLooseMVA62018_value)

        #print "making tAgainstElectronVTightMVA6"
        self.tAgainstElectronVTightMVA6_branch = the_tree.GetBranch("tAgainstElectronVTightMVA6")
        #if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6" not in self.complained:
        if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronVTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVTightMVA6")
        else:
            self.tAgainstElectronVTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVTightMVA6_value)

        #print "making tAgainstMuonLoose3"
        self.tAgainstMuonLoose3_branch = the_tree.GetBranch("tAgainstMuonLoose3")
        #if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3" not in self.complained:
        if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3":
            warnings.warn( "ETauTree: Expected branch tAgainstMuonLoose3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonLoose3")
        else:
            self.tAgainstMuonLoose3_branch.SetAddress(<void*>&self.tAgainstMuonLoose3_value)

        #print "making tAgainstMuonTight3"
        self.tAgainstMuonTight3_branch = the_tree.GetBranch("tAgainstMuonTight3")
        #if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3" not in self.complained:
        if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3":
            warnings.warn( "ETauTree: Expected branch tAgainstMuonTight3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonTight3")
        else:
            self.tAgainstMuonTight3_branch.SetAddress(<void*>&self.tAgainstMuonTight3_value)

        #print "making tByCombinedIsolationDeltaBetaCorrRaw3Hits"
        self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch = the_tree.GetBranch("tByCombinedIsolationDeltaBetaCorrRaw3Hits")
        #if not self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch and "tByCombinedIsolationDeltaBetaCorrRaw3Hits" not in self.complained:
        if not self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch and "tByCombinedIsolationDeltaBetaCorrRaw3Hits":
            warnings.warn( "ETauTree: Expected branch tByCombinedIsolationDeltaBetaCorrRaw3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByCombinedIsolationDeltaBetaCorrRaw3Hits")
        else:
            self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch.SetAddress(<void*>&self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_value)

        #print "making tByIsolationMVArun2v1DBdR03oldDMwLTraw"
        self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw":
            warnings.warn( "ETauTree: Expected branch tByIsolationMVArun2v1DBdR03oldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_value)

        #print "making tByIsolationMVArun2v1DBnewDMwLTraw"
        self.tByIsolationMVArun2v1DBnewDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBnewDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBnewDMwLTraw_branch and "tByIsolationMVArun2v1DBnewDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBnewDMwLTraw_branch and "tByIsolationMVArun2v1DBnewDMwLTraw":
            warnings.warn( "ETauTree: Expected branch tByIsolationMVArun2v1DBnewDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBnewDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBnewDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBnewDMwLTraw_value)

        #print "making tByIsolationMVArun2v1DBoldDMwLTraw"
        self.tByIsolationMVArun2v1DBoldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBoldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw":
            warnings.warn( "ETauTree: Expected branch tByIsolationMVArun2v1DBoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBoldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBoldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBoldDMwLTraw_value)

        #print "making tByLooseCombinedIsolationDeltaBetaCorr3Hits"
        self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByLooseCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch and "tByLooseCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch and "tByLooseCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "ETauTree: Expected branch tByLooseCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1DBnewDMwLT"
        self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByLooseIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByLooseIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "ETauTree: Expected branch tByLooseIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByMediumCombinedIsolationDeltaBetaCorr3Hits"
        self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByMediumCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch and "tByMediumCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch and "tByMediumCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "ETauTree: Expected branch tByMediumCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByMediumIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByMediumIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBnewDMwLT"
        self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch and "tByMediumIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch and "tByMediumIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "ETauTree: Expected branch tByMediumIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBoldDMwLT"
        self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByMediumIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByPhotonPtSumOutsideSignalCone"
        self.tByPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tByPhotonPtSumOutsideSignalCone")
        #if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone":
            warnings.warn( "ETauTree: Expected branch tByPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByPhotonPtSumOutsideSignalCone")
        else:
            self.tByPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tByPhotonPtSumOutsideSignalCone_value)

        #print "making tByTightCombinedIsolationDeltaBetaCorr3Hits"
        self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByTightCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch and "tByTightCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch and "tByTightCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "ETauTree: Expected branch tByTightCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByTightCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByTightIsolationMVArun2v1DBnewDMwLT"
        self.tByTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBnewDMwLT_branch and "tByTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBnewDMwLT_branch and "tByTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "ETauTree: Expected branch tByTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByTightIsolationMVArun2v1DBoldDMwLT"
        self.tByTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBnewDMwLT"
        self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByVLooseIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByVLooseIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVLooseIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBnewDMwLT"
        self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBnewDMwLT"
        self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVVTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVVTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVVTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tCharge"
        self.tCharge_branch = the_tree.GetBranch("tCharge")
        #if not self.tCharge_branch and "tCharge" not in self.complained:
        if not self.tCharge_branch and "tCharge":
            warnings.warn( "ETauTree: Expected branch tCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCharge")
        else:
            self.tCharge_branch.SetAddress(<void*>&self.tCharge_value)

        #print "making tChargedIsoPtSum"
        self.tChargedIsoPtSum_branch = the_tree.GetBranch("tChargedIsoPtSum")
        #if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum" not in self.complained:
        if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum":
            warnings.warn( "ETauTree: Expected branch tChargedIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSum")
        else:
            self.tChargedIsoPtSum_branch.SetAddress(<void*>&self.tChargedIsoPtSum_value)

        #print "making tChargedIsoPtSumdR03"
        self.tChargedIsoPtSumdR03_branch = the_tree.GetBranch("tChargedIsoPtSumdR03")
        #if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03" not in self.complained:
        if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03":
            warnings.warn( "ETauTree: Expected branch tChargedIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSumdR03")
        else:
            self.tChargedIsoPtSumdR03_branch.SetAddress(<void*>&self.tChargedIsoPtSumdR03_value)

        #print "making tComesFromHiggs"
        self.tComesFromHiggs_branch = the_tree.GetBranch("tComesFromHiggs")
        #if not self.tComesFromHiggs_branch and "tComesFromHiggs" not in self.complained:
        if not self.tComesFromHiggs_branch and "tComesFromHiggs":
            warnings.warn( "ETauTree: Expected branch tComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tComesFromHiggs")
        else:
            self.tComesFromHiggs_branch.SetAddress(<void*>&self.tComesFromHiggs_value)

        #print "making tDecayMode"
        self.tDecayMode_branch = the_tree.GetBranch("tDecayMode")
        #if not self.tDecayMode_branch and "tDecayMode" not in self.complained:
        if not self.tDecayMode_branch and "tDecayMode":
            warnings.warn( "ETauTree: Expected branch tDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayMode")
        else:
            self.tDecayMode_branch.SetAddress(<void*>&self.tDecayMode_value)

        #print "making tDecayModeFinding"
        self.tDecayModeFinding_branch = the_tree.GetBranch("tDecayModeFinding")
        #if not self.tDecayModeFinding_branch and "tDecayModeFinding" not in self.complained:
        if not self.tDecayModeFinding_branch and "tDecayModeFinding":
            warnings.warn( "ETauTree: Expected branch tDecayModeFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFinding")
        else:
            self.tDecayModeFinding_branch.SetAddress(<void*>&self.tDecayModeFinding_value)

        #print "making tDecayModeFindingNewDMs"
        self.tDecayModeFindingNewDMs_branch = the_tree.GetBranch("tDecayModeFindingNewDMs")
        #if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs" not in self.complained:
        if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs":
            warnings.warn( "ETauTree: Expected branch tDecayModeFindingNewDMs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFindingNewDMs")
        else:
            self.tDecayModeFindingNewDMs_branch.SetAddress(<void*>&self.tDecayModeFindingNewDMs_value)

        #print "making tEta"
        self.tEta_branch = the_tree.GetBranch("tEta")
        #if not self.tEta_branch and "tEta" not in self.complained:
        if not self.tEta_branch and "tEta":
            warnings.warn( "ETauTree: Expected branch tEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta")
        else:
            self.tEta_branch.SetAddress(<void*>&self.tEta_value)

        #print "making tFootprintCorrection"
        self.tFootprintCorrection_branch = the_tree.GetBranch("tFootprintCorrection")
        #if not self.tFootprintCorrection_branch and "tFootprintCorrection" not in self.complained:
        if not self.tFootprintCorrection_branch and "tFootprintCorrection":
            warnings.warn( "ETauTree: Expected branch tFootprintCorrection does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrection")
        else:
            self.tFootprintCorrection_branch.SetAddress(<void*>&self.tFootprintCorrection_value)

        #print "making tFootprintCorrectiondR03"
        self.tFootprintCorrectiondR03_branch = the_tree.GetBranch("tFootprintCorrectiondR03")
        #if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03" not in self.complained:
        if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03":
            warnings.warn( "ETauTree: Expected branch tFootprintCorrectiondR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrectiondR03")
        else:
            self.tFootprintCorrectiondR03_branch.SetAddress(<void*>&self.tFootprintCorrectiondR03_value)

        #print "making tGenCharge"
        self.tGenCharge_branch = the_tree.GetBranch("tGenCharge")
        #if not self.tGenCharge_branch and "tGenCharge" not in self.complained:
        if not self.tGenCharge_branch and "tGenCharge":
            warnings.warn( "ETauTree: Expected branch tGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenCharge")
        else:
            self.tGenCharge_branch.SetAddress(<void*>&self.tGenCharge_value)

        #print "making tGenDecayMode"
        self.tGenDecayMode_branch = the_tree.GetBranch("tGenDecayMode")
        #if not self.tGenDecayMode_branch and "tGenDecayMode" not in self.complained:
        if not self.tGenDecayMode_branch and "tGenDecayMode":
            warnings.warn( "ETauTree: Expected branch tGenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenDecayMode")
        else:
            self.tGenDecayMode_branch.SetAddress(<void*>&self.tGenDecayMode_value)

        #print "making tGenEnergy"
        self.tGenEnergy_branch = the_tree.GetBranch("tGenEnergy")
        #if not self.tGenEnergy_branch and "tGenEnergy" not in self.complained:
        if not self.tGenEnergy_branch and "tGenEnergy":
            warnings.warn( "ETauTree: Expected branch tGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEnergy")
        else:
            self.tGenEnergy_branch.SetAddress(<void*>&self.tGenEnergy_value)

        #print "making tGenEta"
        self.tGenEta_branch = the_tree.GetBranch("tGenEta")
        #if not self.tGenEta_branch and "tGenEta" not in self.complained:
        if not self.tGenEta_branch and "tGenEta":
            warnings.warn( "ETauTree: Expected branch tGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEta")
        else:
            self.tGenEta_branch.SetAddress(<void*>&self.tGenEta_value)

        #print "making tGenJetEta"
        self.tGenJetEta_branch = the_tree.GetBranch("tGenJetEta")
        #if not self.tGenJetEta_branch and "tGenJetEta" not in self.complained:
        if not self.tGenJetEta_branch and "tGenJetEta":
            warnings.warn( "ETauTree: Expected branch tGenJetEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetEta")
        else:
            self.tGenJetEta_branch.SetAddress(<void*>&self.tGenJetEta_value)

        #print "making tGenJetPt"
        self.tGenJetPt_branch = the_tree.GetBranch("tGenJetPt")
        #if not self.tGenJetPt_branch and "tGenJetPt" not in self.complained:
        if not self.tGenJetPt_branch and "tGenJetPt":
            warnings.warn( "ETauTree: Expected branch tGenJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetPt")
        else:
            self.tGenJetPt_branch.SetAddress(<void*>&self.tGenJetPt_value)

        #print "making tGenMotherEnergy"
        self.tGenMotherEnergy_branch = the_tree.GetBranch("tGenMotherEnergy")
        #if not self.tGenMotherEnergy_branch and "tGenMotherEnergy" not in self.complained:
        if not self.tGenMotherEnergy_branch and "tGenMotherEnergy":
            warnings.warn( "ETauTree: Expected branch tGenMotherEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEnergy")
        else:
            self.tGenMotherEnergy_branch.SetAddress(<void*>&self.tGenMotherEnergy_value)

        #print "making tGenMotherEta"
        self.tGenMotherEta_branch = the_tree.GetBranch("tGenMotherEta")
        #if not self.tGenMotherEta_branch and "tGenMotherEta" not in self.complained:
        if not self.tGenMotherEta_branch and "tGenMotherEta":
            warnings.warn( "ETauTree: Expected branch tGenMotherEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEta")
        else:
            self.tGenMotherEta_branch.SetAddress(<void*>&self.tGenMotherEta_value)

        #print "making tGenMotherPdgId"
        self.tGenMotherPdgId_branch = the_tree.GetBranch("tGenMotherPdgId")
        #if not self.tGenMotherPdgId_branch and "tGenMotherPdgId" not in self.complained:
        if not self.tGenMotherPdgId_branch and "tGenMotherPdgId":
            warnings.warn( "ETauTree: Expected branch tGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPdgId")
        else:
            self.tGenMotherPdgId_branch.SetAddress(<void*>&self.tGenMotherPdgId_value)

        #print "making tGenMotherPhi"
        self.tGenMotherPhi_branch = the_tree.GetBranch("tGenMotherPhi")
        #if not self.tGenMotherPhi_branch and "tGenMotherPhi" not in self.complained:
        if not self.tGenMotherPhi_branch and "tGenMotherPhi":
            warnings.warn( "ETauTree: Expected branch tGenMotherPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPhi")
        else:
            self.tGenMotherPhi_branch.SetAddress(<void*>&self.tGenMotherPhi_value)

        #print "making tGenMotherPt"
        self.tGenMotherPt_branch = the_tree.GetBranch("tGenMotherPt")
        #if not self.tGenMotherPt_branch and "tGenMotherPt" not in self.complained:
        if not self.tGenMotherPt_branch and "tGenMotherPt":
            warnings.warn( "ETauTree: Expected branch tGenMotherPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPt")
        else:
            self.tGenMotherPt_branch.SetAddress(<void*>&self.tGenMotherPt_value)

        #print "making tGenPdgId"
        self.tGenPdgId_branch = the_tree.GetBranch("tGenPdgId")
        #if not self.tGenPdgId_branch and "tGenPdgId" not in self.complained:
        if not self.tGenPdgId_branch and "tGenPdgId":
            warnings.warn( "ETauTree: Expected branch tGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPdgId")
        else:
            self.tGenPdgId_branch.SetAddress(<void*>&self.tGenPdgId_value)

        #print "making tGenPhi"
        self.tGenPhi_branch = the_tree.GetBranch("tGenPhi")
        #if not self.tGenPhi_branch and "tGenPhi" not in self.complained:
        if not self.tGenPhi_branch and "tGenPhi":
            warnings.warn( "ETauTree: Expected branch tGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPhi")
        else:
            self.tGenPhi_branch.SetAddress(<void*>&self.tGenPhi_value)

        #print "making tGenPt"
        self.tGenPt_branch = the_tree.GetBranch("tGenPt")
        #if not self.tGenPt_branch and "tGenPt" not in self.complained:
        if not self.tGenPt_branch and "tGenPt":
            warnings.warn( "ETauTree: Expected branch tGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPt")
        else:
            self.tGenPt_branch.SetAddress(<void*>&self.tGenPt_value)

        #print "making tGenStatus"
        self.tGenStatus_branch = the_tree.GetBranch("tGenStatus")
        #if not self.tGenStatus_branch and "tGenStatus" not in self.complained:
        if not self.tGenStatus_branch and "tGenStatus":
            warnings.warn( "ETauTree: Expected branch tGenStatus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenStatus")
        else:
            self.tGenStatus_branch.SetAddress(<void*>&self.tGenStatus_value)

        #print "making tJetArea"
        self.tJetArea_branch = the_tree.GetBranch("tJetArea")
        #if not self.tJetArea_branch and "tJetArea" not in self.complained:
        if not self.tJetArea_branch and "tJetArea":
            warnings.warn( "ETauTree: Expected branch tJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetArea")
        else:
            self.tJetArea_branch.SetAddress(<void*>&self.tJetArea_value)

        #print "making tJetBtag"
        self.tJetBtag_branch = the_tree.GetBranch("tJetBtag")
        #if not self.tJetBtag_branch and "tJetBtag" not in self.complained:
        if not self.tJetBtag_branch and "tJetBtag":
            warnings.warn( "ETauTree: Expected branch tJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetBtag")
        else:
            self.tJetBtag_branch.SetAddress(<void*>&self.tJetBtag_value)

        #print "making tJetDR"
        self.tJetDR_branch = the_tree.GetBranch("tJetDR")
        #if not self.tJetDR_branch and "tJetDR" not in self.complained:
        if not self.tJetDR_branch and "tJetDR":
            warnings.warn( "ETauTree: Expected branch tJetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetDR")
        else:
            self.tJetDR_branch.SetAddress(<void*>&self.tJetDR_value)

        #print "making tJetEtaEtaMoment"
        self.tJetEtaEtaMoment_branch = the_tree.GetBranch("tJetEtaEtaMoment")
        #if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment" not in self.complained:
        if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment":
            warnings.warn( "ETauTree: Expected branch tJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaEtaMoment")
        else:
            self.tJetEtaEtaMoment_branch.SetAddress(<void*>&self.tJetEtaEtaMoment_value)

        #print "making tJetEtaPhiMoment"
        self.tJetEtaPhiMoment_branch = the_tree.GetBranch("tJetEtaPhiMoment")
        #if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment" not in self.complained:
        if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment":
            warnings.warn( "ETauTree: Expected branch tJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiMoment")
        else:
            self.tJetEtaPhiMoment_branch.SetAddress(<void*>&self.tJetEtaPhiMoment_value)

        #print "making tJetEtaPhiSpread"
        self.tJetEtaPhiSpread_branch = the_tree.GetBranch("tJetEtaPhiSpread")
        #if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread" not in self.complained:
        if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread":
            warnings.warn( "ETauTree: Expected branch tJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiSpread")
        else:
            self.tJetEtaPhiSpread_branch.SetAddress(<void*>&self.tJetEtaPhiSpread_value)

        #print "making tJetHadronFlavour"
        self.tJetHadronFlavour_branch = the_tree.GetBranch("tJetHadronFlavour")
        #if not self.tJetHadronFlavour_branch and "tJetHadronFlavour" not in self.complained:
        if not self.tJetHadronFlavour_branch and "tJetHadronFlavour":
            warnings.warn( "ETauTree: Expected branch tJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetHadronFlavour")
        else:
            self.tJetHadronFlavour_branch.SetAddress(<void*>&self.tJetHadronFlavour_value)

        #print "making tJetPFCISVBtag"
        self.tJetPFCISVBtag_branch = the_tree.GetBranch("tJetPFCISVBtag")
        #if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag" not in self.complained:
        if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag":
            warnings.warn( "ETauTree: Expected branch tJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPFCISVBtag")
        else:
            self.tJetPFCISVBtag_branch.SetAddress(<void*>&self.tJetPFCISVBtag_value)

        #print "making tJetPartonFlavour"
        self.tJetPartonFlavour_branch = the_tree.GetBranch("tJetPartonFlavour")
        #if not self.tJetPartonFlavour_branch and "tJetPartonFlavour" not in self.complained:
        if not self.tJetPartonFlavour_branch and "tJetPartonFlavour":
            warnings.warn( "ETauTree: Expected branch tJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPartonFlavour")
        else:
            self.tJetPartonFlavour_branch.SetAddress(<void*>&self.tJetPartonFlavour_value)

        #print "making tJetPhiPhiMoment"
        self.tJetPhiPhiMoment_branch = the_tree.GetBranch("tJetPhiPhiMoment")
        #if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment" not in self.complained:
        if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment":
            warnings.warn( "ETauTree: Expected branch tJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPhiPhiMoment")
        else:
            self.tJetPhiPhiMoment_branch.SetAddress(<void*>&self.tJetPhiPhiMoment_value)

        #print "making tJetPt"
        self.tJetPt_branch = the_tree.GetBranch("tJetPt")
        #if not self.tJetPt_branch and "tJetPt" not in self.complained:
        if not self.tJetPt_branch and "tJetPt":
            warnings.warn( "ETauTree: Expected branch tJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPt")
        else:
            self.tJetPt_branch.SetAddress(<void*>&self.tJetPt_value)

        #print "making tLeadTrackPt"
        self.tLeadTrackPt_branch = the_tree.GetBranch("tLeadTrackPt")
        #if not self.tLeadTrackPt_branch and "tLeadTrackPt" not in self.complained:
        if not self.tLeadTrackPt_branch and "tLeadTrackPt":
            warnings.warn( "ETauTree: Expected branch tLeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLeadTrackPt")
        else:
            self.tLeadTrackPt_branch.SetAddress(<void*>&self.tLeadTrackPt_value)

        #print "making tLowestMll"
        self.tLowestMll_branch = the_tree.GetBranch("tLowestMll")
        #if not self.tLowestMll_branch and "tLowestMll" not in self.complained:
        if not self.tLowestMll_branch and "tLowestMll":
            warnings.warn( "ETauTree: Expected branch tLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLowestMll")
        else:
            self.tLowestMll_branch.SetAddress(<void*>&self.tLowestMll_value)

        #print "making tMass"
        self.tMass_branch = the_tree.GetBranch("tMass")
        #if not self.tMass_branch and "tMass" not in self.complained:
        if not self.tMass_branch and "tMass":
            warnings.warn( "ETauTree: Expected branch tMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass")
        else:
            self.tMass_branch.SetAddress(<void*>&self.tMass_value)

        #print "making tMatchesEle24Tau30Filter"
        self.tMatchesEle24Tau30Filter_branch = the_tree.GetBranch("tMatchesEle24Tau30Filter")
        #if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter" not in self.complained:
        if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Filter")
        else:
            self.tMatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Filter_value)

        #print "making tMatchesEle24Tau30Path"
        self.tMatchesEle24Tau30Path_branch = the_tree.GetBranch("tMatchesEle24Tau30Path")
        #if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path" not in self.complained:
        if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path":
            warnings.warn( "ETauTree: Expected branch tMatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Path")
        else:
            self.tMatchesEle24Tau30Path_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Path_value)

        #print "making tNChrgHadrIsolationCands"
        self.tNChrgHadrIsolationCands_branch = the_tree.GetBranch("tNChrgHadrIsolationCands")
        #if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands" not in self.complained:
        if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands":
            warnings.warn( "ETauTree: Expected branch tNChrgHadrIsolationCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrIsolationCands")
        else:
            self.tNChrgHadrIsolationCands_branch.SetAddress(<void*>&self.tNChrgHadrIsolationCands_value)

        #print "making tNChrgHadrSignalCands"
        self.tNChrgHadrSignalCands_branch = the_tree.GetBranch("tNChrgHadrSignalCands")
        #if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands" not in self.complained:
        if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands":
            warnings.warn( "ETauTree: Expected branch tNChrgHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrSignalCands")
        else:
            self.tNChrgHadrSignalCands_branch.SetAddress(<void*>&self.tNChrgHadrSignalCands_value)

        #print "making tNGammaSignalCands"
        self.tNGammaSignalCands_branch = the_tree.GetBranch("tNGammaSignalCands")
        #if not self.tNGammaSignalCands_branch and "tNGammaSignalCands" not in self.complained:
        if not self.tNGammaSignalCands_branch and "tNGammaSignalCands":
            warnings.warn( "ETauTree: Expected branch tNGammaSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNGammaSignalCands")
        else:
            self.tNGammaSignalCands_branch.SetAddress(<void*>&self.tNGammaSignalCands_value)

        #print "making tNNeutralHadrSignalCands"
        self.tNNeutralHadrSignalCands_branch = the_tree.GetBranch("tNNeutralHadrSignalCands")
        #if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands" not in self.complained:
        if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands":
            warnings.warn( "ETauTree: Expected branch tNNeutralHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNNeutralHadrSignalCands")
        else:
            self.tNNeutralHadrSignalCands_branch.SetAddress(<void*>&self.tNNeutralHadrSignalCands_value)

        #print "making tNSignalCands"
        self.tNSignalCands_branch = the_tree.GetBranch("tNSignalCands")
        #if not self.tNSignalCands_branch and "tNSignalCands" not in self.complained:
        if not self.tNSignalCands_branch and "tNSignalCands":
            warnings.warn( "ETauTree: Expected branch tNSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNSignalCands")
        else:
            self.tNSignalCands_branch.SetAddress(<void*>&self.tNSignalCands_value)

        #print "making tNearestZMass"
        self.tNearestZMass_branch = the_tree.GetBranch("tNearestZMass")
        #if not self.tNearestZMass_branch and "tNearestZMass" not in self.complained:
        if not self.tNearestZMass_branch and "tNearestZMass":
            warnings.warn( "ETauTree: Expected branch tNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNearestZMass")
        else:
            self.tNearestZMass_branch.SetAddress(<void*>&self.tNearestZMass_value)

        #print "making tNeutralIsoPtSum"
        self.tNeutralIsoPtSum_branch = the_tree.GetBranch("tNeutralIsoPtSum")
        #if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum" not in self.complained:
        if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum":
            warnings.warn( "ETauTree: Expected branch tNeutralIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSum")
        else:
            self.tNeutralIsoPtSum_branch.SetAddress(<void*>&self.tNeutralIsoPtSum_value)

        #print "making tNeutralIsoPtSumWeight"
        self.tNeutralIsoPtSumWeight_branch = the_tree.GetBranch("tNeutralIsoPtSumWeight")
        #if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight" not in self.complained:
        if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight":
            warnings.warn( "ETauTree: Expected branch tNeutralIsoPtSumWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeight")
        else:
            self.tNeutralIsoPtSumWeight_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeight_value)

        #print "making tNeutralIsoPtSumWeightdR03"
        self.tNeutralIsoPtSumWeightdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumWeightdR03")
        #if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03" not in self.complained:
        if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03":
            warnings.warn( "ETauTree: Expected branch tNeutralIsoPtSumWeightdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeightdR03")
        else:
            self.tNeutralIsoPtSumWeightdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeightdR03_value)

        #print "making tNeutralIsoPtSumdR03"
        self.tNeutralIsoPtSumdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumdR03")
        #if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03" not in self.complained:
        if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03":
            warnings.warn( "ETauTree: Expected branch tNeutralIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumdR03")
        else:
            self.tNeutralIsoPtSumdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumdR03_value)

        #print "making tPVDXY"
        self.tPVDXY_branch = the_tree.GetBranch("tPVDXY")
        #if not self.tPVDXY_branch and "tPVDXY" not in self.complained:
        if not self.tPVDXY_branch and "tPVDXY":
            warnings.warn( "ETauTree: Expected branch tPVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDXY")
        else:
            self.tPVDXY_branch.SetAddress(<void*>&self.tPVDXY_value)

        #print "making tPVDZ"
        self.tPVDZ_branch = the_tree.GetBranch("tPVDZ")
        #if not self.tPVDZ_branch and "tPVDZ" not in self.complained:
        if not self.tPVDZ_branch and "tPVDZ":
            warnings.warn( "ETauTree: Expected branch tPVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDZ")
        else:
            self.tPVDZ_branch.SetAddress(<void*>&self.tPVDZ_value)

        #print "making tPhi"
        self.tPhi_branch = the_tree.GetBranch("tPhi")
        #if not self.tPhi_branch and "tPhi" not in self.complained:
        if not self.tPhi_branch and "tPhi":
            warnings.warn( "ETauTree: Expected branch tPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi")
        else:
            self.tPhi_branch.SetAddress(<void*>&self.tPhi_value)

        #print "making tPhotonPtSumOutsideSignalCone"
        self.tPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalCone")
        #if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone":
            warnings.warn( "ETauTree: Expected branch tPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalCone")
        else:
            self.tPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalCone_value)

        #print "making tPhotonPtSumOutsideSignalConedR03"
        self.tPhotonPtSumOutsideSignalConedR03_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalConedR03")
        #if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03":
            warnings.warn( "ETauTree: Expected branch tPhotonPtSumOutsideSignalConedR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalConedR03")
        else:
            self.tPhotonPtSumOutsideSignalConedR03_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalConedR03_value)

        #print "making tPt"
        self.tPt_branch = the_tree.GetBranch("tPt")
        #if not self.tPt_branch and "tPt" not in self.complained:
        if not self.tPt_branch and "tPt":
            warnings.warn( "ETauTree: Expected branch tPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt")
        else:
            self.tPt_branch.SetAddress(<void*>&self.tPt_value)

        #print "making tPuCorrPtSum"
        self.tPuCorrPtSum_branch = the_tree.GetBranch("tPuCorrPtSum")
        #if not self.tPuCorrPtSum_branch and "tPuCorrPtSum" not in self.complained:
        if not self.tPuCorrPtSum_branch and "tPuCorrPtSum":
            warnings.warn( "ETauTree: Expected branch tPuCorrPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPuCorrPtSum")
        else:
            self.tPuCorrPtSum_branch.SetAddress(<void*>&self.tPuCorrPtSum_value)

        #print "making tRerunMVArun2v2DBoldDMwLTLoose"
        self.tRerunMVArun2v2DBoldDMwLTLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTLoose_branch and "tRerunMVArun2v2DBoldDMwLTLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTLoose_branch and "tRerunMVArun2v2DBoldDMwLTLoose":
            warnings.warn( "ETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTLoose_value)

        #print "making tRerunMVArun2v2DBoldDMwLTTight"
        self.tRerunMVArun2v2DBoldDMwLTTight_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTTight")
        #if not self.tRerunMVArun2v2DBoldDMwLTTight_branch and "tRerunMVArun2v2DBoldDMwLTTight" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTTight_branch and "tRerunMVArun2v2DBoldDMwLTTight":
            warnings.warn( "ETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTTight")
        else:
            self.tRerunMVArun2v2DBoldDMwLTTight_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTTight_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVLoose"
        self.tRerunMVArun2v2DBoldDMwLTVLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVLoose":
            warnings.warn( "ETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVLoose_value)

        #print "making tVZ"
        self.tVZ_branch = the_tree.GetBranch("tVZ")
        #if not self.tVZ_branch and "tVZ" not in self.complained:
        if not self.tVZ_branch and "tVZ":
            warnings.warn( "ETauTree: Expected branch tVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVZ")
        else:
            self.tVZ_branch.SetAddress(<void*>&self.tVZ_value)

        #print "making tZTTGenMatching"
        self.tZTTGenMatching_branch = the_tree.GetBranch("tZTTGenMatching")
        #if not self.tZTTGenMatching_branch and "tZTTGenMatching" not in self.complained:
        if not self.tZTTGenMatching_branch and "tZTTGenMatching":
            warnings.warn( "ETauTree: Expected branch tZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenMatching")
        else:
            self.tZTTGenMatching_branch.SetAddress(<void*>&self.tZTTGenMatching_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20LooseMVALTVtx"
        self.tauVetoPt20LooseMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVALTVtx")
        #if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20LooseMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVALTVtx")
        else:
            self.tauVetoPt20LooseMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVALTVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "ETauTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleMu10_5_5Pass"
        self.tripleMu10_5_5Pass_branch = the_tree.GetBranch("tripleMu10_5_5Pass")
        #if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass" not in self.complained:
        if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass":
            warnings.warn( "ETauTree: Expected branch tripleMu10_5_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu10_5_5Pass")
        else:
            self.tripleMu10_5_5Pass_branch.SetAddress(<void*>&self.tripleMu10_5_5Pass_value)

        #print "making tripleMu12_10_5Pass"
        self.tripleMu12_10_5Pass_branch = the_tree.GetBranch("tripleMu12_10_5Pass")
        #if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass" not in self.complained:
        if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass":
            warnings.warn( "ETauTree: Expected branch tripleMu12_10_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu12_10_5Pass")
        else:
            self.tripleMu12_10_5Pass_branch.SetAddress(<void*>&self.tripleMu12_10_5Pass_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "ETauTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "ETauTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "ETauTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "ETauTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "ETauTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "ETauTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMassWoNoisyJets"
        self.vbfMassWoNoisyJets_branch = the_tree.GetBranch("vbfMassWoNoisyJets")
        #if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets" not in self.complained:
        if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets")
        else:
            self.vbfMassWoNoisyJets_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "ETauTree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "ETauTree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "ETauTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "ETauTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "ETauTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "ETauTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "ETauTree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "ETauTree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "ETauTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("idx")
        else:
            self.idx_branch.SetAddress(<void*>&self.idx_value)


    # Iterating over the tree
    def __iter__(self):
        self.ientry = 0
        while self.ientry < self.tree.GetEntries():
            self.load_entry(self.ientry)
            yield self
            self.ientry += 1

    # Iterate over rows which pass the filter
    def where(self, filter):
        print "where"
        cdef TTreeFormula* formula = new TTreeFormula(
            "cyiter", filter, self.tree)
        self.ientry = 0
        cdef TTree* currentTree = self.tree.GetTree()
        while self.ientry < self.tree.GetEntries():
            self.tree.LoadTree(self.ientry)
            if currentTree != self.tree.GetTree():
                currentTree = self.tree.GetTree()
                formula.SetTree(currentTree)
                formula.UpdateFormulaLeaves()
            if formula.EvalInstance(0, NULL):
                yield self
            self.ientry += 1
        del formula

    # Getting/setting the Tree entry number
    property entry:
        def __get__(self):
            return self.ientry
        def __set__(self, int i):
            print i
            self.ientry = i
            self.load_entry(i)

    # Access to the current branch values

    property DoubleMediumHPSTau35Pass:
        def __get__(self):
            self.DoubleMediumHPSTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumHPSTau35Pass_value

    property DoubleMediumHPSTau35TightIDPass:
        def __get__(self):
            self.DoubleMediumHPSTau35TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumHPSTau35TightIDPass_value

    property DoubleMediumHPSTau40Pass:
        def __get__(self):
            self.DoubleMediumHPSTau40Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumHPSTau40Pass_value

    property DoubleMediumHPSTau40TightIDPass:
        def __get__(self):
            self.DoubleMediumHPSTau40TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumHPSTau40TightIDPass_value

    property DoubleMediumTau35Pass:
        def __get__(self):
            self.DoubleMediumTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau35Pass_value

    property DoubleMediumTau35TightIDPass:
        def __get__(self):
            self.DoubleMediumTau35TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau35TightIDPass_value

    property DoubleMediumTau40Pass:
        def __get__(self):
            self.DoubleMediumTau40Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau40Pass_value

    property DoubleMediumTau40TightIDPass:
        def __get__(self):
            self.DoubleMediumTau40TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau40TightIDPass_value

    property DoubleTightHPSTau35Pass:
        def __get__(self):
            self.DoubleTightHPSTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightHPSTau35Pass_value

    property DoubleTightHPSTau35TightIDPass:
        def __get__(self):
            self.DoubleTightHPSTau35TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightHPSTau35TightIDPass_value

    property DoubleTightHPSTau40Pass:
        def __get__(self):
            self.DoubleTightHPSTau40Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightHPSTau40Pass_value

    property DoubleTightHPSTau40TightIDPass:
        def __get__(self):
            self.DoubleTightHPSTau40TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightHPSTau40TightIDPass_value

    property DoubleTightTau35Pass:
        def __get__(self):
            self.DoubleTightTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau35Pass_value

    property DoubleTightTau35TightIDPass:
        def __get__(self):
            self.DoubleTightTau35TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau35TightIDPass_value

    property DoubleTightTau40Pass:
        def __get__(self):
            self.DoubleTightTau40Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau40Pass_value

    property DoubleTightTau40TightIDPass:
        def __get__(self):
            self.DoubleTightTau40TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau40TightIDPass_value

    property Ele24LooseHPSTau30Pass:
        def __get__(self):
            self.Ele24LooseHPSTau30Pass_branch.GetEntry(self.localentry, 0)
            return self.Ele24LooseHPSTau30Pass_value

    property Ele24LooseHPSTau30TightIDPass:
        def __get__(self):
            self.Ele24LooseHPSTau30TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.Ele24LooseHPSTau30TightIDPass_value

    property Ele24LooseTau30Pass:
        def __get__(self):
            self.Ele24LooseTau30Pass_branch.GetEntry(self.localentry, 0)
            return self.Ele24LooseTau30Pass_value

    property Ele24LooseTau30TightIDPass:
        def __get__(self):
            self.Ele24LooseTau30TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.Ele24LooseTau30TightIDPass_value

    property Ele27WPTightPass:
        def __get__(self):
            self.Ele27WPTightPass_branch.GetEntry(self.localentry, 0)
            return self.Ele27WPTightPass_value

    property Ele32WPTightPass:
        def __get__(self):
            self.Ele32WPTightPass_branch.GetEntry(self.localentry, 0)
            return self.Ele32WPTightPass_value

    property Ele35WPTightPass:
        def __get__(self):
            self.Ele35WPTightPass_branch.GetEntry(self.localentry, 0)
            return self.Ele35WPTightPass_value

    property Ele38WPTightPass:
        def __get__(self):
            self.Ele38WPTightPass_branch.GetEntry(self.localentry, 0)
            return self.Ele38WPTightPass_value

    property Ele40WPTightPass:
        def __get__(self):
            self.Ele40WPTightPass_branch.GetEntry(self.localentry, 0)
            return self.Ele40WPTightPass_value

    property EmbPtWeight:
        def __get__(self):
            self.EmbPtWeight_branch.GetEntry(self.localentry, 0)
            return self.EmbPtWeight_value

    property Eta:
        def __get__(self):
            self.Eta_branch.GetEntry(self.localentry, 0)
            return self.Eta_value

    property Flag_BadChargedCandidateFilter:
        def __get__(self):
            self.Flag_BadChargedCandidateFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_BadChargedCandidateFilter_value

    property Flag_BadPFMuonFilter:
        def __get__(self):
            self.Flag_BadPFMuonFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_BadPFMuonFilter_value

    property Flag_EcalDeadCellTriggerPrimitiveFilter:
        def __get__(self):
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_EcalDeadCellTriggerPrimitiveFilter_value

    property Flag_HBHENoiseFilter:
        def __get__(self):
            self.Flag_HBHENoiseFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_HBHENoiseFilter_value

    property Flag_HBHENoiseIsoFilter:
        def __get__(self):
            self.Flag_HBHENoiseIsoFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_HBHENoiseIsoFilter_value

    property Flag_ecalBadCalibFilter:
        def __get__(self):
            self.Flag_ecalBadCalibFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_ecalBadCalibFilter_value

    property Flag_globalTightHalo2016Filter:
        def __get__(self):
            self.Flag_globalTightHalo2016Filter_branch.GetEntry(self.localentry, 0)
            return self.Flag_globalTightHalo2016Filter_value

    property Flag_goodVertices:
        def __get__(self):
            self.Flag_goodVertices_branch.GetEntry(self.localentry, 0)
            return self.Flag_goodVertices_value

    property GenWeight:
        def __get__(self):
            self.GenWeight_branch.GetEntry(self.localentry, 0)
            return self.GenWeight_value

    property Ht:
        def __get__(self):
            self.Ht_branch.GetEntry(self.localentry, 0)
            return self.Ht_value

    property IsoMu24Pass:
        def __get__(self):
            self.IsoMu24Pass_branch.GetEntry(self.localentry, 0)
            return self.IsoMu24Pass_value

    property IsoMu27Pass:
        def __get__(self):
            self.IsoMu27Pass_branch.GetEntry(self.localentry, 0)
            return self.IsoMu27Pass_value

    property LT:
        def __get__(self):
            self.LT_branch.GetEntry(self.localentry, 0)
            return self.LT_value

    property Mass:
        def __get__(self):
            self.Mass_branch.GetEntry(self.localentry, 0)
            return self.Mass_value

    property MassError:
        def __get__(self):
            self.MassError_branch.GetEntry(self.localentry, 0)
            return self.MassError_value

    property MassErrord1:
        def __get__(self):
            self.MassErrord1_branch.GetEntry(self.localentry, 0)
            return self.MassErrord1_value

    property MassErrord2:
        def __get__(self):
            self.MassErrord2_branch.GetEntry(self.localentry, 0)
            return self.MassErrord2_value

    property MassErrord3:
        def __get__(self):
            self.MassErrord3_branch.GetEntry(self.localentry, 0)
            return self.MassErrord3_value

    property MassErrord4:
        def __get__(self):
            self.MassErrord4_branch.GetEntry(self.localentry, 0)
            return self.MassErrord4_value

    property Mt:
        def __get__(self):
            self.Mt_branch.GetEntry(self.localentry, 0)
            return self.Mt_value

    property Mu20LooseHPSTau27Pass:
        def __get__(self):
            self.Mu20LooseHPSTau27Pass_branch.GetEntry(self.localentry, 0)
            return self.Mu20LooseHPSTau27Pass_value

    property Mu20LooseHPSTau27TightIDPass:
        def __get__(self):
            self.Mu20LooseHPSTau27TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.Mu20LooseHPSTau27TightIDPass_value

    property Mu20LooseTau27Pass:
        def __get__(self):
            self.Mu20LooseTau27Pass_branch.GetEntry(self.localentry, 0)
            return self.Mu20LooseTau27Pass_value

    property Mu20LooseTau27TightIDPass:
        def __get__(self):
            self.Mu20LooseTau27TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.Mu20LooseTau27TightIDPass_value

    property Mu50Pass:
        def __get__(self):
            self.Mu50Pass_branch.GetEntry(self.localentry, 0)
            return self.Mu50Pass_value

    property NUP:
        def __get__(self):
            self.NUP_branch.GetEntry(self.localentry, 0)
            return self.NUP_value

    property Phi:
        def __get__(self):
            self.Phi_branch.GetEntry(self.localentry, 0)
            return self.Phi_value

    property Pt:
        def __get__(self):
            self.Pt_branch.GetEntry(self.localentry, 0)
            return self.Pt_value

    property VBFDoubleLooseHPSTau20Pass:
        def __get__(self):
            self.VBFDoubleLooseHPSTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.VBFDoubleLooseHPSTau20Pass_value

    property VBFDoubleLooseTau20Pass:
        def __get__(self):
            self.VBFDoubleLooseTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.VBFDoubleLooseTau20Pass_value

    property VBFDoubleMediumHPSTau20Pass:
        def __get__(self):
            self.VBFDoubleMediumHPSTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.VBFDoubleMediumHPSTau20Pass_value

    property VBFDoubleMediumTau20Pass:
        def __get__(self):
            self.VBFDoubleMediumTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.VBFDoubleMediumTau20Pass_value

    property VBFDoubleTightHPSTau20Pass:
        def __get__(self):
            self.VBFDoubleTightHPSTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.VBFDoubleTightHPSTau20Pass_value

    property VBFDoubleTightTau20Pass:
        def __get__(self):
            self.VBFDoubleTightTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.VBFDoubleTightTau20Pass_value

    property bjetDeepCSVVeto20Loose_2016_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Loose_2016_DR0p5_value

    property bjetDeepCSVVeto20Loose_2017_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Loose_2017_DR0p5_value

    property bjetDeepCSVVeto20Loose_2018_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Loose_2018_DR0p5_value

    property bjetDeepCSVVeto20Medium:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_value

    property bjetDeepCSVVeto20MediumWoNoisyJets:
        def __get__(self):
            self.bjetDeepCSVVeto20MediumWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20MediumWoNoisyJets_value

    property bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_value

    property bjetDeepCSVVeto20Medium_2016_DR0:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2016_DR0_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2016_DR0_value

    property bjetDeepCSVVeto20Medium_2016_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2016_DR0p5_value

    property bjetDeepCSVVeto20Medium_2017_DR0:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2017_DR0_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2017_DR0_value

    property bjetDeepCSVVeto20Medium_2017_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2017_DR0p5_value

    property bjetDeepCSVVeto20Medium_2018_DR0:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2018_DR0_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2018_DR0_value

    property bjetDeepCSVVeto20Medium_2018_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2018_DR0p5_value

    property bjetDeepCSVVeto20Tight_2016_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Tight_2016_DR0p5_value

    property bjetDeepCSVVeto20Tight_2017_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Tight_2017_DR0p5_value

    property bjetDeepCSVVeto20Tight_2018_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Tight_2018_DR0p5_value

    property charge:
        def __get__(self):
            self.charge_branch.GetEntry(self.localentry, 0)
            return self.charge_value

    property dielectronVeto:
        def __get__(self):
            self.dielectronVeto_branch.GetEntry(self.localentry, 0)
            return self.dielectronVeto_value

    property dimu9ele9Pass:
        def __get__(self):
            self.dimu9ele9Pass_branch.GetEntry(self.localentry, 0)
            return self.dimu9ele9Pass_value

    property dimuonVeto:
        def __get__(self):
            self.dimuonVeto_branch.GetEntry(self.localentry, 0)
            return self.dimuonVeto_value

    property doubleE25Pass:
        def __get__(self):
            self.doubleE25Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleE25Pass_value

    property doubleE33Pass:
        def __get__(self):
            self.doubleE33Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleE33Pass_value

    property doubleE_23_12Pass:
        def __get__(self):
            self.doubleE_23_12Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleE_23_12Pass_value

    property doubleMuDZminMass3p8Pass:
        def __get__(self):
            self.doubleMuDZminMass3p8Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuDZminMass3p8Pass_value

    property doubleMuDZminMass8Pass:
        def __get__(self):
            self.doubleMuDZminMass8Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuDZminMass8Pass_value

    property doubleMuSingleEPass:
        def __get__(self):
            self.doubleMuSingleEPass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuSingleEPass_value

    property doubleTau35Pass:
        def __get__(self):
            self.doubleTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleTau35Pass_value

    property doubleTauCmbIso35RegPass:
        def __get__(self):
            self.doubleTauCmbIso35RegPass_branch.GetEntry(self.localentry, 0)
            return self.doubleTauCmbIso35RegPass_value

    property eCBIDLoose:
        def __get__(self):
            self.eCBIDLoose_branch.GetEntry(self.localentry, 0)
            return self.eCBIDLoose_value

    property eCBIDMedium:
        def __get__(self):
            self.eCBIDMedium_branch.GetEntry(self.localentry, 0)
            return self.eCBIDMedium_value

    property eCBIDTight:
        def __get__(self):
            self.eCBIDTight_branch.GetEntry(self.localentry, 0)
            return self.eCBIDTight_value

    property eCBIDVeto:
        def __get__(self):
            self.eCBIDVeto_branch.GetEntry(self.localentry, 0)
            return self.eCBIDVeto_value

    property eCharge:
        def __get__(self):
            self.eCharge_branch.GetEntry(self.localentry, 0)
            return self.eCharge_value

    property eChargeIdLoose:
        def __get__(self):
            self.eChargeIdLoose_branch.GetEntry(self.localentry, 0)
            return self.eChargeIdLoose_value

    property eChargeIdMed:
        def __get__(self):
            self.eChargeIdMed_branch.GetEntry(self.localentry, 0)
            return self.eChargeIdMed_value

    property eChargeIdTight:
        def __get__(self):
            self.eChargeIdTight_branch.GetEntry(self.localentry, 0)
            return self.eChargeIdTight_value

    property eComesFromHiggs:
        def __get__(self):
            self.eComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.eComesFromHiggs_value

    property eCorrectedEt:
        def __get__(self):
            self.eCorrectedEt_branch.GetEntry(self.localentry, 0)
            return self.eCorrectedEt_value

    property eE1x5:
        def __get__(self):
            self.eE1x5_branch.GetEntry(self.localentry, 0)
            return self.eE1x5_value

    property eE2x5Max:
        def __get__(self):
            self.eE2x5Max_branch.GetEntry(self.localentry, 0)
            return self.eE2x5Max_value

    property eE5x5:
        def __get__(self):
            self.eE5x5_branch.GetEntry(self.localentry, 0)
            return self.eE5x5_value

    property eEcalIsoDR03:
        def __get__(self):
            self.eEcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eEcalIsoDR03_value

    property eEnergyError:
        def __get__(self):
            self.eEnergyError_branch.GetEntry(self.localentry, 0)
            return self.eEnergyError_value

    property eEnergyScaleDown:
        def __get__(self):
            self.eEnergyScaleDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleDown_value

    property eEnergyScaleGainDown:
        def __get__(self):
            self.eEnergyScaleGainDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleGainDown_value

    property eEnergyScaleGainUp:
        def __get__(self):
            self.eEnergyScaleGainUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleGainUp_value

    property eEnergyScaleStatDown:
        def __get__(self):
            self.eEnergyScaleStatDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleStatDown_value

    property eEnergyScaleStatUp:
        def __get__(self):
            self.eEnergyScaleStatUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleStatUp_value

    property eEnergyScaleSystDown:
        def __get__(self):
            self.eEnergyScaleSystDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleSystDown_value

    property eEnergyScaleSystUp:
        def __get__(self):
            self.eEnergyScaleSystUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleSystUp_value

    property eEnergyScaleUp:
        def __get__(self):
            self.eEnergyScaleUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleUp_value

    property eEnergySigmaDown:
        def __get__(self):
            self.eEnergySigmaDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergySigmaDown_value

    property eEnergySigmaPhiDown:
        def __get__(self):
            self.eEnergySigmaPhiDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergySigmaPhiDown_value

    property eEnergySigmaPhiUp:
        def __get__(self):
            self.eEnergySigmaPhiUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergySigmaPhiUp_value

    property eEnergySigmaRhoDown:
        def __get__(self):
            self.eEnergySigmaRhoDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergySigmaRhoDown_value

    property eEnergySigmaRhoUp:
        def __get__(self):
            self.eEnergySigmaRhoUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergySigmaRhoUp_value

    property eEnergySigmaUp:
        def __get__(self):
            self.eEnergySigmaUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergySigmaUp_value

    property eEta:
        def __get__(self):
            self.eEta_branch.GetEntry(self.localentry, 0)
            return self.eEta_value

    property eGenCharge:
        def __get__(self):
            self.eGenCharge_branch.GetEntry(self.localentry, 0)
            return self.eGenCharge_value

    property eGenEnergy:
        def __get__(self):
            self.eGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.eGenEnergy_value

    property eGenEta:
        def __get__(self):
            self.eGenEta_branch.GetEntry(self.localentry, 0)
            return self.eGenEta_value

    property eGenMotherPdgId:
        def __get__(self):
            self.eGenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.eGenMotherPdgId_value

    property eGenParticle:
        def __get__(self):
            self.eGenParticle_branch.GetEntry(self.localentry, 0)
            return self.eGenParticle_value

    property eGenPdgId:
        def __get__(self):
            self.eGenPdgId_branch.GetEntry(self.localentry, 0)
            return self.eGenPdgId_value

    property eGenPhi:
        def __get__(self):
            self.eGenPhi_branch.GetEntry(self.localentry, 0)
            return self.eGenPhi_value

    property eGenPrompt:
        def __get__(self):
            self.eGenPrompt_branch.GetEntry(self.localentry, 0)
            return self.eGenPrompt_value

    property eGenPromptTauDecay:
        def __get__(self):
            self.eGenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.eGenPromptTauDecay_value

    property eGenPt:
        def __get__(self):
            self.eGenPt_branch.GetEntry(self.localentry, 0)
            return self.eGenPt_value

    property eGenTauDecay:
        def __get__(self):
            self.eGenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.eGenTauDecay_value

    property eGenVZ:
        def __get__(self):
            self.eGenVZ_branch.GetEntry(self.localentry, 0)
            return self.eGenVZ_value

    property eGenVtxPVMatch:
        def __get__(self):
            self.eGenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.eGenVtxPVMatch_value

    property eHadronicDepth1OverEm:
        def __get__(self):
            self.eHadronicDepth1OverEm_branch.GetEntry(self.localentry, 0)
            return self.eHadronicDepth1OverEm_value

    property eHadronicDepth2OverEm:
        def __get__(self):
            self.eHadronicDepth2OverEm_branch.GetEntry(self.localentry, 0)
            return self.eHadronicDepth2OverEm_value

    property eHadronicOverEM:
        def __get__(self):
            self.eHadronicOverEM_branch.GetEntry(self.localentry, 0)
            return self.eHadronicOverEM_value

    property eHcalIsoDR03:
        def __get__(self):
            self.eHcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eHcalIsoDR03_value

    property eIP3D:
        def __get__(self):
            self.eIP3D_branch.GetEntry(self.localentry, 0)
            return self.eIP3D_value

    property eIP3DErr:
        def __get__(self):
            self.eIP3DErr_branch.GetEntry(self.localentry, 0)
            return self.eIP3DErr_value

    property eJetArea:
        def __get__(self):
            self.eJetArea_branch.GetEntry(self.localentry, 0)
            return self.eJetArea_value

    property eJetBtag:
        def __get__(self):
            self.eJetBtag_branch.GetEntry(self.localentry, 0)
            return self.eJetBtag_value

    property eJetDR:
        def __get__(self):
            self.eJetDR_branch.GetEntry(self.localentry, 0)
            return self.eJetDR_value

    property eJetEtaEtaMoment:
        def __get__(self):
            self.eJetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.eJetEtaEtaMoment_value

    property eJetEtaPhiMoment:
        def __get__(self):
            self.eJetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.eJetEtaPhiMoment_value

    property eJetEtaPhiSpread:
        def __get__(self):
            self.eJetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.eJetEtaPhiSpread_value

    property eJetHadronFlavour:
        def __get__(self):
            self.eJetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.eJetHadronFlavour_value

    property eJetPFCISVBtag:
        def __get__(self):
            self.eJetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.eJetPFCISVBtag_value

    property eJetPartonFlavour:
        def __get__(self):
            self.eJetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.eJetPartonFlavour_value

    property eJetPhiPhiMoment:
        def __get__(self):
            self.eJetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.eJetPhiPhiMoment_value

    property eJetPt:
        def __get__(self):
            self.eJetPt_branch.GetEntry(self.localentry, 0)
            return self.eJetPt_value

    property eLowestMll:
        def __get__(self):
            self.eLowestMll_branch.GetEntry(self.localentry, 0)
            return self.eLowestMll_value

    property eMVAIsoWP80:
        def __get__(self):
            self.eMVAIsoWP80_branch.GetEntry(self.localentry, 0)
            return self.eMVAIsoWP80_value

    property eMVAIsoWP90:
        def __get__(self):
            self.eMVAIsoWP90_branch.GetEntry(self.localentry, 0)
            return self.eMVAIsoWP90_value

    property eMVAIsoWPHZZ:
        def __get__(self):
            self.eMVAIsoWPHZZ_branch.GetEntry(self.localentry, 0)
            return self.eMVAIsoWPHZZ_value

    property eMVAIsoWPLoose:
        def __get__(self):
            self.eMVAIsoWPLoose_branch.GetEntry(self.localentry, 0)
            return self.eMVAIsoWPLoose_value

    property eMVANoisoWP80:
        def __get__(self):
            self.eMVANoisoWP80_branch.GetEntry(self.localentry, 0)
            return self.eMVANoisoWP80_value

    property eMVANoisoWP90:
        def __get__(self):
            self.eMVANoisoWP90_branch.GetEntry(self.localentry, 0)
            return self.eMVANoisoWP90_value

    property eMVANoisoWPLoose:
        def __get__(self):
            self.eMVANoisoWPLoose_branch.GetEntry(self.localentry, 0)
            return self.eMVANoisoWPLoose_value

    property eMass:
        def __get__(self):
            self.eMass_branch.GetEntry(self.localentry, 0)
            return self.eMass_value

    property eMatchesEle24Tau30Filter:
        def __get__(self):
            self.eMatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24Tau30Filter_value

    property eMatchesEle24Tau30Path:
        def __get__(self):
            self.eMatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24Tau30Path_value

    property eMatchesEle27Filter:
        def __get__(self):
            self.eMatchesEle27Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle27Filter_value

    property eMatchesEle27Path:
        def __get__(self):
            self.eMatchesEle27Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle27Path_value

    property eMatchesEle32Filter:
        def __get__(self):
            self.eMatchesEle32Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle32Filter_value

    property eMatchesEle32Path:
        def __get__(self):
            self.eMatchesEle32Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle32Path_value

    property eMatchesEle35Filter:
        def __get__(self):
            self.eMatchesEle35Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle35Filter_value

    property eMatchesEle35Path:
        def __get__(self):
            self.eMatchesEle35Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle35Path_value

    property eMatchesMu23e12DZFilter:
        def __get__(self):
            self.eMatchesMu23e12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23e12DZFilter_value

    property eMatchesMu23e12DZPath:
        def __get__(self):
            self.eMatchesMu23e12DZPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23e12DZPath_value

    property eMatchesMu8e23DZFilter:
        def __get__(self):
            self.eMatchesMu8e23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8e23DZFilter_value

    property eMatchesMu8e23DZPath:
        def __get__(self):
            self.eMatchesMu8e23DZPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8e23DZPath_value

    property eMissingHits:
        def __get__(self):
            self.eMissingHits_branch.GetEntry(self.localentry, 0)
            return self.eMissingHits_value

    property eNearMuonVeto:
        def __get__(self):
            self.eNearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.eNearMuonVeto_value

    property eNearestMuonDR:
        def __get__(self):
            self.eNearestMuonDR_branch.GetEntry(self.localentry, 0)
            return self.eNearestMuonDR_value

    property eNearestZMass:
        def __get__(self):
            self.eNearestZMass_branch.GetEntry(self.localentry, 0)
            return self.eNearestZMass_value

    property ePFChargedIso:
        def __get__(self):
            self.ePFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.ePFChargedIso_value

    property ePFNeutralIso:
        def __get__(self):
            self.ePFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.ePFNeutralIso_value

    property ePFPUChargedIso:
        def __get__(self):
            self.ePFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.ePFPUChargedIso_value

    property ePFPhotonIso:
        def __get__(self):
            self.ePFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.ePFPhotonIso_value

    property ePVDXY:
        def __get__(self):
            self.ePVDXY_branch.GetEntry(self.localentry, 0)
            return self.ePVDXY_value

    property ePVDZ:
        def __get__(self):
            self.ePVDZ_branch.GetEntry(self.localentry, 0)
            return self.ePVDZ_value

    property ePassesConversionVeto:
        def __get__(self):
            self.ePassesConversionVeto_branch.GetEntry(self.localentry, 0)
            return self.ePassesConversionVeto_value

    property ePhi:
        def __get__(self):
            self.ePhi_branch.GetEntry(self.localentry, 0)
            return self.ePhi_value

    property ePt:
        def __get__(self):
            self.ePt_branch.GetEntry(self.localentry, 0)
            return self.ePt_value

    property eRelIso:
        def __get__(self):
            self.eRelIso_branch.GetEntry(self.localentry, 0)
            return self.eRelIso_value

    property eRelPFIsoDB:
        def __get__(self):
            self.eRelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.eRelPFIsoDB_value

    property eRelPFIsoRho:
        def __get__(self):
            self.eRelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.eRelPFIsoRho_value

    property eRho:
        def __get__(self):
            self.eRho_branch.GetEntry(self.localentry, 0)
            return self.eRho_value

    property eSCEnergy:
        def __get__(self):
            self.eSCEnergy_branch.GetEntry(self.localentry, 0)
            return self.eSCEnergy_value

    property eSCEta:
        def __get__(self):
            self.eSCEta_branch.GetEntry(self.localentry, 0)
            return self.eSCEta_value

    property eSCEtaWidth:
        def __get__(self):
            self.eSCEtaWidth_branch.GetEntry(self.localentry, 0)
            return self.eSCEtaWidth_value

    property eSCPhi:
        def __get__(self):
            self.eSCPhi_branch.GetEntry(self.localentry, 0)
            return self.eSCPhi_value

    property eSCPhiWidth:
        def __get__(self):
            self.eSCPhiWidth_branch.GetEntry(self.localentry, 0)
            return self.eSCPhiWidth_value

    property eSCPreshowerEnergy:
        def __get__(self):
            self.eSCPreshowerEnergy_branch.GetEntry(self.localentry, 0)
            return self.eSCPreshowerEnergy_value

    property eSCRawEnergy:
        def __get__(self):
            self.eSCRawEnergy_branch.GetEntry(self.localentry, 0)
            return self.eSCRawEnergy_value

    property eSIP2D:
        def __get__(self):
            self.eSIP2D_branch.GetEntry(self.localentry, 0)
            return self.eSIP2D_value

    property eSIP3D:
        def __get__(self):
            self.eSIP3D_branch.GetEntry(self.localentry, 0)
            return self.eSIP3D_value

    property eSigmaIEtaIEta:
        def __get__(self):
            self.eSigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.eSigmaIEtaIEta_value

    property eTrkIsoDR03:
        def __get__(self):
            self.eTrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eTrkIsoDR03_value

    property eVZ:
        def __get__(self):
            self.eVZ_branch.GetEntry(self.localentry, 0)
            return self.eVZ_value

    property eVetoHZZPt5:
        def __get__(self):
            self.eVetoHZZPt5_branch.GetEntry(self.localentry, 0)
            return self.eVetoHZZPt5_value

    property eVetoMVAIso:
        def __get__(self):
            self.eVetoMVAIso_branch.GetEntry(self.localentry, 0)
            return self.eVetoMVAIso_value

    property eVetoZTTp001dxyz:
        def __get__(self):
            self.eVetoZTTp001dxyz_branch.GetEntry(self.localentry, 0)
            return self.eVetoZTTp001dxyz_value

    property eVetoZTTp001dxyzR0:
        def __get__(self):
            self.eVetoZTTp001dxyzR0_branch.GetEntry(self.localentry, 0)
            return self.eVetoZTTp001dxyzR0_value

    property eZTTGenMatching:
        def __get__(self):
            self.eZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.eZTTGenMatching_value

    property e_t_DR:
        def __get__(self):
            self.e_t_DR_branch.GetEntry(self.localentry, 0)
            return self.e_t_DR_value

    property e_t_Mass:
        def __get__(self):
            self.e_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.e_t_Mass_value

    property e_t_PZeta:
        def __get__(self):
            self.e_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e_t_PZeta_value

    property e_t_PZetaVis:
        def __get__(self):
            self.e_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e_t_PZetaVis_value

    property edeltaEtaSuperClusterTrackAtVtx:
        def __get__(self):
            self.edeltaEtaSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.edeltaEtaSuperClusterTrackAtVtx_value

    property edeltaPhiSuperClusterTrackAtVtx:
        def __get__(self):
            self.edeltaPhiSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.edeltaPhiSuperClusterTrackAtVtx_value

    property eeSuperClusterOverP:
        def __get__(self):
            self.eeSuperClusterOverP_branch.GetEntry(self.localentry, 0)
            return self.eeSuperClusterOverP_value

    property eecalEnergy:
        def __get__(self):
            self.eecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.eecalEnergy_value

    property efBrem:
        def __get__(self):
            self.efBrem_branch.GetEntry(self.localentry, 0)
            return self.efBrem_value

    property etrackMomentumAtVtxP:
        def __get__(self):
            self.etrackMomentumAtVtxP_branch.GetEntry(self.localentry, 0)
            return self.etrackMomentumAtVtxP_value

    property evt:
        def __get__(self):
            self.evt_branch.GetEntry(self.localentry, 0)
            return self.evt_value

    property genHTT:
        def __get__(self):
            self.genHTT_branch.GetEntry(self.localentry, 0)
            return self.genHTT_value

    property genpX:
        def __get__(self):
            self.genpX_branch.GetEntry(self.localentry, 0)
            return self.genpX_value

    property genpY:
        def __get__(self):
            self.genpY_branch.GetEntry(self.localentry, 0)
            return self.genpY_value

    property isWenu:
        def __get__(self):
            self.isWenu_branch.GetEntry(self.localentry, 0)
            return self.isWenu_value

    property isWmunu:
        def __get__(self):
            self.isWmunu_branch.GetEntry(self.localentry, 0)
            return self.isWmunu_value

    property isWtaunu:
        def __get__(self):
            self.isWtaunu_branch.GetEntry(self.localentry, 0)
            return self.isWtaunu_value

    property isZee:
        def __get__(self):
            self.isZee_branch.GetEntry(self.localentry, 0)
            return self.isZee_value

    property isZmumu:
        def __get__(self):
            self.isZmumu_branch.GetEntry(self.localentry, 0)
            return self.isZmumu_value

    property isZtautau:
        def __get__(self):
            self.isZtautau_branch.GetEntry(self.localentry, 0)
            return self.isZtautau_value

    property isdata:
        def __get__(self):
            self.isdata_branch.GetEntry(self.localentry, 0)
            return self.isdata_value

    property isembed:
        def __get__(self):
            self.isembed_branch.GetEntry(self.localentry, 0)
            return self.isembed_value

    property jb1eta:
        def __get__(self):
            self.jb1eta_branch.GetEntry(self.localentry, 0)
            return self.jb1eta_value

    property jb1hadronflavor:
        def __get__(self):
            self.jb1hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavor_value

    property jb1pt:
        def __get__(self):
            self.jb1pt_branch.GetEntry(self.localentry, 0)
            return self.jb1pt_value

    property jetVeto20:
        def __get__(self):
            self.jetVeto20_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_value

    property jetVeto20WoNoisyJets:
        def __get__(self):
            self.jetVeto20WoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20WoNoisyJets_value

    property jetVeto20_JetEnDown:
        def __get__(self):
            self.jetVeto20_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_JetEnDown_value

    property jetVeto20_JetEnUp:
        def __get__(self):
            self.jetVeto20_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_JetEnUp_value

    property jetVeto30:
        def __get__(self):
            self.jetVeto30_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_value

    property jetVeto30WoNoisyJets:
        def __get__(self):
            self.jetVeto30WoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_value

    property jetVeto30WoNoisyJets_JetEnDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEnDown_value

    property jetVeto30WoNoisyJets_JetEnUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEnUp_value

    property jetVeto30_JetEnDown:
        def __get__(self):
            self.jetVeto30_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnDown_value

    property jetVeto30_JetEnUp:
        def __get__(self):
            self.jetVeto30_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnUp_value

    property lheweight0:
        def __get__(self):
            self.lheweight0_branch.GetEntry(self.localentry, 0)
            return self.lheweight0_value

    property lheweight1:
        def __get__(self):
            self.lheweight1_branch.GetEntry(self.localentry, 0)
            return self.lheweight1_value

    property lheweight10:
        def __get__(self):
            self.lheweight10_branch.GetEntry(self.localentry, 0)
            return self.lheweight10_value

    property lheweight100:
        def __get__(self):
            self.lheweight100_branch.GetEntry(self.localentry, 0)
            return self.lheweight100_value

    property lheweight101:
        def __get__(self):
            self.lheweight101_branch.GetEntry(self.localentry, 0)
            return self.lheweight101_value

    property lheweight102:
        def __get__(self):
            self.lheweight102_branch.GetEntry(self.localentry, 0)
            return self.lheweight102_value

    property lheweight103:
        def __get__(self):
            self.lheweight103_branch.GetEntry(self.localentry, 0)
            return self.lheweight103_value

    property lheweight104:
        def __get__(self):
            self.lheweight104_branch.GetEntry(self.localentry, 0)
            return self.lheweight104_value

    property lheweight105:
        def __get__(self):
            self.lheweight105_branch.GetEntry(self.localentry, 0)
            return self.lheweight105_value

    property lheweight106:
        def __get__(self):
            self.lheweight106_branch.GetEntry(self.localentry, 0)
            return self.lheweight106_value

    property lheweight107:
        def __get__(self):
            self.lheweight107_branch.GetEntry(self.localentry, 0)
            return self.lheweight107_value

    property lheweight108:
        def __get__(self):
            self.lheweight108_branch.GetEntry(self.localentry, 0)
            return self.lheweight108_value

    property lheweight109:
        def __get__(self):
            self.lheweight109_branch.GetEntry(self.localentry, 0)
            return self.lheweight109_value

    property lheweight11:
        def __get__(self):
            self.lheweight11_branch.GetEntry(self.localentry, 0)
            return self.lheweight11_value

    property lheweight110:
        def __get__(self):
            self.lheweight110_branch.GetEntry(self.localentry, 0)
            return self.lheweight110_value

    property lheweight111:
        def __get__(self):
            self.lheweight111_branch.GetEntry(self.localentry, 0)
            return self.lheweight111_value

    property lheweight112:
        def __get__(self):
            self.lheweight112_branch.GetEntry(self.localentry, 0)
            return self.lheweight112_value

    property lheweight113:
        def __get__(self):
            self.lheweight113_branch.GetEntry(self.localentry, 0)
            return self.lheweight113_value

    property lheweight114:
        def __get__(self):
            self.lheweight114_branch.GetEntry(self.localentry, 0)
            return self.lheweight114_value

    property lheweight115:
        def __get__(self):
            self.lheweight115_branch.GetEntry(self.localentry, 0)
            return self.lheweight115_value

    property lheweight116:
        def __get__(self):
            self.lheweight116_branch.GetEntry(self.localentry, 0)
            return self.lheweight116_value

    property lheweight117:
        def __get__(self):
            self.lheweight117_branch.GetEntry(self.localentry, 0)
            return self.lheweight117_value

    property lheweight118:
        def __get__(self):
            self.lheweight118_branch.GetEntry(self.localentry, 0)
            return self.lheweight118_value

    property lheweight119:
        def __get__(self):
            self.lheweight119_branch.GetEntry(self.localentry, 0)
            return self.lheweight119_value

    property lheweight12:
        def __get__(self):
            self.lheweight12_branch.GetEntry(self.localentry, 0)
            return self.lheweight12_value

    property lheweight120:
        def __get__(self):
            self.lheweight120_branch.GetEntry(self.localentry, 0)
            return self.lheweight120_value

    property lheweight121:
        def __get__(self):
            self.lheweight121_branch.GetEntry(self.localentry, 0)
            return self.lheweight121_value

    property lheweight122:
        def __get__(self):
            self.lheweight122_branch.GetEntry(self.localentry, 0)
            return self.lheweight122_value

    property lheweight123:
        def __get__(self):
            self.lheweight123_branch.GetEntry(self.localentry, 0)
            return self.lheweight123_value

    property lheweight124:
        def __get__(self):
            self.lheweight124_branch.GetEntry(self.localentry, 0)
            return self.lheweight124_value

    property lheweight125:
        def __get__(self):
            self.lheweight125_branch.GetEntry(self.localentry, 0)
            return self.lheweight125_value

    property lheweight126:
        def __get__(self):
            self.lheweight126_branch.GetEntry(self.localentry, 0)
            return self.lheweight126_value

    property lheweight127:
        def __get__(self):
            self.lheweight127_branch.GetEntry(self.localentry, 0)
            return self.lheweight127_value

    property lheweight128:
        def __get__(self):
            self.lheweight128_branch.GetEntry(self.localentry, 0)
            return self.lheweight128_value

    property lheweight129:
        def __get__(self):
            self.lheweight129_branch.GetEntry(self.localentry, 0)
            return self.lheweight129_value

    property lheweight13:
        def __get__(self):
            self.lheweight13_branch.GetEntry(self.localentry, 0)
            return self.lheweight13_value

    property lheweight130:
        def __get__(self):
            self.lheweight130_branch.GetEntry(self.localentry, 0)
            return self.lheweight130_value

    property lheweight131:
        def __get__(self):
            self.lheweight131_branch.GetEntry(self.localentry, 0)
            return self.lheweight131_value

    property lheweight132:
        def __get__(self):
            self.lheweight132_branch.GetEntry(self.localentry, 0)
            return self.lheweight132_value

    property lheweight133:
        def __get__(self):
            self.lheweight133_branch.GetEntry(self.localentry, 0)
            return self.lheweight133_value

    property lheweight134:
        def __get__(self):
            self.lheweight134_branch.GetEntry(self.localentry, 0)
            return self.lheweight134_value

    property lheweight135:
        def __get__(self):
            self.lheweight135_branch.GetEntry(self.localentry, 0)
            return self.lheweight135_value

    property lheweight136:
        def __get__(self):
            self.lheweight136_branch.GetEntry(self.localentry, 0)
            return self.lheweight136_value

    property lheweight137:
        def __get__(self):
            self.lheweight137_branch.GetEntry(self.localentry, 0)
            return self.lheweight137_value

    property lheweight138:
        def __get__(self):
            self.lheweight138_branch.GetEntry(self.localentry, 0)
            return self.lheweight138_value

    property lheweight139:
        def __get__(self):
            self.lheweight139_branch.GetEntry(self.localentry, 0)
            return self.lheweight139_value

    property lheweight14:
        def __get__(self):
            self.lheweight14_branch.GetEntry(self.localentry, 0)
            return self.lheweight14_value

    property lheweight140:
        def __get__(self):
            self.lheweight140_branch.GetEntry(self.localentry, 0)
            return self.lheweight140_value

    property lheweight141:
        def __get__(self):
            self.lheweight141_branch.GetEntry(self.localentry, 0)
            return self.lheweight141_value

    property lheweight142:
        def __get__(self):
            self.lheweight142_branch.GetEntry(self.localentry, 0)
            return self.lheweight142_value

    property lheweight143:
        def __get__(self):
            self.lheweight143_branch.GetEntry(self.localentry, 0)
            return self.lheweight143_value

    property lheweight144:
        def __get__(self):
            self.lheweight144_branch.GetEntry(self.localentry, 0)
            return self.lheweight144_value

    property lheweight145:
        def __get__(self):
            self.lheweight145_branch.GetEntry(self.localentry, 0)
            return self.lheweight145_value

    property lheweight146:
        def __get__(self):
            self.lheweight146_branch.GetEntry(self.localentry, 0)
            return self.lheweight146_value

    property lheweight147:
        def __get__(self):
            self.lheweight147_branch.GetEntry(self.localentry, 0)
            return self.lheweight147_value

    property lheweight148:
        def __get__(self):
            self.lheweight148_branch.GetEntry(self.localentry, 0)
            return self.lheweight148_value

    property lheweight149:
        def __get__(self):
            self.lheweight149_branch.GetEntry(self.localentry, 0)
            return self.lheweight149_value

    property lheweight15:
        def __get__(self):
            self.lheweight15_branch.GetEntry(self.localentry, 0)
            return self.lheweight15_value

    property lheweight150:
        def __get__(self):
            self.lheweight150_branch.GetEntry(self.localentry, 0)
            return self.lheweight150_value

    property lheweight151:
        def __get__(self):
            self.lheweight151_branch.GetEntry(self.localentry, 0)
            return self.lheweight151_value

    property lheweight152:
        def __get__(self):
            self.lheweight152_branch.GetEntry(self.localentry, 0)
            return self.lheweight152_value

    property lheweight153:
        def __get__(self):
            self.lheweight153_branch.GetEntry(self.localentry, 0)
            return self.lheweight153_value

    property lheweight154:
        def __get__(self):
            self.lheweight154_branch.GetEntry(self.localentry, 0)
            return self.lheweight154_value

    property lheweight155:
        def __get__(self):
            self.lheweight155_branch.GetEntry(self.localentry, 0)
            return self.lheweight155_value

    property lheweight156:
        def __get__(self):
            self.lheweight156_branch.GetEntry(self.localentry, 0)
            return self.lheweight156_value

    property lheweight157:
        def __get__(self):
            self.lheweight157_branch.GetEntry(self.localentry, 0)
            return self.lheweight157_value

    property lheweight158:
        def __get__(self):
            self.lheweight158_branch.GetEntry(self.localentry, 0)
            return self.lheweight158_value

    property lheweight159:
        def __get__(self):
            self.lheweight159_branch.GetEntry(self.localentry, 0)
            return self.lheweight159_value

    property lheweight16:
        def __get__(self):
            self.lheweight16_branch.GetEntry(self.localentry, 0)
            return self.lheweight16_value

    property lheweight160:
        def __get__(self):
            self.lheweight160_branch.GetEntry(self.localentry, 0)
            return self.lheweight160_value

    property lheweight161:
        def __get__(self):
            self.lheweight161_branch.GetEntry(self.localentry, 0)
            return self.lheweight161_value

    property lheweight162:
        def __get__(self):
            self.lheweight162_branch.GetEntry(self.localentry, 0)
            return self.lheweight162_value

    property lheweight163:
        def __get__(self):
            self.lheweight163_branch.GetEntry(self.localentry, 0)
            return self.lheweight163_value

    property lheweight164:
        def __get__(self):
            self.lheweight164_branch.GetEntry(self.localentry, 0)
            return self.lheweight164_value

    property lheweight165:
        def __get__(self):
            self.lheweight165_branch.GetEntry(self.localentry, 0)
            return self.lheweight165_value

    property lheweight166:
        def __get__(self):
            self.lheweight166_branch.GetEntry(self.localentry, 0)
            return self.lheweight166_value

    property lheweight167:
        def __get__(self):
            self.lheweight167_branch.GetEntry(self.localentry, 0)
            return self.lheweight167_value

    property lheweight168:
        def __get__(self):
            self.lheweight168_branch.GetEntry(self.localentry, 0)
            return self.lheweight168_value

    property lheweight169:
        def __get__(self):
            self.lheweight169_branch.GetEntry(self.localentry, 0)
            return self.lheweight169_value

    property lheweight17:
        def __get__(self):
            self.lheweight17_branch.GetEntry(self.localentry, 0)
            return self.lheweight17_value

    property lheweight170:
        def __get__(self):
            self.lheweight170_branch.GetEntry(self.localentry, 0)
            return self.lheweight170_value

    property lheweight171:
        def __get__(self):
            self.lheweight171_branch.GetEntry(self.localentry, 0)
            return self.lheweight171_value

    property lheweight172:
        def __get__(self):
            self.lheweight172_branch.GetEntry(self.localentry, 0)
            return self.lheweight172_value

    property lheweight173:
        def __get__(self):
            self.lheweight173_branch.GetEntry(self.localentry, 0)
            return self.lheweight173_value

    property lheweight174:
        def __get__(self):
            self.lheweight174_branch.GetEntry(self.localentry, 0)
            return self.lheweight174_value

    property lheweight175:
        def __get__(self):
            self.lheweight175_branch.GetEntry(self.localentry, 0)
            return self.lheweight175_value

    property lheweight176:
        def __get__(self):
            self.lheweight176_branch.GetEntry(self.localentry, 0)
            return self.lheweight176_value

    property lheweight177:
        def __get__(self):
            self.lheweight177_branch.GetEntry(self.localentry, 0)
            return self.lheweight177_value

    property lheweight178:
        def __get__(self):
            self.lheweight178_branch.GetEntry(self.localentry, 0)
            return self.lheweight178_value

    property lheweight179:
        def __get__(self):
            self.lheweight179_branch.GetEntry(self.localentry, 0)
            return self.lheweight179_value

    property lheweight18:
        def __get__(self):
            self.lheweight18_branch.GetEntry(self.localentry, 0)
            return self.lheweight18_value

    property lheweight180:
        def __get__(self):
            self.lheweight180_branch.GetEntry(self.localentry, 0)
            return self.lheweight180_value

    property lheweight181:
        def __get__(self):
            self.lheweight181_branch.GetEntry(self.localentry, 0)
            return self.lheweight181_value

    property lheweight182:
        def __get__(self):
            self.lheweight182_branch.GetEntry(self.localentry, 0)
            return self.lheweight182_value

    property lheweight183:
        def __get__(self):
            self.lheweight183_branch.GetEntry(self.localentry, 0)
            return self.lheweight183_value

    property lheweight184:
        def __get__(self):
            self.lheweight184_branch.GetEntry(self.localentry, 0)
            return self.lheweight184_value

    property lheweight185:
        def __get__(self):
            self.lheweight185_branch.GetEntry(self.localentry, 0)
            return self.lheweight185_value

    property lheweight186:
        def __get__(self):
            self.lheweight186_branch.GetEntry(self.localentry, 0)
            return self.lheweight186_value

    property lheweight187:
        def __get__(self):
            self.lheweight187_branch.GetEntry(self.localentry, 0)
            return self.lheweight187_value

    property lheweight188:
        def __get__(self):
            self.lheweight188_branch.GetEntry(self.localentry, 0)
            return self.lheweight188_value

    property lheweight189:
        def __get__(self):
            self.lheweight189_branch.GetEntry(self.localentry, 0)
            return self.lheweight189_value

    property lheweight19:
        def __get__(self):
            self.lheweight19_branch.GetEntry(self.localentry, 0)
            return self.lheweight19_value

    property lheweight190:
        def __get__(self):
            self.lheweight190_branch.GetEntry(self.localentry, 0)
            return self.lheweight190_value

    property lheweight191:
        def __get__(self):
            self.lheweight191_branch.GetEntry(self.localentry, 0)
            return self.lheweight191_value

    property lheweight192:
        def __get__(self):
            self.lheweight192_branch.GetEntry(self.localentry, 0)
            return self.lheweight192_value

    property lheweight193:
        def __get__(self):
            self.lheweight193_branch.GetEntry(self.localentry, 0)
            return self.lheweight193_value

    property lheweight194:
        def __get__(self):
            self.lheweight194_branch.GetEntry(self.localentry, 0)
            return self.lheweight194_value

    property lheweight195:
        def __get__(self):
            self.lheweight195_branch.GetEntry(self.localentry, 0)
            return self.lheweight195_value

    property lheweight196:
        def __get__(self):
            self.lheweight196_branch.GetEntry(self.localentry, 0)
            return self.lheweight196_value

    property lheweight197:
        def __get__(self):
            self.lheweight197_branch.GetEntry(self.localentry, 0)
            return self.lheweight197_value

    property lheweight198:
        def __get__(self):
            self.lheweight198_branch.GetEntry(self.localentry, 0)
            return self.lheweight198_value

    property lheweight199:
        def __get__(self):
            self.lheweight199_branch.GetEntry(self.localentry, 0)
            return self.lheweight199_value

    property lheweight2:
        def __get__(self):
            self.lheweight2_branch.GetEntry(self.localentry, 0)
            return self.lheweight2_value

    property lheweight20:
        def __get__(self):
            self.lheweight20_branch.GetEntry(self.localentry, 0)
            return self.lheweight20_value

    property lheweight200:
        def __get__(self):
            self.lheweight200_branch.GetEntry(self.localentry, 0)
            return self.lheweight200_value

    property lheweight201:
        def __get__(self):
            self.lheweight201_branch.GetEntry(self.localentry, 0)
            return self.lheweight201_value

    property lheweight202:
        def __get__(self):
            self.lheweight202_branch.GetEntry(self.localentry, 0)
            return self.lheweight202_value

    property lheweight203:
        def __get__(self):
            self.lheweight203_branch.GetEntry(self.localentry, 0)
            return self.lheweight203_value

    property lheweight204:
        def __get__(self):
            self.lheweight204_branch.GetEntry(self.localentry, 0)
            return self.lheweight204_value

    property lheweight205:
        def __get__(self):
            self.lheweight205_branch.GetEntry(self.localentry, 0)
            return self.lheweight205_value

    property lheweight206:
        def __get__(self):
            self.lheweight206_branch.GetEntry(self.localentry, 0)
            return self.lheweight206_value

    property lheweight207:
        def __get__(self):
            self.lheweight207_branch.GetEntry(self.localentry, 0)
            return self.lheweight207_value

    property lheweight208:
        def __get__(self):
            self.lheweight208_branch.GetEntry(self.localentry, 0)
            return self.lheweight208_value

    property lheweight209:
        def __get__(self):
            self.lheweight209_branch.GetEntry(self.localentry, 0)
            return self.lheweight209_value

    property lheweight21:
        def __get__(self):
            self.lheweight21_branch.GetEntry(self.localentry, 0)
            return self.lheweight21_value

    property lheweight210:
        def __get__(self):
            self.lheweight210_branch.GetEntry(self.localentry, 0)
            return self.lheweight210_value

    property lheweight211:
        def __get__(self):
            self.lheweight211_branch.GetEntry(self.localentry, 0)
            return self.lheweight211_value

    property lheweight212:
        def __get__(self):
            self.lheweight212_branch.GetEntry(self.localentry, 0)
            return self.lheweight212_value

    property lheweight213:
        def __get__(self):
            self.lheweight213_branch.GetEntry(self.localentry, 0)
            return self.lheweight213_value

    property lheweight214:
        def __get__(self):
            self.lheweight214_branch.GetEntry(self.localentry, 0)
            return self.lheweight214_value

    property lheweight215:
        def __get__(self):
            self.lheweight215_branch.GetEntry(self.localentry, 0)
            return self.lheweight215_value

    property lheweight216:
        def __get__(self):
            self.lheweight216_branch.GetEntry(self.localentry, 0)
            return self.lheweight216_value

    property lheweight217:
        def __get__(self):
            self.lheweight217_branch.GetEntry(self.localentry, 0)
            return self.lheweight217_value

    property lheweight218:
        def __get__(self):
            self.lheweight218_branch.GetEntry(self.localentry, 0)
            return self.lheweight218_value

    property lheweight219:
        def __get__(self):
            self.lheweight219_branch.GetEntry(self.localentry, 0)
            return self.lheweight219_value

    property lheweight22:
        def __get__(self):
            self.lheweight22_branch.GetEntry(self.localentry, 0)
            return self.lheweight22_value

    property lheweight220:
        def __get__(self):
            self.lheweight220_branch.GetEntry(self.localentry, 0)
            return self.lheweight220_value

    property lheweight221:
        def __get__(self):
            self.lheweight221_branch.GetEntry(self.localentry, 0)
            return self.lheweight221_value

    property lheweight23:
        def __get__(self):
            self.lheweight23_branch.GetEntry(self.localentry, 0)
            return self.lheweight23_value

    property lheweight24:
        def __get__(self):
            self.lheweight24_branch.GetEntry(self.localentry, 0)
            return self.lheweight24_value

    property lheweight25:
        def __get__(self):
            self.lheweight25_branch.GetEntry(self.localentry, 0)
            return self.lheweight25_value

    property lheweight26:
        def __get__(self):
            self.lheweight26_branch.GetEntry(self.localentry, 0)
            return self.lheweight26_value

    property lheweight27:
        def __get__(self):
            self.lheweight27_branch.GetEntry(self.localentry, 0)
            return self.lheweight27_value

    property lheweight28:
        def __get__(self):
            self.lheweight28_branch.GetEntry(self.localentry, 0)
            return self.lheweight28_value

    property lheweight29:
        def __get__(self):
            self.lheweight29_branch.GetEntry(self.localentry, 0)
            return self.lheweight29_value

    property lheweight3:
        def __get__(self):
            self.lheweight3_branch.GetEntry(self.localentry, 0)
            return self.lheweight3_value

    property lheweight30:
        def __get__(self):
            self.lheweight30_branch.GetEntry(self.localentry, 0)
            return self.lheweight30_value

    property lheweight31:
        def __get__(self):
            self.lheweight31_branch.GetEntry(self.localentry, 0)
            return self.lheweight31_value

    property lheweight32:
        def __get__(self):
            self.lheweight32_branch.GetEntry(self.localentry, 0)
            return self.lheweight32_value

    property lheweight33:
        def __get__(self):
            self.lheweight33_branch.GetEntry(self.localentry, 0)
            return self.lheweight33_value

    property lheweight34:
        def __get__(self):
            self.lheweight34_branch.GetEntry(self.localentry, 0)
            return self.lheweight34_value

    property lheweight35:
        def __get__(self):
            self.lheweight35_branch.GetEntry(self.localentry, 0)
            return self.lheweight35_value

    property lheweight36:
        def __get__(self):
            self.lheweight36_branch.GetEntry(self.localentry, 0)
            return self.lheweight36_value

    property lheweight37:
        def __get__(self):
            self.lheweight37_branch.GetEntry(self.localentry, 0)
            return self.lheweight37_value

    property lheweight38:
        def __get__(self):
            self.lheweight38_branch.GetEntry(self.localentry, 0)
            return self.lheweight38_value

    property lheweight39:
        def __get__(self):
            self.lheweight39_branch.GetEntry(self.localentry, 0)
            return self.lheweight39_value

    property lheweight4:
        def __get__(self):
            self.lheweight4_branch.GetEntry(self.localentry, 0)
            return self.lheweight4_value

    property lheweight40:
        def __get__(self):
            self.lheweight40_branch.GetEntry(self.localentry, 0)
            return self.lheweight40_value

    property lheweight41:
        def __get__(self):
            self.lheweight41_branch.GetEntry(self.localentry, 0)
            return self.lheweight41_value

    property lheweight42:
        def __get__(self):
            self.lheweight42_branch.GetEntry(self.localentry, 0)
            return self.lheweight42_value

    property lheweight43:
        def __get__(self):
            self.lheweight43_branch.GetEntry(self.localentry, 0)
            return self.lheweight43_value

    property lheweight44:
        def __get__(self):
            self.lheweight44_branch.GetEntry(self.localentry, 0)
            return self.lheweight44_value

    property lheweight45:
        def __get__(self):
            self.lheweight45_branch.GetEntry(self.localentry, 0)
            return self.lheweight45_value

    property lheweight46:
        def __get__(self):
            self.lheweight46_branch.GetEntry(self.localentry, 0)
            return self.lheweight46_value

    property lheweight47:
        def __get__(self):
            self.lheweight47_branch.GetEntry(self.localentry, 0)
            return self.lheweight47_value

    property lheweight48:
        def __get__(self):
            self.lheweight48_branch.GetEntry(self.localentry, 0)
            return self.lheweight48_value

    property lheweight49:
        def __get__(self):
            self.lheweight49_branch.GetEntry(self.localentry, 0)
            return self.lheweight49_value

    property lheweight5:
        def __get__(self):
            self.lheweight5_branch.GetEntry(self.localentry, 0)
            return self.lheweight5_value

    property lheweight50:
        def __get__(self):
            self.lheweight50_branch.GetEntry(self.localentry, 0)
            return self.lheweight50_value

    property lheweight51:
        def __get__(self):
            self.lheweight51_branch.GetEntry(self.localentry, 0)
            return self.lheweight51_value

    property lheweight52:
        def __get__(self):
            self.lheweight52_branch.GetEntry(self.localentry, 0)
            return self.lheweight52_value

    property lheweight53:
        def __get__(self):
            self.lheweight53_branch.GetEntry(self.localentry, 0)
            return self.lheweight53_value

    property lheweight54:
        def __get__(self):
            self.lheweight54_branch.GetEntry(self.localentry, 0)
            return self.lheweight54_value

    property lheweight55:
        def __get__(self):
            self.lheweight55_branch.GetEntry(self.localentry, 0)
            return self.lheweight55_value

    property lheweight56:
        def __get__(self):
            self.lheweight56_branch.GetEntry(self.localentry, 0)
            return self.lheweight56_value

    property lheweight57:
        def __get__(self):
            self.lheweight57_branch.GetEntry(self.localentry, 0)
            return self.lheweight57_value

    property lheweight58:
        def __get__(self):
            self.lheweight58_branch.GetEntry(self.localentry, 0)
            return self.lheweight58_value

    property lheweight59:
        def __get__(self):
            self.lheweight59_branch.GetEntry(self.localentry, 0)
            return self.lheweight59_value

    property lheweight6:
        def __get__(self):
            self.lheweight6_branch.GetEntry(self.localentry, 0)
            return self.lheweight6_value

    property lheweight60:
        def __get__(self):
            self.lheweight60_branch.GetEntry(self.localentry, 0)
            return self.lheweight60_value

    property lheweight61:
        def __get__(self):
            self.lheweight61_branch.GetEntry(self.localentry, 0)
            return self.lheweight61_value

    property lheweight62:
        def __get__(self):
            self.lheweight62_branch.GetEntry(self.localentry, 0)
            return self.lheweight62_value

    property lheweight63:
        def __get__(self):
            self.lheweight63_branch.GetEntry(self.localentry, 0)
            return self.lheweight63_value

    property lheweight64:
        def __get__(self):
            self.lheweight64_branch.GetEntry(self.localentry, 0)
            return self.lheweight64_value

    property lheweight65:
        def __get__(self):
            self.lheweight65_branch.GetEntry(self.localentry, 0)
            return self.lheweight65_value

    property lheweight66:
        def __get__(self):
            self.lheweight66_branch.GetEntry(self.localentry, 0)
            return self.lheweight66_value

    property lheweight67:
        def __get__(self):
            self.lheweight67_branch.GetEntry(self.localentry, 0)
            return self.lheweight67_value

    property lheweight68:
        def __get__(self):
            self.lheweight68_branch.GetEntry(self.localentry, 0)
            return self.lheweight68_value

    property lheweight69:
        def __get__(self):
            self.lheweight69_branch.GetEntry(self.localentry, 0)
            return self.lheweight69_value

    property lheweight7:
        def __get__(self):
            self.lheweight7_branch.GetEntry(self.localentry, 0)
            return self.lheweight7_value

    property lheweight70:
        def __get__(self):
            self.lheweight70_branch.GetEntry(self.localentry, 0)
            return self.lheweight70_value

    property lheweight71:
        def __get__(self):
            self.lheweight71_branch.GetEntry(self.localentry, 0)
            return self.lheweight71_value

    property lheweight72:
        def __get__(self):
            self.lheweight72_branch.GetEntry(self.localentry, 0)
            return self.lheweight72_value

    property lheweight73:
        def __get__(self):
            self.lheweight73_branch.GetEntry(self.localentry, 0)
            return self.lheweight73_value

    property lheweight74:
        def __get__(self):
            self.lheweight74_branch.GetEntry(self.localentry, 0)
            return self.lheweight74_value

    property lheweight75:
        def __get__(self):
            self.lheweight75_branch.GetEntry(self.localentry, 0)
            return self.lheweight75_value

    property lheweight76:
        def __get__(self):
            self.lheweight76_branch.GetEntry(self.localentry, 0)
            return self.lheweight76_value

    property lheweight77:
        def __get__(self):
            self.lheweight77_branch.GetEntry(self.localentry, 0)
            return self.lheweight77_value

    property lheweight78:
        def __get__(self):
            self.lheweight78_branch.GetEntry(self.localentry, 0)
            return self.lheweight78_value

    property lheweight79:
        def __get__(self):
            self.lheweight79_branch.GetEntry(self.localentry, 0)
            return self.lheweight79_value

    property lheweight8:
        def __get__(self):
            self.lheweight8_branch.GetEntry(self.localentry, 0)
            return self.lheweight8_value

    property lheweight80:
        def __get__(self):
            self.lheweight80_branch.GetEntry(self.localentry, 0)
            return self.lheweight80_value

    property lheweight81:
        def __get__(self):
            self.lheweight81_branch.GetEntry(self.localentry, 0)
            return self.lheweight81_value

    property lheweight82:
        def __get__(self):
            self.lheweight82_branch.GetEntry(self.localentry, 0)
            return self.lheweight82_value

    property lheweight83:
        def __get__(self):
            self.lheweight83_branch.GetEntry(self.localentry, 0)
            return self.lheweight83_value

    property lheweight84:
        def __get__(self):
            self.lheweight84_branch.GetEntry(self.localentry, 0)
            return self.lheweight84_value

    property lheweight85:
        def __get__(self):
            self.lheweight85_branch.GetEntry(self.localentry, 0)
            return self.lheweight85_value

    property lheweight86:
        def __get__(self):
            self.lheweight86_branch.GetEntry(self.localentry, 0)
            return self.lheweight86_value

    property lheweight87:
        def __get__(self):
            self.lheweight87_branch.GetEntry(self.localentry, 0)
            return self.lheweight87_value

    property lheweight88:
        def __get__(self):
            self.lheweight88_branch.GetEntry(self.localentry, 0)
            return self.lheweight88_value

    property lheweight89:
        def __get__(self):
            self.lheweight89_branch.GetEntry(self.localentry, 0)
            return self.lheweight89_value

    property lheweight9:
        def __get__(self):
            self.lheweight9_branch.GetEntry(self.localentry, 0)
            return self.lheweight9_value

    property lheweight90:
        def __get__(self):
            self.lheweight90_branch.GetEntry(self.localentry, 0)
            return self.lheweight90_value

    property lheweight91:
        def __get__(self):
            self.lheweight91_branch.GetEntry(self.localentry, 0)
            return self.lheweight91_value

    property lheweight92:
        def __get__(self):
            self.lheweight92_branch.GetEntry(self.localentry, 0)
            return self.lheweight92_value

    property lheweight93:
        def __get__(self):
            self.lheweight93_branch.GetEntry(self.localentry, 0)
            return self.lheweight93_value

    property lheweight94:
        def __get__(self):
            self.lheweight94_branch.GetEntry(self.localentry, 0)
            return self.lheweight94_value

    property lheweight95:
        def __get__(self):
            self.lheweight95_branch.GetEntry(self.localentry, 0)
            return self.lheweight95_value

    property lheweight96:
        def __get__(self):
            self.lheweight96_branch.GetEntry(self.localentry, 0)
            return self.lheweight96_value

    property lheweight97:
        def __get__(self):
            self.lheweight97_branch.GetEntry(self.localentry, 0)
            return self.lheweight97_value

    property lheweight98:
        def __get__(self):
            self.lheweight98_branch.GetEntry(self.localentry, 0)
            return self.lheweight98_value

    property lheweight99:
        def __get__(self):
            self.lheweight99_branch.GetEntry(self.localentry, 0)
            return self.lheweight99_value

    property lumi:
        def __get__(self):
            self.lumi_branch.GetEntry(self.localentry, 0)
            return self.lumi_value

    property mu12e23DZPass:
        def __get__(self):
            self.mu12e23DZPass_branch.GetEntry(self.localentry, 0)
            return self.mu12e23DZPass_value

    property mu12e23Pass:
        def __get__(self):
            self.mu12e23Pass_branch.GetEntry(self.localentry, 0)
            return self.mu12e23Pass_value

    property mu23e12DZPass:
        def __get__(self):
            self.mu23e12DZPass_branch.GetEntry(self.localentry, 0)
            return self.mu23e12DZPass_value

    property mu23e12Pass:
        def __get__(self):
            self.mu23e12Pass_branch.GetEntry(self.localentry, 0)
            return self.mu23e12Pass_value

    property mu8diele12DZPass:
        def __get__(self):
            self.mu8diele12DZPass_branch.GetEntry(self.localentry, 0)
            return self.mu8diele12DZPass_value

    property mu8diele12Pass:
        def __get__(self):
            self.mu8diele12Pass_branch.GetEntry(self.localentry, 0)
            return self.mu8diele12Pass_value

    property mu8e23DZPass:
        def __get__(self):
            self.mu8e23DZPass_branch.GetEntry(self.localentry, 0)
            return self.mu8e23DZPass_value

    property mu8e23Pass:
        def __get__(self):
            self.mu8e23Pass_branch.GetEntry(self.localentry, 0)
            return self.mu8e23Pass_value

    property muGlbIsoVetoPt10:
        def __get__(self):
            self.muGlbIsoVetoPt10_branch.GetEntry(self.localentry, 0)
            return self.muGlbIsoVetoPt10_value

    property muVeto5:
        def __get__(self):
            self.muVeto5_branch.GetEntry(self.localentry, 0)
            return self.muVeto5_value

    property muVetoZTTp001dxyz:
        def __get__(self):
            self.muVetoZTTp001dxyz_branch.GetEntry(self.localentry, 0)
            return self.muVetoZTTp001dxyz_value

    property muVetoZTTp001dxyzR0:
        def __get__(self):
            self.muVetoZTTp001dxyzR0_branch.GetEntry(self.localentry, 0)
            return self.muVetoZTTp001dxyzR0_value

    property nTruePU:
        def __get__(self):
            self.nTruePU_branch.GetEntry(self.localentry, 0)
            return self.nTruePU_value

    property numGenJets:
        def __get__(self):
            self.numGenJets_branch.GetEntry(self.localentry, 0)
            return self.numGenJets_value

    property nvtx:
        def __get__(self):
            self.nvtx_branch.GetEntry(self.localentry, 0)
            return self.nvtx_value

    property prefiring_weight:
        def __get__(self):
            self.prefiring_weight_branch.GetEntry(self.localentry, 0)
            return self.prefiring_weight_value

    property processID:
        def __get__(self):
            self.processID_branch.GetEntry(self.localentry, 0)
            return self.processID_value

    property puppiMetEt:
        def __get__(self):
            self.puppiMetEt_branch.GetEntry(self.localentry, 0)
            return self.puppiMetEt_value

    property puppiMetPhi:
        def __get__(self):
            self.puppiMetPhi_branch.GetEntry(self.localentry, 0)
            return self.puppiMetPhi_value

    property pvChi2:
        def __get__(self):
            self.pvChi2_branch.GetEntry(self.localentry, 0)
            return self.pvChi2_value

    property pvDX:
        def __get__(self):
            self.pvDX_branch.GetEntry(self.localentry, 0)
            return self.pvDX_value

    property pvDY:
        def __get__(self):
            self.pvDY_branch.GetEntry(self.localentry, 0)
            return self.pvDY_value

    property pvDZ:
        def __get__(self):
            self.pvDZ_branch.GetEntry(self.localentry, 0)
            return self.pvDZ_value

    property pvIsFake:
        def __get__(self):
            self.pvIsFake_branch.GetEntry(self.localentry, 0)
            return self.pvIsFake_value

    property pvIsValid:
        def __get__(self):
            self.pvIsValid_branch.GetEntry(self.localentry, 0)
            return self.pvIsValid_value

    property pvNormChi2:
        def __get__(self):
            self.pvNormChi2_branch.GetEntry(self.localentry, 0)
            return self.pvNormChi2_value

    property pvRho:
        def __get__(self):
            self.pvRho_branch.GetEntry(self.localentry, 0)
            return self.pvRho_value

    property pvX:
        def __get__(self):
            self.pvX_branch.GetEntry(self.localentry, 0)
            return self.pvX_value

    property pvY:
        def __get__(self):
            self.pvY_branch.GetEntry(self.localentry, 0)
            return self.pvY_value

    property pvZ:
        def __get__(self):
            self.pvZ_branch.GetEntry(self.localentry, 0)
            return self.pvZ_value

    property pvndof:
        def __get__(self):
            self.pvndof_branch.GetEntry(self.localentry, 0)
            return self.pvndof_value

    property recoilDaught:
        def __get__(self):
            self.recoilDaught_branch.GetEntry(self.localentry, 0)
            return self.recoilDaught_value

    property recoilWithMet:
        def __get__(self):
            self.recoilWithMet_branch.GetEntry(self.localentry, 0)
            return self.recoilWithMet_value

    property rho:
        def __get__(self):
            self.rho_branch.GetEntry(self.localentry, 0)
            return self.rho_value

    property run:
        def __get__(self):
            self.run_branch.GetEntry(self.localentry, 0)
            return self.run_value

    property singleE25eta2p1TightPass:
        def __get__(self):
            self.singleE25eta2p1TightPass_branch.GetEntry(self.localentry, 0)
            return self.singleE25eta2p1TightPass_value

    property singleIsoMu22Pass:
        def __get__(self):
            self.singleIsoMu22Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu22Pass_value

    property singleIsoMu22eta2p1Pass:
        def __get__(self):
            self.singleIsoMu22eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu22eta2p1Pass_value

    property singleIsoTkMu22Pass:
        def __get__(self):
            self.singleIsoTkMu22Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu22Pass_value

    property singleIsoTkMu22eta2p1Pass:
        def __get__(self):
            self.singleIsoTkMu22eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu22eta2p1Pass_value

    property singleMu19eta2p1LooseTau20Pass:
        def __get__(self):
            self.singleMu19eta2p1LooseTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu19eta2p1LooseTau20Pass_value

    property singleMu19eta2p1LooseTau20singleL1Pass:
        def __get__(self):
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu19eta2p1LooseTau20singleL1Pass_value

    property tAgainstElectronLooseMVA6:
        def __get__(self):
            self.tAgainstElectronLooseMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronLooseMVA6_value

    property tAgainstElectronMVA6Raw:
        def __get__(self):
            self.tAgainstElectronMVA6Raw_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMVA6Raw_value

    property tAgainstElectronMVA6category:
        def __get__(self):
            self.tAgainstElectronMVA6category_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMVA6category_value

    property tAgainstElectronMediumMVA6:
        def __get__(self):
            self.tAgainstElectronMediumMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMediumMVA6_value

    property tAgainstElectronTightMVA6:
        def __get__(self):
            self.tAgainstElectronTightMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronTightMVA6_value

    property tAgainstElectronTightMVA62018:
        def __get__(self):
            self.tAgainstElectronTightMVA62018_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronTightMVA62018_value

    property tAgainstElectronVLooseMVA6:
        def __get__(self):
            self.tAgainstElectronVLooseMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronVLooseMVA6_value

    property tAgainstElectronVLooseMVA62018:
        def __get__(self):
            self.tAgainstElectronVLooseMVA62018_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronVLooseMVA62018_value

    property tAgainstElectronVTightMVA6:
        def __get__(self):
            self.tAgainstElectronVTightMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronVTightMVA6_value

    property tAgainstMuonLoose3:
        def __get__(self):
            self.tAgainstMuonLoose3_branch.GetEntry(self.localentry, 0)
            return self.tAgainstMuonLoose3_value

    property tAgainstMuonTight3:
        def __get__(self):
            self.tAgainstMuonTight3_branch.GetEntry(self.localentry, 0)
            return self.tAgainstMuonTight3_value

    property tByCombinedIsolationDeltaBetaCorrRaw3Hits:
        def __get__(self):
            self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch.GetEntry(self.localentry, 0)
            return self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_value

    property tByIsolationMVArun2v1DBdR03oldDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_value

    property tByIsolationMVArun2v1DBnewDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1DBnewDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1DBnewDMwLTraw_value

    property tByIsolationMVArun2v1DBoldDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1DBoldDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1DBoldDMwLTraw_value

    property tByLooseCombinedIsolationDeltaBetaCorr3Hits:
        def __get__(self):
            self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch.GetEntry(self.localentry, 0)
            return self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_value

    property tByLooseIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByLooseIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1DBnewDMwLT_value

    property tByLooseIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1DBoldDMwLT_value

    property tByMediumCombinedIsolationDeltaBetaCorr3Hits:
        def __get__(self):
            self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch.GetEntry(self.localentry, 0)
            return self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_value

    property tByMediumIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByMediumIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1DBnewDMwLT_value

    property tByMediumIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1DBoldDMwLT_value

    property tByPhotonPtSumOutsideSignalCone:
        def __get__(self):
            self.tByPhotonPtSumOutsideSignalCone_branch.GetEntry(self.localentry, 0)
            return self.tByPhotonPtSumOutsideSignalCone_value

    property tByTightCombinedIsolationDeltaBetaCorr3Hits:
        def __get__(self):
            self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch.GetEntry(self.localentry, 0)
            return self.tByTightCombinedIsolationDeltaBetaCorr3Hits_value

    property tByTightIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByTightIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1DBnewDMwLT_value

    property tByTightIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1DBoldDMwLT_value

    property tByVLooseIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByVLooseIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1DBnewDMwLT_value

    property tByVLooseIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1DBoldDMwLT_value

    property tByVTightIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByVTightIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1DBnewDMwLT_value

    property tByVTightIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1DBoldDMwLT_value

    property tByVVTightIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByVVTightIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVVTightIsolationMVArun2v1DBnewDMwLT_value

    property tByVVTightIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVVTightIsolationMVArun2v1DBoldDMwLT_value

    property tCharge:
        def __get__(self):
            self.tCharge_branch.GetEntry(self.localentry, 0)
            return self.tCharge_value

    property tChargedIsoPtSum:
        def __get__(self):
            self.tChargedIsoPtSum_branch.GetEntry(self.localentry, 0)
            return self.tChargedIsoPtSum_value

    property tChargedIsoPtSumdR03:
        def __get__(self):
            self.tChargedIsoPtSumdR03_branch.GetEntry(self.localentry, 0)
            return self.tChargedIsoPtSumdR03_value

    property tComesFromHiggs:
        def __get__(self):
            self.tComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.tComesFromHiggs_value

    property tDecayMode:
        def __get__(self):
            self.tDecayMode_branch.GetEntry(self.localentry, 0)
            return self.tDecayMode_value

    property tDecayModeFinding:
        def __get__(self):
            self.tDecayModeFinding_branch.GetEntry(self.localentry, 0)
            return self.tDecayModeFinding_value

    property tDecayModeFindingNewDMs:
        def __get__(self):
            self.tDecayModeFindingNewDMs_branch.GetEntry(self.localentry, 0)
            return self.tDecayModeFindingNewDMs_value

    property tEta:
        def __get__(self):
            self.tEta_branch.GetEntry(self.localentry, 0)
            return self.tEta_value

    property tFootprintCorrection:
        def __get__(self):
            self.tFootprintCorrection_branch.GetEntry(self.localentry, 0)
            return self.tFootprintCorrection_value

    property tFootprintCorrectiondR03:
        def __get__(self):
            self.tFootprintCorrectiondR03_branch.GetEntry(self.localentry, 0)
            return self.tFootprintCorrectiondR03_value

    property tGenCharge:
        def __get__(self):
            self.tGenCharge_branch.GetEntry(self.localentry, 0)
            return self.tGenCharge_value

    property tGenDecayMode:
        def __get__(self):
            self.tGenDecayMode_branch.GetEntry(self.localentry, 0)
            return self.tGenDecayMode_value

    property tGenEnergy:
        def __get__(self):
            self.tGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.tGenEnergy_value

    property tGenEta:
        def __get__(self):
            self.tGenEta_branch.GetEntry(self.localentry, 0)
            return self.tGenEta_value

    property tGenJetEta:
        def __get__(self):
            self.tGenJetEta_branch.GetEntry(self.localentry, 0)
            return self.tGenJetEta_value

    property tGenJetPt:
        def __get__(self):
            self.tGenJetPt_branch.GetEntry(self.localentry, 0)
            return self.tGenJetPt_value

    property tGenMotherEnergy:
        def __get__(self):
            self.tGenMotherEnergy_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherEnergy_value

    property tGenMotherEta:
        def __get__(self):
            self.tGenMotherEta_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherEta_value

    property tGenMotherPdgId:
        def __get__(self):
            self.tGenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherPdgId_value

    property tGenMotherPhi:
        def __get__(self):
            self.tGenMotherPhi_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherPhi_value

    property tGenMotherPt:
        def __get__(self):
            self.tGenMotherPt_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherPt_value

    property tGenPdgId:
        def __get__(self):
            self.tGenPdgId_branch.GetEntry(self.localentry, 0)
            return self.tGenPdgId_value

    property tGenPhi:
        def __get__(self):
            self.tGenPhi_branch.GetEntry(self.localentry, 0)
            return self.tGenPhi_value

    property tGenPt:
        def __get__(self):
            self.tGenPt_branch.GetEntry(self.localentry, 0)
            return self.tGenPt_value

    property tGenStatus:
        def __get__(self):
            self.tGenStatus_branch.GetEntry(self.localentry, 0)
            return self.tGenStatus_value

    property tJetArea:
        def __get__(self):
            self.tJetArea_branch.GetEntry(self.localentry, 0)
            return self.tJetArea_value

    property tJetBtag:
        def __get__(self):
            self.tJetBtag_branch.GetEntry(self.localentry, 0)
            return self.tJetBtag_value

    property tJetDR:
        def __get__(self):
            self.tJetDR_branch.GetEntry(self.localentry, 0)
            return self.tJetDR_value

    property tJetEtaEtaMoment:
        def __get__(self):
            self.tJetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.tJetEtaEtaMoment_value

    property tJetEtaPhiMoment:
        def __get__(self):
            self.tJetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.tJetEtaPhiMoment_value

    property tJetEtaPhiSpread:
        def __get__(self):
            self.tJetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.tJetEtaPhiSpread_value

    property tJetHadronFlavour:
        def __get__(self):
            self.tJetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.tJetHadronFlavour_value

    property tJetPFCISVBtag:
        def __get__(self):
            self.tJetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.tJetPFCISVBtag_value

    property tJetPartonFlavour:
        def __get__(self):
            self.tJetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.tJetPartonFlavour_value

    property tJetPhiPhiMoment:
        def __get__(self):
            self.tJetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.tJetPhiPhiMoment_value

    property tJetPt:
        def __get__(self):
            self.tJetPt_branch.GetEntry(self.localentry, 0)
            return self.tJetPt_value

    property tLeadTrackPt:
        def __get__(self):
            self.tLeadTrackPt_branch.GetEntry(self.localentry, 0)
            return self.tLeadTrackPt_value

    property tLowestMll:
        def __get__(self):
            self.tLowestMll_branch.GetEntry(self.localentry, 0)
            return self.tLowestMll_value

    property tMass:
        def __get__(self):
            self.tMass_branch.GetEntry(self.localentry, 0)
            return self.tMass_value

    property tMatchesEle24Tau30Filter:
        def __get__(self):
            self.tMatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau30Filter_value

    property tMatchesEle24Tau30Path:
        def __get__(self):
            self.tMatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau30Path_value

    property tNChrgHadrIsolationCands:
        def __get__(self):
            self.tNChrgHadrIsolationCands_branch.GetEntry(self.localentry, 0)
            return self.tNChrgHadrIsolationCands_value

    property tNChrgHadrSignalCands:
        def __get__(self):
            self.tNChrgHadrSignalCands_branch.GetEntry(self.localentry, 0)
            return self.tNChrgHadrSignalCands_value

    property tNGammaSignalCands:
        def __get__(self):
            self.tNGammaSignalCands_branch.GetEntry(self.localentry, 0)
            return self.tNGammaSignalCands_value

    property tNNeutralHadrSignalCands:
        def __get__(self):
            self.tNNeutralHadrSignalCands_branch.GetEntry(self.localentry, 0)
            return self.tNNeutralHadrSignalCands_value

    property tNSignalCands:
        def __get__(self):
            self.tNSignalCands_branch.GetEntry(self.localentry, 0)
            return self.tNSignalCands_value

    property tNearestZMass:
        def __get__(self):
            self.tNearestZMass_branch.GetEntry(self.localentry, 0)
            return self.tNearestZMass_value

    property tNeutralIsoPtSum:
        def __get__(self):
            self.tNeutralIsoPtSum_branch.GetEntry(self.localentry, 0)
            return self.tNeutralIsoPtSum_value

    property tNeutralIsoPtSumWeight:
        def __get__(self):
            self.tNeutralIsoPtSumWeight_branch.GetEntry(self.localentry, 0)
            return self.tNeutralIsoPtSumWeight_value

    property tNeutralIsoPtSumWeightdR03:
        def __get__(self):
            self.tNeutralIsoPtSumWeightdR03_branch.GetEntry(self.localentry, 0)
            return self.tNeutralIsoPtSumWeightdR03_value

    property tNeutralIsoPtSumdR03:
        def __get__(self):
            self.tNeutralIsoPtSumdR03_branch.GetEntry(self.localentry, 0)
            return self.tNeutralIsoPtSumdR03_value

    property tPVDXY:
        def __get__(self):
            self.tPVDXY_branch.GetEntry(self.localentry, 0)
            return self.tPVDXY_value

    property tPVDZ:
        def __get__(self):
            self.tPVDZ_branch.GetEntry(self.localentry, 0)
            return self.tPVDZ_value

    property tPhi:
        def __get__(self):
            self.tPhi_branch.GetEntry(self.localentry, 0)
            return self.tPhi_value

    property tPhotonPtSumOutsideSignalCone:
        def __get__(self):
            self.tPhotonPtSumOutsideSignalCone_branch.GetEntry(self.localentry, 0)
            return self.tPhotonPtSumOutsideSignalCone_value

    property tPhotonPtSumOutsideSignalConedR03:
        def __get__(self):
            self.tPhotonPtSumOutsideSignalConedR03_branch.GetEntry(self.localentry, 0)
            return self.tPhotonPtSumOutsideSignalConedR03_value

    property tPt:
        def __get__(self):
            self.tPt_branch.GetEntry(self.localentry, 0)
            return self.tPt_value

    property tPuCorrPtSum:
        def __get__(self):
            self.tPuCorrPtSum_branch.GetEntry(self.localentry, 0)
            return self.tPuCorrPtSum_value

    property tRerunMVArun2v2DBoldDMwLTLoose:
        def __get__(self):
            self.tRerunMVArun2v2DBoldDMwLTLoose_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v2DBoldDMwLTLoose_value

    property tRerunMVArun2v2DBoldDMwLTTight:
        def __get__(self):
            self.tRerunMVArun2v2DBoldDMwLTTight_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v2DBoldDMwLTTight_value

    property tRerunMVArun2v2DBoldDMwLTVLoose:
        def __get__(self):
            self.tRerunMVArun2v2DBoldDMwLTVLoose_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v2DBoldDMwLTVLoose_value

    property tVZ:
        def __get__(self):
            self.tVZ_branch.GetEntry(self.localentry, 0)
            return self.tVZ_value

    property tZTTGenMatching:
        def __get__(self):
            self.tZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.tZTTGenMatching_value

    property tauVetoPt20Loose3HitsVtx:
        def __get__(self):
            self.tauVetoPt20Loose3HitsVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20Loose3HitsVtx_value

    property tauVetoPt20LooseMVALTVtx:
        def __get__(self):
            self.tauVetoPt20LooseMVALTVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20LooseMVALTVtx_value

    property tauVetoPt20TightMVALTVtx:
        def __get__(self):
            self.tauVetoPt20TightMVALTVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20TightMVALTVtx_value

    property tripleEPass:
        def __get__(self):
            self.tripleEPass_branch.GetEntry(self.localentry, 0)
            return self.tripleEPass_value

    property tripleMu10_5_5Pass:
        def __get__(self):
            self.tripleMu10_5_5Pass_branch.GetEntry(self.localentry, 0)
            return self.tripleMu10_5_5Pass_value

    property tripleMu12_10_5Pass:
        def __get__(self):
            self.tripleMu12_10_5Pass_branch.GetEntry(self.localentry, 0)
            return self.tripleMu12_10_5Pass_value

    property type1_pfMetEt:
        def __get__(self):
            self.type1_pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetEt_value

    property type1_pfMetPhi:
        def __get__(self):
            self.type1_pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetPhi_value

    property vbfDeta:
        def __get__(self):
            self.vbfDeta_branch.GetEntry(self.localentry, 0)
            return self.vbfDeta_value

    property vbfJetVeto20:
        def __get__(self):
            self.vbfJetVeto20_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto20_value

    property vbfJetVeto30:
        def __get__(self):
            self.vbfJetVeto30_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto30_value

    property vbfMass:
        def __get__(self):
            self.vbfMass_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_value

    property vbfMassWoNoisyJets:
        def __get__(self):
            self.vbfMassWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_value

    property vbfNJets20:
        def __get__(self):
            self.vbfNJets20_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets20_value

    property vbfNJets30:
        def __get__(self):
            self.vbfNJets30_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets30_value

    property vbfj1eta:
        def __get__(self):
            self.vbfj1eta_branch.GetEntry(self.localentry, 0)
            return self.vbfj1eta_value

    property vbfj1pt:
        def __get__(self):
            self.vbfj1pt_branch.GetEntry(self.localentry, 0)
            return self.vbfj1pt_value

    property vbfj2eta:
        def __get__(self):
            self.vbfj2eta_branch.GetEntry(self.localentry, 0)
            return self.vbfj2eta_value

    property vbfj2pt:
        def __get__(self):
            self.vbfj2pt_branch.GetEntry(self.localentry, 0)
            return self.vbfj2pt_value

    property vispX:
        def __get__(self):
            self.vispX_branch.GetEntry(self.localentry, 0)
            return self.vispX_value

    property vispY:
        def __get__(self):
            self.vispY_branch.GetEntry(self.localentry, 0)
            return self.vispY_value

    property idx:
        def __get__(self):
            self.idx_branch.GetEntry(self.localentry, 0)
            return self.idx_value

