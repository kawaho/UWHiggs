

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

    cdef TBranch* Flag_ecalBadCalibReducedMINIAODFilter_branch
    cdef float Flag_ecalBadCalibReducedMINIAODFilter_value

    cdef TBranch* Flag_eeBadScFilter_branch
    cdef float Flag_eeBadScFilter_value

    cdef TBranch* Flag_globalSuperTightHalo2016Filter_branch
    cdef float Flag_globalSuperTightHalo2016Filter_value

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

    cdef TBranch* Mu50Pass_branch
    cdef float Mu50Pass_value

    cdef TBranch* Phi_branch
    cdef float Phi_value

    cdef TBranch* Pt_branch
    cdef float Pt_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2016_DR0p5_branch
    cdef float bjetDeepCSVVeto20Medium_2016_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2017_DR0p5_branch
    cdef float bjetDeepCSVVeto20Medium_2017_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2018_DR0p5_branch
    cdef float bjetDeepCSVVeto20Medium_2018_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto30Medium_2016_DR0p5_branch
    cdef float bjetDeepCSVVeto30Medium_2016_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto30Medium_2017_DR0p5_branch
    cdef float bjetDeepCSVVeto30Medium_2017_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto30Medium_2018_DR0p5_branch
    cdef float bjetDeepCSVVeto30Medium_2018_DR0p5_value

    cdef TBranch* bweight_2016_branch
    cdef float bweight_2016_value

    cdef TBranch* bweight_2017_branch
    cdef float bweight_2017_value

    cdef TBranch* bweight_2018_branch
    cdef float bweight_2018_value

    cdef TBranch* charge_branch
    cdef float charge_value

    cdef TBranch* deepcsvb1_btagscore_branch
    cdef float deepcsvb1_btagscore_value

    cdef TBranch* deepcsvb1_eta_branch
    cdef float deepcsvb1_eta_value

    cdef TBranch* deepcsvb1_hadronflavour_branch
    cdef float deepcsvb1_hadronflavour_value

    cdef TBranch* deepcsvb1_m_branch
    cdef float deepcsvb1_m_value

    cdef TBranch* deepcsvb1_phi_branch
    cdef float deepcsvb1_phi_value

    cdef TBranch* deepcsvb1_pt_branch
    cdef float deepcsvb1_pt_value

    cdef TBranch* deepcsvb2_btagscore_branch
    cdef float deepcsvb2_btagscore_value

    cdef TBranch* deepcsvb2_eta_branch
    cdef float deepcsvb2_eta_value

    cdef TBranch* deepcsvb2_hadronflavour_branch
    cdef float deepcsvb2_hadronflavour_value

    cdef TBranch* deepcsvb2_m_branch
    cdef float deepcsvb2_m_value

    cdef TBranch* deepcsvb2_phi_branch
    cdef float deepcsvb2_phi_value

    cdef TBranch* deepcsvb2_pt_branch
    cdef float deepcsvb2_pt_value

    cdef TBranch* dielectronVeto_branch
    cdef float dielectronVeto_value

    cdef TBranch* dimuonVeto_branch
    cdef float dimuonVeto_value

    cdef TBranch* eCharge_branch
    cdef float eCharge_value

    cdef TBranch* eComesFromHiggs_branch
    cdef float eComesFromHiggs_value

    cdef TBranch* eCorrectedEt_branch
    cdef float eCorrectedEt_value

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

    cdef TBranch* eRelPFIsoRho_branch
    cdef float eRelPFIsoRho_value

    cdef TBranch* eSIP2D_branch
    cdef float eSIP2D_value

    cdef TBranch* eSIP3D_branch
    cdef float eSIP3D_value

    cdef TBranch* eVZ_branch
    cdef float eVZ_value

    cdef TBranch* eVetoMVAIsoVtx_branch
    cdef float eVetoMVAIsoVtx_value

    cdef TBranch* eVetoZTTp001dxyz_branch
    cdef float eVetoZTTp001dxyz_value

    cdef TBranch* eZTTGenMatching_branch
    cdef float eZTTGenMatching_value

    cdef TBranch* e_m_PZeta_branch
    cdef float e_m_PZeta_value

    cdef TBranch* e_m_PZetaVis_branch
    cdef float e_m_PZetaVis_value

    cdef TBranch* e_m_doubleL1IsoTauMatch_branch
    cdef float e_m_doubleL1IsoTauMatch_value

    cdef TBranch* eecalEnergy_branch
    cdef float eecalEnergy_value

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

    cdef TBranch* j1eta_JERDown_branch
    cdef float j1eta_JERDown_value

    cdef TBranch* j1eta_JERUp_branch
    cdef float j1eta_JERUp_value

    cdef TBranch* j1eta_JetAbsoluteDown_branch
    cdef float j1eta_JetAbsoluteDown_value

    cdef TBranch* j1eta_JetAbsoluteUp_branch
    cdef float j1eta_JetAbsoluteUp_value

    cdef TBranch* j1eta_JetAbsoluteyearDown_branch
    cdef float j1eta_JetAbsoluteyearDown_value

    cdef TBranch* j1eta_JetAbsoluteyearUp_branch
    cdef float j1eta_JetAbsoluteyearUp_value

    cdef TBranch* j1eta_JetBBEC1Down_branch
    cdef float j1eta_JetBBEC1Down_value

    cdef TBranch* j1eta_JetBBEC1Up_branch
    cdef float j1eta_JetBBEC1Up_value

    cdef TBranch* j1eta_JetBBEC1yearDown_branch
    cdef float j1eta_JetBBEC1yearDown_value

    cdef TBranch* j1eta_JetBBEC1yearUp_branch
    cdef float j1eta_JetBBEC1yearUp_value

    cdef TBranch* j1eta_JetEC2Down_branch
    cdef float j1eta_JetEC2Down_value

    cdef TBranch* j1eta_JetEC2Up_branch
    cdef float j1eta_JetEC2Up_value

    cdef TBranch* j1eta_JetEC2yearDown_branch
    cdef float j1eta_JetEC2yearDown_value

    cdef TBranch* j1eta_JetEC2yearUp_branch
    cdef float j1eta_JetEC2yearUp_value

    cdef TBranch* j1eta_JetFlavorQCDDown_branch
    cdef float j1eta_JetFlavorQCDDown_value

    cdef TBranch* j1eta_JetFlavorQCDUp_branch
    cdef float j1eta_JetFlavorQCDUp_value

    cdef TBranch* j1eta_JetHFDown_branch
    cdef float j1eta_JetHFDown_value

    cdef TBranch* j1eta_JetHFUp_branch
    cdef float j1eta_JetHFUp_value

    cdef TBranch* j1eta_JetHFyearDown_branch
    cdef float j1eta_JetHFyearDown_value

    cdef TBranch* j1eta_JetHFyearUp_branch
    cdef float j1eta_JetHFyearUp_value

    cdef TBranch* j1eta_JetRelativeBalDown_branch
    cdef float j1eta_JetRelativeBalDown_value

    cdef TBranch* j1eta_JetRelativeBalUp_branch
    cdef float j1eta_JetRelativeBalUp_value

    cdef TBranch* j1eta_JetRelativeSampleDown_branch
    cdef float j1eta_JetRelativeSampleDown_value

    cdef TBranch* j1eta_JetRelativeSampleUp_branch
    cdef float j1eta_JetRelativeSampleUp_value

    cdef TBranch* j1hadronflavor_branch
    cdef float j1hadronflavor_value

    cdef TBranch* j1hadronflavorWoNoisyJets_branch
    cdef float j1hadronflavorWoNoisyJets_value

    cdef TBranch* j1phi_branch
    cdef float j1phi_value

    cdef TBranch* j1phiWoNoisyJets_branch
    cdef float j1phiWoNoisyJets_value

    cdef TBranch* j1phi_JERDown_branch
    cdef float j1phi_JERDown_value

    cdef TBranch* j1phi_JERUp_branch
    cdef float j1phi_JERUp_value

    cdef TBranch* j1phi_JetAbsoluteDown_branch
    cdef float j1phi_JetAbsoluteDown_value

    cdef TBranch* j1phi_JetAbsoluteUp_branch
    cdef float j1phi_JetAbsoluteUp_value

    cdef TBranch* j1phi_JetAbsoluteyearDown_branch
    cdef float j1phi_JetAbsoluteyearDown_value

    cdef TBranch* j1phi_JetAbsoluteyearUp_branch
    cdef float j1phi_JetAbsoluteyearUp_value

    cdef TBranch* j1phi_JetBBEC1Down_branch
    cdef float j1phi_JetBBEC1Down_value

    cdef TBranch* j1phi_JetBBEC1Up_branch
    cdef float j1phi_JetBBEC1Up_value

    cdef TBranch* j1phi_JetBBEC1yearDown_branch
    cdef float j1phi_JetBBEC1yearDown_value

    cdef TBranch* j1phi_JetBBEC1yearUp_branch
    cdef float j1phi_JetBBEC1yearUp_value

    cdef TBranch* j1phi_JetEC2Down_branch
    cdef float j1phi_JetEC2Down_value

    cdef TBranch* j1phi_JetEC2Up_branch
    cdef float j1phi_JetEC2Up_value

    cdef TBranch* j1phi_JetEC2yearDown_branch
    cdef float j1phi_JetEC2yearDown_value

    cdef TBranch* j1phi_JetEC2yearUp_branch
    cdef float j1phi_JetEC2yearUp_value

    cdef TBranch* j1phi_JetFlavorQCDDown_branch
    cdef float j1phi_JetFlavorQCDDown_value

    cdef TBranch* j1phi_JetFlavorQCDUp_branch
    cdef float j1phi_JetFlavorQCDUp_value

    cdef TBranch* j1phi_JetHFDown_branch
    cdef float j1phi_JetHFDown_value

    cdef TBranch* j1phi_JetHFUp_branch
    cdef float j1phi_JetHFUp_value

    cdef TBranch* j1phi_JetHFyearDown_branch
    cdef float j1phi_JetHFyearDown_value

    cdef TBranch* j1phi_JetHFyearUp_branch
    cdef float j1phi_JetHFyearUp_value

    cdef TBranch* j1phi_JetRelativeBalDown_branch
    cdef float j1phi_JetRelativeBalDown_value

    cdef TBranch* j1phi_JetRelativeBalUp_branch
    cdef float j1phi_JetRelativeBalUp_value

    cdef TBranch* j1phi_JetRelativeSampleDown_branch
    cdef float j1phi_JetRelativeSampleDown_value

    cdef TBranch* j1phi_JetRelativeSampleUp_branch
    cdef float j1phi_JetRelativeSampleUp_value

    cdef TBranch* j1pt_branch
    cdef float j1pt_value

    cdef TBranch* j1ptWoNoisyJets_branch
    cdef float j1ptWoNoisyJets_value

    cdef TBranch* j1pt_JERDown_branch
    cdef float j1pt_JERDown_value

    cdef TBranch* j1pt_JERUp_branch
    cdef float j1pt_JERUp_value

    cdef TBranch* j1pt_JetAbsoluteDown_branch
    cdef float j1pt_JetAbsoluteDown_value

    cdef TBranch* j1pt_JetAbsoluteUp_branch
    cdef float j1pt_JetAbsoluteUp_value

    cdef TBranch* j1pt_JetAbsoluteyearDown_branch
    cdef float j1pt_JetAbsoluteyearDown_value

    cdef TBranch* j1pt_JetAbsoluteyearUp_branch
    cdef float j1pt_JetAbsoluteyearUp_value

    cdef TBranch* j1pt_JetBBEC1Down_branch
    cdef float j1pt_JetBBEC1Down_value

    cdef TBranch* j1pt_JetBBEC1Up_branch
    cdef float j1pt_JetBBEC1Up_value

    cdef TBranch* j1pt_JetBBEC1yearDown_branch
    cdef float j1pt_JetBBEC1yearDown_value

    cdef TBranch* j1pt_JetBBEC1yearUp_branch
    cdef float j1pt_JetBBEC1yearUp_value

    cdef TBranch* j1pt_JetEC2Down_branch
    cdef float j1pt_JetEC2Down_value

    cdef TBranch* j1pt_JetEC2Up_branch
    cdef float j1pt_JetEC2Up_value

    cdef TBranch* j1pt_JetEC2yearDown_branch
    cdef float j1pt_JetEC2yearDown_value

    cdef TBranch* j1pt_JetEC2yearUp_branch
    cdef float j1pt_JetEC2yearUp_value

    cdef TBranch* j1pt_JetFlavorQCDDown_branch
    cdef float j1pt_JetFlavorQCDDown_value

    cdef TBranch* j1pt_JetFlavorQCDUp_branch
    cdef float j1pt_JetFlavorQCDUp_value

    cdef TBranch* j1pt_JetHFDown_branch
    cdef float j1pt_JetHFDown_value

    cdef TBranch* j1pt_JetHFUp_branch
    cdef float j1pt_JetHFUp_value

    cdef TBranch* j1pt_JetHFyearDown_branch
    cdef float j1pt_JetHFyearDown_value

    cdef TBranch* j1pt_JetHFyearUp_branch
    cdef float j1pt_JetHFyearUp_value

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

    cdef TBranch* j2eta_JERDown_branch
    cdef float j2eta_JERDown_value

    cdef TBranch* j2eta_JERUp_branch
    cdef float j2eta_JERUp_value

    cdef TBranch* j2eta_JetAbsoluteDown_branch
    cdef float j2eta_JetAbsoluteDown_value

    cdef TBranch* j2eta_JetAbsoluteUp_branch
    cdef float j2eta_JetAbsoluteUp_value

    cdef TBranch* j2eta_JetAbsoluteyearDown_branch
    cdef float j2eta_JetAbsoluteyearDown_value

    cdef TBranch* j2eta_JetAbsoluteyearUp_branch
    cdef float j2eta_JetAbsoluteyearUp_value

    cdef TBranch* j2eta_JetBBEC1Down_branch
    cdef float j2eta_JetBBEC1Down_value

    cdef TBranch* j2eta_JetBBEC1Up_branch
    cdef float j2eta_JetBBEC1Up_value

    cdef TBranch* j2eta_JetBBEC1yearDown_branch
    cdef float j2eta_JetBBEC1yearDown_value

    cdef TBranch* j2eta_JetBBEC1yearUp_branch
    cdef float j2eta_JetBBEC1yearUp_value

    cdef TBranch* j2eta_JetEC2Down_branch
    cdef float j2eta_JetEC2Down_value

    cdef TBranch* j2eta_JetEC2Up_branch
    cdef float j2eta_JetEC2Up_value

    cdef TBranch* j2eta_JetEC2yearDown_branch
    cdef float j2eta_JetEC2yearDown_value

    cdef TBranch* j2eta_JetEC2yearUp_branch
    cdef float j2eta_JetEC2yearUp_value

    cdef TBranch* j2eta_JetFlavorQCDDown_branch
    cdef float j2eta_JetFlavorQCDDown_value

    cdef TBranch* j2eta_JetFlavorQCDUp_branch
    cdef float j2eta_JetFlavorQCDUp_value

    cdef TBranch* j2eta_JetHFDown_branch
    cdef float j2eta_JetHFDown_value

    cdef TBranch* j2eta_JetHFUp_branch
    cdef float j2eta_JetHFUp_value

    cdef TBranch* j2eta_JetHFyearDown_branch
    cdef float j2eta_JetHFyearDown_value

    cdef TBranch* j2eta_JetHFyearUp_branch
    cdef float j2eta_JetHFyearUp_value

    cdef TBranch* j2eta_JetRelativeBalDown_branch
    cdef float j2eta_JetRelativeBalDown_value

    cdef TBranch* j2eta_JetRelativeBalUp_branch
    cdef float j2eta_JetRelativeBalUp_value

    cdef TBranch* j2eta_JetRelativeSampleDown_branch
    cdef float j2eta_JetRelativeSampleDown_value

    cdef TBranch* j2eta_JetRelativeSampleUp_branch
    cdef float j2eta_JetRelativeSampleUp_value

    cdef TBranch* j2hadronflavor_branch
    cdef float j2hadronflavor_value

    cdef TBranch* j2hadronflavorWoNoisyJets_branch
    cdef float j2hadronflavorWoNoisyJets_value

    cdef TBranch* j2phi_branch
    cdef float j2phi_value

    cdef TBranch* j2phiWoNoisyJets_branch
    cdef float j2phiWoNoisyJets_value

    cdef TBranch* j2phi_JERDown_branch
    cdef float j2phi_JERDown_value

    cdef TBranch* j2phi_JERUp_branch
    cdef float j2phi_JERUp_value

    cdef TBranch* j2phi_JetAbsoluteDown_branch
    cdef float j2phi_JetAbsoluteDown_value

    cdef TBranch* j2phi_JetAbsoluteUp_branch
    cdef float j2phi_JetAbsoluteUp_value

    cdef TBranch* j2phi_JetAbsoluteyearDown_branch
    cdef float j2phi_JetAbsoluteyearDown_value

    cdef TBranch* j2phi_JetAbsoluteyearUp_branch
    cdef float j2phi_JetAbsoluteyearUp_value

    cdef TBranch* j2phi_JetBBEC1Down_branch
    cdef float j2phi_JetBBEC1Down_value

    cdef TBranch* j2phi_JetBBEC1Up_branch
    cdef float j2phi_JetBBEC1Up_value

    cdef TBranch* j2phi_JetBBEC1yearDown_branch
    cdef float j2phi_JetBBEC1yearDown_value

    cdef TBranch* j2phi_JetBBEC1yearUp_branch
    cdef float j2phi_JetBBEC1yearUp_value

    cdef TBranch* j2phi_JetEC2Down_branch
    cdef float j2phi_JetEC2Down_value

    cdef TBranch* j2phi_JetEC2Up_branch
    cdef float j2phi_JetEC2Up_value

    cdef TBranch* j2phi_JetEC2yearDown_branch
    cdef float j2phi_JetEC2yearDown_value

    cdef TBranch* j2phi_JetEC2yearUp_branch
    cdef float j2phi_JetEC2yearUp_value

    cdef TBranch* j2phi_JetFlavorQCDDown_branch
    cdef float j2phi_JetFlavorQCDDown_value

    cdef TBranch* j2phi_JetFlavorQCDUp_branch
    cdef float j2phi_JetFlavorQCDUp_value

    cdef TBranch* j2phi_JetHFDown_branch
    cdef float j2phi_JetHFDown_value

    cdef TBranch* j2phi_JetHFUp_branch
    cdef float j2phi_JetHFUp_value

    cdef TBranch* j2phi_JetHFyearDown_branch
    cdef float j2phi_JetHFyearDown_value

    cdef TBranch* j2phi_JetHFyearUp_branch
    cdef float j2phi_JetHFyearUp_value

    cdef TBranch* j2phi_JetRelativeBalDown_branch
    cdef float j2phi_JetRelativeBalDown_value

    cdef TBranch* j2phi_JetRelativeBalUp_branch
    cdef float j2phi_JetRelativeBalUp_value

    cdef TBranch* j2phi_JetRelativeSampleDown_branch
    cdef float j2phi_JetRelativeSampleDown_value

    cdef TBranch* j2phi_JetRelativeSampleUp_branch
    cdef float j2phi_JetRelativeSampleUp_value

    cdef TBranch* j2pt_branch
    cdef float j2pt_value

    cdef TBranch* j2ptWoNoisyJets_branch
    cdef float j2ptWoNoisyJets_value

    cdef TBranch* j2pt_JERDown_branch
    cdef float j2pt_JERDown_value

    cdef TBranch* j2pt_JERUp_branch
    cdef float j2pt_JERUp_value

    cdef TBranch* j2pt_JetAbsoluteDown_branch
    cdef float j2pt_JetAbsoluteDown_value

    cdef TBranch* j2pt_JetAbsoluteUp_branch
    cdef float j2pt_JetAbsoluteUp_value

    cdef TBranch* j2pt_JetAbsoluteyearDown_branch
    cdef float j2pt_JetAbsoluteyearDown_value

    cdef TBranch* j2pt_JetAbsoluteyearUp_branch
    cdef float j2pt_JetAbsoluteyearUp_value

    cdef TBranch* j2pt_JetBBEC1Down_branch
    cdef float j2pt_JetBBEC1Down_value

    cdef TBranch* j2pt_JetBBEC1Up_branch
    cdef float j2pt_JetBBEC1Up_value

    cdef TBranch* j2pt_JetBBEC1yearDown_branch
    cdef float j2pt_JetBBEC1yearDown_value

    cdef TBranch* j2pt_JetBBEC1yearUp_branch
    cdef float j2pt_JetBBEC1yearUp_value

    cdef TBranch* j2pt_JetEC2Down_branch
    cdef float j2pt_JetEC2Down_value

    cdef TBranch* j2pt_JetEC2Up_branch
    cdef float j2pt_JetEC2Up_value

    cdef TBranch* j2pt_JetEC2yearDown_branch
    cdef float j2pt_JetEC2yearDown_value

    cdef TBranch* j2pt_JetEC2yearUp_branch
    cdef float j2pt_JetEC2yearUp_value

    cdef TBranch* j2pt_JetFlavorQCDDown_branch
    cdef float j2pt_JetFlavorQCDDown_value

    cdef TBranch* j2pt_JetFlavorQCDUp_branch
    cdef float j2pt_JetFlavorQCDUp_value

    cdef TBranch* j2pt_JetHFDown_branch
    cdef float j2pt_JetHFDown_value

    cdef TBranch* j2pt_JetHFUp_branch
    cdef float j2pt_JetHFUp_value

    cdef TBranch* j2pt_JetHFyearDown_branch
    cdef float j2pt_JetHFyearDown_value

    cdef TBranch* j2pt_JetHFyearUp_branch
    cdef float j2pt_JetHFyearUp_value

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

    cdef TBranch* jetVeto30_branch
    cdef float jetVeto30_value

    cdef TBranch* jetVeto30WoNoisyJets_branch
    cdef float jetVeto30WoNoisyJets_value

    cdef TBranch* jetVeto30_JERDown_branch
    cdef float jetVeto30_JERDown_value

    cdef TBranch* jetVeto30_JERUp_branch
    cdef float jetVeto30_JERUp_value

    cdef TBranch* jetVeto30_JetAbsoluteDown_branch
    cdef float jetVeto30_JetAbsoluteDown_value

    cdef TBranch* jetVeto30_JetAbsoluteUp_branch
    cdef float jetVeto30_JetAbsoluteUp_value

    cdef TBranch* jetVeto30_JetAbsoluteyearDown_branch
    cdef float jetVeto30_JetAbsoluteyearDown_value

    cdef TBranch* jetVeto30_JetAbsoluteyearUp_branch
    cdef float jetVeto30_JetAbsoluteyearUp_value

    cdef TBranch* jetVeto30_JetBBEC1Down_branch
    cdef float jetVeto30_JetBBEC1Down_value

    cdef TBranch* jetVeto30_JetBBEC1Up_branch
    cdef float jetVeto30_JetBBEC1Up_value

    cdef TBranch* jetVeto30_JetBBEC1yearDown_branch
    cdef float jetVeto30_JetBBEC1yearDown_value

    cdef TBranch* jetVeto30_JetBBEC1yearUp_branch
    cdef float jetVeto30_JetBBEC1yearUp_value

    cdef TBranch* jetVeto30_JetEC2Down_branch
    cdef float jetVeto30_JetEC2Down_value

    cdef TBranch* jetVeto30_JetEC2Up_branch
    cdef float jetVeto30_JetEC2Up_value

    cdef TBranch* jetVeto30_JetEC2yearDown_branch
    cdef float jetVeto30_JetEC2yearDown_value

    cdef TBranch* jetVeto30_JetEC2yearUp_branch
    cdef float jetVeto30_JetEC2yearUp_value

    cdef TBranch* jetVeto30_JetFlavorQCDDown_branch
    cdef float jetVeto30_JetFlavorQCDDown_value

    cdef TBranch* jetVeto30_JetFlavorQCDUp_branch
    cdef float jetVeto30_JetFlavorQCDUp_value

    cdef TBranch* jetVeto30_JetHFDown_branch
    cdef float jetVeto30_JetHFDown_value

    cdef TBranch* jetVeto30_JetHFUp_branch
    cdef float jetVeto30_JetHFUp_value

    cdef TBranch* jetVeto30_JetHFyearDown_branch
    cdef float jetVeto30_JetHFyearDown_value

    cdef TBranch* jetVeto30_JetHFyearUp_branch
    cdef float jetVeto30_JetHFyearUp_value

    cdef TBranch* jetVeto30_JetRelativeBalDown_branch
    cdef float jetVeto30_JetRelativeBalDown_value

    cdef TBranch* jetVeto30_JetRelativeBalUp_branch
    cdef float jetVeto30_JetRelativeBalUp_value

    cdef TBranch* jetVeto30_JetRelativeSampleDown_branch
    cdef float jetVeto30_JetRelativeSampleDown_value

    cdef TBranch* jetVeto30_JetRelativeSampleUp_branch
    cdef float jetVeto30_JetRelativeSampleUp_value

    cdef TBranch* jetVeto30_JetTotalDown_branch
    cdef float jetVeto30_JetTotalDown_value

    cdef TBranch* jetVeto30_JetTotalUp_branch
    cdef float jetVeto30_JetTotalUp_value

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

    cdef TBranch* lheweight13_branch
    cdef float lheweight13_value

    cdef TBranch* lheweight14_branch
    cdef float lheweight14_value

    cdef TBranch* lheweight15_branch
    cdef float lheweight15_value

    cdef TBranch* lheweight16_branch
    cdef float lheweight16_value

    cdef TBranch* lheweight17_branch
    cdef float lheweight17_value

    cdef TBranch* lheweight18_branch
    cdef float lheweight18_value

    cdef TBranch* lheweight19_branch
    cdef float lheweight19_value

    cdef TBranch* lheweight2_branch
    cdef float lheweight2_value

    cdef TBranch* lheweight20_branch
    cdef float lheweight20_value

    cdef TBranch* lheweight21_branch
    cdef float lheweight21_value

    cdef TBranch* lheweight22_branch
    cdef float lheweight22_value

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

    cdef TBranch* mCharge_branch
    cdef float mCharge_value

    cdef TBranch* mComesFromHiggs_branch
    cdef float mComesFromHiggs_value

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

    cdef TBranch* mMass_branch
    cdef float mMass_value

    cdef TBranch* mMatchEmbeddedFilterMu24_branch
    cdef float mMatchEmbeddedFilterMu24_value

    cdef TBranch* mMatchEmbeddedFilterMu27_branch
    cdef float mMatchEmbeddedFilterMu27_value

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

    cdef TBranch* mPFIDLoose_branch
    cdef float mPFIDLoose_value

    cdef TBranch* mPFIDMedium_branch
    cdef float mPFIDMedium_value

    cdef TBranch* mPFIDTight_branch
    cdef float mPFIDTight_value

    cdef TBranch* mPVDXY_branch
    cdef float mPVDXY_value

    cdef TBranch* mPVDZ_branch
    cdef float mPVDZ_value

    cdef TBranch* mPhi_branch
    cdef float mPhi_value

    cdef TBranch* mPt_branch
    cdef float mPt_value

    cdef TBranch* mRelPFIsoDBDefaultR04_branch
    cdef float mRelPFIsoDBDefaultR04_value

    cdef TBranch* mSIP2D_branch
    cdef float mSIP2D_value

    cdef TBranch* mSIP3D_branch
    cdef float mSIP3D_value

    cdef TBranch* mVZ_branch
    cdef float mVZ_value

    cdef TBranch* mZTTGenMatching_branch
    cdef float mZTTGenMatching_value

    cdef TBranch* mu12e23DZPass_branch
    cdef float mu12e23DZPass_value

    cdef TBranch* mu12e23Pass_branch
    cdef float mu12e23Pass_value

    cdef TBranch* mu23e12DZPass_branch
    cdef float mu23e12DZPass_value

    cdef TBranch* mu23e12Pass_branch
    cdef float mu23e12Pass_value

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

    cdef TBranch* tauVetoPt20LooseMVALTVtx_branch
    cdef float tauVetoPt20LooseMVALTVtx_value

    cdef TBranch* tauVetoPtDeepVtx_branch
    cdef float tauVetoPtDeepVtx_value

    cdef TBranch* topQuarkPt1_branch
    cdef float topQuarkPt1_value

    cdef TBranch* topQuarkPt2_branch
    cdef float topQuarkPt2_value

    cdef TBranch* type1_pfMetEt_branch
    cdef float type1_pfMetEt_value

    cdef TBranch* type1_pfMetPhi_branch
    cdef float type1_pfMetPhi_value

    cdef TBranch* type1_pfMet_shiftedPhi_JERDown_branch
    cdef float type1_pfMet_shiftedPhi_JERDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JERUp_branch
    cdef float type1_pfMet_shiftedPhi_JERUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteDown_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteUp_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteyearDown_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteyearDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteyearUp_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteyearUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetBBEC1Down_branch
    cdef float type1_pfMet_shiftedPhi_JetBBEC1Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetBBEC1Up_branch
    cdef float type1_pfMet_shiftedPhi_JetBBEC1Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetBBEC1yearDown_branch
    cdef float type1_pfMet_shiftedPhi_JetBBEC1yearDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetBBEC1yearUp_branch
    cdef float type1_pfMet_shiftedPhi_JetBBEC1yearUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEC2Down_branch
    cdef float type1_pfMet_shiftedPhi_JetEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEC2Up_branch
    cdef float type1_pfMet_shiftedPhi_JetEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEC2yearDown_branch
    cdef float type1_pfMet_shiftedPhi_JetEC2yearDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEC2yearUp_branch
    cdef float type1_pfMet_shiftedPhi_JetEC2yearUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEnDown_branch
    cdef float type1_pfMet_shiftedPhi_JetEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEnUp_branch
    cdef float type1_pfMet_shiftedPhi_JetEnUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch
    cdef float type1_pfMet_shiftedPhi_JetFlavorQCDDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch
    cdef float type1_pfMet_shiftedPhi_JetFlavorQCDUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetHFDown_branch
    cdef float type1_pfMet_shiftedPhi_JetHFDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetHFUp_branch
    cdef float type1_pfMet_shiftedPhi_JetHFUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetHFyearDown_branch
    cdef float type1_pfMet_shiftedPhi_JetHFyearDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetHFyearUp_branch
    cdef float type1_pfMet_shiftedPhi_JetHFyearUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeBalDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeBalDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeBalUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeBalUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeSampleDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeSampleUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetResDown_branch
    cdef float type1_pfMet_shiftedPhi_JetResDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetResUp_branch
    cdef float type1_pfMet_shiftedPhi_JetResUp_value

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

    cdef TBranch* type1_pfMet_shiftedPt_JERDown_branch
    cdef float type1_pfMet_shiftedPt_JERDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JERUp_branch
    cdef float type1_pfMet_shiftedPt_JERUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteDown_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteUp_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteyearDown_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteyearDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteyearUp_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteyearUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetBBEC1Down_branch
    cdef float type1_pfMet_shiftedPt_JetBBEC1Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetBBEC1Up_branch
    cdef float type1_pfMet_shiftedPt_JetBBEC1Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetBBEC1yearDown_branch
    cdef float type1_pfMet_shiftedPt_JetBBEC1yearDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetBBEC1yearUp_branch
    cdef float type1_pfMet_shiftedPt_JetBBEC1yearUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEC2Down_branch
    cdef float type1_pfMet_shiftedPt_JetEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEC2Up_branch
    cdef float type1_pfMet_shiftedPt_JetEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEC2yearDown_branch
    cdef float type1_pfMet_shiftedPt_JetEC2yearDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEC2yearUp_branch
    cdef float type1_pfMet_shiftedPt_JetEC2yearUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEnDown_branch
    cdef float type1_pfMet_shiftedPt_JetEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEnUp_branch
    cdef float type1_pfMet_shiftedPt_JetEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetFlavorQCDDown_branch
    cdef float type1_pfMet_shiftedPt_JetFlavorQCDDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetFlavorQCDUp_branch
    cdef float type1_pfMet_shiftedPt_JetFlavorQCDUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetHFDown_branch
    cdef float type1_pfMet_shiftedPt_JetHFDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetHFUp_branch
    cdef float type1_pfMet_shiftedPt_JetHFUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetHFyearDown_branch
    cdef float type1_pfMet_shiftedPt_JetHFyearDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetHFyearUp_branch
    cdef float type1_pfMet_shiftedPt_JetHFyearUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeBalDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeBalDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeBalUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeBalUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeSampleDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeSampleDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeSampleUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeSampleUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetResDown_branch
    cdef float type1_pfMet_shiftedPt_JetResDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetResUp_branch
    cdef float type1_pfMet_shiftedPt_JetResUp_value

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

    cdef TBranch* vbfMass_JERDown_branch
    cdef float vbfMass_JERDown_value

    cdef TBranch* vbfMass_JERUp_branch
    cdef float vbfMass_JERUp_value

    cdef TBranch* vbfMass_JetAbsoluteDown_branch
    cdef float vbfMass_JetAbsoluteDown_value

    cdef TBranch* vbfMass_JetAbsoluteUp_branch
    cdef float vbfMass_JetAbsoluteUp_value

    cdef TBranch* vbfMass_JetAbsoluteyearDown_branch
    cdef float vbfMass_JetAbsoluteyearDown_value

    cdef TBranch* vbfMass_JetAbsoluteyearUp_branch
    cdef float vbfMass_JetAbsoluteyearUp_value

    cdef TBranch* vbfMass_JetBBEC1Down_branch
    cdef float vbfMass_JetBBEC1Down_value

    cdef TBranch* vbfMass_JetBBEC1Up_branch
    cdef float vbfMass_JetBBEC1Up_value

    cdef TBranch* vbfMass_JetBBEC1yearDown_branch
    cdef float vbfMass_JetBBEC1yearDown_value

    cdef TBranch* vbfMass_JetBBEC1yearUp_branch
    cdef float vbfMass_JetBBEC1yearUp_value

    cdef TBranch* vbfMass_JetEC2Down_branch
    cdef float vbfMass_JetEC2Down_value

    cdef TBranch* vbfMass_JetEC2Up_branch
    cdef float vbfMass_JetEC2Up_value

    cdef TBranch* vbfMass_JetEC2yearDown_branch
    cdef float vbfMass_JetEC2yearDown_value

    cdef TBranch* vbfMass_JetEC2yearUp_branch
    cdef float vbfMass_JetEC2yearUp_value

    cdef TBranch* vbfMass_JetFlavorQCDDown_branch
    cdef float vbfMass_JetFlavorQCDDown_value

    cdef TBranch* vbfMass_JetFlavorQCDUp_branch
    cdef float vbfMass_JetFlavorQCDUp_value

    cdef TBranch* vbfMass_JetHFDown_branch
    cdef float vbfMass_JetHFDown_value

    cdef TBranch* vbfMass_JetHFUp_branch
    cdef float vbfMass_JetHFUp_value

    cdef TBranch* vbfMass_JetHFyearDown_branch
    cdef float vbfMass_JetHFyearDown_value

    cdef TBranch* vbfMass_JetHFyearUp_branch
    cdef float vbfMass_JetHFyearUp_value

    cdef TBranch* vbfMass_JetRelativeBalDown_branch
    cdef float vbfMass_JetRelativeBalDown_value

    cdef TBranch* vbfMass_JetRelativeBalUp_branch
    cdef float vbfMass_JetRelativeBalUp_value

    cdef TBranch* vbfMass_JetRelativeSampleDown_branch
    cdef float vbfMass_JetRelativeSampleDown_value

    cdef TBranch* vbfMass_JetRelativeSampleUp_branch
    cdef float vbfMass_JetRelativeSampleUp_value

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

        #print "making Mu50Pass"
        self.Mu50Pass_branch = the_tree.GetBranch("Mu50Pass")
        #if not self.Mu50Pass_branch and "Mu50Pass" not in self.complained:
        if not self.Mu50Pass_branch and "Mu50Pass":
            warnings.warn( "EMTree: Expected branch Mu50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Pass")
        else:
            self.Mu50Pass_branch.SetAddress(<void*>&self.Mu50Pass_value)

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

        #print "making bjetDeepCSVVeto20Medium_2016_DR0p5"
        self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0p5"
        self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0p5"
        self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto30Medium_2016_DR0p5"
        self.bjetDeepCSVVeto30Medium_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto30Medium_2016_DR0p5")
        #if not self.bjetDeepCSVVeto30Medium_2016_DR0p5_branch and "bjetDeepCSVVeto30Medium_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto30Medium_2016_DR0p5_branch and "bjetDeepCSVVeto30Medium_2016_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto30Medium_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto30Medium_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto30Medium_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto30Medium_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto30Medium_2017_DR0p5"
        self.bjetDeepCSVVeto30Medium_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto30Medium_2017_DR0p5")
        #if not self.bjetDeepCSVVeto30Medium_2017_DR0p5_branch and "bjetDeepCSVVeto30Medium_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto30Medium_2017_DR0p5_branch and "bjetDeepCSVVeto30Medium_2017_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto30Medium_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto30Medium_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto30Medium_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto30Medium_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto30Medium_2018_DR0p5"
        self.bjetDeepCSVVeto30Medium_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto30Medium_2018_DR0p5")
        #if not self.bjetDeepCSVVeto30Medium_2018_DR0p5_branch and "bjetDeepCSVVeto30Medium_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto30Medium_2018_DR0p5_branch and "bjetDeepCSVVeto30Medium_2018_DR0p5":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto30Medium_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto30Medium_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto30Medium_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto30Medium_2018_DR0p5_value)

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

        #print "making deepcsvb1_btagscore"
        self.deepcsvb1_btagscore_branch = the_tree.GetBranch("deepcsvb1_btagscore")
        #if not self.deepcsvb1_btagscore_branch and "deepcsvb1_btagscore" not in self.complained:
        if not self.deepcsvb1_btagscore_branch and "deepcsvb1_btagscore":
            warnings.warn( "EMTree: Expected branch deepcsvb1_btagscore does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1_btagscore")
        else:
            self.deepcsvb1_btagscore_branch.SetAddress(<void*>&self.deepcsvb1_btagscore_value)

        #print "making deepcsvb1_eta"
        self.deepcsvb1_eta_branch = the_tree.GetBranch("deepcsvb1_eta")
        #if not self.deepcsvb1_eta_branch and "deepcsvb1_eta" not in self.complained:
        if not self.deepcsvb1_eta_branch and "deepcsvb1_eta":
            warnings.warn( "EMTree: Expected branch deepcsvb1_eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1_eta")
        else:
            self.deepcsvb1_eta_branch.SetAddress(<void*>&self.deepcsvb1_eta_value)

        #print "making deepcsvb1_hadronflavour"
        self.deepcsvb1_hadronflavour_branch = the_tree.GetBranch("deepcsvb1_hadronflavour")
        #if not self.deepcsvb1_hadronflavour_branch and "deepcsvb1_hadronflavour" not in self.complained:
        if not self.deepcsvb1_hadronflavour_branch and "deepcsvb1_hadronflavour":
            warnings.warn( "EMTree: Expected branch deepcsvb1_hadronflavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1_hadronflavour")
        else:
            self.deepcsvb1_hadronflavour_branch.SetAddress(<void*>&self.deepcsvb1_hadronflavour_value)

        #print "making deepcsvb1_m"
        self.deepcsvb1_m_branch = the_tree.GetBranch("deepcsvb1_m")
        #if not self.deepcsvb1_m_branch and "deepcsvb1_m" not in self.complained:
        if not self.deepcsvb1_m_branch and "deepcsvb1_m":
            warnings.warn( "EMTree: Expected branch deepcsvb1_m does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1_m")
        else:
            self.deepcsvb1_m_branch.SetAddress(<void*>&self.deepcsvb1_m_value)

        #print "making deepcsvb1_phi"
        self.deepcsvb1_phi_branch = the_tree.GetBranch("deepcsvb1_phi")
        #if not self.deepcsvb1_phi_branch and "deepcsvb1_phi" not in self.complained:
        if not self.deepcsvb1_phi_branch and "deepcsvb1_phi":
            warnings.warn( "EMTree: Expected branch deepcsvb1_phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1_phi")
        else:
            self.deepcsvb1_phi_branch.SetAddress(<void*>&self.deepcsvb1_phi_value)

        #print "making deepcsvb1_pt"
        self.deepcsvb1_pt_branch = the_tree.GetBranch("deepcsvb1_pt")
        #if not self.deepcsvb1_pt_branch and "deepcsvb1_pt" not in self.complained:
        if not self.deepcsvb1_pt_branch and "deepcsvb1_pt":
            warnings.warn( "EMTree: Expected branch deepcsvb1_pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1_pt")
        else:
            self.deepcsvb1_pt_branch.SetAddress(<void*>&self.deepcsvb1_pt_value)

        #print "making deepcsvb2_btagscore"
        self.deepcsvb2_btagscore_branch = the_tree.GetBranch("deepcsvb2_btagscore")
        #if not self.deepcsvb2_btagscore_branch and "deepcsvb2_btagscore" not in self.complained:
        if not self.deepcsvb2_btagscore_branch and "deepcsvb2_btagscore":
            warnings.warn( "EMTree: Expected branch deepcsvb2_btagscore does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2_btagscore")
        else:
            self.deepcsvb2_btagscore_branch.SetAddress(<void*>&self.deepcsvb2_btagscore_value)

        #print "making deepcsvb2_eta"
        self.deepcsvb2_eta_branch = the_tree.GetBranch("deepcsvb2_eta")
        #if not self.deepcsvb2_eta_branch and "deepcsvb2_eta" not in self.complained:
        if not self.deepcsvb2_eta_branch and "deepcsvb2_eta":
            warnings.warn( "EMTree: Expected branch deepcsvb2_eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2_eta")
        else:
            self.deepcsvb2_eta_branch.SetAddress(<void*>&self.deepcsvb2_eta_value)

        #print "making deepcsvb2_hadronflavour"
        self.deepcsvb2_hadronflavour_branch = the_tree.GetBranch("deepcsvb2_hadronflavour")
        #if not self.deepcsvb2_hadronflavour_branch and "deepcsvb2_hadronflavour" not in self.complained:
        if not self.deepcsvb2_hadronflavour_branch and "deepcsvb2_hadronflavour":
            warnings.warn( "EMTree: Expected branch deepcsvb2_hadronflavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2_hadronflavour")
        else:
            self.deepcsvb2_hadronflavour_branch.SetAddress(<void*>&self.deepcsvb2_hadronflavour_value)

        #print "making deepcsvb2_m"
        self.deepcsvb2_m_branch = the_tree.GetBranch("deepcsvb2_m")
        #if not self.deepcsvb2_m_branch and "deepcsvb2_m" not in self.complained:
        if not self.deepcsvb2_m_branch and "deepcsvb2_m":
            warnings.warn( "EMTree: Expected branch deepcsvb2_m does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2_m")
        else:
            self.deepcsvb2_m_branch.SetAddress(<void*>&self.deepcsvb2_m_value)

        #print "making deepcsvb2_phi"
        self.deepcsvb2_phi_branch = the_tree.GetBranch("deepcsvb2_phi")
        #if not self.deepcsvb2_phi_branch and "deepcsvb2_phi" not in self.complained:
        if not self.deepcsvb2_phi_branch and "deepcsvb2_phi":
            warnings.warn( "EMTree: Expected branch deepcsvb2_phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2_phi")
        else:
            self.deepcsvb2_phi_branch.SetAddress(<void*>&self.deepcsvb2_phi_value)

        #print "making deepcsvb2_pt"
        self.deepcsvb2_pt_branch = the_tree.GetBranch("deepcsvb2_pt")
        #if not self.deepcsvb2_pt_branch and "deepcsvb2_pt" not in self.complained:
        if not self.deepcsvb2_pt_branch and "deepcsvb2_pt":
            warnings.warn( "EMTree: Expected branch deepcsvb2_pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2_pt")
        else:
            self.deepcsvb2_pt_branch.SetAddress(<void*>&self.deepcsvb2_pt_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "EMTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "EMTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making eCharge"
        self.eCharge_branch = the_tree.GetBranch("eCharge")
        #if not self.eCharge_branch and "eCharge" not in self.complained:
        if not self.eCharge_branch and "eCharge":
            warnings.warn( "EMTree: Expected branch eCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCharge")
        else:
            self.eCharge_branch.SetAddress(<void*>&self.eCharge_value)

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

        #print "making eRelPFIsoRho"
        self.eRelPFIsoRho_branch = the_tree.GetBranch("eRelPFIsoRho")
        #if not self.eRelPFIsoRho_branch and "eRelPFIsoRho" not in self.complained:
        if not self.eRelPFIsoRho_branch and "eRelPFIsoRho":
            warnings.warn( "EMTree: Expected branch eRelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRho")
        else:
            self.eRelPFIsoRho_branch.SetAddress(<void*>&self.eRelPFIsoRho_value)

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

        #print "making eecalEnergy"
        self.eecalEnergy_branch = the_tree.GetBranch("eecalEnergy")
        #if not self.eecalEnergy_branch and "eecalEnergy" not in self.complained:
        if not self.eecalEnergy_branch and "eecalEnergy":
            warnings.warn( "EMTree: Expected branch eecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eecalEnergy")
        else:
            self.eecalEnergy_branch.SetAddress(<void*>&self.eecalEnergy_value)

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

        #print "making j1eta_JERDown"
        self.j1eta_JERDown_branch = the_tree.GetBranch("j1eta_JERDown")
        #if not self.j1eta_JERDown_branch and "j1eta_JERDown" not in self.complained:
        if not self.j1eta_JERDown_branch and "j1eta_JERDown":
            warnings.warn( "EMTree: Expected branch j1eta_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JERDown")
        else:
            self.j1eta_JERDown_branch.SetAddress(<void*>&self.j1eta_JERDown_value)

        #print "making j1eta_JERUp"
        self.j1eta_JERUp_branch = the_tree.GetBranch("j1eta_JERUp")
        #if not self.j1eta_JERUp_branch and "j1eta_JERUp" not in self.complained:
        if not self.j1eta_JERUp_branch and "j1eta_JERUp":
            warnings.warn( "EMTree: Expected branch j1eta_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JERUp")
        else:
            self.j1eta_JERUp_branch.SetAddress(<void*>&self.j1eta_JERUp_value)

        #print "making j1eta_JetAbsoluteDown"
        self.j1eta_JetAbsoluteDown_branch = the_tree.GetBranch("j1eta_JetAbsoluteDown")
        #if not self.j1eta_JetAbsoluteDown_branch and "j1eta_JetAbsoluteDown" not in self.complained:
        if not self.j1eta_JetAbsoluteDown_branch and "j1eta_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch j1eta_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetAbsoluteDown")
        else:
            self.j1eta_JetAbsoluteDown_branch.SetAddress(<void*>&self.j1eta_JetAbsoluteDown_value)

        #print "making j1eta_JetAbsoluteUp"
        self.j1eta_JetAbsoluteUp_branch = the_tree.GetBranch("j1eta_JetAbsoluteUp")
        #if not self.j1eta_JetAbsoluteUp_branch and "j1eta_JetAbsoluteUp" not in self.complained:
        if not self.j1eta_JetAbsoluteUp_branch and "j1eta_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch j1eta_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetAbsoluteUp")
        else:
            self.j1eta_JetAbsoluteUp_branch.SetAddress(<void*>&self.j1eta_JetAbsoluteUp_value)

        #print "making j1eta_JetAbsoluteyearDown"
        self.j1eta_JetAbsoluteyearDown_branch = the_tree.GetBranch("j1eta_JetAbsoluteyearDown")
        #if not self.j1eta_JetAbsoluteyearDown_branch and "j1eta_JetAbsoluteyearDown" not in self.complained:
        if not self.j1eta_JetAbsoluteyearDown_branch and "j1eta_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch j1eta_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetAbsoluteyearDown")
        else:
            self.j1eta_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.j1eta_JetAbsoluteyearDown_value)

        #print "making j1eta_JetAbsoluteyearUp"
        self.j1eta_JetAbsoluteyearUp_branch = the_tree.GetBranch("j1eta_JetAbsoluteyearUp")
        #if not self.j1eta_JetAbsoluteyearUp_branch and "j1eta_JetAbsoluteyearUp" not in self.complained:
        if not self.j1eta_JetAbsoluteyearUp_branch and "j1eta_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch j1eta_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetAbsoluteyearUp")
        else:
            self.j1eta_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.j1eta_JetAbsoluteyearUp_value)

        #print "making j1eta_JetBBEC1Down"
        self.j1eta_JetBBEC1Down_branch = the_tree.GetBranch("j1eta_JetBBEC1Down")
        #if not self.j1eta_JetBBEC1Down_branch and "j1eta_JetBBEC1Down" not in self.complained:
        if not self.j1eta_JetBBEC1Down_branch and "j1eta_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch j1eta_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetBBEC1Down")
        else:
            self.j1eta_JetBBEC1Down_branch.SetAddress(<void*>&self.j1eta_JetBBEC1Down_value)

        #print "making j1eta_JetBBEC1Up"
        self.j1eta_JetBBEC1Up_branch = the_tree.GetBranch("j1eta_JetBBEC1Up")
        #if not self.j1eta_JetBBEC1Up_branch and "j1eta_JetBBEC1Up" not in self.complained:
        if not self.j1eta_JetBBEC1Up_branch and "j1eta_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch j1eta_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetBBEC1Up")
        else:
            self.j1eta_JetBBEC1Up_branch.SetAddress(<void*>&self.j1eta_JetBBEC1Up_value)

        #print "making j1eta_JetBBEC1yearDown"
        self.j1eta_JetBBEC1yearDown_branch = the_tree.GetBranch("j1eta_JetBBEC1yearDown")
        #if not self.j1eta_JetBBEC1yearDown_branch and "j1eta_JetBBEC1yearDown" not in self.complained:
        if not self.j1eta_JetBBEC1yearDown_branch and "j1eta_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch j1eta_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetBBEC1yearDown")
        else:
            self.j1eta_JetBBEC1yearDown_branch.SetAddress(<void*>&self.j1eta_JetBBEC1yearDown_value)

        #print "making j1eta_JetBBEC1yearUp"
        self.j1eta_JetBBEC1yearUp_branch = the_tree.GetBranch("j1eta_JetBBEC1yearUp")
        #if not self.j1eta_JetBBEC1yearUp_branch and "j1eta_JetBBEC1yearUp" not in self.complained:
        if not self.j1eta_JetBBEC1yearUp_branch and "j1eta_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch j1eta_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetBBEC1yearUp")
        else:
            self.j1eta_JetBBEC1yearUp_branch.SetAddress(<void*>&self.j1eta_JetBBEC1yearUp_value)

        #print "making j1eta_JetEC2Down"
        self.j1eta_JetEC2Down_branch = the_tree.GetBranch("j1eta_JetEC2Down")
        #if not self.j1eta_JetEC2Down_branch and "j1eta_JetEC2Down" not in self.complained:
        if not self.j1eta_JetEC2Down_branch and "j1eta_JetEC2Down":
            warnings.warn( "EMTree: Expected branch j1eta_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetEC2Down")
        else:
            self.j1eta_JetEC2Down_branch.SetAddress(<void*>&self.j1eta_JetEC2Down_value)

        #print "making j1eta_JetEC2Up"
        self.j1eta_JetEC2Up_branch = the_tree.GetBranch("j1eta_JetEC2Up")
        #if not self.j1eta_JetEC2Up_branch and "j1eta_JetEC2Up" not in self.complained:
        if not self.j1eta_JetEC2Up_branch and "j1eta_JetEC2Up":
            warnings.warn( "EMTree: Expected branch j1eta_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetEC2Up")
        else:
            self.j1eta_JetEC2Up_branch.SetAddress(<void*>&self.j1eta_JetEC2Up_value)

        #print "making j1eta_JetEC2yearDown"
        self.j1eta_JetEC2yearDown_branch = the_tree.GetBranch("j1eta_JetEC2yearDown")
        #if not self.j1eta_JetEC2yearDown_branch and "j1eta_JetEC2yearDown" not in self.complained:
        if not self.j1eta_JetEC2yearDown_branch and "j1eta_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch j1eta_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetEC2yearDown")
        else:
            self.j1eta_JetEC2yearDown_branch.SetAddress(<void*>&self.j1eta_JetEC2yearDown_value)

        #print "making j1eta_JetEC2yearUp"
        self.j1eta_JetEC2yearUp_branch = the_tree.GetBranch("j1eta_JetEC2yearUp")
        #if not self.j1eta_JetEC2yearUp_branch and "j1eta_JetEC2yearUp" not in self.complained:
        if not self.j1eta_JetEC2yearUp_branch and "j1eta_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch j1eta_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetEC2yearUp")
        else:
            self.j1eta_JetEC2yearUp_branch.SetAddress(<void*>&self.j1eta_JetEC2yearUp_value)

        #print "making j1eta_JetFlavorQCDDown"
        self.j1eta_JetFlavorQCDDown_branch = the_tree.GetBranch("j1eta_JetFlavorQCDDown")
        #if not self.j1eta_JetFlavorQCDDown_branch and "j1eta_JetFlavorQCDDown" not in self.complained:
        if not self.j1eta_JetFlavorQCDDown_branch and "j1eta_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch j1eta_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetFlavorQCDDown")
        else:
            self.j1eta_JetFlavorQCDDown_branch.SetAddress(<void*>&self.j1eta_JetFlavorQCDDown_value)

        #print "making j1eta_JetFlavorQCDUp"
        self.j1eta_JetFlavorQCDUp_branch = the_tree.GetBranch("j1eta_JetFlavorQCDUp")
        #if not self.j1eta_JetFlavorQCDUp_branch and "j1eta_JetFlavorQCDUp" not in self.complained:
        if not self.j1eta_JetFlavorQCDUp_branch and "j1eta_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch j1eta_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetFlavorQCDUp")
        else:
            self.j1eta_JetFlavorQCDUp_branch.SetAddress(<void*>&self.j1eta_JetFlavorQCDUp_value)

        #print "making j1eta_JetHFDown"
        self.j1eta_JetHFDown_branch = the_tree.GetBranch("j1eta_JetHFDown")
        #if not self.j1eta_JetHFDown_branch and "j1eta_JetHFDown" not in self.complained:
        if not self.j1eta_JetHFDown_branch and "j1eta_JetHFDown":
            warnings.warn( "EMTree: Expected branch j1eta_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetHFDown")
        else:
            self.j1eta_JetHFDown_branch.SetAddress(<void*>&self.j1eta_JetHFDown_value)

        #print "making j1eta_JetHFUp"
        self.j1eta_JetHFUp_branch = the_tree.GetBranch("j1eta_JetHFUp")
        #if not self.j1eta_JetHFUp_branch and "j1eta_JetHFUp" not in self.complained:
        if not self.j1eta_JetHFUp_branch and "j1eta_JetHFUp":
            warnings.warn( "EMTree: Expected branch j1eta_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetHFUp")
        else:
            self.j1eta_JetHFUp_branch.SetAddress(<void*>&self.j1eta_JetHFUp_value)

        #print "making j1eta_JetHFyearDown"
        self.j1eta_JetHFyearDown_branch = the_tree.GetBranch("j1eta_JetHFyearDown")
        #if not self.j1eta_JetHFyearDown_branch and "j1eta_JetHFyearDown" not in self.complained:
        if not self.j1eta_JetHFyearDown_branch and "j1eta_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch j1eta_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetHFyearDown")
        else:
            self.j1eta_JetHFyearDown_branch.SetAddress(<void*>&self.j1eta_JetHFyearDown_value)

        #print "making j1eta_JetHFyearUp"
        self.j1eta_JetHFyearUp_branch = the_tree.GetBranch("j1eta_JetHFyearUp")
        #if not self.j1eta_JetHFyearUp_branch and "j1eta_JetHFyearUp" not in self.complained:
        if not self.j1eta_JetHFyearUp_branch and "j1eta_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch j1eta_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetHFyearUp")
        else:
            self.j1eta_JetHFyearUp_branch.SetAddress(<void*>&self.j1eta_JetHFyearUp_value)

        #print "making j1eta_JetRelativeBalDown"
        self.j1eta_JetRelativeBalDown_branch = the_tree.GetBranch("j1eta_JetRelativeBalDown")
        #if not self.j1eta_JetRelativeBalDown_branch and "j1eta_JetRelativeBalDown" not in self.complained:
        if not self.j1eta_JetRelativeBalDown_branch and "j1eta_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch j1eta_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetRelativeBalDown")
        else:
            self.j1eta_JetRelativeBalDown_branch.SetAddress(<void*>&self.j1eta_JetRelativeBalDown_value)

        #print "making j1eta_JetRelativeBalUp"
        self.j1eta_JetRelativeBalUp_branch = the_tree.GetBranch("j1eta_JetRelativeBalUp")
        #if not self.j1eta_JetRelativeBalUp_branch and "j1eta_JetRelativeBalUp" not in self.complained:
        if not self.j1eta_JetRelativeBalUp_branch and "j1eta_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch j1eta_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetRelativeBalUp")
        else:
            self.j1eta_JetRelativeBalUp_branch.SetAddress(<void*>&self.j1eta_JetRelativeBalUp_value)

        #print "making j1eta_JetRelativeSampleDown"
        self.j1eta_JetRelativeSampleDown_branch = the_tree.GetBranch("j1eta_JetRelativeSampleDown")
        #if not self.j1eta_JetRelativeSampleDown_branch and "j1eta_JetRelativeSampleDown" not in self.complained:
        if not self.j1eta_JetRelativeSampleDown_branch and "j1eta_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch j1eta_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetRelativeSampleDown")
        else:
            self.j1eta_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j1eta_JetRelativeSampleDown_value)

        #print "making j1eta_JetRelativeSampleUp"
        self.j1eta_JetRelativeSampleUp_branch = the_tree.GetBranch("j1eta_JetRelativeSampleUp")
        #if not self.j1eta_JetRelativeSampleUp_branch and "j1eta_JetRelativeSampleUp" not in self.complained:
        if not self.j1eta_JetRelativeSampleUp_branch and "j1eta_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch j1eta_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta_JetRelativeSampleUp")
        else:
            self.j1eta_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j1eta_JetRelativeSampleUp_value)

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

        #print "making j1phi_JERDown"
        self.j1phi_JERDown_branch = the_tree.GetBranch("j1phi_JERDown")
        #if not self.j1phi_JERDown_branch and "j1phi_JERDown" not in self.complained:
        if not self.j1phi_JERDown_branch and "j1phi_JERDown":
            warnings.warn( "EMTree: Expected branch j1phi_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JERDown")
        else:
            self.j1phi_JERDown_branch.SetAddress(<void*>&self.j1phi_JERDown_value)

        #print "making j1phi_JERUp"
        self.j1phi_JERUp_branch = the_tree.GetBranch("j1phi_JERUp")
        #if not self.j1phi_JERUp_branch and "j1phi_JERUp" not in self.complained:
        if not self.j1phi_JERUp_branch and "j1phi_JERUp":
            warnings.warn( "EMTree: Expected branch j1phi_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JERUp")
        else:
            self.j1phi_JERUp_branch.SetAddress(<void*>&self.j1phi_JERUp_value)

        #print "making j1phi_JetAbsoluteDown"
        self.j1phi_JetAbsoluteDown_branch = the_tree.GetBranch("j1phi_JetAbsoluteDown")
        #if not self.j1phi_JetAbsoluteDown_branch and "j1phi_JetAbsoluteDown" not in self.complained:
        if not self.j1phi_JetAbsoluteDown_branch and "j1phi_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch j1phi_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetAbsoluteDown")
        else:
            self.j1phi_JetAbsoluteDown_branch.SetAddress(<void*>&self.j1phi_JetAbsoluteDown_value)

        #print "making j1phi_JetAbsoluteUp"
        self.j1phi_JetAbsoluteUp_branch = the_tree.GetBranch("j1phi_JetAbsoluteUp")
        #if not self.j1phi_JetAbsoluteUp_branch and "j1phi_JetAbsoluteUp" not in self.complained:
        if not self.j1phi_JetAbsoluteUp_branch and "j1phi_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch j1phi_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetAbsoluteUp")
        else:
            self.j1phi_JetAbsoluteUp_branch.SetAddress(<void*>&self.j1phi_JetAbsoluteUp_value)

        #print "making j1phi_JetAbsoluteyearDown"
        self.j1phi_JetAbsoluteyearDown_branch = the_tree.GetBranch("j1phi_JetAbsoluteyearDown")
        #if not self.j1phi_JetAbsoluteyearDown_branch and "j1phi_JetAbsoluteyearDown" not in self.complained:
        if not self.j1phi_JetAbsoluteyearDown_branch and "j1phi_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch j1phi_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetAbsoluteyearDown")
        else:
            self.j1phi_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.j1phi_JetAbsoluteyearDown_value)

        #print "making j1phi_JetAbsoluteyearUp"
        self.j1phi_JetAbsoluteyearUp_branch = the_tree.GetBranch("j1phi_JetAbsoluteyearUp")
        #if not self.j1phi_JetAbsoluteyearUp_branch and "j1phi_JetAbsoluteyearUp" not in self.complained:
        if not self.j1phi_JetAbsoluteyearUp_branch and "j1phi_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch j1phi_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetAbsoluteyearUp")
        else:
            self.j1phi_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.j1phi_JetAbsoluteyearUp_value)

        #print "making j1phi_JetBBEC1Down"
        self.j1phi_JetBBEC1Down_branch = the_tree.GetBranch("j1phi_JetBBEC1Down")
        #if not self.j1phi_JetBBEC1Down_branch and "j1phi_JetBBEC1Down" not in self.complained:
        if not self.j1phi_JetBBEC1Down_branch and "j1phi_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch j1phi_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetBBEC1Down")
        else:
            self.j1phi_JetBBEC1Down_branch.SetAddress(<void*>&self.j1phi_JetBBEC1Down_value)

        #print "making j1phi_JetBBEC1Up"
        self.j1phi_JetBBEC1Up_branch = the_tree.GetBranch("j1phi_JetBBEC1Up")
        #if not self.j1phi_JetBBEC1Up_branch and "j1phi_JetBBEC1Up" not in self.complained:
        if not self.j1phi_JetBBEC1Up_branch and "j1phi_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch j1phi_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetBBEC1Up")
        else:
            self.j1phi_JetBBEC1Up_branch.SetAddress(<void*>&self.j1phi_JetBBEC1Up_value)

        #print "making j1phi_JetBBEC1yearDown"
        self.j1phi_JetBBEC1yearDown_branch = the_tree.GetBranch("j1phi_JetBBEC1yearDown")
        #if not self.j1phi_JetBBEC1yearDown_branch and "j1phi_JetBBEC1yearDown" not in self.complained:
        if not self.j1phi_JetBBEC1yearDown_branch and "j1phi_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch j1phi_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetBBEC1yearDown")
        else:
            self.j1phi_JetBBEC1yearDown_branch.SetAddress(<void*>&self.j1phi_JetBBEC1yearDown_value)

        #print "making j1phi_JetBBEC1yearUp"
        self.j1phi_JetBBEC1yearUp_branch = the_tree.GetBranch("j1phi_JetBBEC1yearUp")
        #if not self.j1phi_JetBBEC1yearUp_branch and "j1phi_JetBBEC1yearUp" not in self.complained:
        if not self.j1phi_JetBBEC1yearUp_branch and "j1phi_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch j1phi_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetBBEC1yearUp")
        else:
            self.j1phi_JetBBEC1yearUp_branch.SetAddress(<void*>&self.j1phi_JetBBEC1yearUp_value)

        #print "making j1phi_JetEC2Down"
        self.j1phi_JetEC2Down_branch = the_tree.GetBranch("j1phi_JetEC2Down")
        #if not self.j1phi_JetEC2Down_branch and "j1phi_JetEC2Down" not in self.complained:
        if not self.j1phi_JetEC2Down_branch and "j1phi_JetEC2Down":
            warnings.warn( "EMTree: Expected branch j1phi_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetEC2Down")
        else:
            self.j1phi_JetEC2Down_branch.SetAddress(<void*>&self.j1phi_JetEC2Down_value)

        #print "making j1phi_JetEC2Up"
        self.j1phi_JetEC2Up_branch = the_tree.GetBranch("j1phi_JetEC2Up")
        #if not self.j1phi_JetEC2Up_branch and "j1phi_JetEC2Up" not in self.complained:
        if not self.j1phi_JetEC2Up_branch and "j1phi_JetEC2Up":
            warnings.warn( "EMTree: Expected branch j1phi_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetEC2Up")
        else:
            self.j1phi_JetEC2Up_branch.SetAddress(<void*>&self.j1phi_JetEC2Up_value)

        #print "making j1phi_JetEC2yearDown"
        self.j1phi_JetEC2yearDown_branch = the_tree.GetBranch("j1phi_JetEC2yearDown")
        #if not self.j1phi_JetEC2yearDown_branch and "j1phi_JetEC2yearDown" not in self.complained:
        if not self.j1phi_JetEC2yearDown_branch and "j1phi_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch j1phi_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetEC2yearDown")
        else:
            self.j1phi_JetEC2yearDown_branch.SetAddress(<void*>&self.j1phi_JetEC2yearDown_value)

        #print "making j1phi_JetEC2yearUp"
        self.j1phi_JetEC2yearUp_branch = the_tree.GetBranch("j1phi_JetEC2yearUp")
        #if not self.j1phi_JetEC2yearUp_branch and "j1phi_JetEC2yearUp" not in self.complained:
        if not self.j1phi_JetEC2yearUp_branch and "j1phi_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch j1phi_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetEC2yearUp")
        else:
            self.j1phi_JetEC2yearUp_branch.SetAddress(<void*>&self.j1phi_JetEC2yearUp_value)

        #print "making j1phi_JetFlavorQCDDown"
        self.j1phi_JetFlavorQCDDown_branch = the_tree.GetBranch("j1phi_JetFlavorQCDDown")
        #if not self.j1phi_JetFlavorQCDDown_branch and "j1phi_JetFlavorQCDDown" not in self.complained:
        if not self.j1phi_JetFlavorQCDDown_branch and "j1phi_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch j1phi_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetFlavorQCDDown")
        else:
            self.j1phi_JetFlavorQCDDown_branch.SetAddress(<void*>&self.j1phi_JetFlavorQCDDown_value)

        #print "making j1phi_JetFlavorQCDUp"
        self.j1phi_JetFlavorQCDUp_branch = the_tree.GetBranch("j1phi_JetFlavorQCDUp")
        #if not self.j1phi_JetFlavorQCDUp_branch and "j1phi_JetFlavorQCDUp" not in self.complained:
        if not self.j1phi_JetFlavorQCDUp_branch and "j1phi_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch j1phi_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetFlavorQCDUp")
        else:
            self.j1phi_JetFlavorQCDUp_branch.SetAddress(<void*>&self.j1phi_JetFlavorQCDUp_value)

        #print "making j1phi_JetHFDown"
        self.j1phi_JetHFDown_branch = the_tree.GetBranch("j1phi_JetHFDown")
        #if not self.j1phi_JetHFDown_branch and "j1phi_JetHFDown" not in self.complained:
        if not self.j1phi_JetHFDown_branch and "j1phi_JetHFDown":
            warnings.warn( "EMTree: Expected branch j1phi_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetHFDown")
        else:
            self.j1phi_JetHFDown_branch.SetAddress(<void*>&self.j1phi_JetHFDown_value)

        #print "making j1phi_JetHFUp"
        self.j1phi_JetHFUp_branch = the_tree.GetBranch("j1phi_JetHFUp")
        #if not self.j1phi_JetHFUp_branch and "j1phi_JetHFUp" not in self.complained:
        if not self.j1phi_JetHFUp_branch and "j1phi_JetHFUp":
            warnings.warn( "EMTree: Expected branch j1phi_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetHFUp")
        else:
            self.j1phi_JetHFUp_branch.SetAddress(<void*>&self.j1phi_JetHFUp_value)

        #print "making j1phi_JetHFyearDown"
        self.j1phi_JetHFyearDown_branch = the_tree.GetBranch("j1phi_JetHFyearDown")
        #if not self.j1phi_JetHFyearDown_branch and "j1phi_JetHFyearDown" not in self.complained:
        if not self.j1phi_JetHFyearDown_branch and "j1phi_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch j1phi_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetHFyearDown")
        else:
            self.j1phi_JetHFyearDown_branch.SetAddress(<void*>&self.j1phi_JetHFyearDown_value)

        #print "making j1phi_JetHFyearUp"
        self.j1phi_JetHFyearUp_branch = the_tree.GetBranch("j1phi_JetHFyearUp")
        #if not self.j1phi_JetHFyearUp_branch and "j1phi_JetHFyearUp" not in self.complained:
        if not self.j1phi_JetHFyearUp_branch and "j1phi_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch j1phi_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetHFyearUp")
        else:
            self.j1phi_JetHFyearUp_branch.SetAddress(<void*>&self.j1phi_JetHFyearUp_value)

        #print "making j1phi_JetRelativeBalDown"
        self.j1phi_JetRelativeBalDown_branch = the_tree.GetBranch("j1phi_JetRelativeBalDown")
        #if not self.j1phi_JetRelativeBalDown_branch and "j1phi_JetRelativeBalDown" not in self.complained:
        if not self.j1phi_JetRelativeBalDown_branch and "j1phi_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch j1phi_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetRelativeBalDown")
        else:
            self.j1phi_JetRelativeBalDown_branch.SetAddress(<void*>&self.j1phi_JetRelativeBalDown_value)

        #print "making j1phi_JetRelativeBalUp"
        self.j1phi_JetRelativeBalUp_branch = the_tree.GetBranch("j1phi_JetRelativeBalUp")
        #if not self.j1phi_JetRelativeBalUp_branch and "j1phi_JetRelativeBalUp" not in self.complained:
        if not self.j1phi_JetRelativeBalUp_branch and "j1phi_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch j1phi_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetRelativeBalUp")
        else:
            self.j1phi_JetRelativeBalUp_branch.SetAddress(<void*>&self.j1phi_JetRelativeBalUp_value)

        #print "making j1phi_JetRelativeSampleDown"
        self.j1phi_JetRelativeSampleDown_branch = the_tree.GetBranch("j1phi_JetRelativeSampleDown")
        #if not self.j1phi_JetRelativeSampleDown_branch and "j1phi_JetRelativeSampleDown" not in self.complained:
        if not self.j1phi_JetRelativeSampleDown_branch and "j1phi_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch j1phi_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetRelativeSampleDown")
        else:
            self.j1phi_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j1phi_JetRelativeSampleDown_value)

        #print "making j1phi_JetRelativeSampleUp"
        self.j1phi_JetRelativeSampleUp_branch = the_tree.GetBranch("j1phi_JetRelativeSampleUp")
        #if not self.j1phi_JetRelativeSampleUp_branch and "j1phi_JetRelativeSampleUp" not in self.complained:
        if not self.j1phi_JetRelativeSampleUp_branch and "j1phi_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch j1phi_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi_JetRelativeSampleUp")
        else:
            self.j1phi_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j1phi_JetRelativeSampleUp_value)

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

        #print "making j1pt_JERDown"
        self.j1pt_JERDown_branch = the_tree.GetBranch("j1pt_JERDown")
        #if not self.j1pt_JERDown_branch and "j1pt_JERDown" not in self.complained:
        if not self.j1pt_JERDown_branch and "j1pt_JERDown":
            warnings.warn( "EMTree: Expected branch j1pt_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JERDown")
        else:
            self.j1pt_JERDown_branch.SetAddress(<void*>&self.j1pt_JERDown_value)

        #print "making j1pt_JERUp"
        self.j1pt_JERUp_branch = the_tree.GetBranch("j1pt_JERUp")
        #if not self.j1pt_JERUp_branch and "j1pt_JERUp" not in self.complained:
        if not self.j1pt_JERUp_branch and "j1pt_JERUp":
            warnings.warn( "EMTree: Expected branch j1pt_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JERUp")
        else:
            self.j1pt_JERUp_branch.SetAddress(<void*>&self.j1pt_JERUp_value)

        #print "making j1pt_JetAbsoluteDown"
        self.j1pt_JetAbsoluteDown_branch = the_tree.GetBranch("j1pt_JetAbsoluteDown")
        #if not self.j1pt_JetAbsoluteDown_branch and "j1pt_JetAbsoluteDown" not in self.complained:
        if not self.j1pt_JetAbsoluteDown_branch and "j1pt_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch j1pt_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetAbsoluteDown")
        else:
            self.j1pt_JetAbsoluteDown_branch.SetAddress(<void*>&self.j1pt_JetAbsoluteDown_value)

        #print "making j1pt_JetAbsoluteUp"
        self.j1pt_JetAbsoluteUp_branch = the_tree.GetBranch("j1pt_JetAbsoluteUp")
        #if not self.j1pt_JetAbsoluteUp_branch and "j1pt_JetAbsoluteUp" not in self.complained:
        if not self.j1pt_JetAbsoluteUp_branch and "j1pt_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch j1pt_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetAbsoluteUp")
        else:
            self.j1pt_JetAbsoluteUp_branch.SetAddress(<void*>&self.j1pt_JetAbsoluteUp_value)

        #print "making j1pt_JetAbsoluteyearDown"
        self.j1pt_JetAbsoluteyearDown_branch = the_tree.GetBranch("j1pt_JetAbsoluteyearDown")
        #if not self.j1pt_JetAbsoluteyearDown_branch and "j1pt_JetAbsoluteyearDown" not in self.complained:
        if not self.j1pt_JetAbsoluteyearDown_branch and "j1pt_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch j1pt_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetAbsoluteyearDown")
        else:
            self.j1pt_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.j1pt_JetAbsoluteyearDown_value)

        #print "making j1pt_JetAbsoluteyearUp"
        self.j1pt_JetAbsoluteyearUp_branch = the_tree.GetBranch("j1pt_JetAbsoluteyearUp")
        #if not self.j1pt_JetAbsoluteyearUp_branch and "j1pt_JetAbsoluteyearUp" not in self.complained:
        if not self.j1pt_JetAbsoluteyearUp_branch and "j1pt_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch j1pt_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetAbsoluteyearUp")
        else:
            self.j1pt_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.j1pt_JetAbsoluteyearUp_value)

        #print "making j1pt_JetBBEC1Down"
        self.j1pt_JetBBEC1Down_branch = the_tree.GetBranch("j1pt_JetBBEC1Down")
        #if not self.j1pt_JetBBEC1Down_branch and "j1pt_JetBBEC1Down" not in self.complained:
        if not self.j1pt_JetBBEC1Down_branch and "j1pt_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch j1pt_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetBBEC1Down")
        else:
            self.j1pt_JetBBEC1Down_branch.SetAddress(<void*>&self.j1pt_JetBBEC1Down_value)

        #print "making j1pt_JetBBEC1Up"
        self.j1pt_JetBBEC1Up_branch = the_tree.GetBranch("j1pt_JetBBEC1Up")
        #if not self.j1pt_JetBBEC1Up_branch and "j1pt_JetBBEC1Up" not in self.complained:
        if not self.j1pt_JetBBEC1Up_branch and "j1pt_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch j1pt_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetBBEC1Up")
        else:
            self.j1pt_JetBBEC1Up_branch.SetAddress(<void*>&self.j1pt_JetBBEC1Up_value)

        #print "making j1pt_JetBBEC1yearDown"
        self.j1pt_JetBBEC1yearDown_branch = the_tree.GetBranch("j1pt_JetBBEC1yearDown")
        #if not self.j1pt_JetBBEC1yearDown_branch and "j1pt_JetBBEC1yearDown" not in self.complained:
        if not self.j1pt_JetBBEC1yearDown_branch and "j1pt_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch j1pt_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetBBEC1yearDown")
        else:
            self.j1pt_JetBBEC1yearDown_branch.SetAddress(<void*>&self.j1pt_JetBBEC1yearDown_value)

        #print "making j1pt_JetBBEC1yearUp"
        self.j1pt_JetBBEC1yearUp_branch = the_tree.GetBranch("j1pt_JetBBEC1yearUp")
        #if not self.j1pt_JetBBEC1yearUp_branch and "j1pt_JetBBEC1yearUp" not in self.complained:
        if not self.j1pt_JetBBEC1yearUp_branch and "j1pt_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch j1pt_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetBBEC1yearUp")
        else:
            self.j1pt_JetBBEC1yearUp_branch.SetAddress(<void*>&self.j1pt_JetBBEC1yearUp_value)

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

        #print "making j1pt_JetEC2yearDown"
        self.j1pt_JetEC2yearDown_branch = the_tree.GetBranch("j1pt_JetEC2yearDown")
        #if not self.j1pt_JetEC2yearDown_branch and "j1pt_JetEC2yearDown" not in self.complained:
        if not self.j1pt_JetEC2yearDown_branch and "j1pt_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch j1pt_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetEC2yearDown")
        else:
            self.j1pt_JetEC2yearDown_branch.SetAddress(<void*>&self.j1pt_JetEC2yearDown_value)

        #print "making j1pt_JetEC2yearUp"
        self.j1pt_JetEC2yearUp_branch = the_tree.GetBranch("j1pt_JetEC2yearUp")
        #if not self.j1pt_JetEC2yearUp_branch and "j1pt_JetEC2yearUp" not in self.complained:
        if not self.j1pt_JetEC2yearUp_branch and "j1pt_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch j1pt_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetEC2yearUp")
        else:
            self.j1pt_JetEC2yearUp_branch.SetAddress(<void*>&self.j1pt_JetEC2yearUp_value)

        #print "making j1pt_JetFlavorQCDDown"
        self.j1pt_JetFlavorQCDDown_branch = the_tree.GetBranch("j1pt_JetFlavorQCDDown")
        #if not self.j1pt_JetFlavorQCDDown_branch and "j1pt_JetFlavorQCDDown" not in self.complained:
        if not self.j1pt_JetFlavorQCDDown_branch and "j1pt_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch j1pt_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetFlavorQCDDown")
        else:
            self.j1pt_JetFlavorQCDDown_branch.SetAddress(<void*>&self.j1pt_JetFlavorQCDDown_value)

        #print "making j1pt_JetFlavorQCDUp"
        self.j1pt_JetFlavorQCDUp_branch = the_tree.GetBranch("j1pt_JetFlavorQCDUp")
        #if not self.j1pt_JetFlavorQCDUp_branch and "j1pt_JetFlavorQCDUp" not in self.complained:
        if not self.j1pt_JetFlavorQCDUp_branch and "j1pt_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch j1pt_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetFlavorQCDUp")
        else:
            self.j1pt_JetFlavorQCDUp_branch.SetAddress(<void*>&self.j1pt_JetFlavorQCDUp_value)

        #print "making j1pt_JetHFDown"
        self.j1pt_JetHFDown_branch = the_tree.GetBranch("j1pt_JetHFDown")
        #if not self.j1pt_JetHFDown_branch and "j1pt_JetHFDown" not in self.complained:
        if not self.j1pt_JetHFDown_branch and "j1pt_JetHFDown":
            warnings.warn( "EMTree: Expected branch j1pt_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetHFDown")
        else:
            self.j1pt_JetHFDown_branch.SetAddress(<void*>&self.j1pt_JetHFDown_value)

        #print "making j1pt_JetHFUp"
        self.j1pt_JetHFUp_branch = the_tree.GetBranch("j1pt_JetHFUp")
        #if not self.j1pt_JetHFUp_branch and "j1pt_JetHFUp" not in self.complained:
        if not self.j1pt_JetHFUp_branch and "j1pt_JetHFUp":
            warnings.warn( "EMTree: Expected branch j1pt_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetHFUp")
        else:
            self.j1pt_JetHFUp_branch.SetAddress(<void*>&self.j1pt_JetHFUp_value)

        #print "making j1pt_JetHFyearDown"
        self.j1pt_JetHFyearDown_branch = the_tree.GetBranch("j1pt_JetHFyearDown")
        #if not self.j1pt_JetHFyearDown_branch and "j1pt_JetHFyearDown" not in self.complained:
        if not self.j1pt_JetHFyearDown_branch and "j1pt_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch j1pt_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetHFyearDown")
        else:
            self.j1pt_JetHFyearDown_branch.SetAddress(<void*>&self.j1pt_JetHFyearDown_value)

        #print "making j1pt_JetHFyearUp"
        self.j1pt_JetHFyearUp_branch = the_tree.GetBranch("j1pt_JetHFyearUp")
        #if not self.j1pt_JetHFyearUp_branch and "j1pt_JetHFyearUp" not in self.complained:
        if not self.j1pt_JetHFyearUp_branch and "j1pt_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch j1pt_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt_JetHFyearUp")
        else:
            self.j1pt_JetHFyearUp_branch.SetAddress(<void*>&self.j1pt_JetHFyearUp_value)

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

        #print "making j2eta_JERDown"
        self.j2eta_JERDown_branch = the_tree.GetBranch("j2eta_JERDown")
        #if not self.j2eta_JERDown_branch and "j2eta_JERDown" not in self.complained:
        if not self.j2eta_JERDown_branch and "j2eta_JERDown":
            warnings.warn( "EMTree: Expected branch j2eta_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JERDown")
        else:
            self.j2eta_JERDown_branch.SetAddress(<void*>&self.j2eta_JERDown_value)

        #print "making j2eta_JERUp"
        self.j2eta_JERUp_branch = the_tree.GetBranch("j2eta_JERUp")
        #if not self.j2eta_JERUp_branch and "j2eta_JERUp" not in self.complained:
        if not self.j2eta_JERUp_branch and "j2eta_JERUp":
            warnings.warn( "EMTree: Expected branch j2eta_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JERUp")
        else:
            self.j2eta_JERUp_branch.SetAddress(<void*>&self.j2eta_JERUp_value)

        #print "making j2eta_JetAbsoluteDown"
        self.j2eta_JetAbsoluteDown_branch = the_tree.GetBranch("j2eta_JetAbsoluteDown")
        #if not self.j2eta_JetAbsoluteDown_branch and "j2eta_JetAbsoluteDown" not in self.complained:
        if not self.j2eta_JetAbsoluteDown_branch and "j2eta_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch j2eta_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetAbsoluteDown")
        else:
            self.j2eta_JetAbsoluteDown_branch.SetAddress(<void*>&self.j2eta_JetAbsoluteDown_value)

        #print "making j2eta_JetAbsoluteUp"
        self.j2eta_JetAbsoluteUp_branch = the_tree.GetBranch("j2eta_JetAbsoluteUp")
        #if not self.j2eta_JetAbsoluteUp_branch and "j2eta_JetAbsoluteUp" not in self.complained:
        if not self.j2eta_JetAbsoluteUp_branch and "j2eta_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch j2eta_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetAbsoluteUp")
        else:
            self.j2eta_JetAbsoluteUp_branch.SetAddress(<void*>&self.j2eta_JetAbsoluteUp_value)

        #print "making j2eta_JetAbsoluteyearDown"
        self.j2eta_JetAbsoluteyearDown_branch = the_tree.GetBranch("j2eta_JetAbsoluteyearDown")
        #if not self.j2eta_JetAbsoluteyearDown_branch and "j2eta_JetAbsoluteyearDown" not in self.complained:
        if not self.j2eta_JetAbsoluteyearDown_branch and "j2eta_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch j2eta_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetAbsoluteyearDown")
        else:
            self.j2eta_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.j2eta_JetAbsoluteyearDown_value)

        #print "making j2eta_JetAbsoluteyearUp"
        self.j2eta_JetAbsoluteyearUp_branch = the_tree.GetBranch("j2eta_JetAbsoluteyearUp")
        #if not self.j2eta_JetAbsoluteyearUp_branch and "j2eta_JetAbsoluteyearUp" not in self.complained:
        if not self.j2eta_JetAbsoluteyearUp_branch and "j2eta_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch j2eta_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetAbsoluteyearUp")
        else:
            self.j2eta_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.j2eta_JetAbsoluteyearUp_value)

        #print "making j2eta_JetBBEC1Down"
        self.j2eta_JetBBEC1Down_branch = the_tree.GetBranch("j2eta_JetBBEC1Down")
        #if not self.j2eta_JetBBEC1Down_branch and "j2eta_JetBBEC1Down" not in self.complained:
        if not self.j2eta_JetBBEC1Down_branch and "j2eta_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch j2eta_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetBBEC1Down")
        else:
            self.j2eta_JetBBEC1Down_branch.SetAddress(<void*>&self.j2eta_JetBBEC1Down_value)

        #print "making j2eta_JetBBEC1Up"
        self.j2eta_JetBBEC1Up_branch = the_tree.GetBranch("j2eta_JetBBEC1Up")
        #if not self.j2eta_JetBBEC1Up_branch and "j2eta_JetBBEC1Up" not in self.complained:
        if not self.j2eta_JetBBEC1Up_branch and "j2eta_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch j2eta_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetBBEC1Up")
        else:
            self.j2eta_JetBBEC1Up_branch.SetAddress(<void*>&self.j2eta_JetBBEC1Up_value)

        #print "making j2eta_JetBBEC1yearDown"
        self.j2eta_JetBBEC1yearDown_branch = the_tree.GetBranch("j2eta_JetBBEC1yearDown")
        #if not self.j2eta_JetBBEC1yearDown_branch and "j2eta_JetBBEC1yearDown" not in self.complained:
        if not self.j2eta_JetBBEC1yearDown_branch and "j2eta_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch j2eta_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetBBEC1yearDown")
        else:
            self.j2eta_JetBBEC1yearDown_branch.SetAddress(<void*>&self.j2eta_JetBBEC1yearDown_value)

        #print "making j2eta_JetBBEC1yearUp"
        self.j2eta_JetBBEC1yearUp_branch = the_tree.GetBranch("j2eta_JetBBEC1yearUp")
        #if not self.j2eta_JetBBEC1yearUp_branch and "j2eta_JetBBEC1yearUp" not in self.complained:
        if not self.j2eta_JetBBEC1yearUp_branch and "j2eta_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch j2eta_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetBBEC1yearUp")
        else:
            self.j2eta_JetBBEC1yearUp_branch.SetAddress(<void*>&self.j2eta_JetBBEC1yearUp_value)

        #print "making j2eta_JetEC2Down"
        self.j2eta_JetEC2Down_branch = the_tree.GetBranch("j2eta_JetEC2Down")
        #if not self.j2eta_JetEC2Down_branch and "j2eta_JetEC2Down" not in self.complained:
        if not self.j2eta_JetEC2Down_branch and "j2eta_JetEC2Down":
            warnings.warn( "EMTree: Expected branch j2eta_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetEC2Down")
        else:
            self.j2eta_JetEC2Down_branch.SetAddress(<void*>&self.j2eta_JetEC2Down_value)

        #print "making j2eta_JetEC2Up"
        self.j2eta_JetEC2Up_branch = the_tree.GetBranch("j2eta_JetEC2Up")
        #if not self.j2eta_JetEC2Up_branch and "j2eta_JetEC2Up" not in self.complained:
        if not self.j2eta_JetEC2Up_branch and "j2eta_JetEC2Up":
            warnings.warn( "EMTree: Expected branch j2eta_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetEC2Up")
        else:
            self.j2eta_JetEC2Up_branch.SetAddress(<void*>&self.j2eta_JetEC2Up_value)

        #print "making j2eta_JetEC2yearDown"
        self.j2eta_JetEC2yearDown_branch = the_tree.GetBranch("j2eta_JetEC2yearDown")
        #if not self.j2eta_JetEC2yearDown_branch and "j2eta_JetEC2yearDown" not in self.complained:
        if not self.j2eta_JetEC2yearDown_branch and "j2eta_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch j2eta_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetEC2yearDown")
        else:
            self.j2eta_JetEC2yearDown_branch.SetAddress(<void*>&self.j2eta_JetEC2yearDown_value)

        #print "making j2eta_JetEC2yearUp"
        self.j2eta_JetEC2yearUp_branch = the_tree.GetBranch("j2eta_JetEC2yearUp")
        #if not self.j2eta_JetEC2yearUp_branch and "j2eta_JetEC2yearUp" not in self.complained:
        if not self.j2eta_JetEC2yearUp_branch and "j2eta_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch j2eta_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetEC2yearUp")
        else:
            self.j2eta_JetEC2yearUp_branch.SetAddress(<void*>&self.j2eta_JetEC2yearUp_value)

        #print "making j2eta_JetFlavorQCDDown"
        self.j2eta_JetFlavorQCDDown_branch = the_tree.GetBranch("j2eta_JetFlavorQCDDown")
        #if not self.j2eta_JetFlavorQCDDown_branch and "j2eta_JetFlavorQCDDown" not in self.complained:
        if not self.j2eta_JetFlavorQCDDown_branch and "j2eta_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch j2eta_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetFlavorQCDDown")
        else:
            self.j2eta_JetFlavorQCDDown_branch.SetAddress(<void*>&self.j2eta_JetFlavorQCDDown_value)

        #print "making j2eta_JetFlavorQCDUp"
        self.j2eta_JetFlavorQCDUp_branch = the_tree.GetBranch("j2eta_JetFlavorQCDUp")
        #if not self.j2eta_JetFlavorQCDUp_branch and "j2eta_JetFlavorQCDUp" not in self.complained:
        if not self.j2eta_JetFlavorQCDUp_branch and "j2eta_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch j2eta_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetFlavorQCDUp")
        else:
            self.j2eta_JetFlavorQCDUp_branch.SetAddress(<void*>&self.j2eta_JetFlavorQCDUp_value)

        #print "making j2eta_JetHFDown"
        self.j2eta_JetHFDown_branch = the_tree.GetBranch("j2eta_JetHFDown")
        #if not self.j2eta_JetHFDown_branch and "j2eta_JetHFDown" not in self.complained:
        if not self.j2eta_JetHFDown_branch and "j2eta_JetHFDown":
            warnings.warn( "EMTree: Expected branch j2eta_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetHFDown")
        else:
            self.j2eta_JetHFDown_branch.SetAddress(<void*>&self.j2eta_JetHFDown_value)

        #print "making j2eta_JetHFUp"
        self.j2eta_JetHFUp_branch = the_tree.GetBranch("j2eta_JetHFUp")
        #if not self.j2eta_JetHFUp_branch and "j2eta_JetHFUp" not in self.complained:
        if not self.j2eta_JetHFUp_branch and "j2eta_JetHFUp":
            warnings.warn( "EMTree: Expected branch j2eta_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetHFUp")
        else:
            self.j2eta_JetHFUp_branch.SetAddress(<void*>&self.j2eta_JetHFUp_value)

        #print "making j2eta_JetHFyearDown"
        self.j2eta_JetHFyearDown_branch = the_tree.GetBranch("j2eta_JetHFyearDown")
        #if not self.j2eta_JetHFyearDown_branch and "j2eta_JetHFyearDown" not in self.complained:
        if not self.j2eta_JetHFyearDown_branch and "j2eta_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch j2eta_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetHFyearDown")
        else:
            self.j2eta_JetHFyearDown_branch.SetAddress(<void*>&self.j2eta_JetHFyearDown_value)

        #print "making j2eta_JetHFyearUp"
        self.j2eta_JetHFyearUp_branch = the_tree.GetBranch("j2eta_JetHFyearUp")
        #if not self.j2eta_JetHFyearUp_branch and "j2eta_JetHFyearUp" not in self.complained:
        if not self.j2eta_JetHFyearUp_branch and "j2eta_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch j2eta_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetHFyearUp")
        else:
            self.j2eta_JetHFyearUp_branch.SetAddress(<void*>&self.j2eta_JetHFyearUp_value)

        #print "making j2eta_JetRelativeBalDown"
        self.j2eta_JetRelativeBalDown_branch = the_tree.GetBranch("j2eta_JetRelativeBalDown")
        #if not self.j2eta_JetRelativeBalDown_branch and "j2eta_JetRelativeBalDown" not in self.complained:
        if not self.j2eta_JetRelativeBalDown_branch and "j2eta_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch j2eta_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetRelativeBalDown")
        else:
            self.j2eta_JetRelativeBalDown_branch.SetAddress(<void*>&self.j2eta_JetRelativeBalDown_value)

        #print "making j2eta_JetRelativeBalUp"
        self.j2eta_JetRelativeBalUp_branch = the_tree.GetBranch("j2eta_JetRelativeBalUp")
        #if not self.j2eta_JetRelativeBalUp_branch and "j2eta_JetRelativeBalUp" not in self.complained:
        if not self.j2eta_JetRelativeBalUp_branch and "j2eta_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch j2eta_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetRelativeBalUp")
        else:
            self.j2eta_JetRelativeBalUp_branch.SetAddress(<void*>&self.j2eta_JetRelativeBalUp_value)

        #print "making j2eta_JetRelativeSampleDown"
        self.j2eta_JetRelativeSampleDown_branch = the_tree.GetBranch("j2eta_JetRelativeSampleDown")
        #if not self.j2eta_JetRelativeSampleDown_branch and "j2eta_JetRelativeSampleDown" not in self.complained:
        if not self.j2eta_JetRelativeSampleDown_branch and "j2eta_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch j2eta_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetRelativeSampleDown")
        else:
            self.j2eta_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j2eta_JetRelativeSampleDown_value)

        #print "making j2eta_JetRelativeSampleUp"
        self.j2eta_JetRelativeSampleUp_branch = the_tree.GetBranch("j2eta_JetRelativeSampleUp")
        #if not self.j2eta_JetRelativeSampleUp_branch and "j2eta_JetRelativeSampleUp" not in self.complained:
        if not self.j2eta_JetRelativeSampleUp_branch and "j2eta_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch j2eta_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta_JetRelativeSampleUp")
        else:
            self.j2eta_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j2eta_JetRelativeSampleUp_value)

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

        #print "making j2phi_JERDown"
        self.j2phi_JERDown_branch = the_tree.GetBranch("j2phi_JERDown")
        #if not self.j2phi_JERDown_branch and "j2phi_JERDown" not in self.complained:
        if not self.j2phi_JERDown_branch and "j2phi_JERDown":
            warnings.warn( "EMTree: Expected branch j2phi_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JERDown")
        else:
            self.j2phi_JERDown_branch.SetAddress(<void*>&self.j2phi_JERDown_value)

        #print "making j2phi_JERUp"
        self.j2phi_JERUp_branch = the_tree.GetBranch("j2phi_JERUp")
        #if not self.j2phi_JERUp_branch and "j2phi_JERUp" not in self.complained:
        if not self.j2phi_JERUp_branch and "j2phi_JERUp":
            warnings.warn( "EMTree: Expected branch j2phi_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JERUp")
        else:
            self.j2phi_JERUp_branch.SetAddress(<void*>&self.j2phi_JERUp_value)

        #print "making j2phi_JetAbsoluteDown"
        self.j2phi_JetAbsoluteDown_branch = the_tree.GetBranch("j2phi_JetAbsoluteDown")
        #if not self.j2phi_JetAbsoluteDown_branch and "j2phi_JetAbsoluteDown" not in self.complained:
        if not self.j2phi_JetAbsoluteDown_branch and "j2phi_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch j2phi_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetAbsoluteDown")
        else:
            self.j2phi_JetAbsoluteDown_branch.SetAddress(<void*>&self.j2phi_JetAbsoluteDown_value)

        #print "making j2phi_JetAbsoluteUp"
        self.j2phi_JetAbsoluteUp_branch = the_tree.GetBranch("j2phi_JetAbsoluteUp")
        #if not self.j2phi_JetAbsoluteUp_branch and "j2phi_JetAbsoluteUp" not in self.complained:
        if not self.j2phi_JetAbsoluteUp_branch and "j2phi_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch j2phi_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetAbsoluteUp")
        else:
            self.j2phi_JetAbsoluteUp_branch.SetAddress(<void*>&self.j2phi_JetAbsoluteUp_value)

        #print "making j2phi_JetAbsoluteyearDown"
        self.j2phi_JetAbsoluteyearDown_branch = the_tree.GetBranch("j2phi_JetAbsoluteyearDown")
        #if not self.j2phi_JetAbsoluteyearDown_branch and "j2phi_JetAbsoluteyearDown" not in self.complained:
        if not self.j2phi_JetAbsoluteyearDown_branch and "j2phi_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch j2phi_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetAbsoluteyearDown")
        else:
            self.j2phi_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.j2phi_JetAbsoluteyearDown_value)

        #print "making j2phi_JetAbsoluteyearUp"
        self.j2phi_JetAbsoluteyearUp_branch = the_tree.GetBranch("j2phi_JetAbsoluteyearUp")
        #if not self.j2phi_JetAbsoluteyearUp_branch and "j2phi_JetAbsoluteyearUp" not in self.complained:
        if not self.j2phi_JetAbsoluteyearUp_branch and "j2phi_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch j2phi_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetAbsoluteyearUp")
        else:
            self.j2phi_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.j2phi_JetAbsoluteyearUp_value)

        #print "making j2phi_JetBBEC1Down"
        self.j2phi_JetBBEC1Down_branch = the_tree.GetBranch("j2phi_JetBBEC1Down")
        #if not self.j2phi_JetBBEC1Down_branch and "j2phi_JetBBEC1Down" not in self.complained:
        if not self.j2phi_JetBBEC1Down_branch and "j2phi_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch j2phi_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetBBEC1Down")
        else:
            self.j2phi_JetBBEC1Down_branch.SetAddress(<void*>&self.j2phi_JetBBEC1Down_value)

        #print "making j2phi_JetBBEC1Up"
        self.j2phi_JetBBEC1Up_branch = the_tree.GetBranch("j2phi_JetBBEC1Up")
        #if not self.j2phi_JetBBEC1Up_branch and "j2phi_JetBBEC1Up" not in self.complained:
        if not self.j2phi_JetBBEC1Up_branch and "j2phi_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch j2phi_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetBBEC1Up")
        else:
            self.j2phi_JetBBEC1Up_branch.SetAddress(<void*>&self.j2phi_JetBBEC1Up_value)

        #print "making j2phi_JetBBEC1yearDown"
        self.j2phi_JetBBEC1yearDown_branch = the_tree.GetBranch("j2phi_JetBBEC1yearDown")
        #if not self.j2phi_JetBBEC1yearDown_branch and "j2phi_JetBBEC1yearDown" not in self.complained:
        if not self.j2phi_JetBBEC1yearDown_branch and "j2phi_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch j2phi_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetBBEC1yearDown")
        else:
            self.j2phi_JetBBEC1yearDown_branch.SetAddress(<void*>&self.j2phi_JetBBEC1yearDown_value)

        #print "making j2phi_JetBBEC1yearUp"
        self.j2phi_JetBBEC1yearUp_branch = the_tree.GetBranch("j2phi_JetBBEC1yearUp")
        #if not self.j2phi_JetBBEC1yearUp_branch and "j2phi_JetBBEC1yearUp" not in self.complained:
        if not self.j2phi_JetBBEC1yearUp_branch and "j2phi_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch j2phi_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetBBEC1yearUp")
        else:
            self.j2phi_JetBBEC1yearUp_branch.SetAddress(<void*>&self.j2phi_JetBBEC1yearUp_value)

        #print "making j2phi_JetEC2Down"
        self.j2phi_JetEC2Down_branch = the_tree.GetBranch("j2phi_JetEC2Down")
        #if not self.j2phi_JetEC2Down_branch and "j2phi_JetEC2Down" not in self.complained:
        if not self.j2phi_JetEC2Down_branch and "j2phi_JetEC2Down":
            warnings.warn( "EMTree: Expected branch j2phi_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetEC2Down")
        else:
            self.j2phi_JetEC2Down_branch.SetAddress(<void*>&self.j2phi_JetEC2Down_value)

        #print "making j2phi_JetEC2Up"
        self.j2phi_JetEC2Up_branch = the_tree.GetBranch("j2phi_JetEC2Up")
        #if not self.j2phi_JetEC2Up_branch and "j2phi_JetEC2Up" not in self.complained:
        if not self.j2phi_JetEC2Up_branch and "j2phi_JetEC2Up":
            warnings.warn( "EMTree: Expected branch j2phi_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetEC2Up")
        else:
            self.j2phi_JetEC2Up_branch.SetAddress(<void*>&self.j2phi_JetEC2Up_value)

        #print "making j2phi_JetEC2yearDown"
        self.j2phi_JetEC2yearDown_branch = the_tree.GetBranch("j2phi_JetEC2yearDown")
        #if not self.j2phi_JetEC2yearDown_branch and "j2phi_JetEC2yearDown" not in self.complained:
        if not self.j2phi_JetEC2yearDown_branch and "j2phi_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch j2phi_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetEC2yearDown")
        else:
            self.j2phi_JetEC2yearDown_branch.SetAddress(<void*>&self.j2phi_JetEC2yearDown_value)

        #print "making j2phi_JetEC2yearUp"
        self.j2phi_JetEC2yearUp_branch = the_tree.GetBranch("j2phi_JetEC2yearUp")
        #if not self.j2phi_JetEC2yearUp_branch and "j2phi_JetEC2yearUp" not in self.complained:
        if not self.j2phi_JetEC2yearUp_branch and "j2phi_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch j2phi_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetEC2yearUp")
        else:
            self.j2phi_JetEC2yearUp_branch.SetAddress(<void*>&self.j2phi_JetEC2yearUp_value)

        #print "making j2phi_JetFlavorQCDDown"
        self.j2phi_JetFlavorQCDDown_branch = the_tree.GetBranch("j2phi_JetFlavorQCDDown")
        #if not self.j2phi_JetFlavorQCDDown_branch and "j2phi_JetFlavorQCDDown" not in self.complained:
        if not self.j2phi_JetFlavorQCDDown_branch and "j2phi_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch j2phi_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetFlavorQCDDown")
        else:
            self.j2phi_JetFlavorQCDDown_branch.SetAddress(<void*>&self.j2phi_JetFlavorQCDDown_value)

        #print "making j2phi_JetFlavorQCDUp"
        self.j2phi_JetFlavorQCDUp_branch = the_tree.GetBranch("j2phi_JetFlavorQCDUp")
        #if not self.j2phi_JetFlavorQCDUp_branch and "j2phi_JetFlavorQCDUp" not in self.complained:
        if not self.j2phi_JetFlavorQCDUp_branch and "j2phi_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch j2phi_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetFlavorQCDUp")
        else:
            self.j2phi_JetFlavorQCDUp_branch.SetAddress(<void*>&self.j2phi_JetFlavorQCDUp_value)

        #print "making j2phi_JetHFDown"
        self.j2phi_JetHFDown_branch = the_tree.GetBranch("j2phi_JetHFDown")
        #if not self.j2phi_JetHFDown_branch and "j2phi_JetHFDown" not in self.complained:
        if not self.j2phi_JetHFDown_branch and "j2phi_JetHFDown":
            warnings.warn( "EMTree: Expected branch j2phi_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetHFDown")
        else:
            self.j2phi_JetHFDown_branch.SetAddress(<void*>&self.j2phi_JetHFDown_value)

        #print "making j2phi_JetHFUp"
        self.j2phi_JetHFUp_branch = the_tree.GetBranch("j2phi_JetHFUp")
        #if not self.j2phi_JetHFUp_branch and "j2phi_JetHFUp" not in self.complained:
        if not self.j2phi_JetHFUp_branch and "j2phi_JetHFUp":
            warnings.warn( "EMTree: Expected branch j2phi_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetHFUp")
        else:
            self.j2phi_JetHFUp_branch.SetAddress(<void*>&self.j2phi_JetHFUp_value)

        #print "making j2phi_JetHFyearDown"
        self.j2phi_JetHFyearDown_branch = the_tree.GetBranch("j2phi_JetHFyearDown")
        #if not self.j2phi_JetHFyearDown_branch and "j2phi_JetHFyearDown" not in self.complained:
        if not self.j2phi_JetHFyearDown_branch and "j2phi_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch j2phi_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetHFyearDown")
        else:
            self.j2phi_JetHFyearDown_branch.SetAddress(<void*>&self.j2phi_JetHFyearDown_value)

        #print "making j2phi_JetHFyearUp"
        self.j2phi_JetHFyearUp_branch = the_tree.GetBranch("j2phi_JetHFyearUp")
        #if not self.j2phi_JetHFyearUp_branch and "j2phi_JetHFyearUp" not in self.complained:
        if not self.j2phi_JetHFyearUp_branch and "j2phi_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch j2phi_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetHFyearUp")
        else:
            self.j2phi_JetHFyearUp_branch.SetAddress(<void*>&self.j2phi_JetHFyearUp_value)

        #print "making j2phi_JetRelativeBalDown"
        self.j2phi_JetRelativeBalDown_branch = the_tree.GetBranch("j2phi_JetRelativeBalDown")
        #if not self.j2phi_JetRelativeBalDown_branch and "j2phi_JetRelativeBalDown" not in self.complained:
        if not self.j2phi_JetRelativeBalDown_branch and "j2phi_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch j2phi_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetRelativeBalDown")
        else:
            self.j2phi_JetRelativeBalDown_branch.SetAddress(<void*>&self.j2phi_JetRelativeBalDown_value)

        #print "making j2phi_JetRelativeBalUp"
        self.j2phi_JetRelativeBalUp_branch = the_tree.GetBranch("j2phi_JetRelativeBalUp")
        #if not self.j2phi_JetRelativeBalUp_branch and "j2phi_JetRelativeBalUp" not in self.complained:
        if not self.j2phi_JetRelativeBalUp_branch and "j2phi_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch j2phi_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetRelativeBalUp")
        else:
            self.j2phi_JetRelativeBalUp_branch.SetAddress(<void*>&self.j2phi_JetRelativeBalUp_value)

        #print "making j2phi_JetRelativeSampleDown"
        self.j2phi_JetRelativeSampleDown_branch = the_tree.GetBranch("j2phi_JetRelativeSampleDown")
        #if not self.j2phi_JetRelativeSampleDown_branch and "j2phi_JetRelativeSampleDown" not in self.complained:
        if not self.j2phi_JetRelativeSampleDown_branch and "j2phi_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch j2phi_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetRelativeSampleDown")
        else:
            self.j2phi_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j2phi_JetRelativeSampleDown_value)

        #print "making j2phi_JetRelativeSampleUp"
        self.j2phi_JetRelativeSampleUp_branch = the_tree.GetBranch("j2phi_JetRelativeSampleUp")
        #if not self.j2phi_JetRelativeSampleUp_branch and "j2phi_JetRelativeSampleUp" not in self.complained:
        if not self.j2phi_JetRelativeSampleUp_branch and "j2phi_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch j2phi_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi_JetRelativeSampleUp")
        else:
            self.j2phi_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j2phi_JetRelativeSampleUp_value)

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

        #print "making j2pt_JERDown"
        self.j2pt_JERDown_branch = the_tree.GetBranch("j2pt_JERDown")
        #if not self.j2pt_JERDown_branch and "j2pt_JERDown" not in self.complained:
        if not self.j2pt_JERDown_branch and "j2pt_JERDown":
            warnings.warn( "EMTree: Expected branch j2pt_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JERDown")
        else:
            self.j2pt_JERDown_branch.SetAddress(<void*>&self.j2pt_JERDown_value)

        #print "making j2pt_JERUp"
        self.j2pt_JERUp_branch = the_tree.GetBranch("j2pt_JERUp")
        #if not self.j2pt_JERUp_branch and "j2pt_JERUp" not in self.complained:
        if not self.j2pt_JERUp_branch and "j2pt_JERUp":
            warnings.warn( "EMTree: Expected branch j2pt_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JERUp")
        else:
            self.j2pt_JERUp_branch.SetAddress(<void*>&self.j2pt_JERUp_value)

        #print "making j2pt_JetAbsoluteDown"
        self.j2pt_JetAbsoluteDown_branch = the_tree.GetBranch("j2pt_JetAbsoluteDown")
        #if not self.j2pt_JetAbsoluteDown_branch and "j2pt_JetAbsoluteDown" not in self.complained:
        if not self.j2pt_JetAbsoluteDown_branch and "j2pt_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch j2pt_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetAbsoluteDown")
        else:
            self.j2pt_JetAbsoluteDown_branch.SetAddress(<void*>&self.j2pt_JetAbsoluteDown_value)

        #print "making j2pt_JetAbsoluteUp"
        self.j2pt_JetAbsoluteUp_branch = the_tree.GetBranch("j2pt_JetAbsoluteUp")
        #if not self.j2pt_JetAbsoluteUp_branch and "j2pt_JetAbsoluteUp" not in self.complained:
        if not self.j2pt_JetAbsoluteUp_branch and "j2pt_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch j2pt_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetAbsoluteUp")
        else:
            self.j2pt_JetAbsoluteUp_branch.SetAddress(<void*>&self.j2pt_JetAbsoluteUp_value)

        #print "making j2pt_JetAbsoluteyearDown"
        self.j2pt_JetAbsoluteyearDown_branch = the_tree.GetBranch("j2pt_JetAbsoluteyearDown")
        #if not self.j2pt_JetAbsoluteyearDown_branch and "j2pt_JetAbsoluteyearDown" not in self.complained:
        if not self.j2pt_JetAbsoluteyearDown_branch and "j2pt_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch j2pt_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetAbsoluteyearDown")
        else:
            self.j2pt_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.j2pt_JetAbsoluteyearDown_value)

        #print "making j2pt_JetAbsoluteyearUp"
        self.j2pt_JetAbsoluteyearUp_branch = the_tree.GetBranch("j2pt_JetAbsoluteyearUp")
        #if not self.j2pt_JetAbsoluteyearUp_branch and "j2pt_JetAbsoluteyearUp" not in self.complained:
        if not self.j2pt_JetAbsoluteyearUp_branch and "j2pt_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch j2pt_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetAbsoluteyearUp")
        else:
            self.j2pt_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.j2pt_JetAbsoluteyearUp_value)

        #print "making j2pt_JetBBEC1Down"
        self.j2pt_JetBBEC1Down_branch = the_tree.GetBranch("j2pt_JetBBEC1Down")
        #if not self.j2pt_JetBBEC1Down_branch and "j2pt_JetBBEC1Down" not in self.complained:
        if not self.j2pt_JetBBEC1Down_branch and "j2pt_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch j2pt_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetBBEC1Down")
        else:
            self.j2pt_JetBBEC1Down_branch.SetAddress(<void*>&self.j2pt_JetBBEC1Down_value)

        #print "making j2pt_JetBBEC1Up"
        self.j2pt_JetBBEC1Up_branch = the_tree.GetBranch("j2pt_JetBBEC1Up")
        #if not self.j2pt_JetBBEC1Up_branch and "j2pt_JetBBEC1Up" not in self.complained:
        if not self.j2pt_JetBBEC1Up_branch and "j2pt_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch j2pt_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetBBEC1Up")
        else:
            self.j2pt_JetBBEC1Up_branch.SetAddress(<void*>&self.j2pt_JetBBEC1Up_value)

        #print "making j2pt_JetBBEC1yearDown"
        self.j2pt_JetBBEC1yearDown_branch = the_tree.GetBranch("j2pt_JetBBEC1yearDown")
        #if not self.j2pt_JetBBEC1yearDown_branch and "j2pt_JetBBEC1yearDown" not in self.complained:
        if not self.j2pt_JetBBEC1yearDown_branch and "j2pt_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch j2pt_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetBBEC1yearDown")
        else:
            self.j2pt_JetBBEC1yearDown_branch.SetAddress(<void*>&self.j2pt_JetBBEC1yearDown_value)

        #print "making j2pt_JetBBEC1yearUp"
        self.j2pt_JetBBEC1yearUp_branch = the_tree.GetBranch("j2pt_JetBBEC1yearUp")
        #if not self.j2pt_JetBBEC1yearUp_branch and "j2pt_JetBBEC1yearUp" not in self.complained:
        if not self.j2pt_JetBBEC1yearUp_branch and "j2pt_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch j2pt_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetBBEC1yearUp")
        else:
            self.j2pt_JetBBEC1yearUp_branch.SetAddress(<void*>&self.j2pt_JetBBEC1yearUp_value)

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

        #print "making j2pt_JetEC2yearDown"
        self.j2pt_JetEC2yearDown_branch = the_tree.GetBranch("j2pt_JetEC2yearDown")
        #if not self.j2pt_JetEC2yearDown_branch and "j2pt_JetEC2yearDown" not in self.complained:
        if not self.j2pt_JetEC2yearDown_branch and "j2pt_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch j2pt_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetEC2yearDown")
        else:
            self.j2pt_JetEC2yearDown_branch.SetAddress(<void*>&self.j2pt_JetEC2yearDown_value)

        #print "making j2pt_JetEC2yearUp"
        self.j2pt_JetEC2yearUp_branch = the_tree.GetBranch("j2pt_JetEC2yearUp")
        #if not self.j2pt_JetEC2yearUp_branch and "j2pt_JetEC2yearUp" not in self.complained:
        if not self.j2pt_JetEC2yearUp_branch and "j2pt_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch j2pt_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetEC2yearUp")
        else:
            self.j2pt_JetEC2yearUp_branch.SetAddress(<void*>&self.j2pt_JetEC2yearUp_value)

        #print "making j2pt_JetFlavorQCDDown"
        self.j2pt_JetFlavorQCDDown_branch = the_tree.GetBranch("j2pt_JetFlavorQCDDown")
        #if not self.j2pt_JetFlavorQCDDown_branch and "j2pt_JetFlavorQCDDown" not in self.complained:
        if not self.j2pt_JetFlavorQCDDown_branch and "j2pt_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch j2pt_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetFlavorQCDDown")
        else:
            self.j2pt_JetFlavorQCDDown_branch.SetAddress(<void*>&self.j2pt_JetFlavorQCDDown_value)

        #print "making j2pt_JetFlavorQCDUp"
        self.j2pt_JetFlavorQCDUp_branch = the_tree.GetBranch("j2pt_JetFlavorQCDUp")
        #if not self.j2pt_JetFlavorQCDUp_branch and "j2pt_JetFlavorQCDUp" not in self.complained:
        if not self.j2pt_JetFlavorQCDUp_branch and "j2pt_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch j2pt_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetFlavorQCDUp")
        else:
            self.j2pt_JetFlavorQCDUp_branch.SetAddress(<void*>&self.j2pt_JetFlavorQCDUp_value)

        #print "making j2pt_JetHFDown"
        self.j2pt_JetHFDown_branch = the_tree.GetBranch("j2pt_JetHFDown")
        #if not self.j2pt_JetHFDown_branch and "j2pt_JetHFDown" not in self.complained:
        if not self.j2pt_JetHFDown_branch and "j2pt_JetHFDown":
            warnings.warn( "EMTree: Expected branch j2pt_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetHFDown")
        else:
            self.j2pt_JetHFDown_branch.SetAddress(<void*>&self.j2pt_JetHFDown_value)

        #print "making j2pt_JetHFUp"
        self.j2pt_JetHFUp_branch = the_tree.GetBranch("j2pt_JetHFUp")
        #if not self.j2pt_JetHFUp_branch and "j2pt_JetHFUp" not in self.complained:
        if not self.j2pt_JetHFUp_branch and "j2pt_JetHFUp":
            warnings.warn( "EMTree: Expected branch j2pt_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetHFUp")
        else:
            self.j2pt_JetHFUp_branch.SetAddress(<void*>&self.j2pt_JetHFUp_value)

        #print "making j2pt_JetHFyearDown"
        self.j2pt_JetHFyearDown_branch = the_tree.GetBranch("j2pt_JetHFyearDown")
        #if not self.j2pt_JetHFyearDown_branch and "j2pt_JetHFyearDown" not in self.complained:
        if not self.j2pt_JetHFyearDown_branch and "j2pt_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch j2pt_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetHFyearDown")
        else:
            self.j2pt_JetHFyearDown_branch.SetAddress(<void*>&self.j2pt_JetHFyearDown_value)

        #print "making j2pt_JetHFyearUp"
        self.j2pt_JetHFyearUp_branch = the_tree.GetBranch("j2pt_JetHFyearUp")
        #if not self.j2pt_JetHFyearUp_branch and "j2pt_JetHFyearUp" not in self.complained:
        if not self.j2pt_JetHFyearUp_branch and "j2pt_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch j2pt_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt_JetHFyearUp")
        else:
            self.j2pt_JetHFyearUp_branch.SetAddress(<void*>&self.j2pt_JetHFyearUp_value)

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

        #print "making jetVeto30_JERDown"
        self.jetVeto30_JERDown_branch = the_tree.GetBranch("jetVeto30_JERDown")
        #if not self.jetVeto30_JERDown_branch and "jetVeto30_JERDown" not in self.complained:
        if not self.jetVeto30_JERDown_branch and "jetVeto30_JERDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JERDown")
        else:
            self.jetVeto30_JERDown_branch.SetAddress(<void*>&self.jetVeto30_JERDown_value)

        #print "making jetVeto30_JERUp"
        self.jetVeto30_JERUp_branch = the_tree.GetBranch("jetVeto30_JERUp")
        #if not self.jetVeto30_JERUp_branch and "jetVeto30_JERUp" not in self.complained:
        if not self.jetVeto30_JERUp_branch and "jetVeto30_JERUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JERUp")
        else:
            self.jetVeto30_JERUp_branch.SetAddress(<void*>&self.jetVeto30_JERUp_value)

        #print "making jetVeto30_JetAbsoluteDown"
        self.jetVeto30_JetAbsoluteDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteDown")
        #if not self.jetVeto30_JetAbsoluteDown_branch and "jetVeto30_JetAbsoluteDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteDown_branch and "jetVeto30_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteDown")
        else:
            self.jetVeto30_JetAbsoluteDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteDown_value)

        #print "making jetVeto30_JetAbsoluteUp"
        self.jetVeto30_JetAbsoluteUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteUp")
        #if not self.jetVeto30_JetAbsoluteUp_branch and "jetVeto30_JetAbsoluteUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteUp_branch and "jetVeto30_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteUp")
        else:
            self.jetVeto30_JetAbsoluteUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteUp_value)

        #print "making jetVeto30_JetAbsoluteyearDown"
        self.jetVeto30_JetAbsoluteyearDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteyearDown")
        #if not self.jetVeto30_JetAbsoluteyearDown_branch and "jetVeto30_JetAbsoluteyearDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteyearDown_branch and "jetVeto30_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteyearDown")
        else:
            self.jetVeto30_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteyearDown_value)

        #print "making jetVeto30_JetAbsoluteyearUp"
        self.jetVeto30_JetAbsoluteyearUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteyearUp")
        #if not self.jetVeto30_JetAbsoluteyearUp_branch and "jetVeto30_JetAbsoluteyearUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteyearUp_branch and "jetVeto30_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteyearUp")
        else:
            self.jetVeto30_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteyearUp_value)

        #print "making jetVeto30_JetBBEC1Down"
        self.jetVeto30_JetBBEC1Down_branch = the_tree.GetBranch("jetVeto30_JetBBEC1Down")
        #if not self.jetVeto30_JetBBEC1Down_branch and "jetVeto30_JetBBEC1Down" not in self.complained:
        if not self.jetVeto30_JetBBEC1Down_branch and "jetVeto30_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetBBEC1Down")
        else:
            self.jetVeto30_JetBBEC1Down_branch.SetAddress(<void*>&self.jetVeto30_JetBBEC1Down_value)

        #print "making jetVeto30_JetBBEC1Up"
        self.jetVeto30_JetBBEC1Up_branch = the_tree.GetBranch("jetVeto30_JetBBEC1Up")
        #if not self.jetVeto30_JetBBEC1Up_branch and "jetVeto30_JetBBEC1Up" not in self.complained:
        if not self.jetVeto30_JetBBEC1Up_branch and "jetVeto30_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetBBEC1Up")
        else:
            self.jetVeto30_JetBBEC1Up_branch.SetAddress(<void*>&self.jetVeto30_JetBBEC1Up_value)

        #print "making jetVeto30_JetBBEC1yearDown"
        self.jetVeto30_JetBBEC1yearDown_branch = the_tree.GetBranch("jetVeto30_JetBBEC1yearDown")
        #if not self.jetVeto30_JetBBEC1yearDown_branch and "jetVeto30_JetBBEC1yearDown" not in self.complained:
        if not self.jetVeto30_JetBBEC1yearDown_branch and "jetVeto30_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetBBEC1yearDown")
        else:
            self.jetVeto30_JetBBEC1yearDown_branch.SetAddress(<void*>&self.jetVeto30_JetBBEC1yearDown_value)

        #print "making jetVeto30_JetBBEC1yearUp"
        self.jetVeto30_JetBBEC1yearUp_branch = the_tree.GetBranch("jetVeto30_JetBBEC1yearUp")
        #if not self.jetVeto30_JetBBEC1yearUp_branch and "jetVeto30_JetBBEC1yearUp" not in self.complained:
        if not self.jetVeto30_JetBBEC1yearUp_branch and "jetVeto30_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetBBEC1yearUp")
        else:
            self.jetVeto30_JetBBEC1yearUp_branch.SetAddress(<void*>&self.jetVeto30_JetBBEC1yearUp_value)

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

        #print "making jetVeto30_JetEC2yearDown"
        self.jetVeto30_JetEC2yearDown_branch = the_tree.GetBranch("jetVeto30_JetEC2yearDown")
        #if not self.jetVeto30_JetEC2yearDown_branch and "jetVeto30_JetEC2yearDown" not in self.complained:
        if not self.jetVeto30_JetEC2yearDown_branch and "jetVeto30_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEC2yearDown")
        else:
            self.jetVeto30_JetEC2yearDown_branch.SetAddress(<void*>&self.jetVeto30_JetEC2yearDown_value)

        #print "making jetVeto30_JetEC2yearUp"
        self.jetVeto30_JetEC2yearUp_branch = the_tree.GetBranch("jetVeto30_JetEC2yearUp")
        #if not self.jetVeto30_JetEC2yearUp_branch and "jetVeto30_JetEC2yearUp" not in self.complained:
        if not self.jetVeto30_JetEC2yearUp_branch and "jetVeto30_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEC2yearUp")
        else:
            self.jetVeto30_JetEC2yearUp_branch.SetAddress(<void*>&self.jetVeto30_JetEC2yearUp_value)

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

        #print "making jetVeto30_JetHFDown"
        self.jetVeto30_JetHFDown_branch = the_tree.GetBranch("jetVeto30_JetHFDown")
        #if not self.jetVeto30_JetHFDown_branch and "jetVeto30_JetHFDown" not in self.complained:
        if not self.jetVeto30_JetHFDown_branch and "jetVeto30_JetHFDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetHFDown")
        else:
            self.jetVeto30_JetHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetHFDown_value)

        #print "making jetVeto30_JetHFUp"
        self.jetVeto30_JetHFUp_branch = the_tree.GetBranch("jetVeto30_JetHFUp")
        #if not self.jetVeto30_JetHFUp_branch and "jetVeto30_JetHFUp" not in self.complained:
        if not self.jetVeto30_JetHFUp_branch and "jetVeto30_JetHFUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetHFUp")
        else:
            self.jetVeto30_JetHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetHFUp_value)

        #print "making jetVeto30_JetHFyearDown"
        self.jetVeto30_JetHFyearDown_branch = the_tree.GetBranch("jetVeto30_JetHFyearDown")
        #if not self.jetVeto30_JetHFyearDown_branch and "jetVeto30_JetHFyearDown" not in self.complained:
        if not self.jetVeto30_JetHFyearDown_branch and "jetVeto30_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetHFyearDown")
        else:
            self.jetVeto30_JetHFyearDown_branch.SetAddress(<void*>&self.jetVeto30_JetHFyearDown_value)

        #print "making jetVeto30_JetHFyearUp"
        self.jetVeto30_JetHFyearUp_branch = the_tree.GetBranch("jetVeto30_JetHFyearUp")
        #if not self.jetVeto30_JetHFyearUp_branch and "jetVeto30_JetHFyearUp" not in self.complained:
        if not self.jetVeto30_JetHFyearUp_branch and "jetVeto30_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch jetVeto30_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetHFyearUp")
        else:
            self.jetVeto30_JetHFyearUp_branch.SetAddress(<void*>&self.jetVeto30_JetHFyearUp_value)

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

        #print "making lheweight0"
        self.lheweight0_branch = the_tree.GetBranch("lheweight0")
        #if not self.lheweight0_branch and "lheweight0" not in self.complained:
        if not self.lheweight0_branch and "lheweight0":
            warnings.warn( "EMTree: Expected branch lheweight0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight0")
        else:
            self.lheweight0_branch.SetAddress(<void*>&self.lheweight0_value)

        #print "making lheweight1"
        self.lheweight1_branch = the_tree.GetBranch("lheweight1")
        #if not self.lheweight1_branch and "lheweight1" not in self.complained:
        if not self.lheweight1_branch and "lheweight1":
            warnings.warn( "EMTree: Expected branch lheweight1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight1")
        else:
            self.lheweight1_branch.SetAddress(<void*>&self.lheweight1_value)

        #print "making lheweight10"
        self.lheweight10_branch = the_tree.GetBranch("lheweight10")
        #if not self.lheweight10_branch and "lheweight10" not in self.complained:
        if not self.lheweight10_branch and "lheweight10":
            warnings.warn( "EMTree: Expected branch lheweight10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight10")
        else:
            self.lheweight10_branch.SetAddress(<void*>&self.lheweight10_value)

        #print "making lheweight100"
        self.lheweight100_branch = the_tree.GetBranch("lheweight100")
        #if not self.lheweight100_branch and "lheweight100" not in self.complained:
        if not self.lheweight100_branch and "lheweight100":
            warnings.warn( "EMTree: Expected branch lheweight100 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight100")
        else:
            self.lheweight100_branch.SetAddress(<void*>&self.lheweight100_value)

        #print "making lheweight101"
        self.lheweight101_branch = the_tree.GetBranch("lheweight101")
        #if not self.lheweight101_branch and "lheweight101" not in self.complained:
        if not self.lheweight101_branch and "lheweight101":
            warnings.warn( "EMTree: Expected branch lheweight101 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight101")
        else:
            self.lheweight101_branch.SetAddress(<void*>&self.lheweight101_value)

        #print "making lheweight102"
        self.lheweight102_branch = the_tree.GetBranch("lheweight102")
        #if not self.lheweight102_branch and "lheweight102" not in self.complained:
        if not self.lheweight102_branch and "lheweight102":
            warnings.warn( "EMTree: Expected branch lheweight102 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight102")
        else:
            self.lheweight102_branch.SetAddress(<void*>&self.lheweight102_value)

        #print "making lheweight103"
        self.lheweight103_branch = the_tree.GetBranch("lheweight103")
        #if not self.lheweight103_branch and "lheweight103" not in self.complained:
        if not self.lheweight103_branch and "lheweight103":
            warnings.warn( "EMTree: Expected branch lheweight103 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight103")
        else:
            self.lheweight103_branch.SetAddress(<void*>&self.lheweight103_value)

        #print "making lheweight104"
        self.lheweight104_branch = the_tree.GetBranch("lheweight104")
        #if not self.lheweight104_branch and "lheweight104" not in self.complained:
        if not self.lheweight104_branch and "lheweight104":
            warnings.warn( "EMTree: Expected branch lheweight104 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight104")
        else:
            self.lheweight104_branch.SetAddress(<void*>&self.lheweight104_value)

        #print "making lheweight105"
        self.lheweight105_branch = the_tree.GetBranch("lheweight105")
        #if not self.lheweight105_branch and "lheweight105" not in self.complained:
        if not self.lheweight105_branch and "lheweight105":
            warnings.warn( "EMTree: Expected branch lheweight105 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight105")
        else:
            self.lheweight105_branch.SetAddress(<void*>&self.lheweight105_value)

        #print "making lheweight106"
        self.lheweight106_branch = the_tree.GetBranch("lheweight106")
        #if not self.lheweight106_branch and "lheweight106" not in self.complained:
        if not self.lheweight106_branch and "lheweight106":
            warnings.warn( "EMTree: Expected branch lheweight106 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight106")
        else:
            self.lheweight106_branch.SetAddress(<void*>&self.lheweight106_value)

        #print "making lheweight107"
        self.lheweight107_branch = the_tree.GetBranch("lheweight107")
        #if not self.lheweight107_branch and "lheweight107" not in self.complained:
        if not self.lheweight107_branch and "lheweight107":
            warnings.warn( "EMTree: Expected branch lheweight107 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight107")
        else:
            self.lheweight107_branch.SetAddress(<void*>&self.lheweight107_value)

        #print "making lheweight108"
        self.lheweight108_branch = the_tree.GetBranch("lheweight108")
        #if not self.lheweight108_branch and "lheweight108" not in self.complained:
        if not self.lheweight108_branch and "lheweight108":
            warnings.warn( "EMTree: Expected branch lheweight108 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight108")
        else:
            self.lheweight108_branch.SetAddress(<void*>&self.lheweight108_value)

        #print "making lheweight109"
        self.lheweight109_branch = the_tree.GetBranch("lheweight109")
        #if not self.lheweight109_branch and "lheweight109" not in self.complained:
        if not self.lheweight109_branch and "lheweight109":
            warnings.warn( "EMTree: Expected branch lheweight109 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight109")
        else:
            self.lheweight109_branch.SetAddress(<void*>&self.lheweight109_value)

        #print "making lheweight11"
        self.lheweight11_branch = the_tree.GetBranch("lheweight11")
        #if not self.lheweight11_branch and "lheweight11" not in self.complained:
        if not self.lheweight11_branch and "lheweight11":
            warnings.warn( "EMTree: Expected branch lheweight11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight11")
        else:
            self.lheweight11_branch.SetAddress(<void*>&self.lheweight11_value)

        #print "making lheweight110"
        self.lheweight110_branch = the_tree.GetBranch("lheweight110")
        #if not self.lheweight110_branch and "lheweight110" not in self.complained:
        if not self.lheweight110_branch and "lheweight110":
            warnings.warn( "EMTree: Expected branch lheweight110 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight110")
        else:
            self.lheweight110_branch.SetAddress(<void*>&self.lheweight110_value)

        #print "making lheweight111"
        self.lheweight111_branch = the_tree.GetBranch("lheweight111")
        #if not self.lheweight111_branch and "lheweight111" not in self.complained:
        if not self.lheweight111_branch and "lheweight111":
            warnings.warn( "EMTree: Expected branch lheweight111 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight111")
        else:
            self.lheweight111_branch.SetAddress(<void*>&self.lheweight111_value)

        #print "making lheweight112"
        self.lheweight112_branch = the_tree.GetBranch("lheweight112")
        #if not self.lheweight112_branch and "lheweight112" not in self.complained:
        if not self.lheweight112_branch and "lheweight112":
            warnings.warn( "EMTree: Expected branch lheweight112 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight112")
        else:
            self.lheweight112_branch.SetAddress(<void*>&self.lheweight112_value)

        #print "making lheweight113"
        self.lheweight113_branch = the_tree.GetBranch("lheweight113")
        #if not self.lheweight113_branch and "lheweight113" not in self.complained:
        if not self.lheweight113_branch and "lheweight113":
            warnings.warn( "EMTree: Expected branch lheweight113 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight113")
        else:
            self.lheweight113_branch.SetAddress(<void*>&self.lheweight113_value)

        #print "making lheweight114"
        self.lheweight114_branch = the_tree.GetBranch("lheweight114")
        #if not self.lheweight114_branch and "lheweight114" not in self.complained:
        if not self.lheweight114_branch and "lheweight114":
            warnings.warn( "EMTree: Expected branch lheweight114 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight114")
        else:
            self.lheweight114_branch.SetAddress(<void*>&self.lheweight114_value)

        #print "making lheweight115"
        self.lheweight115_branch = the_tree.GetBranch("lheweight115")
        #if not self.lheweight115_branch and "lheweight115" not in self.complained:
        if not self.lheweight115_branch and "lheweight115":
            warnings.warn( "EMTree: Expected branch lheweight115 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight115")
        else:
            self.lheweight115_branch.SetAddress(<void*>&self.lheweight115_value)

        #print "making lheweight116"
        self.lheweight116_branch = the_tree.GetBranch("lheweight116")
        #if not self.lheweight116_branch and "lheweight116" not in self.complained:
        if not self.lheweight116_branch and "lheweight116":
            warnings.warn( "EMTree: Expected branch lheweight116 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight116")
        else:
            self.lheweight116_branch.SetAddress(<void*>&self.lheweight116_value)

        #print "making lheweight117"
        self.lheweight117_branch = the_tree.GetBranch("lheweight117")
        #if not self.lheweight117_branch and "lheweight117" not in self.complained:
        if not self.lheweight117_branch and "lheweight117":
            warnings.warn( "EMTree: Expected branch lheweight117 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight117")
        else:
            self.lheweight117_branch.SetAddress(<void*>&self.lheweight117_value)

        #print "making lheweight118"
        self.lheweight118_branch = the_tree.GetBranch("lheweight118")
        #if not self.lheweight118_branch and "lheweight118" not in self.complained:
        if not self.lheweight118_branch and "lheweight118":
            warnings.warn( "EMTree: Expected branch lheweight118 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight118")
        else:
            self.lheweight118_branch.SetAddress(<void*>&self.lheweight118_value)

        #print "making lheweight119"
        self.lheweight119_branch = the_tree.GetBranch("lheweight119")
        #if not self.lheweight119_branch and "lheweight119" not in self.complained:
        if not self.lheweight119_branch and "lheweight119":
            warnings.warn( "EMTree: Expected branch lheweight119 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight119")
        else:
            self.lheweight119_branch.SetAddress(<void*>&self.lheweight119_value)

        #print "making lheweight12"
        self.lheweight12_branch = the_tree.GetBranch("lheweight12")
        #if not self.lheweight12_branch and "lheweight12" not in self.complained:
        if not self.lheweight12_branch and "lheweight12":
            warnings.warn( "EMTree: Expected branch lheweight12 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight12")
        else:
            self.lheweight12_branch.SetAddress(<void*>&self.lheweight12_value)

        #print "making lheweight13"
        self.lheweight13_branch = the_tree.GetBranch("lheweight13")
        #if not self.lheweight13_branch and "lheweight13" not in self.complained:
        if not self.lheweight13_branch and "lheweight13":
            warnings.warn( "EMTree: Expected branch lheweight13 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight13")
        else:
            self.lheweight13_branch.SetAddress(<void*>&self.lheweight13_value)

        #print "making lheweight14"
        self.lheweight14_branch = the_tree.GetBranch("lheweight14")
        #if not self.lheweight14_branch and "lheweight14" not in self.complained:
        if not self.lheweight14_branch and "lheweight14":
            warnings.warn( "EMTree: Expected branch lheweight14 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight14")
        else:
            self.lheweight14_branch.SetAddress(<void*>&self.lheweight14_value)

        #print "making lheweight15"
        self.lheweight15_branch = the_tree.GetBranch("lheweight15")
        #if not self.lheweight15_branch and "lheweight15" not in self.complained:
        if not self.lheweight15_branch and "lheweight15":
            warnings.warn( "EMTree: Expected branch lheweight15 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight15")
        else:
            self.lheweight15_branch.SetAddress(<void*>&self.lheweight15_value)

        #print "making lheweight16"
        self.lheweight16_branch = the_tree.GetBranch("lheweight16")
        #if not self.lheweight16_branch and "lheweight16" not in self.complained:
        if not self.lheweight16_branch and "lheweight16":
            warnings.warn( "EMTree: Expected branch lheweight16 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight16")
        else:
            self.lheweight16_branch.SetAddress(<void*>&self.lheweight16_value)

        #print "making lheweight17"
        self.lheweight17_branch = the_tree.GetBranch("lheweight17")
        #if not self.lheweight17_branch and "lheweight17" not in self.complained:
        if not self.lheweight17_branch and "lheweight17":
            warnings.warn( "EMTree: Expected branch lheweight17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight17")
        else:
            self.lheweight17_branch.SetAddress(<void*>&self.lheweight17_value)

        #print "making lheweight18"
        self.lheweight18_branch = the_tree.GetBranch("lheweight18")
        #if not self.lheweight18_branch and "lheweight18" not in self.complained:
        if not self.lheweight18_branch and "lheweight18":
            warnings.warn( "EMTree: Expected branch lheweight18 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight18")
        else:
            self.lheweight18_branch.SetAddress(<void*>&self.lheweight18_value)

        #print "making lheweight19"
        self.lheweight19_branch = the_tree.GetBranch("lheweight19")
        #if not self.lheweight19_branch and "lheweight19" not in self.complained:
        if not self.lheweight19_branch and "lheweight19":
            warnings.warn( "EMTree: Expected branch lheweight19 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight19")
        else:
            self.lheweight19_branch.SetAddress(<void*>&self.lheweight19_value)

        #print "making lheweight2"
        self.lheweight2_branch = the_tree.GetBranch("lheweight2")
        #if not self.lheweight2_branch and "lheweight2" not in self.complained:
        if not self.lheweight2_branch and "lheweight2":
            warnings.warn( "EMTree: Expected branch lheweight2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight2")
        else:
            self.lheweight2_branch.SetAddress(<void*>&self.lheweight2_value)

        #print "making lheweight20"
        self.lheweight20_branch = the_tree.GetBranch("lheweight20")
        #if not self.lheweight20_branch and "lheweight20" not in self.complained:
        if not self.lheweight20_branch and "lheweight20":
            warnings.warn( "EMTree: Expected branch lheweight20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight20")
        else:
            self.lheweight20_branch.SetAddress(<void*>&self.lheweight20_value)

        #print "making lheweight21"
        self.lheweight21_branch = the_tree.GetBranch("lheweight21")
        #if not self.lheweight21_branch and "lheweight21" not in self.complained:
        if not self.lheweight21_branch and "lheweight21":
            warnings.warn( "EMTree: Expected branch lheweight21 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight21")
        else:
            self.lheweight21_branch.SetAddress(<void*>&self.lheweight21_value)

        #print "making lheweight22"
        self.lheweight22_branch = the_tree.GetBranch("lheweight22")
        #if not self.lheweight22_branch and "lheweight22" not in self.complained:
        if not self.lheweight22_branch and "lheweight22":
            warnings.warn( "EMTree: Expected branch lheweight22 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight22")
        else:
            self.lheweight22_branch.SetAddress(<void*>&self.lheweight22_value)

        #print "making lheweight23"
        self.lheweight23_branch = the_tree.GetBranch("lheweight23")
        #if not self.lheweight23_branch and "lheweight23" not in self.complained:
        if not self.lheweight23_branch and "lheweight23":
            warnings.warn( "EMTree: Expected branch lheweight23 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight23")
        else:
            self.lheweight23_branch.SetAddress(<void*>&self.lheweight23_value)

        #print "making lheweight24"
        self.lheweight24_branch = the_tree.GetBranch("lheweight24")
        #if not self.lheweight24_branch and "lheweight24" not in self.complained:
        if not self.lheweight24_branch and "lheweight24":
            warnings.warn( "EMTree: Expected branch lheweight24 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight24")
        else:
            self.lheweight24_branch.SetAddress(<void*>&self.lheweight24_value)

        #print "making lheweight25"
        self.lheweight25_branch = the_tree.GetBranch("lheweight25")
        #if not self.lheweight25_branch and "lheweight25" not in self.complained:
        if not self.lheweight25_branch and "lheweight25":
            warnings.warn( "EMTree: Expected branch lheweight25 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight25")
        else:
            self.lheweight25_branch.SetAddress(<void*>&self.lheweight25_value)

        #print "making lheweight26"
        self.lheweight26_branch = the_tree.GetBranch("lheweight26")
        #if not self.lheweight26_branch and "lheweight26" not in self.complained:
        if not self.lheweight26_branch and "lheweight26":
            warnings.warn( "EMTree: Expected branch lheweight26 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight26")
        else:
            self.lheweight26_branch.SetAddress(<void*>&self.lheweight26_value)

        #print "making lheweight27"
        self.lheweight27_branch = the_tree.GetBranch("lheweight27")
        #if not self.lheweight27_branch and "lheweight27" not in self.complained:
        if not self.lheweight27_branch and "lheweight27":
            warnings.warn( "EMTree: Expected branch lheweight27 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight27")
        else:
            self.lheweight27_branch.SetAddress(<void*>&self.lheweight27_value)

        #print "making lheweight28"
        self.lheweight28_branch = the_tree.GetBranch("lheweight28")
        #if not self.lheweight28_branch and "lheweight28" not in self.complained:
        if not self.lheweight28_branch and "lheweight28":
            warnings.warn( "EMTree: Expected branch lheweight28 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight28")
        else:
            self.lheweight28_branch.SetAddress(<void*>&self.lheweight28_value)

        #print "making lheweight29"
        self.lheweight29_branch = the_tree.GetBranch("lheweight29")
        #if not self.lheweight29_branch and "lheweight29" not in self.complained:
        if not self.lheweight29_branch and "lheweight29":
            warnings.warn( "EMTree: Expected branch lheweight29 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight29")
        else:
            self.lheweight29_branch.SetAddress(<void*>&self.lheweight29_value)

        #print "making lheweight3"
        self.lheweight3_branch = the_tree.GetBranch("lheweight3")
        #if not self.lheweight3_branch and "lheweight3" not in self.complained:
        if not self.lheweight3_branch and "lheweight3":
            warnings.warn( "EMTree: Expected branch lheweight3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight3")
        else:
            self.lheweight3_branch.SetAddress(<void*>&self.lheweight3_value)

        #print "making lheweight30"
        self.lheweight30_branch = the_tree.GetBranch("lheweight30")
        #if not self.lheweight30_branch and "lheweight30" not in self.complained:
        if not self.lheweight30_branch and "lheweight30":
            warnings.warn( "EMTree: Expected branch lheweight30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight30")
        else:
            self.lheweight30_branch.SetAddress(<void*>&self.lheweight30_value)

        #print "making lheweight31"
        self.lheweight31_branch = the_tree.GetBranch("lheweight31")
        #if not self.lheweight31_branch and "lheweight31" not in self.complained:
        if not self.lheweight31_branch and "lheweight31":
            warnings.warn( "EMTree: Expected branch lheweight31 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight31")
        else:
            self.lheweight31_branch.SetAddress(<void*>&self.lheweight31_value)

        #print "making lheweight32"
        self.lheweight32_branch = the_tree.GetBranch("lheweight32")
        #if not self.lheweight32_branch and "lheweight32" not in self.complained:
        if not self.lheweight32_branch and "lheweight32":
            warnings.warn( "EMTree: Expected branch lheweight32 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight32")
        else:
            self.lheweight32_branch.SetAddress(<void*>&self.lheweight32_value)

        #print "making lheweight33"
        self.lheweight33_branch = the_tree.GetBranch("lheweight33")
        #if not self.lheweight33_branch and "lheweight33" not in self.complained:
        if not self.lheweight33_branch and "lheweight33":
            warnings.warn( "EMTree: Expected branch lheweight33 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight33")
        else:
            self.lheweight33_branch.SetAddress(<void*>&self.lheweight33_value)

        #print "making lheweight34"
        self.lheweight34_branch = the_tree.GetBranch("lheweight34")
        #if not self.lheweight34_branch and "lheweight34" not in self.complained:
        if not self.lheweight34_branch and "lheweight34":
            warnings.warn( "EMTree: Expected branch lheweight34 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight34")
        else:
            self.lheweight34_branch.SetAddress(<void*>&self.lheweight34_value)

        #print "making lheweight35"
        self.lheweight35_branch = the_tree.GetBranch("lheweight35")
        #if not self.lheweight35_branch and "lheweight35" not in self.complained:
        if not self.lheweight35_branch and "lheweight35":
            warnings.warn( "EMTree: Expected branch lheweight35 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight35")
        else:
            self.lheweight35_branch.SetAddress(<void*>&self.lheweight35_value)

        #print "making lheweight36"
        self.lheweight36_branch = the_tree.GetBranch("lheweight36")
        #if not self.lheweight36_branch and "lheweight36" not in self.complained:
        if not self.lheweight36_branch and "lheweight36":
            warnings.warn( "EMTree: Expected branch lheweight36 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight36")
        else:
            self.lheweight36_branch.SetAddress(<void*>&self.lheweight36_value)

        #print "making lheweight37"
        self.lheweight37_branch = the_tree.GetBranch("lheweight37")
        #if not self.lheweight37_branch and "lheweight37" not in self.complained:
        if not self.lheweight37_branch and "lheweight37":
            warnings.warn( "EMTree: Expected branch lheweight37 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight37")
        else:
            self.lheweight37_branch.SetAddress(<void*>&self.lheweight37_value)

        #print "making lheweight38"
        self.lheweight38_branch = the_tree.GetBranch("lheweight38")
        #if not self.lheweight38_branch and "lheweight38" not in self.complained:
        if not self.lheweight38_branch and "lheweight38":
            warnings.warn( "EMTree: Expected branch lheweight38 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight38")
        else:
            self.lheweight38_branch.SetAddress(<void*>&self.lheweight38_value)

        #print "making lheweight39"
        self.lheweight39_branch = the_tree.GetBranch("lheweight39")
        #if not self.lheweight39_branch and "lheweight39" not in self.complained:
        if not self.lheweight39_branch and "lheweight39":
            warnings.warn( "EMTree: Expected branch lheweight39 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight39")
        else:
            self.lheweight39_branch.SetAddress(<void*>&self.lheweight39_value)

        #print "making lheweight4"
        self.lheweight4_branch = the_tree.GetBranch("lheweight4")
        #if not self.lheweight4_branch and "lheweight4" not in self.complained:
        if not self.lheweight4_branch and "lheweight4":
            warnings.warn( "EMTree: Expected branch lheweight4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight4")
        else:
            self.lheweight4_branch.SetAddress(<void*>&self.lheweight4_value)

        #print "making lheweight40"
        self.lheweight40_branch = the_tree.GetBranch("lheweight40")
        #if not self.lheweight40_branch and "lheweight40" not in self.complained:
        if not self.lheweight40_branch and "lheweight40":
            warnings.warn( "EMTree: Expected branch lheweight40 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight40")
        else:
            self.lheweight40_branch.SetAddress(<void*>&self.lheweight40_value)

        #print "making lheweight41"
        self.lheweight41_branch = the_tree.GetBranch("lheweight41")
        #if not self.lheweight41_branch and "lheweight41" not in self.complained:
        if not self.lheweight41_branch and "lheweight41":
            warnings.warn( "EMTree: Expected branch lheweight41 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight41")
        else:
            self.lheweight41_branch.SetAddress(<void*>&self.lheweight41_value)

        #print "making lheweight42"
        self.lheweight42_branch = the_tree.GetBranch("lheweight42")
        #if not self.lheweight42_branch and "lheweight42" not in self.complained:
        if not self.lheweight42_branch and "lheweight42":
            warnings.warn( "EMTree: Expected branch lheweight42 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight42")
        else:
            self.lheweight42_branch.SetAddress(<void*>&self.lheweight42_value)

        #print "making lheweight43"
        self.lheweight43_branch = the_tree.GetBranch("lheweight43")
        #if not self.lheweight43_branch and "lheweight43" not in self.complained:
        if not self.lheweight43_branch and "lheweight43":
            warnings.warn( "EMTree: Expected branch lheweight43 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight43")
        else:
            self.lheweight43_branch.SetAddress(<void*>&self.lheweight43_value)

        #print "making lheweight44"
        self.lheweight44_branch = the_tree.GetBranch("lheweight44")
        #if not self.lheweight44_branch and "lheweight44" not in self.complained:
        if not self.lheweight44_branch and "lheweight44":
            warnings.warn( "EMTree: Expected branch lheweight44 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight44")
        else:
            self.lheweight44_branch.SetAddress(<void*>&self.lheweight44_value)

        #print "making lheweight45"
        self.lheweight45_branch = the_tree.GetBranch("lheweight45")
        #if not self.lheweight45_branch and "lheweight45" not in self.complained:
        if not self.lheweight45_branch and "lheweight45":
            warnings.warn( "EMTree: Expected branch lheweight45 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight45")
        else:
            self.lheweight45_branch.SetAddress(<void*>&self.lheweight45_value)

        #print "making lheweight46"
        self.lheweight46_branch = the_tree.GetBranch("lheweight46")
        #if not self.lheweight46_branch and "lheweight46" not in self.complained:
        if not self.lheweight46_branch and "lheweight46":
            warnings.warn( "EMTree: Expected branch lheweight46 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight46")
        else:
            self.lheweight46_branch.SetAddress(<void*>&self.lheweight46_value)

        #print "making lheweight47"
        self.lheweight47_branch = the_tree.GetBranch("lheweight47")
        #if not self.lheweight47_branch and "lheweight47" not in self.complained:
        if not self.lheweight47_branch and "lheweight47":
            warnings.warn( "EMTree: Expected branch lheweight47 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight47")
        else:
            self.lheweight47_branch.SetAddress(<void*>&self.lheweight47_value)

        #print "making lheweight48"
        self.lheweight48_branch = the_tree.GetBranch("lheweight48")
        #if not self.lheweight48_branch and "lheweight48" not in self.complained:
        if not self.lheweight48_branch and "lheweight48":
            warnings.warn( "EMTree: Expected branch lheweight48 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight48")
        else:
            self.lheweight48_branch.SetAddress(<void*>&self.lheweight48_value)

        #print "making lheweight49"
        self.lheweight49_branch = the_tree.GetBranch("lheweight49")
        #if not self.lheweight49_branch and "lheweight49" not in self.complained:
        if not self.lheweight49_branch and "lheweight49":
            warnings.warn( "EMTree: Expected branch lheweight49 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight49")
        else:
            self.lheweight49_branch.SetAddress(<void*>&self.lheweight49_value)

        #print "making lheweight5"
        self.lheweight5_branch = the_tree.GetBranch("lheweight5")
        #if not self.lheweight5_branch and "lheweight5" not in self.complained:
        if not self.lheweight5_branch and "lheweight5":
            warnings.warn( "EMTree: Expected branch lheweight5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight5")
        else:
            self.lheweight5_branch.SetAddress(<void*>&self.lheweight5_value)

        #print "making lheweight50"
        self.lheweight50_branch = the_tree.GetBranch("lheweight50")
        #if not self.lheweight50_branch and "lheweight50" not in self.complained:
        if not self.lheweight50_branch and "lheweight50":
            warnings.warn( "EMTree: Expected branch lheweight50 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight50")
        else:
            self.lheweight50_branch.SetAddress(<void*>&self.lheweight50_value)

        #print "making lheweight51"
        self.lheweight51_branch = the_tree.GetBranch("lheweight51")
        #if not self.lheweight51_branch and "lheweight51" not in self.complained:
        if not self.lheweight51_branch and "lheweight51":
            warnings.warn( "EMTree: Expected branch lheweight51 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight51")
        else:
            self.lheweight51_branch.SetAddress(<void*>&self.lheweight51_value)

        #print "making lheweight52"
        self.lheweight52_branch = the_tree.GetBranch("lheweight52")
        #if not self.lheweight52_branch and "lheweight52" not in self.complained:
        if not self.lheweight52_branch and "lheweight52":
            warnings.warn( "EMTree: Expected branch lheweight52 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight52")
        else:
            self.lheweight52_branch.SetAddress(<void*>&self.lheweight52_value)

        #print "making lheweight53"
        self.lheweight53_branch = the_tree.GetBranch("lheweight53")
        #if not self.lheweight53_branch and "lheweight53" not in self.complained:
        if not self.lheweight53_branch and "lheweight53":
            warnings.warn( "EMTree: Expected branch lheweight53 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight53")
        else:
            self.lheweight53_branch.SetAddress(<void*>&self.lheweight53_value)

        #print "making lheweight54"
        self.lheweight54_branch = the_tree.GetBranch("lheweight54")
        #if not self.lheweight54_branch and "lheweight54" not in self.complained:
        if not self.lheweight54_branch and "lheweight54":
            warnings.warn( "EMTree: Expected branch lheweight54 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight54")
        else:
            self.lheweight54_branch.SetAddress(<void*>&self.lheweight54_value)

        #print "making lheweight55"
        self.lheweight55_branch = the_tree.GetBranch("lheweight55")
        #if not self.lheweight55_branch and "lheweight55" not in self.complained:
        if not self.lheweight55_branch and "lheweight55":
            warnings.warn( "EMTree: Expected branch lheweight55 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight55")
        else:
            self.lheweight55_branch.SetAddress(<void*>&self.lheweight55_value)

        #print "making lheweight56"
        self.lheweight56_branch = the_tree.GetBranch("lheweight56")
        #if not self.lheweight56_branch and "lheweight56" not in self.complained:
        if not self.lheweight56_branch and "lheweight56":
            warnings.warn( "EMTree: Expected branch lheweight56 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight56")
        else:
            self.lheweight56_branch.SetAddress(<void*>&self.lheweight56_value)

        #print "making lheweight57"
        self.lheweight57_branch = the_tree.GetBranch("lheweight57")
        #if not self.lheweight57_branch and "lheweight57" not in self.complained:
        if not self.lheweight57_branch and "lheweight57":
            warnings.warn( "EMTree: Expected branch lheweight57 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight57")
        else:
            self.lheweight57_branch.SetAddress(<void*>&self.lheweight57_value)

        #print "making lheweight58"
        self.lheweight58_branch = the_tree.GetBranch("lheweight58")
        #if not self.lheweight58_branch and "lheweight58" not in self.complained:
        if not self.lheweight58_branch and "lheweight58":
            warnings.warn( "EMTree: Expected branch lheweight58 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight58")
        else:
            self.lheweight58_branch.SetAddress(<void*>&self.lheweight58_value)

        #print "making lheweight59"
        self.lheweight59_branch = the_tree.GetBranch("lheweight59")
        #if not self.lheweight59_branch and "lheweight59" not in self.complained:
        if not self.lheweight59_branch and "lheweight59":
            warnings.warn( "EMTree: Expected branch lheweight59 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight59")
        else:
            self.lheweight59_branch.SetAddress(<void*>&self.lheweight59_value)

        #print "making lheweight6"
        self.lheweight6_branch = the_tree.GetBranch("lheweight6")
        #if not self.lheweight6_branch and "lheweight6" not in self.complained:
        if not self.lheweight6_branch and "lheweight6":
            warnings.warn( "EMTree: Expected branch lheweight6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight6")
        else:
            self.lheweight6_branch.SetAddress(<void*>&self.lheweight6_value)

        #print "making lheweight60"
        self.lheweight60_branch = the_tree.GetBranch("lheweight60")
        #if not self.lheweight60_branch and "lheweight60" not in self.complained:
        if not self.lheweight60_branch and "lheweight60":
            warnings.warn( "EMTree: Expected branch lheweight60 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight60")
        else:
            self.lheweight60_branch.SetAddress(<void*>&self.lheweight60_value)

        #print "making lheweight61"
        self.lheweight61_branch = the_tree.GetBranch("lheweight61")
        #if not self.lheweight61_branch and "lheweight61" not in self.complained:
        if not self.lheweight61_branch and "lheweight61":
            warnings.warn( "EMTree: Expected branch lheweight61 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight61")
        else:
            self.lheweight61_branch.SetAddress(<void*>&self.lheweight61_value)

        #print "making lheweight62"
        self.lheweight62_branch = the_tree.GetBranch("lheweight62")
        #if not self.lheweight62_branch and "lheweight62" not in self.complained:
        if not self.lheweight62_branch and "lheweight62":
            warnings.warn( "EMTree: Expected branch lheweight62 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight62")
        else:
            self.lheweight62_branch.SetAddress(<void*>&self.lheweight62_value)

        #print "making lheweight63"
        self.lheweight63_branch = the_tree.GetBranch("lheweight63")
        #if not self.lheweight63_branch and "lheweight63" not in self.complained:
        if not self.lheweight63_branch and "lheweight63":
            warnings.warn( "EMTree: Expected branch lheweight63 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight63")
        else:
            self.lheweight63_branch.SetAddress(<void*>&self.lheweight63_value)

        #print "making lheweight64"
        self.lheweight64_branch = the_tree.GetBranch("lheweight64")
        #if not self.lheweight64_branch and "lheweight64" not in self.complained:
        if not self.lheweight64_branch and "lheweight64":
            warnings.warn( "EMTree: Expected branch lheweight64 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight64")
        else:
            self.lheweight64_branch.SetAddress(<void*>&self.lheweight64_value)

        #print "making lheweight65"
        self.lheweight65_branch = the_tree.GetBranch("lheweight65")
        #if not self.lheweight65_branch and "lheweight65" not in self.complained:
        if not self.lheweight65_branch and "lheweight65":
            warnings.warn( "EMTree: Expected branch lheweight65 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight65")
        else:
            self.lheweight65_branch.SetAddress(<void*>&self.lheweight65_value)

        #print "making lheweight66"
        self.lheweight66_branch = the_tree.GetBranch("lheweight66")
        #if not self.lheweight66_branch and "lheweight66" not in self.complained:
        if not self.lheweight66_branch and "lheweight66":
            warnings.warn( "EMTree: Expected branch lheweight66 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight66")
        else:
            self.lheweight66_branch.SetAddress(<void*>&self.lheweight66_value)

        #print "making lheweight67"
        self.lheweight67_branch = the_tree.GetBranch("lheweight67")
        #if not self.lheweight67_branch and "lheweight67" not in self.complained:
        if not self.lheweight67_branch and "lheweight67":
            warnings.warn( "EMTree: Expected branch lheweight67 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight67")
        else:
            self.lheweight67_branch.SetAddress(<void*>&self.lheweight67_value)

        #print "making lheweight68"
        self.lheweight68_branch = the_tree.GetBranch("lheweight68")
        #if not self.lheweight68_branch and "lheweight68" not in self.complained:
        if not self.lheweight68_branch and "lheweight68":
            warnings.warn( "EMTree: Expected branch lheweight68 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight68")
        else:
            self.lheweight68_branch.SetAddress(<void*>&self.lheweight68_value)

        #print "making lheweight69"
        self.lheweight69_branch = the_tree.GetBranch("lheweight69")
        #if not self.lheweight69_branch and "lheweight69" not in self.complained:
        if not self.lheweight69_branch and "lheweight69":
            warnings.warn( "EMTree: Expected branch lheweight69 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight69")
        else:
            self.lheweight69_branch.SetAddress(<void*>&self.lheweight69_value)

        #print "making lheweight7"
        self.lheweight7_branch = the_tree.GetBranch("lheweight7")
        #if not self.lheweight7_branch and "lheweight7" not in self.complained:
        if not self.lheweight7_branch and "lheweight7":
            warnings.warn( "EMTree: Expected branch lheweight7 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight7")
        else:
            self.lheweight7_branch.SetAddress(<void*>&self.lheweight7_value)

        #print "making lheweight70"
        self.lheweight70_branch = the_tree.GetBranch("lheweight70")
        #if not self.lheweight70_branch and "lheweight70" not in self.complained:
        if not self.lheweight70_branch and "lheweight70":
            warnings.warn( "EMTree: Expected branch lheweight70 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight70")
        else:
            self.lheweight70_branch.SetAddress(<void*>&self.lheweight70_value)

        #print "making lheweight71"
        self.lheweight71_branch = the_tree.GetBranch("lheweight71")
        #if not self.lheweight71_branch and "lheweight71" not in self.complained:
        if not self.lheweight71_branch and "lheweight71":
            warnings.warn( "EMTree: Expected branch lheweight71 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight71")
        else:
            self.lheweight71_branch.SetAddress(<void*>&self.lheweight71_value)

        #print "making lheweight72"
        self.lheweight72_branch = the_tree.GetBranch("lheweight72")
        #if not self.lheweight72_branch and "lheweight72" not in self.complained:
        if not self.lheweight72_branch and "lheweight72":
            warnings.warn( "EMTree: Expected branch lheweight72 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight72")
        else:
            self.lheweight72_branch.SetAddress(<void*>&self.lheweight72_value)

        #print "making lheweight73"
        self.lheweight73_branch = the_tree.GetBranch("lheweight73")
        #if not self.lheweight73_branch and "lheweight73" not in self.complained:
        if not self.lheweight73_branch and "lheweight73":
            warnings.warn( "EMTree: Expected branch lheweight73 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight73")
        else:
            self.lheweight73_branch.SetAddress(<void*>&self.lheweight73_value)

        #print "making lheweight74"
        self.lheweight74_branch = the_tree.GetBranch("lheweight74")
        #if not self.lheweight74_branch and "lheweight74" not in self.complained:
        if not self.lheweight74_branch and "lheweight74":
            warnings.warn( "EMTree: Expected branch lheweight74 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight74")
        else:
            self.lheweight74_branch.SetAddress(<void*>&self.lheweight74_value)

        #print "making lheweight75"
        self.lheweight75_branch = the_tree.GetBranch("lheweight75")
        #if not self.lheweight75_branch and "lheweight75" not in self.complained:
        if not self.lheweight75_branch and "lheweight75":
            warnings.warn( "EMTree: Expected branch lheweight75 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight75")
        else:
            self.lheweight75_branch.SetAddress(<void*>&self.lheweight75_value)

        #print "making lheweight76"
        self.lheweight76_branch = the_tree.GetBranch("lheweight76")
        #if not self.lheweight76_branch and "lheweight76" not in self.complained:
        if not self.lheweight76_branch and "lheweight76":
            warnings.warn( "EMTree: Expected branch lheweight76 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight76")
        else:
            self.lheweight76_branch.SetAddress(<void*>&self.lheweight76_value)

        #print "making lheweight77"
        self.lheweight77_branch = the_tree.GetBranch("lheweight77")
        #if not self.lheweight77_branch and "lheweight77" not in self.complained:
        if not self.lheweight77_branch and "lheweight77":
            warnings.warn( "EMTree: Expected branch lheweight77 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight77")
        else:
            self.lheweight77_branch.SetAddress(<void*>&self.lheweight77_value)

        #print "making lheweight78"
        self.lheweight78_branch = the_tree.GetBranch("lheweight78")
        #if not self.lheweight78_branch and "lheweight78" not in self.complained:
        if not self.lheweight78_branch and "lheweight78":
            warnings.warn( "EMTree: Expected branch lheweight78 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight78")
        else:
            self.lheweight78_branch.SetAddress(<void*>&self.lheweight78_value)

        #print "making lheweight79"
        self.lheweight79_branch = the_tree.GetBranch("lheweight79")
        #if not self.lheweight79_branch and "lheweight79" not in self.complained:
        if not self.lheweight79_branch and "lheweight79":
            warnings.warn( "EMTree: Expected branch lheweight79 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight79")
        else:
            self.lheweight79_branch.SetAddress(<void*>&self.lheweight79_value)

        #print "making lheweight8"
        self.lheweight8_branch = the_tree.GetBranch("lheweight8")
        #if not self.lheweight8_branch and "lheweight8" not in self.complained:
        if not self.lheweight8_branch and "lheweight8":
            warnings.warn( "EMTree: Expected branch lheweight8 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight8")
        else:
            self.lheweight8_branch.SetAddress(<void*>&self.lheweight8_value)

        #print "making lheweight80"
        self.lheweight80_branch = the_tree.GetBranch("lheweight80")
        #if not self.lheweight80_branch and "lheweight80" not in self.complained:
        if not self.lheweight80_branch and "lheweight80":
            warnings.warn( "EMTree: Expected branch lheweight80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight80")
        else:
            self.lheweight80_branch.SetAddress(<void*>&self.lheweight80_value)

        #print "making lheweight81"
        self.lheweight81_branch = the_tree.GetBranch("lheweight81")
        #if not self.lheweight81_branch and "lheweight81" not in self.complained:
        if not self.lheweight81_branch and "lheweight81":
            warnings.warn( "EMTree: Expected branch lheweight81 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight81")
        else:
            self.lheweight81_branch.SetAddress(<void*>&self.lheweight81_value)

        #print "making lheweight82"
        self.lheweight82_branch = the_tree.GetBranch("lheweight82")
        #if not self.lheweight82_branch and "lheweight82" not in self.complained:
        if not self.lheweight82_branch and "lheweight82":
            warnings.warn( "EMTree: Expected branch lheweight82 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight82")
        else:
            self.lheweight82_branch.SetAddress(<void*>&self.lheweight82_value)

        #print "making lheweight83"
        self.lheweight83_branch = the_tree.GetBranch("lheweight83")
        #if not self.lheweight83_branch and "lheweight83" not in self.complained:
        if not self.lheweight83_branch and "lheweight83":
            warnings.warn( "EMTree: Expected branch lheweight83 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight83")
        else:
            self.lheweight83_branch.SetAddress(<void*>&self.lheweight83_value)

        #print "making lheweight84"
        self.lheweight84_branch = the_tree.GetBranch("lheweight84")
        #if not self.lheweight84_branch and "lheweight84" not in self.complained:
        if not self.lheweight84_branch and "lheweight84":
            warnings.warn( "EMTree: Expected branch lheweight84 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight84")
        else:
            self.lheweight84_branch.SetAddress(<void*>&self.lheweight84_value)

        #print "making lheweight85"
        self.lheweight85_branch = the_tree.GetBranch("lheweight85")
        #if not self.lheweight85_branch and "lheweight85" not in self.complained:
        if not self.lheweight85_branch and "lheweight85":
            warnings.warn( "EMTree: Expected branch lheweight85 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight85")
        else:
            self.lheweight85_branch.SetAddress(<void*>&self.lheweight85_value)

        #print "making lheweight86"
        self.lheweight86_branch = the_tree.GetBranch("lheweight86")
        #if not self.lheweight86_branch and "lheweight86" not in self.complained:
        if not self.lheweight86_branch and "lheweight86":
            warnings.warn( "EMTree: Expected branch lheweight86 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight86")
        else:
            self.lheweight86_branch.SetAddress(<void*>&self.lheweight86_value)

        #print "making lheweight87"
        self.lheweight87_branch = the_tree.GetBranch("lheweight87")
        #if not self.lheweight87_branch and "lheweight87" not in self.complained:
        if not self.lheweight87_branch and "lheweight87":
            warnings.warn( "EMTree: Expected branch lheweight87 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight87")
        else:
            self.lheweight87_branch.SetAddress(<void*>&self.lheweight87_value)

        #print "making lheweight88"
        self.lheweight88_branch = the_tree.GetBranch("lheweight88")
        #if not self.lheweight88_branch and "lheweight88" not in self.complained:
        if not self.lheweight88_branch and "lheweight88":
            warnings.warn( "EMTree: Expected branch lheweight88 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight88")
        else:
            self.lheweight88_branch.SetAddress(<void*>&self.lheweight88_value)

        #print "making lheweight89"
        self.lheweight89_branch = the_tree.GetBranch("lheweight89")
        #if not self.lheweight89_branch and "lheweight89" not in self.complained:
        if not self.lheweight89_branch and "lheweight89":
            warnings.warn( "EMTree: Expected branch lheweight89 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight89")
        else:
            self.lheweight89_branch.SetAddress(<void*>&self.lheweight89_value)

        #print "making lheweight9"
        self.lheweight9_branch = the_tree.GetBranch("lheweight9")
        #if not self.lheweight9_branch and "lheweight9" not in self.complained:
        if not self.lheweight9_branch and "lheweight9":
            warnings.warn( "EMTree: Expected branch lheweight9 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight9")
        else:
            self.lheweight9_branch.SetAddress(<void*>&self.lheweight9_value)

        #print "making lheweight90"
        self.lheweight90_branch = the_tree.GetBranch("lheweight90")
        #if not self.lheweight90_branch and "lheweight90" not in self.complained:
        if not self.lheweight90_branch and "lheweight90":
            warnings.warn( "EMTree: Expected branch lheweight90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight90")
        else:
            self.lheweight90_branch.SetAddress(<void*>&self.lheweight90_value)

        #print "making lheweight91"
        self.lheweight91_branch = the_tree.GetBranch("lheweight91")
        #if not self.lheweight91_branch and "lheweight91" not in self.complained:
        if not self.lheweight91_branch and "lheweight91":
            warnings.warn( "EMTree: Expected branch lheweight91 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight91")
        else:
            self.lheweight91_branch.SetAddress(<void*>&self.lheweight91_value)

        #print "making lheweight92"
        self.lheweight92_branch = the_tree.GetBranch("lheweight92")
        #if not self.lheweight92_branch and "lheweight92" not in self.complained:
        if not self.lheweight92_branch and "lheweight92":
            warnings.warn( "EMTree: Expected branch lheweight92 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight92")
        else:
            self.lheweight92_branch.SetAddress(<void*>&self.lheweight92_value)

        #print "making lheweight93"
        self.lheweight93_branch = the_tree.GetBranch("lheweight93")
        #if not self.lheweight93_branch and "lheweight93" not in self.complained:
        if not self.lheweight93_branch and "lheweight93":
            warnings.warn( "EMTree: Expected branch lheweight93 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight93")
        else:
            self.lheweight93_branch.SetAddress(<void*>&self.lheweight93_value)

        #print "making lheweight94"
        self.lheweight94_branch = the_tree.GetBranch("lheweight94")
        #if not self.lheweight94_branch and "lheweight94" not in self.complained:
        if not self.lheweight94_branch and "lheweight94":
            warnings.warn( "EMTree: Expected branch lheweight94 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight94")
        else:
            self.lheweight94_branch.SetAddress(<void*>&self.lheweight94_value)

        #print "making lheweight95"
        self.lheweight95_branch = the_tree.GetBranch("lheweight95")
        #if not self.lheweight95_branch and "lheweight95" not in self.complained:
        if not self.lheweight95_branch and "lheweight95":
            warnings.warn( "EMTree: Expected branch lheweight95 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight95")
        else:
            self.lheweight95_branch.SetAddress(<void*>&self.lheweight95_value)

        #print "making lheweight96"
        self.lheweight96_branch = the_tree.GetBranch("lheweight96")
        #if not self.lheweight96_branch and "lheweight96" not in self.complained:
        if not self.lheweight96_branch and "lheweight96":
            warnings.warn( "EMTree: Expected branch lheweight96 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight96")
        else:
            self.lheweight96_branch.SetAddress(<void*>&self.lheweight96_value)

        #print "making lheweight97"
        self.lheweight97_branch = the_tree.GetBranch("lheweight97")
        #if not self.lheweight97_branch and "lheweight97" not in self.complained:
        if not self.lheweight97_branch and "lheweight97":
            warnings.warn( "EMTree: Expected branch lheweight97 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight97")
        else:
            self.lheweight97_branch.SetAddress(<void*>&self.lheweight97_value)

        #print "making lheweight98"
        self.lheweight98_branch = the_tree.GetBranch("lheweight98")
        #if not self.lheweight98_branch and "lheweight98" not in self.complained:
        if not self.lheweight98_branch and "lheweight98":
            warnings.warn( "EMTree: Expected branch lheweight98 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight98")
        else:
            self.lheweight98_branch.SetAddress(<void*>&self.lheweight98_value)

        #print "making lheweight99"
        self.lheweight99_branch = the_tree.GetBranch("lheweight99")
        #if not self.lheweight99_branch and "lheweight99" not in self.complained:
        if not self.lheweight99_branch and "lheweight99":
            warnings.warn( "EMTree: Expected branch lheweight99 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lheweight99")
        else:
            self.lheweight99_branch.SetAddress(<void*>&self.lheweight99_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EMTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making mCharge"
        self.mCharge_branch = the_tree.GetBranch("mCharge")
        #if not self.mCharge_branch and "mCharge" not in self.complained:
        if not self.mCharge_branch and "mCharge":
            warnings.warn( "EMTree: Expected branch mCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mCharge")
        else:
            self.mCharge_branch.SetAddress(<void*>&self.mCharge_value)

        #print "making mComesFromHiggs"
        self.mComesFromHiggs_branch = the_tree.GetBranch("mComesFromHiggs")
        #if not self.mComesFromHiggs_branch and "mComesFromHiggs" not in self.complained:
        if not self.mComesFromHiggs_branch and "mComesFromHiggs":
            warnings.warn( "EMTree: Expected branch mComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mComesFromHiggs")
        else:
            self.mComesFromHiggs_branch.SetAddress(<void*>&self.mComesFromHiggs_value)

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

        #print "making mMass"
        self.mMass_branch = the_tree.GetBranch("mMass")
        #if not self.mMass_branch and "mMass" not in self.complained:
        if not self.mMass_branch and "mMass":
            warnings.warn( "EMTree: Expected branch mMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMass")
        else:
            self.mMass_branch.SetAddress(<void*>&self.mMass_value)

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

        #print "making mPt"
        self.mPt_branch = the_tree.GetBranch("mPt")
        #if not self.mPt_branch and "mPt" not in self.complained:
        if not self.mPt_branch and "mPt":
            warnings.warn( "EMTree: Expected branch mPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPt")
        else:
            self.mPt_branch.SetAddress(<void*>&self.mPt_value)

        #print "making mRelPFIsoDBDefaultR04"
        self.mRelPFIsoDBDefaultR04_branch = the_tree.GetBranch("mRelPFIsoDBDefaultR04")
        #if not self.mRelPFIsoDBDefaultR04_branch and "mRelPFIsoDBDefaultR04" not in self.complained:
        if not self.mRelPFIsoDBDefaultR04_branch and "mRelPFIsoDBDefaultR04":
            warnings.warn( "EMTree: Expected branch mRelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRelPFIsoDBDefaultR04")
        else:
            self.mRelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.mRelPFIsoDBDefaultR04_value)

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

        #print "making mVZ"
        self.mVZ_branch = the_tree.GetBranch("mVZ")
        #if not self.mVZ_branch and "mVZ" not in self.complained:
        if not self.mVZ_branch and "mVZ":
            warnings.warn( "EMTree: Expected branch mVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mVZ")
        else:
            self.mVZ_branch.SetAddress(<void*>&self.mVZ_value)

        #print "making mZTTGenMatching"
        self.mZTTGenMatching_branch = the_tree.GetBranch("mZTTGenMatching")
        #if not self.mZTTGenMatching_branch and "mZTTGenMatching" not in self.complained:
        if not self.mZTTGenMatching_branch and "mZTTGenMatching":
            warnings.warn( "EMTree: Expected branch mZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mZTTGenMatching")
        else:
            self.mZTTGenMatching_branch.SetAddress(<void*>&self.mZTTGenMatching_value)

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

        #print "making tauVetoPt20LooseMVALTVtx"
        self.tauVetoPt20LooseMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVALTVtx")
        #if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx":
            warnings.warn( "EMTree: Expected branch tauVetoPt20LooseMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVALTVtx")
        else:
            self.tauVetoPt20LooseMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVALTVtx_value)

        #print "making tauVetoPtDeepVtx"
        self.tauVetoPtDeepVtx_branch = the_tree.GetBranch("tauVetoPtDeepVtx")
        #if not self.tauVetoPtDeepVtx_branch and "tauVetoPtDeepVtx" not in self.complained:
        if not self.tauVetoPtDeepVtx_branch and "tauVetoPtDeepVtx":
            warnings.warn( "EMTree: Expected branch tauVetoPtDeepVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPtDeepVtx")
        else:
            self.tauVetoPtDeepVtx_branch.SetAddress(<void*>&self.tauVetoPtDeepVtx_value)

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

        #print "making type1_pfMet_shiftedPhi_JERDown"
        self.type1_pfMet_shiftedPhi_JERDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JERDown")
        #if not self.type1_pfMet_shiftedPhi_JERDown_branch and "type1_pfMet_shiftedPhi_JERDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JERDown_branch and "type1_pfMet_shiftedPhi_JERDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JERDown")
        else:
            self.type1_pfMet_shiftedPhi_JERDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JERDown_value)

        #print "making type1_pfMet_shiftedPhi_JERUp"
        self.type1_pfMet_shiftedPhi_JERUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JERUp")
        #if not self.type1_pfMet_shiftedPhi_JERUp_branch and "type1_pfMet_shiftedPhi_JERUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JERUp_branch and "type1_pfMet_shiftedPhi_JERUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JERUp")
        else:
            self.type1_pfMet_shiftedPhi_JERUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JERUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteyearDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteyearDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteyearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteyearDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteyearUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteyearUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteyearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteyearUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_value)

        #print "making type1_pfMet_shiftedPhi_JetBBEC1Down"
        self.type1_pfMet_shiftedPhi_JetBBEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetBBEC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetBBEC1Down_branch and "type1_pfMet_shiftedPhi_JetBBEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetBBEC1Down_branch and "type1_pfMet_shiftedPhi_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetBBEC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetBBEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetBBEC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetBBEC1Up"
        self.type1_pfMet_shiftedPhi_JetBBEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetBBEC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetBBEC1Up_branch and "type1_pfMet_shiftedPhi_JetBBEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetBBEC1Up_branch and "type1_pfMet_shiftedPhi_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetBBEC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetBBEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetBBEC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetBBEC1yearDown"
        self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetBBEC1yearDown")
        #if not self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_branch and "type1_pfMet_shiftedPhi_JetBBEC1yearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_branch and "type1_pfMet_shiftedPhi_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetBBEC1yearDown")
        else:
            self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_value)

        #print "making type1_pfMet_shiftedPhi_JetBBEC1yearUp"
        self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetBBEC1yearUp")
        #if not self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_branch and "type1_pfMet_shiftedPhi_JetBBEC1yearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_branch and "type1_pfMet_shiftedPhi_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetBBEC1yearUp")
        else:
            self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_value)

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

        #print "making type1_pfMet_shiftedPhi_JetEC2yearDown"
        self.type1_pfMet_shiftedPhi_JetEC2yearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEC2yearDown")
        #if not self.type1_pfMet_shiftedPhi_JetEC2yearDown_branch and "type1_pfMet_shiftedPhi_JetEC2yearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEC2yearDown_branch and "type1_pfMet_shiftedPhi_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEC2yearDown")
        else:
            self.type1_pfMet_shiftedPhi_JetEC2yearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEC2yearDown_value)

        #print "making type1_pfMet_shiftedPhi_JetEC2yearUp"
        self.type1_pfMet_shiftedPhi_JetEC2yearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEC2yearUp")
        #if not self.type1_pfMet_shiftedPhi_JetEC2yearUp_branch and "type1_pfMet_shiftedPhi_JetEC2yearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEC2yearUp_branch and "type1_pfMet_shiftedPhi_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEC2yearUp")
        else:
            self.type1_pfMet_shiftedPhi_JetEC2yearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEC2yearUp_value)

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

        #print "making type1_pfMet_shiftedPhi_JetHFDown"
        self.type1_pfMet_shiftedPhi_JetHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetHFDown_branch and "type1_pfMet_shiftedPhi_JetHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetHFDown_branch and "type1_pfMet_shiftedPhi_JetHFDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetHFUp"
        self.type1_pfMet_shiftedPhi_JetHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetHFUp_branch and "type1_pfMet_shiftedPhi_JetHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetHFUp_branch and "type1_pfMet_shiftedPhi_JetHFUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetHFyearDown"
        self.type1_pfMet_shiftedPhi_JetHFyearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetHFyearDown")
        #if not self.type1_pfMet_shiftedPhi_JetHFyearDown_branch and "type1_pfMet_shiftedPhi_JetHFyearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetHFyearDown_branch and "type1_pfMet_shiftedPhi_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetHFyearDown")
        else:
            self.type1_pfMet_shiftedPhi_JetHFyearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetHFyearDown_value)

        #print "making type1_pfMet_shiftedPhi_JetHFyearUp"
        self.type1_pfMet_shiftedPhi_JetHFyearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetHFyearUp")
        #if not self.type1_pfMet_shiftedPhi_JetHFyearUp_branch and "type1_pfMet_shiftedPhi_JetHFyearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetHFyearUp_branch and "type1_pfMet_shiftedPhi_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPhi_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetHFyearUp")
        else:
            self.type1_pfMet_shiftedPhi_JetHFyearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetHFyearUp_value)

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

        #print "making type1_pfMet_shiftedPt_JERDown"
        self.type1_pfMet_shiftedPt_JERDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JERDown")
        #if not self.type1_pfMet_shiftedPt_JERDown_branch and "type1_pfMet_shiftedPt_JERDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JERDown_branch and "type1_pfMet_shiftedPt_JERDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JERDown")
        else:
            self.type1_pfMet_shiftedPt_JERDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JERDown_value)

        #print "making type1_pfMet_shiftedPt_JERUp"
        self.type1_pfMet_shiftedPt_JERUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JERUp")
        #if not self.type1_pfMet_shiftedPt_JERUp_branch and "type1_pfMet_shiftedPt_JERUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JERUp_branch and "type1_pfMet_shiftedPt_JERUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JERUp")
        else:
            self.type1_pfMet_shiftedPt_JERUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JERUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteyearDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteyearDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteyearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteyearDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteyearUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteyearUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteyearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteyearUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_value)

        #print "making type1_pfMet_shiftedPt_JetBBEC1Down"
        self.type1_pfMet_shiftedPt_JetBBEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetBBEC1Down")
        #if not self.type1_pfMet_shiftedPt_JetBBEC1Down_branch and "type1_pfMet_shiftedPt_JetBBEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetBBEC1Down_branch and "type1_pfMet_shiftedPt_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetBBEC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetBBEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetBBEC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetBBEC1Up"
        self.type1_pfMet_shiftedPt_JetBBEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetBBEC1Up")
        #if not self.type1_pfMet_shiftedPt_JetBBEC1Up_branch and "type1_pfMet_shiftedPt_JetBBEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetBBEC1Up_branch and "type1_pfMet_shiftedPt_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetBBEC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetBBEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetBBEC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetBBEC1yearDown"
        self.type1_pfMet_shiftedPt_JetBBEC1yearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetBBEC1yearDown")
        #if not self.type1_pfMet_shiftedPt_JetBBEC1yearDown_branch and "type1_pfMet_shiftedPt_JetBBEC1yearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetBBEC1yearDown_branch and "type1_pfMet_shiftedPt_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetBBEC1yearDown")
        else:
            self.type1_pfMet_shiftedPt_JetBBEC1yearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetBBEC1yearDown_value)

        #print "making type1_pfMet_shiftedPt_JetBBEC1yearUp"
        self.type1_pfMet_shiftedPt_JetBBEC1yearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetBBEC1yearUp")
        #if not self.type1_pfMet_shiftedPt_JetBBEC1yearUp_branch and "type1_pfMet_shiftedPt_JetBBEC1yearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetBBEC1yearUp_branch and "type1_pfMet_shiftedPt_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetBBEC1yearUp")
        else:
            self.type1_pfMet_shiftedPt_JetBBEC1yearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetBBEC1yearUp_value)

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

        #print "making type1_pfMet_shiftedPt_JetEC2yearDown"
        self.type1_pfMet_shiftedPt_JetEC2yearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEC2yearDown")
        #if not self.type1_pfMet_shiftedPt_JetEC2yearDown_branch and "type1_pfMet_shiftedPt_JetEC2yearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEC2yearDown_branch and "type1_pfMet_shiftedPt_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEC2yearDown")
        else:
            self.type1_pfMet_shiftedPt_JetEC2yearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEC2yearDown_value)

        #print "making type1_pfMet_shiftedPt_JetEC2yearUp"
        self.type1_pfMet_shiftedPt_JetEC2yearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEC2yearUp")
        #if not self.type1_pfMet_shiftedPt_JetEC2yearUp_branch and "type1_pfMet_shiftedPt_JetEC2yearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEC2yearUp_branch and "type1_pfMet_shiftedPt_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEC2yearUp")
        else:
            self.type1_pfMet_shiftedPt_JetEC2yearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEC2yearUp_value)

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

        #print "making type1_pfMet_shiftedPt_JetHFDown"
        self.type1_pfMet_shiftedPt_JetHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetHFDown")
        #if not self.type1_pfMet_shiftedPt_JetHFDown_branch and "type1_pfMet_shiftedPt_JetHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetHFDown_branch and "type1_pfMet_shiftedPt_JetHFDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetHFUp"
        self.type1_pfMet_shiftedPt_JetHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetHFUp")
        #if not self.type1_pfMet_shiftedPt_JetHFUp_branch and "type1_pfMet_shiftedPt_JetHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetHFUp_branch and "type1_pfMet_shiftedPt_JetHFUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetHFyearDown"
        self.type1_pfMet_shiftedPt_JetHFyearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetHFyearDown")
        #if not self.type1_pfMet_shiftedPt_JetHFyearDown_branch and "type1_pfMet_shiftedPt_JetHFyearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetHFyearDown_branch and "type1_pfMet_shiftedPt_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetHFyearDown")
        else:
            self.type1_pfMet_shiftedPt_JetHFyearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetHFyearDown_value)

        #print "making type1_pfMet_shiftedPt_JetHFyearUp"
        self.type1_pfMet_shiftedPt_JetHFyearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetHFyearUp")
        #if not self.type1_pfMet_shiftedPt_JetHFyearUp_branch and "type1_pfMet_shiftedPt_JetHFyearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetHFyearUp_branch and "type1_pfMet_shiftedPt_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch type1_pfMet_shiftedPt_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetHFyearUp")
        else:
            self.type1_pfMet_shiftedPt_JetHFyearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetHFyearUp_value)

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

        #print "making vbfMass_JERDown"
        self.vbfMass_JERDown_branch = the_tree.GetBranch("vbfMass_JERDown")
        #if not self.vbfMass_JERDown_branch and "vbfMass_JERDown" not in self.complained:
        if not self.vbfMass_JERDown_branch and "vbfMass_JERDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JERDown")
        else:
            self.vbfMass_JERDown_branch.SetAddress(<void*>&self.vbfMass_JERDown_value)

        #print "making vbfMass_JERUp"
        self.vbfMass_JERUp_branch = the_tree.GetBranch("vbfMass_JERUp")
        #if not self.vbfMass_JERUp_branch and "vbfMass_JERUp" not in self.complained:
        if not self.vbfMass_JERUp_branch and "vbfMass_JERUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JERUp")
        else:
            self.vbfMass_JERUp_branch.SetAddress(<void*>&self.vbfMass_JERUp_value)

        #print "making vbfMass_JetAbsoluteDown"
        self.vbfMass_JetAbsoluteDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteDown")
        #if not self.vbfMass_JetAbsoluteDown_branch and "vbfMass_JetAbsoluteDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteDown_branch and "vbfMass_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteDown")
        else:
            self.vbfMass_JetAbsoluteDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteDown_value)

        #print "making vbfMass_JetAbsoluteUp"
        self.vbfMass_JetAbsoluteUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteUp")
        #if not self.vbfMass_JetAbsoluteUp_branch and "vbfMass_JetAbsoluteUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteUp_branch and "vbfMass_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteUp")
        else:
            self.vbfMass_JetAbsoluteUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteUp_value)

        #print "making vbfMass_JetAbsoluteyearDown"
        self.vbfMass_JetAbsoluteyearDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteyearDown")
        #if not self.vbfMass_JetAbsoluteyearDown_branch and "vbfMass_JetAbsoluteyearDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteyearDown_branch and "vbfMass_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteyearDown")
        else:
            self.vbfMass_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteyearDown_value)

        #print "making vbfMass_JetAbsoluteyearUp"
        self.vbfMass_JetAbsoluteyearUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteyearUp")
        #if not self.vbfMass_JetAbsoluteyearUp_branch and "vbfMass_JetAbsoluteyearUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteyearUp_branch and "vbfMass_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteyearUp")
        else:
            self.vbfMass_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteyearUp_value)

        #print "making vbfMass_JetBBEC1Down"
        self.vbfMass_JetBBEC1Down_branch = the_tree.GetBranch("vbfMass_JetBBEC1Down")
        #if not self.vbfMass_JetBBEC1Down_branch and "vbfMass_JetBBEC1Down" not in self.complained:
        if not self.vbfMass_JetBBEC1Down_branch and "vbfMass_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch vbfMass_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetBBEC1Down")
        else:
            self.vbfMass_JetBBEC1Down_branch.SetAddress(<void*>&self.vbfMass_JetBBEC1Down_value)

        #print "making vbfMass_JetBBEC1Up"
        self.vbfMass_JetBBEC1Up_branch = the_tree.GetBranch("vbfMass_JetBBEC1Up")
        #if not self.vbfMass_JetBBEC1Up_branch and "vbfMass_JetBBEC1Up" not in self.complained:
        if not self.vbfMass_JetBBEC1Up_branch and "vbfMass_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch vbfMass_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetBBEC1Up")
        else:
            self.vbfMass_JetBBEC1Up_branch.SetAddress(<void*>&self.vbfMass_JetBBEC1Up_value)

        #print "making vbfMass_JetBBEC1yearDown"
        self.vbfMass_JetBBEC1yearDown_branch = the_tree.GetBranch("vbfMass_JetBBEC1yearDown")
        #if not self.vbfMass_JetBBEC1yearDown_branch and "vbfMass_JetBBEC1yearDown" not in self.complained:
        if not self.vbfMass_JetBBEC1yearDown_branch and "vbfMass_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetBBEC1yearDown")
        else:
            self.vbfMass_JetBBEC1yearDown_branch.SetAddress(<void*>&self.vbfMass_JetBBEC1yearDown_value)

        #print "making vbfMass_JetBBEC1yearUp"
        self.vbfMass_JetBBEC1yearUp_branch = the_tree.GetBranch("vbfMass_JetBBEC1yearUp")
        #if not self.vbfMass_JetBBEC1yearUp_branch and "vbfMass_JetBBEC1yearUp" not in self.complained:
        if not self.vbfMass_JetBBEC1yearUp_branch and "vbfMass_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetBBEC1yearUp")
        else:
            self.vbfMass_JetBBEC1yearUp_branch.SetAddress(<void*>&self.vbfMass_JetBBEC1yearUp_value)

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

        #print "making vbfMass_JetEC2yearDown"
        self.vbfMass_JetEC2yearDown_branch = the_tree.GetBranch("vbfMass_JetEC2yearDown")
        #if not self.vbfMass_JetEC2yearDown_branch and "vbfMass_JetEC2yearDown" not in self.complained:
        if not self.vbfMass_JetEC2yearDown_branch and "vbfMass_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEC2yearDown")
        else:
            self.vbfMass_JetEC2yearDown_branch.SetAddress(<void*>&self.vbfMass_JetEC2yearDown_value)

        #print "making vbfMass_JetEC2yearUp"
        self.vbfMass_JetEC2yearUp_branch = the_tree.GetBranch("vbfMass_JetEC2yearUp")
        #if not self.vbfMass_JetEC2yearUp_branch and "vbfMass_JetEC2yearUp" not in self.complained:
        if not self.vbfMass_JetEC2yearUp_branch and "vbfMass_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEC2yearUp")
        else:
            self.vbfMass_JetEC2yearUp_branch.SetAddress(<void*>&self.vbfMass_JetEC2yearUp_value)

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

        #print "making vbfMass_JetHFDown"
        self.vbfMass_JetHFDown_branch = the_tree.GetBranch("vbfMass_JetHFDown")
        #if not self.vbfMass_JetHFDown_branch and "vbfMass_JetHFDown" not in self.complained:
        if not self.vbfMass_JetHFDown_branch and "vbfMass_JetHFDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetHFDown")
        else:
            self.vbfMass_JetHFDown_branch.SetAddress(<void*>&self.vbfMass_JetHFDown_value)

        #print "making vbfMass_JetHFUp"
        self.vbfMass_JetHFUp_branch = the_tree.GetBranch("vbfMass_JetHFUp")
        #if not self.vbfMass_JetHFUp_branch and "vbfMass_JetHFUp" not in self.complained:
        if not self.vbfMass_JetHFUp_branch and "vbfMass_JetHFUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetHFUp")
        else:
            self.vbfMass_JetHFUp_branch.SetAddress(<void*>&self.vbfMass_JetHFUp_value)

        #print "making vbfMass_JetHFyearDown"
        self.vbfMass_JetHFyearDown_branch = the_tree.GetBranch("vbfMass_JetHFyearDown")
        #if not self.vbfMass_JetHFyearDown_branch and "vbfMass_JetHFyearDown" not in self.complained:
        if not self.vbfMass_JetHFyearDown_branch and "vbfMass_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch vbfMass_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetHFyearDown")
        else:
            self.vbfMass_JetHFyearDown_branch.SetAddress(<void*>&self.vbfMass_JetHFyearDown_value)

        #print "making vbfMass_JetHFyearUp"
        self.vbfMass_JetHFyearUp_branch = the_tree.GetBranch("vbfMass_JetHFyearUp")
        #if not self.vbfMass_JetHFyearUp_branch and "vbfMass_JetHFyearUp" not in self.complained:
        if not self.vbfMass_JetHFyearUp_branch and "vbfMass_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch vbfMass_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetHFyearUp")
        else:
            self.vbfMass_JetHFyearUp_branch.SetAddress(<void*>&self.vbfMass_JetHFyearUp_value)

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

    property Mu50Pass:
        def __get__(self):
            self.Mu50Pass_branch.GetEntry(self.localentry, 0)
            return self.Mu50Pass_value

    property Phi:
        def __get__(self):
            self.Phi_branch.GetEntry(self.localentry, 0)
            return self.Phi_value

    property Pt:
        def __get__(self):
            self.Pt_branch.GetEntry(self.localentry, 0)
            return self.Pt_value

    property bjetDeepCSVVeto20Medium_2016_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2016_DR0p5_value

    property bjetDeepCSVVeto20Medium_2017_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2017_DR0p5_value

    property bjetDeepCSVVeto20Medium_2018_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2018_DR0p5_value

    property bjetDeepCSVVeto30Medium_2016_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto30Medium_2016_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto30Medium_2016_DR0p5_value

    property bjetDeepCSVVeto30Medium_2017_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto30Medium_2017_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto30Medium_2017_DR0p5_value

    property bjetDeepCSVVeto30Medium_2018_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto30Medium_2018_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto30Medium_2018_DR0p5_value

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

    property deepcsvb1_btagscore:
        def __get__(self):
            self.deepcsvb1_btagscore_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1_btagscore_value

    property deepcsvb1_eta:
        def __get__(self):
            self.deepcsvb1_eta_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1_eta_value

    property deepcsvb1_hadronflavour:
        def __get__(self):
            self.deepcsvb1_hadronflavour_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1_hadronflavour_value

    property deepcsvb1_m:
        def __get__(self):
            self.deepcsvb1_m_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1_m_value

    property deepcsvb1_phi:
        def __get__(self):
            self.deepcsvb1_phi_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1_phi_value

    property deepcsvb1_pt:
        def __get__(self):
            self.deepcsvb1_pt_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1_pt_value

    property deepcsvb2_btagscore:
        def __get__(self):
            self.deepcsvb2_btagscore_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2_btagscore_value

    property deepcsvb2_eta:
        def __get__(self):
            self.deepcsvb2_eta_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2_eta_value

    property deepcsvb2_hadronflavour:
        def __get__(self):
            self.deepcsvb2_hadronflavour_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2_hadronflavour_value

    property deepcsvb2_m:
        def __get__(self):
            self.deepcsvb2_m_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2_m_value

    property deepcsvb2_phi:
        def __get__(self):
            self.deepcsvb2_phi_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2_phi_value

    property deepcsvb2_pt:
        def __get__(self):
            self.deepcsvb2_pt_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2_pt_value

    property dielectronVeto:
        def __get__(self):
            self.dielectronVeto_branch.GetEntry(self.localentry, 0)
            return self.dielectronVeto_value

    property dimuonVeto:
        def __get__(self):
            self.dimuonVeto_branch.GetEntry(self.localentry, 0)
            return self.dimuonVeto_value

    property eCharge:
        def __get__(self):
            self.eCharge_branch.GetEntry(self.localentry, 0)
            return self.eCharge_value

    property eComesFromHiggs:
        def __get__(self):
            self.eComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.eComesFromHiggs_value

    property eCorrectedEt:
        def __get__(self):
            self.eCorrectedEt_branch.GetEntry(self.localentry, 0)
            return self.eCorrectedEt_value

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

    property eRelPFIsoRho:
        def __get__(self):
            self.eRelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.eRelPFIsoRho_value

    property eSIP2D:
        def __get__(self):
            self.eSIP2D_branch.GetEntry(self.localentry, 0)
            return self.eSIP2D_value

    property eSIP3D:
        def __get__(self):
            self.eSIP3D_branch.GetEntry(self.localentry, 0)
            return self.eSIP3D_value

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

    property eecalEnergy:
        def __get__(self):
            self.eecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.eecalEnergy_value

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

    property j1eta_JERDown:
        def __get__(self):
            self.j1eta_JERDown_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JERDown_value

    property j1eta_JERUp:
        def __get__(self):
            self.j1eta_JERUp_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JERUp_value

    property j1eta_JetAbsoluteDown:
        def __get__(self):
            self.j1eta_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetAbsoluteDown_value

    property j1eta_JetAbsoluteUp:
        def __get__(self):
            self.j1eta_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetAbsoluteUp_value

    property j1eta_JetAbsoluteyearDown:
        def __get__(self):
            self.j1eta_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetAbsoluteyearDown_value

    property j1eta_JetAbsoluteyearUp:
        def __get__(self):
            self.j1eta_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetAbsoluteyearUp_value

    property j1eta_JetBBEC1Down:
        def __get__(self):
            self.j1eta_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetBBEC1Down_value

    property j1eta_JetBBEC1Up:
        def __get__(self):
            self.j1eta_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetBBEC1Up_value

    property j1eta_JetBBEC1yearDown:
        def __get__(self):
            self.j1eta_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetBBEC1yearDown_value

    property j1eta_JetBBEC1yearUp:
        def __get__(self):
            self.j1eta_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetBBEC1yearUp_value

    property j1eta_JetEC2Down:
        def __get__(self):
            self.j1eta_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetEC2Down_value

    property j1eta_JetEC2Up:
        def __get__(self):
            self.j1eta_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetEC2Up_value

    property j1eta_JetEC2yearDown:
        def __get__(self):
            self.j1eta_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetEC2yearDown_value

    property j1eta_JetEC2yearUp:
        def __get__(self):
            self.j1eta_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetEC2yearUp_value

    property j1eta_JetFlavorQCDDown:
        def __get__(self):
            self.j1eta_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetFlavorQCDDown_value

    property j1eta_JetFlavorQCDUp:
        def __get__(self):
            self.j1eta_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetFlavorQCDUp_value

    property j1eta_JetHFDown:
        def __get__(self):
            self.j1eta_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetHFDown_value

    property j1eta_JetHFUp:
        def __get__(self):
            self.j1eta_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetHFUp_value

    property j1eta_JetHFyearDown:
        def __get__(self):
            self.j1eta_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetHFyearDown_value

    property j1eta_JetHFyearUp:
        def __get__(self):
            self.j1eta_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetHFyearUp_value

    property j1eta_JetRelativeBalDown:
        def __get__(self):
            self.j1eta_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetRelativeBalDown_value

    property j1eta_JetRelativeBalUp:
        def __get__(self):
            self.j1eta_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetRelativeBalUp_value

    property j1eta_JetRelativeSampleDown:
        def __get__(self):
            self.j1eta_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetRelativeSampleDown_value

    property j1eta_JetRelativeSampleUp:
        def __get__(self):
            self.j1eta_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.j1eta_JetRelativeSampleUp_value

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

    property j1phi_JERDown:
        def __get__(self):
            self.j1phi_JERDown_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JERDown_value

    property j1phi_JERUp:
        def __get__(self):
            self.j1phi_JERUp_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JERUp_value

    property j1phi_JetAbsoluteDown:
        def __get__(self):
            self.j1phi_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetAbsoluteDown_value

    property j1phi_JetAbsoluteUp:
        def __get__(self):
            self.j1phi_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetAbsoluteUp_value

    property j1phi_JetAbsoluteyearDown:
        def __get__(self):
            self.j1phi_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetAbsoluteyearDown_value

    property j1phi_JetAbsoluteyearUp:
        def __get__(self):
            self.j1phi_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetAbsoluteyearUp_value

    property j1phi_JetBBEC1Down:
        def __get__(self):
            self.j1phi_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetBBEC1Down_value

    property j1phi_JetBBEC1Up:
        def __get__(self):
            self.j1phi_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetBBEC1Up_value

    property j1phi_JetBBEC1yearDown:
        def __get__(self):
            self.j1phi_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetBBEC1yearDown_value

    property j1phi_JetBBEC1yearUp:
        def __get__(self):
            self.j1phi_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetBBEC1yearUp_value

    property j1phi_JetEC2Down:
        def __get__(self):
            self.j1phi_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetEC2Down_value

    property j1phi_JetEC2Up:
        def __get__(self):
            self.j1phi_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetEC2Up_value

    property j1phi_JetEC2yearDown:
        def __get__(self):
            self.j1phi_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetEC2yearDown_value

    property j1phi_JetEC2yearUp:
        def __get__(self):
            self.j1phi_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetEC2yearUp_value

    property j1phi_JetFlavorQCDDown:
        def __get__(self):
            self.j1phi_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetFlavorQCDDown_value

    property j1phi_JetFlavorQCDUp:
        def __get__(self):
            self.j1phi_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetFlavorQCDUp_value

    property j1phi_JetHFDown:
        def __get__(self):
            self.j1phi_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetHFDown_value

    property j1phi_JetHFUp:
        def __get__(self):
            self.j1phi_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetHFUp_value

    property j1phi_JetHFyearDown:
        def __get__(self):
            self.j1phi_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetHFyearDown_value

    property j1phi_JetHFyearUp:
        def __get__(self):
            self.j1phi_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetHFyearUp_value

    property j1phi_JetRelativeBalDown:
        def __get__(self):
            self.j1phi_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetRelativeBalDown_value

    property j1phi_JetRelativeBalUp:
        def __get__(self):
            self.j1phi_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetRelativeBalUp_value

    property j1phi_JetRelativeSampleDown:
        def __get__(self):
            self.j1phi_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetRelativeSampleDown_value

    property j1phi_JetRelativeSampleUp:
        def __get__(self):
            self.j1phi_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.j1phi_JetRelativeSampleUp_value

    property j1pt:
        def __get__(self):
            self.j1pt_branch.GetEntry(self.localentry, 0)
            return self.j1pt_value

    property j1ptWoNoisyJets:
        def __get__(self):
            self.j1ptWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_value

    property j1pt_JERDown:
        def __get__(self):
            self.j1pt_JERDown_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JERDown_value

    property j1pt_JERUp:
        def __get__(self):
            self.j1pt_JERUp_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JERUp_value

    property j1pt_JetAbsoluteDown:
        def __get__(self):
            self.j1pt_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetAbsoluteDown_value

    property j1pt_JetAbsoluteUp:
        def __get__(self):
            self.j1pt_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetAbsoluteUp_value

    property j1pt_JetAbsoluteyearDown:
        def __get__(self):
            self.j1pt_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetAbsoluteyearDown_value

    property j1pt_JetAbsoluteyearUp:
        def __get__(self):
            self.j1pt_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetAbsoluteyearUp_value

    property j1pt_JetBBEC1Down:
        def __get__(self):
            self.j1pt_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetBBEC1Down_value

    property j1pt_JetBBEC1Up:
        def __get__(self):
            self.j1pt_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetBBEC1Up_value

    property j1pt_JetBBEC1yearDown:
        def __get__(self):
            self.j1pt_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetBBEC1yearDown_value

    property j1pt_JetBBEC1yearUp:
        def __get__(self):
            self.j1pt_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetBBEC1yearUp_value

    property j1pt_JetEC2Down:
        def __get__(self):
            self.j1pt_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetEC2Down_value

    property j1pt_JetEC2Up:
        def __get__(self):
            self.j1pt_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetEC2Up_value

    property j1pt_JetEC2yearDown:
        def __get__(self):
            self.j1pt_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetEC2yearDown_value

    property j1pt_JetEC2yearUp:
        def __get__(self):
            self.j1pt_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetEC2yearUp_value

    property j1pt_JetFlavorQCDDown:
        def __get__(self):
            self.j1pt_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetFlavorQCDDown_value

    property j1pt_JetFlavorQCDUp:
        def __get__(self):
            self.j1pt_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetFlavorQCDUp_value

    property j1pt_JetHFDown:
        def __get__(self):
            self.j1pt_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetHFDown_value

    property j1pt_JetHFUp:
        def __get__(self):
            self.j1pt_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetHFUp_value

    property j1pt_JetHFyearDown:
        def __get__(self):
            self.j1pt_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetHFyearDown_value

    property j1pt_JetHFyearUp:
        def __get__(self):
            self.j1pt_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.j1pt_JetHFyearUp_value

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

    property j2eta_JERDown:
        def __get__(self):
            self.j2eta_JERDown_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JERDown_value

    property j2eta_JERUp:
        def __get__(self):
            self.j2eta_JERUp_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JERUp_value

    property j2eta_JetAbsoluteDown:
        def __get__(self):
            self.j2eta_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetAbsoluteDown_value

    property j2eta_JetAbsoluteUp:
        def __get__(self):
            self.j2eta_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetAbsoluteUp_value

    property j2eta_JetAbsoluteyearDown:
        def __get__(self):
            self.j2eta_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetAbsoluteyearDown_value

    property j2eta_JetAbsoluteyearUp:
        def __get__(self):
            self.j2eta_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetAbsoluteyearUp_value

    property j2eta_JetBBEC1Down:
        def __get__(self):
            self.j2eta_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetBBEC1Down_value

    property j2eta_JetBBEC1Up:
        def __get__(self):
            self.j2eta_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetBBEC1Up_value

    property j2eta_JetBBEC1yearDown:
        def __get__(self):
            self.j2eta_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetBBEC1yearDown_value

    property j2eta_JetBBEC1yearUp:
        def __get__(self):
            self.j2eta_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetBBEC1yearUp_value

    property j2eta_JetEC2Down:
        def __get__(self):
            self.j2eta_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetEC2Down_value

    property j2eta_JetEC2Up:
        def __get__(self):
            self.j2eta_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetEC2Up_value

    property j2eta_JetEC2yearDown:
        def __get__(self):
            self.j2eta_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetEC2yearDown_value

    property j2eta_JetEC2yearUp:
        def __get__(self):
            self.j2eta_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetEC2yearUp_value

    property j2eta_JetFlavorQCDDown:
        def __get__(self):
            self.j2eta_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetFlavorQCDDown_value

    property j2eta_JetFlavorQCDUp:
        def __get__(self):
            self.j2eta_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetFlavorQCDUp_value

    property j2eta_JetHFDown:
        def __get__(self):
            self.j2eta_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetHFDown_value

    property j2eta_JetHFUp:
        def __get__(self):
            self.j2eta_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetHFUp_value

    property j2eta_JetHFyearDown:
        def __get__(self):
            self.j2eta_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetHFyearDown_value

    property j2eta_JetHFyearUp:
        def __get__(self):
            self.j2eta_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetHFyearUp_value

    property j2eta_JetRelativeBalDown:
        def __get__(self):
            self.j2eta_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetRelativeBalDown_value

    property j2eta_JetRelativeBalUp:
        def __get__(self):
            self.j2eta_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetRelativeBalUp_value

    property j2eta_JetRelativeSampleDown:
        def __get__(self):
            self.j2eta_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetRelativeSampleDown_value

    property j2eta_JetRelativeSampleUp:
        def __get__(self):
            self.j2eta_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.j2eta_JetRelativeSampleUp_value

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

    property j2phi_JERDown:
        def __get__(self):
            self.j2phi_JERDown_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JERDown_value

    property j2phi_JERUp:
        def __get__(self):
            self.j2phi_JERUp_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JERUp_value

    property j2phi_JetAbsoluteDown:
        def __get__(self):
            self.j2phi_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetAbsoluteDown_value

    property j2phi_JetAbsoluteUp:
        def __get__(self):
            self.j2phi_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetAbsoluteUp_value

    property j2phi_JetAbsoluteyearDown:
        def __get__(self):
            self.j2phi_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetAbsoluteyearDown_value

    property j2phi_JetAbsoluteyearUp:
        def __get__(self):
            self.j2phi_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetAbsoluteyearUp_value

    property j2phi_JetBBEC1Down:
        def __get__(self):
            self.j2phi_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetBBEC1Down_value

    property j2phi_JetBBEC1Up:
        def __get__(self):
            self.j2phi_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetBBEC1Up_value

    property j2phi_JetBBEC1yearDown:
        def __get__(self):
            self.j2phi_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetBBEC1yearDown_value

    property j2phi_JetBBEC1yearUp:
        def __get__(self):
            self.j2phi_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetBBEC1yearUp_value

    property j2phi_JetEC2Down:
        def __get__(self):
            self.j2phi_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetEC2Down_value

    property j2phi_JetEC2Up:
        def __get__(self):
            self.j2phi_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetEC2Up_value

    property j2phi_JetEC2yearDown:
        def __get__(self):
            self.j2phi_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetEC2yearDown_value

    property j2phi_JetEC2yearUp:
        def __get__(self):
            self.j2phi_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetEC2yearUp_value

    property j2phi_JetFlavorQCDDown:
        def __get__(self):
            self.j2phi_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetFlavorQCDDown_value

    property j2phi_JetFlavorQCDUp:
        def __get__(self):
            self.j2phi_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetFlavorQCDUp_value

    property j2phi_JetHFDown:
        def __get__(self):
            self.j2phi_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetHFDown_value

    property j2phi_JetHFUp:
        def __get__(self):
            self.j2phi_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetHFUp_value

    property j2phi_JetHFyearDown:
        def __get__(self):
            self.j2phi_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetHFyearDown_value

    property j2phi_JetHFyearUp:
        def __get__(self):
            self.j2phi_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetHFyearUp_value

    property j2phi_JetRelativeBalDown:
        def __get__(self):
            self.j2phi_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetRelativeBalDown_value

    property j2phi_JetRelativeBalUp:
        def __get__(self):
            self.j2phi_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetRelativeBalUp_value

    property j2phi_JetRelativeSampleDown:
        def __get__(self):
            self.j2phi_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetRelativeSampleDown_value

    property j2phi_JetRelativeSampleUp:
        def __get__(self):
            self.j2phi_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.j2phi_JetRelativeSampleUp_value

    property j2pt:
        def __get__(self):
            self.j2pt_branch.GetEntry(self.localentry, 0)
            return self.j2pt_value

    property j2ptWoNoisyJets:
        def __get__(self):
            self.j2ptWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_value

    property j2pt_JERDown:
        def __get__(self):
            self.j2pt_JERDown_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JERDown_value

    property j2pt_JERUp:
        def __get__(self):
            self.j2pt_JERUp_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JERUp_value

    property j2pt_JetAbsoluteDown:
        def __get__(self):
            self.j2pt_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetAbsoluteDown_value

    property j2pt_JetAbsoluteUp:
        def __get__(self):
            self.j2pt_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetAbsoluteUp_value

    property j2pt_JetAbsoluteyearDown:
        def __get__(self):
            self.j2pt_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetAbsoluteyearDown_value

    property j2pt_JetAbsoluteyearUp:
        def __get__(self):
            self.j2pt_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetAbsoluteyearUp_value

    property j2pt_JetBBEC1Down:
        def __get__(self):
            self.j2pt_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetBBEC1Down_value

    property j2pt_JetBBEC1Up:
        def __get__(self):
            self.j2pt_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetBBEC1Up_value

    property j2pt_JetBBEC1yearDown:
        def __get__(self):
            self.j2pt_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetBBEC1yearDown_value

    property j2pt_JetBBEC1yearUp:
        def __get__(self):
            self.j2pt_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetBBEC1yearUp_value

    property j2pt_JetEC2Down:
        def __get__(self):
            self.j2pt_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetEC2Down_value

    property j2pt_JetEC2Up:
        def __get__(self):
            self.j2pt_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetEC2Up_value

    property j2pt_JetEC2yearDown:
        def __get__(self):
            self.j2pt_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetEC2yearDown_value

    property j2pt_JetEC2yearUp:
        def __get__(self):
            self.j2pt_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetEC2yearUp_value

    property j2pt_JetFlavorQCDDown:
        def __get__(self):
            self.j2pt_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetFlavorQCDDown_value

    property j2pt_JetFlavorQCDUp:
        def __get__(self):
            self.j2pt_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetFlavorQCDUp_value

    property j2pt_JetHFDown:
        def __get__(self):
            self.j2pt_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetHFDown_value

    property j2pt_JetHFUp:
        def __get__(self):
            self.j2pt_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetHFUp_value

    property j2pt_JetHFyearDown:
        def __get__(self):
            self.j2pt_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetHFyearDown_value

    property j2pt_JetHFyearUp:
        def __get__(self):
            self.j2pt_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.j2pt_JetHFyearUp_value

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

    property jetVeto30:
        def __get__(self):
            self.jetVeto30_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_value

    property jetVeto30WoNoisyJets:
        def __get__(self):
            self.jetVeto30WoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_value

    property jetVeto30_JERDown:
        def __get__(self):
            self.jetVeto30_JERDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JERDown_value

    property jetVeto30_JERUp:
        def __get__(self):
            self.jetVeto30_JERUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JERUp_value

    property jetVeto30_JetAbsoluteDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteDown_value

    property jetVeto30_JetAbsoluteUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteUp_value

    property jetVeto30_JetAbsoluteyearDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteyearDown_value

    property jetVeto30_JetAbsoluteyearUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteyearUp_value

    property jetVeto30_JetBBEC1Down:
        def __get__(self):
            self.jetVeto30_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetBBEC1Down_value

    property jetVeto30_JetBBEC1Up:
        def __get__(self):
            self.jetVeto30_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetBBEC1Up_value

    property jetVeto30_JetBBEC1yearDown:
        def __get__(self):
            self.jetVeto30_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetBBEC1yearDown_value

    property jetVeto30_JetBBEC1yearUp:
        def __get__(self):
            self.jetVeto30_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetBBEC1yearUp_value

    property jetVeto30_JetEC2Down:
        def __get__(self):
            self.jetVeto30_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEC2Down_value

    property jetVeto30_JetEC2Up:
        def __get__(self):
            self.jetVeto30_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEC2Up_value

    property jetVeto30_JetEC2yearDown:
        def __get__(self):
            self.jetVeto30_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEC2yearDown_value

    property jetVeto30_JetEC2yearUp:
        def __get__(self):
            self.jetVeto30_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEC2yearUp_value

    property jetVeto30_JetFlavorQCDDown:
        def __get__(self):
            self.jetVeto30_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFlavorQCDDown_value

    property jetVeto30_JetFlavorQCDUp:
        def __get__(self):
            self.jetVeto30_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFlavorQCDUp_value

    property jetVeto30_JetHFDown:
        def __get__(self):
            self.jetVeto30_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetHFDown_value

    property jetVeto30_JetHFUp:
        def __get__(self):
            self.jetVeto30_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetHFUp_value

    property jetVeto30_JetHFyearDown:
        def __get__(self):
            self.jetVeto30_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetHFyearDown_value

    property jetVeto30_JetHFyearUp:
        def __get__(self):
            self.jetVeto30_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetHFyearUp_value

    property jetVeto30_JetRelativeBalDown:
        def __get__(self):
            self.jetVeto30_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeBalDown_value

    property jetVeto30_JetRelativeBalUp:
        def __get__(self):
            self.jetVeto30_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeBalUp_value

    property jetVeto30_JetRelativeSampleDown:
        def __get__(self):
            self.jetVeto30_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeSampleDown_value

    property jetVeto30_JetRelativeSampleUp:
        def __get__(self):
            self.jetVeto30_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeSampleUp_value

    property jetVeto30_JetTotalDown:
        def __get__(self):
            self.jetVeto30_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTotalDown_value

    property jetVeto30_JetTotalUp:
        def __get__(self):
            self.jetVeto30_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTotalUp_value

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

    property lheweight13:
        def __get__(self):
            self.lheweight13_branch.GetEntry(self.localentry, 0)
            return self.lheweight13_value

    property lheweight14:
        def __get__(self):
            self.lheweight14_branch.GetEntry(self.localentry, 0)
            return self.lheweight14_value

    property lheweight15:
        def __get__(self):
            self.lheweight15_branch.GetEntry(self.localentry, 0)
            return self.lheweight15_value

    property lheweight16:
        def __get__(self):
            self.lheweight16_branch.GetEntry(self.localentry, 0)
            return self.lheweight16_value

    property lheweight17:
        def __get__(self):
            self.lheweight17_branch.GetEntry(self.localentry, 0)
            return self.lheweight17_value

    property lheweight18:
        def __get__(self):
            self.lheweight18_branch.GetEntry(self.localentry, 0)
            return self.lheweight18_value

    property lheweight19:
        def __get__(self):
            self.lheweight19_branch.GetEntry(self.localentry, 0)
            return self.lheweight19_value

    property lheweight2:
        def __get__(self):
            self.lheweight2_branch.GetEntry(self.localentry, 0)
            return self.lheweight2_value

    property lheweight20:
        def __get__(self):
            self.lheweight20_branch.GetEntry(self.localentry, 0)
            return self.lheweight20_value

    property lheweight21:
        def __get__(self):
            self.lheweight21_branch.GetEntry(self.localentry, 0)
            return self.lheweight21_value

    property lheweight22:
        def __get__(self):
            self.lheweight22_branch.GetEntry(self.localentry, 0)
            return self.lheweight22_value

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

    property mCharge:
        def __get__(self):
            self.mCharge_branch.GetEntry(self.localentry, 0)
            return self.mCharge_value

    property mComesFromHiggs:
        def __get__(self):
            self.mComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.mComesFromHiggs_value

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

    property mMass:
        def __get__(self):
            self.mMass_branch.GetEntry(self.localentry, 0)
            return self.mMass_value

    property mMatchEmbeddedFilterMu24:
        def __get__(self):
            self.mMatchEmbeddedFilterMu24_branch.GetEntry(self.localentry, 0)
            return self.mMatchEmbeddedFilterMu24_value

    property mMatchEmbeddedFilterMu27:
        def __get__(self):
            self.mMatchEmbeddedFilterMu27_branch.GetEntry(self.localentry, 0)
            return self.mMatchEmbeddedFilterMu27_value

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

    property mPt:
        def __get__(self):
            self.mPt_branch.GetEntry(self.localentry, 0)
            return self.mPt_value

    property mRelPFIsoDBDefaultR04:
        def __get__(self):
            self.mRelPFIsoDBDefaultR04_branch.GetEntry(self.localentry, 0)
            return self.mRelPFIsoDBDefaultR04_value

    property mSIP2D:
        def __get__(self):
            self.mSIP2D_branch.GetEntry(self.localentry, 0)
            return self.mSIP2D_value

    property mSIP3D:
        def __get__(self):
            self.mSIP3D_branch.GetEntry(self.localentry, 0)
            return self.mSIP3D_value

    property mVZ:
        def __get__(self):
            self.mVZ_branch.GetEntry(self.localentry, 0)
            return self.mVZ_value

    property mZTTGenMatching:
        def __get__(self):
            self.mZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.mZTTGenMatching_value

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

    property tauVetoPt20LooseMVALTVtx:
        def __get__(self):
            self.tauVetoPt20LooseMVALTVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20LooseMVALTVtx_value

    property tauVetoPtDeepVtx:
        def __get__(self):
            self.tauVetoPtDeepVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPtDeepVtx_value

    property topQuarkPt1:
        def __get__(self):
            self.topQuarkPt1_branch.GetEntry(self.localentry, 0)
            return self.topQuarkPt1_value

    property topQuarkPt2:
        def __get__(self):
            self.topQuarkPt2_branch.GetEntry(self.localentry, 0)
            return self.topQuarkPt2_value

    property type1_pfMetEt:
        def __get__(self):
            self.type1_pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetEt_value

    property type1_pfMetPhi:
        def __get__(self):
            self.type1_pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetPhi_value

    property type1_pfMet_shiftedPhi_JERDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JERDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JERDown_value

    property type1_pfMet_shiftedPhi_JERUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JERUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JERUp_value

    property type1_pfMet_shiftedPhi_JetAbsoluteDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteDown_value

    property type1_pfMet_shiftedPhi_JetAbsoluteUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteUp_value

    property type1_pfMet_shiftedPhi_JetAbsoluteyearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_value

    property type1_pfMet_shiftedPhi_JetAbsoluteyearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_value

    property type1_pfMet_shiftedPhi_JetBBEC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetBBEC1Down_value

    property type1_pfMet_shiftedPhi_JetBBEC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetBBEC1Up_value

    property type1_pfMet_shiftedPhi_JetBBEC1yearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_value

    property type1_pfMet_shiftedPhi_JetBBEC1yearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_value

    property type1_pfMet_shiftedPhi_JetEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEC2Down_value

    property type1_pfMet_shiftedPhi_JetEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEC2Up_value

    property type1_pfMet_shiftedPhi_JetEC2yearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEC2yearDown_value

    property type1_pfMet_shiftedPhi_JetEC2yearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEC2yearUp_value

    property type1_pfMet_shiftedPhi_JetEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEnDown_value

    property type1_pfMet_shiftedPhi_JetEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEnUp_value

    property type1_pfMet_shiftedPhi_JetFlavorQCDDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_value

    property type1_pfMet_shiftedPhi_JetFlavorQCDUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_value

    property type1_pfMet_shiftedPhi_JetHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetHFDown_value

    property type1_pfMet_shiftedPhi_JetHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetHFUp_value

    property type1_pfMet_shiftedPhi_JetHFyearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetHFyearDown_value

    property type1_pfMet_shiftedPhi_JetHFyearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetHFyearUp_value

    property type1_pfMet_shiftedPhi_JetRelativeBalDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeBalDown_value

    property type1_pfMet_shiftedPhi_JetRelativeBalUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeBalUp_value

    property type1_pfMet_shiftedPhi_JetRelativeSampleDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_value

    property type1_pfMet_shiftedPhi_JetRelativeSampleUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_value

    property type1_pfMet_shiftedPhi_JetResDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetResDown_value

    property type1_pfMet_shiftedPhi_JetResUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetResUp_value

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

    property type1_pfMet_shiftedPt_JERDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JERDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JERDown_value

    property type1_pfMet_shiftedPt_JERUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JERUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JERUp_value

    property type1_pfMet_shiftedPt_JetAbsoluteDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteDown_value

    property type1_pfMet_shiftedPt_JetAbsoluteUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteUp_value

    property type1_pfMet_shiftedPt_JetAbsoluteyearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_value

    property type1_pfMet_shiftedPt_JetAbsoluteyearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_value

    property type1_pfMet_shiftedPt_JetBBEC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetBBEC1Down_value

    property type1_pfMet_shiftedPt_JetBBEC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetBBEC1Up_value

    property type1_pfMet_shiftedPt_JetBBEC1yearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetBBEC1yearDown_value

    property type1_pfMet_shiftedPt_JetBBEC1yearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetBBEC1yearUp_value

    property type1_pfMet_shiftedPt_JetEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEC2Down_value

    property type1_pfMet_shiftedPt_JetEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEC2Up_value

    property type1_pfMet_shiftedPt_JetEC2yearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEC2yearDown_value

    property type1_pfMet_shiftedPt_JetEC2yearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEC2yearUp_value

    property type1_pfMet_shiftedPt_JetEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEnDown_value

    property type1_pfMet_shiftedPt_JetEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEnUp_value

    property type1_pfMet_shiftedPt_JetFlavorQCDDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetFlavorQCDDown_value

    property type1_pfMet_shiftedPt_JetFlavorQCDUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetFlavorQCDUp_value

    property type1_pfMet_shiftedPt_JetHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetHFDown_value

    property type1_pfMet_shiftedPt_JetHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetHFUp_value

    property type1_pfMet_shiftedPt_JetHFyearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetHFyearDown_value

    property type1_pfMet_shiftedPt_JetHFyearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetHFyearUp_value

    property type1_pfMet_shiftedPt_JetRelativeBalDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeBalDown_value

    property type1_pfMet_shiftedPt_JetRelativeBalUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeBalUp_value

    property type1_pfMet_shiftedPt_JetRelativeSampleDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeSampleDown_value

    property type1_pfMet_shiftedPt_JetRelativeSampleUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeSampleUp_value

    property type1_pfMet_shiftedPt_JetResDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetResDown_value

    property type1_pfMet_shiftedPt_JetResUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetResUp_value

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

    property vbfMass_JERDown:
        def __get__(self):
            self.vbfMass_JERDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JERDown_value

    property vbfMass_JERUp:
        def __get__(self):
            self.vbfMass_JERUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JERUp_value

    property vbfMass_JetAbsoluteDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteDown_value

    property vbfMass_JetAbsoluteUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteUp_value

    property vbfMass_JetAbsoluteyearDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteyearDown_value

    property vbfMass_JetAbsoluteyearUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteyearUp_value

    property vbfMass_JetBBEC1Down:
        def __get__(self):
            self.vbfMass_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetBBEC1Down_value

    property vbfMass_JetBBEC1Up:
        def __get__(self):
            self.vbfMass_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetBBEC1Up_value

    property vbfMass_JetBBEC1yearDown:
        def __get__(self):
            self.vbfMass_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetBBEC1yearDown_value

    property vbfMass_JetBBEC1yearUp:
        def __get__(self):
            self.vbfMass_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetBBEC1yearUp_value

    property vbfMass_JetEC2Down:
        def __get__(self):
            self.vbfMass_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEC2Down_value

    property vbfMass_JetEC2Up:
        def __get__(self):
            self.vbfMass_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEC2Up_value

    property vbfMass_JetEC2yearDown:
        def __get__(self):
            self.vbfMass_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEC2yearDown_value

    property vbfMass_JetEC2yearUp:
        def __get__(self):
            self.vbfMass_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEC2yearUp_value

    property vbfMass_JetFlavorQCDDown:
        def __get__(self):
            self.vbfMass_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFlavorQCDDown_value

    property vbfMass_JetFlavorQCDUp:
        def __get__(self):
            self.vbfMass_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFlavorQCDUp_value

    property vbfMass_JetHFDown:
        def __get__(self):
            self.vbfMass_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetHFDown_value

    property vbfMass_JetHFUp:
        def __get__(self):
            self.vbfMass_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetHFUp_value

    property vbfMass_JetHFyearDown:
        def __get__(self):
            self.vbfMass_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetHFyearDown_value

    property vbfMass_JetHFyearUp:
        def __get__(self):
            self.vbfMass_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetHFyearUp_value

    property vbfMass_JetRelativeBalDown:
        def __get__(self):
            self.vbfMass_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeBalDown_value

    property vbfMass_JetRelativeBalUp:
        def __get__(self):
            self.vbfMass_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeBalUp_value

    property vbfMass_JetRelativeSampleDown:
        def __get__(self):
            self.vbfMass_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeSampleDown_value

    property vbfMass_JetRelativeSampleUp:
        def __get__(self):
            self.vbfMass_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeSampleUp_value

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


