

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

cdef class EMTree:
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

    cdef TBranch* Flag_badMuons_branch
    cdef float Flag_badMuons_value

    cdef TBranch* Flag_duplicateMuons_branch
    cdef float Flag_duplicateMuons_value

    cdef TBranch* Flag_ecalBadCalibFilter_branch
    cdef float Flag_ecalBadCalibFilter_value

    cdef TBranch* Flag_ecalBadCalibReducedMINIAODFilter_branch
    cdef float Flag_ecalBadCalibReducedMINIAODFilter_value

    cdef TBranch* Flag_eeBadScFilter_branch
    cdef float Flag_eeBadScFilter_value

    cdef TBranch* Flag_globalSuperTightHalo2016Filter_branch
    cdef float Flag_globalSuperTightHalo2016Filter_value

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

    cdef TBranch* bweight_2016_branch
    cdef float bweight_2016_value

    cdef TBranch* bweight_2017_branch
    cdef float bweight_2017_value

    cdef TBranch* bweight_2018_branch
    cdef float bweight_2018_value

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

    cdef TBranch* eGenDirectPromptTauDecay_branch
    cdef float eGenDirectPromptTauDecay_value

    cdef TBranch* eGenEnergy_branch
    cdef float eGenEnergy_value

    cdef TBranch* eGenEta_branch
    cdef float eGenEta_value

    cdef TBranch* eGenIsPrompt_branch
    cdef float eGenIsPrompt_value

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

    cdef TBranch* eHcalIsoDR03_branch
    cdef float eHcalIsoDR03_value

    cdef TBranch* eIP3D_branch
    cdef float eIP3D_value

    cdef TBranch* eIP3DErr_branch
    cdef float eIP3DErr_value

    cdef TBranch* eIsoDB03_branch
    cdef float eIsoDB03_value

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

    cdef TBranch* eMVANoisoWP80_branch
    cdef float eMVANoisoWP80_value

    cdef TBranch* eMVANoisoWP90_branch
    cdef float eMVANoisoWP90_value

    cdef TBranch* eMass_branch
    cdef float eMass_value

    cdef TBranch* eMatchEmbeddedFilterEle24Tau30_branch
    cdef float eMatchEmbeddedFilterEle24Tau30_value

    cdef TBranch* eMatchEmbeddedFilterEle27_branch
    cdef float eMatchEmbeddedFilterEle27_value

    cdef TBranch* eMatchEmbeddedFilterEle32_branch
    cdef float eMatchEmbeddedFilterEle32_value

    cdef TBranch* eMatchEmbeddedFilterEle32DoubleL1_v1_branch
    cdef float eMatchEmbeddedFilterEle32DoubleL1_v1_value

    cdef TBranch* eMatchEmbeddedFilterEle32DoubleL1_v2_branch
    cdef float eMatchEmbeddedFilterEle32DoubleL1_v2_value

    cdef TBranch* eMatchEmbeddedFilterEle35_branch
    cdef float eMatchEmbeddedFilterEle35_value

    cdef TBranch* eMatchesEle24HPSTau30Filter_branch
    cdef float eMatchesEle24HPSTau30Filter_value

    cdef TBranch* eMatchesEle24HPSTau30Path_branch
    cdef float eMatchesEle24HPSTau30Path_value

    cdef TBranch* eMatchesEle24Tau30Filter_branch
    cdef float eMatchesEle24Tau30Filter_value

    cdef TBranch* eMatchesEle24Tau30Path_branch
    cdef float eMatchesEle24Tau30Path_value

    cdef TBranch* eMatchesEle25Filter_branch
    cdef float eMatchesEle25Filter_value

    cdef TBranch* eMatchesEle25Path_branch
    cdef float eMatchesEle25Path_value

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

    cdef TBranch* eMatchesMu23e12Filter_branch
    cdef float eMatchesMu23e12Filter_value

    cdef TBranch* eMatchesMu23e12Path_branch
    cdef float eMatchesMu23e12Path_value

    cdef TBranch* eMatchesMu8e23DZFilter_branch
    cdef float eMatchesMu8e23DZFilter_value

    cdef TBranch* eMatchesMu8e23DZPath_branch
    cdef float eMatchesMu8e23DZPath_value

    cdef TBranch* eMatchesMu8e23Filter_branch
    cdef float eMatchesMu8e23Filter_value

    cdef TBranch* eMatchesMu8e23Path_branch
    cdef float eMatchesMu8e23Path_value

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

    cdef TBranch* eSIP2D_branch
    cdef float eSIP2D_value

    cdef TBranch* eSIP3D_branch
    cdef float eSIP3D_value

    cdef TBranch* eTrkIsoDR03_branch
    cdef float eTrkIsoDR03_value

    cdef TBranch* eVZ_branch
    cdef float eVZ_value

    cdef TBranch* eVetoMVAIsoVtx_branch
    cdef float eVetoMVAIsoVtx_value

    cdef TBranch* eVetoZTTp001dxyz_branch
    cdef float eVetoZTTp001dxyz_value

    cdef TBranch* eZTTGenMatching_branch
    cdef float eZTTGenMatching_value

    cdef TBranch* e_m_DR_branch
    cdef float e_m_DR_value

    cdef TBranch* e_m_Mass_branch
    cdef float e_m_Mass_value

    cdef TBranch* e_m_PZeta_branch
    cdef float e_m_PZeta_value

    cdef TBranch* e_m_PZetaVis_branch
    cdef float e_m_PZetaVis_value

    cdef TBranch* e_m_doubleL1IsoTauMatch_branch
    cdef float e_m_doubleL1IsoTauMatch_value

    cdef TBranch* evt_branch
    cdef unsigned long evt_value

    cdef TBranch* genEta_branch
    cdef float genEta_value

    cdef TBranch* genHTT_branch
    cdef float genHTT_value

    cdef TBranch* genM_branch
    cdef float genM_value

    cdef TBranch* genMass_branch
    cdef float genMass_value

    cdef TBranch* genPhi_branch
    cdef float genPhi_value

    cdef TBranch* genpT_branch
    cdef float genpT_value

    cdef TBranch* genpX_branch
    cdef float genpX_value

    cdef TBranch* genpY_branch
    cdef float genpY_value

    cdef TBranch* isGtautau_branch
    cdef float isGtautau_value

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

    cdef TBranch* j1csv_branch
    cdef float j1csv_value

    cdef TBranch* j1csvWoNoisyJets_branch
    cdef float j1csvWoNoisyJets_value

    cdef TBranch* j1eta_branch
    cdef float j1eta_value

    cdef TBranch* j1etaWoNoisyJets_branch
    cdef float j1etaWoNoisyJets_value

    cdef TBranch* j1hadronflavor_branch
    cdef float j1hadronflavor_value

    cdef TBranch* j1hadronflavorWoNoisyJets_branch
    cdef float j1hadronflavorWoNoisyJets_value

    cdef TBranch* j1phi_branch
    cdef float j1phi_value

    cdef TBranch* j1phiWoNoisyJets_branch
    cdef float j1phiWoNoisyJets_value

    cdef TBranch* j1pt_branch
    cdef float j1pt_value

    cdef TBranch* j1ptWoNoisyJets_branch
    cdef float j1ptWoNoisyJets_value

    cdef TBranch* j1ptWoNoisyJets_JetEC2Down_branch
    cdef float j1ptWoNoisyJets_JetEC2Down_value

    cdef TBranch* j1ptWoNoisyJets_JetEC2Up_branch
    cdef float j1ptWoNoisyJets_JetEC2Up_value

    cdef TBranch* j1ptWoNoisyJets_JetEta0to3Down_branch
    cdef float j1ptWoNoisyJets_JetEta0to3Down_value

    cdef TBranch* j1ptWoNoisyJets_JetEta0to3Up_branch
    cdef float j1ptWoNoisyJets_JetEta0to3Up_value

    cdef TBranch* j1ptWoNoisyJets_JetEta0to5Down_branch
    cdef float j1ptWoNoisyJets_JetEta0to5Down_value

    cdef TBranch* j1ptWoNoisyJets_JetEta0to5Up_branch
    cdef float j1ptWoNoisyJets_JetEta0to5Up_value

    cdef TBranch* j1ptWoNoisyJets_JetEta3to5Down_branch
    cdef float j1ptWoNoisyJets_JetEta3to5Down_value

    cdef TBranch* j1ptWoNoisyJets_JetEta3to5Up_branch
    cdef float j1ptWoNoisyJets_JetEta3to5Up_value

    cdef TBranch* j1ptWoNoisyJets_JetRelativeBalDown_branch
    cdef float j1ptWoNoisyJets_JetRelativeBalDown_value

    cdef TBranch* j1ptWoNoisyJets_JetRelativeBalUp_branch
    cdef float j1ptWoNoisyJets_JetRelativeBalUp_value

    cdef TBranch* j1ptWoNoisyJets_JetRelativeSampleDown_branch
    cdef float j1ptWoNoisyJets_JetRelativeSampleDown_value

    cdef TBranch* j1ptWoNoisyJets_JetRelativeSampleUp_branch
    cdef float j1ptWoNoisyJets_JetRelativeSampleUp_value

    cdef TBranch* j1pt_JetEC2Down_branch
    cdef float j1pt_JetEC2Down_value

    cdef TBranch* j1pt_JetEC2Up_branch
    cdef float j1pt_JetEC2Up_value

    cdef TBranch* j1pt_JetEta0to3Down_branch
    cdef float j1pt_JetEta0to3Down_value

    cdef TBranch* j1pt_JetEta0to3Up_branch
    cdef float j1pt_JetEta0to3Up_value

    cdef TBranch* j1pt_JetEta0to5Down_branch
    cdef float j1pt_JetEta0to5Down_value

    cdef TBranch* j1pt_JetEta0to5Up_branch
    cdef float j1pt_JetEta0to5Up_value

    cdef TBranch* j1pt_JetEta3to5Down_branch
    cdef float j1pt_JetEta3to5Down_value

    cdef TBranch* j1pt_JetEta3to5Up_branch
    cdef float j1pt_JetEta3to5Up_value

    cdef TBranch* j1pt_JetRelativeBalDown_branch
    cdef float j1pt_JetRelativeBalDown_value

    cdef TBranch* j1pt_JetRelativeBalUp_branch
    cdef float j1pt_JetRelativeBalUp_value

    cdef TBranch* j1pt_JetRelativeSampleDown_branch
    cdef float j1pt_JetRelativeSampleDown_value

    cdef TBranch* j1pt_JetRelativeSampleUp_branch
    cdef float j1pt_JetRelativeSampleUp_value

    cdef TBranch* j2csv_branch
    cdef float j2csv_value

    cdef TBranch* j2csvWoNoisyJets_branch
    cdef float j2csvWoNoisyJets_value

    cdef TBranch* j2eta_branch
    cdef float j2eta_value

    cdef TBranch* j2etaWoNoisyJets_branch
    cdef float j2etaWoNoisyJets_value

    cdef TBranch* j2hadronflavor_branch
    cdef float j2hadronflavor_value

    cdef TBranch* j2hadronflavorWoNoisyJets_branch
    cdef float j2hadronflavorWoNoisyJets_value

    cdef TBranch* j2phi_branch
    cdef float j2phi_value

    cdef TBranch* j2phiWoNoisyJets_branch
    cdef float j2phiWoNoisyJets_value

    cdef TBranch* j2pt_branch
    cdef float j2pt_value

    cdef TBranch* j2ptWoNoisyJets_branch
    cdef float j2ptWoNoisyJets_value

    cdef TBranch* j2ptWoNoisyJets_JetEC2Down_branch
    cdef float j2ptWoNoisyJets_JetEC2Down_value

    cdef TBranch* j2ptWoNoisyJets_JetEC2Up_branch
    cdef float j2ptWoNoisyJets_JetEC2Up_value

    cdef TBranch* j2ptWoNoisyJets_JetEta0to3Down_branch
    cdef float j2ptWoNoisyJets_JetEta0to3Down_value

    cdef TBranch* j2ptWoNoisyJets_JetEta0to3Up_branch
    cdef float j2ptWoNoisyJets_JetEta0to3Up_value

    cdef TBranch* j2ptWoNoisyJets_JetEta0to5Down_branch
    cdef float j2ptWoNoisyJets_JetEta0to5Down_value

    cdef TBranch* j2ptWoNoisyJets_JetEta0to5Up_branch
    cdef float j2ptWoNoisyJets_JetEta0to5Up_value

    cdef TBranch* j2ptWoNoisyJets_JetEta3to5Down_branch
    cdef float j2ptWoNoisyJets_JetEta3to5Down_value

    cdef TBranch* j2ptWoNoisyJets_JetEta3to5Up_branch
    cdef float j2ptWoNoisyJets_JetEta3to5Up_value

    cdef TBranch* j2ptWoNoisyJets_JetRelativeBalDown_branch
    cdef float j2ptWoNoisyJets_JetRelativeBalDown_value

    cdef TBranch* j2ptWoNoisyJets_JetRelativeBalUp_branch
    cdef float j2ptWoNoisyJets_JetRelativeBalUp_value

    cdef TBranch* j2ptWoNoisyJets_JetRelativeSampleDown_branch
    cdef float j2ptWoNoisyJets_JetRelativeSampleDown_value

    cdef TBranch* j2ptWoNoisyJets_JetRelativeSampleUp_branch
    cdef float j2ptWoNoisyJets_JetRelativeSampleUp_value

    cdef TBranch* j2pt_JetEC2Down_branch
    cdef float j2pt_JetEC2Down_value

    cdef TBranch* j2pt_JetEC2Up_branch
    cdef float j2pt_JetEC2Up_value

    cdef TBranch* j2pt_JetEta0to3Down_branch
    cdef float j2pt_JetEta0to3Down_value

    cdef TBranch* j2pt_JetEta0to3Up_branch
    cdef float j2pt_JetEta0to3Up_value

    cdef TBranch* j2pt_JetEta0to5Down_branch
    cdef float j2pt_JetEta0to5Down_value

    cdef TBranch* j2pt_JetEta0to5Up_branch
    cdef float j2pt_JetEta0to5Up_value

    cdef TBranch* j2pt_JetEta3to5Down_branch
    cdef float j2pt_JetEta3to5Down_value

    cdef TBranch* j2pt_JetEta3to5Up_branch
    cdef float j2pt_JetEta3to5Up_value

    cdef TBranch* j2pt_JetRelativeBalDown_branch
    cdef float j2pt_JetRelativeBalDown_value

    cdef TBranch* j2pt_JetRelativeBalUp_branch
    cdef float j2pt_JetRelativeBalUp_value

    cdef TBranch* j2pt_JetRelativeSampleDown_branch
    cdef float j2pt_JetRelativeSampleDown_value

    cdef TBranch* j2pt_JetRelativeSampleUp_branch
    cdef float j2pt_JetRelativeSampleUp_value

    cdef TBranch* jb1eta_2016_branch
    cdef float jb1eta_2016_value

    cdef TBranch* jb1eta_2017_branch
    cdef float jb1eta_2017_value

    cdef TBranch* jb1eta_2018_branch
    cdef float jb1eta_2018_value

    cdef TBranch* jb1hadronflavor_2016_branch
    cdef float jb1hadronflavor_2016_value

    cdef TBranch* jb1hadronflavor_2017_branch
    cdef float jb1hadronflavor_2017_value

    cdef TBranch* jb1hadronflavor_2018_branch
    cdef float jb1hadronflavor_2018_value

    cdef TBranch* jb1phi_2016_branch
    cdef float jb1phi_2016_value

    cdef TBranch* jb1phi_2017_branch
    cdef float jb1phi_2017_value

    cdef TBranch* jb1phi_2018_branch
    cdef float jb1phi_2018_value

    cdef TBranch* jb1pt_2016_branch
    cdef float jb1pt_2016_value

    cdef TBranch* jb1pt_2017_branch
    cdef float jb1pt_2017_value

    cdef TBranch* jb1pt_2018_branch
    cdef float jb1pt_2018_value

    cdef TBranch* jb2eta_2016_branch
    cdef float jb2eta_2016_value

    cdef TBranch* jb2eta_2017_branch
    cdef float jb2eta_2017_value

    cdef TBranch* jb2eta_2018_branch
    cdef float jb2eta_2018_value

    cdef TBranch* jb2hadronflavor_2016_branch
    cdef float jb2hadronflavor_2016_value

    cdef TBranch* jb2hadronflavor_2017_branch
    cdef float jb2hadronflavor_2017_value

    cdef TBranch* jb2hadronflavor_2018_branch
    cdef float jb2hadronflavor_2018_value

    cdef TBranch* jb2phi_2016_branch
    cdef float jb2phi_2016_value

    cdef TBranch* jb2phi_2017_branch
    cdef float jb2phi_2017_value

    cdef TBranch* jb2phi_2018_branch
    cdef float jb2phi_2018_value

    cdef TBranch* jb2pt_2016_branch
    cdef float jb2pt_2016_value

    cdef TBranch* jb2pt_2017_branch
    cdef float jb2pt_2017_value

    cdef TBranch* jb2pt_2018_branch
    cdef float jb2pt_2018_value

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

    cdef TBranch* jetVeto30WoNoisyJets_JetEC2Down_branch
    cdef float jetVeto30WoNoisyJets_JetEC2Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEC2Up_branch
    cdef float jetVeto30WoNoisyJets_JetEC2Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEnDown_branch
    cdef float jetVeto30WoNoisyJets_JetEnDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEnUp_branch
    cdef float jetVeto30WoNoisyJets_JetEnUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEta0to3Down_branch
    cdef float jetVeto30WoNoisyJets_JetEta0to3Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEta0to3Up_branch
    cdef float jetVeto30WoNoisyJets_JetEta0to3Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEta0to5Down_branch
    cdef float jetVeto30WoNoisyJets_JetEta0to5Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEta0to5Up_branch
    cdef float jetVeto30WoNoisyJets_JetEta0to5Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEta3to5Down_branch
    cdef float jetVeto30WoNoisyJets_JetEta3to5Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEta3to5Up_branch
    cdef float jetVeto30WoNoisyJets_JetEta3to5Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeSampleDown_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeSampleDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeSampleUp_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeSampleUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetTotalDown_branch
    cdef float jetVeto30WoNoisyJets_JetTotalDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetTotalUp_branch
    cdef float jetVeto30WoNoisyJets_JetTotalUp_value

    cdef TBranch* jetVeto30_JetAbsoluteFlavMapDown_branch
    cdef float jetVeto30_JetAbsoluteFlavMapDown_value

    cdef TBranch* jetVeto30_JetAbsoluteFlavMapUp_branch
    cdef float jetVeto30_JetAbsoluteFlavMapUp_value

    cdef TBranch* jetVeto30_JetAbsoluteMPFBiasDown_branch
    cdef float jetVeto30_JetAbsoluteMPFBiasDown_value

    cdef TBranch* jetVeto30_JetAbsoluteMPFBiasUp_branch
    cdef float jetVeto30_JetAbsoluteMPFBiasUp_value

    cdef TBranch* jetVeto30_JetAbsoluteScaleDown_branch
    cdef float jetVeto30_JetAbsoluteScaleDown_value

    cdef TBranch* jetVeto30_JetAbsoluteScaleUp_branch
    cdef float jetVeto30_JetAbsoluteScaleUp_value

    cdef TBranch* jetVeto30_JetAbsoluteStatDown_branch
    cdef float jetVeto30_JetAbsoluteStatDown_value

    cdef TBranch* jetVeto30_JetAbsoluteStatUp_branch
    cdef float jetVeto30_JetAbsoluteStatUp_value

    cdef TBranch* jetVeto30_JetClosureDown_branch
    cdef float jetVeto30_JetClosureDown_value

    cdef TBranch* jetVeto30_JetClosureUp_branch
    cdef float jetVeto30_JetClosureUp_value

    cdef TBranch* jetVeto30_JetEC2Down_branch
    cdef float jetVeto30_JetEC2Down_value

    cdef TBranch* jetVeto30_JetEC2Up_branch
    cdef float jetVeto30_JetEC2Up_value

    cdef TBranch* jetVeto30_JetEnDown_branch
    cdef float jetVeto30_JetEnDown_value

    cdef TBranch* jetVeto30_JetEnUp_branch
    cdef float jetVeto30_JetEnUp_value

    cdef TBranch* jetVeto30_JetEta0to3Down_branch
    cdef float jetVeto30_JetEta0to3Down_value

    cdef TBranch* jetVeto30_JetEta0to3Up_branch
    cdef float jetVeto30_JetEta0to3Up_value

    cdef TBranch* jetVeto30_JetEta0to5Down_branch
    cdef float jetVeto30_JetEta0to5Down_value

    cdef TBranch* jetVeto30_JetEta0to5Up_branch
    cdef float jetVeto30_JetEta0to5Up_value

    cdef TBranch* jetVeto30_JetEta3to5Down_branch
    cdef float jetVeto30_JetEta3to5Down_value

    cdef TBranch* jetVeto30_JetEta3to5Up_branch
    cdef float jetVeto30_JetEta3to5Up_value

    cdef TBranch* jetVeto30_JetFlavorQCDDown_branch
    cdef float jetVeto30_JetFlavorQCDDown_value

    cdef TBranch* jetVeto30_JetFlavorQCDUp_branch
    cdef float jetVeto30_JetFlavorQCDUp_value

    cdef TBranch* jetVeto30_JetFragmentationDown_branch
    cdef float jetVeto30_JetFragmentationDown_value

    cdef TBranch* jetVeto30_JetFragmentationUp_branch
    cdef float jetVeto30_JetFragmentationUp_value

    cdef TBranch* jetVeto30_JetPileUpDataMCDown_branch
    cdef float jetVeto30_JetPileUpDataMCDown_value

    cdef TBranch* jetVeto30_JetPileUpDataMCUp_branch
    cdef float jetVeto30_JetPileUpDataMCUp_value

    cdef TBranch* jetVeto30_JetPileUpPtBBDown_branch
    cdef float jetVeto30_JetPileUpPtBBDown_value

    cdef TBranch* jetVeto30_JetPileUpPtBBUp_branch
    cdef float jetVeto30_JetPileUpPtBBUp_value

    cdef TBranch* jetVeto30_JetPileUpPtEC1Down_branch
    cdef float jetVeto30_JetPileUpPtEC1Down_value

    cdef TBranch* jetVeto30_JetPileUpPtEC1Up_branch
    cdef float jetVeto30_JetPileUpPtEC1Up_value

    cdef TBranch* jetVeto30_JetPileUpPtEC2Down_branch
    cdef float jetVeto30_JetPileUpPtEC2Down_value

    cdef TBranch* jetVeto30_JetPileUpPtEC2Up_branch
    cdef float jetVeto30_JetPileUpPtEC2Up_value

    cdef TBranch* jetVeto30_JetPileUpPtHFDown_branch
    cdef float jetVeto30_JetPileUpPtHFDown_value

    cdef TBranch* jetVeto30_JetPileUpPtHFUp_branch
    cdef float jetVeto30_JetPileUpPtHFUp_value

    cdef TBranch* jetVeto30_JetPileUpPtRefDown_branch
    cdef float jetVeto30_JetPileUpPtRefDown_value

    cdef TBranch* jetVeto30_JetPileUpPtRefUp_branch
    cdef float jetVeto30_JetPileUpPtRefUp_value

    cdef TBranch* jetVeto30_JetRelativeBalDown_branch
    cdef float jetVeto30_JetRelativeBalDown_value

    cdef TBranch* jetVeto30_JetRelativeBalUp_branch
    cdef float jetVeto30_JetRelativeBalUp_value

    cdef TBranch* jetVeto30_JetRelativeFSRDown_branch
    cdef float jetVeto30_JetRelativeFSRDown_value

    cdef TBranch* jetVeto30_JetRelativeFSRUp_branch
    cdef float jetVeto30_JetRelativeFSRUp_value

    cdef TBranch* jetVeto30_JetRelativeJEREC1Down_branch
    cdef float jetVeto30_JetRelativeJEREC1Down_value

    cdef TBranch* jetVeto30_JetRelativeJEREC1Up_branch
    cdef float jetVeto30_JetRelativeJEREC1Up_value

    cdef TBranch* jetVeto30_JetRelativeJEREC2Down_branch
    cdef float jetVeto30_JetRelativeJEREC2Down_value

    cdef TBranch* jetVeto30_JetRelativeJEREC2Up_branch
    cdef float jetVeto30_JetRelativeJEREC2Up_value

    cdef TBranch* jetVeto30_JetRelativeJERHFDown_branch
    cdef float jetVeto30_JetRelativeJERHFDown_value

    cdef TBranch* jetVeto30_JetRelativeJERHFUp_branch
    cdef float jetVeto30_JetRelativeJERHFUp_value

    cdef TBranch* jetVeto30_JetRelativePtBBDown_branch
    cdef float jetVeto30_JetRelativePtBBDown_value

    cdef TBranch* jetVeto30_JetRelativePtBBUp_branch
    cdef float jetVeto30_JetRelativePtBBUp_value

    cdef TBranch* jetVeto30_JetRelativePtEC1Down_branch
    cdef float jetVeto30_JetRelativePtEC1Down_value

    cdef TBranch* jetVeto30_JetRelativePtEC1Up_branch
    cdef float jetVeto30_JetRelativePtEC1Up_value

    cdef TBranch* jetVeto30_JetRelativePtEC2Down_branch
    cdef float jetVeto30_JetRelativePtEC2Down_value

    cdef TBranch* jetVeto30_JetRelativePtEC2Up_branch
    cdef float jetVeto30_JetRelativePtEC2Up_value

    cdef TBranch* jetVeto30_JetRelativePtHFDown_branch
    cdef float jetVeto30_JetRelativePtHFDown_value

    cdef TBranch* jetVeto30_JetRelativePtHFUp_branch
    cdef float jetVeto30_JetRelativePtHFUp_value

    cdef TBranch* jetVeto30_JetRelativeSampleDown_branch
    cdef float jetVeto30_JetRelativeSampleDown_value

    cdef TBranch* jetVeto30_JetRelativeSampleUp_branch
    cdef float jetVeto30_JetRelativeSampleUp_value

    cdef TBranch* jetVeto30_JetRelativeStatECDown_branch
    cdef float jetVeto30_JetRelativeStatECDown_value

    cdef TBranch* jetVeto30_JetRelativeStatECUp_branch
    cdef float jetVeto30_JetRelativeStatECUp_value

    cdef TBranch* jetVeto30_JetRelativeStatFSRDown_branch
    cdef float jetVeto30_JetRelativeStatFSRDown_value

    cdef TBranch* jetVeto30_JetRelativeStatFSRUp_branch
    cdef float jetVeto30_JetRelativeStatFSRUp_value

    cdef TBranch* jetVeto30_JetRelativeStatHFDown_branch
    cdef float jetVeto30_JetRelativeStatHFDown_value

    cdef TBranch* jetVeto30_JetRelativeStatHFUp_branch
    cdef float jetVeto30_JetRelativeStatHFUp_value

    cdef TBranch* jetVeto30_JetSinglePionECALDown_branch
    cdef float jetVeto30_JetSinglePionECALDown_value

    cdef TBranch* jetVeto30_JetSinglePionECALUp_branch
    cdef float jetVeto30_JetSinglePionECALUp_value

    cdef TBranch* jetVeto30_JetSinglePionHCALDown_branch
    cdef float jetVeto30_JetSinglePionHCALDown_value

    cdef TBranch* jetVeto30_JetSinglePionHCALUp_branch
    cdef float jetVeto30_JetSinglePionHCALUp_value

    cdef TBranch* jetVeto30_JetTimePtEtaDown_branch
    cdef float jetVeto30_JetTimePtEtaDown_value

    cdef TBranch* jetVeto30_JetTimePtEtaUp_branch
    cdef float jetVeto30_JetTimePtEtaUp_value

    cdef TBranch* jetVeto30_JetTotalDown_branch
    cdef float jetVeto30_JetTotalDown_value

    cdef TBranch* jetVeto30_JetTotalUp_branch
    cdef float jetVeto30_JetTotalUp_value

    cdef TBranch* lumi_branch
    cdef int lumi_value

    cdef TBranch* mBestTrackType_branch
    cdef float mBestTrackType_value

    cdef TBranch* mCharge_branch
    cdef float mCharge_value

    cdef TBranch* mChi2LocalPosition_branch
    cdef float mChi2LocalPosition_value

    cdef TBranch* mComesFromHiggs_branch
    cdef float mComesFromHiggs_value

    cdef TBranch* mEcalIsoDR03_branch
    cdef float mEcalIsoDR03_value

    cdef TBranch* mEta_branch
    cdef float mEta_value

    cdef TBranch* mGenCharge_branch
    cdef float mGenCharge_value

    cdef TBranch* mGenDirectPromptTauDecayFinalState_branch
    cdef float mGenDirectPromptTauDecayFinalState_value

    cdef TBranch* mGenEnergy_branch
    cdef float mGenEnergy_value

    cdef TBranch* mGenEta_branch
    cdef float mGenEta_value

    cdef TBranch* mGenIsPrompt_branch
    cdef float mGenIsPrompt_value

    cdef TBranch* mGenMotherPdgId_branch
    cdef float mGenMotherPdgId_value

    cdef TBranch* mGenParticle_branch
    cdef float mGenParticle_value

    cdef TBranch* mGenPdgId_branch
    cdef float mGenPdgId_value

    cdef TBranch* mGenPhi_branch
    cdef float mGenPhi_value

    cdef TBranch* mGenPrompt_branch
    cdef float mGenPrompt_value

    cdef TBranch* mGenPromptFinalState_branch
    cdef float mGenPromptFinalState_value

    cdef TBranch* mGenPromptTauDecay_branch
    cdef float mGenPromptTauDecay_value

    cdef TBranch* mGenPt_branch
    cdef float mGenPt_value

    cdef TBranch* mGenTauDecay_branch
    cdef float mGenTauDecay_value

    cdef TBranch* mGenVZ_branch
    cdef float mGenVZ_value

    cdef TBranch* mGenVtxPVMatch_branch
    cdef float mGenVtxPVMatch_value

    cdef TBranch* mHcalIsoDR03_branch
    cdef float mHcalIsoDR03_value

    cdef TBranch* mIP3D_branch
    cdef float mIP3D_value

    cdef TBranch* mIP3DErr_branch
    cdef float mIP3DErr_value

    cdef TBranch* mIsGlobal_branch
    cdef float mIsGlobal_value

    cdef TBranch* mIsPFMuon_branch
    cdef float mIsPFMuon_value

    cdef TBranch* mIsTracker_branch
    cdef float mIsTracker_value

    cdef TBranch* mIsoDB03_branch
    cdef float mIsoDB03_value

    cdef TBranch* mIsoDB04_branch
    cdef float mIsoDB04_value

    cdef TBranch* mJetArea_branch
    cdef float mJetArea_value

    cdef TBranch* mJetBtag_branch
    cdef float mJetBtag_value

    cdef TBranch* mJetDR_branch
    cdef float mJetDR_value

    cdef TBranch* mJetEtaEtaMoment_branch
    cdef float mJetEtaEtaMoment_value

    cdef TBranch* mJetEtaPhiMoment_branch
    cdef float mJetEtaPhiMoment_value

    cdef TBranch* mJetEtaPhiSpread_branch
    cdef float mJetEtaPhiSpread_value

    cdef TBranch* mJetHadronFlavour_branch
    cdef float mJetHadronFlavour_value

    cdef TBranch* mJetPFCISVBtag_branch
    cdef float mJetPFCISVBtag_value

    cdef TBranch* mJetPartonFlavour_branch
    cdef float mJetPartonFlavour_value

    cdef TBranch* mJetPhiPhiMoment_branch
    cdef float mJetPhiPhiMoment_value

    cdef TBranch* mJetPt_branch
    cdef float mJetPt_value

    cdef TBranch* mLowestMll_branch
    cdef float mLowestMll_value

    cdef TBranch* mMass_branch
    cdef float mMass_value

    cdef TBranch* mMatchEmbeddedFilterMu19Tau20_2016_branch
    cdef float mMatchEmbeddedFilterMu19Tau20_2016_value

    cdef TBranch* mMatchEmbeddedFilterMu20Tau27_2017_branch
    cdef float mMatchEmbeddedFilterMu20Tau27_2017_value

    cdef TBranch* mMatchEmbeddedFilterMu20Tau27_2018_branch
    cdef float mMatchEmbeddedFilterMu20Tau27_2018_value

    cdef TBranch* mMatchEmbeddedFilterMu24_branch
    cdef float mMatchEmbeddedFilterMu24_value

    cdef TBranch* mMatchEmbeddedFilterMu27_branch
    cdef float mMatchEmbeddedFilterMu27_value

    cdef TBranch* mMatchedStations_branch
    cdef float mMatchedStations_value

    cdef TBranch* mMatchesIsoMu19Tau20Filter_branch
    cdef float mMatchesIsoMu19Tau20Filter_value

    cdef TBranch* mMatchesIsoMu19Tau20Path_branch
    cdef float mMatchesIsoMu19Tau20Path_value

    cdef TBranch* mMatchesIsoMu19Tau20SingleL1Filter_branch
    cdef float mMatchesIsoMu19Tau20SingleL1Filter_value

    cdef TBranch* mMatchesIsoMu19Tau20SingleL1Path_branch
    cdef float mMatchesIsoMu19Tau20SingleL1Path_value

    cdef TBranch* mMatchesIsoMu20HPSTau27Filter_branch
    cdef float mMatchesIsoMu20HPSTau27Filter_value

    cdef TBranch* mMatchesIsoMu20HPSTau27Path_branch
    cdef float mMatchesIsoMu20HPSTau27Path_value

    cdef TBranch* mMatchesIsoMu20Tau27Filter_branch
    cdef float mMatchesIsoMu20Tau27Filter_value

    cdef TBranch* mMatchesIsoMu20Tau27Path_branch
    cdef float mMatchesIsoMu20Tau27Path_value

    cdef TBranch* mMatchesIsoMu24Filter_branch
    cdef float mMatchesIsoMu24Filter_value

    cdef TBranch* mMatchesIsoMu24Path_branch
    cdef float mMatchesIsoMu24Path_value

    cdef TBranch* mMatchesIsoMu27Filter_branch
    cdef float mMatchesIsoMu27Filter_value

    cdef TBranch* mMatchesIsoMu27Path_branch
    cdef float mMatchesIsoMu27Path_value

    cdef TBranch* mMatchesMu23e12DZFilter_branch
    cdef float mMatchesMu23e12DZFilter_value

    cdef TBranch* mMatchesMu23e12DZPath_branch
    cdef float mMatchesMu23e12DZPath_value

    cdef TBranch* mMatchesMu23e12Filter_branch
    cdef float mMatchesMu23e12Filter_value

    cdef TBranch* mMatchesMu23e12Path_branch
    cdef float mMatchesMu23e12Path_value

    cdef TBranch* mMatchesMu8e23DZFilter_branch
    cdef float mMatchesMu8e23DZFilter_value

    cdef TBranch* mMatchesMu8e23DZPath_branch
    cdef float mMatchesMu8e23DZPath_value

    cdef TBranch* mMatchesMu8e23Filter_branch
    cdef float mMatchesMu8e23Filter_value

    cdef TBranch* mMatchesMu8e23Path_branch
    cdef float mMatchesMu8e23Path_value

    cdef TBranch* mMiniIsoLoose_branch
    cdef float mMiniIsoLoose_value

    cdef TBranch* mMiniIsoMedium_branch
    cdef float mMiniIsoMedium_value

    cdef TBranch* mMiniIsoTight_branch
    cdef float mMiniIsoTight_value

    cdef TBranch* mMiniIsoVeryTight_branch
    cdef float mMiniIsoVeryTight_value

    cdef TBranch* mMuonHits_branch
    cdef float mMuonHits_value

    cdef TBranch* mMvaLoose_branch
    cdef float mMvaLoose_value

    cdef TBranch* mMvaMedium_branch
    cdef float mMvaMedium_value

    cdef TBranch* mMvaTight_branch
    cdef float mMvaTight_value

    cdef TBranch* mNearestZMass_branch
    cdef float mNearestZMass_value

    cdef TBranch* mNormTrkChi2_branch
    cdef float mNormTrkChi2_value

    cdef TBranch* mNormalizedChi2_branch
    cdef float mNormalizedChi2_value

    cdef TBranch* mPFChargedHadronIsoR04_branch
    cdef float mPFChargedHadronIsoR04_value

    cdef TBranch* mPFChargedIso_branch
    cdef float mPFChargedIso_value

    cdef TBranch* mPFIDLoose_branch
    cdef float mPFIDLoose_value

    cdef TBranch* mPFIDMedium_branch
    cdef float mPFIDMedium_value

    cdef TBranch* mPFIDTight_branch
    cdef float mPFIDTight_value

    cdef TBranch* mPFIsoLoose_branch
    cdef float mPFIsoLoose_value

    cdef TBranch* mPFIsoMedium_branch
    cdef float mPFIsoMedium_value

    cdef TBranch* mPFIsoTight_branch
    cdef float mPFIsoTight_value

    cdef TBranch* mPFNeutralHadronIsoR04_branch
    cdef float mPFNeutralHadronIsoR04_value

    cdef TBranch* mPFNeutralIso_branch
    cdef float mPFNeutralIso_value

    cdef TBranch* mPFPUChargedIso_branch
    cdef float mPFPUChargedIso_value

    cdef TBranch* mPFPhotonIso_branch
    cdef float mPFPhotonIso_value

    cdef TBranch* mPFPhotonIsoR04_branch
    cdef float mPFPhotonIsoR04_value

    cdef TBranch* mPFPileupIsoR04_branch
    cdef float mPFPileupIsoR04_value

    cdef TBranch* mPVDXY_branch
    cdef float mPVDXY_value

    cdef TBranch* mPVDZ_branch
    cdef float mPVDZ_value

    cdef TBranch* mPhi_branch
    cdef float mPhi_value

    cdef TBranch* mPixHits_branch
    cdef float mPixHits_value

    cdef TBranch* mPt_branch
    cdef float mPt_value

    cdef TBranch* mRelPFIsoDBDefault_branch
    cdef float mRelPFIsoDBDefault_value

    cdef TBranch* mRelPFIsoDBDefaultR04_branch
    cdef float mRelPFIsoDBDefaultR04_value

    cdef TBranch* mRelPFIsoRho_branch
    cdef float mRelPFIsoRho_value

    cdef TBranch* mRho_branch
    cdef float mRho_value

    cdef TBranch* mSIP2D_branch
    cdef float mSIP2D_value

    cdef TBranch* mSIP3D_branch
    cdef float mSIP3D_value

    cdef TBranch* mSegmentCompatibility_branch
    cdef float mSegmentCompatibility_value

    cdef TBranch* mTkLayersWithMeasurement_branch
    cdef float mTkLayersWithMeasurement_value

    cdef TBranch* mTrkIsoDR03_branch
    cdef float mTrkIsoDR03_value

    cdef TBranch* mTrkKink_branch
    cdef float mTrkKink_value

    cdef TBranch* mTypeCode_branch
    cdef int mTypeCode_value

    cdef TBranch* mVZ_branch
    cdef float mVZ_value

    cdef TBranch* mValidFraction_branch
    cdef float mValidFraction_value

    cdef TBranch* mZTTGenMatching_branch
    cdef float mZTTGenMatching_value

    cdef TBranch* metSig_branch
    cdef float metSig_value

    cdef TBranch* metcov00_branch
    cdef float metcov00_value

    cdef TBranch* metcov01_branch
    cdef float metcov01_value

    cdef TBranch* metcov10_branch
    cdef float metcov10_value

    cdef TBranch* metcov11_branch
    cdef float metcov11_value

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

    cdef TBranch* muVetoZTTp001dxyz_branch
    cdef float muVetoZTTp001dxyz_value

    cdef TBranch* nTruePU_branch
    cdef float nTruePU_value

    cdef TBranch* npNLO_branch
    cdef float npNLO_value

    cdef TBranch* numGenJets_branch
    cdef float numGenJets_value

    cdef TBranch* nvtx_branch
    cdef float nvtx_value

    cdef TBranch* prefiring_weight_branch
    cdef float prefiring_weight_value

    cdef TBranch* prefiring_weight_down_branch
    cdef float prefiring_weight_down_value

    cdef TBranch* prefiring_weight_up_branch
    cdef float prefiring_weight_up_value

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

    cdef TBranch* tauVetoPt20Loose3HitsVtx_branch
    cdef float tauVetoPt20Loose3HitsVtx_value

    cdef TBranch* tauVetoPt20LooseMVALTVtx_branch
    cdef float tauVetoPt20LooseMVALTVtx_value

    cdef TBranch* tauVetoPt20TightMVALTVtx_branch
    cdef float tauVetoPt20TightMVALTVtx_value

    cdef TBranch* topQuarkPt1_branch
    cdef float topQuarkPt1_value

    cdef TBranch* topQuarkPt2_branch
    cdef float topQuarkPt2_value

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

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteStatDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteStatUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetClosureDown_branch
    cdef float type1_pfMet_shiftedPhi_JetClosureDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetClosureUp_branch
    cdef float type1_pfMet_shiftedPhi_JetClosureUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEC2Down_branch
    cdef float type1_pfMet_shiftedPhi_JetEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEC2Up_branch
    cdef float type1_pfMet_shiftedPhi_JetEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEnDown_branch
    cdef float type1_pfMet_shiftedPhi_JetEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEnUp_branch
    cdef float type1_pfMet_shiftedPhi_JetEnUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEta0to3Down_branch
    cdef float type1_pfMet_shiftedPhi_JetEta0to3Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEta0to3Up_branch
    cdef float type1_pfMet_shiftedPhi_JetEta0to3Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEta0to5Down_branch
    cdef float type1_pfMet_shiftedPhi_JetEta0to5Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEta0to5Up_branch
    cdef float type1_pfMet_shiftedPhi_JetEta0to5Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEta3to5Down_branch
    cdef float type1_pfMet_shiftedPhi_JetEta3to5Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEta3to5Up_branch
    cdef float type1_pfMet_shiftedPhi_JetEta3to5Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch
    cdef float type1_pfMet_shiftedPhi_JetFlavorQCDDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch
    cdef float type1_pfMet_shiftedPhi_JetFlavorQCDUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetFragmentationDown_branch
    cdef float type1_pfMet_shiftedPhi_JetFragmentationDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetFragmentationUp_branch
    cdef float type1_pfMet_shiftedPhi_JetFragmentationUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpDataMCDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpDataMCUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtBBDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtBBUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtHFDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtHFUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtRefDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtRefUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeBalDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeBalDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeBalUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeBalUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeFSRDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeFSRUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeJERHFDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeJERHFUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtBBDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtBBUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtEC1Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtEC1Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtHFDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtHFUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeSampleDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeSampleUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeStatECDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeStatECUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeStatHFDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeStatHFUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetResDown_branch
    cdef float type1_pfMet_shiftedPhi_JetResDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetResUp_branch
    cdef float type1_pfMet_shiftedPhi_JetResUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch
    cdef float type1_pfMet_shiftedPhi_JetSinglePionECALDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch
    cdef float type1_pfMet_shiftedPhi_JetSinglePionECALUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch
    cdef float type1_pfMet_shiftedPhi_JetSinglePionHCALDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch
    cdef float type1_pfMet_shiftedPhi_JetSinglePionHCALUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch
    cdef float type1_pfMet_shiftedPhi_JetTimePtEtaDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch
    cdef float type1_pfMet_shiftedPhi_JetTimePtEtaUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetTotalDown_branch
    cdef float type1_pfMet_shiftedPhi_JetTotalDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetTotalUp_branch
    cdef float type1_pfMet_shiftedPhi_JetTotalUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesCHARGEDDown_branch
    cdef float type1_pfMet_shiftedPhi_UesCHARGEDDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesCHARGEDUp_branch
    cdef float type1_pfMet_shiftedPhi_UesCHARGEDUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesECALDown_branch
    cdef float type1_pfMet_shiftedPhi_UesECALDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesECALUp_branch
    cdef float type1_pfMet_shiftedPhi_UesECALUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesHCALDown_branch
    cdef float type1_pfMet_shiftedPhi_UesHCALDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesHCALUp_branch
    cdef float type1_pfMet_shiftedPhi_UesHCALUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesHFDown_branch
    cdef float type1_pfMet_shiftedPhi_UesHFDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesHFUp_branch
    cdef float type1_pfMet_shiftedPhi_UesHFUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_UnclusteredEnDown_branch
    cdef float type1_pfMet_shiftedPhi_UnclusteredEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_UnclusteredEnUp_branch
    cdef float type1_pfMet_shiftedPhi_UnclusteredEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteScaleDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteScaleUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteStatDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteStatUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetClosureDown_branch
    cdef float type1_pfMet_shiftedPt_JetClosureDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetClosureUp_branch
    cdef float type1_pfMet_shiftedPt_JetClosureUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEC2Down_branch
    cdef float type1_pfMet_shiftedPt_JetEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEC2Up_branch
    cdef float type1_pfMet_shiftedPt_JetEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEnDown_branch
    cdef float type1_pfMet_shiftedPt_JetEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEnUp_branch
    cdef float type1_pfMet_shiftedPt_JetEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEta0to3Down_branch
    cdef float type1_pfMet_shiftedPt_JetEta0to3Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEta0to3Up_branch
    cdef float type1_pfMet_shiftedPt_JetEta0to3Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEta0to5Down_branch
    cdef float type1_pfMet_shiftedPt_JetEta0to5Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEta0to5Up_branch
    cdef float type1_pfMet_shiftedPt_JetEta0to5Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEta3to5Down_branch
    cdef float type1_pfMet_shiftedPt_JetEta3to5Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEta3to5Up_branch
    cdef float type1_pfMet_shiftedPt_JetEta3to5Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetFlavorQCDDown_branch
    cdef float type1_pfMet_shiftedPt_JetFlavorQCDDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetFlavorQCDUp_branch
    cdef float type1_pfMet_shiftedPt_JetFlavorQCDUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetFragmentationDown_branch
    cdef float type1_pfMet_shiftedPt_JetFragmentationDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetFragmentationUp_branch
    cdef float type1_pfMet_shiftedPt_JetFragmentationUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpDataMCDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpDataMCUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtBBDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtBBUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtEC1Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtEC1Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtHFDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtHFUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtRefDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtRefUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeBalDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeBalDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeBalUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeBalUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeFSRDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeFSRDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeFSRUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeFSRUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeJEREC1Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeJEREC1Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeJEREC2Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeJEREC2Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeJERHFDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeJERHFUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtBBDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtBBDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtBBUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtBBUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtEC1Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtEC1Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtHFDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtHFDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtHFUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtHFUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeSampleDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeSampleDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeSampleUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeSampleUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeStatECDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeStatECDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeStatECUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeStatECUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeStatFSRDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeStatFSRUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeStatHFDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeStatHFUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetResDown_branch
    cdef float type1_pfMet_shiftedPt_JetResDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetResUp_branch
    cdef float type1_pfMet_shiftedPt_JetResUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetSinglePionECALDown_branch
    cdef float type1_pfMet_shiftedPt_JetSinglePionECALDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetSinglePionECALUp_branch
    cdef float type1_pfMet_shiftedPt_JetSinglePionECALUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch
    cdef float type1_pfMet_shiftedPt_JetSinglePionHCALDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch
    cdef float type1_pfMet_shiftedPt_JetSinglePionHCALUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetTimePtEtaDown_branch
    cdef float type1_pfMet_shiftedPt_JetTimePtEtaDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetTimePtEtaUp_branch
    cdef float type1_pfMet_shiftedPt_JetTimePtEtaUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetTotalDown_branch
    cdef float type1_pfMet_shiftedPt_JetTotalDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetTotalUp_branch
    cdef float type1_pfMet_shiftedPt_JetTotalUp_value

    cdef TBranch* type1_pfMet_shiftedPt_UesCHARGEDDown_branch
    cdef float type1_pfMet_shiftedPt_UesCHARGEDDown_value

    cdef TBranch* type1_pfMet_shiftedPt_UesCHARGEDUp_branch
    cdef float type1_pfMet_shiftedPt_UesCHARGEDUp_value

    cdef TBranch* type1_pfMet_shiftedPt_UesECALDown_branch
    cdef float type1_pfMet_shiftedPt_UesECALDown_value

    cdef TBranch* type1_pfMet_shiftedPt_UesECALUp_branch
    cdef float type1_pfMet_shiftedPt_UesECALUp_value

    cdef TBranch* type1_pfMet_shiftedPt_UesHCALDown_branch
    cdef float type1_pfMet_shiftedPt_UesHCALDown_value

    cdef TBranch* type1_pfMet_shiftedPt_UesHCALUp_branch
    cdef float type1_pfMet_shiftedPt_UesHCALUp_value

    cdef TBranch* type1_pfMet_shiftedPt_UesHFDown_branch
    cdef float type1_pfMet_shiftedPt_UesHFDown_value

    cdef TBranch* type1_pfMet_shiftedPt_UesHFUp_branch
    cdef float type1_pfMet_shiftedPt_UesHFUp_value

    cdef TBranch* type1_pfMet_shiftedPt_UnclusteredEnDown_branch
    cdef float type1_pfMet_shiftedPt_UnclusteredEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_UnclusteredEnUp_branch
    cdef float type1_pfMet_shiftedPt_UnclusteredEnUp_value

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

    cdef TBranch* vbfMassWoNoisyJets_JetEC2Down_branch
    cdef float vbfMassWoNoisyJets_JetEC2Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetEC2Up_branch
    cdef float vbfMassWoNoisyJets_JetEC2Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetEta0to3Down_branch
    cdef float vbfMassWoNoisyJets_JetEta0to3Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetEta0to3Up_branch
    cdef float vbfMassWoNoisyJets_JetEta0to3Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetEta0to5Down_branch
    cdef float vbfMassWoNoisyJets_JetEta0to5Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetEta0to5Up_branch
    cdef float vbfMassWoNoisyJets_JetEta0to5Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetEta3to5Down_branch
    cdef float vbfMassWoNoisyJets_JetEta3to5Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetEta3to5Up_branch
    cdef float vbfMassWoNoisyJets_JetEta3to5Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeBalDown_branch
    cdef float vbfMassWoNoisyJets_JetRelativeBalDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeBalUp_branch
    cdef float vbfMassWoNoisyJets_JetRelativeBalUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeSampleDown_branch
    cdef float vbfMassWoNoisyJets_JetRelativeSampleDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeSampleUp_branch
    cdef float vbfMassWoNoisyJets_JetRelativeSampleUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetTotalDown_branch
    cdef float vbfMassWoNoisyJets_JetTotalDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetTotalUp_branch
    cdef float vbfMassWoNoisyJets_JetTotalUp_value

    cdef TBranch* vbfMass_JetAbsoluteFlavMapDown_branch
    cdef float vbfMass_JetAbsoluteFlavMapDown_value

    cdef TBranch* vbfMass_JetAbsoluteFlavMapUp_branch
    cdef float vbfMass_JetAbsoluteFlavMapUp_value

    cdef TBranch* vbfMass_JetAbsoluteMPFBiasDown_branch
    cdef float vbfMass_JetAbsoluteMPFBiasDown_value

    cdef TBranch* vbfMass_JetAbsoluteMPFBiasUp_branch
    cdef float vbfMass_JetAbsoluteMPFBiasUp_value

    cdef TBranch* vbfMass_JetAbsoluteScaleDown_branch
    cdef float vbfMass_JetAbsoluteScaleDown_value

    cdef TBranch* vbfMass_JetAbsoluteScaleUp_branch
    cdef float vbfMass_JetAbsoluteScaleUp_value

    cdef TBranch* vbfMass_JetAbsoluteStatDown_branch
    cdef float vbfMass_JetAbsoluteStatDown_value

    cdef TBranch* vbfMass_JetAbsoluteStatUp_branch
    cdef float vbfMass_JetAbsoluteStatUp_value

    cdef TBranch* vbfMass_JetClosureDown_branch
    cdef float vbfMass_JetClosureDown_value

    cdef TBranch* vbfMass_JetClosureUp_branch
    cdef float vbfMass_JetClosureUp_value

    cdef TBranch* vbfMass_JetEC2Down_branch
    cdef float vbfMass_JetEC2Down_value

    cdef TBranch* vbfMass_JetEC2Up_branch
    cdef float vbfMass_JetEC2Up_value

    cdef TBranch* vbfMass_JetEta0to3Down_branch
    cdef float vbfMass_JetEta0to3Down_value

    cdef TBranch* vbfMass_JetEta0to3Up_branch
    cdef float vbfMass_JetEta0to3Up_value

    cdef TBranch* vbfMass_JetEta0to5Down_branch
    cdef float vbfMass_JetEta0to5Down_value

    cdef TBranch* vbfMass_JetEta0to5Up_branch
    cdef float vbfMass_JetEta0to5Up_value

    cdef TBranch* vbfMass_JetEta3to5Down_branch
    cdef float vbfMass_JetEta3to5Down_value

    cdef TBranch* vbfMass_JetEta3to5Up_branch
    cdef float vbfMass_JetEta3to5Up_value

    cdef TBranch* vbfMass_JetFlavorQCDDown_branch
    cdef float vbfMass_JetFlavorQCDDown_value

    cdef TBranch* vbfMass_JetFlavorQCDUp_branch
    cdef float vbfMass_JetFlavorQCDUp_value

    cdef TBranch* vbfMass_JetFragmentationDown_branch
    cdef float vbfMass_JetFragmentationDown_value

    cdef TBranch* vbfMass_JetFragmentationUp_branch
    cdef float vbfMass_JetFragmentationUp_value

    cdef TBranch* vbfMass_JetPileUpDataMCDown_branch
    cdef float vbfMass_JetPileUpDataMCDown_value

    cdef TBranch* vbfMass_JetPileUpDataMCUp_branch
    cdef float vbfMass_JetPileUpDataMCUp_value

    cdef TBranch* vbfMass_JetPileUpPtBBDown_branch
    cdef float vbfMass_JetPileUpPtBBDown_value

    cdef TBranch* vbfMass_JetPileUpPtBBUp_branch
    cdef float vbfMass_JetPileUpPtBBUp_value

    cdef TBranch* vbfMass_JetPileUpPtEC1Down_branch
    cdef float vbfMass_JetPileUpPtEC1Down_value

    cdef TBranch* vbfMass_JetPileUpPtEC1Up_branch
    cdef float vbfMass_JetPileUpPtEC1Up_value

    cdef TBranch* vbfMass_JetPileUpPtEC2Down_branch
    cdef float vbfMass_JetPileUpPtEC2Down_value

    cdef TBranch* vbfMass_JetPileUpPtEC2Up_branch
    cdef float vbfMass_JetPileUpPtEC2Up_value

    cdef TBranch* vbfMass_JetPileUpPtHFDown_branch
    cdef float vbfMass_JetPileUpPtHFDown_value

    cdef TBranch* vbfMass_JetPileUpPtHFUp_branch
    cdef float vbfMass_JetPileUpPtHFUp_value

    cdef TBranch* vbfMass_JetPileUpPtRefDown_branch
    cdef float vbfMass_JetPileUpPtRefDown_value

    cdef TBranch* vbfMass_JetPileUpPtRefUp_branch
    cdef float vbfMass_JetPileUpPtRefUp_value

    cdef TBranch* vbfMass_JetRelativeBalDown_branch
    cdef float vbfMass_JetRelativeBalDown_value

    cdef TBranch* vbfMass_JetRelativeBalUp_branch
    cdef float vbfMass_JetRelativeBalUp_value

    cdef TBranch* vbfMass_JetRelativeFSRDown_branch
    cdef float vbfMass_JetRelativeFSRDown_value

    cdef TBranch* vbfMass_JetRelativeFSRUp_branch
    cdef float vbfMass_JetRelativeFSRUp_value

    cdef TBranch* vbfMass_JetRelativeJEREC1Down_branch
    cdef float vbfMass_JetRelativeJEREC1Down_value

    cdef TBranch* vbfMass_JetRelativeJEREC1Up_branch
    cdef float vbfMass_JetRelativeJEREC1Up_value

    cdef TBranch* vbfMass_JetRelativeJEREC2Down_branch
    cdef float vbfMass_JetRelativeJEREC2Down_value

    cdef TBranch* vbfMass_JetRelativeJEREC2Up_branch
    cdef float vbfMass_JetRelativeJEREC2Up_value

    cdef TBranch* vbfMass_JetRelativeJERHFDown_branch
    cdef float vbfMass_JetRelativeJERHFDown_value

    cdef TBranch* vbfMass_JetRelativeJERHFUp_branch
    cdef float vbfMass_JetRelativeJERHFUp_value

    cdef TBranch* vbfMass_JetRelativePtBBDown_branch
    cdef float vbfMass_JetRelativePtBBDown_value

    cdef TBranch* vbfMass_JetRelativePtBBUp_branch
    cdef float vbfMass_JetRelativePtBBUp_value

    cdef TBranch* vbfMass_JetRelativePtEC1Down_branch
    cdef float vbfMass_JetRelativePtEC1Down_value

    cdef TBranch* vbfMass_JetRelativePtEC1Up_branch
    cdef float vbfMass_JetRelativePtEC1Up_value

    cdef TBranch* vbfMass_JetRelativePtEC2Down_branch
    cdef float vbfMass_JetRelativePtEC2Down_value

    cdef TBranch* vbfMass_JetRelativePtEC2Up_branch
    cdef float vbfMass_JetRelativePtEC2Up_value

    cdef TBranch* vbfMass_JetRelativePtHFDown_branch
    cdef float vbfMass_JetRelativePtHFDown_value

    cdef TBranch* vbfMass_JetRelativePtHFUp_branch
    cdef float vbfMass_JetRelativePtHFUp_value

    cdef TBranch* vbfMass_JetRelativeSampleDown_branch
    cdef float vbfMass_JetRelativeSampleDown_value

    cdef TBranch* vbfMass_JetRelativeSampleUp_branch
    cdef float vbfMass_JetRelativeSampleUp_value

    cdef TBranch* vbfMass_JetRelativeStatECDown_branch
    cdef float vbfMass_JetRelativeStatECDown_value

    cdef TBranch* vbfMass_JetRelativeStatECUp_branch
    cdef float vbfMass_JetRelativeStatECUp_value

    cdef TBranch* vbfMass_JetRelativeStatFSRDown_branch
    cdef float vbfMass_JetRelativeStatFSRDown_value

    cdef TBranch* vbfMass_JetRelativeStatFSRUp_branch
    cdef float vbfMass_JetRelativeStatFSRUp_value

    cdef TBranch* vbfMass_JetRelativeStatHFDown_branch
    cdef float vbfMass_JetRelativeStatHFDown_value

    cdef TBranch* vbfMass_JetRelativeStatHFUp_branch
    cdef float vbfMass_JetRelativeStatHFUp_value

    cdef TBranch* vbfMass_JetSinglePionECALDown_branch
    cdef float vbfMass_JetSinglePionECALDown_value

    cdef TBranch* vbfMass_JetSinglePionECALUp_branch
    cdef float vbfMass_JetSinglePionECALUp_value

    cdef TBranch* vbfMass_JetSinglePionHCALDown_branch
    cdef float vbfMass_JetSinglePionHCALDown_value

    cdef TBranch* vbfMass_JetSinglePionHCALUp_branch
    cdef float vbfMass_JetSinglePionHCALUp_value

    cdef TBranch* vbfMass_JetTimePtEtaDown_branch
    cdef float vbfMass_JetTimePtEtaDown_value

    cdef TBranch* vbfMass_JetTimePtEtaUp_branch
    cdef float vbfMass_JetTimePtEtaUp_value

    cdef TBranch* vbfMass_JetTotalDown_branch
    cdef float vbfMass_JetTotalDown_value

    cdef TBranch* vbfMass_JetTotalUp_branch
    cdef float vbfMass_JetTotalUp_value

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
            warnings.warn( "EMTree: Expected branch DoubleMediumHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35Pass")
        else:
            self.DoubleMediumHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35Pass_value)

        #print "making DoubleMediumHPSTau35TightIDPass"
        self.DoubleMediumHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau35TightIDPass")
        #if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass":
            warnings.warn( "EMTree: Expected branch DoubleMediumHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35TightIDPass")
        else:
            self.DoubleMediumHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35TightIDPass_value)

        #print "making DoubleMediumHPSTau40Pass"
        self.DoubleMediumHPSTau40Pass_branch = the_tree.GetBranch("DoubleMediumHPSTau40Pass")
        #if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass" not in self.complained:
        if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass":
            warnings.warn( "EMTree: Expected branch DoubleMediumHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40Pass")
        else:
            self.DoubleMediumHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40Pass_value)

        #print "making DoubleMediumHPSTau40TightIDPass"
        self.DoubleMediumHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau40TightIDPass")
        #if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass":
            warnings.warn( "EMTree: Expected branch DoubleMediumHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40TightIDPass")
        else:
            self.DoubleMediumHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40TightIDPass_value)

        #print "making DoubleMediumTau35Pass"
        self.DoubleMediumTau35Pass_branch = the_tree.GetBranch("DoubleMediumTau35Pass")
        #if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass" not in self.complained:
        if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass":
            warnings.warn( "EMTree: Expected branch DoubleMediumTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35Pass")
        else:
            self.DoubleMediumTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumTau35Pass_value)

        #print "making DoubleMediumTau35TightIDPass"
        self.DoubleMediumTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau35TightIDPass")
        #if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass":
            warnings.warn( "EMTree: Expected branch DoubleMediumTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35TightIDPass")
        else:
            self.DoubleMediumTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau35TightIDPass_value)

        #print "making DoubleMediumTau40Pass"
        self.DoubleMediumTau40Pass_branch = the_tree.GetBranch("DoubleMediumTau40Pass")
        #if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass" not in self.complained:
        if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass":
            warnings.warn( "EMTree: Expected branch DoubleMediumTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40Pass")
        else:
            self.DoubleMediumTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumTau40Pass_value)

        #print "making DoubleMediumTau40TightIDPass"
        self.DoubleMediumTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau40TightIDPass")
        #if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass":
            warnings.warn( "EMTree: Expected branch DoubleMediumTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40TightIDPass")
        else:
            self.DoubleMediumTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau40TightIDPass_value)

        #print "making DoubleTightHPSTau35Pass"
        self.DoubleTightHPSTau35Pass_branch = the_tree.GetBranch("DoubleTightHPSTau35Pass")
        #if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass" not in self.complained:
        if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass":
            warnings.warn( "EMTree: Expected branch DoubleTightHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35Pass")
        else:
            self.DoubleTightHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35Pass_value)

        #print "making DoubleTightHPSTau35TightIDPass"
        self.DoubleTightHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau35TightIDPass")
        #if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass":
            warnings.warn( "EMTree: Expected branch DoubleTightHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35TightIDPass")
        else:
            self.DoubleTightHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35TightIDPass_value)

        #print "making DoubleTightHPSTau40Pass"
        self.DoubleTightHPSTau40Pass_branch = the_tree.GetBranch("DoubleTightHPSTau40Pass")
        #if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass" not in self.complained:
        if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass":
            warnings.warn( "EMTree: Expected branch DoubleTightHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40Pass")
        else:
            self.DoubleTightHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40Pass_value)

        #print "making DoubleTightHPSTau40TightIDPass"
        self.DoubleTightHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau40TightIDPass")
        #if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass":
            warnings.warn( "EMTree: Expected branch DoubleTightHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40TightIDPass")
        else:
            self.DoubleTightHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40TightIDPass_value)

        #print "making DoubleTightTau35Pass"
        self.DoubleTightTau35Pass_branch = the_tree.GetBranch("DoubleTightTau35Pass")
        #if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass" not in self.complained:
        if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass":
            warnings.warn( "EMTree: Expected branch DoubleTightTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35Pass")
        else:
            self.DoubleTightTau35Pass_branch.SetAddress(<void*>&self.DoubleTightTau35Pass_value)

        #print "making DoubleTightTau35TightIDPass"
        self.DoubleTightTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightTau35TightIDPass")
        #if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass" not in self.complained:
        if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass":
            warnings.warn( "EMTree: Expected branch DoubleTightTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35TightIDPass")
        else:
            self.DoubleTightTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau35TightIDPass_value)

        #print "making DoubleTightTau40Pass"
        self.DoubleTightTau40Pass_branch = the_tree.GetBranch("DoubleTightTau40Pass")
        #if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass" not in self.complained:
        if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass":
            warnings.warn( "EMTree: Expected branch DoubleTightTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40Pass")
        else:
            self.DoubleTightTau40Pass_branch.SetAddress(<void*>&self.DoubleTightTau40Pass_value)

        #print "making DoubleTightTau40TightIDPass"
        self.DoubleTightTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightTau40TightIDPass")
        #if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass" not in self.complained:
        if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass":
            warnings.warn( "EMTree: Expected branch DoubleTightTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40TightIDPass")
        else:
            self.DoubleTightTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau40TightIDPass_value)

        #print "making Ele24LooseHPSTau30Pass"
        self.Ele24LooseHPSTau30Pass_branch = the_tree.GetBranch("Ele24LooseHPSTau30Pass")
        #if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass" not in self.complained:
        if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass":
            warnings.warn( "EMTree: Expected branch Ele24LooseHPSTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30Pass")
        else:
            self.Ele24LooseHPSTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30Pass_value)

        #print "making Ele24LooseHPSTau30TightIDPass"
        self.Ele24LooseHPSTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseHPSTau30TightIDPass")
        #if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass":
            warnings.warn( "EMTree: Expected branch Ele24LooseHPSTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30TightIDPass")
        else:
            self.Ele24LooseHPSTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30TightIDPass_value)

        #print "making Ele24LooseTau30Pass"
        self.Ele24LooseTau30Pass_branch = the_tree.GetBranch("Ele24LooseTau30Pass")
        #if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass" not in self.complained:
        if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass":
            warnings.warn( "EMTree: Expected branch Ele24LooseTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30Pass")
        else:
            self.Ele24LooseTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseTau30Pass_value)

        #print "making Ele24LooseTau30TightIDPass"
        self.Ele24LooseTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseTau30TightIDPass")
        #if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass":
            warnings.warn( "EMTree: Expected branch Ele24LooseTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30TightIDPass")
        else:
            self.Ele24LooseTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseTau30TightIDPass_value)

        #print "making Ele27WPTightPass"
        self.Ele27WPTightPass_branch = the_tree.GetBranch("Ele27WPTightPass")
        #if not self.Ele27WPTightPass_branch and "Ele27WPTightPass" not in self.complained:
        if not self.Ele27WPTightPass_branch and "Ele27WPTightPass":
            warnings.warn( "EMTree: Expected branch Ele27WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele27WPTightPass")
        else:
            self.Ele27WPTightPass_branch.SetAddress(<void*>&self.Ele27WPTightPass_value)

        #print "making Ele32WPTightPass"
        self.Ele32WPTightPass_branch = the_tree.GetBranch("Ele32WPTightPass")
        #if not self.Ele32WPTightPass_branch and "Ele32WPTightPass" not in self.complained:
        if not self.Ele32WPTightPass_branch and "Ele32WPTightPass":
            warnings.warn( "EMTree: Expected branch Ele32WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele32WPTightPass")
        else:
            self.Ele32WPTightPass_branch.SetAddress(<void*>&self.Ele32WPTightPass_value)

        #print "making Ele35WPTightPass"
        self.Ele35WPTightPass_branch = the_tree.GetBranch("Ele35WPTightPass")
        #if not self.Ele35WPTightPass_branch and "Ele35WPTightPass" not in self.complained:
        if not self.Ele35WPTightPass_branch and "Ele35WPTightPass":
            warnings.warn( "EMTree: Expected branch Ele35WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele35WPTightPass")
        else:
            self.Ele35WPTightPass_branch.SetAddress(<void*>&self.Ele35WPTightPass_value)

        #print "making Ele38WPTightPass"
        self.Ele38WPTightPass_branch = the_tree.GetBranch("Ele38WPTightPass")
        #if not self.Ele38WPTightPass_branch and "Ele38WPTightPass" not in self.complained:
        if not self.Ele38WPTightPass_branch and "Ele38WPTightPass":
            warnings.warn( "EMTree: Expected branch Ele38WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele38WPTightPass")
        else:
            self.Ele38WPTightPass_branch.SetAddress(<void*>&self.Ele38WPTightPass_value)

        #print "making Ele40WPTightPass"
        self.Ele40WPTightPass_branch = the_tree.GetBranch("Ele40WPTightPass")
        #if not self.Ele40WPTightPass_branch and "Ele40WPTightPass" not in self.complained:
        if not self.Ele40WPTightPass_branch and "Ele40WPTightPass":
            warnings.warn( "EMTree: Expected branch Ele40WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele40WPTightPass")
        else:
            self.Ele40WPTightPass_branch.SetAddress(<void*>&self.Ele40WPTightPass_value)

        #print "making EmbPtWeight"
        self.EmbPtWeight_branch = the_tree.GetBranch("EmbPtWeight")
        #if not self.EmbPtWeight_branch and "EmbPtWeight" not in self.complained:
        if not self.EmbPtWeight_branch and "EmbPtWeight":
            warnings.warn( "EMTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "EMTree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "EMTree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making Flag_BadPFMuonFilter"
        self.Flag_BadPFMuonFilter_branch = the_tree.GetBranch("Flag_BadPFMuonFilter")
        #if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter" not in self.complained:
        if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter":
            warnings.warn( "EMTree: Expected branch Flag_BadPFMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonFilter")
        else:
            self.Flag_BadPFMuonFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonFilter_value)

        #print "making Flag_EcalDeadCellTriggerPrimitiveFilter"
        self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch = the_tree.GetBranch("Flag_EcalDeadCellTriggerPrimitiveFilter")
        #if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter" not in self.complained:
        if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter":
            warnings.warn( "EMTree: Expected branch Flag_EcalDeadCellTriggerPrimitiveFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_EcalDeadCellTriggerPrimitiveFilter")
        else:
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.SetAddress(<void*>&self.Flag_EcalDeadCellTriggerPrimitiveFilter_value)

        #print "making Flag_HBHENoiseFilter"
        self.Flag_HBHENoiseFilter_branch = the_tree.GetBranch("Flag_HBHENoiseFilter")
        #if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter" not in self.complained:
        if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter":
            warnings.warn( "EMTree: Expected branch Flag_HBHENoiseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseFilter")
        else:
            self.Flag_HBHENoiseFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseFilter_value)

        #print "making Flag_HBHENoiseIsoFilter"
        self.Flag_HBHENoiseIsoFilter_branch = the_tree.GetBranch("Flag_HBHENoiseIsoFilter")
        #if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter" not in self.complained:
        if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter":
            warnings.warn( "EMTree: Expected branch Flag_HBHENoiseIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseIsoFilter")
        else:
            self.Flag_HBHENoiseIsoFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseIsoFilter_value)

        #print "making Flag_badMuons"
        self.Flag_badMuons_branch = the_tree.GetBranch("Flag_badMuons")
        #if not self.Flag_badMuons_branch and "Flag_badMuons" not in self.complained:
        if not self.Flag_badMuons_branch and "Flag_badMuons":
            warnings.warn( "EMTree: Expected branch Flag_badMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badMuons")
        else:
            self.Flag_badMuons_branch.SetAddress(<void*>&self.Flag_badMuons_value)

        #print "making Flag_duplicateMuons"
        self.Flag_duplicateMuons_branch = the_tree.GetBranch("Flag_duplicateMuons")
        #if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons" not in self.complained:
        if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons":
            warnings.warn( "EMTree: Expected branch Flag_duplicateMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_duplicateMuons")
        else:
            self.Flag_duplicateMuons_branch.SetAddress(<void*>&self.Flag_duplicateMuons_value)

        #print "making Flag_ecalBadCalibFilter"
        self.Flag_ecalBadCalibFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibFilter")
        #if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter" not in self.complained:
        if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter":
            warnings.warn( "EMTree: Expected branch Flag_ecalBadCalibFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibFilter")
        else:
            self.Flag_ecalBadCalibFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibFilter_value)

        #print "making Flag_ecalBadCalibReducedMINIAODFilter"
        self.Flag_ecalBadCalibReducedMINIAODFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibReducedMINIAODFilter")
        #if not self.Flag_ecalBadCalibReducedMINIAODFilter_branch and "Flag_ecalBadCalibReducedMINIAODFilter" not in self.complained:
        if not self.Flag_ecalBadCalibReducedMINIAODFilter_branch and "Flag_ecalBadCalibReducedMINIAODFilter":
            warnings.warn( "EMTree: Expected branch Flag_ecalBadCalibReducedMINIAODFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibReducedMINIAODFilter")
        else:
            self.Flag_ecalBadCalibReducedMINIAODFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibReducedMINIAODFilter_value)

        #print "making Flag_eeBadScFilter"
        self.Flag_eeBadScFilter_branch = the_tree.GetBranch("Flag_eeBadScFilter")
        #if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter" not in self.complained:
        if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter":
            warnings.warn( "EMTree: Expected branch Flag_eeBadScFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_eeBadScFilter")
        else:
            self.Flag_eeBadScFilter_branch.SetAddress(<void*>&self.Flag_eeBadScFilter_value)

        #print "making Flag_globalSuperTightHalo2016Filter"
        self.Flag_globalSuperTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalSuperTightHalo2016Filter")
        #if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter":
            warnings.warn( "EMTree: Expected branch Flag_globalSuperTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalSuperTightHalo2016Filter")
        else:
            self.Flag_globalSuperTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalSuperTightHalo2016Filter_value)

        #print "making Flag_globalTightHalo2016Filter"
        self.Flag_globalTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalTightHalo2016Filter")
        #if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter":
            warnings.warn( "EMTree: Expected branch Flag_globalTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalTightHalo2016Filter")
        else:
            self.Flag_globalTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalTightHalo2016Filter_value)

        #print "making Flag_goodVertices"
        self.Flag_goodVertices_branch = the_tree.GetBranch("Flag_goodVertices")
        #if not self.Flag_goodVertices_branch and "Flag_goodVertices" not in self.complained:
        if not self.Flag_goodVertices_branch and "Flag_goodVertices":
            warnings.warn( "EMTree: Expected branch Flag_goodVertices does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_goodVertices")
        else:
            self.Flag_goodVertices_branch.SetAddress(<void*>&self.Flag_goodVertices_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "EMTree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "EMTree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

        #print "making IsoMu24Pass"
        self.IsoMu24Pass_branch = the_tree.GetBranch("IsoMu24Pass")
        #if not self.IsoMu24Pass_branch and "IsoMu24Pass" not in self.complained:
        if not self.IsoMu24Pass_branch and "IsoMu24Pass":
            warnings.warn( "EMTree: Expected branch IsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24Pass")
        else:
            self.IsoMu24Pass_branch.SetAddress(<void*>&self.IsoMu24Pass_value)

        #print "making IsoMu27Pass"
        self.IsoMu27Pass_branch = the_tree.GetBranch("IsoMu27Pass")
        #if not self.IsoMu27Pass_branch and "IsoMu27Pass" not in self.complained:
        if not self.IsoMu27Pass_branch and "IsoMu27Pass":
            warnings.warn( "EMTree: Expected branch IsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu27Pass")
        else:
            self.IsoMu27Pass_branch.SetAddress(<void*>&self.IsoMu27Pass_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "EMTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "EMTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "EMTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "EMTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "EMTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "EMTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "EMTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "EMTree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making Mu20LooseHPSTau27Pass"
        self.Mu20LooseHPSTau27Pass_branch = the_tree.GetBranch("Mu20LooseHPSTau27Pass")
        #if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass" not in self.complained:
        if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass":
            warnings.warn( "EMTree: Expected branch Mu20LooseHPSTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27Pass")
        else:
            self.Mu20LooseHPSTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27Pass_value)

        #print "making Mu20LooseHPSTau27TightIDPass"
        self.Mu20LooseHPSTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseHPSTau27TightIDPass")
        #if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass":
            warnings.warn( "EMTree: Expected branch Mu20LooseHPSTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27TightIDPass")
        else:
            self.Mu20LooseHPSTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27TightIDPass_value)

        #print "making Mu20LooseTau27Pass"
        self.Mu20LooseTau27Pass_branch = the_tree.GetBranch("Mu20LooseTau27Pass")
        #if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass" not in self.complained:
        if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass":
            warnings.warn( "EMTree: Expected branch Mu20LooseTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27Pass")
        else:
            self.Mu20LooseTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseTau27Pass_value)

        #print "making Mu20LooseTau27TightIDPass"
        self.Mu20LooseTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseTau27TightIDPass")
        #if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass":
            warnings.warn( "EMTree: Expected branch Mu20LooseTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27TightIDPass")
        else:
            self.Mu20LooseTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseTau27TightIDPass_value)

        #print "making Mu50Pass"
        self.Mu50Pass_branch = the_tree.GetBranch("Mu50Pass")
        #if not self.Mu50Pass_branch and "Mu50Pass" not in self.complained:
        if not self.Mu50Pass_branch and "Mu50Pass":
            warnings.warn( "EMTree: Expected branch Mu50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Pass")
        else:
            self.Mu50Pass_branch.SetAddress(<void*>&self.Mu50Pass_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "EMTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "EMTree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "EMTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making VBFDoubleLooseHPSTau20Pass"
        self.VBFDoubleLooseHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseHPSTau20Pass")
        #if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass":
            warnings.warn( "EMTree: Expected branch VBFDoubleLooseHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseHPSTau20Pass")
        else:
            self.VBFDoubleLooseHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseHPSTau20Pass_value)

        #print "making VBFDoubleLooseTau20Pass"
        self.VBFDoubleLooseTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseTau20Pass")
        #if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass":
            warnings.warn( "EMTree: Expected branch VBFDoubleLooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseTau20Pass")
        else:
            self.VBFDoubleLooseTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseTau20Pass_value)

        #print "making VBFDoubleMediumHPSTau20Pass"
        self.VBFDoubleMediumHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumHPSTau20Pass")
        #if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass":
            warnings.warn( "EMTree: Expected branch VBFDoubleMediumHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumHPSTau20Pass")
        else:
            self.VBFDoubleMediumHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumHPSTau20Pass_value)

        #print "making VBFDoubleMediumTau20Pass"
        self.VBFDoubleMediumTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumTau20Pass")
        #if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass":
            warnings.warn( "EMTree: Expected branch VBFDoubleMediumTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumTau20Pass")
        else:
            self.VBFDoubleMediumTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumTau20Pass_value)

        #print "making VBFDoubleTightHPSTau20Pass"
        self.VBFDoubleTightHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightHPSTau20Pass")
        #if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass":
            warnings.warn( "EMTree: Expected branch VBFDoubleTightHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightHPSTau20Pass")
        else:
            self.VBFDoubleTightHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightHPSTau20Pass_value)

        #print "making VBFDoubleTightTau20Pass"
        self.VBFDoubleTightTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightTau20Pass")
        #if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass" not in self.complained:
        if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass":
            warnings.warn( "EMTree: Expected branch VBFDoubleTightTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightTau20Pass")
        else:
            self.VBFDoubleTightTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightTau20Pass_value)

        #print "making bjetDeepCSVVeto20Loose_2016_DR0p5"
        self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Loose_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2017_DR0p5"
        self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Loose_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2018_DR0p5"
        self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Loose_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0"
        self.bjetDeepCSVVeto20Medium_2016_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0p5"
        self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0"
        self.bjetDeepCSVVeto20Medium_2017_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0p5"
        self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0"
        self.bjetDeepCSVVeto20Medium_2018_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0p5"
        self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2016_DR0p5"
        self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Tight_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2017_DR0p5"
        self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Tight_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2018_DR0p5"
        self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Tight_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2018_DR0p5_value)

        #print "making bweight_2016"
        self.bweight_2016_branch = the_tree.GetBranch("bweight_2016")
        #if not self.bweight_2016_branch and "bweight_2016" not in self.complained:
        if not self.bweight_2016_branch and "bweight_2016":
            warnings.warn( "EMTree: Expected branch bweight_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2016")
        else:
            self.bweight_2016_branch.SetAddress(<void*>&self.bweight_2016_value)

        #print "making bweight_2017"
        self.bweight_2017_branch = the_tree.GetBranch("bweight_2017")
        #if not self.bweight_2017_branch and "bweight_2017" not in self.complained:
        if not self.bweight_2017_branch and "bweight_2017":
            warnings.warn( "EMTree: Expected branch bweight_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2017")
        else:
            self.bweight_2017_branch.SetAddress(<void*>&self.bweight_2017_value)

        #print "making bweight_2018"
        self.bweight_2018_branch = the_tree.GetBranch("bweight_2018")
        #if not self.bweight_2018_branch and "bweight_2018" not in self.complained:
        if not self.bweight_2018_branch and "bweight_2018":
            warnings.warn( "EMTree: Expected branch bweight_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2018")
        else:
            self.bweight_2018_branch.SetAddress(<void*>&self.bweight_2018_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "EMTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "EMTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimu9ele9Pass"
        self.dimu9ele9Pass_branch = the_tree.GetBranch("dimu9ele9Pass")
        #if not self.dimu9ele9Pass_branch and "dimu9ele9Pass" not in self.complained:
        if not self.dimu9ele9Pass_branch and "dimu9ele9Pass":
            warnings.warn( "EMTree: Expected branch dimu9ele9Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimu9ele9Pass")
        else:
            self.dimu9ele9Pass_branch.SetAddress(<void*>&self.dimu9ele9Pass_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "EMTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making doubleE25Pass"
        self.doubleE25Pass_branch = the_tree.GetBranch("doubleE25Pass")
        #if not self.doubleE25Pass_branch and "doubleE25Pass" not in self.complained:
        if not self.doubleE25Pass_branch and "doubleE25Pass":
            warnings.warn( "EMTree: Expected branch doubleE25Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE25Pass")
        else:
            self.doubleE25Pass_branch.SetAddress(<void*>&self.doubleE25Pass_value)

        #print "making doubleE33Pass"
        self.doubleE33Pass_branch = the_tree.GetBranch("doubleE33Pass")
        #if not self.doubleE33Pass_branch and "doubleE33Pass" not in self.complained:
        if not self.doubleE33Pass_branch and "doubleE33Pass":
            warnings.warn( "EMTree: Expected branch doubleE33Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE33Pass")
        else:
            self.doubleE33Pass_branch.SetAddress(<void*>&self.doubleE33Pass_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "EMTree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleMuDZminMass3p8Pass"
        self.doubleMuDZminMass3p8Pass_branch = the_tree.GetBranch("doubleMuDZminMass3p8Pass")
        #if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass" not in self.complained:
        if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass":
            warnings.warn( "EMTree: Expected branch doubleMuDZminMass3p8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass3p8Pass")
        else:
            self.doubleMuDZminMass3p8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass3p8Pass_value)

        #print "making doubleMuDZminMass8Pass"
        self.doubleMuDZminMass8Pass_branch = the_tree.GetBranch("doubleMuDZminMass8Pass")
        #if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass" not in self.complained:
        if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass":
            warnings.warn( "EMTree: Expected branch doubleMuDZminMass8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass8Pass")
        else:
            self.doubleMuDZminMass8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass8Pass_value)

        #print "making doubleMuSingleEPass"
        self.doubleMuSingleEPass_branch = the_tree.GetBranch("doubleMuSingleEPass")
        #if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass" not in self.complained:
        if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass":
            warnings.warn( "EMTree: Expected branch doubleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPass")
        else:
            self.doubleMuSingleEPass_branch.SetAddress(<void*>&self.doubleMuSingleEPass_value)

        #print "making doubleTau35Pass"
        self.doubleTau35Pass_branch = the_tree.GetBranch("doubleTau35Pass")
        #if not self.doubleTau35Pass_branch and "doubleTau35Pass" not in self.complained:
        if not self.doubleTau35Pass_branch and "doubleTau35Pass":
            warnings.warn( "EMTree: Expected branch doubleTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Pass")
        else:
            self.doubleTau35Pass_branch.SetAddress(<void*>&self.doubleTau35Pass_value)

        #print "making doubleTauCmbIso35RegPass"
        self.doubleTauCmbIso35RegPass_branch = the_tree.GetBranch("doubleTauCmbIso35RegPass")
        #if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass" not in self.complained:
        if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass":
            warnings.warn( "EMTree: Expected branch doubleTauCmbIso35RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPass")
        else:
            self.doubleTauCmbIso35RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPass_value)

        #print "making eCharge"
        self.eCharge_branch = the_tree.GetBranch("eCharge")
        #if not self.eCharge_branch and "eCharge" not in self.complained:
        if not self.eCharge_branch and "eCharge":
            warnings.warn( "EMTree: Expected branch eCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCharge")
        else:
            self.eCharge_branch.SetAddress(<void*>&self.eCharge_value)

        #print "making eChargeIdLoose"
        self.eChargeIdLoose_branch = the_tree.GetBranch("eChargeIdLoose")
        #if not self.eChargeIdLoose_branch and "eChargeIdLoose" not in self.complained:
        if not self.eChargeIdLoose_branch and "eChargeIdLoose":
            warnings.warn( "EMTree: Expected branch eChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdLoose")
        else:
            self.eChargeIdLoose_branch.SetAddress(<void*>&self.eChargeIdLoose_value)

        #print "making eChargeIdMed"
        self.eChargeIdMed_branch = the_tree.GetBranch("eChargeIdMed")
        #if not self.eChargeIdMed_branch and "eChargeIdMed" not in self.complained:
        if not self.eChargeIdMed_branch and "eChargeIdMed":
            warnings.warn( "EMTree: Expected branch eChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdMed")
        else:
            self.eChargeIdMed_branch.SetAddress(<void*>&self.eChargeIdMed_value)

        #print "making eChargeIdTight"
        self.eChargeIdTight_branch = the_tree.GetBranch("eChargeIdTight")
        #if not self.eChargeIdTight_branch and "eChargeIdTight" not in self.complained:
        if not self.eChargeIdTight_branch and "eChargeIdTight":
            warnings.warn( "EMTree: Expected branch eChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdTight")
        else:
            self.eChargeIdTight_branch.SetAddress(<void*>&self.eChargeIdTight_value)

        #print "making eComesFromHiggs"
        self.eComesFromHiggs_branch = the_tree.GetBranch("eComesFromHiggs")
        #if not self.eComesFromHiggs_branch and "eComesFromHiggs" not in self.complained:
        if not self.eComesFromHiggs_branch and "eComesFromHiggs":
            warnings.warn( "EMTree: Expected branch eComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eComesFromHiggs")
        else:
            self.eComesFromHiggs_branch.SetAddress(<void*>&self.eComesFromHiggs_value)

        #print "making eCorrectedEt"
        self.eCorrectedEt_branch = the_tree.GetBranch("eCorrectedEt")
        #if not self.eCorrectedEt_branch and "eCorrectedEt" not in self.complained:
        if not self.eCorrectedEt_branch and "eCorrectedEt":
            warnings.warn( "EMTree: Expected branch eCorrectedEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCorrectedEt")
        else:
            self.eCorrectedEt_branch.SetAddress(<void*>&self.eCorrectedEt_value)

        #print "making eEcalIsoDR03"
        self.eEcalIsoDR03_branch = the_tree.GetBranch("eEcalIsoDR03")
        #if not self.eEcalIsoDR03_branch and "eEcalIsoDR03" not in self.complained:
        if not self.eEcalIsoDR03_branch and "eEcalIsoDR03":
            warnings.warn( "EMTree: Expected branch eEcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEcalIsoDR03")
        else:
            self.eEcalIsoDR03_branch.SetAddress(<void*>&self.eEcalIsoDR03_value)

        #print "making eEnergyError"
        self.eEnergyError_branch = the_tree.GetBranch("eEnergyError")
        #if not self.eEnergyError_branch and "eEnergyError" not in self.complained:
        if not self.eEnergyError_branch and "eEnergyError":
            warnings.warn( "EMTree: Expected branch eEnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyError")
        else:
            self.eEnergyError_branch.SetAddress(<void*>&self.eEnergyError_value)

        #print "making eEnergyScaleDown"
        self.eEnergyScaleDown_branch = the_tree.GetBranch("eEnergyScaleDown")
        #if not self.eEnergyScaleDown_branch and "eEnergyScaleDown" not in self.complained:
        if not self.eEnergyScaleDown_branch and "eEnergyScaleDown":
            warnings.warn( "EMTree: Expected branch eEnergyScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleDown")
        else:
            self.eEnergyScaleDown_branch.SetAddress(<void*>&self.eEnergyScaleDown_value)

        #print "making eEnergyScaleGainDown"
        self.eEnergyScaleGainDown_branch = the_tree.GetBranch("eEnergyScaleGainDown")
        #if not self.eEnergyScaleGainDown_branch and "eEnergyScaleGainDown" not in self.complained:
        if not self.eEnergyScaleGainDown_branch and "eEnergyScaleGainDown":
            warnings.warn( "EMTree: Expected branch eEnergyScaleGainDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleGainDown")
        else:
            self.eEnergyScaleGainDown_branch.SetAddress(<void*>&self.eEnergyScaleGainDown_value)

        #print "making eEnergyScaleGainUp"
        self.eEnergyScaleGainUp_branch = the_tree.GetBranch("eEnergyScaleGainUp")
        #if not self.eEnergyScaleGainUp_branch and "eEnergyScaleGainUp" not in self.complained:
        if not self.eEnergyScaleGainUp_branch and "eEnergyScaleGainUp":
            warnings.warn( "EMTree: Expected branch eEnergyScaleGainUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleGainUp")
        else:
            self.eEnergyScaleGainUp_branch.SetAddress(<void*>&self.eEnergyScaleGainUp_value)

        #print "making eEnergyScaleStatDown"
        self.eEnergyScaleStatDown_branch = the_tree.GetBranch("eEnergyScaleStatDown")
        #if not self.eEnergyScaleStatDown_branch and "eEnergyScaleStatDown" not in self.complained:
        if not self.eEnergyScaleStatDown_branch and "eEnergyScaleStatDown":
            warnings.warn( "EMTree: Expected branch eEnergyScaleStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleStatDown")
        else:
            self.eEnergyScaleStatDown_branch.SetAddress(<void*>&self.eEnergyScaleStatDown_value)

        #print "making eEnergyScaleStatUp"
        self.eEnergyScaleStatUp_branch = the_tree.GetBranch("eEnergyScaleStatUp")
        #if not self.eEnergyScaleStatUp_branch and "eEnergyScaleStatUp" not in self.complained:
        if not self.eEnergyScaleStatUp_branch and "eEnergyScaleStatUp":
            warnings.warn( "EMTree: Expected branch eEnergyScaleStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleStatUp")
        else:
            self.eEnergyScaleStatUp_branch.SetAddress(<void*>&self.eEnergyScaleStatUp_value)

        #print "making eEnergyScaleSystDown"
        self.eEnergyScaleSystDown_branch = the_tree.GetBranch("eEnergyScaleSystDown")
        #if not self.eEnergyScaleSystDown_branch and "eEnergyScaleSystDown" not in self.complained:
        if not self.eEnergyScaleSystDown_branch and "eEnergyScaleSystDown":
            warnings.warn( "EMTree: Expected branch eEnergyScaleSystDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleSystDown")
        else:
            self.eEnergyScaleSystDown_branch.SetAddress(<void*>&self.eEnergyScaleSystDown_value)

        #print "making eEnergyScaleSystUp"
        self.eEnergyScaleSystUp_branch = the_tree.GetBranch("eEnergyScaleSystUp")
        #if not self.eEnergyScaleSystUp_branch and "eEnergyScaleSystUp" not in self.complained:
        if not self.eEnergyScaleSystUp_branch and "eEnergyScaleSystUp":
            warnings.warn( "EMTree: Expected branch eEnergyScaleSystUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleSystUp")
        else:
            self.eEnergyScaleSystUp_branch.SetAddress(<void*>&self.eEnergyScaleSystUp_value)

        #print "making eEnergyScaleUp"
        self.eEnergyScaleUp_branch = the_tree.GetBranch("eEnergyScaleUp")
        #if not self.eEnergyScaleUp_branch and "eEnergyScaleUp" not in self.complained:
        if not self.eEnergyScaleUp_branch and "eEnergyScaleUp":
            warnings.warn( "EMTree: Expected branch eEnergyScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleUp")
        else:
            self.eEnergyScaleUp_branch.SetAddress(<void*>&self.eEnergyScaleUp_value)

        #print "making eEnergySigmaDown"
        self.eEnergySigmaDown_branch = the_tree.GetBranch("eEnergySigmaDown")
        #if not self.eEnergySigmaDown_branch and "eEnergySigmaDown" not in self.complained:
        if not self.eEnergySigmaDown_branch and "eEnergySigmaDown":
            warnings.warn( "EMTree: Expected branch eEnergySigmaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaDown")
        else:
            self.eEnergySigmaDown_branch.SetAddress(<void*>&self.eEnergySigmaDown_value)

        #print "making eEnergySigmaPhiDown"
        self.eEnergySigmaPhiDown_branch = the_tree.GetBranch("eEnergySigmaPhiDown")
        #if not self.eEnergySigmaPhiDown_branch and "eEnergySigmaPhiDown" not in self.complained:
        if not self.eEnergySigmaPhiDown_branch and "eEnergySigmaPhiDown":
            warnings.warn( "EMTree: Expected branch eEnergySigmaPhiDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaPhiDown")
        else:
            self.eEnergySigmaPhiDown_branch.SetAddress(<void*>&self.eEnergySigmaPhiDown_value)

        #print "making eEnergySigmaPhiUp"
        self.eEnergySigmaPhiUp_branch = the_tree.GetBranch("eEnergySigmaPhiUp")
        #if not self.eEnergySigmaPhiUp_branch and "eEnergySigmaPhiUp" not in self.complained:
        if not self.eEnergySigmaPhiUp_branch and "eEnergySigmaPhiUp":
            warnings.warn( "EMTree: Expected branch eEnergySigmaPhiUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaPhiUp")
        else:
            self.eEnergySigmaPhiUp_branch.SetAddress(<void*>&self.eEnergySigmaPhiUp_value)

        #print "making eEnergySigmaRhoDown"
        self.eEnergySigmaRhoDown_branch = the_tree.GetBranch("eEnergySigmaRhoDown")
        #if not self.eEnergySigmaRhoDown_branch and "eEnergySigmaRhoDown" not in self.complained:
        if not self.eEnergySigmaRhoDown_branch and "eEnergySigmaRhoDown":
            warnings.warn( "EMTree: Expected branch eEnergySigmaRhoDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaRhoDown")
        else:
            self.eEnergySigmaRhoDown_branch.SetAddress(<void*>&self.eEnergySigmaRhoDown_value)

        #print "making eEnergySigmaRhoUp"
        self.eEnergySigmaRhoUp_branch = the_tree.GetBranch("eEnergySigmaRhoUp")
        #if not self.eEnergySigmaRhoUp_branch and "eEnergySigmaRhoUp" not in self.complained:
        if not self.eEnergySigmaRhoUp_branch and "eEnergySigmaRhoUp":
            warnings.warn( "EMTree: Expected branch eEnergySigmaRhoUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaRhoUp")
        else:
            self.eEnergySigmaRhoUp_branch.SetAddress(<void*>&self.eEnergySigmaRhoUp_value)

        #print "making eEnergySigmaUp"
        self.eEnergySigmaUp_branch = the_tree.GetBranch("eEnergySigmaUp")
        #if not self.eEnergySigmaUp_branch and "eEnergySigmaUp" not in self.complained:
        if not self.eEnergySigmaUp_branch and "eEnergySigmaUp":
            warnings.warn( "EMTree: Expected branch eEnergySigmaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaUp")
        else:
            self.eEnergySigmaUp_branch.SetAddress(<void*>&self.eEnergySigmaUp_value)

        #print "making eEta"
        self.eEta_branch = the_tree.GetBranch("eEta")
        #if not self.eEta_branch and "eEta" not in self.complained:
        if not self.eEta_branch and "eEta":
            warnings.warn( "EMTree: Expected branch eEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEta")
        else:
            self.eEta_branch.SetAddress(<void*>&self.eEta_value)

        #print "making eGenCharge"
        self.eGenCharge_branch = the_tree.GetBranch("eGenCharge")
        #if not self.eGenCharge_branch and "eGenCharge" not in self.complained:
        if not self.eGenCharge_branch and "eGenCharge":
            warnings.warn( "EMTree: Expected branch eGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenCharge")
        else:
            self.eGenCharge_branch.SetAddress(<void*>&self.eGenCharge_value)

        #print "making eGenDirectPromptTauDecay"
        self.eGenDirectPromptTauDecay_branch = the_tree.GetBranch("eGenDirectPromptTauDecay")
        #if not self.eGenDirectPromptTauDecay_branch and "eGenDirectPromptTauDecay" not in self.complained:
        if not self.eGenDirectPromptTauDecay_branch and "eGenDirectPromptTauDecay":
            warnings.warn( "EMTree: Expected branch eGenDirectPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenDirectPromptTauDecay")
        else:
            self.eGenDirectPromptTauDecay_branch.SetAddress(<void*>&self.eGenDirectPromptTauDecay_value)

        #print "making eGenEnergy"
        self.eGenEnergy_branch = the_tree.GetBranch("eGenEnergy")
        #if not self.eGenEnergy_branch and "eGenEnergy" not in self.complained:
        if not self.eGenEnergy_branch and "eGenEnergy":
            warnings.warn( "EMTree: Expected branch eGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEnergy")
        else:
            self.eGenEnergy_branch.SetAddress(<void*>&self.eGenEnergy_value)

        #print "making eGenEta"
        self.eGenEta_branch = the_tree.GetBranch("eGenEta")
        #if not self.eGenEta_branch and "eGenEta" not in self.complained:
        if not self.eGenEta_branch and "eGenEta":
            warnings.warn( "EMTree: Expected branch eGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEta")
        else:
            self.eGenEta_branch.SetAddress(<void*>&self.eGenEta_value)

        #print "making eGenIsPrompt"
        self.eGenIsPrompt_branch = the_tree.GetBranch("eGenIsPrompt")
        #if not self.eGenIsPrompt_branch and "eGenIsPrompt" not in self.complained:
        if not self.eGenIsPrompt_branch and "eGenIsPrompt":
            warnings.warn( "EMTree: Expected branch eGenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenIsPrompt")
        else:
            self.eGenIsPrompt_branch.SetAddress(<void*>&self.eGenIsPrompt_value)

        #print "making eGenMotherPdgId"
        self.eGenMotherPdgId_branch = the_tree.GetBranch("eGenMotherPdgId")
        #if not self.eGenMotherPdgId_branch and "eGenMotherPdgId" not in self.complained:
        if not self.eGenMotherPdgId_branch and "eGenMotherPdgId":
            warnings.warn( "EMTree: Expected branch eGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenMotherPdgId")
        else:
            self.eGenMotherPdgId_branch.SetAddress(<void*>&self.eGenMotherPdgId_value)

        #print "making eGenParticle"
        self.eGenParticle_branch = the_tree.GetBranch("eGenParticle")
        #if not self.eGenParticle_branch and "eGenParticle" not in self.complained:
        if not self.eGenParticle_branch and "eGenParticle":
            warnings.warn( "EMTree: Expected branch eGenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenParticle")
        else:
            self.eGenParticle_branch.SetAddress(<void*>&self.eGenParticle_value)

        #print "making eGenPdgId"
        self.eGenPdgId_branch = the_tree.GetBranch("eGenPdgId")
        #if not self.eGenPdgId_branch and "eGenPdgId" not in self.complained:
        if not self.eGenPdgId_branch and "eGenPdgId":
            warnings.warn( "EMTree: Expected branch eGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPdgId")
        else:
            self.eGenPdgId_branch.SetAddress(<void*>&self.eGenPdgId_value)

        #print "making eGenPhi"
        self.eGenPhi_branch = the_tree.GetBranch("eGenPhi")
        #if not self.eGenPhi_branch and "eGenPhi" not in self.complained:
        if not self.eGenPhi_branch and "eGenPhi":
            warnings.warn( "EMTree: Expected branch eGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPhi")
        else:
            self.eGenPhi_branch.SetAddress(<void*>&self.eGenPhi_value)

        #print "making eGenPrompt"
        self.eGenPrompt_branch = the_tree.GetBranch("eGenPrompt")
        #if not self.eGenPrompt_branch and "eGenPrompt" not in self.complained:
        if not self.eGenPrompt_branch and "eGenPrompt":
            warnings.warn( "EMTree: Expected branch eGenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPrompt")
        else:
            self.eGenPrompt_branch.SetAddress(<void*>&self.eGenPrompt_value)

        #print "making eGenPromptTauDecay"
        self.eGenPromptTauDecay_branch = the_tree.GetBranch("eGenPromptTauDecay")
        #if not self.eGenPromptTauDecay_branch and "eGenPromptTauDecay" not in self.complained:
        if not self.eGenPromptTauDecay_branch and "eGenPromptTauDecay":
            warnings.warn( "EMTree: Expected branch eGenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPromptTauDecay")
        else:
            self.eGenPromptTauDecay_branch.SetAddress(<void*>&self.eGenPromptTauDecay_value)

        #print "making eGenPt"
        self.eGenPt_branch = the_tree.GetBranch("eGenPt")
        #if not self.eGenPt_branch and "eGenPt" not in self.complained:
        if not self.eGenPt_branch and "eGenPt":
            warnings.warn( "EMTree: Expected branch eGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPt")
        else:
            self.eGenPt_branch.SetAddress(<void*>&self.eGenPt_value)

        #print "making eGenTauDecay"
        self.eGenTauDecay_branch = the_tree.GetBranch("eGenTauDecay")
        #if not self.eGenTauDecay_branch and "eGenTauDecay" not in self.complained:
        if not self.eGenTauDecay_branch and "eGenTauDecay":
            warnings.warn( "EMTree: Expected branch eGenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenTauDecay")
        else:
            self.eGenTauDecay_branch.SetAddress(<void*>&self.eGenTauDecay_value)

        #print "making eGenVZ"
        self.eGenVZ_branch = the_tree.GetBranch("eGenVZ")
        #if not self.eGenVZ_branch and "eGenVZ" not in self.complained:
        if not self.eGenVZ_branch and "eGenVZ":
            warnings.warn( "EMTree: Expected branch eGenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenVZ")
        else:
            self.eGenVZ_branch.SetAddress(<void*>&self.eGenVZ_value)

        #print "making eGenVtxPVMatch"
        self.eGenVtxPVMatch_branch = the_tree.GetBranch("eGenVtxPVMatch")
        #if not self.eGenVtxPVMatch_branch and "eGenVtxPVMatch" not in self.complained:
        if not self.eGenVtxPVMatch_branch and "eGenVtxPVMatch":
            warnings.warn( "EMTree: Expected branch eGenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenVtxPVMatch")
        else:
            self.eGenVtxPVMatch_branch.SetAddress(<void*>&self.eGenVtxPVMatch_value)

        #print "making eHcalIsoDR03"
        self.eHcalIsoDR03_branch = the_tree.GetBranch("eHcalIsoDR03")
        #if not self.eHcalIsoDR03_branch and "eHcalIsoDR03" not in self.complained:
        if not self.eHcalIsoDR03_branch and "eHcalIsoDR03":
            warnings.warn( "EMTree: Expected branch eHcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHcalIsoDR03")
        else:
            self.eHcalIsoDR03_branch.SetAddress(<void*>&self.eHcalIsoDR03_value)

        #print "making eIP3D"
        self.eIP3D_branch = the_tree.GetBranch("eIP3D")
        #if not self.eIP3D_branch and "eIP3D" not in self.complained:
        if not self.eIP3D_branch and "eIP3D":
            warnings.warn( "EMTree: Expected branch eIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIP3D")
        else:
            self.eIP3D_branch.SetAddress(<void*>&self.eIP3D_value)

        #print "making eIP3DErr"
        self.eIP3DErr_branch = the_tree.GetBranch("eIP3DErr")
        #if not self.eIP3DErr_branch and "eIP3DErr" not in self.complained:
        if not self.eIP3DErr_branch and "eIP3DErr":
            warnings.warn( "EMTree: Expected branch eIP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIP3DErr")
        else:
            self.eIP3DErr_branch.SetAddress(<void*>&self.eIP3DErr_value)

        #print "making eIsoDB03"
        self.eIsoDB03_branch = the_tree.GetBranch("eIsoDB03")
        #if not self.eIsoDB03_branch and "eIsoDB03" not in self.complained:
        if not self.eIsoDB03_branch and "eIsoDB03":
            warnings.warn( "EMTree: Expected branch eIsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIsoDB03")
        else:
            self.eIsoDB03_branch.SetAddress(<void*>&self.eIsoDB03_value)

        #print "making eJetArea"
        self.eJetArea_branch = the_tree.GetBranch("eJetArea")
        #if not self.eJetArea_branch and "eJetArea" not in self.complained:
        if not self.eJetArea_branch and "eJetArea":
            warnings.warn( "EMTree: Expected branch eJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetArea")
        else:
            self.eJetArea_branch.SetAddress(<void*>&self.eJetArea_value)

        #print "making eJetBtag"
        self.eJetBtag_branch = the_tree.GetBranch("eJetBtag")
        #if not self.eJetBtag_branch and "eJetBtag" not in self.complained:
        if not self.eJetBtag_branch and "eJetBtag":
            warnings.warn( "EMTree: Expected branch eJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetBtag")
        else:
            self.eJetBtag_branch.SetAddress(<void*>&self.eJetBtag_value)

        #print "making eJetDR"
        self.eJetDR_branch = the_tree.GetBranch("eJetDR")
        #if not self.eJetDR_branch and "eJetDR" not in self.complained:
        if not self.eJetDR_branch and "eJetDR":
            warnings.warn( "EMTree: Expected branch eJetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetDR")
        else:
            self.eJetDR_branch.SetAddress(<void*>&self.eJetDR_value)

        #print "making eJetEtaEtaMoment"
        self.eJetEtaEtaMoment_branch = the_tree.GetBranch("eJetEtaEtaMoment")
        #if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment" not in self.complained:
        if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment":
            warnings.warn( "EMTree: Expected branch eJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaEtaMoment")
        else:
            self.eJetEtaEtaMoment_branch.SetAddress(<void*>&self.eJetEtaEtaMoment_value)

        #print "making eJetEtaPhiMoment"
        self.eJetEtaPhiMoment_branch = the_tree.GetBranch("eJetEtaPhiMoment")
        #if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment" not in self.complained:
        if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment":
            warnings.warn( "EMTree: Expected branch eJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiMoment")
        else:
            self.eJetEtaPhiMoment_branch.SetAddress(<void*>&self.eJetEtaPhiMoment_value)

        #print "making eJetEtaPhiSpread"
        self.eJetEtaPhiSpread_branch = the_tree.GetBranch("eJetEtaPhiSpread")
        #if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread" not in self.complained:
        if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread":
            warnings.warn( "EMTree: Expected branch eJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiSpread")
        else:
            self.eJetEtaPhiSpread_branch.SetAddress(<void*>&self.eJetEtaPhiSpread_value)

        #print "making eJetHadronFlavour"
        self.eJetHadronFlavour_branch = the_tree.GetBranch("eJetHadronFlavour")
        #if not self.eJetHadronFlavour_branch and "eJetHadronFlavour" not in self.complained:
        if not self.eJetHadronFlavour_branch and "eJetHadronFlavour":
            warnings.warn( "EMTree: Expected branch eJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetHadronFlavour")
        else:
            self.eJetHadronFlavour_branch.SetAddress(<void*>&self.eJetHadronFlavour_value)

        #print "making eJetPFCISVBtag"
        self.eJetPFCISVBtag_branch = the_tree.GetBranch("eJetPFCISVBtag")
        #if not self.eJetPFCISVBtag_branch and "eJetPFCISVBtag" not in self.complained:
        if not self.eJetPFCISVBtag_branch and "eJetPFCISVBtag":
            warnings.warn( "EMTree: Expected branch eJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPFCISVBtag")
        else:
            self.eJetPFCISVBtag_branch.SetAddress(<void*>&self.eJetPFCISVBtag_value)

        #print "making eJetPartonFlavour"
        self.eJetPartonFlavour_branch = the_tree.GetBranch("eJetPartonFlavour")
        #if not self.eJetPartonFlavour_branch and "eJetPartonFlavour" not in self.complained:
        if not self.eJetPartonFlavour_branch and "eJetPartonFlavour":
            warnings.warn( "EMTree: Expected branch eJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPartonFlavour")
        else:
            self.eJetPartonFlavour_branch.SetAddress(<void*>&self.eJetPartonFlavour_value)

        #print "making eJetPhiPhiMoment"
        self.eJetPhiPhiMoment_branch = the_tree.GetBranch("eJetPhiPhiMoment")
        #if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment" not in self.complained:
        if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment":
            warnings.warn( "EMTree: Expected branch eJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPhiPhiMoment")
        else:
            self.eJetPhiPhiMoment_branch.SetAddress(<void*>&self.eJetPhiPhiMoment_value)

        #print "making eJetPt"
        self.eJetPt_branch = the_tree.GetBranch("eJetPt")
        #if not self.eJetPt_branch and "eJetPt" not in self.complained:
        if not self.eJetPt_branch and "eJetPt":
            warnings.warn( "EMTree: Expected branch eJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPt")
        else:
            self.eJetPt_branch.SetAddress(<void*>&self.eJetPt_value)

        #print "making eLowestMll"
        self.eLowestMll_branch = the_tree.GetBranch("eLowestMll")
        #if not self.eLowestMll_branch and "eLowestMll" not in self.complained:
        if not self.eLowestMll_branch and "eLowestMll":
            warnings.warn( "EMTree: Expected branch eLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eLowestMll")
        else:
            self.eLowestMll_branch.SetAddress(<void*>&self.eLowestMll_value)

        #print "making eMVAIsoWP80"
        self.eMVAIsoWP80_branch = the_tree.GetBranch("eMVAIsoWP80")
        #if not self.eMVAIsoWP80_branch and "eMVAIsoWP80" not in self.complained:
        if not self.eMVAIsoWP80_branch and "eMVAIsoWP80":
            warnings.warn( "EMTree: Expected branch eMVAIsoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIsoWP80")
        else:
            self.eMVAIsoWP80_branch.SetAddress(<void*>&self.eMVAIsoWP80_value)

        #print "making eMVAIsoWP90"
        self.eMVAIsoWP90_branch = the_tree.GetBranch("eMVAIsoWP90")
        #if not self.eMVAIsoWP90_branch and "eMVAIsoWP90" not in self.complained:
        if not self.eMVAIsoWP90_branch and "eMVAIsoWP90":
            warnings.warn( "EMTree: Expected branch eMVAIsoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIsoWP90")
        else:
            self.eMVAIsoWP90_branch.SetAddress(<void*>&self.eMVAIsoWP90_value)

        #print "making eMVANoisoWP80"
        self.eMVANoisoWP80_branch = the_tree.GetBranch("eMVANoisoWP80")
        #if not self.eMVANoisoWP80_branch and "eMVANoisoWP80" not in self.complained:
        if not self.eMVANoisoWP80_branch and "eMVANoisoWP80":
            warnings.warn( "EMTree: Expected branch eMVANoisoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANoisoWP80")
        else:
            self.eMVANoisoWP80_branch.SetAddress(<void*>&self.eMVANoisoWP80_value)

        #print "making eMVANoisoWP90"
        self.eMVANoisoWP90_branch = the_tree.GetBranch("eMVANoisoWP90")
        #if not self.eMVANoisoWP90_branch and "eMVANoisoWP90" not in self.complained:
        if not self.eMVANoisoWP90_branch and "eMVANoisoWP90":
            warnings.warn( "EMTree: Expected branch eMVANoisoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANoisoWP90")
        else:
            self.eMVANoisoWP90_branch.SetAddress(<void*>&self.eMVANoisoWP90_value)

        #print "making eMass"
        self.eMass_branch = the_tree.GetBranch("eMass")
        #if not self.eMass_branch and "eMass" not in self.complained:
        if not self.eMass_branch and "eMass":
            warnings.warn( "EMTree: Expected branch eMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMass")
        else:
            self.eMass_branch.SetAddress(<void*>&self.eMass_value)

        #print "making eMatchEmbeddedFilterEle24Tau30"
        self.eMatchEmbeddedFilterEle24Tau30_branch = the_tree.GetBranch("eMatchEmbeddedFilterEle24Tau30")
        #if not self.eMatchEmbeddedFilterEle24Tau30_branch and "eMatchEmbeddedFilterEle24Tau30" not in self.complained:
        if not self.eMatchEmbeddedFilterEle24Tau30_branch and "eMatchEmbeddedFilterEle24Tau30":
            warnings.warn( "EMTree: Expected branch eMatchEmbeddedFilterEle24Tau30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchEmbeddedFilterEle24Tau30")
        else:
            self.eMatchEmbeddedFilterEle24Tau30_branch.SetAddress(<void*>&self.eMatchEmbeddedFilterEle24Tau30_value)

        #print "making eMatchEmbeddedFilterEle27"
        self.eMatchEmbeddedFilterEle27_branch = the_tree.GetBranch("eMatchEmbeddedFilterEle27")
        #if not self.eMatchEmbeddedFilterEle27_branch and "eMatchEmbeddedFilterEle27" not in self.complained:
        if not self.eMatchEmbeddedFilterEle27_branch and "eMatchEmbeddedFilterEle27":
            warnings.warn( "EMTree: Expected branch eMatchEmbeddedFilterEle27 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchEmbeddedFilterEle27")
        else:
            self.eMatchEmbeddedFilterEle27_branch.SetAddress(<void*>&self.eMatchEmbeddedFilterEle27_value)

        #print "making eMatchEmbeddedFilterEle32"
        self.eMatchEmbeddedFilterEle32_branch = the_tree.GetBranch("eMatchEmbeddedFilterEle32")
        #if not self.eMatchEmbeddedFilterEle32_branch and "eMatchEmbeddedFilterEle32" not in self.complained:
        if not self.eMatchEmbeddedFilterEle32_branch and "eMatchEmbeddedFilterEle32":
            warnings.warn( "EMTree: Expected branch eMatchEmbeddedFilterEle32 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchEmbeddedFilterEle32")
        else:
            self.eMatchEmbeddedFilterEle32_branch.SetAddress(<void*>&self.eMatchEmbeddedFilterEle32_value)

        #print "making eMatchEmbeddedFilterEle32DoubleL1_v1"
        self.eMatchEmbeddedFilterEle32DoubleL1_v1_branch = the_tree.GetBranch("eMatchEmbeddedFilterEle32DoubleL1_v1")
        #if not self.eMatchEmbeddedFilterEle32DoubleL1_v1_branch and "eMatchEmbeddedFilterEle32DoubleL1_v1" not in self.complained:
        if not self.eMatchEmbeddedFilterEle32DoubleL1_v1_branch and "eMatchEmbeddedFilterEle32DoubleL1_v1":
            warnings.warn( "EMTree: Expected branch eMatchEmbeddedFilterEle32DoubleL1_v1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchEmbeddedFilterEle32DoubleL1_v1")
        else:
            self.eMatchEmbeddedFilterEle32DoubleL1_v1_branch.SetAddress(<void*>&self.eMatchEmbeddedFilterEle32DoubleL1_v1_value)

        #print "making eMatchEmbeddedFilterEle32DoubleL1_v2"
        self.eMatchEmbeddedFilterEle32DoubleL1_v2_branch = the_tree.GetBranch("eMatchEmbeddedFilterEle32DoubleL1_v2")
        #if not self.eMatchEmbeddedFilterEle32DoubleL1_v2_branch and "eMatchEmbeddedFilterEle32DoubleL1_v2" not in self.complained:
        if not self.eMatchEmbeddedFilterEle32DoubleL1_v2_branch and "eMatchEmbeddedFilterEle32DoubleL1_v2":
            warnings.warn( "EMTree: Expected branch eMatchEmbeddedFilterEle32DoubleL1_v2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchEmbeddedFilterEle32DoubleL1_v2")
        else:
            self.eMatchEmbeddedFilterEle32DoubleL1_v2_branch.SetAddress(<void*>&self.eMatchEmbeddedFilterEle32DoubleL1_v2_value)

        #print "making eMatchEmbeddedFilterEle35"
        self.eMatchEmbeddedFilterEle35_branch = the_tree.GetBranch("eMatchEmbeddedFilterEle35")
        #if not self.eMatchEmbeddedFilterEle35_branch and "eMatchEmbeddedFilterEle35" not in self.complained:
        if not self.eMatchEmbeddedFilterEle35_branch and "eMatchEmbeddedFilterEle35":
            warnings.warn( "EMTree: Expected branch eMatchEmbeddedFilterEle35 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchEmbeddedFilterEle35")
        else:
            self.eMatchEmbeddedFilterEle35_branch.SetAddress(<void*>&self.eMatchEmbeddedFilterEle35_value)

        #print "making eMatchesEle24HPSTau30Filter"
        self.eMatchesEle24HPSTau30Filter_branch = the_tree.GetBranch("eMatchesEle24HPSTau30Filter")
        #if not self.eMatchesEle24HPSTau30Filter_branch and "eMatchesEle24HPSTau30Filter" not in self.complained:
        if not self.eMatchesEle24HPSTau30Filter_branch and "eMatchesEle24HPSTau30Filter":
            warnings.warn( "EMTree: Expected branch eMatchesEle24HPSTau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24HPSTau30Filter")
        else:
            self.eMatchesEle24HPSTau30Filter_branch.SetAddress(<void*>&self.eMatchesEle24HPSTau30Filter_value)

        #print "making eMatchesEle24HPSTau30Path"
        self.eMatchesEle24HPSTau30Path_branch = the_tree.GetBranch("eMatchesEle24HPSTau30Path")
        #if not self.eMatchesEle24HPSTau30Path_branch and "eMatchesEle24HPSTau30Path" not in self.complained:
        if not self.eMatchesEle24HPSTau30Path_branch and "eMatchesEle24HPSTau30Path":
            warnings.warn( "EMTree: Expected branch eMatchesEle24HPSTau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24HPSTau30Path")
        else:
            self.eMatchesEle24HPSTau30Path_branch.SetAddress(<void*>&self.eMatchesEle24HPSTau30Path_value)

        #print "making eMatchesEle24Tau30Filter"
        self.eMatchesEle24Tau30Filter_branch = the_tree.GetBranch("eMatchesEle24Tau30Filter")
        #if not self.eMatchesEle24Tau30Filter_branch and "eMatchesEle24Tau30Filter" not in self.complained:
        if not self.eMatchesEle24Tau30Filter_branch and "eMatchesEle24Tau30Filter":
            warnings.warn( "EMTree: Expected branch eMatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24Tau30Filter")
        else:
            self.eMatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.eMatchesEle24Tau30Filter_value)

        #print "making eMatchesEle24Tau30Path"
        self.eMatchesEle24Tau30Path_branch = the_tree.GetBranch("eMatchesEle24Tau30Path")
        #if not self.eMatchesEle24Tau30Path_branch and "eMatchesEle24Tau30Path" not in self.complained:
        if not self.eMatchesEle24Tau30Path_branch and "eMatchesEle24Tau30Path":
            warnings.warn( "EMTree: Expected branch eMatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24Tau30Path")
        else:
            self.eMatchesEle24Tau30Path_branch.SetAddress(<void*>&self.eMatchesEle24Tau30Path_value)

        #print "making eMatchesEle25Filter"
        self.eMatchesEle25Filter_branch = the_tree.GetBranch("eMatchesEle25Filter")
        #if not self.eMatchesEle25Filter_branch and "eMatchesEle25Filter" not in self.complained:
        if not self.eMatchesEle25Filter_branch and "eMatchesEle25Filter":
            warnings.warn( "EMTree: Expected branch eMatchesEle25Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle25Filter")
        else:
            self.eMatchesEle25Filter_branch.SetAddress(<void*>&self.eMatchesEle25Filter_value)

        #print "making eMatchesEle25Path"
        self.eMatchesEle25Path_branch = the_tree.GetBranch("eMatchesEle25Path")
        #if not self.eMatchesEle25Path_branch and "eMatchesEle25Path" not in self.complained:
        if not self.eMatchesEle25Path_branch and "eMatchesEle25Path":
            warnings.warn( "EMTree: Expected branch eMatchesEle25Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle25Path")
        else:
            self.eMatchesEle25Path_branch.SetAddress(<void*>&self.eMatchesEle25Path_value)

        #print "making eMatchesEle27Filter"
        self.eMatchesEle27Filter_branch = the_tree.GetBranch("eMatchesEle27Filter")
        #if not self.eMatchesEle27Filter_branch and "eMatchesEle27Filter" not in self.complained:
        if not self.eMatchesEle27Filter_branch and "eMatchesEle27Filter":
            warnings.warn( "EMTree: Expected branch eMatchesEle27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle27Filter")
        else:
            self.eMatchesEle27Filter_branch.SetAddress(<void*>&self.eMatchesEle27Filter_value)

        #print "making eMatchesEle27Path"
        self.eMatchesEle27Path_branch = the_tree.GetBranch("eMatchesEle27Path")
        #if not self.eMatchesEle27Path_branch and "eMatchesEle27Path" not in self.complained:
        if not self.eMatchesEle27Path_branch and "eMatchesEle27Path":
            warnings.warn( "EMTree: Expected branch eMatchesEle27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle27Path")
        else:
            self.eMatchesEle27Path_branch.SetAddress(<void*>&self.eMatchesEle27Path_value)

        #print "making eMatchesEle32Filter"
        self.eMatchesEle32Filter_branch = the_tree.GetBranch("eMatchesEle32Filter")
        #if not self.eMatchesEle32Filter_branch and "eMatchesEle32Filter" not in self.complained:
        if not self.eMatchesEle32Filter_branch and "eMatchesEle32Filter":
            warnings.warn( "EMTree: Expected branch eMatchesEle32Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle32Filter")
        else:
            self.eMatchesEle32Filter_branch.SetAddress(<void*>&self.eMatchesEle32Filter_value)

        #print "making eMatchesEle32Path"
        self.eMatchesEle32Path_branch = the_tree.GetBranch("eMatchesEle32Path")
        #if not self.eMatchesEle32Path_branch and "eMatchesEle32Path" not in self.complained:
        if not self.eMatchesEle32Path_branch and "eMatchesEle32Path":
            warnings.warn( "EMTree: Expected branch eMatchesEle32Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle32Path")
        else:
            self.eMatchesEle32Path_branch.SetAddress(<void*>&self.eMatchesEle32Path_value)

        #print "making eMatchesEle35Filter"
        self.eMatchesEle35Filter_branch = the_tree.GetBranch("eMatchesEle35Filter")
        #if not self.eMatchesEle35Filter_branch and "eMatchesEle35Filter" not in self.complained:
        if not self.eMatchesEle35Filter_branch and "eMatchesEle35Filter":
            warnings.warn( "EMTree: Expected branch eMatchesEle35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle35Filter")
        else:
            self.eMatchesEle35Filter_branch.SetAddress(<void*>&self.eMatchesEle35Filter_value)

        #print "making eMatchesEle35Path"
        self.eMatchesEle35Path_branch = the_tree.GetBranch("eMatchesEle35Path")
        #if not self.eMatchesEle35Path_branch and "eMatchesEle35Path" not in self.complained:
        if not self.eMatchesEle35Path_branch and "eMatchesEle35Path":
            warnings.warn( "EMTree: Expected branch eMatchesEle35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle35Path")
        else:
            self.eMatchesEle35Path_branch.SetAddress(<void*>&self.eMatchesEle35Path_value)

        #print "making eMatchesMu23e12DZFilter"
        self.eMatchesMu23e12DZFilter_branch = the_tree.GetBranch("eMatchesMu23e12DZFilter")
        #if not self.eMatchesMu23e12DZFilter_branch and "eMatchesMu23e12DZFilter" not in self.complained:
        if not self.eMatchesMu23e12DZFilter_branch and "eMatchesMu23e12DZFilter":
            warnings.warn( "EMTree: Expected branch eMatchesMu23e12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23e12DZFilter")
        else:
            self.eMatchesMu23e12DZFilter_branch.SetAddress(<void*>&self.eMatchesMu23e12DZFilter_value)

        #print "making eMatchesMu23e12DZPath"
        self.eMatchesMu23e12DZPath_branch = the_tree.GetBranch("eMatchesMu23e12DZPath")
        #if not self.eMatchesMu23e12DZPath_branch and "eMatchesMu23e12DZPath" not in self.complained:
        if not self.eMatchesMu23e12DZPath_branch and "eMatchesMu23e12DZPath":
            warnings.warn( "EMTree: Expected branch eMatchesMu23e12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23e12DZPath")
        else:
            self.eMatchesMu23e12DZPath_branch.SetAddress(<void*>&self.eMatchesMu23e12DZPath_value)

        #print "making eMatchesMu23e12Filter"
        self.eMatchesMu23e12Filter_branch = the_tree.GetBranch("eMatchesMu23e12Filter")
        #if not self.eMatchesMu23e12Filter_branch and "eMatchesMu23e12Filter" not in self.complained:
        if not self.eMatchesMu23e12Filter_branch and "eMatchesMu23e12Filter":
            warnings.warn( "EMTree: Expected branch eMatchesMu23e12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23e12Filter")
        else:
            self.eMatchesMu23e12Filter_branch.SetAddress(<void*>&self.eMatchesMu23e12Filter_value)

        #print "making eMatchesMu23e12Path"
        self.eMatchesMu23e12Path_branch = the_tree.GetBranch("eMatchesMu23e12Path")
        #if not self.eMatchesMu23e12Path_branch and "eMatchesMu23e12Path" not in self.complained:
        if not self.eMatchesMu23e12Path_branch and "eMatchesMu23e12Path":
            warnings.warn( "EMTree: Expected branch eMatchesMu23e12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23e12Path")
        else:
            self.eMatchesMu23e12Path_branch.SetAddress(<void*>&self.eMatchesMu23e12Path_value)

        #print "making eMatchesMu8e23DZFilter"
        self.eMatchesMu8e23DZFilter_branch = the_tree.GetBranch("eMatchesMu8e23DZFilter")
        #if not self.eMatchesMu8e23DZFilter_branch and "eMatchesMu8e23DZFilter" not in self.complained:
        if not self.eMatchesMu8e23DZFilter_branch and "eMatchesMu8e23DZFilter":
            warnings.warn( "EMTree: Expected branch eMatchesMu8e23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8e23DZFilter")
        else:
            self.eMatchesMu8e23DZFilter_branch.SetAddress(<void*>&self.eMatchesMu8e23DZFilter_value)

        #print "making eMatchesMu8e23DZPath"
        self.eMatchesMu8e23DZPath_branch = the_tree.GetBranch("eMatchesMu8e23DZPath")
        #if not self.eMatchesMu8e23DZPath_branch and "eMatchesMu8e23DZPath" not in self.complained:
        if not self.eMatchesMu8e23DZPath_branch and "eMatchesMu8e23DZPath":
            warnings.warn( "EMTree: Expected branch eMatchesMu8e23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8e23DZPath")
        else:
            self.eMatchesMu8e23DZPath_branch.SetAddress(<void*>&self.eMatchesMu8e23DZPath_value)

        #print "making eMatchesMu8e23Filter"
        self.eMatchesMu8e23Filter_branch = the_tree.GetBranch("eMatchesMu8e23Filter")
        #if not self.eMatchesMu8e23Filter_branch and "eMatchesMu8e23Filter" not in self.complained:
        if not self.eMatchesMu8e23Filter_branch and "eMatchesMu8e23Filter":
            warnings.warn( "EMTree: Expected branch eMatchesMu8e23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8e23Filter")
        else:
            self.eMatchesMu8e23Filter_branch.SetAddress(<void*>&self.eMatchesMu8e23Filter_value)

        #print "making eMatchesMu8e23Path"
        self.eMatchesMu8e23Path_branch = the_tree.GetBranch("eMatchesMu8e23Path")
        #if not self.eMatchesMu8e23Path_branch and "eMatchesMu8e23Path" not in self.complained:
        if not self.eMatchesMu8e23Path_branch and "eMatchesMu8e23Path":
            warnings.warn( "EMTree: Expected branch eMatchesMu8e23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8e23Path")
        else:
            self.eMatchesMu8e23Path_branch.SetAddress(<void*>&self.eMatchesMu8e23Path_value)

        #print "making eMissingHits"
        self.eMissingHits_branch = the_tree.GetBranch("eMissingHits")
        #if not self.eMissingHits_branch and "eMissingHits" not in self.complained:
        if not self.eMissingHits_branch and "eMissingHits":
            warnings.warn( "EMTree: Expected branch eMissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMissingHits")
        else:
            self.eMissingHits_branch.SetAddress(<void*>&self.eMissingHits_value)

        #print "making eNearMuonVeto"
        self.eNearMuonVeto_branch = the_tree.GetBranch("eNearMuonVeto")
        #if not self.eNearMuonVeto_branch and "eNearMuonVeto" not in self.complained:
        if not self.eNearMuonVeto_branch and "eNearMuonVeto":
            warnings.warn( "EMTree: Expected branch eNearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearMuonVeto")
        else:
            self.eNearMuonVeto_branch.SetAddress(<void*>&self.eNearMuonVeto_value)

        #print "making eNearestMuonDR"
        self.eNearestMuonDR_branch = the_tree.GetBranch("eNearestMuonDR")
        #if not self.eNearestMuonDR_branch and "eNearestMuonDR" not in self.complained:
        if not self.eNearestMuonDR_branch and "eNearestMuonDR":
            warnings.warn( "EMTree: Expected branch eNearestMuonDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearestMuonDR")
        else:
            self.eNearestMuonDR_branch.SetAddress(<void*>&self.eNearestMuonDR_value)

        #print "making eNearestZMass"
        self.eNearestZMass_branch = the_tree.GetBranch("eNearestZMass")
        #if not self.eNearestZMass_branch and "eNearestZMass" not in self.complained:
        if not self.eNearestZMass_branch and "eNearestZMass":
            warnings.warn( "EMTree: Expected branch eNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearestZMass")
        else:
            self.eNearestZMass_branch.SetAddress(<void*>&self.eNearestZMass_value)

        #print "making ePFChargedIso"
        self.ePFChargedIso_branch = the_tree.GetBranch("ePFChargedIso")
        #if not self.ePFChargedIso_branch and "ePFChargedIso" not in self.complained:
        if not self.ePFChargedIso_branch and "ePFChargedIso":
            warnings.warn( "EMTree: Expected branch ePFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFChargedIso")
        else:
            self.ePFChargedIso_branch.SetAddress(<void*>&self.ePFChargedIso_value)

        #print "making ePFNeutralIso"
        self.ePFNeutralIso_branch = the_tree.GetBranch("ePFNeutralIso")
        #if not self.ePFNeutralIso_branch and "ePFNeutralIso" not in self.complained:
        if not self.ePFNeutralIso_branch and "ePFNeutralIso":
            warnings.warn( "EMTree: Expected branch ePFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFNeutralIso")
        else:
            self.ePFNeutralIso_branch.SetAddress(<void*>&self.ePFNeutralIso_value)

        #print "making ePFPUChargedIso"
        self.ePFPUChargedIso_branch = the_tree.GetBranch("ePFPUChargedIso")
        #if not self.ePFPUChargedIso_branch and "ePFPUChargedIso" not in self.complained:
        if not self.ePFPUChargedIso_branch and "ePFPUChargedIso":
            warnings.warn( "EMTree: Expected branch ePFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFPUChargedIso")
        else:
            self.ePFPUChargedIso_branch.SetAddress(<void*>&self.ePFPUChargedIso_value)

        #print "making ePFPhotonIso"
        self.ePFPhotonIso_branch = the_tree.GetBranch("ePFPhotonIso")
        #if not self.ePFPhotonIso_branch and "ePFPhotonIso" not in self.complained:
        if not self.ePFPhotonIso_branch and "ePFPhotonIso":
            warnings.warn( "EMTree: Expected branch ePFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFPhotonIso")
        else:
            self.ePFPhotonIso_branch.SetAddress(<void*>&self.ePFPhotonIso_value)

        #print "making ePVDXY"
        self.ePVDXY_branch = the_tree.GetBranch("ePVDXY")
        #if not self.ePVDXY_branch and "ePVDXY" not in self.complained:
        if not self.ePVDXY_branch and "ePVDXY":
            warnings.warn( "EMTree: Expected branch ePVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDXY")
        else:
            self.ePVDXY_branch.SetAddress(<void*>&self.ePVDXY_value)

        #print "making ePVDZ"
        self.ePVDZ_branch = the_tree.GetBranch("ePVDZ")
        #if not self.ePVDZ_branch and "ePVDZ" not in self.complained:
        if not self.ePVDZ_branch and "ePVDZ":
            warnings.warn( "EMTree: Expected branch ePVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDZ")
        else:
            self.ePVDZ_branch.SetAddress(<void*>&self.ePVDZ_value)

        #print "making ePassesConversionVeto"
        self.ePassesConversionVeto_branch = the_tree.GetBranch("ePassesConversionVeto")
        #if not self.ePassesConversionVeto_branch and "ePassesConversionVeto" not in self.complained:
        if not self.ePassesConversionVeto_branch and "ePassesConversionVeto":
            warnings.warn( "EMTree: Expected branch ePassesConversionVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePassesConversionVeto")
        else:
            self.ePassesConversionVeto_branch.SetAddress(<void*>&self.ePassesConversionVeto_value)

        #print "making ePhi"
        self.ePhi_branch = the_tree.GetBranch("ePhi")
        #if not self.ePhi_branch and "ePhi" not in self.complained:
        if not self.ePhi_branch and "ePhi":
            warnings.warn( "EMTree: Expected branch ePhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhi")
        else:
            self.ePhi_branch.SetAddress(<void*>&self.ePhi_value)

        #print "making ePt"
        self.ePt_branch = the_tree.GetBranch("ePt")
        #if not self.ePt_branch and "ePt" not in self.complained:
        if not self.ePt_branch and "ePt":
            warnings.warn( "EMTree: Expected branch ePt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt")
        else:
            self.ePt_branch.SetAddress(<void*>&self.ePt_value)

        #print "making eRelIso"
        self.eRelIso_branch = the_tree.GetBranch("eRelIso")
        #if not self.eRelIso_branch and "eRelIso" not in self.complained:
        if not self.eRelIso_branch and "eRelIso":
            warnings.warn( "EMTree: Expected branch eRelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelIso")
        else:
            self.eRelIso_branch.SetAddress(<void*>&self.eRelIso_value)

        #print "making eRelPFIsoDB"
        self.eRelPFIsoDB_branch = the_tree.GetBranch("eRelPFIsoDB")
        #if not self.eRelPFIsoDB_branch and "eRelPFIsoDB" not in self.complained:
        if not self.eRelPFIsoDB_branch and "eRelPFIsoDB":
            warnings.warn( "EMTree: Expected branch eRelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoDB")
        else:
            self.eRelPFIsoDB_branch.SetAddress(<void*>&self.eRelPFIsoDB_value)

        #print "making eRelPFIsoRho"
        self.eRelPFIsoRho_branch = the_tree.GetBranch("eRelPFIsoRho")
        #if not self.eRelPFIsoRho_branch and "eRelPFIsoRho" not in self.complained:
        if not self.eRelPFIsoRho_branch and "eRelPFIsoRho":
            warnings.warn( "EMTree: Expected branch eRelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRho")
        else:
            self.eRelPFIsoRho_branch.SetAddress(<void*>&self.eRelPFIsoRho_value)

        #print "making eRho"
        self.eRho_branch = the_tree.GetBranch("eRho")
        #if not self.eRho_branch and "eRho" not in self.complained:
        if not self.eRho_branch and "eRho":
            warnings.warn( "EMTree: Expected branch eRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRho")
        else:
            self.eRho_branch.SetAddress(<void*>&self.eRho_value)

        #print "making eSIP2D"
        self.eSIP2D_branch = the_tree.GetBranch("eSIP2D")
        #if not self.eSIP2D_branch and "eSIP2D" not in self.complained:
        if not self.eSIP2D_branch and "eSIP2D":
            warnings.warn( "EMTree: Expected branch eSIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSIP2D")
        else:
            self.eSIP2D_branch.SetAddress(<void*>&self.eSIP2D_value)

        #print "making eSIP3D"
        self.eSIP3D_branch = the_tree.GetBranch("eSIP3D")
        #if not self.eSIP3D_branch and "eSIP3D" not in self.complained:
        if not self.eSIP3D_branch and "eSIP3D":
            warnings.warn( "EMTree: Expected branch eSIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSIP3D")
        else:
            self.eSIP3D_branch.SetAddress(<void*>&self.eSIP3D_value)

        #print "making eTrkIsoDR03"
        self.eTrkIsoDR03_branch = the_tree.GetBranch("eTrkIsoDR03")
        #if not self.eTrkIsoDR03_branch and "eTrkIsoDR03" not in self.complained:
        if not self.eTrkIsoDR03_branch and "eTrkIsoDR03":
            warnings.warn( "EMTree: Expected branch eTrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTrkIsoDR03")
        else:
            self.eTrkIsoDR03_branch.SetAddress(<void*>&self.eTrkIsoDR03_value)

        #print "making eVZ"
        self.eVZ_branch = the_tree.GetBranch("eVZ")
        #if not self.eVZ_branch and "eVZ" not in self.complained:
        if not self.eVZ_branch and "eVZ":
            warnings.warn( "EMTree: Expected branch eVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVZ")
        else:
            self.eVZ_branch.SetAddress(<void*>&self.eVZ_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "EMTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "EMTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making eZTTGenMatching"
        self.eZTTGenMatching_branch = the_tree.GetBranch("eZTTGenMatching")
        #if not self.eZTTGenMatching_branch and "eZTTGenMatching" not in self.complained:
        if not self.eZTTGenMatching_branch and "eZTTGenMatching":
            warnings.warn( "EMTree: Expected branch eZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eZTTGenMatching")
        else:
            self.eZTTGenMatching_branch.SetAddress(<void*>&self.eZTTGenMatching_value)

        #print "making e_m_DR"
        self.e_m_DR_branch = the_tree.GetBranch("e_m_DR")
        #if not self.e_m_DR_branch and "e_m_DR" not in self.complained:
        if not self.e_m_DR_branch and "e_m_DR":
            warnings.warn( "EMTree: Expected branch e_m_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m_DR")
        else:
            self.e_m_DR_branch.SetAddress(<void*>&self.e_m_DR_value)

        #print "making e_m_Mass"
        self.e_m_Mass_branch = the_tree.GetBranch("e_m_Mass")
        #if not self.e_m_Mass_branch and "e_m_Mass" not in self.complained:
        if not self.e_m_Mass_branch and "e_m_Mass":
            warnings.warn( "EMTree: Expected branch e_m_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m_Mass")
        else:
            self.e_m_Mass_branch.SetAddress(<void*>&self.e_m_Mass_value)

        #print "making e_m_PZeta"
        self.e_m_PZeta_branch = the_tree.GetBranch("e_m_PZeta")
        #if not self.e_m_PZeta_branch and "e_m_PZeta" not in self.complained:
        if not self.e_m_PZeta_branch and "e_m_PZeta":
            warnings.warn( "EMTree: Expected branch e_m_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m_PZeta")
        else:
            self.e_m_PZeta_branch.SetAddress(<void*>&self.e_m_PZeta_value)

        #print "making e_m_PZetaVis"
        self.e_m_PZetaVis_branch = the_tree.GetBranch("e_m_PZetaVis")
        #if not self.e_m_PZetaVis_branch and "e_m_PZetaVis" not in self.complained:
        if not self.e_m_PZetaVis_branch and "e_m_PZetaVis":
            warnings.warn( "EMTree: Expected branch e_m_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m_PZetaVis")
        else:
            self.e_m_PZetaVis_branch.SetAddress(<void*>&self.e_m_PZetaVis_value)

        #print "making e_m_doubleL1IsoTauMatch"
        self.e_m_doubleL1IsoTauMatch_branch = the_tree.GetBranch("e_m_doubleL1IsoTauMatch")
        #if not self.e_m_doubleL1IsoTauMatch_branch and "e_m_doubleL1IsoTauMatch" not in self.complained:
        if not self.e_m_doubleL1IsoTauMatch_branch and "e_m_doubleL1IsoTauMatch":
            warnings.warn( "EMTree: Expected branch e_m_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_m_doubleL1IsoTauMatch")
        else:
            self.e_m_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.e_m_doubleL1IsoTauMatch_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "EMTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genEta"
        self.genEta_branch = the_tree.GetBranch("genEta")
        #if not self.genEta_branch and "genEta" not in self.complained:
        if not self.genEta_branch and "genEta":
            warnings.warn( "EMTree: Expected branch genEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genEta")
        else:
            self.genEta_branch.SetAddress(<void*>&self.genEta_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "EMTree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "EMTree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genMass"
        self.genMass_branch = the_tree.GetBranch("genMass")
        #if not self.genMass_branch and "genMass" not in self.complained:
        if not self.genMass_branch and "genMass":
            warnings.warn( "EMTree: Expected branch genMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genMass")
        else:
            self.genMass_branch.SetAddress(<void*>&self.genMass_value)

        #print "making genPhi"
        self.genPhi_branch = the_tree.GetBranch("genPhi")
        #if not self.genPhi_branch and "genPhi" not in self.complained:
        if not self.genPhi_branch and "genPhi":
            warnings.warn( "EMTree: Expected branch genPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genPhi")
        else:
            self.genPhi_branch.SetAddress(<void*>&self.genPhi_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "EMTree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "EMTree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "EMTree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "EMTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWenu"
        self.isWenu_branch = the_tree.GetBranch("isWenu")
        #if not self.isWenu_branch and "isWenu" not in self.complained:
        if not self.isWenu_branch and "isWenu":
            warnings.warn( "EMTree: Expected branch isWenu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWenu")
        else:
            self.isWenu_branch.SetAddress(<void*>&self.isWenu_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "EMTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "EMTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZee"
        self.isZee_branch = the_tree.GetBranch("isZee")
        #if not self.isZee_branch and "isZee" not in self.complained:
        if not self.isZee_branch and "isZee":
            warnings.warn( "EMTree: Expected branch isZee does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZee")
        else:
            self.isZee_branch.SetAddress(<void*>&self.isZee_value)

        #print "making isZmumu"
        self.isZmumu_branch = the_tree.GetBranch("isZmumu")
        #if not self.isZmumu_branch and "isZmumu" not in self.complained:
        if not self.isZmumu_branch and "isZmumu":
            warnings.warn( "EMTree: Expected branch isZmumu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZmumu")
        else:
            self.isZmumu_branch.SetAddress(<void*>&self.isZmumu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "EMTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "EMTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isembed"
        self.isembed_branch = the_tree.GetBranch("isembed")
        #if not self.isembed_branch and "isembed" not in self.complained:
        if not self.isembed_branch and "isembed":
            warnings.warn( "EMTree: Expected branch isembed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isembed")
        else:
            self.isembed_branch.SetAddress(<void*>&self.isembed_value)

        #print "making j1csv"
        self.j1csv_branch = the_tree.GetBranch("j1csv")
        #if not self.j1csv_branch and "j1csv" not in self.complained:
        if not self.j1csv_branch and "j1csv":
            warnings.warn( "EMTree: Expected branch j1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csv")
        else:
            self.j1csv_branch.SetAddress(<void*>&self.j1csv_value)

        #print "making j1csvWoNoisyJets"
        self.j1csvWoNoisyJets_branch = the_tree.GetBranch("j1csvWoNoisyJets")
        #if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets" not in self.complained:
        if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets":
            warnings.warn( "EMTree: Expected branch j1csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csvWoNoisyJets")
        else:
            self.j1csvWoNoisyJets_branch.SetAddress(<void*>&self.j1csvWoNoisyJets_value)

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "EMTree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

        #print "making j1etaWoNoisyJets"
        self.j1etaWoNoisyJets_branch = the_tree.GetBranch("j1etaWoNoisyJets")
        #if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets" not in self.complained:
        if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets":
            warnings.warn( "EMTree: Expected branch j1etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1etaWoNoisyJets")
        else:
            self.j1etaWoNoisyJets_branch.SetAddress(<void*>&self.j1etaWoNoisyJets_value)

        #print "making j1hadronflavor"
        self.j1hadronflavor_branch = the_tree.GetBranch("j1hadronflavor")
        #if not self.j1hadronflavor_branch and "j1hadronflavor" not in self.complained:
        if not self.j1hadronflavor_branch and "j1hadronflavor":
            warnings.warn( "EMTree: Expected branch j1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavor")
        else:
            self.j1hadronflavor_branch.SetAddress(<void*>&self.j1hadronflavor_value)

        #print "making j1hadronflavorWoNoisyJets"
        self.j1hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j1hadronflavorWoNoisyJets")
        #if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets" not in self.complained:
        if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets":
            warnings.warn( "EMTree: Expected branch j1hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavorWoNoisyJets")
        else:
            self.j1hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j1hadronflavorWoNoisyJets_value)

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "EMTree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

        #print "making j1phiWoNoisyJets"
        self.j1phiWoNoisyJets_branch = the_tree.GetBranch("j1phiWoNoisyJets")
        #if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets" not in self.complained:
        if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets":
            warnings.warn( "EMTree: Expected branch j1phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phiWoNoisyJets")
        else:
            self.j1phiWoNoisyJets_branch.SetAddress(<void*>&self.j1phiWoNoisyJets_value)

        #print "making j1pt"
        self.j1pt_branch = the_tree.GetBranch("j1pt")
        #if not self.j1pt_branch and "j1pt" not in self.complained:
        if not self.j1pt_branch and "j1pt":
            warnings.warn( "EMTree: Expected branch j1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt")
        else:
            self.j1pt_branch.SetAddress(<void*>&self.j1pt_value)

        #print "making j1ptWoNoisyJets"
        self.j1ptWoNoisyJets_branch = the_tree.GetBranch("j1ptWoNoisyJets")
        #if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets" not in self.complained:
        if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets":
            warnings.warn( "EMTree: Expected branch j1ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets")
        else:
            self.j1ptWoNoisyJets_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_value)

        #print "making j1ptWoNoisyJets_JetEC2Down"
        self.j1ptWoNoisyJets_JetEC2Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEC2Down")
        #if not self.j1ptWoNoisyJets_JetEC2Down_branch and "j1ptWoNoisyJets_JetEC2Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEC2Down_branch and "j1ptWoNoisyJets_JetEC2Down":
            warnings.warn( "EMTree: Expected branch j1ptWoNoisyJets_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEC2Down")
        else:
            self.j1ptWoNoisyJets_JetEC2Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEC2Down_value)

        #print "making j1ptWoNoisyJets_JetEC2Up"
        self.j1ptWoNoisyJets_JetEC2Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEC2Up")
        #if not self.j1ptWoNoisyJets_JetEC2Up_branch and "j1ptWoNoisyJets_JetEC2Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEC2Up_branch and "j1ptWoNoisyJets_JetEC2Up":
            warnings.warn( "EMTree: Expected branch j1ptWoNoisyJets_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEC2Up")
        else:
            self.j1ptWoNoisyJets_JetEC2Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEC2Up_value)

        #print "making j1ptWoNoisyJets_JetEta0to3Down"
        self.j1ptWoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to3Down")
        #if not self.j1ptWoNoisyJets_JetEta0to3Down_branch and "j1ptWoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to3Down_branch and "j1ptWoNoisyJets_JetEta0to3Down":
            warnings.warn( "EMTree: Expected branch j1ptWoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to3Down")
        else:
            self.j1ptWoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to3Down_value)

        #print "making j1ptWoNoisyJets_JetEta0to3Up"
        self.j1ptWoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to3Up")
        #if not self.j1ptWoNoisyJets_JetEta0to3Up_branch and "j1ptWoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to3Up_branch and "j1ptWoNoisyJets_JetEta0to3Up":
            warnings.warn( "EMTree: Expected branch j1ptWoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to3Up")
        else:
            self.j1ptWoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to3Up_value)

        #print "making j1ptWoNoisyJets_JetEta0to5Down"
        self.j1ptWoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to5Down")
        #if not self.j1ptWoNoisyJets_JetEta0to5Down_branch and "j1ptWoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to5Down_branch and "j1ptWoNoisyJets_JetEta0to5Down":
            warnings.warn( "EMTree: Expected branch j1ptWoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to5Down")
        else:
            self.j1ptWoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to5Down_value)

        #print "making j1ptWoNoisyJets_JetEta0to5Up"
        self.j1ptWoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to5Up")
        #if not self.j1ptWoNoisyJets_JetEta0to5Up_branch and "j1ptWoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to5Up_branch and "j1ptWoNoisyJets_JetEta0to5Up":
            warnings.warn( "EMTree: Expected branch j1ptWoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to5Up")
        else:
            self.j1ptWoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to5Up_value)

        #print "making j1ptWoNoisyJets_JetEta3to5Down"
        self.j1ptWoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta3to5Down")
        #if not self.j1ptWoNoisyJets_JetEta3to5Down_branch and "j1ptWoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta3to5Down_branch and "j1ptWoNoisyJets_JetEta3to5Down":
            warnings.warn( "EMTree: Expected branch j1ptWoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta3to5Down")
        else:
            self.j1ptWoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta3to5Down_value)

        #print "making j1ptWoNoisyJets_JetEta3to5Up"
        self.j1ptWoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta3to5Up")
        #if not self.j1ptWoNoisyJets_JetEta3to5Up_branch and "j1ptWoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta3to5Up_branch and "j1ptWoNoisyJets_JetEta3to5Up":
            warnings.warn( "EMTree: Expected branch j1ptWoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta3to5Up")
        else:
            self.j1ptWoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta3to5Up_value)

        #print "making j1ptWoNoisyJets_JetRelativeBalDown"
        self.j1ptWoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeBalDown")
        #if not self.j1ptWoNoisyJets_JetRelativeBalDown_branch and "j1ptWoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeBalDown_branch and "j1ptWoNoisyJets_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch j1ptWoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeBalDown")
        else:
            self.j1ptWoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeBalDown_value)

        #print "making j1ptWoNoisyJets_JetRelativeBalUp"
        self.j1ptWoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeBalUp")
        #if not self.j1ptWoNoisyJets_JetRelativeBalUp_branch and "j1ptWoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeBalUp_branch and "j1ptWoNoisyJets_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch j1ptWoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeBalUp")
        else:
            self.j1ptWoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeBalUp_value)

        #print "making j1ptWoNoisyJets_JetRelativeSampleDown"
        self.j1ptWoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeSampleDown")
        #if not self.j1ptWoNoisyJets_JetRelativeSampleDown_branch and "j1ptWoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeSampleDown_branch and "j1ptWoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch j1ptWoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeSampleDown")
        else:
            self.j1ptWoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeSampleDown_value)

        #print "making j1ptWoNoisyJets_JetRelativeSampleUp"
        self.j1ptWoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeSampleUp")
        #if not self.j1ptWoNoisyJets_JetRelativeSampleUp_branch and "j1ptWoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeSampleUp_branch and "j1ptWoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch j1ptWoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeSampleUp")
        else:
            self.j1ptWoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeSampleUp_value)

        #print "making j1pt_JetEC2Down"
        self.j1pt_JetEC2Down_branch = the_tree.GetBranch("j1pt_JetEC2Down")
        #if not self.j1pt_JetEC2Down_branch and "j1pt_JetEC2Down" not in self.complained:
        if not self.j1pt_JetEC2Down_branch and "j1pt_JetEC2Down":
            warnings.warn( "EMTree: Expected branch j1pt_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetEC2Down")
        else:
            self.j1pt_JetEC2Down_branch.SetAddress(<void*>&self.j1pt_JetEC2Down_value)

        #print "making j1pt_JetEC2Up"
        self.j1pt_JetEC2Up_branch = the_tree.GetBranch("j1pt_JetEC2Up")
        #if not self.j1pt_JetEC2Up_branch and "j1pt_JetEC2Up" not in self.complained:
        if not self.j1pt_JetEC2Up_branch and "j1pt_JetEC2Up":
            warnings.warn( "EMTree: Expected branch j1pt_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetEC2Up")
        else:
            self.j1pt_JetEC2Up_branch.SetAddress(<void*>&self.j1pt_JetEC2Up_value)

        #print "making j1pt_JetEta0to3Down"
        self.j1pt_JetEta0to3Down_branch = the_tree.GetBranch("j1pt_JetEta0to3Down")
        #if not self.j1pt_JetEta0to3Down_branch and "j1pt_JetEta0to3Down" not in self.complained:
        if not self.j1pt_JetEta0to3Down_branch and "j1pt_JetEta0to3Down":
            warnings.warn( "EMTree: Expected branch j1pt_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetEta0to3Down")
        else:
            self.j1pt_JetEta0to3Down_branch.SetAddress(<void*>&self.j1pt_JetEta0to3Down_value)

        #print "making j1pt_JetEta0to3Up"
        self.j1pt_JetEta0to3Up_branch = the_tree.GetBranch("j1pt_JetEta0to3Up")
        #if not self.j1pt_JetEta0to3Up_branch and "j1pt_JetEta0to3Up" not in self.complained:
        if not self.j1pt_JetEta0to3Up_branch and "j1pt_JetEta0to3Up":
            warnings.warn( "EMTree: Expected branch j1pt_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetEta0to3Up")
        else:
            self.j1pt_JetEta0to3Up_branch.SetAddress(<void*>&self.j1pt_JetEta0to3Up_value)

        #print "making j1pt_JetEta0to5Down"
        self.j1pt_JetEta0to5Down_branch = the_tree.GetBranch("j1pt_JetEta0to5Down")
        #if not self.j1pt_JetEta0to5Down_branch and "j1pt_JetEta0to5Down" not in self.complained:
        if not self.j1pt_JetEta0to5Down_branch and "j1pt_JetEta0to5Down":
            warnings.warn( "EMTree: Expected branch j1pt_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetEta0to5Down")
        else:
            self.j1pt_JetEta0to5Down_branch.SetAddress(<void*>&self.j1pt_JetEta0to5Down_value)

        #print "making j1pt_JetEta0to5Up"
        self.j1pt_JetEta0to5Up_branch = the_tree.GetBranch("j1pt_JetEta0to5Up")
        #if not self.j1pt_JetEta0to5Up_branch and "j1pt_JetEta0to5Up" not in self.complained:
        if not self.j1pt_JetEta0to5Up_branch and "j1pt_JetEta0to5Up":
            warnings.warn( "EMTree: Expected branch j1pt_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetEta0to5Up")
        else:
            self.j1pt_JetEta0to5Up_branch.SetAddress(<void*>&self.j1pt_JetEta0to5Up_value)

        #print "making j1pt_JetEta3to5Down"
        self.j1pt_JetEta3to5Down_branch = the_tree.GetBranch("j1pt_JetEta3to5Down")
        #if not self.j1pt_JetEta3to5Down_branch and "j1pt_JetEta3to5Down" not in self.complained:
        if not self.j1pt_JetEta3to5Down_branch and "j1pt_JetEta3to5Down":
            warnings.warn( "EMTree: Expected branch j1pt_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetEta3to5Down")
        else:
            self.j1pt_JetEta3to5Down_branch.SetAddress(<void*>&self.j1pt_JetEta3to5Down_value)

        #print "making j1pt_JetEta3to5Up"
        self.j1pt_JetEta3to5Up_branch = the_tree.GetBranch("j1pt_JetEta3to5Up")
        #if not self.j1pt_JetEta3to5Up_branch and "j1pt_JetEta3to5Up" not in self.complained:
        if not self.j1pt_JetEta3to5Up_branch and "j1pt_JetEta3to5Up":
            warnings.warn( "EMTree: Expected branch j1pt_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetEta3to5Up")
        else:
            self.j1pt_JetEta3to5Up_branch.SetAddress(<void*>&self.j1pt_JetEta3to5Up_value)

        #print "making j1pt_JetRelativeBalDown"
        self.j1pt_JetRelativeBalDown_branch = the_tree.GetBranch("j1pt_JetRelativeBalDown")
        #if not self.j1pt_JetRelativeBalDown_branch and "j1pt_JetRelativeBalDown" not in self.complained:
        if not self.j1pt_JetRelativeBalDown_branch and "j1pt_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch j1pt_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetRelativeBalDown")
        else:
            self.j1pt_JetRelativeBalDown_branch.SetAddress(<void*>&self.j1pt_JetRelativeBalDown_value)

        #print "making j1pt_JetRelativeBalUp"
        self.j1pt_JetRelativeBalUp_branch = the_tree.GetBranch("j1pt_JetRelativeBalUp")
        #if not self.j1pt_JetRelativeBalUp_branch and "j1pt_JetRelativeBalUp" not in self.complained:
        if not self.j1pt_JetRelativeBalUp_branch and "j1pt_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch j1pt_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetRelativeBalUp")
        else:
            self.j1pt_JetRelativeBalUp_branch.SetAddress(<void*>&self.j1pt_JetRelativeBalUp_value)

        #print "making j1pt_JetRelativeSampleDown"
        self.j1pt_JetRelativeSampleDown_branch = the_tree.GetBranch("j1pt_JetRelativeSampleDown")
        #if not self.j1pt_JetRelativeSampleDown_branch and "j1pt_JetRelativeSampleDown" not in self.complained:
        if not self.j1pt_JetRelativeSampleDown_branch and "j1pt_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch j1pt_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetRelativeSampleDown")
        else:
            self.j1pt_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j1pt_JetRelativeSampleDown_value)

        #print "making j1pt_JetRelativeSampleUp"
        self.j1pt_JetRelativeSampleUp_branch = the_tree.GetBranch("j1pt_JetRelativeSampleUp")
        #if not self.j1pt_JetRelativeSampleUp_branch and "j1pt_JetRelativeSampleUp" not in self.complained:
        if not self.j1pt_JetRelativeSampleUp_branch and "j1pt_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch j1pt_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetRelativeSampleUp")
        else:
            self.j1pt_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j1pt_JetRelativeSampleUp_value)

        #print "making j2csv"
        self.j2csv_branch = the_tree.GetBranch("j2csv")
        #if not self.j2csv_branch and "j2csv" not in self.complained:
        if not self.j2csv_branch and "j2csv":
            warnings.warn( "EMTree: Expected branch j2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csv")
        else:
            self.j2csv_branch.SetAddress(<void*>&self.j2csv_value)

        #print "making j2csvWoNoisyJets"
        self.j2csvWoNoisyJets_branch = the_tree.GetBranch("j2csvWoNoisyJets")
        #if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets" not in self.complained:
        if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets":
            warnings.warn( "EMTree: Expected branch j2csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csvWoNoisyJets")
        else:
            self.j2csvWoNoisyJets_branch.SetAddress(<void*>&self.j2csvWoNoisyJets_value)

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "EMTree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

        #print "making j2etaWoNoisyJets"
        self.j2etaWoNoisyJets_branch = the_tree.GetBranch("j2etaWoNoisyJets")
        #if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets" not in self.complained:
        if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets":
            warnings.warn( "EMTree: Expected branch j2etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2etaWoNoisyJets")
        else:
            self.j2etaWoNoisyJets_branch.SetAddress(<void*>&self.j2etaWoNoisyJets_value)

        #print "making j2hadronflavor"
        self.j2hadronflavor_branch = the_tree.GetBranch("j2hadronflavor")
        #if not self.j2hadronflavor_branch and "j2hadronflavor" not in self.complained:
        if not self.j2hadronflavor_branch and "j2hadronflavor":
            warnings.warn( "EMTree: Expected branch j2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavor")
        else:
            self.j2hadronflavor_branch.SetAddress(<void*>&self.j2hadronflavor_value)

        #print "making j2hadronflavorWoNoisyJets"
        self.j2hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j2hadronflavorWoNoisyJets")
        #if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets" not in self.complained:
        if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets":
            warnings.warn( "EMTree: Expected branch j2hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavorWoNoisyJets")
        else:
            self.j2hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j2hadronflavorWoNoisyJets_value)

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "EMTree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

        #print "making j2phiWoNoisyJets"
        self.j2phiWoNoisyJets_branch = the_tree.GetBranch("j2phiWoNoisyJets")
        #if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets" not in self.complained:
        if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets":
            warnings.warn( "EMTree: Expected branch j2phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phiWoNoisyJets")
        else:
            self.j2phiWoNoisyJets_branch.SetAddress(<void*>&self.j2phiWoNoisyJets_value)

        #print "making j2pt"
        self.j2pt_branch = the_tree.GetBranch("j2pt")
        #if not self.j2pt_branch and "j2pt" not in self.complained:
        if not self.j2pt_branch and "j2pt":
            warnings.warn( "EMTree: Expected branch j2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt")
        else:
            self.j2pt_branch.SetAddress(<void*>&self.j2pt_value)

        #print "making j2ptWoNoisyJets"
        self.j2ptWoNoisyJets_branch = the_tree.GetBranch("j2ptWoNoisyJets")
        #if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets" not in self.complained:
        if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets":
            warnings.warn( "EMTree: Expected branch j2ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets")
        else:
            self.j2ptWoNoisyJets_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_value)

        #print "making j2ptWoNoisyJets_JetEC2Down"
        self.j2ptWoNoisyJets_JetEC2Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEC2Down")
        #if not self.j2ptWoNoisyJets_JetEC2Down_branch and "j2ptWoNoisyJets_JetEC2Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEC2Down_branch and "j2ptWoNoisyJets_JetEC2Down":
            warnings.warn( "EMTree: Expected branch j2ptWoNoisyJets_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEC2Down")
        else:
            self.j2ptWoNoisyJets_JetEC2Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEC2Down_value)

        #print "making j2ptWoNoisyJets_JetEC2Up"
        self.j2ptWoNoisyJets_JetEC2Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEC2Up")
        #if not self.j2ptWoNoisyJets_JetEC2Up_branch and "j2ptWoNoisyJets_JetEC2Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEC2Up_branch and "j2ptWoNoisyJets_JetEC2Up":
            warnings.warn( "EMTree: Expected branch j2ptWoNoisyJets_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEC2Up")
        else:
            self.j2ptWoNoisyJets_JetEC2Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEC2Up_value)

        #print "making j2ptWoNoisyJets_JetEta0to3Down"
        self.j2ptWoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to3Down")
        #if not self.j2ptWoNoisyJets_JetEta0to3Down_branch and "j2ptWoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to3Down_branch and "j2ptWoNoisyJets_JetEta0to3Down":
            warnings.warn( "EMTree: Expected branch j2ptWoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to3Down")
        else:
            self.j2ptWoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to3Down_value)

        #print "making j2ptWoNoisyJets_JetEta0to3Up"
        self.j2ptWoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to3Up")
        #if not self.j2ptWoNoisyJets_JetEta0to3Up_branch and "j2ptWoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to3Up_branch and "j2ptWoNoisyJets_JetEta0to3Up":
            warnings.warn( "EMTree: Expected branch j2ptWoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to3Up")
        else:
            self.j2ptWoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to3Up_value)

        #print "making j2ptWoNoisyJets_JetEta0to5Down"
        self.j2ptWoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to5Down")
        #if not self.j2ptWoNoisyJets_JetEta0to5Down_branch and "j2ptWoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to5Down_branch and "j2ptWoNoisyJets_JetEta0to5Down":
            warnings.warn( "EMTree: Expected branch j2ptWoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to5Down")
        else:
            self.j2ptWoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to5Down_value)

        #print "making j2ptWoNoisyJets_JetEta0to5Up"
        self.j2ptWoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to5Up")
        #if not self.j2ptWoNoisyJets_JetEta0to5Up_branch and "j2ptWoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to5Up_branch and "j2ptWoNoisyJets_JetEta0to5Up":
            warnings.warn( "EMTree: Expected branch j2ptWoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to5Up")
        else:
            self.j2ptWoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to5Up_value)

        #print "making j2ptWoNoisyJets_JetEta3to5Down"
        self.j2ptWoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta3to5Down")
        #if not self.j2ptWoNoisyJets_JetEta3to5Down_branch and "j2ptWoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta3to5Down_branch and "j2ptWoNoisyJets_JetEta3to5Down":
            warnings.warn( "EMTree: Expected branch j2ptWoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta3to5Down")
        else:
            self.j2ptWoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta3to5Down_value)

        #print "making j2ptWoNoisyJets_JetEta3to5Up"
        self.j2ptWoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta3to5Up")
        #if not self.j2ptWoNoisyJets_JetEta3to5Up_branch and "j2ptWoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta3to5Up_branch and "j2ptWoNoisyJets_JetEta3to5Up":
            warnings.warn( "EMTree: Expected branch j2ptWoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta3to5Up")
        else:
            self.j2ptWoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta3to5Up_value)

        #print "making j2ptWoNoisyJets_JetRelativeBalDown"
        self.j2ptWoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeBalDown")
        #if not self.j2ptWoNoisyJets_JetRelativeBalDown_branch and "j2ptWoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeBalDown_branch and "j2ptWoNoisyJets_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch j2ptWoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeBalDown")
        else:
            self.j2ptWoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeBalDown_value)

        #print "making j2ptWoNoisyJets_JetRelativeBalUp"
        self.j2ptWoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeBalUp")
        #if not self.j2ptWoNoisyJets_JetRelativeBalUp_branch and "j2ptWoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeBalUp_branch and "j2ptWoNoisyJets_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch j2ptWoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeBalUp")
        else:
            self.j2ptWoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeBalUp_value)

        #print "making j2ptWoNoisyJets_JetRelativeSampleDown"
        self.j2ptWoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeSampleDown")
        #if not self.j2ptWoNoisyJets_JetRelativeSampleDown_branch and "j2ptWoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeSampleDown_branch and "j2ptWoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch j2ptWoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeSampleDown")
        else:
            self.j2ptWoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeSampleDown_value)

        #print "making j2ptWoNoisyJets_JetRelativeSampleUp"
        self.j2ptWoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeSampleUp")
        #if not self.j2ptWoNoisyJets_JetRelativeSampleUp_branch and "j2ptWoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeSampleUp_branch and "j2ptWoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch j2ptWoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeSampleUp")
        else:
            self.j2ptWoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeSampleUp_value)

        #print "making j2pt_JetEC2Down"
        self.j2pt_JetEC2Down_branch = the_tree.GetBranch("j2pt_JetEC2Down")
        #if not self.j2pt_JetEC2Down_branch and "j2pt_JetEC2Down" not in self.complained:
        if not self.j2pt_JetEC2Down_branch and "j2pt_JetEC2Down":
            warnings.warn( "EMTree: Expected branch j2pt_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetEC2Down")
        else:
            self.j2pt_JetEC2Down_branch.SetAddress(<void*>&self.j2pt_JetEC2Down_value)

        #print "making j2pt_JetEC2Up"
        self.j2pt_JetEC2Up_branch = the_tree.GetBranch("j2pt_JetEC2Up")
        #if not self.j2pt_JetEC2Up_branch and "j2pt_JetEC2Up" not in self.complained:
        if not self.j2pt_JetEC2Up_branch and "j2pt_JetEC2Up":
            warnings.warn( "EMTree: Expected branch j2pt_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetEC2Up")
        else:
            self.j2pt_JetEC2Up_branch.SetAddress(<void*>&self.j2pt_JetEC2Up_value)

        #print "making j2pt_JetEta0to3Down"
        self.j2pt_JetEta0to3Down_branch = the_tree.GetBranch("j2pt_JetEta0to3Down")
        #if not self.j2pt_JetEta0to3Down_branch and "j2pt_JetEta0to3Down" not in self.complained:
        if not self.j2pt_JetEta0to3Down_branch and "j2pt_JetEta0to3Down":
            warnings.warn( "EMTree: Expected branch j2pt_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetEta0to3Down")
        else:
            self.j2pt_JetEta0to3Down_branch.SetAddress(<void*>&self.j2pt_JetEta0to3Down_value)

        #print "making j2pt_JetEta0to3Up"
        self.j2pt_JetEta0to3Up_branch = the_tree.GetBranch("j2pt_JetEta0to3Up")
        #if not self.j2pt_JetEta0to3Up_branch and "j2pt_JetEta0to3Up" not in self.complained:
        if not self.j2pt_JetEta0to3Up_branch and "j2pt_JetEta0to3Up":
            warnings.warn( "EMTree: Expected branch j2pt_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetEta0to3Up")
        else:
            self.j2pt_JetEta0to3Up_branch.SetAddress(<void*>&self.j2pt_JetEta0to3Up_value)

        #print "making j2pt_JetEta0to5Down"
        self.j2pt_JetEta0to5Down_branch = the_tree.GetBranch("j2pt_JetEta0to5Down")
        #if not self.j2pt_JetEta0to5Down_branch and "j2pt_JetEta0to5Down" not in self.complained:
        if not self.j2pt_JetEta0to5Down_branch and "j2pt_JetEta0to5Down":
            warnings.warn( "EMTree: Expected branch j2pt_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetEta0to5Down")
        else:
            self.j2pt_JetEta0to5Down_branch.SetAddress(<void*>&self.j2pt_JetEta0to5Down_value)

        #print "making j2pt_JetEta0to5Up"
        self.j2pt_JetEta0to5Up_branch = the_tree.GetBranch("j2pt_JetEta0to5Up")
        #if not self.j2pt_JetEta0to5Up_branch and "j2pt_JetEta0to5Up" not in self.complained:
        if not self.j2pt_JetEta0to5Up_branch and "j2pt_JetEta0to5Up":
            warnings.warn( "EMTree: Expected branch j2pt_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetEta0to5Up")
        else:
            self.j2pt_JetEta0to5Up_branch.SetAddress(<void*>&self.j2pt_JetEta0to5Up_value)

        #print "making j2pt_JetEta3to5Down"
        self.j2pt_JetEta3to5Down_branch = the_tree.GetBranch("j2pt_JetEta3to5Down")
        #if not self.j2pt_JetEta3to5Down_branch and "j2pt_JetEta3to5Down" not in self.complained:
        if not self.j2pt_JetEta3to5Down_branch and "j2pt_JetEta3to5Down":
            warnings.warn( "EMTree: Expected branch j2pt_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetEta3to5Down")
        else:
            self.j2pt_JetEta3to5Down_branch.SetAddress(<void*>&self.j2pt_JetEta3to5Down_value)

        #print "making j2pt_JetEta3to5Up"
        self.j2pt_JetEta3to5Up_branch = the_tree.GetBranch("j2pt_JetEta3to5Up")
        #if not self.j2pt_JetEta3to5Up_branch and "j2pt_JetEta3to5Up" not in self.complained:
        if not self.j2pt_JetEta3to5Up_branch and "j2pt_JetEta3to5Up":
            warnings.warn( "EMTree: Expected branch j2pt_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetEta3to5Up")
        else:
            self.j2pt_JetEta3to5Up_branch.SetAddress(<void*>&self.j2pt_JetEta3to5Up_value)

        #print "making j2pt_JetRelativeBalDown"
        self.j2pt_JetRelativeBalDown_branch = the_tree.GetBranch("j2pt_JetRelativeBalDown")
        #if not self.j2pt_JetRelativeBalDown_branch and "j2pt_JetRelativeBalDown" not in self.complained:
        if not self.j2pt_JetRelativeBalDown_branch and "j2pt_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch j2pt_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetRelativeBalDown")
        else:
            self.j2pt_JetRelativeBalDown_branch.SetAddress(<void*>&self.j2pt_JetRelativeBalDown_value)

        #print "making j2pt_JetRelativeBalUp"
        self.j2pt_JetRelativeBalUp_branch = the_tree.GetBranch("j2pt_JetRelativeBalUp")
        #if not self.j2pt_JetRelativeBalUp_branch and "j2pt_JetRelativeBalUp" not in self.complained:
        if not self.j2pt_JetRelativeBalUp_branch and "j2pt_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch j2pt_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetRelativeBalUp")
        else:
            self.j2pt_JetRelativeBalUp_branch.SetAddress(<void*>&self.j2pt_JetRelativeBalUp_value)

        #print "making j2pt_JetRelativeSampleDown"
        self.j2pt_JetRelativeSampleDown_branch = the_tree.GetBranch("j2pt_JetRelativeSampleDown")
        #if not self.j2pt_JetRelativeSampleDown_branch and "j2pt_JetRelativeSampleDown" not in self.complained:
        if not self.j2pt_JetRelativeSampleDown_branch and "j2pt_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch j2pt_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetRelativeSampleDown")
        else:
            self.j2pt_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j2pt_JetRelativeSampleDown_value)

        #print "making j2pt_JetRelativeSampleUp"
        self.j2pt_JetRelativeSampleUp_branch = the_tree.GetBranch("j2pt_JetRelativeSampleUp")
        #if not self.j2pt_JetRelativeSampleUp_branch and "j2pt_JetRelativeSampleUp" not in self.complained:
        if not self.j2pt_JetRelativeSampleUp_branch and "j2pt_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch j2pt_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetRelativeSampleUp")
        else:
            self.j2pt_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j2pt_JetRelativeSampleUp_value)

        #print "making jb1eta_2016"
        self.jb1eta_2016_branch = the_tree.GetBranch("jb1eta_2016")
        #if not self.jb1eta_2016_branch and "jb1eta_2016" not in self.complained:
        if not self.jb1eta_2016_branch and "jb1eta_2016":
            warnings.warn( "EMTree: Expected branch jb1eta_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2016")
        else:
            self.jb1eta_2016_branch.SetAddress(<void*>&self.jb1eta_2016_value)

        #print "making jb1eta_2017"
        self.jb1eta_2017_branch = the_tree.GetBranch("jb1eta_2017")
        #if not self.jb1eta_2017_branch and "jb1eta_2017" not in self.complained:
        if not self.jb1eta_2017_branch and "jb1eta_2017":
            warnings.warn( "EMTree: Expected branch jb1eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2017")
        else:
            self.jb1eta_2017_branch.SetAddress(<void*>&self.jb1eta_2017_value)

        #print "making jb1eta_2018"
        self.jb1eta_2018_branch = the_tree.GetBranch("jb1eta_2018")
        #if not self.jb1eta_2018_branch and "jb1eta_2018" not in self.complained:
        if not self.jb1eta_2018_branch and "jb1eta_2018":
            warnings.warn( "EMTree: Expected branch jb1eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2018")
        else:
            self.jb1eta_2018_branch.SetAddress(<void*>&self.jb1eta_2018_value)

        #print "making jb1hadronflavor_2016"
        self.jb1hadronflavor_2016_branch = the_tree.GetBranch("jb1hadronflavor_2016")
        #if not self.jb1hadronflavor_2016_branch and "jb1hadronflavor_2016" not in self.complained:
        if not self.jb1hadronflavor_2016_branch and "jb1hadronflavor_2016":
            warnings.warn( "EMTree: Expected branch jb1hadronflavor_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2016")
        else:
            self.jb1hadronflavor_2016_branch.SetAddress(<void*>&self.jb1hadronflavor_2016_value)

        #print "making jb1hadronflavor_2017"
        self.jb1hadronflavor_2017_branch = the_tree.GetBranch("jb1hadronflavor_2017")
        #if not self.jb1hadronflavor_2017_branch and "jb1hadronflavor_2017" not in self.complained:
        if not self.jb1hadronflavor_2017_branch and "jb1hadronflavor_2017":
            warnings.warn( "EMTree: Expected branch jb1hadronflavor_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2017")
        else:
            self.jb1hadronflavor_2017_branch.SetAddress(<void*>&self.jb1hadronflavor_2017_value)

        #print "making jb1hadronflavor_2018"
        self.jb1hadronflavor_2018_branch = the_tree.GetBranch("jb1hadronflavor_2018")
        #if not self.jb1hadronflavor_2018_branch and "jb1hadronflavor_2018" not in self.complained:
        if not self.jb1hadronflavor_2018_branch and "jb1hadronflavor_2018":
            warnings.warn( "EMTree: Expected branch jb1hadronflavor_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2018")
        else:
            self.jb1hadronflavor_2018_branch.SetAddress(<void*>&self.jb1hadronflavor_2018_value)

        #print "making jb1phi_2016"
        self.jb1phi_2016_branch = the_tree.GetBranch("jb1phi_2016")
        #if not self.jb1phi_2016_branch and "jb1phi_2016" not in self.complained:
        if not self.jb1phi_2016_branch and "jb1phi_2016":
            warnings.warn( "EMTree: Expected branch jb1phi_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2016")
        else:
            self.jb1phi_2016_branch.SetAddress(<void*>&self.jb1phi_2016_value)

        #print "making jb1phi_2017"
        self.jb1phi_2017_branch = the_tree.GetBranch("jb1phi_2017")
        #if not self.jb1phi_2017_branch and "jb1phi_2017" not in self.complained:
        if not self.jb1phi_2017_branch and "jb1phi_2017":
            warnings.warn( "EMTree: Expected branch jb1phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2017")
        else:
            self.jb1phi_2017_branch.SetAddress(<void*>&self.jb1phi_2017_value)

        #print "making jb1phi_2018"
        self.jb1phi_2018_branch = the_tree.GetBranch("jb1phi_2018")
        #if not self.jb1phi_2018_branch and "jb1phi_2018" not in self.complained:
        if not self.jb1phi_2018_branch and "jb1phi_2018":
            warnings.warn( "EMTree: Expected branch jb1phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2018")
        else:
            self.jb1phi_2018_branch.SetAddress(<void*>&self.jb1phi_2018_value)

        #print "making jb1pt_2016"
        self.jb1pt_2016_branch = the_tree.GetBranch("jb1pt_2016")
        #if not self.jb1pt_2016_branch and "jb1pt_2016" not in self.complained:
        if not self.jb1pt_2016_branch and "jb1pt_2016":
            warnings.warn( "EMTree: Expected branch jb1pt_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2016")
        else:
            self.jb1pt_2016_branch.SetAddress(<void*>&self.jb1pt_2016_value)

        #print "making jb1pt_2017"
        self.jb1pt_2017_branch = the_tree.GetBranch("jb1pt_2017")
        #if not self.jb1pt_2017_branch and "jb1pt_2017" not in self.complained:
        if not self.jb1pt_2017_branch and "jb1pt_2017":
            warnings.warn( "EMTree: Expected branch jb1pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2017")
        else:
            self.jb1pt_2017_branch.SetAddress(<void*>&self.jb1pt_2017_value)

        #print "making jb1pt_2018"
        self.jb1pt_2018_branch = the_tree.GetBranch("jb1pt_2018")
        #if not self.jb1pt_2018_branch and "jb1pt_2018" not in self.complained:
        if not self.jb1pt_2018_branch and "jb1pt_2018":
            warnings.warn( "EMTree: Expected branch jb1pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2018")
        else:
            self.jb1pt_2018_branch.SetAddress(<void*>&self.jb1pt_2018_value)

        #print "making jb2eta_2016"
        self.jb2eta_2016_branch = the_tree.GetBranch("jb2eta_2016")
        #if not self.jb2eta_2016_branch and "jb2eta_2016" not in self.complained:
        if not self.jb2eta_2016_branch and "jb2eta_2016":
            warnings.warn( "EMTree: Expected branch jb2eta_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2016")
        else:
            self.jb2eta_2016_branch.SetAddress(<void*>&self.jb2eta_2016_value)

        #print "making jb2eta_2017"
        self.jb2eta_2017_branch = the_tree.GetBranch("jb2eta_2017")
        #if not self.jb2eta_2017_branch and "jb2eta_2017" not in self.complained:
        if not self.jb2eta_2017_branch and "jb2eta_2017":
            warnings.warn( "EMTree: Expected branch jb2eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2017")
        else:
            self.jb2eta_2017_branch.SetAddress(<void*>&self.jb2eta_2017_value)

        #print "making jb2eta_2018"
        self.jb2eta_2018_branch = the_tree.GetBranch("jb2eta_2018")
        #if not self.jb2eta_2018_branch and "jb2eta_2018" not in self.complained:
        if not self.jb2eta_2018_branch and "jb2eta_2018":
            warnings.warn( "EMTree: Expected branch jb2eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2018")
        else:
            self.jb2eta_2018_branch.SetAddress(<void*>&self.jb2eta_2018_value)

        #print "making jb2hadronflavor_2016"
        self.jb2hadronflavor_2016_branch = the_tree.GetBranch("jb2hadronflavor_2016")
        #if not self.jb2hadronflavor_2016_branch and "jb2hadronflavor_2016" not in self.complained:
        if not self.jb2hadronflavor_2016_branch and "jb2hadronflavor_2016":
            warnings.warn( "EMTree: Expected branch jb2hadronflavor_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2016")
        else:
            self.jb2hadronflavor_2016_branch.SetAddress(<void*>&self.jb2hadronflavor_2016_value)

        #print "making jb2hadronflavor_2017"
        self.jb2hadronflavor_2017_branch = the_tree.GetBranch("jb2hadronflavor_2017")
        #if not self.jb2hadronflavor_2017_branch and "jb2hadronflavor_2017" not in self.complained:
        if not self.jb2hadronflavor_2017_branch and "jb2hadronflavor_2017":
            warnings.warn( "EMTree: Expected branch jb2hadronflavor_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2017")
        else:
            self.jb2hadronflavor_2017_branch.SetAddress(<void*>&self.jb2hadronflavor_2017_value)

        #print "making jb2hadronflavor_2018"
        self.jb2hadronflavor_2018_branch = the_tree.GetBranch("jb2hadronflavor_2018")
        #if not self.jb2hadronflavor_2018_branch and "jb2hadronflavor_2018" not in self.complained:
        if not self.jb2hadronflavor_2018_branch and "jb2hadronflavor_2018":
            warnings.warn( "EMTree: Expected branch jb2hadronflavor_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2018")
        else:
            self.jb2hadronflavor_2018_branch.SetAddress(<void*>&self.jb2hadronflavor_2018_value)

        #print "making jb2phi_2016"
        self.jb2phi_2016_branch = the_tree.GetBranch("jb2phi_2016")
        #if not self.jb2phi_2016_branch and "jb2phi_2016" not in self.complained:
        if not self.jb2phi_2016_branch and "jb2phi_2016":
            warnings.warn( "EMTree: Expected branch jb2phi_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2016")
        else:
            self.jb2phi_2016_branch.SetAddress(<void*>&self.jb2phi_2016_value)

        #print "making jb2phi_2017"
        self.jb2phi_2017_branch = the_tree.GetBranch("jb2phi_2017")
        #if not self.jb2phi_2017_branch and "jb2phi_2017" not in self.complained:
        if not self.jb2phi_2017_branch and "jb2phi_2017":
            warnings.warn( "EMTree: Expected branch jb2phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2017")
        else:
            self.jb2phi_2017_branch.SetAddress(<void*>&self.jb2phi_2017_value)

        #print "making jb2phi_2018"
        self.jb2phi_2018_branch = the_tree.GetBranch("jb2phi_2018")
        #if not self.jb2phi_2018_branch and "jb2phi_2018" not in self.complained:
        if not self.jb2phi_2018_branch and "jb2phi_2018":
            warnings.warn( "EMTree: Expected branch jb2phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2018")
        else:
            self.jb2phi_2018_branch.SetAddress(<void*>&self.jb2phi_2018_value)

        #print "making jb2pt_2016"
        self.jb2pt_2016_branch = the_tree.GetBranch("jb2pt_2016")
        #if not self.jb2pt_2016_branch and "jb2pt_2016" not in self.complained:
        if not self.jb2pt_2016_branch and "jb2pt_2016":
            warnings.warn( "EMTree: Expected branch jb2pt_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2016")
        else:
            self.jb2pt_2016_branch.SetAddress(<void*>&self.jb2pt_2016_value)

        #print "making jb2pt_2017"
        self.jb2pt_2017_branch = the_tree.GetBranch("jb2pt_2017")
        #if not self.jb2pt_2017_branch and "jb2pt_2017" not in self.complained:
        if not self.jb2pt_2017_branch and "jb2pt_2017":
            warnings.warn( "EMTree: Expected branch jb2pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2017")
        else:
            self.jb2pt_2017_branch.SetAddress(<void*>&self.jb2pt_2017_value)

        #print "making jb2pt_2018"
        self.jb2pt_2018_branch = the_tree.GetBranch("jb2pt_2018")
        #if not self.jb2pt_2018_branch and "jb2pt_2018" not in self.complained:
        if not self.jb2pt_2018_branch and "jb2pt_2018":
            warnings.warn( "EMTree: Expected branch jb2pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2018")
        else:
            self.jb2pt_2018_branch.SetAddress(<void*>&self.jb2pt_2018_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "EMTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20WoNoisyJets"
        self.jetVeto20WoNoisyJets_branch = the_tree.GetBranch("jetVeto20WoNoisyJets")
        #if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets" not in self.complained:
        if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets":
            warnings.warn( "EMTree: Expected branch jetVeto20WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20WoNoisyJets")
        else:
            self.jetVeto20WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto20WoNoisyJets_value)

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "EMTree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "EMTree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "EMTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30WoNoisyJets"
        self.jetVeto30WoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_value)

        #print "making jetVeto30WoNoisyJets_JetEC2Down"
        self.jetVeto30WoNoisyJets_JetEC2Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEC2Down")
        #if not self.jetVeto30WoNoisyJets_JetEC2Down_branch and "jetVeto30WoNoisyJets_JetEC2Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEC2Down_branch and "jetVeto30WoNoisyJets_JetEC2Down":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEC2Down")
        else:
            self.jetVeto30WoNoisyJets_JetEC2Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEC2Down_value)

        #print "making jetVeto30WoNoisyJets_JetEC2Up"
        self.jetVeto30WoNoisyJets_JetEC2Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEC2Up")
        #if not self.jetVeto30WoNoisyJets_JetEC2Up_branch and "jetVeto30WoNoisyJets_JetEC2Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEC2Up_branch and "jetVeto30WoNoisyJets_JetEC2Up":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEC2Up")
        else:
            self.jetVeto30WoNoisyJets_JetEC2Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEC2Up_value)

        #print "making jetVeto30WoNoisyJets_JetEnDown"
        self.jetVeto30WoNoisyJets_JetEnDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEnDown")
        #if not self.jetVeto30WoNoisyJets_JetEnDown_branch and "jetVeto30WoNoisyJets_JetEnDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEnDown_branch and "jetVeto30WoNoisyJets_JetEnDown":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEnDown")
        else:
            self.jetVeto30WoNoisyJets_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEnDown_value)

        #print "making jetVeto30WoNoisyJets_JetEnUp"
        self.jetVeto30WoNoisyJets_JetEnUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEnUp")
        #if not self.jetVeto30WoNoisyJets_JetEnUp_branch and "jetVeto30WoNoisyJets_JetEnUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEnUp_branch and "jetVeto30WoNoisyJets_JetEnUp":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEnUp")
        else:
            self.jetVeto30WoNoisyJets_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEnUp_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to3Down"
        self.jetVeto30WoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to3Down")
        #if not self.jetVeto30WoNoisyJets_JetEta0to3Down_branch and "jetVeto30WoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to3Down_branch and "jetVeto30WoNoisyJets_JetEta0to3Down":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to3Down")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to3Down_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to3Up"
        self.jetVeto30WoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to3Up")
        #if not self.jetVeto30WoNoisyJets_JetEta0to3Up_branch and "jetVeto30WoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to3Up_branch and "jetVeto30WoNoisyJets_JetEta0to3Up":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to3Up")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to3Up_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to5Down"
        self.jetVeto30WoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to5Down")
        #if not self.jetVeto30WoNoisyJets_JetEta0to5Down_branch and "jetVeto30WoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to5Down_branch and "jetVeto30WoNoisyJets_JetEta0to5Down":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to5Down")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to5Down_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to5Up"
        self.jetVeto30WoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to5Up")
        #if not self.jetVeto30WoNoisyJets_JetEta0to5Up_branch and "jetVeto30WoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to5Up_branch and "jetVeto30WoNoisyJets_JetEta0to5Up":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to5Up")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to5Up_value)

        #print "making jetVeto30WoNoisyJets_JetEta3to5Down"
        self.jetVeto30WoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta3to5Down")
        #if not self.jetVeto30WoNoisyJets_JetEta3to5Down_branch and "jetVeto30WoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta3to5Down_branch and "jetVeto30WoNoisyJets_JetEta3to5Down":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta3to5Down")
        else:
            self.jetVeto30WoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta3to5Down_value)

        #print "making jetVeto30WoNoisyJets_JetEta3to5Up"
        self.jetVeto30WoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta3to5Up")
        #if not self.jetVeto30WoNoisyJets_JetEta3to5Up_branch and "jetVeto30WoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta3to5Up_branch and "jetVeto30WoNoisyJets_JetEta3to5Up":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta3to5Up")
        else:
            self.jetVeto30WoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta3to5Up_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets"
        self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch and "jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch and "jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets"
        self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch and "jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch and "jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeSampleDown"
        self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeSampleDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch and "jetVeto30WoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch and "jetVeto30WoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeSampleDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeSampleDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeSampleUp"
        self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeSampleUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch and "jetVeto30WoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch and "jetVeto30WoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeSampleUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeSampleUp_value)

        #print "making jetVeto30WoNoisyJets_JetTotalDown"
        self.jetVeto30WoNoisyJets_JetTotalDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetTotalDown")
        #if not self.jetVeto30WoNoisyJets_JetTotalDown_branch and "jetVeto30WoNoisyJets_JetTotalDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetTotalDown_branch and "jetVeto30WoNoisyJets_JetTotalDown":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetTotalDown")
        else:
            self.jetVeto30WoNoisyJets_JetTotalDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetTotalDown_value)

        #print "making jetVeto30WoNoisyJets_JetTotalUp"
        self.jetVeto30WoNoisyJets_JetTotalUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetTotalUp")
        #if not self.jetVeto30WoNoisyJets_JetTotalUp_branch and "jetVeto30WoNoisyJets_JetTotalUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetTotalUp_branch and "jetVeto30WoNoisyJets_JetTotalUp":
            warnings.warn( "EMTree: Expected branch jetVeto30WoNoisyJets_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetTotalUp")
        else:
            self.jetVeto30WoNoisyJets_JetTotalUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetTotalUp_value)

        #print "making jetVeto30_JetAbsoluteFlavMapDown"
        self.jetVeto30_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteFlavMapDown")
        #if not self.jetVeto30_JetAbsoluteFlavMapDown_branch and "jetVeto30_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteFlavMapDown_branch and "jetVeto30_JetAbsoluteFlavMapDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteFlavMapDown")
        else:
            self.jetVeto30_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteFlavMapDown_value)

        #print "making jetVeto30_JetAbsoluteFlavMapUp"
        self.jetVeto30_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteFlavMapUp")
        #if not self.jetVeto30_JetAbsoluteFlavMapUp_branch and "jetVeto30_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteFlavMapUp_branch and "jetVeto30_JetAbsoluteFlavMapUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteFlavMapUp")
        else:
            self.jetVeto30_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteFlavMapUp_value)

        #print "making jetVeto30_JetAbsoluteMPFBiasDown"
        self.jetVeto30_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteMPFBiasDown")
        #if not self.jetVeto30_JetAbsoluteMPFBiasDown_branch and "jetVeto30_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteMPFBiasDown_branch and "jetVeto30_JetAbsoluteMPFBiasDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteMPFBiasDown")
        else:
            self.jetVeto30_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteMPFBiasDown_value)

        #print "making jetVeto30_JetAbsoluteMPFBiasUp"
        self.jetVeto30_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteMPFBiasUp")
        #if not self.jetVeto30_JetAbsoluteMPFBiasUp_branch and "jetVeto30_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteMPFBiasUp_branch and "jetVeto30_JetAbsoluteMPFBiasUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteMPFBiasUp")
        else:
            self.jetVeto30_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteMPFBiasUp_value)

        #print "making jetVeto30_JetAbsoluteScaleDown"
        self.jetVeto30_JetAbsoluteScaleDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteScaleDown")
        #if not self.jetVeto30_JetAbsoluteScaleDown_branch and "jetVeto30_JetAbsoluteScaleDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteScaleDown_branch and "jetVeto30_JetAbsoluteScaleDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteScaleDown")
        else:
            self.jetVeto30_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteScaleDown_value)

        #print "making jetVeto30_JetAbsoluteScaleUp"
        self.jetVeto30_JetAbsoluteScaleUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteScaleUp")
        #if not self.jetVeto30_JetAbsoluteScaleUp_branch and "jetVeto30_JetAbsoluteScaleUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteScaleUp_branch and "jetVeto30_JetAbsoluteScaleUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteScaleUp")
        else:
            self.jetVeto30_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteScaleUp_value)

        #print "making jetVeto30_JetAbsoluteStatDown"
        self.jetVeto30_JetAbsoluteStatDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteStatDown")
        #if not self.jetVeto30_JetAbsoluteStatDown_branch and "jetVeto30_JetAbsoluteStatDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteStatDown_branch and "jetVeto30_JetAbsoluteStatDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteStatDown")
        else:
            self.jetVeto30_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteStatDown_value)

        #print "making jetVeto30_JetAbsoluteStatUp"
        self.jetVeto30_JetAbsoluteStatUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteStatUp")
        #if not self.jetVeto30_JetAbsoluteStatUp_branch and "jetVeto30_JetAbsoluteStatUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteStatUp_branch and "jetVeto30_JetAbsoluteStatUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteStatUp")
        else:
            self.jetVeto30_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteStatUp_value)

        #print "making jetVeto30_JetClosureDown"
        self.jetVeto30_JetClosureDown_branch = the_tree.GetBranch("jetVeto30_JetClosureDown")
        #if not self.jetVeto30_JetClosureDown_branch and "jetVeto30_JetClosureDown" not in self.complained:
        if not self.jetVeto30_JetClosureDown_branch and "jetVeto30_JetClosureDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetClosureDown")
        else:
            self.jetVeto30_JetClosureDown_branch.SetAddress(<void*>&self.jetVeto30_JetClosureDown_value)

        #print "making jetVeto30_JetClosureUp"
        self.jetVeto30_JetClosureUp_branch = the_tree.GetBranch("jetVeto30_JetClosureUp")
        #if not self.jetVeto30_JetClosureUp_branch and "jetVeto30_JetClosureUp" not in self.complained:
        if not self.jetVeto30_JetClosureUp_branch and "jetVeto30_JetClosureUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetClosureUp")
        else:
            self.jetVeto30_JetClosureUp_branch.SetAddress(<void*>&self.jetVeto30_JetClosureUp_value)

        #print "making jetVeto30_JetEC2Down"
        self.jetVeto30_JetEC2Down_branch = the_tree.GetBranch("jetVeto30_JetEC2Down")
        #if not self.jetVeto30_JetEC2Down_branch and "jetVeto30_JetEC2Down" not in self.complained:
        if not self.jetVeto30_JetEC2Down_branch and "jetVeto30_JetEC2Down":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEC2Down")
        else:
            self.jetVeto30_JetEC2Down_branch.SetAddress(<void*>&self.jetVeto30_JetEC2Down_value)

        #print "making jetVeto30_JetEC2Up"
        self.jetVeto30_JetEC2Up_branch = the_tree.GetBranch("jetVeto30_JetEC2Up")
        #if not self.jetVeto30_JetEC2Up_branch and "jetVeto30_JetEC2Up" not in self.complained:
        if not self.jetVeto30_JetEC2Up_branch and "jetVeto30_JetEC2Up":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEC2Up")
        else:
            self.jetVeto30_JetEC2Up_branch.SetAddress(<void*>&self.jetVeto30_JetEC2Up_value)

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making jetVeto30_JetEta0to3Down"
        self.jetVeto30_JetEta0to3Down_branch = the_tree.GetBranch("jetVeto30_JetEta0to3Down")
        #if not self.jetVeto30_JetEta0to3Down_branch and "jetVeto30_JetEta0to3Down" not in self.complained:
        if not self.jetVeto30_JetEta0to3Down_branch and "jetVeto30_JetEta0to3Down":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEta0to3Down")
        else:
            self.jetVeto30_JetEta0to3Down_branch.SetAddress(<void*>&self.jetVeto30_JetEta0to3Down_value)

        #print "making jetVeto30_JetEta0to3Up"
        self.jetVeto30_JetEta0to3Up_branch = the_tree.GetBranch("jetVeto30_JetEta0to3Up")
        #if not self.jetVeto30_JetEta0to3Up_branch and "jetVeto30_JetEta0to3Up" not in self.complained:
        if not self.jetVeto30_JetEta0to3Up_branch and "jetVeto30_JetEta0to3Up":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEta0to3Up")
        else:
            self.jetVeto30_JetEta0to3Up_branch.SetAddress(<void*>&self.jetVeto30_JetEta0to3Up_value)

        #print "making jetVeto30_JetEta0to5Down"
        self.jetVeto30_JetEta0to5Down_branch = the_tree.GetBranch("jetVeto30_JetEta0to5Down")
        #if not self.jetVeto30_JetEta0to5Down_branch and "jetVeto30_JetEta0to5Down" not in self.complained:
        if not self.jetVeto30_JetEta0to5Down_branch and "jetVeto30_JetEta0to5Down":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEta0to5Down")
        else:
            self.jetVeto30_JetEta0to5Down_branch.SetAddress(<void*>&self.jetVeto30_JetEta0to5Down_value)

        #print "making jetVeto30_JetEta0to5Up"
        self.jetVeto30_JetEta0to5Up_branch = the_tree.GetBranch("jetVeto30_JetEta0to5Up")
        #if not self.jetVeto30_JetEta0to5Up_branch and "jetVeto30_JetEta0to5Up" not in self.complained:
        if not self.jetVeto30_JetEta0to5Up_branch and "jetVeto30_JetEta0to5Up":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEta0to5Up")
        else:
            self.jetVeto30_JetEta0to5Up_branch.SetAddress(<void*>&self.jetVeto30_JetEta0to5Up_value)

        #print "making jetVeto30_JetEta3to5Down"
        self.jetVeto30_JetEta3to5Down_branch = the_tree.GetBranch("jetVeto30_JetEta3to5Down")
        #if not self.jetVeto30_JetEta3to5Down_branch and "jetVeto30_JetEta3to5Down" not in self.complained:
        if not self.jetVeto30_JetEta3to5Down_branch and "jetVeto30_JetEta3to5Down":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEta3to5Down")
        else:
            self.jetVeto30_JetEta3to5Down_branch.SetAddress(<void*>&self.jetVeto30_JetEta3to5Down_value)

        #print "making jetVeto30_JetEta3to5Up"
        self.jetVeto30_JetEta3to5Up_branch = the_tree.GetBranch("jetVeto30_JetEta3to5Up")
        #if not self.jetVeto30_JetEta3to5Up_branch and "jetVeto30_JetEta3to5Up" not in self.complained:
        if not self.jetVeto30_JetEta3to5Up_branch and "jetVeto30_JetEta3to5Up":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEta3to5Up")
        else:
            self.jetVeto30_JetEta3to5Up_branch.SetAddress(<void*>&self.jetVeto30_JetEta3to5Up_value)

        #print "making jetVeto30_JetFlavorQCDDown"
        self.jetVeto30_JetFlavorQCDDown_branch = the_tree.GetBranch("jetVeto30_JetFlavorQCDDown")
        #if not self.jetVeto30_JetFlavorQCDDown_branch and "jetVeto30_JetFlavorQCDDown" not in self.complained:
        if not self.jetVeto30_JetFlavorQCDDown_branch and "jetVeto30_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFlavorQCDDown")
        else:
            self.jetVeto30_JetFlavorQCDDown_branch.SetAddress(<void*>&self.jetVeto30_JetFlavorQCDDown_value)

        #print "making jetVeto30_JetFlavorQCDUp"
        self.jetVeto30_JetFlavorQCDUp_branch = the_tree.GetBranch("jetVeto30_JetFlavorQCDUp")
        #if not self.jetVeto30_JetFlavorQCDUp_branch and "jetVeto30_JetFlavorQCDUp" not in self.complained:
        if not self.jetVeto30_JetFlavorQCDUp_branch and "jetVeto30_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFlavorQCDUp")
        else:
            self.jetVeto30_JetFlavorQCDUp_branch.SetAddress(<void*>&self.jetVeto30_JetFlavorQCDUp_value)

        #print "making jetVeto30_JetFragmentationDown"
        self.jetVeto30_JetFragmentationDown_branch = the_tree.GetBranch("jetVeto30_JetFragmentationDown")
        #if not self.jetVeto30_JetFragmentationDown_branch and "jetVeto30_JetFragmentationDown" not in self.complained:
        if not self.jetVeto30_JetFragmentationDown_branch and "jetVeto30_JetFragmentationDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFragmentationDown")
        else:
            self.jetVeto30_JetFragmentationDown_branch.SetAddress(<void*>&self.jetVeto30_JetFragmentationDown_value)

        #print "making jetVeto30_JetFragmentationUp"
        self.jetVeto30_JetFragmentationUp_branch = the_tree.GetBranch("jetVeto30_JetFragmentationUp")
        #if not self.jetVeto30_JetFragmentationUp_branch and "jetVeto30_JetFragmentationUp" not in self.complained:
        if not self.jetVeto30_JetFragmentationUp_branch and "jetVeto30_JetFragmentationUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFragmentationUp")
        else:
            self.jetVeto30_JetFragmentationUp_branch.SetAddress(<void*>&self.jetVeto30_JetFragmentationUp_value)

        #print "making jetVeto30_JetPileUpDataMCDown"
        self.jetVeto30_JetPileUpDataMCDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpDataMCDown")
        #if not self.jetVeto30_JetPileUpDataMCDown_branch and "jetVeto30_JetPileUpDataMCDown" not in self.complained:
        if not self.jetVeto30_JetPileUpDataMCDown_branch and "jetVeto30_JetPileUpDataMCDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpDataMCDown")
        else:
            self.jetVeto30_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpDataMCDown_value)

        #print "making jetVeto30_JetPileUpDataMCUp"
        self.jetVeto30_JetPileUpDataMCUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpDataMCUp")
        #if not self.jetVeto30_JetPileUpDataMCUp_branch and "jetVeto30_JetPileUpDataMCUp" not in self.complained:
        if not self.jetVeto30_JetPileUpDataMCUp_branch and "jetVeto30_JetPileUpDataMCUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpDataMCUp")
        else:
            self.jetVeto30_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpDataMCUp_value)

        #print "making jetVeto30_JetPileUpPtBBDown"
        self.jetVeto30_JetPileUpPtBBDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtBBDown")
        #if not self.jetVeto30_JetPileUpPtBBDown_branch and "jetVeto30_JetPileUpPtBBDown" not in self.complained:
        if not self.jetVeto30_JetPileUpPtBBDown_branch and "jetVeto30_JetPileUpPtBBDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtBBDown")
        else:
            self.jetVeto30_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtBBDown_value)

        #print "making jetVeto30_JetPileUpPtBBUp"
        self.jetVeto30_JetPileUpPtBBUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtBBUp")
        #if not self.jetVeto30_JetPileUpPtBBUp_branch and "jetVeto30_JetPileUpPtBBUp" not in self.complained:
        if not self.jetVeto30_JetPileUpPtBBUp_branch and "jetVeto30_JetPileUpPtBBUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtBBUp")
        else:
            self.jetVeto30_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtBBUp_value)

        #print "making jetVeto30_JetPileUpPtEC1Down"
        self.jetVeto30_JetPileUpPtEC1Down_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC1Down")
        #if not self.jetVeto30_JetPileUpPtEC1Down_branch and "jetVeto30_JetPileUpPtEC1Down" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC1Down_branch and "jetVeto30_JetPileUpPtEC1Down":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC1Down")
        else:
            self.jetVeto30_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC1Down_value)

        #print "making jetVeto30_JetPileUpPtEC1Up"
        self.jetVeto30_JetPileUpPtEC1Up_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC1Up")
        #if not self.jetVeto30_JetPileUpPtEC1Up_branch and "jetVeto30_JetPileUpPtEC1Up" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC1Up_branch and "jetVeto30_JetPileUpPtEC1Up":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC1Up")
        else:
            self.jetVeto30_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC1Up_value)

        #print "making jetVeto30_JetPileUpPtEC2Down"
        self.jetVeto30_JetPileUpPtEC2Down_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC2Down")
        #if not self.jetVeto30_JetPileUpPtEC2Down_branch and "jetVeto30_JetPileUpPtEC2Down" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC2Down_branch and "jetVeto30_JetPileUpPtEC2Down":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC2Down")
        else:
            self.jetVeto30_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC2Down_value)

        #print "making jetVeto30_JetPileUpPtEC2Up"
        self.jetVeto30_JetPileUpPtEC2Up_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC2Up")
        #if not self.jetVeto30_JetPileUpPtEC2Up_branch and "jetVeto30_JetPileUpPtEC2Up" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC2Up_branch and "jetVeto30_JetPileUpPtEC2Up":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC2Up")
        else:
            self.jetVeto30_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC2Up_value)

        #print "making jetVeto30_JetPileUpPtHFDown"
        self.jetVeto30_JetPileUpPtHFDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtHFDown")
        #if not self.jetVeto30_JetPileUpPtHFDown_branch and "jetVeto30_JetPileUpPtHFDown" not in self.complained:
        if not self.jetVeto30_JetPileUpPtHFDown_branch and "jetVeto30_JetPileUpPtHFDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtHFDown")
        else:
            self.jetVeto30_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtHFDown_value)

        #print "making jetVeto30_JetPileUpPtHFUp"
        self.jetVeto30_JetPileUpPtHFUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtHFUp")
        #if not self.jetVeto30_JetPileUpPtHFUp_branch and "jetVeto30_JetPileUpPtHFUp" not in self.complained:
        if not self.jetVeto30_JetPileUpPtHFUp_branch and "jetVeto30_JetPileUpPtHFUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtHFUp")
        else:
            self.jetVeto30_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtHFUp_value)

        #print "making jetVeto30_JetPileUpPtRefDown"
        self.jetVeto30_JetPileUpPtRefDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtRefDown")
        #if not self.jetVeto30_JetPileUpPtRefDown_branch and "jetVeto30_JetPileUpPtRefDown" not in self.complained:
        if not self.jetVeto30_JetPileUpPtRefDown_branch and "jetVeto30_JetPileUpPtRefDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtRefDown")
        else:
            self.jetVeto30_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtRefDown_value)

        #print "making jetVeto30_JetPileUpPtRefUp"
        self.jetVeto30_JetPileUpPtRefUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtRefUp")
        #if not self.jetVeto30_JetPileUpPtRefUp_branch and "jetVeto30_JetPileUpPtRefUp" not in self.complained:
        if not self.jetVeto30_JetPileUpPtRefUp_branch and "jetVeto30_JetPileUpPtRefUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtRefUp")
        else:
            self.jetVeto30_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtRefUp_value)

        #print "making jetVeto30_JetRelativeBalDown"
        self.jetVeto30_JetRelativeBalDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeBalDown")
        #if not self.jetVeto30_JetRelativeBalDown_branch and "jetVeto30_JetRelativeBalDown" not in self.complained:
        if not self.jetVeto30_JetRelativeBalDown_branch and "jetVeto30_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeBalDown")
        else:
            self.jetVeto30_JetRelativeBalDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeBalDown_value)

        #print "making jetVeto30_JetRelativeBalUp"
        self.jetVeto30_JetRelativeBalUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeBalUp")
        #if not self.jetVeto30_JetRelativeBalUp_branch and "jetVeto30_JetRelativeBalUp" not in self.complained:
        if not self.jetVeto30_JetRelativeBalUp_branch and "jetVeto30_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeBalUp")
        else:
            self.jetVeto30_JetRelativeBalUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeBalUp_value)

        #print "making jetVeto30_JetRelativeFSRDown"
        self.jetVeto30_JetRelativeFSRDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeFSRDown")
        #if not self.jetVeto30_JetRelativeFSRDown_branch and "jetVeto30_JetRelativeFSRDown" not in self.complained:
        if not self.jetVeto30_JetRelativeFSRDown_branch and "jetVeto30_JetRelativeFSRDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeFSRDown")
        else:
            self.jetVeto30_JetRelativeFSRDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeFSRDown_value)

        #print "making jetVeto30_JetRelativeFSRUp"
        self.jetVeto30_JetRelativeFSRUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeFSRUp")
        #if not self.jetVeto30_JetRelativeFSRUp_branch and "jetVeto30_JetRelativeFSRUp" not in self.complained:
        if not self.jetVeto30_JetRelativeFSRUp_branch and "jetVeto30_JetRelativeFSRUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeFSRUp")
        else:
            self.jetVeto30_JetRelativeFSRUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeFSRUp_value)

        #print "making jetVeto30_JetRelativeJEREC1Down"
        self.jetVeto30_JetRelativeJEREC1Down_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC1Down")
        #if not self.jetVeto30_JetRelativeJEREC1Down_branch and "jetVeto30_JetRelativeJEREC1Down" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC1Down_branch and "jetVeto30_JetRelativeJEREC1Down":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC1Down")
        else:
            self.jetVeto30_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC1Down_value)

        #print "making jetVeto30_JetRelativeJEREC1Up"
        self.jetVeto30_JetRelativeJEREC1Up_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC1Up")
        #if not self.jetVeto30_JetRelativeJEREC1Up_branch and "jetVeto30_JetRelativeJEREC1Up" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC1Up_branch and "jetVeto30_JetRelativeJEREC1Up":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC1Up")
        else:
            self.jetVeto30_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC1Up_value)

        #print "making jetVeto30_JetRelativeJEREC2Down"
        self.jetVeto30_JetRelativeJEREC2Down_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC2Down")
        #if not self.jetVeto30_JetRelativeJEREC2Down_branch and "jetVeto30_JetRelativeJEREC2Down" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC2Down_branch and "jetVeto30_JetRelativeJEREC2Down":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC2Down")
        else:
            self.jetVeto30_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC2Down_value)

        #print "making jetVeto30_JetRelativeJEREC2Up"
        self.jetVeto30_JetRelativeJEREC2Up_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC2Up")
        #if not self.jetVeto30_JetRelativeJEREC2Up_branch and "jetVeto30_JetRelativeJEREC2Up" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC2Up_branch and "jetVeto30_JetRelativeJEREC2Up":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC2Up")
        else:
            self.jetVeto30_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC2Up_value)

        #print "making jetVeto30_JetRelativeJERHFDown"
        self.jetVeto30_JetRelativeJERHFDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeJERHFDown")
        #if not self.jetVeto30_JetRelativeJERHFDown_branch and "jetVeto30_JetRelativeJERHFDown" not in self.complained:
        if not self.jetVeto30_JetRelativeJERHFDown_branch and "jetVeto30_JetRelativeJERHFDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJERHFDown")
        else:
            self.jetVeto30_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJERHFDown_value)

        #print "making jetVeto30_JetRelativeJERHFUp"
        self.jetVeto30_JetRelativeJERHFUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeJERHFUp")
        #if not self.jetVeto30_JetRelativeJERHFUp_branch and "jetVeto30_JetRelativeJERHFUp" not in self.complained:
        if not self.jetVeto30_JetRelativeJERHFUp_branch and "jetVeto30_JetRelativeJERHFUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJERHFUp")
        else:
            self.jetVeto30_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJERHFUp_value)

        #print "making jetVeto30_JetRelativePtBBDown"
        self.jetVeto30_JetRelativePtBBDown_branch = the_tree.GetBranch("jetVeto30_JetRelativePtBBDown")
        #if not self.jetVeto30_JetRelativePtBBDown_branch and "jetVeto30_JetRelativePtBBDown" not in self.complained:
        if not self.jetVeto30_JetRelativePtBBDown_branch and "jetVeto30_JetRelativePtBBDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtBBDown")
        else:
            self.jetVeto30_JetRelativePtBBDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtBBDown_value)

        #print "making jetVeto30_JetRelativePtBBUp"
        self.jetVeto30_JetRelativePtBBUp_branch = the_tree.GetBranch("jetVeto30_JetRelativePtBBUp")
        #if not self.jetVeto30_JetRelativePtBBUp_branch and "jetVeto30_JetRelativePtBBUp" not in self.complained:
        if not self.jetVeto30_JetRelativePtBBUp_branch and "jetVeto30_JetRelativePtBBUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtBBUp")
        else:
            self.jetVeto30_JetRelativePtBBUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtBBUp_value)

        #print "making jetVeto30_JetRelativePtEC1Down"
        self.jetVeto30_JetRelativePtEC1Down_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC1Down")
        #if not self.jetVeto30_JetRelativePtEC1Down_branch and "jetVeto30_JetRelativePtEC1Down" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC1Down_branch and "jetVeto30_JetRelativePtEC1Down":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC1Down")
        else:
            self.jetVeto30_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC1Down_value)

        #print "making jetVeto30_JetRelativePtEC1Up"
        self.jetVeto30_JetRelativePtEC1Up_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC1Up")
        #if not self.jetVeto30_JetRelativePtEC1Up_branch and "jetVeto30_JetRelativePtEC1Up" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC1Up_branch and "jetVeto30_JetRelativePtEC1Up":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC1Up")
        else:
            self.jetVeto30_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC1Up_value)

        #print "making jetVeto30_JetRelativePtEC2Down"
        self.jetVeto30_JetRelativePtEC2Down_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC2Down")
        #if not self.jetVeto30_JetRelativePtEC2Down_branch and "jetVeto30_JetRelativePtEC2Down" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC2Down_branch and "jetVeto30_JetRelativePtEC2Down":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC2Down")
        else:
            self.jetVeto30_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC2Down_value)

        #print "making jetVeto30_JetRelativePtEC2Up"
        self.jetVeto30_JetRelativePtEC2Up_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC2Up")
        #if not self.jetVeto30_JetRelativePtEC2Up_branch and "jetVeto30_JetRelativePtEC2Up" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC2Up_branch and "jetVeto30_JetRelativePtEC2Up":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC2Up")
        else:
            self.jetVeto30_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC2Up_value)

        #print "making jetVeto30_JetRelativePtHFDown"
        self.jetVeto30_JetRelativePtHFDown_branch = the_tree.GetBranch("jetVeto30_JetRelativePtHFDown")
        #if not self.jetVeto30_JetRelativePtHFDown_branch and "jetVeto30_JetRelativePtHFDown" not in self.complained:
        if not self.jetVeto30_JetRelativePtHFDown_branch and "jetVeto30_JetRelativePtHFDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtHFDown")
        else:
            self.jetVeto30_JetRelativePtHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtHFDown_value)

        #print "making jetVeto30_JetRelativePtHFUp"
        self.jetVeto30_JetRelativePtHFUp_branch = the_tree.GetBranch("jetVeto30_JetRelativePtHFUp")
        #if not self.jetVeto30_JetRelativePtHFUp_branch and "jetVeto30_JetRelativePtHFUp" not in self.complained:
        if not self.jetVeto30_JetRelativePtHFUp_branch and "jetVeto30_JetRelativePtHFUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtHFUp")
        else:
            self.jetVeto30_JetRelativePtHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtHFUp_value)

        #print "making jetVeto30_JetRelativeSampleDown"
        self.jetVeto30_JetRelativeSampleDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeSampleDown")
        #if not self.jetVeto30_JetRelativeSampleDown_branch and "jetVeto30_JetRelativeSampleDown" not in self.complained:
        if not self.jetVeto30_JetRelativeSampleDown_branch and "jetVeto30_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeSampleDown")
        else:
            self.jetVeto30_JetRelativeSampleDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeSampleDown_value)

        #print "making jetVeto30_JetRelativeSampleUp"
        self.jetVeto30_JetRelativeSampleUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeSampleUp")
        #if not self.jetVeto30_JetRelativeSampleUp_branch and "jetVeto30_JetRelativeSampleUp" not in self.complained:
        if not self.jetVeto30_JetRelativeSampleUp_branch and "jetVeto30_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeSampleUp")
        else:
            self.jetVeto30_JetRelativeSampleUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeSampleUp_value)

        #print "making jetVeto30_JetRelativeStatECDown"
        self.jetVeto30_JetRelativeStatECDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatECDown")
        #if not self.jetVeto30_JetRelativeStatECDown_branch and "jetVeto30_JetRelativeStatECDown" not in self.complained:
        if not self.jetVeto30_JetRelativeStatECDown_branch and "jetVeto30_JetRelativeStatECDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatECDown")
        else:
            self.jetVeto30_JetRelativeStatECDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatECDown_value)

        #print "making jetVeto30_JetRelativeStatECUp"
        self.jetVeto30_JetRelativeStatECUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatECUp")
        #if not self.jetVeto30_JetRelativeStatECUp_branch and "jetVeto30_JetRelativeStatECUp" not in self.complained:
        if not self.jetVeto30_JetRelativeStatECUp_branch and "jetVeto30_JetRelativeStatECUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatECUp")
        else:
            self.jetVeto30_JetRelativeStatECUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatECUp_value)

        #print "making jetVeto30_JetRelativeStatFSRDown"
        self.jetVeto30_JetRelativeStatFSRDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatFSRDown")
        #if not self.jetVeto30_JetRelativeStatFSRDown_branch and "jetVeto30_JetRelativeStatFSRDown" not in self.complained:
        if not self.jetVeto30_JetRelativeStatFSRDown_branch and "jetVeto30_JetRelativeStatFSRDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatFSRDown")
        else:
            self.jetVeto30_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatFSRDown_value)

        #print "making jetVeto30_JetRelativeStatFSRUp"
        self.jetVeto30_JetRelativeStatFSRUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatFSRUp")
        #if not self.jetVeto30_JetRelativeStatFSRUp_branch and "jetVeto30_JetRelativeStatFSRUp" not in self.complained:
        if not self.jetVeto30_JetRelativeStatFSRUp_branch and "jetVeto30_JetRelativeStatFSRUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatFSRUp")
        else:
            self.jetVeto30_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatFSRUp_value)

        #print "making jetVeto30_JetRelativeStatHFDown"
        self.jetVeto30_JetRelativeStatHFDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatHFDown")
        #if not self.jetVeto30_JetRelativeStatHFDown_branch and "jetVeto30_JetRelativeStatHFDown" not in self.complained:
        if not self.jetVeto30_JetRelativeStatHFDown_branch and "jetVeto30_JetRelativeStatHFDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatHFDown")
        else:
            self.jetVeto30_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatHFDown_value)

        #print "making jetVeto30_JetRelativeStatHFUp"
        self.jetVeto30_JetRelativeStatHFUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatHFUp")
        #if not self.jetVeto30_JetRelativeStatHFUp_branch and "jetVeto30_JetRelativeStatHFUp" not in self.complained:
        if not self.jetVeto30_JetRelativeStatHFUp_branch and "jetVeto30_JetRelativeStatHFUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatHFUp")
        else:
            self.jetVeto30_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatHFUp_value)

        #print "making jetVeto30_JetSinglePionECALDown"
        self.jetVeto30_JetSinglePionECALDown_branch = the_tree.GetBranch("jetVeto30_JetSinglePionECALDown")
        #if not self.jetVeto30_JetSinglePionECALDown_branch and "jetVeto30_JetSinglePionECALDown" not in self.complained:
        if not self.jetVeto30_JetSinglePionECALDown_branch and "jetVeto30_JetSinglePionECALDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionECALDown")
        else:
            self.jetVeto30_JetSinglePionECALDown_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionECALDown_value)

        #print "making jetVeto30_JetSinglePionECALUp"
        self.jetVeto30_JetSinglePionECALUp_branch = the_tree.GetBranch("jetVeto30_JetSinglePionECALUp")
        #if not self.jetVeto30_JetSinglePionECALUp_branch and "jetVeto30_JetSinglePionECALUp" not in self.complained:
        if not self.jetVeto30_JetSinglePionECALUp_branch and "jetVeto30_JetSinglePionECALUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionECALUp")
        else:
            self.jetVeto30_JetSinglePionECALUp_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionECALUp_value)

        #print "making jetVeto30_JetSinglePionHCALDown"
        self.jetVeto30_JetSinglePionHCALDown_branch = the_tree.GetBranch("jetVeto30_JetSinglePionHCALDown")
        #if not self.jetVeto30_JetSinglePionHCALDown_branch and "jetVeto30_JetSinglePionHCALDown" not in self.complained:
        if not self.jetVeto30_JetSinglePionHCALDown_branch and "jetVeto30_JetSinglePionHCALDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionHCALDown")
        else:
            self.jetVeto30_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionHCALDown_value)

        #print "making jetVeto30_JetSinglePionHCALUp"
        self.jetVeto30_JetSinglePionHCALUp_branch = the_tree.GetBranch("jetVeto30_JetSinglePionHCALUp")
        #if not self.jetVeto30_JetSinglePionHCALUp_branch and "jetVeto30_JetSinglePionHCALUp" not in self.complained:
        if not self.jetVeto30_JetSinglePionHCALUp_branch and "jetVeto30_JetSinglePionHCALUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionHCALUp")
        else:
            self.jetVeto30_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionHCALUp_value)

        #print "making jetVeto30_JetTimePtEtaDown"
        self.jetVeto30_JetTimePtEtaDown_branch = the_tree.GetBranch("jetVeto30_JetTimePtEtaDown")
        #if not self.jetVeto30_JetTimePtEtaDown_branch and "jetVeto30_JetTimePtEtaDown" not in self.complained:
        if not self.jetVeto30_JetTimePtEtaDown_branch and "jetVeto30_JetTimePtEtaDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTimePtEtaDown")
        else:
            self.jetVeto30_JetTimePtEtaDown_branch.SetAddress(<void*>&self.jetVeto30_JetTimePtEtaDown_value)

        #print "making jetVeto30_JetTimePtEtaUp"
        self.jetVeto30_JetTimePtEtaUp_branch = the_tree.GetBranch("jetVeto30_JetTimePtEtaUp")
        #if not self.jetVeto30_JetTimePtEtaUp_branch and "jetVeto30_JetTimePtEtaUp" not in self.complained:
        if not self.jetVeto30_JetTimePtEtaUp_branch and "jetVeto30_JetTimePtEtaUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTimePtEtaUp")
        else:
            self.jetVeto30_JetTimePtEtaUp_branch.SetAddress(<void*>&self.jetVeto30_JetTimePtEtaUp_value)

        #print "making jetVeto30_JetTotalDown"
        self.jetVeto30_JetTotalDown_branch = the_tree.GetBranch("jetVeto30_JetTotalDown")
        #if not self.jetVeto30_JetTotalDown_branch and "jetVeto30_JetTotalDown" not in self.complained:
        if not self.jetVeto30_JetTotalDown_branch and "jetVeto30_JetTotalDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTotalDown")
        else:
            self.jetVeto30_JetTotalDown_branch.SetAddress(<void*>&self.jetVeto30_JetTotalDown_value)

        #print "making jetVeto30_JetTotalUp"
        self.jetVeto30_JetTotalUp_branch = the_tree.GetBranch("jetVeto30_JetTotalUp")
        #if not self.jetVeto30_JetTotalUp_branch and "jetVeto30_JetTotalUp" not in self.complained:
        if not self.jetVeto30_JetTotalUp_branch and "jetVeto30_JetTotalUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTotalUp")
        else:
            self.jetVeto30_JetTotalUp_branch.SetAddress(<void*>&self.jetVeto30_JetTotalUp_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EMTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making mBestTrackType"
        self.mBestTrackType_branch = the_tree.GetBranch("mBestTrackType")
        #if not self.mBestTrackType_branch and "mBestTrackType" not in self.complained:
        if not self.mBestTrackType_branch and "mBestTrackType":
            warnings.warn( "EMTree: Expected branch mBestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mBestTrackType")
        else:
            self.mBestTrackType_branch.SetAddress(<void*>&self.mBestTrackType_value)

        #print "making mCharge"
        self.mCharge_branch = the_tree.GetBranch("mCharge")
        #if not self.mCharge_branch and "mCharge" not in self.complained:
        if not self.mCharge_branch and "mCharge":
            warnings.warn( "EMTree: Expected branch mCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mCharge")
        else:
            self.mCharge_branch.SetAddress(<void*>&self.mCharge_value)

        #print "making mChi2LocalPosition"
        self.mChi2LocalPosition_branch = the_tree.GetBranch("mChi2LocalPosition")
        #if not self.mChi2LocalPosition_branch and "mChi2LocalPosition" not in self.complained:
        if not self.mChi2LocalPosition_branch and "mChi2LocalPosition":
            warnings.warn( "EMTree: Expected branch mChi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mChi2LocalPosition")
        else:
            self.mChi2LocalPosition_branch.SetAddress(<void*>&self.mChi2LocalPosition_value)

        #print "making mComesFromHiggs"
        self.mComesFromHiggs_branch = the_tree.GetBranch("mComesFromHiggs")
        #if not self.mComesFromHiggs_branch and "mComesFromHiggs" not in self.complained:
        if not self.mComesFromHiggs_branch and "mComesFromHiggs":
            warnings.warn( "EMTree: Expected branch mComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mComesFromHiggs")
        else:
            self.mComesFromHiggs_branch.SetAddress(<void*>&self.mComesFromHiggs_value)

        #print "making mEcalIsoDR03"
        self.mEcalIsoDR03_branch = the_tree.GetBranch("mEcalIsoDR03")
        #if not self.mEcalIsoDR03_branch and "mEcalIsoDR03" not in self.complained:
        if not self.mEcalIsoDR03_branch and "mEcalIsoDR03":
            warnings.warn( "EMTree: Expected branch mEcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEcalIsoDR03")
        else:
            self.mEcalIsoDR03_branch.SetAddress(<void*>&self.mEcalIsoDR03_value)

        #print "making mEta"
        self.mEta_branch = the_tree.GetBranch("mEta")
        #if not self.mEta_branch and "mEta" not in self.complained:
        if not self.mEta_branch and "mEta":
            warnings.warn( "EMTree: Expected branch mEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEta")
        else:
            self.mEta_branch.SetAddress(<void*>&self.mEta_value)

        #print "making mGenCharge"
        self.mGenCharge_branch = the_tree.GetBranch("mGenCharge")
        #if not self.mGenCharge_branch and "mGenCharge" not in self.complained:
        if not self.mGenCharge_branch and "mGenCharge":
            warnings.warn( "EMTree: Expected branch mGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenCharge")
        else:
            self.mGenCharge_branch.SetAddress(<void*>&self.mGenCharge_value)

        #print "making mGenDirectPromptTauDecayFinalState"
        self.mGenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("mGenDirectPromptTauDecayFinalState")
        #if not self.mGenDirectPromptTauDecayFinalState_branch and "mGenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.mGenDirectPromptTauDecayFinalState_branch and "mGenDirectPromptTauDecayFinalState":
            warnings.warn( "EMTree: Expected branch mGenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenDirectPromptTauDecayFinalState")
        else:
            self.mGenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.mGenDirectPromptTauDecayFinalState_value)

        #print "making mGenEnergy"
        self.mGenEnergy_branch = the_tree.GetBranch("mGenEnergy")
        #if not self.mGenEnergy_branch and "mGenEnergy" not in self.complained:
        if not self.mGenEnergy_branch and "mGenEnergy":
            warnings.warn( "EMTree: Expected branch mGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenEnergy")
        else:
            self.mGenEnergy_branch.SetAddress(<void*>&self.mGenEnergy_value)

        #print "making mGenEta"
        self.mGenEta_branch = the_tree.GetBranch("mGenEta")
        #if not self.mGenEta_branch and "mGenEta" not in self.complained:
        if not self.mGenEta_branch and "mGenEta":
            warnings.warn( "EMTree: Expected branch mGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenEta")
        else:
            self.mGenEta_branch.SetAddress(<void*>&self.mGenEta_value)

        #print "making mGenIsPrompt"
        self.mGenIsPrompt_branch = the_tree.GetBranch("mGenIsPrompt")
        #if not self.mGenIsPrompt_branch and "mGenIsPrompt" not in self.complained:
        if not self.mGenIsPrompt_branch and "mGenIsPrompt":
            warnings.warn( "EMTree: Expected branch mGenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenIsPrompt")
        else:
            self.mGenIsPrompt_branch.SetAddress(<void*>&self.mGenIsPrompt_value)

        #print "making mGenMotherPdgId"
        self.mGenMotherPdgId_branch = the_tree.GetBranch("mGenMotherPdgId")
        #if not self.mGenMotherPdgId_branch and "mGenMotherPdgId" not in self.complained:
        if not self.mGenMotherPdgId_branch and "mGenMotherPdgId":
            warnings.warn( "EMTree: Expected branch mGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenMotherPdgId")
        else:
            self.mGenMotherPdgId_branch.SetAddress(<void*>&self.mGenMotherPdgId_value)

        #print "making mGenParticle"
        self.mGenParticle_branch = the_tree.GetBranch("mGenParticle")
        #if not self.mGenParticle_branch and "mGenParticle" not in self.complained:
        if not self.mGenParticle_branch and "mGenParticle":
            warnings.warn( "EMTree: Expected branch mGenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenParticle")
        else:
            self.mGenParticle_branch.SetAddress(<void*>&self.mGenParticle_value)

        #print "making mGenPdgId"
        self.mGenPdgId_branch = the_tree.GetBranch("mGenPdgId")
        #if not self.mGenPdgId_branch and "mGenPdgId" not in self.complained:
        if not self.mGenPdgId_branch and "mGenPdgId":
            warnings.warn( "EMTree: Expected branch mGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPdgId")
        else:
            self.mGenPdgId_branch.SetAddress(<void*>&self.mGenPdgId_value)

        #print "making mGenPhi"
        self.mGenPhi_branch = the_tree.GetBranch("mGenPhi")
        #if not self.mGenPhi_branch and "mGenPhi" not in self.complained:
        if not self.mGenPhi_branch and "mGenPhi":
            warnings.warn( "EMTree: Expected branch mGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPhi")
        else:
            self.mGenPhi_branch.SetAddress(<void*>&self.mGenPhi_value)

        #print "making mGenPrompt"
        self.mGenPrompt_branch = the_tree.GetBranch("mGenPrompt")
        #if not self.mGenPrompt_branch and "mGenPrompt" not in self.complained:
        if not self.mGenPrompt_branch and "mGenPrompt":
            warnings.warn( "EMTree: Expected branch mGenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPrompt")
        else:
            self.mGenPrompt_branch.SetAddress(<void*>&self.mGenPrompt_value)

        #print "making mGenPromptFinalState"
        self.mGenPromptFinalState_branch = the_tree.GetBranch("mGenPromptFinalState")
        #if not self.mGenPromptFinalState_branch and "mGenPromptFinalState" not in self.complained:
        if not self.mGenPromptFinalState_branch and "mGenPromptFinalState":
            warnings.warn( "EMTree: Expected branch mGenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPromptFinalState")
        else:
            self.mGenPromptFinalState_branch.SetAddress(<void*>&self.mGenPromptFinalState_value)

        #print "making mGenPromptTauDecay"
        self.mGenPromptTauDecay_branch = the_tree.GetBranch("mGenPromptTauDecay")
        #if not self.mGenPromptTauDecay_branch and "mGenPromptTauDecay" not in self.complained:
        if not self.mGenPromptTauDecay_branch and "mGenPromptTauDecay":
            warnings.warn( "EMTree: Expected branch mGenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPromptTauDecay")
        else:
            self.mGenPromptTauDecay_branch.SetAddress(<void*>&self.mGenPromptTauDecay_value)

        #print "making mGenPt"
        self.mGenPt_branch = the_tree.GetBranch("mGenPt")
        #if not self.mGenPt_branch and "mGenPt" not in self.complained:
        if not self.mGenPt_branch and "mGenPt":
            warnings.warn( "EMTree: Expected branch mGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPt")
        else:
            self.mGenPt_branch.SetAddress(<void*>&self.mGenPt_value)

        #print "making mGenTauDecay"
        self.mGenTauDecay_branch = the_tree.GetBranch("mGenTauDecay")
        #if not self.mGenTauDecay_branch and "mGenTauDecay" not in self.complained:
        if not self.mGenTauDecay_branch and "mGenTauDecay":
            warnings.warn( "EMTree: Expected branch mGenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenTauDecay")
        else:
            self.mGenTauDecay_branch.SetAddress(<void*>&self.mGenTauDecay_value)

        #print "making mGenVZ"
        self.mGenVZ_branch = the_tree.GetBranch("mGenVZ")
        #if not self.mGenVZ_branch and "mGenVZ" not in self.complained:
        if not self.mGenVZ_branch and "mGenVZ":
            warnings.warn( "EMTree: Expected branch mGenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenVZ")
        else:
            self.mGenVZ_branch.SetAddress(<void*>&self.mGenVZ_value)

        #print "making mGenVtxPVMatch"
        self.mGenVtxPVMatch_branch = the_tree.GetBranch("mGenVtxPVMatch")
        #if not self.mGenVtxPVMatch_branch and "mGenVtxPVMatch" not in self.complained:
        if not self.mGenVtxPVMatch_branch and "mGenVtxPVMatch":
            warnings.warn( "EMTree: Expected branch mGenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenVtxPVMatch")
        else:
            self.mGenVtxPVMatch_branch.SetAddress(<void*>&self.mGenVtxPVMatch_value)

        #print "making mHcalIsoDR03"
        self.mHcalIsoDR03_branch = the_tree.GetBranch("mHcalIsoDR03")
        #if not self.mHcalIsoDR03_branch and "mHcalIsoDR03" not in self.complained:
        if not self.mHcalIsoDR03_branch and "mHcalIsoDR03":
            warnings.warn( "EMTree: Expected branch mHcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mHcalIsoDR03")
        else:
            self.mHcalIsoDR03_branch.SetAddress(<void*>&self.mHcalIsoDR03_value)

        #print "making mIP3D"
        self.mIP3D_branch = the_tree.GetBranch("mIP3D")
        #if not self.mIP3D_branch and "mIP3D" not in self.complained:
        if not self.mIP3D_branch and "mIP3D":
            warnings.warn( "EMTree: Expected branch mIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIP3D")
        else:
            self.mIP3D_branch.SetAddress(<void*>&self.mIP3D_value)

        #print "making mIP3DErr"
        self.mIP3DErr_branch = the_tree.GetBranch("mIP3DErr")
        #if not self.mIP3DErr_branch and "mIP3DErr" not in self.complained:
        if not self.mIP3DErr_branch and "mIP3DErr":
            warnings.warn( "EMTree: Expected branch mIP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIP3DErr")
        else:
            self.mIP3DErr_branch.SetAddress(<void*>&self.mIP3DErr_value)

        #print "making mIsGlobal"
        self.mIsGlobal_branch = the_tree.GetBranch("mIsGlobal")
        #if not self.mIsGlobal_branch and "mIsGlobal" not in self.complained:
        if not self.mIsGlobal_branch and "mIsGlobal":
            warnings.warn( "EMTree: Expected branch mIsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsGlobal")
        else:
            self.mIsGlobal_branch.SetAddress(<void*>&self.mIsGlobal_value)

        #print "making mIsPFMuon"
        self.mIsPFMuon_branch = the_tree.GetBranch("mIsPFMuon")
        #if not self.mIsPFMuon_branch and "mIsPFMuon" not in self.complained:
        if not self.mIsPFMuon_branch and "mIsPFMuon":
            warnings.warn( "EMTree: Expected branch mIsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsPFMuon")
        else:
            self.mIsPFMuon_branch.SetAddress(<void*>&self.mIsPFMuon_value)

        #print "making mIsTracker"
        self.mIsTracker_branch = the_tree.GetBranch("mIsTracker")
        #if not self.mIsTracker_branch and "mIsTracker" not in self.complained:
        if not self.mIsTracker_branch and "mIsTracker":
            warnings.warn( "EMTree: Expected branch mIsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsTracker")
        else:
            self.mIsTracker_branch.SetAddress(<void*>&self.mIsTracker_value)

        #print "making mIsoDB03"
        self.mIsoDB03_branch = the_tree.GetBranch("mIsoDB03")
        #if not self.mIsoDB03_branch and "mIsoDB03" not in self.complained:
        if not self.mIsoDB03_branch and "mIsoDB03":
            warnings.warn( "EMTree: Expected branch mIsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoDB03")
        else:
            self.mIsoDB03_branch.SetAddress(<void*>&self.mIsoDB03_value)

        #print "making mIsoDB04"
        self.mIsoDB04_branch = the_tree.GetBranch("mIsoDB04")
        #if not self.mIsoDB04_branch and "mIsoDB04" not in self.complained:
        if not self.mIsoDB04_branch and "mIsoDB04":
            warnings.warn( "EMTree: Expected branch mIsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoDB04")
        else:
            self.mIsoDB04_branch.SetAddress(<void*>&self.mIsoDB04_value)

        #print "making mJetArea"
        self.mJetArea_branch = the_tree.GetBranch("mJetArea")
        #if not self.mJetArea_branch and "mJetArea" not in self.complained:
        if not self.mJetArea_branch and "mJetArea":
            warnings.warn( "EMTree: Expected branch mJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetArea")
        else:
            self.mJetArea_branch.SetAddress(<void*>&self.mJetArea_value)

        #print "making mJetBtag"
        self.mJetBtag_branch = the_tree.GetBranch("mJetBtag")
        #if not self.mJetBtag_branch and "mJetBtag" not in self.complained:
        if not self.mJetBtag_branch and "mJetBtag":
            warnings.warn( "EMTree: Expected branch mJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetBtag")
        else:
            self.mJetBtag_branch.SetAddress(<void*>&self.mJetBtag_value)

        #print "making mJetDR"
        self.mJetDR_branch = the_tree.GetBranch("mJetDR")
        #if not self.mJetDR_branch and "mJetDR" not in self.complained:
        if not self.mJetDR_branch and "mJetDR":
            warnings.warn( "EMTree: Expected branch mJetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetDR")
        else:
            self.mJetDR_branch.SetAddress(<void*>&self.mJetDR_value)

        #print "making mJetEtaEtaMoment"
        self.mJetEtaEtaMoment_branch = the_tree.GetBranch("mJetEtaEtaMoment")
        #if not self.mJetEtaEtaMoment_branch and "mJetEtaEtaMoment" not in self.complained:
        if not self.mJetEtaEtaMoment_branch and "mJetEtaEtaMoment":
            warnings.warn( "EMTree: Expected branch mJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetEtaEtaMoment")
        else:
            self.mJetEtaEtaMoment_branch.SetAddress(<void*>&self.mJetEtaEtaMoment_value)

        #print "making mJetEtaPhiMoment"
        self.mJetEtaPhiMoment_branch = the_tree.GetBranch("mJetEtaPhiMoment")
        #if not self.mJetEtaPhiMoment_branch and "mJetEtaPhiMoment" not in self.complained:
        if not self.mJetEtaPhiMoment_branch and "mJetEtaPhiMoment":
            warnings.warn( "EMTree: Expected branch mJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetEtaPhiMoment")
        else:
            self.mJetEtaPhiMoment_branch.SetAddress(<void*>&self.mJetEtaPhiMoment_value)

        #print "making mJetEtaPhiSpread"
        self.mJetEtaPhiSpread_branch = the_tree.GetBranch("mJetEtaPhiSpread")
        #if not self.mJetEtaPhiSpread_branch and "mJetEtaPhiSpread" not in self.complained:
        if not self.mJetEtaPhiSpread_branch and "mJetEtaPhiSpread":
            warnings.warn( "EMTree: Expected branch mJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetEtaPhiSpread")
        else:
            self.mJetEtaPhiSpread_branch.SetAddress(<void*>&self.mJetEtaPhiSpread_value)

        #print "making mJetHadronFlavour"
        self.mJetHadronFlavour_branch = the_tree.GetBranch("mJetHadronFlavour")
        #if not self.mJetHadronFlavour_branch and "mJetHadronFlavour" not in self.complained:
        if not self.mJetHadronFlavour_branch and "mJetHadronFlavour":
            warnings.warn( "EMTree: Expected branch mJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetHadronFlavour")
        else:
            self.mJetHadronFlavour_branch.SetAddress(<void*>&self.mJetHadronFlavour_value)

        #print "making mJetPFCISVBtag"
        self.mJetPFCISVBtag_branch = the_tree.GetBranch("mJetPFCISVBtag")
        #if not self.mJetPFCISVBtag_branch and "mJetPFCISVBtag" not in self.complained:
        if not self.mJetPFCISVBtag_branch and "mJetPFCISVBtag":
            warnings.warn( "EMTree: Expected branch mJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetPFCISVBtag")
        else:
            self.mJetPFCISVBtag_branch.SetAddress(<void*>&self.mJetPFCISVBtag_value)

        #print "making mJetPartonFlavour"
        self.mJetPartonFlavour_branch = the_tree.GetBranch("mJetPartonFlavour")
        #if not self.mJetPartonFlavour_branch and "mJetPartonFlavour" not in self.complained:
        if not self.mJetPartonFlavour_branch and "mJetPartonFlavour":
            warnings.warn( "EMTree: Expected branch mJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetPartonFlavour")
        else:
            self.mJetPartonFlavour_branch.SetAddress(<void*>&self.mJetPartonFlavour_value)

        #print "making mJetPhiPhiMoment"
        self.mJetPhiPhiMoment_branch = the_tree.GetBranch("mJetPhiPhiMoment")
        #if not self.mJetPhiPhiMoment_branch and "mJetPhiPhiMoment" not in self.complained:
        if not self.mJetPhiPhiMoment_branch and "mJetPhiPhiMoment":
            warnings.warn( "EMTree: Expected branch mJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetPhiPhiMoment")
        else:
            self.mJetPhiPhiMoment_branch.SetAddress(<void*>&self.mJetPhiPhiMoment_value)

        #print "making mJetPt"
        self.mJetPt_branch = the_tree.GetBranch("mJetPt")
        #if not self.mJetPt_branch and "mJetPt" not in self.complained:
        if not self.mJetPt_branch and "mJetPt":
            warnings.warn( "EMTree: Expected branch mJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetPt")
        else:
            self.mJetPt_branch.SetAddress(<void*>&self.mJetPt_value)

        #print "making mLowestMll"
        self.mLowestMll_branch = the_tree.GetBranch("mLowestMll")
        #if not self.mLowestMll_branch and "mLowestMll" not in self.complained:
        if not self.mLowestMll_branch and "mLowestMll":
            warnings.warn( "EMTree: Expected branch mLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mLowestMll")
        else:
            self.mLowestMll_branch.SetAddress(<void*>&self.mLowestMll_value)

        #print "making mMass"
        self.mMass_branch = the_tree.GetBranch("mMass")
        #if not self.mMass_branch and "mMass" not in self.complained:
        if not self.mMass_branch and "mMass":
            warnings.warn( "EMTree: Expected branch mMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMass")
        else:
            self.mMass_branch.SetAddress(<void*>&self.mMass_value)

        #print "making mMatchEmbeddedFilterMu19Tau20_2016"
        self.mMatchEmbeddedFilterMu19Tau20_2016_branch = the_tree.GetBranch("mMatchEmbeddedFilterMu19Tau20_2016")
        #if not self.mMatchEmbeddedFilterMu19Tau20_2016_branch and "mMatchEmbeddedFilterMu19Tau20_2016" not in self.complained:
        if not self.mMatchEmbeddedFilterMu19Tau20_2016_branch and "mMatchEmbeddedFilterMu19Tau20_2016":
            warnings.warn( "EMTree: Expected branch mMatchEmbeddedFilterMu19Tau20_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchEmbeddedFilterMu19Tau20_2016")
        else:
            self.mMatchEmbeddedFilterMu19Tau20_2016_branch.SetAddress(<void*>&self.mMatchEmbeddedFilterMu19Tau20_2016_value)

        #print "making mMatchEmbeddedFilterMu20Tau27_2017"
        self.mMatchEmbeddedFilterMu20Tau27_2017_branch = the_tree.GetBranch("mMatchEmbeddedFilterMu20Tau27_2017")
        #if not self.mMatchEmbeddedFilterMu20Tau27_2017_branch and "mMatchEmbeddedFilterMu20Tau27_2017" not in self.complained:
        if not self.mMatchEmbeddedFilterMu20Tau27_2017_branch and "mMatchEmbeddedFilterMu20Tau27_2017":
            warnings.warn( "EMTree: Expected branch mMatchEmbeddedFilterMu20Tau27_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchEmbeddedFilterMu20Tau27_2017")
        else:
            self.mMatchEmbeddedFilterMu20Tau27_2017_branch.SetAddress(<void*>&self.mMatchEmbeddedFilterMu20Tau27_2017_value)

        #print "making mMatchEmbeddedFilterMu20Tau27_2018"
        self.mMatchEmbeddedFilterMu20Tau27_2018_branch = the_tree.GetBranch("mMatchEmbeddedFilterMu20Tau27_2018")
        #if not self.mMatchEmbeddedFilterMu20Tau27_2018_branch and "mMatchEmbeddedFilterMu20Tau27_2018" not in self.complained:
        if not self.mMatchEmbeddedFilterMu20Tau27_2018_branch and "mMatchEmbeddedFilterMu20Tau27_2018":
            warnings.warn( "EMTree: Expected branch mMatchEmbeddedFilterMu20Tau27_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchEmbeddedFilterMu20Tau27_2018")
        else:
            self.mMatchEmbeddedFilterMu20Tau27_2018_branch.SetAddress(<void*>&self.mMatchEmbeddedFilterMu20Tau27_2018_value)

        #print "making mMatchEmbeddedFilterMu24"
        self.mMatchEmbeddedFilterMu24_branch = the_tree.GetBranch("mMatchEmbeddedFilterMu24")
        #if not self.mMatchEmbeddedFilterMu24_branch and "mMatchEmbeddedFilterMu24" not in self.complained:
        if not self.mMatchEmbeddedFilterMu24_branch and "mMatchEmbeddedFilterMu24":
            warnings.warn( "EMTree: Expected branch mMatchEmbeddedFilterMu24 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchEmbeddedFilterMu24")
        else:
            self.mMatchEmbeddedFilterMu24_branch.SetAddress(<void*>&self.mMatchEmbeddedFilterMu24_value)

        #print "making mMatchEmbeddedFilterMu27"
        self.mMatchEmbeddedFilterMu27_branch = the_tree.GetBranch("mMatchEmbeddedFilterMu27")
        #if not self.mMatchEmbeddedFilterMu27_branch and "mMatchEmbeddedFilterMu27" not in self.complained:
        if not self.mMatchEmbeddedFilterMu27_branch and "mMatchEmbeddedFilterMu27":
            warnings.warn( "EMTree: Expected branch mMatchEmbeddedFilterMu27 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchEmbeddedFilterMu27")
        else:
            self.mMatchEmbeddedFilterMu27_branch.SetAddress(<void*>&self.mMatchEmbeddedFilterMu27_value)

        #print "making mMatchedStations"
        self.mMatchedStations_branch = the_tree.GetBranch("mMatchedStations")
        #if not self.mMatchedStations_branch and "mMatchedStations" not in self.complained:
        if not self.mMatchedStations_branch and "mMatchedStations":
            warnings.warn( "EMTree: Expected branch mMatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchedStations")
        else:
            self.mMatchedStations_branch.SetAddress(<void*>&self.mMatchedStations_value)

        #print "making mMatchesIsoMu19Tau20Filter"
        self.mMatchesIsoMu19Tau20Filter_branch = the_tree.GetBranch("mMatchesIsoMu19Tau20Filter")
        #if not self.mMatchesIsoMu19Tau20Filter_branch and "mMatchesIsoMu19Tau20Filter" not in self.complained:
        if not self.mMatchesIsoMu19Tau20Filter_branch and "mMatchesIsoMu19Tau20Filter":
            warnings.warn( "EMTree: Expected branch mMatchesIsoMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu19Tau20Filter")
        else:
            self.mMatchesIsoMu19Tau20Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu19Tau20Filter_value)

        #print "making mMatchesIsoMu19Tau20Path"
        self.mMatchesIsoMu19Tau20Path_branch = the_tree.GetBranch("mMatchesIsoMu19Tau20Path")
        #if not self.mMatchesIsoMu19Tau20Path_branch and "mMatchesIsoMu19Tau20Path" not in self.complained:
        if not self.mMatchesIsoMu19Tau20Path_branch and "mMatchesIsoMu19Tau20Path":
            warnings.warn( "EMTree: Expected branch mMatchesIsoMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu19Tau20Path")
        else:
            self.mMatchesIsoMu19Tau20Path_branch.SetAddress(<void*>&self.mMatchesIsoMu19Tau20Path_value)

        #print "making mMatchesIsoMu19Tau20SingleL1Filter"
        self.mMatchesIsoMu19Tau20SingleL1Filter_branch = the_tree.GetBranch("mMatchesIsoMu19Tau20SingleL1Filter")
        #if not self.mMatchesIsoMu19Tau20SingleL1Filter_branch and "mMatchesIsoMu19Tau20SingleL1Filter" not in self.complained:
        if not self.mMatchesIsoMu19Tau20SingleL1Filter_branch and "mMatchesIsoMu19Tau20SingleL1Filter":
            warnings.warn( "EMTree: Expected branch mMatchesIsoMu19Tau20SingleL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu19Tau20SingleL1Filter")
        else:
            self.mMatchesIsoMu19Tau20SingleL1Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu19Tau20SingleL1Filter_value)

        #print "making mMatchesIsoMu19Tau20SingleL1Path"
        self.mMatchesIsoMu19Tau20SingleL1Path_branch = the_tree.GetBranch("mMatchesIsoMu19Tau20SingleL1Path")
        #if not self.mMatchesIsoMu19Tau20SingleL1Path_branch and "mMatchesIsoMu19Tau20SingleL1Path" not in self.complained:
        if not self.mMatchesIsoMu19Tau20SingleL1Path_branch and "mMatchesIsoMu19Tau20SingleL1Path":
            warnings.warn( "EMTree: Expected branch mMatchesIsoMu19Tau20SingleL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu19Tau20SingleL1Path")
        else:
            self.mMatchesIsoMu19Tau20SingleL1Path_branch.SetAddress(<void*>&self.mMatchesIsoMu19Tau20SingleL1Path_value)

        #print "making mMatchesIsoMu20HPSTau27Filter"
        self.mMatchesIsoMu20HPSTau27Filter_branch = the_tree.GetBranch("mMatchesIsoMu20HPSTau27Filter")
        #if not self.mMatchesIsoMu20HPSTau27Filter_branch and "mMatchesIsoMu20HPSTau27Filter" not in self.complained:
        if not self.mMatchesIsoMu20HPSTau27Filter_branch and "mMatchesIsoMu20HPSTau27Filter":
            warnings.warn( "EMTree: Expected branch mMatchesIsoMu20HPSTau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu20HPSTau27Filter")
        else:
            self.mMatchesIsoMu20HPSTau27Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu20HPSTau27Filter_value)

        #print "making mMatchesIsoMu20HPSTau27Path"
        self.mMatchesIsoMu20HPSTau27Path_branch = the_tree.GetBranch("mMatchesIsoMu20HPSTau27Path")
        #if not self.mMatchesIsoMu20HPSTau27Path_branch and "mMatchesIsoMu20HPSTau27Path" not in self.complained:
        if not self.mMatchesIsoMu20HPSTau27Path_branch and "mMatchesIsoMu20HPSTau27Path":
            warnings.warn( "EMTree: Expected branch mMatchesIsoMu20HPSTau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu20HPSTau27Path")
        else:
            self.mMatchesIsoMu20HPSTau27Path_branch.SetAddress(<void*>&self.mMatchesIsoMu20HPSTau27Path_value)

        #print "making mMatchesIsoMu20Tau27Filter"
        self.mMatchesIsoMu20Tau27Filter_branch = the_tree.GetBranch("mMatchesIsoMu20Tau27Filter")
        #if not self.mMatchesIsoMu20Tau27Filter_branch and "mMatchesIsoMu20Tau27Filter" not in self.complained:
        if not self.mMatchesIsoMu20Tau27Filter_branch and "mMatchesIsoMu20Tau27Filter":
            warnings.warn( "EMTree: Expected branch mMatchesIsoMu20Tau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu20Tau27Filter")
        else:
            self.mMatchesIsoMu20Tau27Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu20Tau27Filter_value)

        #print "making mMatchesIsoMu20Tau27Path"
        self.mMatchesIsoMu20Tau27Path_branch = the_tree.GetBranch("mMatchesIsoMu20Tau27Path")
        #if not self.mMatchesIsoMu20Tau27Path_branch and "mMatchesIsoMu20Tau27Path" not in self.complained:
        if not self.mMatchesIsoMu20Tau27Path_branch and "mMatchesIsoMu20Tau27Path":
            warnings.warn( "EMTree: Expected branch mMatchesIsoMu20Tau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu20Tau27Path")
        else:
            self.mMatchesIsoMu20Tau27Path_branch.SetAddress(<void*>&self.mMatchesIsoMu20Tau27Path_value)

        #print "making mMatchesIsoMu24Filter"
        self.mMatchesIsoMu24Filter_branch = the_tree.GetBranch("mMatchesIsoMu24Filter")
        #if not self.mMatchesIsoMu24Filter_branch and "mMatchesIsoMu24Filter" not in self.complained:
        if not self.mMatchesIsoMu24Filter_branch and "mMatchesIsoMu24Filter":
            warnings.warn( "EMTree: Expected branch mMatchesIsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu24Filter")
        else:
            self.mMatchesIsoMu24Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu24Filter_value)

        #print "making mMatchesIsoMu24Path"
        self.mMatchesIsoMu24Path_branch = the_tree.GetBranch("mMatchesIsoMu24Path")
        #if not self.mMatchesIsoMu24Path_branch and "mMatchesIsoMu24Path" not in self.complained:
        if not self.mMatchesIsoMu24Path_branch and "mMatchesIsoMu24Path":
            warnings.warn( "EMTree: Expected branch mMatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu24Path")
        else:
            self.mMatchesIsoMu24Path_branch.SetAddress(<void*>&self.mMatchesIsoMu24Path_value)

        #print "making mMatchesIsoMu27Filter"
        self.mMatchesIsoMu27Filter_branch = the_tree.GetBranch("mMatchesIsoMu27Filter")
        #if not self.mMatchesIsoMu27Filter_branch and "mMatchesIsoMu27Filter" not in self.complained:
        if not self.mMatchesIsoMu27Filter_branch and "mMatchesIsoMu27Filter":
            warnings.warn( "EMTree: Expected branch mMatchesIsoMu27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu27Filter")
        else:
            self.mMatchesIsoMu27Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu27Filter_value)

        #print "making mMatchesIsoMu27Path"
        self.mMatchesIsoMu27Path_branch = the_tree.GetBranch("mMatchesIsoMu27Path")
        #if not self.mMatchesIsoMu27Path_branch and "mMatchesIsoMu27Path" not in self.complained:
        if not self.mMatchesIsoMu27Path_branch and "mMatchesIsoMu27Path":
            warnings.warn( "EMTree: Expected branch mMatchesIsoMu27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu27Path")
        else:
            self.mMatchesIsoMu27Path_branch.SetAddress(<void*>&self.mMatchesIsoMu27Path_value)

        #print "making mMatchesMu23e12DZFilter"
        self.mMatchesMu23e12DZFilter_branch = the_tree.GetBranch("mMatchesMu23e12DZFilter")
        #if not self.mMatchesMu23e12DZFilter_branch and "mMatchesMu23e12DZFilter" not in self.complained:
        if not self.mMatchesMu23e12DZFilter_branch and "mMatchesMu23e12DZFilter":
            warnings.warn( "EMTree: Expected branch mMatchesMu23e12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu23e12DZFilter")
        else:
            self.mMatchesMu23e12DZFilter_branch.SetAddress(<void*>&self.mMatchesMu23e12DZFilter_value)

        #print "making mMatchesMu23e12DZPath"
        self.mMatchesMu23e12DZPath_branch = the_tree.GetBranch("mMatchesMu23e12DZPath")
        #if not self.mMatchesMu23e12DZPath_branch and "mMatchesMu23e12DZPath" not in self.complained:
        if not self.mMatchesMu23e12DZPath_branch and "mMatchesMu23e12DZPath":
            warnings.warn( "EMTree: Expected branch mMatchesMu23e12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu23e12DZPath")
        else:
            self.mMatchesMu23e12DZPath_branch.SetAddress(<void*>&self.mMatchesMu23e12DZPath_value)

        #print "making mMatchesMu23e12Filter"
        self.mMatchesMu23e12Filter_branch = the_tree.GetBranch("mMatchesMu23e12Filter")
        #if not self.mMatchesMu23e12Filter_branch and "mMatchesMu23e12Filter" not in self.complained:
        if not self.mMatchesMu23e12Filter_branch and "mMatchesMu23e12Filter":
            warnings.warn( "EMTree: Expected branch mMatchesMu23e12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu23e12Filter")
        else:
            self.mMatchesMu23e12Filter_branch.SetAddress(<void*>&self.mMatchesMu23e12Filter_value)

        #print "making mMatchesMu23e12Path"
        self.mMatchesMu23e12Path_branch = the_tree.GetBranch("mMatchesMu23e12Path")
        #if not self.mMatchesMu23e12Path_branch and "mMatchesMu23e12Path" not in self.complained:
        if not self.mMatchesMu23e12Path_branch and "mMatchesMu23e12Path":
            warnings.warn( "EMTree: Expected branch mMatchesMu23e12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu23e12Path")
        else:
            self.mMatchesMu23e12Path_branch.SetAddress(<void*>&self.mMatchesMu23e12Path_value)

        #print "making mMatchesMu8e23DZFilter"
        self.mMatchesMu8e23DZFilter_branch = the_tree.GetBranch("mMatchesMu8e23DZFilter")
        #if not self.mMatchesMu8e23DZFilter_branch and "mMatchesMu8e23DZFilter" not in self.complained:
        if not self.mMatchesMu8e23DZFilter_branch and "mMatchesMu8e23DZFilter":
            warnings.warn( "EMTree: Expected branch mMatchesMu8e23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu8e23DZFilter")
        else:
            self.mMatchesMu8e23DZFilter_branch.SetAddress(<void*>&self.mMatchesMu8e23DZFilter_value)

        #print "making mMatchesMu8e23DZPath"
        self.mMatchesMu8e23DZPath_branch = the_tree.GetBranch("mMatchesMu8e23DZPath")
        #if not self.mMatchesMu8e23DZPath_branch and "mMatchesMu8e23DZPath" not in self.complained:
        if not self.mMatchesMu8e23DZPath_branch and "mMatchesMu8e23DZPath":
            warnings.warn( "EMTree: Expected branch mMatchesMu8e23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu8e23DZPath")
        else:
            self.mMatchesMu8e23DZPath_branch.SetAddress(<void*>&self.mMatchesMu8e23DZPath_value)

        #print "making mMatchesMu8e23Filter"
        self.mMatchesMu8e23Filter_branch = the_tree.GetBranch("mMatchesMu8e23Filter")
        #if not self.mMatchesMu8e23Filter_branch and "mMatchesMu8e23Filter" not in self.complained:
        if not self.mMatchesMu8e23Filter_branch and "mMatchesMu8e23Filter":
            warnings.warn( "EMTree: Expected branch mMatchesMu8e23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu8e23Filter")
        else:
            self.mMatchesMu8e23Filter_branch.SetAddress(<void*>&self.mMatchesMu8e23Filter_value)

        #print "making mMatchesMu8e23Path"
        self.mMatchesMu8e23Path_branch = the_tree.GetBranch("mMatchesMu8e23Path")
        #if not self.mMatchesMu8e23Path_branch and "mMatchesMu8e23Path" not in self.complained:
        if not self.mMatchesMu8e23Path_branch and "mMatchesMu8e23Path":
            warnings.warn( "EMTree: Expected branch mMatchesMu8e23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu8e23Path")
        else:
            self.mMatchesMu8e23Path_branch.SetAddress(<void*>&self.mMatchesMu8e23Path_value)

        #print "making mMiniIsoLoose"
        self.mMiniIsoLoose_branch = the_tree.GetBranch("mMiniIsoLoose")
        #if not self.mMiniIsoLoose_branch and "mMiniIsoLoose" not in self.complained:
        if not self.mMiniIsoLoose_branch and "mMiniIsoLoose":
            warnings.warn( "EMTree: Expected branch mMiniIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMiniIsoLoose")
        else:
            self.mMiniIsoLoose_branch.SetAddress(<void*>&self.mMiniIsoLoose_value)

        #print "making mMiniIsoMedium"
        self.mMiniIsoMedium_branch = the_tree.GetBranch("mMiniIsoMedium")
        #if not self.mMiniIsoMedium_branch and "mMiniIsoMedium" not in self.complained:
        if not self.mMiniIsoMedium_branch and "mMiniIsoMedium":
            warnings.warn( "EMTree: Expected branch mMiniIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMiniIsoMedium")
        else:
            self.mMiniIsoMedium_branch.SetAddress(<void*>&self.mMiniIsoMedium_value)

        #print "making mMiniIsoTight"
        self.mMiniIsoTight_branch = the_tree.GetBranch("mMiniIsoTight")
        #if not self.mMiniIsoTight_branch and "mMiniIsoTight" not in self.complained:
        if not self.mMiniIsoTight_branch and "mMiniIsoTight":
            warnings.warn( "EMTree: Expected branch mMiniIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMiniIsoTight")
        else:
            self.mMiniIsoTight_branch.SetAddress(<void*>&self.mMiniIsoTight_value)

        #print "making mMiniIsoVeryTight"
        self.mMiniIsoVeryTight_branch = the_tree.GetBranch("mMiniIsoVeryTight")
        #if not self.mMiniIsoVeryTight_branch and "mMiniIsoVeryTight" not in self.complained:
        if not self.mMiniIsoVeryTight_branch and "mMiniIsoVeryTight":
            warnings.warn( "EMTree: Expected branch mMiniIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMiniIsoVeryTight")
        else:
            self.mMiniIsoVeryTight_branch.SetAddress(<void*>&self.mMiniIsoVeryTight_value)

        #print "making mMuonHits"
        self.mMuonHits_branch = the_tree.GetBranch("mMuonHits")
        #if not self.mMuonHits_branch and "mMuonHits" not in self.complained:
        if not self.mMuonHits_branch and "mMuonHits":
            warnings.warn( "EMTree: Expected branch mMuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMuonHits")
        else:
            self.mMuonHits_branch.SetAddress(<void*>&self.mMuonHits_value)

        #print "making mMvaLoose"
        self.mMvaLoose_branch = the_tree.GetBranch("mMvaLoose")
        #if not self.mMvaLoose_branch and "mMvaLoose" not in self.complained:
        if not self.mMvaLoose_branch and "mMvaLoose":
            warnings.warn( "EMTree: Expected branch mMvaLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMvaLoose")
        else:
            self.mMvaLoose_branch.SetAddress(<void*>&self.mMvaLoose_value)

        #print "making mMvaMedium"
        self.mMvaMedium_branch = the_tree.GetBranch("mMvaMedium")
        #if not self.mMvaMedium_branch and "mMvaMedium" not in self.complained:
        if not self.mMvaMedium_branch and "mMvaMedium":
            warnings.warn( "EMTree: Expected branch mMvaMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMvaMedium")
        else:
            self.mMvaMedium_branch.SetAddress(<void*>&self.mMvaMedium_value)

        #print "making mMvaTight"
        self.mMvaTight_branch = the_tree.GetBranch("mMvaTight")
        #if not self.mMvaTight_branch and "mMvaTight" not in self.complained:
        if not self.mMvaTight_branch and "mMvaTight":
            warnings.warn( "EMTree: Expected branch mMvaTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMvaTight")
        else:
            self.mMvaTight_branch.SetAddress(<void*>&self.mMvaTight_value)

        #print "making mNearestZMass"
        self.mNearestZMass_branch = the_tree.GetBranch("mNearestZMass")
        #if not self.mNearestZMass_branch and "mNearestZMass" not in self.complained:
        if not self.mNearestZMass_branch and "mNearestZMass":
            warnings.warn( "EMTree: Expected branch mNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mNearestZMass")
        else:
            self.mNearestZMass_branch.SetAddress(<void*>&self.mNearestZMass_value)

        #print "making mNormTrkChi2"
        self.mNormTrkChi2_branch = the_tree.GetBranch("mNormTrkChi2")
        #if not self.mNormTrkChi2_branch and "mNormTrkChi2" not in self.complained:
        if not self.mNormTrkChi2_branch and "mNormTrkChi2":
            warnings.warn( "EMTree: Expected branch mNormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mNormTrkChi2")
        else:
            self.mNormTrkChi2_branch.SetAddress(<void*>&self.mNormTrkChi2_value)

        #print "making mNormalizedChi2"
        self.mNormalizedChi2_branch = the_tree.GetBranch("mNormalizedChi2")
        #if not self.mNormalizedChi2_branch and "mNormalizedChi2" not in self.complained:
        if not self.mNormalizedChi2_branch and "mNormalizedChi2":
            warnings.warn( "EMTree: Expected branch mNormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mNormalizedChi2")
        else:
            self.mNormalizedChi2_branch.SetAddress(<void*>&self.mNormalizedChi2_value)

        #print "making mPFChargedHadronIsoR04"
        self.mPFChargedHadronIsoR04_branch = the_tree.GetBranch("mPFChargedHadronIsoR04")
        #if not self.mPFChargedHadronIsoR04_branch and "mPFChargedHadronIsoR04" not in self.complained:
        if not self.mPFChargedHadronIsoR04_branch and "mPFChargedHadronIsoR04":
            warnings.warn( "EMTree: Expected branch mPFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFChargedHadronIsoR04")
        else:
            self.mPFChargedHadronIsoR04_branch.SetAddress(<void*>&self.mPFChargedHadronIsoR04_value)

        #print "making mPFChargedIso"
        self.mPFChargedIso_branch = the_tree.GetBranch("mPFChargedIso")
        #if not self.mPFChargedIso_branch and "mPFChargedIso" not in self.complained:
        if not self.mPFChargedIso_branch and "mPFChargedIso":
            warnings.warn( "EMTree: Expected branch mPFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFChargedIso")
        else:
            self.mPFChargedIso_branch.SetAddress(<void*>&self.mPFChargedIso_value)

        #print "making mPFIDLoose"
        self.mPFIDLoose_branch = the_tree.GetBranch("mPFIDLoose")
        #if not self.mPFIDLoose_branch and "mPFIDLoose" not in self.complained:
        if not self.mPFIDLoose_branch and "mPFIDLoose":
            warnings.warn( "EMTree: Expected branch mPFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIDLoose")
        else:
            self.mPFIDLoose_branch.SetAddress(<void*>&self.mPFIDLoose_value)

        #print "making mPFIDMedium"
        self.mPFIDMedium_branch = the_tree.GetBranch("mPFIDMedium")
        #if not self.mPFIDMedium_branch and "mPFIDMedium" not in self.complained:
        if not self.mPFIDMedium_branch and "mPFIDMedium":
            warnings.warn( "EMTree: Expected branch mPFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIDMedium")
        else:
            self.mPFIDMedium_branch.SetAddress(<void*>&self.mPFIDMedium_value)

        #print "making mPFIDTight"
        self.mPFIDTight_branch = the_tree.GetBranch("mPFIDTight")
        #if not self.mPFIDTight_branch and "mPFIDTight" not in self.complained:
        if not self.mPFIDTight_branch and "mPFIDTight":
            warnings.warn( "EMTree: Expected branch mPFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIDTight")
        else:
            self.mPFIDTight_branch.SetAddress(<void*>&self.mPFIDTight_value)

        #print "making mPFIsoLoose"
        self.mPFIsoLoose_branch = the_tree.GetBranch("mPFIsoLoose")
        #if not self.mPFIsoLoose_branch and "mPFIsoLoose" not in self.complained:
        if not self.mPFIsoLoose_branch and "mPFIsoLoose":
            warnings.warn( "EMTree: Expected branch mPFIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIsoLoose")
        else:
            self.mPFIsoLoose_branch.SetAddress(<void*>&self.mPFIsoLoose_value)

        #print "making mPFIsoMedium"
        self.mPFIsoMedium_branch = the_tree.GetBranch("mPFIsoMedium")
        #if not self.mPFIsoMedium_branch and "mPFIsoMedium" not in self.complained:
        if not self.mPFIsoMedium_branch and "mPFIsoMedium":
            warnings.warn( "EMTree: Expected branch mPFIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIsoMedium")
        else:
            self.mPFIsoMedium_branch.SetAddress(<void*>&self.mPFIsoMedium_value)

        #print "making mPFIsoTight"
        self.mPFIsoTight_branch = the_tree.GetBranch("mPFIsoTight")
        #if not self.mPFIsoTight_branch and "mPFIsoTight" not in self.complained:
        if not self.mPFIsoTight_branch and "mPFIsoTight":
            warnings.warn( "EMTree: Expected branch mPFIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIsoTight")
        else:
            self.mPFIsoTight_branch.SetAddress(<void*>&self.mPFIsoTight_value)

        #print "making mPFNeutralHadronIsoR04"
        self.mPFNeutralHadronIsoR04_branch = the_tree.GetBranch("mPFNeutralHadronIsoR04")
        #if not self.mPFNeutralHadronIsoR04_branch and "mPFNeutralHadronIsoR04" not in self.complained:
        if not self.mPFNeutralHadronIsoR04_branch and "mPFNeutralHadronIsoR04":
            warnings.warn( "EMTree: Expected branch mPFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFNeutralHadronIsoR04")
        else:
            self.mPFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.mPFNeutralHadronIsoR04_value)

        #print "making mPFNeutralIso"
        self.mPFNeutralIso_branch = the_tree.GetBranch("mPFNeutralIso")
        #if not self.mPFNeutralIso_branch and "mPFNeutralIso" not in self.complained:
        if not self.mPFNeutralIso_branch and "mPFNeutralIso":
            warnings.warn( "EMTree: Expected branch mPFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFNeutralIso")
        else:
            self.mPFNeutralIso_branch.SetAddress(<void*>&self.mPFNeutralIso_value)

        #print "making mPFPUChargedIso"
        self.mPFPUChargedIso_branch = the_tree.GetBranch("mPFPUChargedIso")
        #if not self.mPFPUChargedIso_branch and "mPFPUChargedIso" not in self.complained:
        if not self.mPFPUChargedIso_branch and "mPFPUChargedIso":
            warnings.warn( "EMTree: Expected branch mPFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFPUChargedIso")
        else:
            self.mPFPUChargedIso_branch.SetAddress(<void*>&self.mPFPUChargedIso_value)

        #print "making mPFPhotonIso"
        self.mPFPhotonIso_branch = the_tree.GetBranch("mPFPhotonIso")
        #if not self.mPFPhotonIso_branch and "mPFPhotonIso" not in self.complained:
        if not self.mPFPhotonIso_branch and "mPFPhotonIso":
            warnings.warn( "EMTree: Expected branch mPFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFPhotonIso")
        else:
            self.mPFPhotonIso_branch.SetAddress(<void*>&self.mPFPhotonIso_value)

        #print "making mPFPhotonIsoR04"
        self.mPFPhotonIsoR04_branch = the_tree.GetBranch("mPFPhotonIsoR04")
        #if not self.mPFPhotonIsoR04_branch and "mPFPhotonIsoR04" not in self.complained:
        if not self.mPFPhotonIsoR04_branch and "mPFPhotonIsoR04":
            warnings.warn( "EMTree: Expected branch mPFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFPhotonIsoR04")
        else:
            self.mPFPhotonIsoR04_branch.SetAddress(<void*>&self.mPFPhotonIsoR04_value)

        #print "making mPFPileupIsoR04"
        self.mPFPileupIsoR04_branch = the_tree.GetBranch("mPFPileupIsoR04")
        #if not self.mPFPileupIsoR04_branch and "mPFPileupIsoR04" not in self.complained:
        if not self.mPFPileupIsoR04_branch and "mPFPileupIsoR04":
            warnings.warn( "EMTree: Expected branch mPFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFPileupIsoR04")
        else:
            self.mPFPileupIsoR04_branch.SetAddress(<void*>&self.mPFPileupIsoR04_value)

        #print "making mPVDXY"
        self.mPVDXY_branch = the_tree.GetBranch("mPVDXY")
        #if not self.mPVDXY_branch and "mPVDXY" not in self.complained:
        if not self.mPVDXY_branch and "mPVDXY":
            warnings.warn( "EMTree: Expected branch mPVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPVDXY")
        else:
            self.mPVDXY_branch.SetAddress(<void*>&self.mPVDXY_value)

        #print "making mPVDZ"
        self.mPVDZ_branch = the_tree.GetBranch("mPVDZ")
        #if not self.mPVDZ_branch and "mPVDZ" not in self.complained:
        if not self.mPVDZ_branch and "mPVDZ":
            warnings.warn( "EMTree: Expected branch mPVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPVDZ")
        else:
            self.mPVDZ_branch.SetAddress(<void*>&self.mPVDZ_value)

        #print "making mPhi"
        self.mPhi_branch = the_tree.GetBranch("mPhi")
        #if not self.mPhi_branch and "mPhi" not in self.complained:
        if not self.mPhi_branch and "mPhi":
            warnings.warn( "EMTree: Expected branch mPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPhi")
        else:
            self.mPhi_branch.SetAddress(<void*>&self.mPhi_value)

        #print "making mPixHits"
        self.mPixHits_branch = the_tree.GetBranch("mPixHits")
        #if not self.mPixHits_branch and "mPixHits" not in self.complained:
        if not self.mPixHits_branch and "mPixHits":
            warnings.warn( "EMTree: Expected branch mPixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPixHits")
        else:
            self.mPixHits_branch.SetAddress(<void*>&self.mPixHits_value)

        #print "making mPt"
        self.mPt_branch = the_tree.GetBranch("mPt")
        #if not self.mPt_branch and "mPt" not in self.complained:
        if not self.mPt_branch and "mPt":
            warnings.warn( "EMTree: Expected branch mPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPt")
        else:
            self.mPt_branch.SetAddress(<void*>&self.mPt_value)

        #print "making mRelPFIsoDBDefault"
        self.mRelPFIsoDBDefault_branch = the_tree.GetBranch("mRelPFIsoDBDefault")
        #if not self.mRelPFIsoDBDefault_branch and "mRelPFIsoDBDefault" not in self.complained:
        if not self.mRelPFIsoDBDefault_branch and "mRelPFIsoDBDefault":
            warnings.warn( "EMTree: Expected branch mRelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRelPFIsoDBDefault")
        else:
            self.mRelPFIsoDBDefault_branch.SetAddress(<void*>&self.mRelPFIsoDBDefault_value)

        #print "making mRelPFIsoDBDefaultR04"
        self.mRelPFIsoDBDefaultR04_branch = the_tree.GetBranch("mRelPFIsoDBDefaultR04")
        #if not self.mRelPFIsoDBDefaultR04_branch and "mRelPFIsoDBDefaultR04" not in self.complained:
        if not self.mRelPFIsoDBDefaultR04_branch and "mRelPFIsoDBDefaultR04":
            warnings.warn( "EMTree: Expected branch mRelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRelPFIsoDBDefaultR04")
        else:
            self.mRelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.mRelPFIsoDBDefaultR04_value)

        #print "making mRelPFIsoRho"
        self.mRelPFIsoRho_branch = the_tree.GetBranch("mRelPFIsoRho")
        #if not self.mRelPFIsoRho_branch and "mRelPFIsoRho" not in self.complained:
        if not self.mRelPFIsoRho_branch and "mRelPFIsoRho":
            warnings.warn( "EMTree: Expected branch mRelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRelPFIsoRho")
        else:
            self.mRelPFIsoRho_branch.SetAddress(<void*>&self.mRelPFIsoRho_value)

        #print "making mRho"
        self.mRho_branch = the_tree.GetBranch("mRho")
        #if not self.mRho_branch and "mRho" not in self.complained:
        if not self.mRho_branch and "mRho":
            warnings.warn( "EMTree: Expected branch mRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRho")
        else:
            self.mRho_branch.SetAddress(<void*>&self.mRho_value)

        #print "making mSIP2D"
        self.mSIP2D_branch = the_tree.GetBranch("mSIP2D")
        #if not self.mSIP2D_branch and "mSIP2D" not in self.complained:
        if not self.mSIP2D_branch and "mSIP2D":
            warnings.warn( "EMTree: Expected branch mSIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mSIP2D")
        else:
            self.mSIP2D_branch.SetAddress(<void*>&self.mSIP2D_value)

        #print "making mSIP3D"
        self.mSIP3D_branch = the_tree.GetBranch("mSIP3D")
        #if not self.mSIP3D_branch and "mSIP3D" not in self.complained:
        if not self.mSIP3D_branch and "mSIP3D":
            warnings.warn( "EMTree: Expected branch mSIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mSIP3D")
        else:
            self.mSIP3D_branch.SetAddress(<void*>&self.mSIP3D_value)

        #print "making mSegmentCompatibility"
        self.mSegmentCompatibility_branch = the_tree.GetBranch("mSegmentCompatibility")
        #if not self.mSegmentCompatibility_branch and "mSegmentCompatibility" not in self.complained:
        if not self.mSegmentCompatibility_branch and "mSegmentCompatibility":
            warnings.warn( "EMTree: Expected branch mSegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mSegmentCompatibility")
        else:
            self.mSegmentCompatibility_branch.SetAddress(<void*>&self.mSegmentCompatibility_value)

        #print "making mTkLayersWithMeasurement"
        self.mTkLayersWithMeasurement_branch = the_tree.GetBranch("mTkLayersWithMeasurement")
        #if not self.mTkLayersWithMeasurement_branch and "mTkLayersWithMeasurement" not in self.complained:
        if not self.mTkLayersWithMeasurement_branch and "mTkLayersWithMeasurement":
            warnings.warn( "EMTree: Expected branch mTkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTkLayersWithMeasurement")
        else:
            self.mTkLayersWithMeasurement_branch.SetAddress(<void*>&self.mTkLayersWithMeasurement_value)

        #print "making mTrkIsoDR03"
        self.mTrkIsoDR03_branch = the_tree.GetBranch("mTrkIsoDR03")
        #if not self.mTrkIsoDR03_branch and "mTrkIsoDR03" not in self.complained:
        if not self.mTrkIsoDR03_branch and "mTrkIsoDR03":
            warnings.warn( "EMTree: Expected branch mTrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTrkIsoDR03")
        else:
            self.mTrkIsoDR03_branch.SetAddress(<void*>&self.mTrkIsoDR03_value)

        #print "making mTrkKink"
        self.mTrkKink_branch = the_tree.GetBranch("mTrkKink")
        #if not self.mTrkKink_branch and "mTrkKink" not in self.complained:
        if not self.mTrkKink_branch and "mTrkKink":
            warnings.warn( "EMTree: Expected branch mTrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTrkKink")
        else:
            self.mTrkKink_branch.SetAddress(<void*>&self.mTrkKink_value)

        #print "making mTypeCode"
        self.mTypeCode_branch = the_tree.GetBranch("mTypeCode")
        #if not self.mTypeCode_branch and "mTypeCode" not in self.complained:
        if not self.mTypeCode_branch and "mTypeCode":
            warnings.warn( "EMTree: Expected branch mTypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTypeCode")
        else:
            self.mTypeCode_branch.SetAddress(<void*>&self.mTypeCode_value)

        #print "making mVZ"
        self.mVZ_branch = the_tree.GetBranch("mVZ")
        #if not self.mVZ_branch and "mVZ" not in self.complained:
        if not self.mVZ_branch and "mVZ":
            warnings.warn( "EMTree: Expected branch mVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mVZ")
        else:
            self.mVZ_branch.SetAddress(<void*>&self.mVZ_value)

        #print "making mValidFraction"
        self.mValidFraction_branch = the_tree.GetBranch("mValidFraction")
        #if not self.mValidFraction_branch and "mValidFraction" not in self.complained:
        if not self.mValidFraction_branch and "mValidFraction":
            warnings.warn( "EMTree: Expected branch mValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mValidFraction")
        else:
            self.mValidFraction_branch.SetAddress(<void*>&self.mValidFraction_value)

        #print "making mZTTGenMatching"
        self.mZTTGenMatching_branch = the_tree.GetBranch("mZTTGenMatching")
        #if not self.mZTTGenMatching_branch and "mZTTGenMatching" not in self.complained:
        if not self.mZTTGenMatching_branch and "mZTTGenMatching":
            warnings.warn( "EMTree: Expected branch mZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mZTTGenMatching")
        else:
            self.mZTTGenMatching_branch.SetAddress(<void*>&self.mZTTGenMatching_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "EMTree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "EMTree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "EMTree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "EMTree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "EMTree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

        #print "making mu12e23DZPass"
        self.mu12e23DZPass_branch = the_tree.GetBranch("mu12e23DZPass")
        #if not self.mu12e23DZPass_branch and "mu12e23DZPass" not in self.complained:
        if not self.mu12e23DZPass_branch and "mu12e23DZPass":
            warnings.warn( "EMTree: Expected branch mu12e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23DZPass")
        else:
            self.mu12e23DZPass_branch.SetAddress(<void*>&self.mu12e23DZPass_value)

        #print "making mu12e23Pass"
        self.mu12e23Pass_branch = the_tree.GetBranch("mu12e23Pass")
        #if not self.mu12e23Pass_branch and "mu12e23Pass" not in self.complained:
        if not self.mu12e23Pass_branch and "mu12e23Pass":
            warnings.warn( "EMTree: Expected branch mu12e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23Pass")
        else:
            self.mu12e23Pass_branch.SetAddress(<void*>&self.mu12e23Pass_value)

        #print "making mu23e12DZPass"
        self.mu23e12DZPass_branch = the_tree.GetBranch("mu23e12DZPass")
        #if not self.mu23e12DZPass_branch and "mu23e12DZPass" not in self.complained:
        if not self.mu23e12DZPass_branch and "mu23e12DZPass":
            warnings.warn( "EMTree: Expected branch mu23e12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12DZPass")
        else:
            self.mu23e12DZPass_branch.SetAddress(<void*>&self.mu23e12DZPass_value)

        #print "making mu23e12Pass"
        self.mu23e12Pass_branch = the_tree.GetBranch("mu23e12Pass")
        #if not self.mu23e12Pass_branch and "mu23e12Pass" not in self.complained:
        if not self.mu23e12Pass_branch and "mu23e12Pass":
            warnings.warn( "EMTree: Expected branch mu23e12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12Pass")
        else:
            self.mu23e12Pass_branch.SetAddress(<void*>&self.mu23e12Pass_value)

        #print "making mu8diele12DZPass"
        self.mu8diele12DZPass_branch = the_tree.GetBranch("mu8diele12DZPass")
        #if not self.mu8diele12DZPass_branch and "mu8diele12DZPass" not in self.complained:
        if not self.mu8diele12DZPass_branch and "mu8diele12DZPass":
            warnings.warn( "EMTree: Expected branch mu8diele12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12DZPass")
        else:
            self.mu8diele12DZPass_branch.SetAddress(<void*>&self.mu8diele12DZPass_value)

        #print "making mu8diele12Pass"
        self.mu8diele12Pass_branch = the_tree.GetBranch("mu8diele12Pass")
        #if not self.mu8diele12Pass_branch and "mu8diele12Pass" not in self.complained:
        if not self.mu8diele12Pass_branch and "mu8diele12Pass":
            warnings.warn( "EMTree: Expected branch mu8diele12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12Pass")
        else:
            self.mu8diele12Pass_branch.SetAddress(<void*>&self.mu8diele12Pass_value)

        #print "making mu8e23DZPass"
        self.mu8e23DZPass_branch = the_tree.GetBranch("mu8e23DZPass")
        #if not self.mu8e23DZPass_branch and "mu8e23DZPass" not in self.complained:
        if not self.mu8e23DZPass_branch and "mu8e23DZPass":
            warnings.warn( "EMTree: Expected branch mu8e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23DZPass")
        else:
            self.mu8e23DZPass_branch.SetAddress(<void*>&self.mu8e23DZPass_value)

        #print "making mu8e23Pass"
        self.mu8e23Pass_branch = the_tree.GetBranch("mu8e23Pass")
        #if not self.mu8e23Pass_branch and "mu8e23Pass" not in self.complained:
        if not self.mu8e23Pass_branch and "mu8e23Pass":
            warnings.warn( "EMTree: Expected branch mu8e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23Pass")
        else:
            self.mu8e23Pass_branch.SetAddress(<void*>&self.mu8e23Pass_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "EMTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "EMTree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "EMTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making npNLO"
        self.npNLO_branch = the_tree.GetBranch("npNLO")
        #if not self.npNLO_branch and "npNLO" not in self.complained:
        if not self.npNLO_branch and "npNLO":
            warnings.warn( "EMTree: Expected branch npNLO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("npNLO")
        else:
            self.npNLO_branch.SetAddress(<void*>&self.npNLO_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "EMTree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "EMTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making prefiring_weight"
        self.prefiring_weight_branch = the_tree.GetBranch("prefiring_weight")
        #if not self.prefiring_weight_branch and "prefiring_weight" not in self.complained:
        if not self.prefiring_weight_branch and "prefiring_weight":
            warnings.warn( "EMTree: Expected branch prefiring_weight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight")
        else:
            self.prefiring_weight_branch.SetAddress(<void*>&self.prefiring_weight_value)

        #print "making prefiring_weight_down"
        self.prefiring_weight_down_branch = the_tree.GetBranch("prefiring_weight_down")
        #if not self.prefiring_weight_down_branch and "prefiring_weight_down" not in self.complained:
        if not self.prefiring_weight_down_branch and "prefiring_weight_down":
            warnings.warn( "EMTree: Expected branch prefiring_weight_down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight_down")
        else:
            self.prefiring_weight_down_branch.SetAddress(<void*>&self.prefiring_weight_down_value)

        #print "making prefiring_weight_up"
        self.prefiring_weight_up_branch = the_tree.GetBranch("prefiring_weight_up")
        #if not self.prefiring_weight_up_branch and "prefiring_weight_up" not in self.complained:
        if not self.prefiring_weight_up_branch and "prefiring_weight_up":
            warnings.warn( "EMTree: Expected branch prefiring_weight_up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight_up")
        else:
            self.prefiring_weight_up_branch.SetAddress(<void*>&self.prefiring_weight_up_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "EMTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "EMTree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "EMTree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "EMTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "EMTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "EMTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "EMTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "EMTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "EMTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "EMTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "EMTree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "EMTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "EMTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "EMTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "EMTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "EMTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "EMTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "EMTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "EMTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleE25eta2p1TightPass"
        self.singleE25eta2p1TightPass_branch = the_tree.GetBranch("singleE25eta2p1TightPass")
        #if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass" not in self.complained:
        if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass":
            warnings.warn( "EMTree: Expected branch singleE25eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPass")
        else:
            self.singleE25eta2p1TightPass_branch.SetAddress(<void*>&self.singleE25eta2p1TightPass_value)

        #print "making singleIsoMu22Pass"
        self.singleIsoMu22Pass_branch = the_tree.GetBranch("singleIsoMu22Pass")
        #if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass" not in self.complained:
        if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass":
            warnings.warn( "EMTree: Expected branch singleIsoMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Pass")
        else:
            self.singleIsoMu22Pass_branch.SetAddress(<void*>&self.singleIsoMu22Pass_value)

        #print "making singleIsoMu22eta2p1Pass"
        self.singleIsoMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu22eta2p1Pass")
        #if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass":
            warnings.warn( "EMTree: Expected branch singleIsoMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Pass")
        else:
            self.singleIsoMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Pass_value)

        #print "making singleIsoTkMu22Pass"
        self.singleIsoTkMu22Pass_branch = the_tree.GetBranch("singleIsoTkMu22Pass")
        #if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass" not in self.complained:
        if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass":
            warnings.warn( "EMTree: Expected branch singleIsoTkMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Pass")
        else:
            self.singleIsoTkMu22Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22Pass_value)

        #print "making singleIsoTkMu22eta2p1Pass"
        self.singleIsoTkMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Pass")
        #if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass":
            warnings.warn( "EMTree: Expected branch singleIsoTkMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Pass")
        else:
            self.singleIsoTkMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Pass_value)

        #print "making singleMu19eta2p1LooseTau20Pass"
        self.singleMu19eta2p1LooseTau20Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Pass")
        #if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass":
            warnings.warn( "EMTree: Expected branch singleMu19eta2p1LooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Pass")
        else:
            self.singleMu19eta2p1LooseTau20Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Pass_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Pass"
        self.singleMu19eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass":
            warnings.warn( "EMTree: Expected branch singleMu19eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Pass_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "EMTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20LooseMVALTVtx"
        self.tauVetoPt20LooseMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVALTVtx")
        #if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx":
            warnings.warn( "EMTree: Expected branch tauVetoPt20LooseMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVALTVtx")
        else:
            self.tauVetoPt20LooseMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVALTVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "EMTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making topQuarkPt1"
        self.topQuarkPt1_branch = the_tree.GetBranch("topQuarkPt1")
        #if not self.topQuarkPt1_branch and "topQuarkPt1" not in self.complained:
        if not self.topQuarkPt1_branch and "topQuarkPt1":
            warnings.warn( "EMTree: Expected branch topQuarkPt1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt1")
        else:
            self.topQuarkPt1_branch.SetAddress(<void*>&self.topQuarkPt1_value)

        #print "making topQuarkPt2"
        self.topQuarkPt2_branch = the_tree.GetBranch("topQuarkPt2")
        #if not self.topQuarkPt2_branch and "topQuarkPt2" not in self.complained:
        if not self.topQuarkPt2_branch and "topQuarkPt2":
            warnings.warn( "EMTree: Expected branch topQuarkPt2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt2")
        else:
            self.topQuarkPt2_branch.SetAddress(<void*>&self.topQuarkPt2_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "EMTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleMu10_5_5Pass"
        self.tripleMu10_5_5Pass_branch = the_tree.GetBranch("tripleMu10_5_5Pass")
        #if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass" not in self.complained:
        if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass":
            warnings.warn( "EMTree: Expected branch tripleMu10_5_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu10_5_5Pass")
        else:
            self.tripleMu10_5_5Pass_branch.SetAddress(<void*>&self.tripleMu10_5_5Pass_value)

        #print "making tripleMu12_10_5Pass"
        self.tripleMu12_10_5Pass_branch = the_tree.GetBranch("tripleMu12_10_5Pass")
        #if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass" not in self.complained:
        if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass":
            warnings.warn( "EMTree: Expected branch tripleMu12_10_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu12_10_5Pass")
        else:
            self.tripleMu12_10_5Pass_branch.SetAddress(<void*>&self.tripleMu12_10_5Pass_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "EMTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "EMTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteScaleDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteScaleDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteScaleDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteScaleUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteScaleUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteScaleUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteStatDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteStatDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteStatDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteStatUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteStatUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteStatUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_value)

        #print "making type1_pfMet_shiftedPhi_JetClosureDown"
        self.type1_pfMet_shiftedPhi_JetClosureDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetClosureDown")
        #if not self.type1_pfMet_shiftedPhi_JetClosureDown_branch and "type1_pfMet_shiftedPhi_JetClosureDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetClosureDown_branch and "type1_pfMet_shiftedPhi_JetClosureDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetClosureDown")
        else:
            self.type1_pfMet_shiftedPhi_JetClosureDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetClosureDown_value)

        #print "making type1_pfMet_shiftedPhi_JetClosureUp"
        self.type1_pfMet_shiftedPhi_JetClosureUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetClosureUp")
        #if not self.type1_pfMet_shiftedPhi_JetClosureUp_branch and "type1_pfMet_shiftedPhi_JetClosureUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetClosureUp_branch and "type1_pfMet_shiftedPhi_JetClosureUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetClosureUp")
        else:
            self.type1_pfMet_shiftedPhi_JetClosureUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetClosureUp_value)

        #print "making type1_pfMet_shiftedPhi_JetEC2Down"
        self.type1_pfMet_shiftedPhi_JetEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetEC2Down_branch and "type1_pfMet_shiftedPhi_JetEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEC2Down_branch and "type1_pfMet_shiftedPhi_JetEC2Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEC2Up"
        self.type1_pfMet_shiftedPhi_JetEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetEC2Up_branch and "type1_pfMet_shiftedPhi_JetEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEC2Up_branch and "type1_pfMet_shiftedPhi_JetEC2Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetEnDown"
        self.type1_pfMet_shiftedPhi_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnDown")
        #if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnDown")
        else:
            self.type1_pfMet_shiftedPhi_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnDown_value)

        #print "making type1_pfMet_shiftedPhi_JetEnUp"
        self.type1_pfMet_shiftedPhi_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnUp")
        #if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnUp")
        else:
            self.type1_pfMet_shiftedPhi_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnUp_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to3Down"
        self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to3Down")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch and "type1_pfMet_shiftedPhi_JetEta0to3Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch and "type1_pfMet_shiftedPhi_JetEta0to3Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to3Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to3Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to3Up"
        self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to3Up")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch and "type1_pfMet_shiftedPhi_JetEta0to3Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch and "type1_pfMet_shiftedPhi_JetEta0to3Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to3Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to3Up_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to5Down"
        self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to5Down")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch and "type1_pfMet_shiftedPhi_JetEta0to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch and "type1_pfMet_shiftedPhi_JetEta0to5Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to5Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to5Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to5Up"
        self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to5Up")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch and "type1_pfMet_shiftedPhi_JetEta0to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch and "type1_pfMet_shiftedPhi_JetEta0to5Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to5Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to5Up_value)

        #print "making type1_pfMet_shiftedPhi_JetEta3to5Down"
        self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta3to5Down")
        #if not self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch and "type1_pfMet_shiftedPhi_JetEta3to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch and "type1_pfMet_shiftedPhi_JetEta3to5Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta3to5Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta3to5Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEta3to5Up"
        self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta3to5Up")
        #if not self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch and "type1_pfMet_shiftedPhi_JetEta3to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch and "type1_pfMet_shiftedPhi_JetEta3to5Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta3to5Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta3to5Up_value)

        #print "making type1_pfMet_shiftedPhi_JetFlavorQCDDown"
        self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFlavorQCDDown")
        #if not self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFlavorQCDDown")
        else:
            self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_value)

        #print "making type1_pfMet_shiftedPhi_JetFlavorQCDUp"
        self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFlavorQCDUp")
        #if not self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFlavorQCDUp")
        else:
            self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_value)

        #print "making type1_pfMet_shiftedPhi_JetFragmentationDown"
        self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFragmentationDown")
        #if not self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch and "type1_pfMet_shiftedPhi_JetFragmentationDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch and "type1_pfMet_shiftedPhi_JetFragmentationDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFragmentationDown")
        else:
            self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFragmentationDown_value)

        #print "making type1_pfMet_shiftedPhi_JetFragmentationUp"
        self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFragmentationUp")
        #if not self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch and "type1_pfMet_shiftedPhi_JetFragmentationUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch and "type1_pfMet_shiftedPhi_JetFragmentationUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFragmentationUp")
        else:
            self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFragmentationUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpDataMCDown"
        self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpDataMCDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpDataMCDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpDataMCUp"
        self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpDataMCUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpDataMCUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtBBDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtBBDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtBBDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtBBUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtBBUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtBBUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC1Down"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC1Up"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC2Down"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC2Up"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtHFDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtHFUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtRefDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtRefDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtRefDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtRefUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtRefUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtRefUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeBalDown"
        self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeBalDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch and "type1_pfMet_shiftedPhi_JetRelativeBalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch and "type1_pfMet_shiftedPhi_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeBalDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeBalDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeBalUp"
        self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeBalUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch and "type1_pfMet_shiftedPhi_JetRelativeBalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch and "type1_pfMet_shiftedPhi_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeBalUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeBalUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeFSRDown"
        self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeFSRDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeFSRDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeFSRUp"
        self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeFSRUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeFSRUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC1Down"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC1Up"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC2Down"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC2Up"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJERHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJERHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJERHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJERHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJERHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJERHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtBBDown"
        self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtBBDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtBBDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtBBUp"
        self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtBBUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtBBUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC1Down"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC1Up"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC2Down"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC2Up"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeSampleDown"
        self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeSampleDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeSampleDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeSampleUp"
        self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeSampleUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeSampleUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatECDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatECDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatECDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatECUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatECUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatECUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatFSRDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatFSRDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatFSRDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatFSRUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatFSRUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatFSRUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetResDown"
        self.type1_pfMet_shiftedPhi_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResDown")
        #if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResDown")
        else:
            self.type1_pfMet_shiftedPhi_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResDown_value)

        #print "making type1_pfMet_shiftedPhi_JetResUp"
        self.type1_pfMet_shiftedPhi_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResUp")
        #if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResUp")
        else:
            self.type1_pfMet_shiftedPhi_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResUp_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionECALDown"
        self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionECALDown")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionECALDown")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionECALUp"
        self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionECALUp")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionECALUp")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionHCALDown"
        self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionHCALDown")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionHCALDown")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionHCALUp"
        self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionHCALUp")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionHCALUp")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_value)

        #print "making type1_pfMet_shiftedPhi_JetTimePtEtaDown"
        self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTimePtEtaDown")
        #if not self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTimePtEtaDown")
        else:
            self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_value)

        #print "making type1_pfMet_shiftedPhi_JetTimePtEtaUp"
        self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTimePtEtaUp")
        #if not self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTimePtEtaUp")
        else:
            self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_value)

        #print "making type1_pfMet_shiftedPhi_JetTotalDown"
        self.type1_pfMet_shiftedPhi_JetTotalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTotalDown")
        #if not self.type1_pfMet_shiftedPhi_JetTotalDown_branch and "type1_pfMet_shiftedPhi_JetTotalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTotalDown_branch and "type1_pfMet_shiftedPhi_JetTotalDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTotalDown")
        else:
            self.type1_pfMet_shiftedPhi_JetTotalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTotalDown_value)

        #print "making type1_pfMet_shiftedPhi_JetTotalUp"
        self.type1_pfMet_shiftedPhi_JetTotalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTotalUp")
        #if not self.type1_pfMet_shiftedPhi_JetTotalUp_branch and "type1_pfMet_shiftedPhi_JetTotalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTotalUp_branch and "type1_pfMet_shiftedPhi_JetTotalUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTotalUp")
        else:
            self.type1_pfMet_shiftedPhi_JetTotalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTotalUp_value)

        #print "making type1_pfMet_shiftedPhi_UesCHARGEDDown"
        self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesCHARGEDDown")
        #if not self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch and "type1_pfMet_shiftedPhi_UesCHARGEDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch and "type1_pfMet_shiftedPhi_UesCHARGEDDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_UesCHARGEDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesCHARGEDDown")
        else:
            self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesCHARGEDDown_value)

        #print "making type1_pfMet_shiftedPhi_UesCHARGEDUp"
        self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesCHARGEDUp")
        #if not self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch and "type1_pfMet_shiftedPhi_UesCHARGEDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch and "type1_pfMet_shiftedPhi_UesCHARGEDUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_UesCHARGEDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesCHARGEDUp")
        else:
            self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesCHARGEDUp_value)

        #print "making type1_pfMet_shiftedPhi_UesECALDown"
        self.type1_pfMet_shiftedPhi_UesECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesECALDown")
        #if not self.type1_pfMet_shiftedPhi_UesECALDown_branch and "type1_pfMet_shiftedPhi_UesECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesECALDown_branch and "type1_pfMet_shiftedPhi_UesECALDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_UesECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesECALDown")
        else:
            self.type1_pfMet_shiftedPhi_UesECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesECALDown_value)

        #print "making type1_pfMet_shiftedPhi_UesECALUp"
        self.type1_pfMet_shiftedPhi_UesECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesECALUp")
        #if not self.type1_pfMet_shiftedPhi_UesECALUp_branch and "type1_pfMet_shiftedPhi_UesECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesECALUp_branch and "type1_pfMet_shiftedPhi_UesECALUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_UesECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesECALUp")
        else:
            self.type1_pfMet_shiftedPhi_UesECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesECALUp_value)

        #print "making type1_pfMet_shiftedPhi_UesHCALDown"
        self.type1_pfMet_shiftedPhi_UesHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesHCALDown")
        #if not self.type1_pfMet_shiftedPhi_UesHCALDown_branch and "type1_pfMet_shiftedPhi_UesHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesHCALDown_branch and "type1_pfMet_shiftedPhi_UesHCALDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_UesHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesHCALDown")
        else:
            self.type1_pfMet_shiftedPhi_UesHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesHCALDown_value)

        #print "making type1_pfMet_shiftedPhi_UesHCALUp"
        self.type1_pfMet_shiftedPhi_UesHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesHCALUp")
        #if not self.type1_pfMet_shiftedPhi_UesHCALUp_branch and "type1_pfMet_shiftedPhi_UesHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesHCALUp_branch and "type1_pfMet_shiftedPhi_UesHCALUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_UesHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesHCALUp")
        else:
            self.type1_pfMet_shiftedPhi_UesHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesHCALUp_value)

        #print "making type1_pfMet_shiftedPhi_UesHFDown"
        self.type1_pfMet_shiftedPhi_UesHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesHFDown")
        #if not self.type1_pfMet_shiftedPhi_UesHFDown_branch and "type1_pfMet_shiftedPhi_UesHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesHFDown_branch and "type1_pfMet_shiftedPhi_UesHFDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_UesHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesHFDown")
        else:
            self.type1_pfMet_shiftedPhi_UesHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesHFDown_value)

        #print "making type1_pfMet_shiftedPhi_UesHFUp"
        self.type1_pfMet_shiftedPhi_UesHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesHFUp")
        #if not self.type1_pfMet_shiftedPhi_UesHFUp_branch and "type1_pfMet_shiftedPhi_UesHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesHFUp_branch and "type1_pfMet_shiftedPhi_UesHFUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_UesHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesHFUp")
        else:
            self.type1_pfMet_shiftedPhi_UesHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesHFUp_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnDown"
        self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnUp"
        self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteScaleDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteScaleDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteScaleDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteScaleUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteScaleUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteScaleUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteStatDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteStatDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteStatDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteStatUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteStatUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteStatUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_value)

        #print "making type1_pfMet_shiftedPt_JetClosureDown"
        self.type1_pfMet_shiftedPt_JetClosureDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetClosureDown")
        #if not self.type1_pfMet_shiftedPt_JetClosureDown_branch and "type1_pfMet_shiftedPt_JetClosureDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetClosureDown_branch and "type1_pfMet_shiftedPt_JetClosureDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetClosureDown")
        else:
            self.type1_pfMet_shiftedPt_JetClosureDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetClosureDown_value)

        #print "making type1_pfMet_shiftedPt_JetClosureUp"
        self.type1_pfMet_shiftedPt_JetClosureUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetClosureUp")
        #if not self.type1_pfMet_shiftedPt_JetClosureUp_branch and "type1_pfMet_shiftedPt_JetClosureUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetClosureUp_branch and "type1_pfMet_shiftedPt_JetClosureUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetClosureUp")
        else:
            self.type1_pfMet_shiftedPt_JetClosureUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetClosureUp_value)

        #print "making type1_pfMet_shiftedPt_JetEC2Down"
        self.type1_pfMet_shiftedPt_JetEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEC2Down")
        #if not self.type1_pfMet_shiftedPt_JetEC2Down_branch and "type1_pfMet_shiftedPt_JetEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEC2Down_branch and "type1_pfMet_shiftedPt_JetEC2Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetEC2Up"
        self.type1_pfMet_shiftedPt_JetEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEC2Up")
        #if not self.type1_pfMet_shiftedPt_JetEC2Up_branch and "type1_pfMet_shiftedPt_JetEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEC2Up_branch and "type1_pfMet_shiftedPt_JetEC2Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetEnDown"
        self.type1_pfMet_shiftedPt_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnDown")
        #if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnDown")
        else:
            self.type1_pfMet_shiftedPt_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnDown_value)

        #print "making type1_pfMet_shiftedPt_JetEnUp"
        self.type1_pfMet_shiftedPt_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnUp")
        #if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnUp")
        else:
            self.type1_pfMet_shiftedPt_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnUp_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to3Down"
        self.type1_pfMet_shiftedPt_JetEta0to3Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to3Down")
        #if not self.type1_pfMet_shiftedPt_JetEta0to3Down_branch and "type1_pfMet_shiftedPt_JetEta0to3Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to3Down_branch and "type1_pfMet_shiftedPt_JetEta0to3Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to3Down")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to3Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to3Down_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to3Up"
        self.type1_pfMet_shiftedPt_JetEta0to3Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to3Up")
        #if not self.type1_pfMet_shiftedPt_JetEta0to3Up_branch and "type1_pfMet_shiftedPt_JetEta0to3Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to3Up_branch and "type1_pfMet_shiftedPt_JetEta0to3Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to3Up")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to3Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to3Up_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to5Down"
        self.type1_pfMet_shiftedPt_JetEta0to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to5Down")
        #if not self.type1_pfMet_shiftedPt_JetEta0to5Down_branch and "type1_pfMet_shiftedPt_JetEta0to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to5Down_branch and "type1_pfMet_shiftedPt_JetEta0to5Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to5Down")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to5Down_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to5Up"
        self.type1_pfMet_shiftedPt_JetEta0to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to5Up")
        #if not self.type1_pfMet_shiftedPt_JetEta0to5Up_branch and "type1_pfMet_shiftedPt_JetEta0to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to5Up_branch and "type1_pfMet_shiftedPt_JetEta0to5Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to5Up")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to5Up_value)

        #print "making type1_pfMet_shiftedPt_JetEta3to5Down"
        self.type1_pfMet_shiftedPt_JetEta3to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta3to5Down")
        #if not self.type1_pfMet_shiftedPt_JetEta3to5Down_branch and "type1_pfMet_shiftedPt_JetEta3to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta3to5Down_branch and "type1_pfMet_shiftedPt_JetEta3to5Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta3to5Down")
        else:
            self.type1_pfMet_shiftedPt_JetEta3to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta3to5Down_value)

        #print "making type1_pfMet_shiftedPt_JetEta3to5Up"
        self.type1_pfMet_shiftedPt_JetEta3to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta3to5Up")
        #if not self.type1_pfMet_shiftedPt_JetEta3to5Up_branch and "type1_pfMet_shiftedPt_JetEta3to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta3to5Up_branch and "type1_pfMet_shiftedPt_JetEta3to5Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta3to5Up")
        else:
            self.type1_pfMet_shiftedPt_JetEta3to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta3to5Up_value)

        #print "making type1_pfMet_shiftedPt_JetFlavorQCDDown"
        self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFlavorQCDDown")
        #if not self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPt_JetFlavorQCDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPt_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFlavorQCDDown")
        else:
            self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFlavorQCDDown_value)

        #print "making type1_pfMet_shiftedPt_JetFlavorQCDUp"
        self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFlavorQCDUp")
        #if not self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPt_JetFlavorQCDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPt_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFlavorQCDUp")
        else:
            self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFlavorQCDUp_value)

        #print "making type1_pfMet_shiftedPt_JetFragmentationDown"
        self.type1_pfMet_shiftedPt_JetFragmentationDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFragmentationDown")
        #if not self.type1_pfMet_shiftedPt_JetFragmentationDown_branch and "type1_pfMet_shiftedPt_JetFragmentationDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFragmentationDown_branch and "type1_pfMet_shiftedPt_JetFragmentationDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFragmentationDown")
        else:
            self.type1_pfMet_shiftedPt_JetFragmentationDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFragmentationDown_value)

        #print "making type1_pfMet_shiftedPt_JetFragmentationUp"
        self.type1_pfMet_shiftedPt_JetFragmentationUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFragmentationUp")
        #if not self.type1_pfMet_shiftedPt_JetFragmentationUp_branch and "type1_pfMet_shiftedPt_JetFragmentationUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFragmentationUp_branch and "type1_pfMet_shiftedPt_JetFragmentationUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFragmentationUp")
        else:
            self.type1_pfMet_shiftedPt_JetFragmentationUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFragmentationUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpDataMCDown"
        self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpDataMCDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpDataMCDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpDataMCUp"
        self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpDataMCUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpDataMCUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtBBDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtBBDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtBBDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtBBUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtBBUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtBBUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC1Down"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC1Down")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC1Up"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC1Up")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC2Down"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC2Down")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC2Up"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC2Up")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtHFDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtHFDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtHFUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtHFUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtRefDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtRefDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtRefDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtRefUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtRefUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtRefUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeBalDown"
        self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeBalDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch and "type1_pfMet_shiftedPt_JetRelativeBalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch and "type1_pfMet_shiftedPt_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeBalDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeBalDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeBalUp"
        self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeBalUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch and "type1_pfMet_shiftedPt_JetRelativeBalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch and "type1_pfMet_shiftedPt_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeBalUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeBalUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeFSRDown"
        self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeFSRDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeFSRDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeFSRDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeFSRDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeFSRUp"
        self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeFSRUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeFSRUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeFSRUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeFSRUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC1Down"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC1Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC1Up"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC1Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC2Down"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC2Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC2Up"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC2Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJERHFDown"
        self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJERHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJERHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJERHFUp"
        self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJERHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJERHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtBBDown"
        self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtBBDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPt_JetRelativePtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPt_JetRelativePtBBDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtBBDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtBBDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtBBUp"
        self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtBBUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPt_JetRelativePtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPt_JetRelativePtBBUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtBBUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtBBUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC1Down"
        self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC1Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC1Up"
        self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC1Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC2Down"
        self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC2Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC2Up"
        self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC2Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtHFDown"
        self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPt_JetRelativePtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPt_JetRelativePtHFDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtHFUp"
        self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPt_JetRelativePtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPt_JetRelativePtHFUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeSampleDown"
        self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeSampleDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPt_JetRelativeSampleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPt_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeSampleDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeSampleDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeSampleUp"
        self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeSampleUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPt_JetRelativeSampleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPt_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeSampleUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeSampleUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatECDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatECDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatECDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatECDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatECDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatECDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatECUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatECUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatECUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatECUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatECUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatECUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatFSRDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatFSRDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatFSRDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatFSRUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatFSRUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatFSRUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatHFDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatHFUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetResDown"
        self.type1_pfMet_shiftedPt_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResDown")
        #if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResDown")
        else:
            self.type1_pfMet_shiftedPt_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResDown_value)

        #print "making type1_pfMet_shiftedPt_JetResUp"
        self.type1_pfMet_shiftedPt_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResUp")
        #if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResUp")
        else:
            self.type1_pfMet_shiftedPt_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResUp_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionECALDown"
        self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionECALDown")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionECALDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionECALDown")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionECALDown_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionECALUp"
        self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionECALUp")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionECALUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionECALUp")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionECALUp_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionHCALDown"
        self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionHCALDown")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionHCALDown")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionHCALUp"
        self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionHCALUp")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionHCALUp")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_value)

        #print "making type1_pfMet_shiftedPt_JetTimePtEtaDown"
        self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTimePtEtaDown")
        #if not self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPt_JetTimePtEtaDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPt_JetTimePtEtaDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTimePtEtaDown")
        else:
            self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTimePtEtaDown_value)

        #print "making type1_pfMet_shiftedPt_JetTimePtEtaUp"
        self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTimePtEtaUp")
        #if not self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPt_JetTimePtEtaUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPt_JetTimePtEtaUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTimePtEtaUp")
        else:
            self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTimePtEtaUp_value)

        #print "making type1_pfMet_shiftedPt_JetTotalDown"
        self.type1_pfMet_shiftedPt_JetTotalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTotalDown")
        #if not self.type1_pfMet_shiftedPt_JetTotalDown_branch and "type1_pfMet_shiftedPt_JetTotalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTotalDown_branch and "type1_pfMet_shiftedPt_JetTotalDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTotalDown")
        else:
            self.type1_pfMet_shiftedPt_JetTotalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTotalDown_value)

        #print "making type1_pfMet_shiftedPt_JetTotalUp"
        self.type1_pfMet_shiftedPt_JetTotalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTotalUp")
        #if not self.type1_pfMet_shiftedPt_JetTotalUp_branch and "type1_pfMet_shiftedPt_JetTotalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTotalUp_branch and "type1_pfMet_shiftedPt_JetTotalUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTotalUp")
        else:
            self.type1_pfMet_shiftedPt_JetTotalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTotalUp_value)

        #print "making type1_pfMet_shiftedPt_UesCHARGEDDown"
        self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesCHARGEDDown")
        #if not self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch and "type1_pfMet_shiftedPt_UesCHARGEDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch and "type1_pfMet_shiftedPt_UesCHARGEDDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_UesCHARGEDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesCHARGEDDown")
        else:
            self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesCHARGEDDown_value)

        #print "making type1_pfMet_shiftedPt_UesCHARGEDUp"
        self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesCHARGEDUp")
        #if not self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch and "type1_pfMet_shiftedPt_UesCHARGEDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch and "type1_pfMet_shiftedPt_UesCHARGEDUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_UesCHARGEDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesCHARGEDUp")
        else:
            self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesCHARGEDUp_value)

        #print "making type1_pfMet_shiftedPt_UesECALDown"
        self.type1_pfMet_shiftedPt_UesECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesECALDown")
        #if not self.type1_pfMet_shiftedPt_UesECALDown_branch and "type1_pfMet_shiftedPt_UesECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesECALDown_branch and "type1_pfMet_shiftedPt_UesECALDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_UesECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesECALDown")
        else:
            self.type1_pfMet_shiftedPt_UesECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesECALDown_value)

        #print "making type1_pfMet_shiftedPt_UesECALUp"
        self.type1_pfMet_shiftedPt_UesECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesECALUp")
        #if not self.type1_pfMet_shiftedPt_UesECALUp_branch and "type1_pfMet_shiftedPt_UesECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesECALUp_branch and "type1_pfMet_shiftedPt_UesECALUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_UesECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesECALUp")
        else:
            self.type1_pfMet_shiftedPt_UesECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesECALUp_value)

        #print "making type1_pfMet_shiftedPt_UesHCALDown"
        self.type1_pfMet_shiftedPt_UesHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesHCALDown")
        #if not self.type1_pfMet_shiftedPt_UesHCALDown_branch and "type1_pfMet_shiftedPt_UesHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesHCALDown_branch and "type1_pfMet_shiftedPt_UesHCALDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_UesHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesHCALDown")
        else:
            self.type1_pfMet_shiftedPt_UesHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesHCALDown_value)

        #print "making type1_pfMet_shiftedPt_UesHCALUp"
        self.type1_pfMet_shiftedPt_UesHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesHCALUp")
        #if not self.type1_pfMet_shiftedPt_UesHCALUp_branch and "type1_pfMet_shiftedPt_UesHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesHCALUp_branch and "type1_pfMet_shiftedPt_UesHCALUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_UesHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesHCALUp")
        else:
            self.type1_pfMet_shiftedPt_UesHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesHCALUp_value)

        #print "making type1_pfMet_shiftedPt_UesHFDown"
        self.type1_pfMet_shiftedPt_UesHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesHFDown")
        #if not self.type1_pfMet_shiftedPt_UesHFDown_branch and "type1_pfMet_shiftedPt_UesHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesHFDown_branch and "type1_pfMet_shiftedPt_UesHFDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_UesHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesHFDown")
        else:
            self.type1_pfMet_shiftedPt_UesHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesHFDown_value)

        #print "making type1_pfMet_shiftedPt_UesHFUp"
        self.type1_pfMet_shiftedPt_UesHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesHFUp")
        #if not self.type1_pfMet_shiftedPt_UesHFUp_branch and "type1_pfMet_shiftedPt_UesHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesHFUp_branch and "type1_pfMet_shiftedPt_UesHFUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_UesHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesHFUp")
        else:
            self.type1_pfMet_shiftedPt_UesHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesHFUp_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnDown"
        self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnUp"
        self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnUp_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "EMTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "EMTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "EMTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "EMTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMassWoNoisyJets"
        self.vbfMassWoNoisyJets_branch = the_tree.GetBranch("vbfMassWoNoisyJets")
        #if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets" not in self.complained:
        if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets")
        else:
            self.vbfMassWoNoisyJets_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_value)

        #print "making vbfMassWoNoisyJets_JetEC2Down"
        self.vbfMassWoNoisyJets_JetEC2Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEC2Down")
        #if not self.vbfMassWoNoisyJets_JetEC2Down_branch and "vbfMassWoNoisyJets_JetEC2Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEC2Down_branch and "vbfMassWoNoisyJets_JetEC2Down":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEC2Down")
        else:
            self.vbfMassWoNoisyJets_JetEC2Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEC2Down_value)

        #print "making vbfMassWoNoisyJets_JetEC2Up"
        self.vbfMassWoNoisyJets_JetEC2Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEC2Up")
        #if not self.vbfMassWoNoisyJets_JetEC2Up_branch and "vbfMassWoNoisyJets_JetEC2Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEC2Up_branch and "vbfMassWoNoisyJets_JetEC2Up":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEC2Up")
        else:
            self.vbfMassWoNoisyJets_JetEC2Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEC2Up_value)

        #print "making vbfMassWoNoisyJets_JetEta0to3Down"
        self.vbfMassWoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to3Down")
        #if not self.vbfMassWoNoisyJets_JetEta0to3Down_branch and "vbfMassWoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to3Down_branch and "vbfMassWoNoisyJets_JetEta0to3Down":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to3Down")
        else:
            self.vbfMassWoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to3Down_value)

        #print "making vbfMassWoNoisyJets_JetEta0to3Up"
        self.vbfMassWoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to3Up")
        #if not self.vbfMassWoNoisyJets_JetEta0to3Up_branch and "vbfMassWoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to3Up_branch and "vbfMassWoNoisyJets_JetEta0to3Up":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to3Up")
        else:
            self.vbfMassWoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to3Up_value)

        #print "making vbfMassWoNoisyJets_JetEta0to5Down"
        self.vbfMassWoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to5Down")
        #if not self.vbfMassWoNoisyJets_JetEta0to5Down_branch and "vbfMassWoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to5Down_branch and "vbfMassWoNoisyJets_JetEta0to5Down":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to5Down")
        else:
            self.vbfMassWoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to5Down_value)

        #print "making vbfMassWoNoisyJets_JetEta0to5Up"
        self.vbfMassWoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to5Up")
        #if not self.vbfMassWoNoisyJets_JetEta0to5Up_branch and "vbfMassWoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to5Up_branch and "vbfMassWoNoisyJets_JetEta0to5Up":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to5Up")
        else:
            self.vbfMassWoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to5Up_value)

        #print "making vbfMassWoNoisyJets_JetEta3to5Down"
        self.vbfMassWoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta3to5Down")
        #if not self.vbfMassWoNoisyJets_JetEta3to5Down_branch and "vbfMassWoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta3to5Down_branch and "vbfMassWoNoisyJets_JetEta3to5Down":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta3to5Down")
        else:
            self.vbfMassWoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta3to5Down_value)

        #print "making vbfMassWoNoisyJets_JetEta3to5Up"
        self.vbfMassWoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta3to5Up")
        #if not self.vbfMassWoNoisyJets_JetEta3to5Up_branch and "vbfMassWoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta3to5Up_branch and "vbfMassWoNoisyJets_JetEta3to5Up":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta3to5Up")
        else:
            self.vbfMassWoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta3to5Up_value)

        #print "making vbfMassWoNoisyJets_JetRelativeBalDown"
        self.vbfMassWoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeBalDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeBalDown_branch and "vbfMassWoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeBalDown_branch and "vbfMassWoNoisyJets_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeBalDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeBalDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeBalUp"
        self.vbfMassWoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeBalUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeBalUp_branch and "vbfMassWoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeBalUp_branch and "vbfMassWoNoisyJets_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeBalUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeBalUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeSampleDown"
        self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeSampleDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch and "vbfMassWoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch and "vbfMassWoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeSampleDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeSampleDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeSampleUp"
        self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeSampleUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch and "vbfMassWoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch and "vbfMassWoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeSampleUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeSampleUp_value)

        #print "making vbfMassWoNoisyJets_JetTotalDown"
        self.vbfMassWoNoisyJets_JetTotalDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetTotalDown")
        #if not self.vbfMassWoNoisyJets_JetTotalDown_branch and "vbfMassWoNoisyJets_JetTotalDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetTotalDown_branch and "vbfMassWoNoisyJets_JetTotalDown":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetTotalDown")
        else:
            self.vbfMassWoNoisyJets_JetTotalDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetTotalDown_value)

        #print "making vbfMassWoNoisyJets_JetTotalUp"
        self.vbfMassWoNoisyJets_JetTotalUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetTotalUp")
        #if not self.vbfMassWoNoisyJets_JetTotalUp_branch and "vbfMassWoNoisyJets_JetTotalUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetTotalUp_branch and "vbfMassWoNoisyJets_JetTotalUp":
            warnings.warn( "EMTree: Expected branch vbfMassWoNoisyJets_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetTotalUp")
        else:
            self.vbfMassWoNoisyJets_JetTotalUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetTotalUp_value)

        #print "making vbfMass_JetAbsoluteFlavMapDown"
        self.vbfMass_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteFlavMapDown")
        #if not self.vbfMass_JetAbsoluteFlavMapDown_branch and "vbfMass_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteFlavMapDown_branch and "vbfMass_JetAbsoluteFlavMapDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteFlavMapDown")
        else:
            self.vbfMass_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteFlavMapDown_value)

        #print "making vbfMass_JetAbsoluteFlavMapUp"
        self.vbfMass_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteFlavMapUp")
        #if not self.vbfMass_JetAbsoluteFlavMapUp_branch and "vbfMass_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteFlavMapUp_branch and "vbfMass_JetAbsoluteFlavMapUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteFlavMapUp")
        else:
            self.vbfMass_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteFlavMapUp_value)

        #print "making vbfMass_JetAbsoluteMPFBiasDown"
        self.vbfMass_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteMPFBiasDown")
        #if not self.vbfMass_JetAbsoluteMPFBiasDown_branch and "vbfMass_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteMPFBiasDown_branch and "vbfMass_JetAbsoluteMPFBiasDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteMPFBiasDown")
        else:
            self.vbfMass_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteMPFBiasDown_value)

        #print "making vbfMass_JetAbsoluteMPFBiasUp"
        self.vbfMass_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteMPFBiasUp")
        #if not self.vbfMass_JetAbsoluteMPFBiasUp_branch and "vbfMass_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteMPFBiasUp_branch and "vbfMass_JetAbsoluteMPFBiasUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteMPFBiasUp")
        else:
            self.vbfMass_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteMPFBiasUp_value)

        #print "making vbfMass_JetAbsoluteScaleDown"
        self.vbfMass_JetAbsoluteScaleDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteScaleDown")
        #if not self.vbfMass_JetAbsoluteScaleDown_branch and "vbfMass_JetAbsoluteScaleDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteScaleDown_branch and "vbfMass_JetAbsoluteScaleDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteScaleDown")
        else:
            self.vbfMass_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteScaleDown_value)

        #print "making vbfMass_JetAbsoluteScaleUp"
        self.vbfMass_JetAbsoluteScaleUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteScaleUp")
        #if not self.vbfMass_JetAbsoluteScaleUp_branch and "vbfMass_JetAbsoluteScaleUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteScaleUp_branch and "vbfMass_JetAbsoluteScaleUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteScaleUp")
        else:
            self.vbfMass_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteScaleUp_value)

        #print "making vbfMass_JetAbsoluteStatDown"
        self.vbfMass_JetAbsoluteStatDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteStatDown")
        #if not self.vbfMass_JetAbsoluteStatDown_branch and "vbfMass_JetAbsoluteStatDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteStatDown_branch and "vbfMass_JetAbsoluteStatDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteStatDown")
        else:
            self.vbfMass_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteStatDown_value)

        #print "making vbfMass_JetAbsoluteStatUp"
        self.vbfMass_JetAbsoluteStatUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteStatUp")
        #if not self.vbfMass_JetAbsoluteStatUp_branch and "vbfMass_JetAbsoluteStatUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteStatUp_branch and "vbfMass_JetAbsoluteStatUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteStatUp")
        else:
            self.vbfMass_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteStatUp_value)

        #print "making vbfMass_JetClosureDown"
        self.vbfMass_JetClosureDown_branch = the_tree.GetBranch("vbfMass_JetClosureDown")
        #if not self.vbfMass_JetClosureDown_branch and "vbfMass_JetClosureDown" not in self.complained:
        if not self.vbfMass_JetClosureDown_branch and "vbfMass_JetClosureDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetClosureDown")
        else:
            self.vbfMass_JetClosureDown_branch.SetAddress(<void*>&self.vbfMass_JetClosureDown_value)

        #print "making vbfMass_JetClosureUp"
        self.vbfMass_JetClosureUp_branch = the_tree.GetBranch("vbfMass_JetClosureUp")
        #if not self.vbfMass_JetClosureUp_branch and "vbfMass_JetClosureUp" not in self.complained:
        if not self.vbfMass_JetClosureUp_branch and "vbfMass_JetClosureUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetClosureUp")
        else:
            self.vbfMass_JetClosureUp_branch.SetAddress(<void*>&self.vbfMass_JetClosureUp_value)

        #print "making vbfMass_JetEC2Down"
        self.vbfMass_JetEC2Down_branch = the_tree.GetBranch("vbfMass_JetEC2Down")
        #if not self.vbfMass_JetEC2Down_branch and "vbfMass_JetEC2Down" not in self.complained:
        if not self.vbfMass_JetEC2Down_branch and "vbfMass_JetEC2Down":
            warnings.warn( "EMTree: Expected branch vbfMass_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEC2Down")
        else:
            self.vbfMass_JetEC2Down_branch.SetAddress(<void*>&self.vbfMass_JetEC2Down_value)

        #print "making vbfMass_JetEC2Up"
        self.vbfMass_JetEC2Up_branch = the_tree.GetBranch("vbfMass_JetEC2Up")
        #if not self.vbfMass_JetEC2Up_branch and "vbfMass_JetEC2Up" not in self.complained:
        if not self.vbfMass_JetEC2Up_branch and "vbfMass_JetEC2Up":
            warnings.warn( "EMTree: Expected branch vbfMass_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEC2Up")
        else:
            self.vbfMass_JetEC2Up_branch.SetAddress(<void*>&self.vbfMass_JetEC2Up_value)

        #print "making vbfMass_JetEta0to3Down"
        self.vbfMass_JetEta0to3Down_branch = the_tree.GetBranch("vbfMass_JetEta0to3Down")
        #if not self.vbfMass_JetEta0to3Down_branch and "vbfMass_JetEta0to3Down" not in self.complained:
        if not self.vbfMass_JetEta0to3Down_branch and "vbfMass_JetEta0to3Down":
            warnings.warn( "EMTree: Expected branch vbfMass_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEta0to3Down")
        else:
            self.vbfMass_JetEta0to3Down_branch.SetAddress(<void*>&self.vbfMass_JetEta0to3Down_value)

        #print "making vbfMass_JetEta0to3Up"
        self.vbfMass_JetEta0to3Up_branch = the_tree.GetBranch("vbfMass_JetEta0to3Up")
        #if not self.vbfMass_JetEta0to3Up_branch and "vbfMass_JetEta0to3Up" not in self.complained:
        if not self.vbfMass_JetEta0to3Up_branch and "vbfMass_JetEta0to3Up":
            warnings.warn( "EMTree: Expected branch vbfMass_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEta0to3Up")
        else:
            self.vbfMass_JetEta0to3Up_branch.SetAddress(<void*>&self.vbfMass_JetEta0to3Up_value)

        #print "making vbfMass_JetEta0to5Down"
        self.vbfMass_JetEta0to5Down_branch = the_tree.GetBranch("vbfMass_JetEta0to5Down")
        #if not self.vbfMass_JetEta0to5Down_branch and "vbfMass_JetEta0to5Down" not in self.complained:
        if not self.vbfMass_JetEta0to5Down_branch and "vbfMass_JetEta0to5Down":
            warnings.warn( "EMTree: Expected branch vbfMass_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEta0to5Down")
        else:
            self.vbfMass_JetEta0to5Down_branch.SetAddress(<void*>&self.vbfMass_JetEta0to5Down_value)

        #print "making vbfMass_JetEta0to5Up"
        self.vbfMass_JetEta0to5Up_branch = the_tree.GetBranch("vbfMass_JetEta0to5Up")
        #if not self.vbfMass_JetEta0to5Up_branch and "vbfMass_JetEta0to5Up" not in self.complained:
        if not self.vbfMass_JetEta0to5Up_branch and "vbfMass_JetEta0to5Up":
            warnings.warn( "EMTree: Expected branch vbfMass_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEta0to5Up")
        else:
            self.vbfMass_JetEta0to5Up_branch.SetAddress(<void*>&self.vbfMass_JetEta0to5Up_value)

        #print "making vbfMass_JetEta3to5Down"
        self.vbfMass_JetEta3to5Down_branch = the_tree.GetBranch("vbfMass_JetEta3to5Down")
        #if not self.vbfMass_JetEta3to5Down_branch and "vbfMass_JetEta3to5Down" not in self.complained:
        if not self.vbfMass_JetEta3to5Down_branch and "vbfMass_JetEta3to5Down":
            warnings.warn( "EMTree: Expected branch vbfMass_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEta3to5Down")
        else:
            self.vbfMass_JetEta3to5Down_branch.SetAddress(<void*>&self.vbfMass_JetEta3to5Down_value)

        #print "making vbfMass_JetEta3to5Up"
        self.vbfMass_JetEta3to5Up_branch = the_tree.GetBranch("vbfMass_JetEta3to5Up")
        #if not self.vbfMass_JetEta3to5Up_branch and "vbfMass_JetEta3to5Up" not in self.complained:
        if not self.vbfMass_JetEta3to5Up_branch and "vbfMass_JetEta3to5Up":
            warnings.warn( "EMTree: Expected branch vbfMass_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEta3to5Up")
        else:
            self.vbfMass_JetEta3to5Up_branch.SetAddress(<void*>&self.vbfMass_JetEta3to5Up_value)

        #print "making vbfMass_JetFlavorQCDDown"
        self.vbfMass_JetFlavorQCDDown_branch = the_tree.GetBranch("vbfMass_JetFlavorQCDDown")
        #if not self.vbfMass_JetFlavorQCDDown_branch and "vbfMass_JetFlavorQCDDown" not in self.complained:
        if not self.vbfMass_JetFlavorQCDDown_branch and "vbfMass_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFlavorQCDDown")
        else:
            self.vbfMass_JetFlavorQCDDown_branch.SetAddress(<void*>&self.vbfMass_JetFlavorQCDDown_value)

        #print "making vbfMass_JetFlavorQCDUp"
        self.vbfMass_JetFlavorQCDUp_branch = the_tree.GetBranch("vbfMass_JetFlavorQCDUp")
        #if not self.vbfMass_JetFlavorQCDUp_branch and "vbfMass_JetFlavorQCDUp" not in self.complained:
        if not self.vbfMass_JetFlavorQCDUp_branch and "vbfMass_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFlavorQCDUp")
        else:
            self.vbfMass_JetFlavorQCDUp_branch.SetAddress(<void*>&self.vbfMass_JetFlavorQCDUp_value)

        #print "making vbfMass_JetFragmentationDown"
        self.vbfMass_JetFragmentationDown_branch = the_tree.GetBranch("vbfMass_JetFragmentationDown")
        #if not self.vbfMass_JetFragmentationDown_branch and "vbfMass_JetFragmentationDown" not in self.complained:
        if not self.vbfMass_JetFragmentationDown_branch and "vbfMass_JetFragmentationDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFragmentationDown")
        else:
            self.vbfMass_JetFragmentationDown_branch.SetAddress(<void*>&self.vbfMass_JetFragmentationDown_value)

        #print "making vbfMass_JetFragmentationUp"
        self.vbfMass_JetFragmentationUp_branch = the_tree.GetBranch("vbfMass_JetFragmentationUp")
        #if not self.vbfMass_JetFragmentationUp_branch and "vbfMass_JetFragmentationUp" not in self.complained:
        if not self.vbfMass_JetFragmentationUp_branch and "vbfMass_JetFragmentationUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFragmentationUp")
        else:
            self.vbfMass_JetFragmentationUp_branch.SetAddress(<void*>&self.vbfMass_JetFragmentationUp_value)

        #print "making vbfMass_JetPileUpDataMCDown"
        self.vbfMass_JetPileUpDataMCDown_branch = the_tree.GetBranch("vbfMass_JetPileUpDataMCDown")
        #if not self.vbfMass_JetPileUpDataMCDown_branch and "vbfMass_JetPileUpDataMCDown" not in self.complained:
        if not self.vbfMass_JetPileUpDataMCDown_branch and "vbfMass_JetPileUpDataMCDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpDataMCDown")
        else:
            self.vbfMass_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpDataMCDown_value)

        #print "making vbfMass_JetPileUpDataMCUp"
        self.vbfMass_JetPileUpDataMCUp_branch = the_tree.GetBranch("vbfMass_JetPileUpDataMCUp")
        #if not self.vbfMass_JetPileUpDataMCUp_branch and "vbfMass_JetPileUpDataMCUp" not in self.complained:
        if not self.vbfMass_JetPileUpDataMCUp_branch and "vbfMass_JetPileUpDataMCUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpDataMCUp")
        else:
            self.vbfMass_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpDataMCUp_value)

        #print "making vbfMass_JetPileUpPtBBDown"
        self.vbfMass_JetPileUpPtBBDown_branch = the_tree.GetBranch("vbfMass_JetPileUpPtBBDown")
        #if not self.vbfMass_JetPileUpPtBBDown_branch and "vbfMass_JetPileUpPtBBDown" not in self.complained:
        if not self.vbfMass_JetPileUpPtBBDown_branch and "vbfMass_JetPileUpPtBBDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtBBDown")
        else:
            self.vbfMass_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtBBDown_value)

        #print "making vbfMass_JetPileUpPtBBUp"
        self.vbfMass_JetPileUpPtBBUp_branch = the_tree.GetBranch("vbfMass_JetPileUpPtBBUp")
        #if not self.vbfMass_JetPileUpPtBBUp_branch and "vbfMass_JetPileUpPtBBUp" not in self.complained:
        if not self.vbfMass_JetPileUpPtBBUp_branch and "vbfMass_JetPileUpPtBBUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtBBUp")
        else:
            self.vbfMass_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtBBUp_value)

        #print "making vbfMass_JetPileUpPtEC1Down"
        self.vbfMass_JetPileUpPtEC1Down_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC1Down")
        #if not self.vbfMass_JetPileUpPtEC1Down_branch and "vbfMass_JetPileUpPtEC1Down" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC1Down_branch and "vbfMass_JetPileUpPtEC1Down":
            warnings.warn( "EMTree: Expected branch vbfMass_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC1Down")
        else:
            self.vbfMass_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC1Down_value)

        #print "making vbfMass_JetPileUpPtEC1Up"
        self.vbfMass_JetPileUpPtEC1Up_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC1Up")
        #if not self.vbfMass_JetPileUpPtEC1Up_branch and "vbfMass_JetPileUpPtEC1Up" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC1Up_branch and "vbfMass_JetPileUpPtEC1Up":
            warnings.warn( "EMTree: Expected branch vbfMass_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC1Up")
        else:
            self.vbfMass_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC1Up_value)

        #print "making vbfMass_JetPileUpPtEC2Down"
        self.vbfMass_JetPileUpPtEC2Down_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC2Down")
        #if not self.vbfMass_JetPileUpPtEC2Down_branch and "vbfMass_JetPileUpPtEC2Down" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC2Down_branch and "vbfMass_JetPileUpPtEC2Down":
            warnings.warn( "EMTree: Expected branch vbfMass_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC2Down")
        else:
            self.vbfMass_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC2Down_value)

        #print "making vbfMass_JetPileUpPtEC2Up"
        self.vbfMass_JetPileUpPtEC2Up_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC2Up")
        #if not self.vbfMass_JetPileUpPtEC2Up_branch and "vbfMass_JetPileUpPtEC2Up" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC2Up_branch and "vbfMass_JetPileUpPtEC2Up":
            warnings.warn( "EMTree: Expected branch vbfMass_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC2Up")
        else:
            self.vbfMass_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC2Up_value)

        #print "making vbfMass_JetPileUpPtHFDown"
        self.vbfMass_JetPileUpPtHFDown_branch = the_tree.GetBranch("vbfMass_JetPileUpPtHFDown")
        #if not self.vbfMass_JetPileUpPtHFDown_branch and "vbfMass_JetPileUpPtHFDown" not in self.complained:
        if not self.vbfMass_JetPileUpPtHFDown_branch and "vbfMass_JetPileUpPtHFDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtHFDown")
        else:
            self.vbfMass_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtHFDown_value)

        #print "making vbfMass_JetPileUpPtHFUp"
        self.vbfMass_JetPileUpPtHFUp_branch = the_tree.GetBranch("vbfMass_JetPileUpPtHFUp")
        #if not self.vbfMass_JetPileUpPtHFUp_branch and "vbfMass_JetPileUpPtHFUp" not in self.complained:
        if not self.vbfMass_JetPileUpPtHFUp_branch and "vbfMass_JetPileUpPtHFUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtHFUp")
        else:
            self.vbfMass_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtHFUp_value)

        #print "making vbfMass_JetPileUpPtRefDown"
        self.vbfMass_JetPileUpPtRefDown_branch = the_tree.GetBranch("vbfMass_JetPileUpPtRefDown")
        #if not self.vbfMass_JetPileUpPtRefDown_branch and "vbfMass_JetPileUpPtRefDown" not in self.complained:
        if not self.vbfMass_JetPileUpPtRefDown_branch and "vbfMass_JetPileUpPtRefDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtRefDown")
        else:
            self.vbfMass_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtRefDown_value)

        #print "making vbfMass_JetPileUpPtRefUp"
        self.vbfMass_JetPileUpPtRefUp_branch = the_tree.GetBranch("vbfMass_JetPileUpPtRefUp")
        #if not self.vbfMass_JetPileUpPtRefUp_branch and "vbfMass_JetPileUpPtRefUp" not in self.complained:
        if not self.vbfMass_JetPileUpPtRefUp_branch and "vbfMass_JetPileUpPtRefUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtRefUp")
        else:
            self.vbfMass_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtRefUp_value)

        #print "making vbfMass_JetRelativeBalDown"
        self.vbfMass_JetRelativeBalDown_branch = the_tree.GetBranch("vbfMass_JetRelativeBalDown")
        #if not self.vbfMass_JetRelativeBalDown_branch and "vbfMass_JetRelativeBalDown" not in self.complained:
        if not self.vbfMass_JetRelativeBalDown_branch and "vbfMass_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeBalDown")
        else:
            self.vbfMass_JetRelativeBalDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeBalDown_value)

        #print "making vbfMass_JetRelativeBalUp"
        self.vbfMass_JetRelativeBalUp_branch = the_tree.GetBranch("vbfMass_JetRelativeBalUp")
        #if not self.vbfMass_JetRelativeBalUp_branch and "vbfMass_JetRelativeBalUp" not in self.complained:
        if not self.vbfMass_JetRelativeBalUp_branch and "vbfMass_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeBalUp")
        else:
            self.vbfMass_JetRelativeBalUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeBalUp_value)

        #print "making vbfMass_JetRelativeFSRDown"
        self.vbfMass_JetRelativeFSRDown_branch = the_tree.GetBranch("vbfMass_JetRelativeFSRDown")
        #if not self.vbfMass_JetRelativeFSRDown_branch and "vbfMass_JetRelativeFSRDown" not in self.complained:
        if not self.vbfMass_JetRelativeFSRDown_branch and "vbfMass_JetRelativeFSRDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeFSRDown")
        else:
            self.vbfMass_JetRelativeFSRDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeFSRDown_value)

        #print "making vbfMass_JetRelativeFSRUp"
        self.vbfMass_JetRelativeFSRUp_branch = the_tree.GetBranch("vbfMass_JetRelativeFSRUp")
        #if not self.vbfMass_JetRelativeFSRUp_branch and "vbfMass_JetRelativeFSRUp" not in self.complained:
        if not self.vbfMass_JetRelativeFSRUp_branch and "vbfMass_JetRelativeFSRUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeFSRUp")
        else:
            self.vbfMass_JetRelativeFSRUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeFSRUp_value)

        #print "making vbfMass_JetRelativeJEREC1Down"
        self.vbfMass_JetRelativeJEREC1Down_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC1Down")
        #if not self.vbfMass_JetRelativeJEREC1Down_branch and "vbfMass_JetRelativeJEREC1Down" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC1Down_branch and "vbfMass_JetRelativeJEREC1Down":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC1Down")
        else:
            self.vbfMass_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC1Down_value)

        #print "making vbfMass_JetRelativeJEREC1Up"
        self.vbfMass_JetRelativeJEREC1Up_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC1Up")
        #if not self.vbfMass_JetRelativeJEREC1Up_branch and "vbfMass_JetRelativeJEREC1Up" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC1Up_branch and "vbfMass_JetRelativeJEREC1Up":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC1Up")
        else:
            self.vbfMass_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC1Up_value)

        #print "making vbfMass_JetRelativeJEREC2Down"
        self.vbfMass_JetRelativeJEREC2Down_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC2Down")
        #if not self.vbfMass_JetRelativeJEREC2Down_branch and "vbfMass_JetRelativeJEREC2Down" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC2Down_branch and "vbfMass_JetRelativeJEREC2Down":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC2Down")
        else:
            self.vbfMass_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC2Down_value)

        #print "making vbfMass_JetRelativeJEREC2Up"
        self.vbfMass_JetRelativeJEREC2Up_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC2Up")
        #if not self.vbfMass_JetRelativeJEREC2Up_branch and "vbfMass_JetRelativeJEREC2Up" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC2Up_branch and "vbfMass_JetRelativeJEREC2Up":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC2Up")
        else:
            self.vbfMass_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC2Up_value)

        #print "making vbfMass_JetRelativeJERHFDown"
        self.vbfMass_JetRelativeJERHFDown_branch = the_tree.GetBranch("vbfMass_JetRelativeJERHFDown")
        #if not self.vbfMass_JetRelativeJERHFDown_branch and "vbfMass_JetRelativeJERHFDown" not in self.complained:
        if not self.vbfMass_JetRelativeJERHFDown_branch and "vbfMass_JetRelativeJERHFDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJERHFDown")
        else:
            self.vbfMass_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJERHFDown_value)

        #print "making vbfMass_JetRelativeJERHFUp"
        self.vbfMass_JetRelativeJERHFUp_branch = the_tree.GetBranch("vbfMass_JetRelativeJERHFUp")
        #if not self.vbfMass_JetRelativeJERHFUp_branch and "vbfMass_JetRelativeJERHFUp" not in self.complained:
        if not self.vbfMass_JetRelativeJERHFUp_branch and "vbfMass_JetRelativeJERHFUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJERHFUp")
        else:
            self.vbfMass_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJERHFUp_value)

        #print "making vbfMass_JetRelativePtBBDown"
        self.vbfMass_JetRelativePtBBDown_branch = the_tree.GetBranch("vbfMass_JetRelativePtBBDown")
        #if not self.vbfMass_JetRelativePtBBDown_branch and "vbfMass_JetRelativePtBBDown" not in self.complained:
        if not self.vbfMass_JetRelativePtBBDown_branch and "vbfMass_JetRelativePtBBDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtBBDown")
        else:
            self.vbfMass_JetRelativePtBBDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtBBDown_value)

        #print "making vbfMass_JetRelativePtBBUp"
        self.vbfMass_JetRelativePtBBUp_branch = the_tree.GetBranch("vbfMass_JetRelativePtBBUp")
        #if not self.vbfMass_JetRelativePtBBUp_branch and "vbfMass_JetRelativePtBBUp" not in self.complained:
        if not self.vbfMass_JetRelativePtBBUp_branch and "vbfMass_JetRelativePtBBUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtBBUp")
        else:
            self.vbfMass_JetRelativePtBBUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtBBUp_value)

        #print "making vbfMass_JetRelativePtEC1Down"
        self.vbfMass_JetRelativePtEC1Down_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC1Down")
        #if not self.vbfMass_JetRelativePtEC1Down_branch and "vbfMass_JetRelativePtEC1Down" not in self.complained:
        if not self.vbfMass_JetRelativePtEC1Down_branch and "vbfMass_JetRelativePtEC1Down":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC1Down")
        else:
            self.vbfMass_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC1Down_value)

        #print "making vbfMass_JetRelativePtEC1Up"
        self.vbfMass_JetRelativePtEC1Up_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC1Up")
        #if not self.vbfMass_JetRelativePtEC1Up_branch and "vbfMass_JetRelativePtEC1Up" not in self.complained:
        if not self.vbfMass_JetRelativePtEC1Up_branch and "vbfMass_JetRelativePtEC1Up":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC1Up")
        else:
            self.vbfMass_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC1Up_value)

        #print "making vbfMass_JetRelativePtEC2Down"
        self.vbfMass_JetRelativePtEC2Down_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC2Down")
        #if not self.vbfMass_JetRelativePtEC2Down_branch and "vbfMass_JetRelativePtEC2Down" not in self.complained:
        if not self.vbfMass_JetRelativePtEC2Down_branch and "vbfMass_JetRelativePtEC2Down":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC2Down")
        else:
            self.vbfMass_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC2Down_value)

        #print "making vbfMass_JetRelativePtEC2Up"
        self.vbfMass_JetRelativePtEC2Up_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC2Up")
        #if not self.vbfMass_JetRelativePtEC2Up_branch and "vbfMass_JetRelativePtEC2Up" not in self.complained:
        if not self.vbfMass_JetRelativePtEC2Up_branch and "vbfMass_JetRelativePtEC2Up":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC2Up")
        else:
            self.vbfMass_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC2Up_value)

        #print "making vbfMass_JetRelativePtHFDown"
        self.vbfMass_JetRelativePtHFDown_branch = the_tree.GetBranch("vbfMass_JetRelativePtHFDown")
        #if not self.vbfMass_JetRelativePtHFDown_branch and "vbfMass_JetRelativePtHFDown" not in self.complained:
        if not self.vbfMass_JetRelativePtHFDown_branch and "vbfMass_JetRelativePtHFDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtHFDown")
        else:
            self.vbfMass_JetRelativePtHFDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtHFDown_value)

        #print "making vbfMass_JetRelativePtHFUp"
        self.vbfMass_JetRelativePtHFUp_branch = the_tree.GetBranch("vbfMass_JetRelativePtHFUp")
        #if not self.vbfMass_JetRelativePtHFUp_branch and "vbfMass_JetRelativePtHFUp" not in self.complained:
        if not self.vbfMass_JetRelativePtHFUp_branch and "vbfMass_JetRelativePtHFUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtHFUp")
        else:
            self.vbfMass_JetRelativePtHFUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtHFUp_value)

        #print "making vbfMass_JetRelativeSampleDown"
        self.vbfMass_JetRelativeSampleDown_branch = the_tree.GetBranch("vbfMass_JetRelativeSampleDown")
        #if not self.vbfMass_JetRelativeSampleDown_branch and "vbfMass_JetRelativeSampleDown" not in self.complained:
        if not self.vbfMass_JetRelativeSampleDown_branch and "vbfMass_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeSampleDown")
        else:
            self.vbfMass_JetRelativeSampleDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeSampleDown_value)

        #print "making vbfMass_JetRelativeSampleUp"
        self.vbfMass_JetRelativeSampleUp_branch = the_tree.GetBranch("vbfMass_JetRelativeSampleUp")
        #if not self.vbfMass_JetRelativeSampleUp_branch and "vbfMass_JetRelativeSampleUp" not in self.complained:
        if not self.vbfMass_JetRelativeSampleUp_branch and "vbfMass_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeSampleUp")
        else:
            self.vbfMass_JetRelativeSampleUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeSampleUp_value)

        #print "making vbfMass_JetRelativeStatECDown"
        self.vbfMass_JetRelativeStatECDown_branch = the_tree.GetBranch("vbfMass_JetRelativeStatECDown")
        #if not self.vbfMass_JetRelativeStatECDown_branch and "vbfMass_JetRelativeStatECDown" not in self.complained:
        if not self.vbfMass_JetRelativeStatECDown_branch and "vbfMass_JetRelativeStatECDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatECDown")
        else:
            self.vbfMass_JetRelativeStatECDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatECDown_value)

        #print "making vbfMass_JetRelativeStatECUp"
        self.vbfMass_JetRelativeStatECUp_branch = the_tree.GetBranch("vbfMass_JetRelativeStatECUp")
        #if not self.vbfMass_JetRelativeStatECUp_branch and "vbfMass_JetRelativeStatECUp" not in self.complained:
        if not self.vbfMass_JetRelativeStatECUp_branch and "vbfMass_JetRelativeStatECUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatECUp")
        else:
            self.vbfMass_JetRelativeStatECUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatECUp_value)

        #print "making vbfMass_JetRelativeStatFSRDown"
        self.vbfMass_JetRelativeStatFSRDown_branch = the_tree.GetBranch("vbfMass_JetRelativeStatFSRDown")
        #if not self.vbfMass_JetRelativeStatFSRDown_branch and "vbfMass_JetRelativeStatFSRDown" not in self.complained:
        if not self.vbfMass_JetRelativeStatFSRDown_branch and "vbfMass_JetRelativeStatFSRDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatFSRDown")
        else:
            self.vbfMass_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatFSRDown_value)

        #print "making vbfMass_JetRelativeStatFSRUp"
        self.vbfMass_JetRelativeStatFSRUp_branch = the_tree.GetBranch("vbfMass_JetRelativeStatFSRUp")
        #if not self.vbfMass_JetRelativeStatFSRUp_branch and "vbfMass_JetRelativeStatFSRUp" not in self.complained:
        if not self.vbfMass_JetRelativeStatFSRUp_branch and "vbfMass_JetRelativeStatFSRUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatFSRUp")
        else:
            self.vbfMass_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatFSRUp_value)

        #print "making vbfMass_JetRelativeStatHFDown"
        self.vbfMass_JetRelativeStatHFDown_branch = the_tree.GetBranch("vbfMass_JetRelativeStatHFDown")
        #if not self.vbfMass_JetRelativeStatHFDown_branch and "vbfMass_JetRelativeStatHFDown" not in self.complained:
        if not self.vbfMass_JetRelativeStatHFDown_branch and "vbfMass_JetRelativeStatHFDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatHFDown")
        else:
            self.vbfMass_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatHFDown_value)

        #print "making vbfMass_JetRelativeStatHFUp"
        self.vbfMass_JetRelativeStatHFUp_branch = the_tree.GetBranch("vbfMass_JetRelativeStatHFUp")
        #if not self.vbfMass_JetRelativeStatHFUp_branch and "vbfMass_JetRelativeStatHFUp" not in self.complained:
        if not self.vbfMass_JetRelativeStatHFUp_branch and "vbfMass_JetRelativeStatHFUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatHFUp")
        else:
            self.vbfMass_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatHFUp_value)

        #print "making vbfMass_JetSinglePionECALDown"
        self.vbfMass_JetSinglePionECALDown_branch = the_tree.GetBranch("vbfMass_JetSinglePionECALDown")
        #if not self.vbfMass_JetSinglePionECALDown_branch and "vbfMass_JetSinglePionECALDown" not in self.complained:
        if not self.vbfMass_JetSinglePionECALDown_branch and "vbfMass_JetSinglePionECALDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionECALDown")
        else:
            self.vbfMass_JetSinglePionECALDown_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionECALDown_value)

        #print "making vbfMass_JetSinglePionECALUp"
        self.vbfMass_JetSinglePionECALUp_branch = the_tree.GetBranch("vbfMass_JetSinglePionECALUp")
        #if not self.vbfMass_JetSinglePionECALUp_branch and "vbfMass_JetSinglePionECALUp" not in self.complained:
        if not self.vbfMass_JetSinglePionECALUp_branch and "vbfMass_JetSinglePionECALUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionECALUp")
        else:
            self.vbfMass_JetSinglePionECALUp_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionECALUp_value)

        #print "making vbfMass_JetSinglePionHCALDown"
        self.vbfMass_JetSinglePionHCALDown_branch = the_tree.GetBranch("vbfMass_JetSinglePionHCALDown")
        #if not self.vbfMass_JetSinglePionHCALDown_branch and "vbfMass_JetSinglePionHCALDown" not in self.complained:
        if not self.vbfMass_JetSinglePionHCALDown_branch and "vbfMass_JetSinglePionHCALDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionHCALDown")
        else:
            self.vbfMass_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionHCALDown_value)

        #print "making vbfMass_JetSinglePionHCALUp"
        self.vbfMass_JetSinglePionHCALUp_branch = the_tree.GetBranch("vbfMass_JetSinglePionHCALUp")
        #if not self.vbfMass_JetSinglePionHCALUp_branch and "vbfMass_JetSinglePionHCALUp" not in self.complained:
        if not self.vbfMass_JetSinglePionHCALUp_branch and "vbfMass_JetSinglePionHCALUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionHCALUp")
        else:
            self.vbfMass_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionHCALUp_value)

        #print "making vbfMass_JetTimePtEtaDown"
        self.vbfMass_JetTimePtEtaDown_branch = the_tree.GetBranch("vbfMass_JetTimePtEtaDown")
        #if not self.vbfMass_JetTimePtEtaDown_branch and "vbfMass_JetTimePtEtaDown" not in self.complained:
        if not self.vbfMass_JetTimePtEtaDown_branch and "vbfMass_JetTimePtEtaDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTimePtEtaDown")
        else:
            self.vbfMass_JetTimePtEtaDown_branch.SetAddress(<void*>&self.vbfMass_JetTimePtEtaDown_value)

        #print "making vbfMass_JetTimePtEtaUp"
        self.vbfMass_JetTimePtEtaUp_branch = the_tree.GetBranch("vbfMass_JetTimePtEtaUp")
        #if not self.vbfMass_JetTimePtEtaUp_branch and "vbfMass_JetTimePtEtaUp" not in self.complained:
        if not self.vbfMass_JetTimePtEtaUp_branch and "vbfMass_JetTimePtEtaUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTimePtEtaUp")
        else:
            self.vbfMass_JetTimePtEtaUp_branch.SetAddress(<void*>&self.vbfMass_JetTimePtEtaUp_value)

        #print "making vbfMass_JetTotalDown"
        self.vbfMass_JetTotalDown_branch = the_tree.GetBranch("vbfMass_JetTotalDown")
        #if not self.vbfMass_JetTotalDown_branch and "vbfMass_JetTotalDown" not in self.complained:
        if not self.vbfMass_JetTotalDown_branch and "vbfMass_JetTotalDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTotalDown")
        else:
            self.vbfMass_JetTotalDown_branch.SetAddress(<void*>&self.vbfMass_JetTotalDown_value)

        #print "making vbfMass_JetTotalUp"
        self.vbfMass_JetTotalUp_branch = the_tree.GetBranch("vbfMass_JetTotalUp")
        #if not self.vbfMass_JetTotalUp_branch and "vbfMass_JetTotalUp" not in self.complained:
        if not self.vbfMass_JetTotalUp_branch and "vbfMass_JetTotalUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTotalUp")
        else:
            self.vbfMass_JetTotalUp_branch.SetAddress(<void*>&self.vbfMass_JetTotalUp_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "EMTree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "EMTree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "EMTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "EMTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "EMTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "EMTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "EMTree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "EMTree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "EMTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property Flag_badMuons:
        def __get__(self):
            self.Flag_badMuons_branch.GetEntry(self.localentry, 0)
            return self.Flag_badMuons_value

    property Flag_duplicateMuons:
        def __get__(self):
            self.Flag_duplicateMuons_branch.GetEntry(self.localentry, 0)
            return self.Flag_duplicateMuons_value

    property Flag_ecalBadCalibFilter:
        def __get__(self):
            self.Flag_ecalBadCalibFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_ecalBadCalibFilter_value

    property Flag_ecalBadCalibReducedMINIAODFilter:
        def __get__(self):
            self.Flag_ecalBadCalibReducedMINIAODFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_ecalBadCalibReducedMINIAODFilter_value

    property Flag_eeBadScFilter:
        def __get__(self):
            self.Flag_eeBadScFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_eeBadScFilter_value

    property Flag_globalSuperTightHalo2016Filter:
        def __get__(self):
            self.Flag_globalSuperTightHalo2016Filter_branch.GetEntry(self.localentry, 0)
            return self.Flag_globalSuperTightHalo2016Filter_value

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

    property bweight_2016:
        def __get__(self):
            self.bweight_2016_branch.GetEntry(self.localentry, 0)
            return self.bweight_2016_value

    property bweight_2017:
        def __get__(self):
            self.bweight_2017_branch.GetEntry(self.localentry, 0)
            return self.bweight_2017_value

    property bweight_2018:
        def __get__(self):
            self.bweight_2018_branch.GetEntry(self.localentry, 0)
            return self.bweight_2018_value

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

    property eGenDirectPromptTauDecay:
        def __get__(self):
            self.eGenDirectPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.eGenDirectPromptTauDecay_value

    property eGenEnergy:
        def __get__(self):
            self.eGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.eGenEnergy_value

    property eGenEta:
        def __get__(self):
            self.eGenEta_branch.GetEntry(self.localentry, 0)
            return self.eGenEta_value

    property eGenIsPrompt:
        def __get__(self):
            self.eGenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.eGenIsPrompt_value

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

    property eIsoDB03:
        def __get__(self):
            self.eIsoDB03_branch.GetEntry(self.localentry, 0)
            return self.eIsoDB03_value

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

    property eMVANoisoWP80:
        def __get__(self):
            self.eMVANoisoWP80_branch.GetEntry(self.localentry, 0)
            return self.eMVANoisoWP80_value

    property eMVANoisoWP90:
        def __get__(self):
            self.eMVANoisoWP90_branch.GetEntry(self.localentry, 0)
            return self.eMVANoisoWP90_value

    property eMass:
        def __get__(self):
            self.eMass_branch.GetEntry(self.localentry, 0)
            return self.eMass_value

    property eMatchEmbeddedFilterEle24Tau30:
        def __get__(self):
            self.eMatchEmbeddedFilterEle24Tau30_branch.GetEntry(self.localentry, 0)
            return self.eMatchEmbeddedFilterEle24Tau30_value

    property eMatchEmbeddedFilterEle27:
        def __get__(self):
            self.eMatchEmbeddedFilterEle27_branch.GetEntry(self.localentry, 0)
            return self.eMatchEmbeddedFilterEle27_value

    property eMatchEmbeddedFilterEle32:
        def __get__(self):
            self.eMatchEmbeddedFilterEle32_branch.GetEntry(self.localentry, 0)
            return self.eMatchEmbeddedFilterEle32_value

    property eMatchEmbeddedFilterEle32DoubleL1_v1:
        def __get__(self):
            self.eMatchEmbeddedFilterEle32DoubleL1_v1_branch.GetEntry(self.localentry, 0)
            return self.eMatchEmbeddedFilterEle32DoubleL1_v1_value

    property eMatchEmbeddedFilterEle32DoubleL1_v2:
        def __get__(self):
            self.eMatchEmbeddedFilterEle32DoubleL1_v2_branch.GetEntry(self.localentry, 0)
            return self.eMatchEmbeddedFilterEle32DoubleL1_v2_value

    property eMatchEmbeddedFilterEle35:
        def __get__(self):
            self.eMatchEmbeddedFilterEle35_branch.GetEntry(self.localentry, 0)
            return self.eMatchEmbeddedFilterEle35_value

    property eMatchesEle24HPSTau30Filter:
        def __get__(self):
            self.eMatchesEle24HPSTau30Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24HPSTau30Filter_value

    property eMatchesEle24HPSTau30Path:
        def __get__(self):
            self.eMatchesEle24HPSTau30Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24HPSTau30Path_value

    property eMatchesEle24Tau30Filter:
        def __get__(self):
            self.eMatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24Tau30Filter_value

    property eMatchesEle24Tau30Path:
        def __get__(self):
            self.eMatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24Tau30Path_value

    property eMatchesEle25Filter:
        def __get__(self):
            self.eMatchesEle25Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle25Filter_value

    property eMatchesEle25Path:
        def __get__(self):
            self.eMatchesEle25Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle25Path_value

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

    property eMatchesMu23e12Filter:
        def __get__(self):
            self.eMatchesMu23e12Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23e12Filter_value

    property eMatchesMu23e12Path:
        def __get__(self):
            self.eMatchesMu23e12Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23e12Path_value

    property eMatchesMu8e23DZFilter:
        def __get__(self):
            self.eMatchesMu8e23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8e23DZFilter_value

    property eMatchesMu8e23DZPath:
        def __get__(self):
            self.eMatchesMu8e23DZPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8e23DZPath_value

    property eMatchesMu8e23Filter:
        def __get__(self):
            self.eMatchesMu8e23Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8e23Filter_value

    property eMatchesMu8e23Path:
        def __get__(self):
            self.eMatchesMu8e23Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8e23Path_value

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

    property eSIP2D:
        def __get__(self):
            self.eSIP2D_branch.GetEntry(self.localentry, 0)
            return self.eSIP2D_value

    property eSIP3D:
        def __get__(self):
            self.eSIP3D_branch.GetEntry(self.localentry, 0)
            return self.eSIP3D_value

    property eTrkIsoDR03:
        def __get__(self):
            self.eTrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eTrkIsoDR03_value

    property eVZ:
        def __get__(self):
            self.eVZ_branch.GetEntry(self.localentry, 0)
            return self.eVZ_value

    property eVetoMVAIsoVtx:
        def __get__(self):
            self.eVetoMVAIsoVtx_branch.GetEntry(self.localentry, 0)
            return self.eVetoMVAIsoVtx_value

    property eVetoZTTp001dxyz:
        def __get__(self):
            self.eVetoZTTp001dxyz_branch.GetEntry(self.localentry, 0)
            return self.eVetoZTTp001dxyz_value

    property eZTTGenMatching:
        def __get__(self):
            self.eZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.eZTTGenMatching_value

    property e_m_DR:
        def __get__(self):
            self.e_m_DR_branch.GetEntry(self.localentry, 0)
            return self.e_m_DR_value

    property e_m_Mass:
        def __get__(self):
            self.e_m_Mass_branch.GetEntry(self.localentry, 0)
            return self.e_m_Mass_value

    property e_m_PZeta:
        def __get__(self):
            self.e_m_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e_m_PZeta_value

    property e_m_PZetaVis:
        def __get__(self):
            self.e_m_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e_m_PZetaVis_value

    property e_m_doubleL1IsoTauMatch:
        def __get__(self):
            self.e_m_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.e_m_doubleL1IsoTauMatch_value

    property evt:
        def __get__(self):
            self.evt_branch.GetEntry(self.localentry, 0)
            return self.evt_value

    property genEta:
        def __get__(self):
            self.genEta_branch.GetEntry(self.localentry, 0)
            return self.genEta_value

    property genHTT:
        def __get__(self):
            self.genHTT_branch.GetEntry(self.localentry, 0)
            return self.genHTT_value

    property genM:
        def __get__(self):
            self.genM_branch.GetEntry(self.localentry, 0)
            return self.genM_value

    property genMass:
        def __get__(self):
            self.genMass_branch.GetEntry(self.localentry, 0)
            return self.genMass_value

    property genPhi:
        def __get__(self):
            self.genPhi_branch.GetEntry(self.localentry, 0)
            return self.genPhi_value

    property genpT:
        def __get__(self):
            self.genpT_branch.GetEntry(self.localentry, 0)
            return self.genpT_value

    property genpX:
        def __get__(self):
            self.genpX_branch.GetEntry(self.localentry, 0)
            return self.genpX_value

    property genpY:
        def __get__(self):
            self.genpY_branch.GetEntry(self.localentry, 0)
            return self.genpY_value

    property isGtautau:
        def __get__(self):
            self.isGtautau_branch.GetEntry(self.localentry, 0)
            return self.isGtautau_value

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

    property j1csv:
        def __get__(self):
            self.j1csv_branch.GetEntry(self.localentry, 0)
            return self.j1csv_value

    property j1csvWoNoisyJets:
        def __get__(self):
            self.j1csvWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j1csvWoNoisyJets_value

    property j1eta:
        def __get__(self):
            self.j1eta_branch.GetEntry(self.localentry, 0)
            return self.j1eta_value

    property j1etaWoNoisyJets:
        def __get__(self):
            self.j1etaWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j1etaWoNoisyJets_value

    property j1hadronflavor:
        def __get__(self):
            self.j1hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.j1hadronflavor_value

    property j1hadronflavorWoNoisyJets:
        def __get__(self):
            self.j1hadronflavorWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j1hadronflavorWoNoisyJets_value

    property j1phi:
        def __get__(self):
            self.j1phi_branch.GetEntry(self.localentry, 0)
            return self.j1phi_value

    property j1phiWoNoisyJets:
        def __get__(self):
            self.j1phiWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j1phiWoNoisyJets_value

    property j1pt:
        def __get__(self):
            self.j1pt_branch.GetEntry(self.localentry, 0)
            return self.j1pt_value

    property j1ptWoNoisyJets:
        def __get__(self):
            self.j1ptWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_value

    property j1ptWoNoisyJets_JetEC2Down:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEC2Down_value

    property j1ptWoNoisyJets_JetEC2Up:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEC2Up_value

    property j1ptWoNoisyJets_JetEta0to3Down:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEta0to3Down_value

    property j1ptWoNoisyJets_JetEta0to3Up:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEta0to3Up_value

    property j1ptWoNoisyJets_JetEta0to5Down:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEta0to5Down_value

    property j1ptWoNoisyJets_JetEta0to5Up:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEta0to5Up_value

    property j1ptWoNoisyJets_JetEta3to5Down:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEta3to5Down_value

    property j1ptWoNoisyJets_JetEta3to5Up:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEta3to5Up_value

    property j1ptWoNoisyJets_JetRelativeBalDown:
        def __get__(self):
            self.j1ptWoNoisyJets_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetRelativeBalDown_value

    property j1ptWoNoisyJets_JetRelativeBalUp:
        def __get__(self):
            self.j1ptWoNoisyJets_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetRelativeBalUp_value

    property j1ptWoNoisyJets_JetRelativeSampleDown:
        def __get__(self):
            self.j1ptWoNoisyJets_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetRelativeSampleDown_value

    property j1ptWoNoisyJets_JetRelativeSampleUp:
        def __get__(self):
            self.j1ptWoNoisyJets_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetRelativeSampleUp_value

    property j1pt_JetEC2Down:
        def __get__(self):
            self.j1pt_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetEC2Down_value

    property j1pt_JetEC2Up:
        def __get__(self):
            self.j1pt_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetEC2Up_value

    property j1pt_JetEta0to3Down:
        def __get__(self):
            self.j1pt_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetEta0to3Down_value

    property j1pt_JetEta0to3Up:
        def __get__(self):
            self.j1pt_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetEta0to3Up_value

    property j1pt_JetEta0to5Down:
        def __get__(self):
            self.j1pt_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetEta0to5Down_value

    property j1pt_JetEta0to5Up:
        def __get__(self):
            self.j1pt_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetEta0to5Up_value

    property j1pt_JetEta3to5Down:
        def __get__(self):
            self.j1pt_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetEta3to5Down_value

    property j1pt_JetEta3to5Up:
        def __get__(self):
            self.j1pt_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetEta3to5Up_value

    property j1pt_JetRelativeBalDown:
        def __get__(self):
            self.j1pt_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetRelativeBalDown_value

    property j1pt_JetRelativeBalUp:
        def __get__(self):
            self.j1pt_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetRelativeBalUp_value

    property j1pt_JetRelativeSampleDown:
        def __get__(self):
            self.j1pt_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetRelativeSampleDown_value

    property j1pt_JetRelativeSampleUp:
        def __get__(self):
            self.j1pt_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetRelativeSampleUp_value

    property j2csv:
        def __get__(self):
            self.j2csv_branch.GetEntry(self.localentry, 0)
            return self.j2csv_value

    property j2csvWoNoisyJets:
        def __get__(self):
            self.j2csvWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j2csvWoNoisyJets_value

    property j2eta:
        def __get__(self):
            self.j2eta_branch.GetEntry(self.localentry, 0)
            return self.j2eta_value

    property j2etaWoNoisyJets:
        def __get__(self):
            self.j2etaWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j2etaWoNoisyJets_value

    property j2hadronflavor:
        def __get__(self):
            self.j2hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.j2hadronflavor_value

    property j2hadronflavorWoNoisyJets:
        def __get__(self):
            self.j2hadronflavorWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j2hadronflavorWoNoisyJets_value

    property j2phi:
        def __get__(self):
            self.j2phi_branch.GetEntry(self.localentry, 0)
            return self.j2phi_value

    property j2phiWoNoisyJets:
        def __get__(self):
            self.j2phiWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j2phiWoNoisyJets_value

    property j2pt:
        def __get__(self):
            self.j2pt_branch.GetEntry(self.localentry, 0)
            return self.j2pt_value

    property j2ptWoNoisyJets:
        def __get__(self):
            self.j2ptWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_value

    property j2ptWoNoisyJets_JetEC2Down:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEC2Down_value

    property j2ptWoNoisyJets_JetEC2Up:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEC2Up_value

    property j2ptWoNoisyJets_JetEta0to3Down:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEta0to3Down_value

    property j2ptWoNoisyJets_JetEta0to3Up:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEta0to3Up_value

    property j2ptWoNoisyJets_JetEta0to5Down:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEta0to5Down_value

    property j2ptWoNoisyJets_JetEta0to5Up:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEta0to5Up_value

    property j2ptWoNoisyJets_JetEta3to5Down:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEta3to5Down_value

    property j2ptWoNoisyJets_JetEta3to5Up:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEta3to5Up_value

    property j2ptWoNoisyJets_JetRelativeBalDown:
        def __get__(self):
            self.j2ptWoNoisyJets_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetRelativeBalDown_value

    property j2ptWoNoisyJets_JetRelativeBalUp:
        def __get__(self):
            self.j2ptWoNoisyJets_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetRelativeBalUp_value

    property j2ptWoNoisyJets_JetRelativeSampleDown:
        def __get__(self):
            self.j2ptWoNoisyJets_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetRelativeSampleDown_value

    property j2ptWoNoisyJets_JetRelativeSampleUp:
        def __get__(self):
            self.j2ptWoNoisyJets_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetRelativeSampleUp_value

    property j2pt_JetEC2Down:
        def __get__(self):
            self.j2pt_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetEC2Down_value

    property j2pt_JetEC2Up:
        def __get__(self):
            self.j2pt_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetEC2Up_value

    property j2pt_JetEta0to3Down:
        def __get__(self):
            self.j2pt_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetEta0to3Down_value

    property j2pt_JetEta0to3Up:
        def __get__(self):
            self.j2pt_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetEta0to3Up_value

    property j2pt_JetEta0to5Down:
        def __get__(self):
            self.j2pt_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetEta0to5Down_value

    property j2pt_JetEta0to5Up:
        def __get__(self):
            self.j2pt_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetEta0to5Up_value

    property j2pt_JetEta3to5Down:
        def __get__(self):
            self.j2pt_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetEta3to5Down_value

    property j2pt_JetEta3to5Up:
        def __get__(self):
            self.j2pt_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetEta3to5Up_value

    property j2pt_JetRelativeBalDown:
        def __get__(self):
            self.j2pt_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetRelativeBalDown_value

    property j2pt_JetRelativeBalUp:
        def __get__(self):
            self.j2pt_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetRelativeBalUp_value

    property j2pt_JetRelativeSampleDown:
        def __get__(self):
            self.j2pt_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetRelativeSampleDown_value

    property j2pt_JetRelativeSampleUp:
        def __get__(self):
            self.j2pt_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetRelativeSampleUp_value

    property jb1eta_2016:
        def __get__(self):
            self.jb1eta_2016_branch.GetEntry(self.localentry, 0)
            return self.jb1eta_2016_value

    property jb1eta_2017:
        def __get__(self):
            self.jb1eta_2017_branch.GetEntry(self.localentry, 0)
            return self.jb1eta_2017_value

    property jb1eta_2018:
        def __get__(self):
            self.jb1eta_2018_branch.GetEntry(self.localentry, 0)
            return self.jb1eta_2018_value

    property jb1hadronflavor_2016:
        def __get__(self):
            self.jb1hadronflavor_2016_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavor_2016_value

    property jb1hadronflavor_2017:
        def __get__(self):
            self.jb1hadronflavor_2017_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavor_2017_value

    property jb1hadronflavor_2018:
        def __get__(self):
            self.jb1hadronflavor_2018_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavor_2018_value

    property jb1phi_2016:
        def __get__(self):
            self.jb1phi_2016_branch.GetEntry(self.localentry, 0)
            return self.jb1phi_2016_value

    property jb1phi_2017:
        def __get__(self):
            self.jb1phi_2017_branch.GetEntry(self.localentry, 0)
            return self.jb1phi_2017_value

    property jb1phi_2018:
        def __get__(self):
            self.jb1phi_2018_branch.GetEntry(self.localentry, 0)
            return self.jb1phi_2018_value

    property jb1pt_2016:
        def __get__(self):
            self.jb1pt_2016_branch.GetEntry(self.localentry, 0)
            return self.jb1pt_2016_value

    property jb1pt_2017:
        def __get__(self):
            self.jb1pt_2017_branch.GetEntry(self.localentry, 0)
            return self.jb1pt_2017_value

    property jb1pt_2018:
        def __get__(self):
            self.jb1pt_2018_branch.GetEntry(self.localentry, 0)
            return self.jb1pt_2018_value

    property jb2eta_2016:
        def __get__(self):
            self.jb2eta_2016_branch.GetEntry(self.localentry, 0)
            return self.jb2eta_2016_value

    property jb2eta_2017:
        def __get__(self):
            self.jb2eta_2017_branch.GetEntry(self.localentry, 0)
            return self.jb2eta_2017_value

    property jb2eta_2018:
        def __get__(self):
            self.jb2eta_2018_branch.GetEntry(self.localentry, 0)
            return self.jb2eta_2018_value

    property jb2hadronflavor_2016:
        def __get__(self):
            self.jb2hadronflavor_2016_branch.GetEntry(self.localentry, 0)
            return self.jb2hadronflavor_2016_value

    property jb2hadronflavor_2017:
        def __get__(self):
            self.jb2hadronflavor_2017_branch.GetEntry(self.localentry, 0)
            return self.jb2hadronflavor_2017_value

    property jb2hadronflavor_2018:
        def __get__(self):
            self.jb2hadronflavor_2018_branch.GetEntry(self.localentry, 0)
            return self.jb2hadronflavor_2018_value

    property jb2phi_2016:
        def __get__(self):
            self.jb2phi_2016_branch.GetEntry(self.localentry, 0)
            return self.jb2phi_2016_value

    property jb2phi_2017:
        def __get__(self):
            self.jb2phi_2017_branch.GetEntry(self.localentry, 0)
            return self.jb2phi_2017_value

    property jb2phi_2018:
        def __get__(self):
            self.jb2phi_2018_branch.GetEntry(self.localentry, 0)
            return self.jb2phi_2018_value

    property jb2pt_2016:
        def __get__(self):
            self.jb2pt_2016_branch.GetEntry(self.localentry, 0)
            return self.jb2pt_2016_value

    property jb2pt_2017:
        def __get__(self):
            self.jb2pt_2017_branch.GetEntry(self.localentry, 0)
            return self.jb2pt_2017_value

    property jb2pt_2018:
        def __get__(self):
            self.jb2pt_2018_branch.GetEntry(self.localentry, 0)
            return self.jb2pt_2018_value

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

    property jetVeto30WoNoisyJets_JetEC2Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEC2Down_value

    property jetVeto30WoNoisyJets_JetEC2Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEC2Up_value

    property jetVeto30WoNoisyJets_JetEnDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEnDown_value

    property jetVeto30WoNoisyJets_JetEnUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEnUp_value

    property jetVeto30WoNoisyJets_JetEta0to3Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEta0to3Down_value

    property jetVeto30WoNoisyJets_JetEta0to3Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEta0to3Up_value

    property jetVeto30WoNoisyJets_JetEta0to5Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEta0to5Down_value

    property jetVeto30WoNoisyJets_JetEta0to5Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEta0to5Up_value

    property jetVeto30WoNoisyJets_JetEta3to5Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEta3to5Down_value

    property jetVeto30WoNoisyJets_JetEta3to5Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEta3to5Up_value

    property jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_value

    property jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_value

    property jetVeto30WoNoisyJets_JetRelativeSampleDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeSampleDown_value

    property jetVeto30WoNoisyJets_JetRelativeSampleUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeSampleUp_value

    property jetVeto30WoNoisyJets_JetTotalDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetTotalDown_value

    property jetVeto30WoNoisyJets_JetTotalUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetTotalUp_value

    property jetVeto30_JetAbsoluteFlavMapDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteFlavMapDown_value

    property jetVeto30_JetAbsoluteFlavMapUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteFlavMapUp_value

    property jetVeto30_JetAbsoluteMPFBiasDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteMPFBiasDown_value

    property jetVeto30_JetAbsoluteMPFBiasUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteMPFBiasUp_value

    property jetVeto30_JetAbsoluteScaleDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteScaleDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteScaleDown_value

    property jetVeto30_JetAbsoluteScaleUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteScaleUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteScaleUp_value

    property jetVeto30_JetAbsoluteStatDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteStatDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteStatDown_value

    property jetVeto30_JetAbsoluteStatUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteStatUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteStatUp_value

    property jetVeto30_JetClosureDown:
        def __get__(self):
            self.jetVeto30_JetClosureDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetClosureDown_value

    property jetVeto30_JetClosureUp:
        def __get__(self):
            self.jetVeto30_JetClosureUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetClosureUp_value

    property jetVeto30_JetEC2Down:
        def __get__(self):
            self.jetVeto30_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEC2Down_value

    property jetVeto30_JetEC2Up:
        def __get__(self):
            self.jetVeto30_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEC2Up_value

    property jetVeto30_JetEnDown:
        def __get__(self):
            self.jetVeto30_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnDown_value

    property jetVeto30_JetEnUp:
        def __get__(self):
            self.jetVeto30_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnUp_value

    property jetVeto30_JetEta0to3Down:
        def __get__(self):
            self.jetVeto30_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEta0to3Down_value

    property jetVeto30_JetEta0to3Up:
        def __get__(self):
            self.jetVeto30_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEta0to3Up_value

    property jetVeto30_JetEta0to5Down:
        def __get__(self):
            self.jetVeto30_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEta0to5Down_value

    property jetVeto30_JetEta0to5Up:
        def __get__(self):
            self.jetVeto30_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEta0to5Up_value

    property jetVeto30_JetEta3to5Down:
        def __get__(self):
            self.jetVeto30_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEta3to5Down_value

    property jetVeto30_JetEta3to5Up:
        def __get__(self):
            self.jetVeto30_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEta3to5Up_value

    property jetVeto30_JetFlavorQCDDown:
        def __get__(self):
            self.jetVeto30_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFlavorQCDDown_value

    property jetVeto30_JetFlavorQCDUp:
        def __get__(self):
            self.jetVeto30_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFlavorQCDUp_value

    property jetVeto30_JetFragmentationDown:
        def __get__(self):
            self.jetVeto30_JetFragmentationDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFragmentationDown_value

    property jetVeto30_JetFragmentationUp:
        def __get__(self):
            self.jetVeto30_JetFragmentationUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFragmentationUp_value

    property jetVeto30_JetPileUpDataMCDown:
        def __get__(self):
            self.jetVeto30_JetPileUpDataMCDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpDataMCDown_value

    property jetVeto30_JetPileUpDataMCUp:
        def __get__(self):
            self.jetVeto30_JetPileUpDataMCUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpDataMCUp_value

    property jetVeto30_JetPileUpPtBBDown:
        def __get__(self):
            self.jetVeto30_JetPileUpPtBBDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtBBDown_value

    property jetVeto30_JetPileUpPtBBUp:
        def __get__(self):
            self.jetVeto30_JetPileUpPtBBUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtBBUp_value

    property jetVeto30_JetPileUpPtEC1Down:
        def __get__(self):
            self.jetVeto30_JetPileUpPtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtEC1Down_value

    property jetVeto30_JetPileUpPtEC1Up:
        def __get__(self):
            self.jetVeto30_JetPileUpPtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtEC1Up_value

    property jetVeto30_JetPileUpPtEC2Down:
        def __get__(self):
            self.jetVeto30_JetPileUpPtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtEC2Down_value

    property jetVeto30_JetPileUpPtEC2Up:
        def __get__(self):
            self.jetVeto30_JetPileUpPtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtEC2Up_value

    property jetVeto30_JetPileUpPtHFDown:
        def __get__(self):
            self.jetVeto30_JetPileUpPtHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtHFDown_value

    property jetVeto30_JetPileUpPtHFUp:
        def __get__(self):
            self.jetVeto30_JetPileUpPtHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtHFUp_value

    property jetVeto30_JetPileUpPtRefDown:
        def __get__(self):
            self.jetVeto30_JetPileUpPtRefDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtRefDown_value

    property jetVeto30_JetPileUpPtRefUp:
        def __get__(self):
            self.jetVeto30_JetPileUpPtRefUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtRefUp_value

    property jetVeto30_JetRelativeBalDown:
        def __get__(self):
            self.jetVeto30_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeBalDown_value

    property jetVeto30_JetRelativeBalUp:
        def __get__(self):
            self.jetVeto30_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeBalUp_value

    property jetVeto30_JetRelativeFSRDown:
        def __get__(self):
            self.jetVeto30_JetRelativeFSRDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeFSRDown_value

    property jetVeto30_JetRelativeFSRUp:
        def __get__(self):
            self.jetVeto30_JetRelativeFSRUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeFSRUp_value

    property jetVeto30_JetRelativeJEREC1Down:
        def __get__(self):
            self.jetVeto30_JetRelativeJEREC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJEREC1Down_value

    property jetVeto30_JetRelativeJEREC1Up:
        def __get__(self):
            self.jetVeto30_JetRelativeJEREC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJEREC1Up_value

    property jetVeto30_JetRelativeJEREC2Down:
        def __get__(self):
            self.jetVeto30_JetRelativeJEREC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJEREC2Down_value

    property jetVeto30_JetRelativeJEREC2Up:
        def __get__(self):
            self.jetVeto30_JetRelativeJEREC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJEREC2Up_value

    property jetVeto30_JetRelativeJERHFDown:
        def __get__(self):
            self.jetVeto30_JetRelativeJERHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJERHFDown_value

    property jetVeto30_JetRelativeJERHFUp:
        def __get__(self):
            self.jetVeto30_JetRelativeJERHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJERHFUp_value

    property jetVeto30_JetRelativePtBBDown:
        def __get__(self):
            self.jetVeto30_JetRelativePtBBDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtBBDown_value

    property jetVeto30_JetRelativePtBBUp:
        def __get__(self):
            self.jetVeto30_JetRelativePtBBUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtBBUp_value

    property jetVeto30_JetRelativePtEC1Down:
        def __get__(self):
            self.jetVeto30_JetRelativePtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtEC1Down_value

    property jetVeto30_JetRelativePtEC1Up:
        def __get__(self):
            self.jetVeto30_JetRelativePtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtEC1Up_value

    property jetVeto30_JetRelativePtEC2Down:
        def __get__(self):
            self.jetVeto30_JetRelativePtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtEC2Down_value

    property jetVeto30_JetRelativePtEC2Up:
        def __get__(self):
            self.jetVeto30_JetRelativePtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtEC2Up_value

    property jetVeto30_JetRelativePtHFDown:
        def __get__(self):
            self.jetVeto30_JetRelativePtHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtHFDown_value

    property jetVeto30_JetRelativePtHFUp:
        def __get__(self):
            self.jetVeto30_JetRelativePtHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtHFUp_value

    property jetVeto30_JetRelativeSampleDown:
        def __get__(self):
            self.jetVeto30_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeSampleDown_value

    property jetVeto30_JetRelativeSampleUp:
        def __get__(self):
            self.jetVeto30_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeSampleUp_value

    property jetVeto30_JetRelativeStatECDown:
        def __get__(self):
            self.jetVeto30_JetRelativeStatECDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatECDown_value

    property jetVeto30_JetRelativeStatECUp:
        def __get__(self):
            self.jetVeto30_JetRelativeStatECUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatECUp_value

    property jetVeto30_JetRelativeStatFSRDown:
        def __get__(self):
            self.jetVeto30_JetRelativeStatFSRDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatFSRDown_value

    property jetVeto30_JetRelativeStatFSRUp:
        def __get__(self):
            self.jetVeto30_JetRelativeStatFSRUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatFSRUp_value

    property jetVeto30_JetRelativeStatHFDown:
        def __get__(self):
            self.jetVeto30_JetRelativeStatHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatHFDown_value

    property jetVeto30_JetRelativeStatHFUp:
        def __get__(self):
            self.jetVeto30_JetRelativeStatHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatHFUp_value

    property jetVeto30_JetSinglePionECALDown:
        def __get__(self):
            self.jetVeto30_JetSinglePionECALDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSinglePionECALDown_value

    property jetVeto30_JetSinglePionECALUp:
        def __get__(self):
            self.jetVeto30_JetSinglePionECALUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSinglePionECALUp_value

    property jetVeto30_JetSinglePionHCALDown:
        def __get__(self):
            self.jetVeto30_JetSinglePionHCALDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSinglePionHCALDown_value

    property jetVeto30_JetSinglePionHCALUp:
        def __get__(self):
            self.jetVeto30_JetSinglePionHCALUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSinglePionHCALUp_value

    property jetVeto30_JetTimePtEtaDown:
        def __get__(self):
            self.jetVeto30_JetTimePtEtaDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTimePtEtaDown_value

    property jetVeto30_JetTimePtEtaUp:
        def __get__(self):
            self.jetVeto30_JetTimePtEtaUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTimePtEtaUp_value

    property jetVeto30_JetTotalDown:
        def __get__(self):
            self.jetVeto30_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTotalDown_value

    property jetVeto30_JetTotalUp:
        def __get__(self):
            self.jetVeto30_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTotalUp_value

    property lumi:
        def __get__(self):
            self.lumi_branch.GetEntry(self.localentry, 0)
            return self.lumi_value

    property mBestTrackType:
        def __get__(self):
            self.mBestTrackType_branch.GetEntry(self.localentry, 0)
            return self.mBestTrackType_value

    property mCharge:
        def __get__(self):
            self.mCharge_branch.GetEntry(self.localentry, 0)
            return self.mCharge_value

    property mChi2LocalPosition:
        def __get__(self):
            self.mChi2LocalPosition_branch.GetEntry(self.localentry, 0)
            return self.mChi2LocalPosition_value

    property mComesFromHiggs:
        def __get__(self):
            self.mComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.mComesFromHiggs_value

    property mEcalIsoDR03:
        def __get__(self):
            self.mEcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.mEcalIsoDR03_value

    property mEta:
        def __get__(self):
            self.mEta_branch.GetEntry(self.localentry, 0)
            return self.mEta_value

    property mGenCharge:
        def __get__(self):
            self.mGenCharge_branch.GetEntry(self.localentry, 0)
            return self.mGenCharge_value

    property mGenDirectPromptTauDecayFinalState:
        def __get__(self):
            self.mGenDirectPromptTauDecayFinalState_branch.GetEntry(self.localentry, 0)
            return self.mGenDirectPromptTauDecayFinalState_value

    property mGenEnergy:
        def __get__(self):
            self.mGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.mGenEnergy_value

    property mGenEta:
        def __get__(self):
            self.mGenEta_branch.GetEntry(self.localentry, 0)
            return self.mGenEta_value

    property mGenIsPrompt:
        def __get__(self):
            self.mGenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.mGenIsPrompt_value

    property mGenMotherPdgId:
        def __get__(self):
            self.mGenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.mGenMotherPdgId_value

    property mGenParticle:
        def __get__(self):
            self.mGenParticle_branch.GetEntry(self.localentry, 0)
            return self.mGenParticle_value

    property mGenPdgId:
        def __get__(self):
            self.mGenPdgId_branch.GetEntry(self.localentry, 0)
            return self.mGenPdgId_value

    property mGenPhi:
        def __get__(self):
            self.mGenPhi_branch.GetEntry(self.localentry, 0)
            return self.mGenPhi_value

    property mGenPrompt:
        def __get__(self):
            self.mGenPrompt_branch.GetEntry(self.localentry, 0)
            return self.mGenPrompt_value

    property mGenPromptFinalState:
        def __get__(self):
            self.mGenPromptFinalState_branch.GetEntry(self.localentry, 0)
            return self.mGenPromptFinalState_value

    property mGenPromptTauDecay:
        def __get__(self):
            self.mGenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.mGenPromptTauDecay_value

    property mGenPt:
        def __get__(self):
            self.mGenPt_branch.GetEntry(self.localentry, 0)
            return self.mGenPt_value

    property mGenTauDecay:
        def __get__(self):
            self.mGenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.mGenTauDecay_value

    property mGenVZ:
        def __get__(self):
            self.mGenVZ_branch.GetEntry(self.localentry, 0)
            return self.mGenVZ_value

    property mGenVtxPVMatch:
        def __get__(self):
            self.mGenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.mGenVtxPVMatch_value

    property mHcalIsoDR03:
        def __get__(self):
            self.mHcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.mHcalIsoDR03_value

    property mIP3D:
        def __get__(self):
            self.mIP3D_branch.GetEntry(self.localentry, 0)
            return self.mIP3D_value

    property mIP3DErr:
        def __get__(self):
            self.mIP3DErr_branch.GetEntry(self.localentry, 0)
            return self.mIP3DErr_value

    property mIsGlobal:
        def __get__(self):
            self.mIsGlobal_branch.GetEntry(self.localentry, 0)
            return self.mIsGlobal_value

    property mIsPFMuon:
        def __get__(self):
            self.mIsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.mIsPFMuon_value

    property mIsTracker:
        def __get__(self):
            self.mIsTracker_branch.GetEntry(self.localentry, 0)
            return self.mIsTracker_value

    property mIsoDB03:
        def __get__(self):
            self.mIsoDB03_branch.GetEntry(self.localentry, 0)
            return self.mIsoDB03_value

    property mIsoDB04:
        def __get__(self):
            self.mIsoDB04_branch.GetEntry(self.localentry, 0)
            return self.mIsoDB04_value

    property mJetArea:
        def __get__(self):
            self.mJetArea_branch.GetEntry(self.localentry, 0)
            return self.mJetArea_value

    property mJetBtag:
        def __get__(self):
            self.mJetBtag_branch.GetEntry(self.localentry, 0)
            return self.mJetBtag_value

    property mJetDR:
        def __get__(self):
            self.mJetDR_branch.GetEntry(self.localentry, 0)
            return self.mJetDR_value

    property mJetEtaEtaMoment:
        def __get__(self):
            self.mJetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.mJetEtaEtaMoment_value

    property mJetEtaPhiMoment:
        def __get__(self):
            self.mJetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.mJetEtaPhiMoment_value

    property mJetEtaPhiSpread:
        def __get__(self):
            self.mJetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.mJetEtaPhiSpread_value

    property mJetHadronFlavour:
        def __get__(self):
            self.mJetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.mJetHadronFlavour_value

    property mJetPFCISVBtag:
        def __get__(self):
            self.mJetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.mJetPFCISVBtag_value

    property mJetPartonFlavour:
        def __get__(self):
            self.mJetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.mJetPartonFlavour_value

    property mJetPhiPhiMoment:
        def __get__(self):
            self.mJetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.mJetPhiPhiMoment_value

    property mJetPt:
        def __get__(self):
            self.mJetPt_branch.GetEntry(self.localentry, 0)
            return self.mJetPt_value

    property mLowestMll:
        def __get__(self):
            self.mLowestMll_branch.GetEntry(self.localentry, 0)
            return self.mLowestMll_value

    property mMass:
        def __get__(self):
            self.mMass_branch.GetEntry(self.localentry, 0)
            return self.mMass_value

    property mMatchEmbeddedFilterMu19Tau20_2016:
        def __get__(self):
            self.mMatchEmbeddedFilterMu19Tau20_2016_branch.GetEntry(self.localentry, 0)
            return self.mMatchEmbeddedFilterMu19Tau20_2016_value

    property mMatchEmbeddedFilterMu20Tau27_2017:
        def __get__(self):
            self.mMatchEmbeddedFilterMu20Tau27_2017_branch.GetEntry(self.localentry, 0)
            return self.mMatchEmbeddedFilterMu20Tau27_2017_value

    property mMatchEmbeddedFilterMu20Tau27_2018:
        def __get__(self):
            self.mMatchEmbeddedFilterMu20Tau27_2018_branch.GetEntry(self.localentry, 0)
            return self.mMatchEmbeddedFilterMu20Tau27_2018_value

    property mMatchEmbeddedFilterMu24:
        def __get__(self):
            self.mMatchEmbeddedFilterMu24_branch.GetEntry(self.localentry, 0)
            return self.mMatchEmbeddedFilterMu24_value

    property mMatchEmbeddedFilterMu27:
        def __get__(self):
            self.mMatchEmbeddedFilterMu27_branch.GetEntry(self.localentry, 0)
            return self.mMatchEmbeddedFilterMu27_value

    property mMatchedStations:
        def __get__(self):
            self.mMatchedStations_branch.GetEntry(self.localentry, 0)
            return self.mMatchedStations_value

    property mMatchesIsoMu19Tau20Filter:
        def __get__(self):
            self.mMatchesIsoMu19Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu19Tau20Filter_value

    property mMatchesIsoMu19Tau20Path:
        def __get__(self):
            self.mMatchesIsoMu19Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu19Tau20Path_value

    property mMatchesIsoMu19Tau20SingleL1Filter:
        def __get__(self):
            self.mMatchesIsoMu19Tau20SingleL1Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu19Tau20SingleL1Filter_value

    property mMatchesIsoMu19Tau20SingleL1Path:
        def __get__(self):
            self.mMatchesIsoMu19Tau20SingleL1Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu19Tau20SingleL1Path_value

    property mMatchesIsoMu20HPSTau27Filter:
        def __get__(self):
            self.mMatchesIsoMu20HPSTau27Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu20HPSTau27Filter_value

    property mMatchesIsoMu20HPSTau27Path:
        def __get__(self):
            self.mMatchesIsoMu20HPSTau27Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu20HPSTau27Path_value

    property mMatchesIsoMu20Tau27Filter:
        def __get__(self):
            self.mMatchesIsoMu20Tau27Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu20Tau27Filter_value

    property mMatchesIsoMu20Tau27Path:
        def __get__(self):
            self.mMatchesIsoMu20Tau27Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu20Tau27Path_value

    property mMatchesIsoMu24Filter:
        def __get__(self):
            self.mMatchesIsoMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu24Filter_value

    property mMatchesIsoMu24Path:
        def __get__(self):
            self.mMatchesIsoMu24Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu24Path_value

    property mMatchesIsoMu27Filter:
        def __get__(self):
            self.mMatchesIsoMu27Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu27Filter_value

    property mMatchesIsoMu27Path:
        def __get__(self):
            self.mMatchesIsoMu27Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu27Path_value

    property mMatchesMu23e12DZFilter:
        def __get__(self):
            self.mMatchesMu23e12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu23e12DZFilter_value

    property mMatchesMu23e12DZPath:
        def __get__(self):
            self.mMatchesMu23e12DZPath_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu23e12DZPath_value

    property mMatchesMu23e12Filter:
        def __get__(self):
            self.mMatchesMu23e12Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu23e12Filter_value

    property mMatchesMu23e12Path:
        def __get__(self):
            self.mMatchesMu23e12Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu23e12Path_value

    property mMatchesMu8e23DZFilter:
        def __get__(self):
            self.mMatchesMu8e23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu8e23DZFilter_value

    property mMatchesMu8e23DZPath:
        def __get__(self):
            self.mMatchesMu8e23DZPath_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu8e23DZPath_value

    property mMatchesMu8e23Filter:
        def __get__(self):
            self.mMatchesMu8e23Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu8e23Filter_value

    property mMatchesMu8e23Path:
        def __get__(self):
            self.mMatchesMu8e23Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu8e23Path_value

    property mMiniIsoLoose:
        def __get__(self):
            self.mMiniIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.mMiniIsoLoose_value

    property mMiniIsoMedium:
        def __get__(self):
            self.mMiniIsoMedium_branch.GetEntry(self.localentry, 0)
            return self.mMiniIsoMedium_value

    property mMiniIsoTight:
        def __get__(self):
            self.mMiniIsoTight_branch.GetEntry(self.localentry, 0)
            return self.mMiniIsoTight_value

    property mMiniIsoVeryTight:
        def __get__(self):
            self.mMiniIsoVeryTight_branch.GetEntry(self.localentry, 0)
            return self.mMiniIsoVeryTight_value

    property mMuonHits:
        def __get__(self):
            self.mMuonHits_branch.GetEntry(self.localentry, 0)
            return self.mMuonHits_value

    property mMvaLoose:
        def __get__(self):
            self.mMvaLoose_branch.GetEntry(self.localentry, 0)
            return self.mMvaLoose_value

    property mMvaMedium:
        def __get__(self):
            self.mMvaMedium_branch.GetEntry(self.localentry, 0)
            return self.mMvaMedium_value

    property mMvaTight:
        def __get__(self):
            self.mMvaTight_branch.GetEntry(self.localentry, 0)
            return self.mMvaTight_value

    property mNearestZMass:
        def __get__(self):
            self.mNearestZMass_branch.GetEntry(self.localentry, 0)
            return self.mNearestZMass_value

    property mNormTrkChi2:
        def __get__(self):
            self.mNormTrkChi2_branch.GetEntry(self.localentry, 0)
            return self.mNormTrkChi2_value

    property mNormalizedChi2:
        def __get__(self):
            self.mNormalizedChi2_branch.GetEntry(self.localentry, 0)
            return self.mNormalizedChi2_value

    property mPFChargedHadronIsoR04:
        def __get__(self):
            self.mPFChargedHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.mPFChargedHadronIsoR04_value

    property mPFChargedIso:
        def __get__(self):
            self.mPFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.mPFChargedIso_value

    property mPFIDLoose:
        def __get__(self):
            self.mPFIDLoose_branch.GetEntry(self.localentry, 0)
            return self.mPFIDLoose_value

    property mPFIDMedium:
        def __get__(self):
            self.mPFIDMedium_branch.GetEntry(self.localentry, 0)
            return self.mPFIDMedium_value

    property mPFIDTight:
        def __get__(self):
            self.mPFIDTight_branch.GetEntry(self.localentry, 0)
            return self.mPFIDTight_value

    property mPFIsoLoose:
        def __get__(self):
            self.mPFIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.mPFIsoLoose_value

    property mPFIsoMedium:
        def __get__(self):
            self.mPFIsoMedium_branch.GetEntry(self.localentry, 0)
            return self.mPFIsoMedium_value

    property mPFIsoTight:
        def __get__(self):
            self.mPFIsoTight_branch.GetEntry(self.localentry, 0)
            return self.mPFIsoTight_value

    property mPFNeutralHadronIsoR04:
        def __get__(self):
            self.mPFNeutralHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.mPFNeutralHadronIsoR04_value

    property mPFNeutralIso:
        def __get__(self):
            self.mPFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.mPFNeutralIso_value

    property mPFPUChargedIso:
        def __get__(self):
            self.mPFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.mPFPUChargedIso_value

    property mPFPhotonIso:
        def __get__(self):
            self.mPFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.mPFPhotonIso_value

    property mPFPhotonIsoR04:
        def __get__(self):
            self.mPFPhotonIsoR04_branch.GetEntry(self.localentry, 0)
            return self.mPFPhotonIsoR04_value

    property mPFPileupIsoR04:
        def __get__(self):
            self.mPFPileupIsoR04_branch.GetEntry(self.localentry, 0)
            return self.mPFPileupIsoR04_value

    property mPVDXY:
        def __get__(self):
            self.mPVDXY_branch.GetEntry(self.localentry, 0)
            return self.mPVDXY_value

    property mPVDZ:
        def __get__(self):
            self.mPVDZ_branch.GetEntry(self.localentry, 0)
            return self.mPVDZ_value

    property mPhi:
        def __get__(self):
            self.mPhi_branch.GetEntry(self.localentry, 0)
            return self.mPhi_value

    property mPixHits:
        def __get__(self):
            self.mPixHits_branch.GetEntry(self.localentry, 0)
            return self.mPixHits_value

    property mPt:
        def __get__(self):
            self.mPt_branch.GetEntry(self.localentry, 0)
            return self.mPt_value

    property mRelPFIsoDBDefault:
        def __get__(self):
            self.mRelPFIsoDBDefault_branch.GetEntry(self.localentry, 0)
            return self.mRelPFIsoDBDefault_value

    property mRelPFIsoDBDefaultR04:
        def __get__(self):
            self.mRelPFIsoDBDefaultR04_branch.GetEntry(self.localentry, 0)
            return self.mRelPFIsoDBDefaultR04_value

    property mRelPFIsoRho:
        def __get__(self):
            self.mRelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.mRelPFIsoRho_value

    property mRho:
        def __get__(self):
            self.mRho_branch.GetEntry(self.localentry, 0)
            return self.mRho_value

    property mSIP2D:
        def __get__(self):
            self.mSIP2D_branch.GetEntry(self.localentry, 0)
            return self.mSIP2D_value

    property mSIP3D:
        def __get__(self):
            self.mSIP3D_branch.GetEntry(self.localentry, 0)
            return self.mSIP3D_value

    property mSegmentCompatibility:
        def __get__(self):
            self.mSegmentCompatibility_branch.GetEntry(self.localentry, 0)
            return self.mSegmentCompatibility_value

    property mTkLayersWithMeasurement:
        def __get__(self):
            self.mTkLayersWithMeasurement_branch.GetEntry(self.localentry, 0)
            return self.mTkLayersWithMeasurement_value

    property mTrkIsoDR03:
        def __get__(self):
            self.mTrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.mTrkIsoDR03_value

    property mTrkKink:
        def __get__(self):
            self.mTrkKink_branch.GetEntry(self.localentry, 0)
            return self.mTrkKink_value

    property mTypeCode:
        def __get__(self):
            self.mTypeCode_branch.GetEntry(self.localentry, 0)
            return self.mTypeCode_value

    property mVZ:
        def __get__(self):
            self.mVZ_branch.GetEntry(self.localentry, 0)
            return self.mVZ_value

    property mValidFraction:
        def __get__(self):
            self.mValidFraction_branch.GetEntry(self.localentry, 0)
            return self.mValidFraction_value

    property mZTTGenMatching:
        def __get__(self):
            self.mZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.mZTTGenMatching_value

    property metSig:
        def __get__(self):
            self.metSig_branch.GetEntry(self.localentry, 0)
            return self.metSig_value

    property metcov00:
        def __get__(self):
            self.metcov00_branch.GetEntry(self.localentry, 0)
            return self.metcov00_value

    property metcov01:
        def __get__(self):
            self.metcov01_branch.GetEntry(self.localentry, 0)
            return self.metcov01_value

    property metcov10:
        def __get__(self):
            self.metcov10_branch.GetEntry(self.localentry, 0)
            return self.metcov10_value

    property metcov11:
        def __get__(self):
            self.metcov11_branch.GetEntry(self.localentry, 0)
            return self.metcov11_value

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

    property muVetoZTTp001dxyz:
        def __get__(self):
            self.muVetoZTTp001dxyz_branch.GetEntry(self.localentry, 0)
            return self.muVetoZTTp001dxyz_value

    property nTruePU:
        def __get__(self):
            self.nTruePU_branch.GetEntry(self.localentry, 0)
            return self.nTruePU_value

    property npNLO:
        def __get__(self):
            self.npNLO_branch.GetEntry(self.localentry, 0)
            return self.npNLO_value

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

    property prefiring_weight_down:
        def __get__(self):
            self.prefiring_weight_down_branch.GetEntry(self.localentry, 0)
            return self.prefiring_weight_down_value

    property prefiring_weight_up:
        def __get__(self):
            self.prefiring_weight_up_branch.GetEntry(self.localentry, 0)
            return self.prefiring_weight_up_value

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

    property topQuarkPt1:
        def __get__(self):
            self.topQuarkPt1_branch.GetEntry(self.localentry, 0)
            return self.topQuarkPt1_value

    property topQuarkPt2:
        def __get__(self):
            self.topQuarkPt2_branch.GetEntry(self.localentry, 0)
            return self.topQuarkPt2_value

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

    property type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_value

    property type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_value

    property type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_value

    property type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_value

    property type1_pfMet_shiftedPhi_JetAbsoluteScaleDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_value

    property type1_pfMet_shiftedPhi_JetAbsoluteScaleUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_value

    property type1_pfMet_shiftedPhi_JetAbsoluteStatDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_value

    property type1_pfMet_shiftedPhi_JetAbsoluteStatUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_value

    property type1_pfMet_shiftedPhi_JetClosureDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetClosureDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetClosureDown_value

    property type1_pfMet_shiftedPhi_JetClosureUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetClosureUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetClosureUp_value

    property type1_pfMet_shiftedPhi_JetEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEC2Down_value

    property type1_pfMet_shiftedPhi_JetEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEC2Up_value

    property type1_pfMet_shiftedPhi_JetEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEnDown_value

    property type1_pfMet_shiftedPhi_JetEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEnUp_value

    property type1_pfMet_shiftedPhi_JetEta0to3Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEta0to3Down_value

    property type1_pfMet_shiftedPhi_JetEta0to3Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEta0to3Up_value

    property type1_pfMet_shiftedPhi_JetEta0to5Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEta0to5Down_value

    property type1_pfMet_shiftedPhi_JetEta0to5Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEta0to5Up_value

    property type1_pfMet_shiftedPhi_JetEta3to5Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEta3to5Down_value

    property type1_pfMet_shiftedPhi_JetEta3to5Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEta3to5Up_value

    property type1_pfMet_shiftedPhi_JetFlavorQCDDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_value

    property type1_pfMet_shiftedPhi_JetFlavorQCDUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_value

    property type1_pfMet_shiftedPhi_JetFragmentationDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetFragmentationDown_value

    property type1_pfMet_shiftedPhi_JetFragmentationUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetFragmentationUp_value

    property type1_pfMet_shiftedPhi_JetPileUpDataMCDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_value

    property type1_pfMet_shiftedPhi_JetPileUpDataMCUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_value

    property type1_pfMet_shiftedPhi_JetPileUpPtBBDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_value

    property type1_pfMet_shiftedPhi_JetPileUpPtBBUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_value

    property type1_pfMet_shiftedPhi_JetPileUpPtEC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_value

    property type1_pfMet_shiftedPhi_JetPileUpPtEC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_value

    property type1_pfMet_shiftedPhi_JetPileUpPtEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_value

    property type1_pfMet_shiftedPhi_JetPileUpPtEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_value

    property type1_pfMet_shiftedPhi_JetPileUpPtHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_value

    property type1_pfMet_shiftedPhi_JetPileUpPtHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_value

    property type1_pfMet_shiftedPhi_JetPileUpPtRefDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_value

    property type1_pfMet_shiftedPhi_JetPileUpPtRefUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_value

    property type1_pfMet_shiftedPhi_JetRelativeBalDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeBalDown_value

    property type1_pfMet_shiftedPhi_JetRelativeBalUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeBalUp_value

    property type1_pfMet_shiftedPhi_JetRelativeFSRDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_value

    property type1_pfMet_shiftedPhi_JetRelativeFSRUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_value

    property type1_pfMet_shiftedPhi_JetRelativeJEREC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_value

    property type1_pfMet_shiftedPhi_JetRelativeJEREC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_value

    property type1_pfMet_shiftedPhi_JetRelativeJEREC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_value

    property type1_pfMet_shiftedPhi_JetRelativeJEREC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_value

    property type1_pfMet_shiftedPhi_JetRelativeJERHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_value

    property type1_pfMet_shiftedPhi_JetRelativeJERHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_value

    property type1_pfMet_shiftedPhi_JetRelativePtBBDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_value

    property type1_pfMet_shiftedPhi_JetRelativePtBBUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_value

    property type1_pfMet_shiftedPhi_JetRelativePtEC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_value

    property type1_pfMet_shiftedPhi_JetRelativePtEC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_value

    property type1_pfMet_shiftedPhi_JetRelativePtEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_value

    property type1_pfMet_shiftedPhi_JetRelativePtEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_value

    property type1_pfMet_shiftedPhi_JetRelativePtHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_value

    property type1_pfMet_shiftedPhi_JetRelativePtHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_value

    property type1_pfMet_shiftedPhi_JetRelativeSampleDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_value

    property type1_pfMet_shiftedPhi_JetRelativeSampleUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_value

    property type1_pfMet_shiftedPhi_JetRelativeStatECDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_value

    property type1_pfMet_shiftedPhi_JetRelativeStatECUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_value

    property type1_pfMet_shiftedPhi_JetRelativeStatFSRDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_value

    property type1_pfMet_shiftedPhi_JetRelativeStatFSRUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_value

    property type1_pfMet_shiftedPhi_JetRelativeStatHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_value

    property type1_pfMet_shiftedPhi_JetRelativeStatHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_value

    property type1_pfMet_shiftedPhi_JetResDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetResDown_value

    property type1_pfMet_shiftedPhi_JetResUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetResUp_value

    property type1_pfMet_shiftedPhi_JetSinglePionECALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_value

    property type1_pfMet_shiftedPhi_JetSinglePionECALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_value

    property type1_pfMet_shiftedPhi_JetSinglePionHCALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_value

    property type1_pfMet_shiftedPhi_JetSinglePionHCALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_value

    property type1_pfMet_shiftedPhi_JetTimePtEtaDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_value

    property type1_pfMet_shiftedPhi_JetTimePtEtaUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_value

    property type1_pfMet_shiftedPhi_JetTotalDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetTotalDown_value

    property type1_pfMet_shiftedPhi_JetTotalUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetTotalUp_value

    property type1_pfMet_shiftedPhi_UesCHARGEDDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesCHARGEDDown_value

    property type1_pfMet_shiftedPhi_UesCHARGEDUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesCHARGEDUp_value

    property type1_pfMet_shiftedPhi_UesECALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesECALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesECALDown_value

    property type1_pfMet_shiftedPhi_UesECALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesECALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesECALUp_value

    property type1_pfMet_shiftedPhi_UesHCALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesHCALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesHCALDown_value

    property type1_pfMet_shiftedPhi_UesHCALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesHCALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesHCALUp_value

    property type1_pfMet_shiftedPhi_UesHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesHFDown_value

    property type1_pfMet_shiftedPhi_UesHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesHFUp_value

    property type1_pfMet_shiftedPhi_UnclusteredEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UnclusteredEnDown_value

    property type1_pfMet_shiftedPhi_UnclusteredEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UnclusteredEnUp_value

    property type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_value

    property type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_value

    property type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_value

    property type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_value

    property type1_pfMet_shiftedPt_JetAbsoluteScaleDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_value

    property type1_pfMet_shiftedPt_JetAbsoluteScaleUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_value

    property type1_pfMet_shiftedPt_JetAbsoluteStatDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_value

    property type1_pfMet_shiftedPt_JetAbsoluteStatUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_value

    property type1_pfMet_shiftedPt_JetClosureDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetClosureDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetClosureDown_value

    property type1_pfMet_shiftedPt_JetClosureUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetClosureUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetClosureUp_value

    property type1_pfMet_shiftedPt_JetEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEC2Down_value

    property type1_pfMet_shiftedPt_JetEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEC2Up_value

    property type1_pfMet_shiftedPt_JetEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEnDown_value

    property type1_pfMet_shiftedPt_JetEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEnUp_value

    property type1_pfMet_shiftedPt_JetEta0to3Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEta0to3Down_value

    property type1_pfMet_shiftedPt_JetEta0to3Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEta0to3Up_value

    property type1_pfMet_shiftedPt_JetEta0to5Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEta0to5Down_value

    property type1_pfMet_shiftedPt_JetEta0to5Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEta0to5Up_value

    property type1_pfMet_shiftedPt_JetEta3to5Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEta3to5Down_value

    property type1_pfMet_shiftedPt_JetEta3to5Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEta3to5Up_value

    property type1_pfMet_shiftedPt_JetFlavorQCDDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetFlavorQCDDown_value

    property type1_pfMet_shiftedPt_JetFlavorQCDUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetFlavorQCDUp_value

    property type1_pfMet_shiftedPt_JetFragmentationDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetFragmentationDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetFragmentationDown_value

    property type1_pfMet_shiftedPt_JetFragmentationUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetFragmentationUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetFragmentationUp_value

    property type1_pfMet_shiftedPt_JetPileUpDataMCDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_value

    property type1_pfMet_shiftedPt_JetPileUpDataMCUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_value

    property type1_pfMet_shiftedPt_JetPileUpPtBBDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_value

    property type1_pfMet_shiftedPt_JetPileUpPtBBUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_value

    property type1_pfMet_shiftedPt_JetPileUpPtEC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_value

    property type1_pfMet_shiftedPt_JetPileUpPtEC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_value

    property type1_pfMet_shiftedPt_JetPileUpPtEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_value

    property type1_pfMet_shiftedPt_JetPileUpPtEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_value

    property type1_pfMet_shiftedPt_JetPileUpPtHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_value

    property type1_pfMet_shiftedPt_JetPileUpPtHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_value

    property type1_pfMet_shiftedPt_JetPileUpPtRefDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_value

    property type1_pfMet_shiftedPt_JetPileUpPtRefUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_value

    property type1_pfMet_shiftedPt_JetRelativeBalDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeBalDown_value

    property type1_pfMet_shiftedPt_JetRelativeBalUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeBalUp_value

    property type1_pfMet_shiftedPt_JetRelativeFSRDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeFSRDown_value

    property type1_pfMet_shiftedPt_JetRelativeFSRUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeFSRUp_value

    property type1_pfMet_shiftedPt_JetRelativeJEREC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_value

    property type1_pfMet_shiftedPt_JetRelativeJEREC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_value

    property type1_pfMet_shiftedPt_JetRelativeJEREC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_value

    property type1_pfMet_shiftedPt_JetRelativeJEREC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_value

    property type1_pfMet_shiftedPt_JetRelativeJERHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_value

    property type1_pfMet_shiftedPt_JetRelativeJERHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_value

    property type1_pfMet_shiftedPt_JetRelativePtBBDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtBBDown_value

    property type1_pfMet_shiftedPt_JetRelativePtBBUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtBBUp_value

    property type1_pfMet_shiftedPt_JetRelativePtEC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_value

    property type1_pfMet_shiftedPt_JetRelativePtEC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_value

    property type1_pfMet_shiftedPt_JetRelativePtEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_value

    property type1_pfMet_shiftedPt_JetRelativePtEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_value

    property type1_pfMet_shiftedPt_JetRelativePtHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtHFDown_value

    property type1_pfMet_shiftedPt_JetRelativePtHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtHFUp_value

    property type1_pfMet_shiftedPt_JetRelativeSampleDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeSampleDown_value

    property type1_pfMet_shiftedPt_JetRelativeSampleUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeSampleUp_value

    property type1_pfMet_shiftedPt_JetRelativeStatECDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeStatECDown_value

    property type1_pfMet_shiftedPt_JetRelativeStatECUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeStatECUp_value

    property type1_pfMet_shiftedPt_JetRelativeStatFSRDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_value

    property type1_pfMet_shiftedPt_JetRelativeStatFSRUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_value

    property type1_pfMet_shiftedPt_JetRelativeStatHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_value

    property type1_pfMet_shiftedPt_JetRelativeStatHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_value

    property type1_pfMet_shiftedPt_JetResDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetResDown_value

    property type1_pfMet_shiftedPt_JetResUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetResUp_value

    property type1_pfMet_shiftedPt_JetSinglePionECALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetSinglePionECALDown_value

    property type1_pfMet_shiftedPt_JetSinglePionECALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetSinglePionECALUp_value

    property type1_pfMet_shiftedPt_JetSinglePionHCALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_value

    property type1_pfMet_shiftedPt_JetSinglePionHCALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_value

    property type1_pfMet_shiftedPt_JetTimePtEtaDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetTimePtEtaDown_value

    property type1_pfMet_shiftedPt_JetTimePtEtaUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetTimePtEtaUp_value

    property type1_pfMet_shiftedPt_JetTotalDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetTotalDown_value

    property type1_pfMet_shiftedPt_JetTotalUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetTotalUp_value

    property type1_pfMet_shiftedPt_UesCHARGEDDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesCHARGEDDown_value

    property type1_pfMet_shiftedPt_UesCHARGEDUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesCHARGEDUp_value

    property type1_pfMet_shiftedPt_UesECALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesECALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesECALDown_value

    property type1_pfMet_shiftedPt_UesECALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesECALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesECALUp_value

    property type1_pfMet_shiftedPt_UesHCALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesHCALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesHCALDown_value

    property type1_pfMet_shiftedPt_UesHCALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesHCALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesHCALUp_value

    property type1_pfMet_shiftedPt_UesHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesHFDown_value

    property type1_pfMet_shiftedPt_UesHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesHFUp_value

    property type1_pfMet_shiftedPt_UnclusteredEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UnclusteredEnDown_value

    property type1_pfMet_shiftedPt_UnclusteredEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UnclusteredEnUp_value

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

    property vbfMassWoNoisyJets_JetEC2Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEC2Down_value

    property vbfMassWoNoisyJets_JetEC2Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEC2Up_value

    property vbfMassWoNoisyJets_JetEta0to3Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEta0to3Down_value

    property vbfMassWoNoisyJets_JetEta0to3Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEta0to3Up_value

    property vbfMassWoNoisyJets_JetEta0to5Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEta0to5Down_value

    property vbfMassWoNoisyJets_JetEta0to5Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEta0to5Up_value

    property vbfMassWoNoisyJets_JetEta3to5Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEta3to5Down_value

    property vbfMassWoNoisyJets_JetEta3to5Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEta3to5Up_value

    property vbfMassWoNoisyJets_JetRelativeBalDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeBalDown_value

    property vbfMassWoNoisyJets_JetRelativeBalUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeBalUp_value

    property vbfMassWoNoisyJets_JetRelativeSampleDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeSampleDown_value

    property vbfMassWoNoisyJets_JetRelativeSampleUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeSampleUp_value

    property vbfMassWoNoisyJets_JetTotalDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetTotalDown_value

    property vbfMassWoNoisyJets_JetTotalUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetTotalUp_value

    property vbfMass_JetAbsoluteFlavMapDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteFlavMapDown_value

    property vbfMass_JetAbsoluteFlavMapUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteFlavMapUp_value

    property vbfMass_JetAbsoluteMPFBiasDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteMPFBiasDown_value

    property vbfMass_JetAbsoluteMPFBiasUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteMPFBiasUp_value

    property vbfMass_JetAbsoluteScaleDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteScaleDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteScaleDown_value

    property vbfMass_JetAbsoluteScaleUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteScaleUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteScaleUp_value

    property vbfMass_JetAbsoluteStatDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteStatDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteStatDown_value

    property vbfMass_JetAbsoluteStatUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteStatUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteStatUp_value

    property vbfMass_JetClosureDown:
        def __get__(self):
            self.vbfMass_JetClosureDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetClosureDown_value

    property vbfMass_JetClosureUp:
        def __get__(self):
            self.vbfMass_JetClosureUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetClosureUp_value

    property vbfMass_JetEC2Down:
        def __get__(self):
            self.vbfMass_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEC2Down_value

    property vbfMass_JetEC2Up:
        def __get__(self):
            self.vbfMass_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEC2Up_value

    property vbfMass_JetEta0to3Down:
        def __get__(self):
            self.vbfMass_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEta0to3Down_value

    property vbfMass_JetEta0to3Up:
        def __get__(self):
            self.vbfMass_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEta0to3Up_value

    property vbfMass_JetEta0to5Down:
        def __get__(self):
            self.vbfMass_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEta0to5Down_value

    property vbfMass_JetEta0to5Up:
        def __get__(self):
            self.vbfMass_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEta0to5Up_value

    property vbfMass_JetEta3to5Down:
        def __get__(self):
            self.vbfMass_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEta3to5Down_value

    property vbfMass_JetEta3to5Up:
        def __get__(self):
            self.vbfMass_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEta3to5Up_value

    property vbfMass_JetFlavorQCDDown:
        def __get__(self):
            self.vbfMass_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFlavorQCDDown_value

    property vbfMass_JetFlavorQCDUp:
        def __get__(self):
            self.vbfMass_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFlavorQCDUp_value

    property vbfMass_JetFragmentationDown:
        def __get__(self):
            self.vbfMass_JetFragmentationDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFragmentationDown_value

    property vbfMass_JetFragmentationUp:
        def __get__(self):
            self.vbfMass_JetFragmentationUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFragmentationUp_value

    property vbfMass_JetPileUpDataMCDown:
        def __get__(self):
            self.vbfMass_JetPileUpDataMCDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpDataMCDown_value

    property vbfMass_JetPileUpDataMCUp:
        def __get__(self):
            self.vbfMass_JetPileUpDataMCUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpDataMCUp_value

    property vbfMass_JetPileUpPtBBDown:
        def __get__(self):
            self.vbfMass_JetPileUpPtBBDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtBBDown_value

    property vbfMass_JetPileUpPtBBUp:
        def __get__(self):
            self.vbfMass_JetPileUpPtBBUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtBBUp_value

    property vbfMass_JetPileUpPtEC1Down:
        def __get__(self):
            self.vbfMass_JetPileUpPtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtEC1Down_value

    property vbfMass_JetPileUpPtEC1Up:
        def __get__(self):
            self.vbfMass_JetPileUpPtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtEC1Up_value

    property vbfMass_JetPileUpPtEC2Down:
        def __get__(self):
            self.vbfMass_JetPileUpPtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtEC2Down_value

    property vbfMass_JetPileUpPtEC2Up:
        def __get__(self):
            self.vbfMass_JetPileUpPtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtEC2Up_value

    property vbfMass_JetPileUpPtHFDown:
        def __get__(self):
            self.vbfMass_JetPileUpPtHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtHFDown_value

    property vbfMass_JetPileUpPtHFUp:
        def __get__(self):
            self.vbfMass_JetPileUpPtHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtHFUp_value

    property vbfMass_JetPileUpPtRefDown:
        def __get__(self):
            self.vbfMass_JetPileUpPtRefDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtRefDown_value

    property vbfMass_JetPileUpPtRefUp:
        def __get__(self):
            self.vbfMass_JetPileUpPtRefUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtRefUp_value

    property vbfMass_JetRelativeBalDown:
        def __get__(self):
            self.vbfMass_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeBalDown_value

    property vbfMass_JetRelativeBalUp:
        def __get__(self):
            self.vbfMass_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeBalUp_value

    property vbfMass_JetRelativeFSRDown:
        def __get__(self):
            self.vbfMass_JetRelativeFSRDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeFSRDown_value

    property vbfMass_JetRelativeFSRUp:
        def __get__(self):
            self.vbfMass_JetRelativeFSRUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeFSRUp_value

    property vbfMass_JetRelativeJEREC1Down:
        def __get__(self):
            self.vbfMass_JetRelativeJEREC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJEREC1Down_value

    property vbfMass_JetRelativeJEREC1Up:
        def __get__(self):
            self.vbfMass_JetRelativeJEREC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJEREC1Up_value

    property vbfMass_JetRelativeJEREC2Down:
        def __get__(self):
            self.vbfMass_JetRelativeJEREC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJEREC2Down_value

    property vbfMass_JetRelativeJEREC2Up:
        def __get__(self):
            self.vbfMass_JetRelativeJEREC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJEREC2Up_value

    property vbfMass_JetRelativeJERHFDown:
        def __get__(self):
            self.vbfMass_JetRelativeJERHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJERHFDown_value

    property vbfMass_JetRelativeJERHFUp:
        def __get__(self):
            self.vbfMass_JetRelativeJERHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJERHFUp_value

    property vbfMass_JetRelativePtBBDown:
        def __get__(self):
            self.vbfMass_JetRelativePtBBDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtBBDown_value

    property vbfMass_JetRelativePtBBUp:
        def __get__(self):
            self.vbfMass_JetRelativePtBBUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtBBUp_value

    property vbfMass_JetRelativePtEC1Down:
        def __get__(self):
            self.vbfMass_JetRelativePtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtEC1Down_value

    property vbfMass_JetRelativePtEC1Up:
        def __get__(self):
            self.vbfMass_JetRelativePtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtEC1Up_value

    property vbfMass_JetRelativePtEC2Down:
        def __get__(self):
            self.vbfMass_JetRelativePtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtEC2Down_value

    property vbfMass_JetRelativePtEC2Up:
        def __get__(self):
            self.vbfMass_JetRelativePtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtEC2Up_value

    property vbfMass_JetRelativePtHFDown:
        def __get__(self):
            self.vbfMass_JetRelativePtHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtHFDown_value

    property vbfMass_JetRelativePtHFUp:
        def __get__(self):
            self.vbfMass_JetRelativePtHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtHFUp_value

    property vbfMass_JetRelativeSampleDown:
        def __get__(self):
            self.vbfMass_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeSampleDown_value

    property vbfMass_JetRelativeSampleUp:
        def __get__(self):
            self.vbfMass_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeSampleUp_value

    property vbfMass_JetRelativeStatECDown:
        def __get__(self):
            self.vbfMass_JetRelativeStatECDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatECDown_value

    property vbfMass_JetRelativeStatECUp:
        def __get__(self):
            self.vbfMass_JetRelativeStatECUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatECUp_value

    property vbfMass_JetRelativeStatFSRDown:
        def __get__(self):
            self.vbfMass_JetRelativeStatFSRDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatFSRDown_value

    property vbfMass_JetRelativeStatFSRUp:
        def __get__(self):
            self.vbfMass_JetRelativeStatFSRUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatFSRUp_value

    property vbfMass_JetRelativeStatHFDown:
        def __get__(self):
            self.vbfMass_JetRelativeStatHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatHFDown_value

    property vbfMass_JetRelativeStatHFUp:
        def __get__(self):
            self.vbfMass_JetRelativeStatHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatHFUp_value

    property vbfMass_JetSinglePionECALDown:
        def __get__(self):
            self.vbfMass_JetSinglePionECALDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSinglePionECALDown_value

    property vbfMass_JetSinglePionECALUp:
        def __get__(self):
            self.vbfMass_JetSinglePionECALUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSinglePionECALUp_value

    property vbfMass_JetSinglePionHCALDown:
        def __get__(self):
            self.vbfMass_JetSinglePionHCALDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSinglePionHCALDown_value

    property vbfMass_JetSinglePionHCALUp:
        def __get__(self):
            self.vbfMass_JetSinglePionHCALUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSinglePionHCALUp_value

    property vbfMass_JetTimePtEtaDown:
        def __get__(self):
            self.vbfMass_JetTimePtEtaDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetTimePtEtaDown_value

    property vbfMass_JetTimePtEtaUp:
        def __get__(self):
            self.vbfMass_JetTimePtEtaUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetTimePtEtaUp_value

    property vbfMass_JetTotalDown:
        def __get__(self):
            self.vbfMass_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetTotalDown_value

    property vbfMass_JetTotalUp:
        def __get__(self):
            self.vbfMass_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetTotalUp_value

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

