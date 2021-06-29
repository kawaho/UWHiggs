

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

    cdef TBranch* EmbPtWeight_branch
    cdef float EmbPtWeight_value

    cdef TBranch* Flag_BadChargedCandidateFilter_branch
    cdef float Flag_BadChargedCandidateFilter_value

    cdef TBranch* Flag_BadPFMuonDzFilter_branch
    cdef float Flag_BadPFMuonDzFilter_value

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

    cdef TBranch* Flag_eeBadScFilter_branch
    cdef float Flag_eeBadScFilter_value

    cdef TBranch* Flag_globalSuperTightHalo2016Filter_branch
    cdef float Flag_globalSuperTightHalo2016Filter_value

    cdef TBranch* Flag_goodVertices_branch
    cdef float Flag_goodVertices_value

    cdef TBranch* GenWeight_branch
    cdef float GenWeight_value

    cdef TBranch* IsoMu20Pass_branch
    cdef float IsoMu20Pass_value

    cdef TBranch* IsoMu22Pass_branch
    cdef float IsoMu22Pass_value

    cdef TBranch* IsoMu22eta2p1Pass_branch
    cdef float IsoMu22eta2p1Pass_value

    cdef TBranch* IsoMu24Pass_branch
    cdef float IsoMu24Pass_value

    cdef TBranch* IsoMu27Pass_branch
    cdef float IsoMu27Pass_value

    cdef TBranch* NUP_branch
    cdef float NUP_value

    cdef TBranch* bjetDeepCSVVeto20Loose_2016_DR0p4_branch
    cdef float bjetDeepCSVVeto20Loose_2016_DR0p4_value

    cdef TBranch* bjetDeepCSVVeto20Loose_2017_DR0p4_branch
    cdef float bjetDeepCSVVeto20Loose_2017_DR0p4_value

    cdef TBranch* bjetDeepCSVVeto20Loose_2018_DR0p4_branch
    cdef float bjetDeepCSVVeto20Loose_2018_DR0p4_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2016_DR0p4_branch
    cdef float bjetDeepCSVVeto20Medium_2016_DR0p4_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2017_DR0p4_branch
    cdef float bjetDeepCSVVeto20Medium_2017_DR0p4_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2018_DR0p4_branch
    cdef float bjetDeepCSVVeto20Medium_2018_DR0p4_value

    cdef TBranch* bjetDeepFlavourVeto20Loose_2016_DR0p4_branch
    cdef float bjetDeepFlavourVeto20Loose_2016_DR0p4_value

    cdef TBranch* bjetDeepFlavourVeto20Loose_2017_DR0p4_branch
    cdef float bjetDeepFlavourVeto20Loose_2017_DR0p4_value

    cdef TBranch* bjetDeepFlavourVeto20Loose_2018_DR0p4_branch
    cdef float bjetDeepFlavourVeto20Loose_2018_DR0p4_value

    cdef TBranch* bjetDeepFlavourVeto20Medium_2016_DR0p4_branch
    cdef float bjetDeepFlavourVeto20Medium_2016_DR0p4_value

    cdef TBranch* bjetDeepFlavourVeto20Medium_2017_DR0p4_branch
    cdef float bjetDeepFlavourVeto20Medium_2017_DR0p4_value

    cdef TBranch* bjetDeepFlavourVeto20Medium_2018_DR0p4_branch
    cdef float bjetDeepFlavourVeto20Medium_2018_DR0p4_value

    cdef TBranch* deepcsvb1Loose_btagscore_2017_branch
    cdef float deepcsvb1Loose_btagscore_2017_value

    cdef TBranch* deepcsvb1Loose_btagscore_2018_branch
    cdef float deepcsvb1Loose_btagscore_2018_value

    cdef TBranch* deepcsvb1Loose_eta_2017_branch
    cdef float deepcsvb1Loose_eta_2017_value

    cdef TBranch* deepcsvb1Loose_eta_2018_branch
    cdef float deepcsvb1Loose_eta_2018_value

    cdef TBranch* deepcsvb1Loose_hadronflavour_2017_branch
    cdef float deepcsvb1Loose_hadronflavour_2017_value

    cdef TBranch* deepcsvb1Loose_hadronflavour_2018_branch
    cdef float deepcsvb1Loose_hadronflavour_2018_value

    cdef TBranch* deepcsvb1Loose_m_2017_branch
    cdef float deepcsvb1Loose_m_2017_value

    cdef TBranch* deepcsvb1Loose_m_2018_branch
    cdef float deepcsvb1Loose_m_2018_value

    cdef TBranch* deepcsvb1Loose_phi_2017_branch
    cdef float deepcsvb1Loose_phi_2017_value

    cdef TBranch* deepcsvb1Loose_phi_2018_branch
    cdef float deepcsvb1Loose_phi_2018_value

    cdef TBranch* deepcsvb1Loose_pt_2017_branch
    cdef float deepcsvb1Loose_pt_2017_value

    cdef TBranch* deepcsvb1Loose_pt_2018_branch
    cdef float deepcsvb1Loose_pt_2018_value

    cdef TBranch* deepcsvb1Medium_btagscore_2017_branch
    cdef float deepcsvb1Medium_btagscore_2017_value

    cdef TBranch* deepcsvb1Medium_btagscore_2018_branch
    cdef float deepcsvb1Medium_btagscore_2018_value

    cdef TBranch* deepcsvb1Medium_eta_2017_branch
    cdef float deepcsvb1Medium_eta_2017_value

    cdef TBranch* deepcsvb1Medium_eta_2018_branch
    cdef float deepcsvb1Medium_eta_2018_value

    cdef TBranch* deepcsvb1Medium_hadronflavour_2017_branch
    cdef float deepcsvb1Medium_hadronflavour_2017_value

    cdef TBranch* deepcsvb1Medium_hadronflavour_2018_branch
    cdef float deepcsvb1Medium_hadronflavour_2018_value

    cdef TBranch* deepcsvb1Medium_m_2017_branch
    cdef float deepcsvb1Medium_m_2017_value

    cdef TBranch* deepcsvb1Medium_m_2018_branch
    cdef float deepcsvb1Medium_m_2018_value

    cdef TBranch* deepcsvb1Medium_phi_2017_branch
    cdef float deepcsvb1Medium_phi_2017_value

    cdef TBranch* deepcsvb1Medium_phi_2018_branch
    cdef float deepcsvb1Medium_phi_2018_value

    cdef TBranch* deepcsvb1Medium_pt_2017_branch
    cdef float deepcsvb1Medium_pt_2017_value

    cdef TBranch* deepcsvb1Medium_pt_2018_branch
    cdef float deepcsvb1Medium_pt_2018_value

    cdef TBranch* deepcsvb2Loose_btagscore_2017_branch
    cdef float deepcsvb2Loose_btagscore_2017_value

    cdef TBranch* deepcsvb2Loose_btagscore_2018_branch
    cdef float deepcsvb2Loose_btagscore_2018_value

    cdef TBranch* deepcsvb2Loose_eta_2017_branch
    cdef float deepcsvb2Loose_eta_2017_value

    cdef TBranch* deepcsvb2Loose_eta_2018_branch
    cdef float deepcsvb2Loose_eta_2018_value

    cdef TBranch* deepcsvb2Loose_hadronflavour_2017_branch
    cdef float deepcsvb2Loose_hadronflavour_2017_value

    cdef TBranch* deepcsvb2Loose_hadronflavour_2018_branch
    cdef float deepcsvb2Loose_hadronflavour_2018_value

    cdef TBranch* deepcsvb2Loose_m_2017_branch
    cdef float deepcsvb2Loose_m_2017_value

    cdef TBranch* deepcsvb2Loose_m_2018_branch
    cdef float deepcsvb2Loose_m_2018_value

    cdef TBranch* deepcsvb2Loose_phi_2017_branch
    cdef float deepcsvb2Loose_phi_2017_value

    cdef TBranch* deepcsvb2Loose_phi_2018_branch
    cdef float deepcsvb2Loose_phi_2018_value

    cdef TBranch* deepcsvb2Loose_pt_2017_branch
    cdef float deepcsvb2Loose_pt_2017_value

    cdef TBranch* deepcsvb2Loose_pt_2018_branch
    cdef float deepcsvb2Loose_pt_2018_value

    cdef TBranch* deepcsvb2Medium_btagscore_2017_branch
    cdef float deepcsvb2Medium_btagscore_2017_value

    cdef TBranch* deepcsvb2Medium_btagscore_2018_branch
    cdef float deepcsvb2Medium_btagscore_2018_value

    cdef TBranch* deepcsvb2Medium_eta_2017_branch
    cdef float deepcsvb2Medium_eta_2017_value

    cdef TBranch* deepcsvb2Medium_eta_2018_branch
    cdef float deepcsvb2Medium_eta_2018_value

    cdef TBranch* deepcsvb2Medium_hadronflavour_2017_branch
    cdef float deepcsvb2Medium_hadronflavour_2017_value

    cdef TBranch* deepcsvb2Medium_hadronflavour_2018_branch
    cdef float deepcsvb2Medium_hadronflavour_2018_value

    cdef TBranch* deepcsvb2Medium_m_2017_branch
    cdef float deepcsvb2Medium_m_2017_value

    cdef TBranch* deepcsvb2Medium_m_2018_branch
    cdef float deepcsvb2Medium_m_2018_value

    cdef TBranch* deepcsvb2Medium_phi_2017_branch
    cdef float deepcsvb2Medium_phi_2017_value

    cdef TBranch* deepcsvb2Medium_phi_2018_branch
    cdef float deepcsvb2Medium_phi_2018_value

    cdef TBranch* deepcsvb2Medium_pt_2017_branch
    cdef float deepcsvb2Medium_pt_2017_value

    cdef TBranch* deepcsvb2Medium_pt_2018_branch
    cdef float deepcsvb2Medium_pt_2018_value

    cdef TBranch* deepflavourLooseb1_btagscore_2017_branch
    cdef float deepflavourLooseb1_btagscore_2017_value

    cdef TBranch* deepflavourLooseb1_btagscore_2018_branch
    cdef float deepflavourLooseb1_btagscore_2018_value

    cdef TBranch* deepflavourLooseb1_eta_2017_branch
    cdef float deepflavourLooseb1_eta_2017_value

    cdef TBranch* deepflavourLooseb1_eta_2018_branch
    cdef float deepflavourLooseb1_eta_2018_value

    cdef TBranch* deepflavourLooseb1_hadronflavour_2017_branch
    cdef float deepflavourLooseb1_hadronflavour_2017_value

    cdef TBranch* deepflavourLooseb1_hadronflavour_2018_branch
    cdef float deepflavourLooseb1_hadronflavour_2018_value

    cdef TBranch* deepflavourLooseb1_m_2017_branch
    cdef float deepflavourLooseb1_m_2017_value

    cdef TBranch* deepflavourLooseb1_m_2018_branch
    cdef float deepflavourLooseb1_m_2018_value

    cdef TBranch* deepflavourLooseb1_phi_2017_branch
    cdef float deepflavourLooseb1_phi_2017_value

    cdef TBranch* deepflavourLooseb1_phi_2018_branch
    cdef float deepflavourLooseb1_phi_2018_value

    cdef TBranch* deepflavourLooseb1_pt_2017_branch
    cdef float deepflavourLooseb1_pt_2017_value

    cdef TBranch* deepflavourLooseb1_pt_2018_branch
    cdef float deepflavourLooseb1_pt_2018_value

    cdef TBranch* deepflavourLooseb2_btagscore_2017_branch
    cdef float deepflavourLooseb2_btagscore_2017_value

    cdef TBranch* deepflavourLooseb2_btagscore_2018_branch
    cdef float deepflavourLooseb2_btagscore_2018_value

    cdef TBranch* deepflavourLooseb2_eta_2017_branch
    cdef float deepflavourLooseb2_eta_2017_value

    cdef TBranch* deepflavourLooseb2_eta_2018_branch
    cdef float deepflavourLooseb2_eta_2018_value

    cdef TBranch* deepflavourLooseb2_hadronflavour_2017_branch
    cdef float deepflavourLooseb2_hadronflavour_2017_value

    cdef TBranch* deepflavourLooseb2_hadronflavour_2018_branch
    cdef float deepflavourLooseb2_hadronflavour_2018_value

    cdef TBranch* deepflavourLooseb2_m_2017_branch
    cdef float deepflavourLooseb2_m_2017_value

    cdef TBranch* deepflavourLooseb2_m_2018_branch
    cdef float deepflavourLooseb2_m_2018_value

    cdef TBranch* deepflavourLooseb2_phi_2017_branch
    cdef float deepflavourLooseb2_phi_2017_value

    cdef TBranch* deepflavourLooseb2_phi_2018_branch
    cdef float deepflavourLooseb2_phi_2018_value

    cdef TBranch* deepflavourLooseb2_pt_2017_branch
    cdef float deepflavourLooseb2_pt_2017_value

    cdef TBranch* deepflavourLooseb2_pt_2018_branch
    cdef float deepflavourLooseb2_pt_2018_value

    cdef TBranch* deepflavourMediumb1_btagscore_2017_branch
    cdef float deepflavourMediumb1_btagscore_2017_value

    cdef TBranch* deepflavourMediumb1_btagscore_2018_branch
    cdef float deepflavourMediumb1_btagscore_2018_value

    cdef TBranch* deepflavourMediumb1_eta_2017_branch
    cdef float deepflavourMediumb1_eta_2017_value

    cdef TBranch* deepflavourMediumb1_eta_2018_branch
    cdef float deepflavourMediumb1_eta_2018_value

    cdef TBranch* deepflavourMediumb1_hadronflavour_2017_branch
    cdef float deepflavourMediumb1_hadronflavour_2017_value

    cdef TBranch* deepflavourMediumb1_hadronflavour_2018_branch
    cdef float deepflavourMediumb1_hadronflavour_2018_value

    cdef TBranch* deepflavourMediumb1_m_2017_branch
    cdef float deepflavourMediumb1_m_2017_value

    cdef TBranch* deepflavourMediumb1_m_2018_branch
    cdef float deepflavourMediumb1_m_2018_value

    cdef TBranch* deepflavourMediumb1_phi_2017_branch
    cdef float deepflavourMediumb1_phi_2017_value

    cdef TBranch* deepflavourMediumb1_phi_2018_branch
    cdef float deepflavourMediumb1_phi_2018_value

    cdef TBranch* deepflavourMediumb1_pt_2017_branch
    cdef float deepflavourMediumb1_pt_2017_value

    cdef TBranch* deepflavourMediumb1_pt_2018_branch
    cdef float deepflavourMediumb1_pt_2018_value

    cdef TBranch* deepflavourMediumb2_btagscore_2017_branch
    cdef float deepflavourMediumb2_btagscore_2017_value

    cdef TBranch* deepflavourMediumb2_btagscore_2018_branch
    cdef float deepflavourMediumb2_btagscore_2018_value

    cdef TBranch* deepflavourMediumb2_eta_2017_branch
    cdef float deepflavourMediumb2_eta_2017_value

    cdef TBranch* deepflavourMediumb2_eta_2018_branch
    cdef float deepflavourMediumb2_eta_2018_value

    cdef TBranch* deepflavourMediumb2_hadronflavour_2017_branch
    cdef float deepflavourMediumb2_hadronflavour_2017_value

    cdef TBranch* deepflavourMediumb2_hadronflavour_2018_branch
    cdef float deepflavourMediumb2_hadronflavour_2018_value

    cdef TBranch* deepflavourMediumb2_m_2017_branch
    cdef float deepflavourMediumb2_m_2017_value

    cdef TBranch* deepflavourMediumb2_m_2018_branch
    cdef float deepflavourMediumb2_m_2018_value

    cdef TBranch* deepflavourMediumb2_phi_2017_branch
    cdef float deepflavourMediumb2_phi_2017_value

    cdef TBranch* deepflavourMediumb2_phi_2018_branch
    cdef float deepflavourMediumb2_phi_2018_value

    cdef TBranch* deepflavourMediumb2_pt_2017_branch
    cdef float deepflavourMediumb2_pt_2017_value

    cdef TBranch* deepflavourMediumb2_pt_2018_branch
    cdef float deepflavourMediumb2_pt_2018_value

    cdef TBranch* eVetoZTTp001dxyz_branch
    cdef float eVetoZTTp001dxyz_value

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

    cdef TBranch* isZee_branch
    cdef float isZee_value

    cdef TBranch* isZmumu_branch
    cdef float isZmumu_value

    cdef TBranch* isdata_branch
    cdef int isdata_value

    cdef TBranch* isembed_branch
    cdef int isembed_value

    cdef TBranch* j1eta_branch
    cdef float j1eta_value

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

    cdef TBranch* j1phi_branch
    cdef float j1phi_value

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

    cdef TBranch* j2eta_branch
    cdef float j2eta_value

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

    cdef TBranch* j2phi_branch
    cdef float j2phi_value

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

    cdef TBranch* jetVeto20_branch
    cdef float jetVeto20_value

    cdef TBranch* jetVeto30_branch
    cdef float jetVeto30_value

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

    cdef TBranch* jetVeto30_JetEnDown_branch
    cdef float jetVeto30_JetEnDown_value

    cdef TBranch* jetVeto30_JetEnUp_branch
    cdef float jetVeto30_JetEnUp_value

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

    cdef TBranch* lumi_branch
    cdef int lumi_value

    cdef TBranch* m1BestTrackType_branch
    cdef float m1BestTrackType_value

    cdef TBranch* m1Charge_branch
    cdef float m1Charge_value

    cdef TBranch* m1EcalIsoDR03_branch
    cdef float m1EcalIsoDR03_value

    cdef TBranch* m1Eta_branch
    cdef float m1Eta_value

    cdef TBranch* m1GenCharge_branch
    cdef float m1GenCharge_value

    cdef TBranch* m1GenEnergy_branch
    cdef float m1GenEnergy_value

    cdef TBranch* m1GenEta_branch
    cdef float m1GenEta_value

    cdef TBranch* m1GenMotherPdgId_branch
    cdef float m1GenMotherPdgId_value

    cdef TBranch* m1GenParticle_branch
    cdef float m1GenParticle_value

    cdef TBranch* m1GenPdgId_branch
    cdef float m1GenPdgId_value

    cdef TBranch* m1GenPhi_branch
    cdef float m1GenPhi_value

    cdef TBranch* m1GenPt_branch
    cdef float m1GenPt_value

    cdef TBranch* m1GenVZ_branch
    cdef float m1GenVZ_value

    cdef TBranch* m1HcalIsoDR03_branch
    cdef float m1HcalIsoDR03_value

    cdef TBranch* m1IP3D_branch
    cdef float m1IP3D_value

    cdef TBranch* m1IP3DS_branch
    cdef float m1IP3DS_value

    cdef TBranch* m1IPDXY_branch
    cdef float m1IPDXY_value

    cdef TBranch* m1IsGlobal_branch
    cdef float m1IsGlobal_value

    cdef TBranch* m1IsPFMuon_branch
    cdef float m1IsPFMuon_value

    cdef TBranch* m1IsTracker_branch
    cdef float m1IsTracker_value

    cdef TBranch* m1IsoDB03_branch
    cdef float m1IsoDB03_value

    cdef TBranch* m1IsoDB04_branch
    cdef float m1IsoDB04_value

    cdef TBranch* m1Mass_branch
    cdef float m1Mass_value

    cdef TBranch* m1MatchesIsoMu20Filter_branch
    cdef float m1MatchesIsoMu20Filter_value

    cdef TBranch* m1MatchesIsoMu20Path_branch
    cdef float m1MatchesIsoMu20Path_value

    cdef TBranch* m1MatchesIsoMu22Filter_branch
    cdef float m1MatchesIsoMu22Filter_value

    cdef TBranch* m1MatchesIsoMu22Path_branch
    cdef float m1MatchesIsoMu22Path_value

    cdef TBranch* m1MatchesIsoMu22eta2p1Filter_branch
    cdef float m1MatchesIsoMu22eta2p1Filter_value

    cdef TBranch* m1MatchesIsoMu22eta2p1Path_branch
    cdef float m1MatchesIsoMu22eta2p1Path_value

    cdef TBranch* m1MatchesIsoMu24Filter_branch
    cdef float m1MatchesIsoMu24Filter_value

    cdef TBranch* m1MatchesIsoMu24Path_branch
    cdef float m1MatchesIsoMu24Path_value

    cdef TBranch* m1MatchesIsoMu27Filter_branch
    cdef float m1MatchesIsoMu27Filter_value

    cdef TBranch* m1MatchesIsoMu27Path_branch
    cdef float m1MatchesIsoMu27Path_value

    cdef TBranch* m1MatchesIsoTkMu22Filter_branch
    cdef float m1MatchesIsoTkMu22Filter_value

    cdef TBranch* m1MatchesIsoTkMu22Path_branch
    cdef float m1MatchesIsoTkMu22Path_value

    cdef TBranch* m1MatchesIsoTkMu22eta2p1Filter_branch
    cdef float m1MatchesIsoTkMu22eta2p1Filter_value

    cdef TBranch* m1MatchesIsoTkMu22eta2p1Path_branch
    cdef float m1MatchesIsoTkMu22eta2p1Path_value

    cdef TBranch* m1MatchesIsoTkMu24Filter_branch
    cdef float m1MatchesIsoTkMu24Filter_value

    cdef TBranch* m1MatchesIsoTkMu24Path_branch
    cdef float m1MatchesIsoTkMu24Path_value

    cdef TBranch* m1MatchesMu23e12DZFilter_branch
    cdef float m1MatchesMu23e12DZFilter_value

    cdef TBranch* m1MatchesMu23e12DZPath_branch
    cdef float m1MatchesMu23e12DZPath_value

    cdef TBranch* m1MatchesMu23e12Filter_branch
    cdef float m1MatchesMu23e12Filter_value

    cdef TBranch* m1MatchesMu23e12Path_branch
    cdef float m1MatchesMu23e12Path_value

    cdef TBranch* m1MatchesMu8e23DZFilter_branch
    cdef float m1MatchesMu8e23DZFilter_value

    cdef TBranch* m1MatchesMu8e23DZPath_branch
    cdef float m1MatchesMu8e23DZPath_value

    cdef TBranch* m1MatchesMu8e23Filter_branch
    cdef float m1MatchesMu8e23Filter_value

    cdef TBranch* m1MatchesMu8e23Path_branch
    cdef float m1MatchesMu8e23Path_value

    cdef TBranch* m1MvaLoose_branch
    cdef float m1MvaLoose_value

    cdef TBranch* m1MvaMedium_branch
    cdef float m1MvaMedium_value

    cdef TBranch* m1MvaTight_branch
    cdef float m1MvaTight_value

    cdef TBranch* m1PFChargedHadronIsoR04_branch
    cdef float m1PFChargedHadronIsoR04_value

    cdef TBranch* m1PFChargedIso_branch
    cdef float m1PFChargedIso_value

    cdef TBranch* m1PFIDLoose_branch
    cdef float m1PFIDLoose_value

    cdef TBranch* m1PFIDMedium_branch
    cdef float m1PFIDMedium_value

    cdef TBranch* m1PFIDTight_branch
    cdef float m1PFIDTight_value

    cdef TBranch* m1PFIsoLoose_branch
    cdef float m1PFIsoLoose_value

    cdef TBranch* m1PFIsoMedium_branch
    cdef float m1PFIsoMedium_value

    cdef TBranch* m1PFIsoTight_branch
    cdef float m1PFIsoTight_value

    cdef TBranch* m1PFIsoVeryLoose_branch
    cdef float m1PFIsoVeryLoose_value

    cdef TBranch* m1PFIsoVeryTight_branch
    cdef float m1PFIsoVeryTight_value

    cdef TBranch* m1PFNeutralHadronIsoR04_branch
    cdef float m1PFNeutralHadronIsoR04_value

    cdef TBranch* m1PFNeutralIso_branch
    cdef float m1PFNeutralIso_value

    cdef TBranch* m1PFPUChargedIso_branch
    cdef float m1PFPUChargedIso_value

    cdef TBranch* m1PFPhotonIso_branch
    cdef float m1PFPhotonIso_value

    cdef TBranch* m1PFPhotonIsoR04_branch
    cdef float m1PFPhotonIsoR04_value

    cdef TBranch* m1PFPileupIsoR04_branch
    cdef float m1PFPileupIsoR04_value

    cdef TBranch* m1PVDXY_branch
    cdef float m1PVDXY_value

    cdef TBranch* m1PVDZ_branch
    cdef float m1PVDZ_value

    cdef TBranch* m1Phi_branch
    cdef float m1Phi_value

    cdef TBranch* m1Pt_branch
    cdef float m1Pt_value

    cdef TBranch* m1RelPFIsoDBDefault_branch
    cdef float m1RelPFIsoDBDefault_value

    cdef TBranch* m1RelPFIsoDBDefaultR04_branch
    cdef float m1RelPFIsoDBDefaultR04_value

    cdef TBranch* m1SegmentCompatibility_branch
    cdef float m1SegmentCompatibility_value

    cdef TBranch* m1TrkIsoDR03_branch
    cdef float m1TrkIsoDR03_value

    cdef TBranch* m1TypeCode_branch
    cdef int m1TypeCode_value

    cdef TBranch* m1ZTTGenMatching_branch
    cdef float m1ZTTGenMatching_value

    cdef TBranch* m1_m2_DR_branch
    cdef float m1_m2_DR_value

    cdef TBranch* m1_m2_Mass_branch
    cdef float m1_m2_Mass_value

    cdef TBranch* m1_m2_PZeta_branch
    cdef float m1_m2_PZeta_value

    cdef TBranch* m1_m2_PZetaVis_branch
    cdef float m1_m2_PZetaVis_value

    cdef TBranch* m2BestTrackType_branch
    cdef float m2BestTrackType_value

    cdef TBranch* m2Charge_branch
    cdef float m2Charge_value

    cdef TBranch* m2EcalIsoDR03_branch
    cdef float m2EcalIsoDR03_value

    cdef TBranch* m2Eta_branch
    cdef float m2Eta_value

    cdef TBranch* m2GenCharge_branch
    cdef float m2GenCharge_value

    cdef TBranch* m2GenEnergy_branch
    cdef float m2GenEnergy_value

    cdef TBranch* m2GenEta_branch
    cdef float m2GenEta_value

    cdef TBranch* m2GenMotherPdgId_branch
    cdef float m2GenMotherPdgId_value

    cdef TBranch* m2GenParticle_branch
    cdef float m2GenParticle_value

    cdef TBranch* m2GenPdgId_branch
    cdef float m2GenPdgId_value

    cdef TBranch* m2GenPhi_branch
    cdef float m2GenPhi_value

    cdef TBranch* m2GenPt_branch
    cdef float m2GenPt_value

    cdef TBranch* m2GenVZ_branch
    cdef float m2GenVZ_value

    cdef TBranch* m2HcalIsoDR03_branch
    cdef float m2HcalIsoDR03_value

    cdef TBranch* m2IP3D_branch
    cdef float m2IP3D_value

    cdef TBranch* m2IP3DS_branch
    cdef float m2IP3DS_value

    cdef TBranch* m2IPDXY_branch
    cdef float m2IPDXY_value

    cdef TBranch* m2IsGlobal_branch
    cdef float m2IsGlobal_value

    cdef TBranch* m2IsPFMuon_branch
    cdef float m2IsPFMuon_value

    cdef TBranch* m2IsTracker_branch
    cdef float m2IsTracker_value

    cdef TBranch* m2IsoDB03_branch
    cdef float m2IsoDB03_value

    cdef TBranch* m2IsoDB04_branch
    cdef float m2IsoDB04_value

    cdef TBranch* m2Mass_branch
    cdef float m2Mass_value

    cdef TBranch* m2MatchesIsoMu20Filter_branch
    cdef float m2MatchesIsoMu20Filter_value

    cdef TBranch* m2MatchesIsoMu20Path_branch
    cdef float m2MatchesIsoMu20Path_value

    cdef TBranch* m2MatchesIsoMu22Filter_branch
    cdef float m2MatchesIsoMu22Filter_value

    cdef TBranch* m2MatchesIsoMu22Path_branch
    cdef float m2MatchesIsoMu22Path_value

    cdef TBranch* m2MatchesIsoMu22eta2p1Filter_branch
    cdef float m2MatchesIsoMu22eta2p1Filter_value

    cdef TBranch* m2MatchesIsoMu22eta2p1Path_branch
    cdef float m2MatchesIsoMu22eta2p1Path_value

    cdef TBranch* m2MatchesIsoMu24Filter_branch
    cdef float m2MatchesIsoMu24Filter_value

    cdef TBranch* m2MatchesIsoMu24Path_branch
    cdef float m2MatchesIsoMu24Path_value

    cdef TBranch* m2MatchesIsoMu27Filter_branch
    cdef float m2MatchesIsoMu27Filter_value

    cdef TBranch* m2MatchesIsoMu27Path_branch
    cdef float m2MatchesIsoMu27Path_value

    cdef TBranch* m2MatchesIsoTkMu22Filter_branch
    cdef float m2MatchesIsoTkMu22Filter_value

    cdef TBranch* m2MatchesIsoTkMu22Path_branch
    cdef float m2MatchesIsoTkMu22Path_value

    cdef TBranch* m2MatchesIsoTkMu22eta2p1Filter_branch
    cdef float m2MatchesIsoTkMu22eta2p1Filter_value

    cdef TBranch* m2MatchesIsoTkMu22eta2p1Path_branch
    cdef float m2MatchesIsoTkMu22eta2p1Path_value

    cdef TBranch* m2MatchesIsoTkMu24Filter_branch
    cdef float m2MatchesIsoTkMu24Filter_value

    cdef TBranch* m2MatchesIsoTkMu24Path_branch
    cdef float m2MatchesIsoTkMu24Path_value

    cdef TBranch* m2MatchesMu23e12DZFilter_branch
    cdef float m2MatchesMu23e12DZFilter_value

    cdef TBranch* m2MatchesMu23e12DZPath_branch
    cdef float m2MatchesMu23e12DZPath_value

    cdef TBranch* m2MatchesMu23e12Filter_branch
    cdef float m2MatchesMu23e12Filter_value

    cdef TBranch* m2MatchesMu23e12Path_branch
    cdef float m2MatchesMu23e12Path_value

    cdef TBranch* m2MatchesMu8e23DZFilter_branch
    cdef float m2MatchesMu8e23DZFilter_value

    cdef TBranch* m2MatchesMu8e23DZPath_branch
    cdef float m2MatchesMu8e23DZPath_value

    cdef TBranch* m2MatchesMu8e23Filter_branch
    cdef float m2MatchesMu8e23Filter_value

    cdef TBranch* m2MatchesMu8e23Path_branch
    cdef float m2MatchesMu8e23Path_value

    cdef TBranch* m2MvaLoose_branch
    cdef float m2MvaLoose_value

    cdef TBranch* m2MvaMedium_branch
    cdef float m2MvaMedium_value

    cdef TBranch* m2MvaTight_branch
    cdef float m2MvaTight_value

    cdef TBranch* m2PFChargedHadronIsoR04_branch
    cdef float m2PFChargedHadronIsoR04_value

    cdef TBranch* m2PFChargedIso_branch
    cdef float m2PFChargedIso_value

    cdef TBranch* m2PFIDLoose_branch
    cdef float m2PFIDLoose_value

    cdef TBranch* m2PFIDMedium_branch
    cdef float m2PFIDMedium_value

    cdef TBranch* m2PFIDTight_branch
    cdef float m2PFIDTight_value

    cdef TBranch* m2PFIsoLoose_branch
    cdef float m2PFIsoLoose_value

    cdef TBranch* m2PFIsoMedium_branch
    cdef float m2PFIsoMedium_value

    cdef TBranch* m2PFIsoTight_branch
    cdef float m2PFIsoTight_value

    cdef TBranch* m2PFIsoVeryLoose_branch
    cdef float m2PFIsoVeryLoose_value

    cdef TBranch* m2PFIsoVeryTight_branch
    cdef float m2PFIsoVeryTight_value

    cdef TBranch* m2PFNeutralHadronIsoR04_branch
    cdef float m2PFNeutralHadronIsoR04_value

    cdef TBranch* m2PFNeutralIso_branch
    cdef float m2PFNeutralIso_value

    cdef TBranch* m2PFPUChargedIso_branch
    cdef float m2PFPUChargedIso_value

    cdef TBranch* m2PFPhotonIso_branch
    cdef float m2PFPhotonIso_value

    cdef TBranch* m2PFPhotonIsoR04_branch
    cdef float m2PFPhotonIsoR04_value

    cdef TBranch* m2PFPileupIsoR04_branch
    cdef float m2PFPileupIsoR04_value

    cdef TBranch* m2PVDXY_branch
    cdef float m2PVDXY_value

    cdef TBranch* m2PVDZ_branch
    cdef float m2PVDZ_value

    cdef TBranch* m2Phi_branch
    cdef float m2Phi_value

    cdef TBranch* m2Pt_branch
    cdef float m2Pt_value

    cdef TBranch* m2RelPFIsoDBDefault_branch
    cdef float m2RelPFIsoDBDefault_value

    cdef TBranch* m2RelPFIsoDBDefaultR04_branch
    cdef float m2RelPFIsoDBDefaultR04_value

    cdef TBranch* m2SegmentCompatibility_branch
    cdef float m2SegmentCompatibility_value

    cdef TBranch* m2TrkIsoDR03_branch
    cdef float m2TrkIsoDR03_value

    cdef TBranch* m2TypeCode_branch
    cdef int m2TypeCode_value

    cdef TBranch* m2ZTTGenMatching_branch
    cdef float m2ZTTGenMatching_value

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

    cdef TBranch* raw_pfMetEt_branch
    cdef float raw_pfMetEt_value

    cdef TBranch* raw_pfMetPhi_branch
    cdef float raw_pfMetPhi_value

    cdef TBranch* rho_branch
    cdef float rho_value

    cdef TBranch* run_branch
    cdef int run_value

    cdef TBranch* singleIsoTkMu22Pass_branch
    cdef float singleIsoTkMu22Pass_value

    cdef TBranch* singleIsoTkMu22eta2p1Pass_branch
    cdef float singleIsoTkMu22eta2p1Pass_value

    cdef TBranch* singleIsoTkMu24Pass_branch
    cdef float singleIsoTkMu24Pass_value

    cdef TBranch* tauVetoPtDeepVtx_branch
    cdef float tauVetoPtDeepVtx_value

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

    cdef TBranch* vbfMass_branch
    cdef float vbfMass_value

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

        #print "making EmbPtWeight"
        self.EmbPtWeight_branch = the_tree.GetBranch("EmbPtWeight")
        #if not self.EmbPtWeight_branch and "EmbPtWeight" not in self.complained:
        if not self.EmbPtWeight_branch and "EmbPtWeight":
            warnings.warn( "EMTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "EMTree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making Flag_BadPFMuonDzFilter"
        self.Flag_BadPFMuonDzFilter_branch = the_tree.GetBranch("Flag_BadPFMuonDzFilter")
        #if not self.Flag_BadPFMuonDzFilter_branch and "Flag_BadPFMuonDzFilter" not in self.complained:
        if not self.Flag_BadPFMuonDzFilter_branch and "Flag_BadPFMuonDzFilter":
            warnings.warn( "EMTree: Expected branch Flag_BadPFMuonDzFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonDzFilter")
        else:
            self.Flag_BadPFMuonDzFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonDzFilter_value)

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

        #print "making Flag_ecalBadCalibFilter"
        self.Flag_ecalBadCalibFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibFilter")
        #if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter" not in self.complained:
        if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter":
            warnings.warn( "EMTree: Expected branch Flag_ecalBadCalibFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibFilter")
        else:
            self.Flag_ecalBadCalibFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibFilter_value)

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

        #print "making IsoMu20Pass"
        self.IsoMu20Pass_branch = the_tree.GetBranch("IsoMu20Pass")
        #if not self.IsoMu20Pass_branch and "IsoMu20Pass" not in self.complained:
        if not self.IsoMu20Pass_branch and "IsoMu20Pass":
            warnings.warn( "EMTree: Expected branch IsoMu20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu20Pass")
        else:
            self.IsoMu20Pass_branch.SetAddress(<void*>&self.IsoMu20Pass_value)

        #print "making IsoMu22Pass"
        self.IsoMu22Pass_branch = the_tree.GetBranch("IsoMu22Pass")
        #if not self.IsoMu22Pass_branch and "IsoMu22Pass" not in self.complained:
        if not self.IsoMu22Pass_branch and "IsoMu22Pass":
            warnings.warn( "EMTree: Expected branch IsoMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu22Pass")
        else:
            self.IsoMu22Pass_branch.SetAddress(<void*>&self.IsoMu22Pass_value)

        #print "making IsoMu22eta2p1Pass"
        self.IsoMu22eta2p1Pass_branch = the_tree.GetBranch("IsoMu22eta2p1Pass")
        #if not self.IsoMu22eta2p1Pass_branch and "IsoMu22eta2p1Pass" not in self.complained:
        if not self.IsoMu22eta2p1Pass_branch and "IsoMu22eta2p1Pass":
            warnings.warn( "EMTree: Expected branch IsoMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu22eta2p1Pass")
        else:
            self.IsoMu22eta2p1Pass_branch.SetAddress(<void*>&self.IsoMu22eta2p1Pass_value)

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

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "EMTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making bjetDeepCSVVeto20Loose_2016_DR0p4"
        self.bjetDeepCSVVeto20Loose_2016_DR0p4_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2016_DR0p4")
        #if not self.bjetDeepCSVVeto20Loose_2016_DR0p4_branch and "bjetDeepCSVVeto20Loose_2016_DR0p4" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2016_DR0p4_branch and "bjetDeepCSVVeto20Loose_2016_DR0p4":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Loose_2016_DR0p4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2016_DR0p4")
        else:
            self.bjetDeepCSVVeto20Loose_2016_DR0p4_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2016_DR0p4_value)

        #print "making bjetDeepCSVVeto20Loose_2017_DR0p4"
        self.bjetDeepCSVVeto20Loose_2017_DR0p4_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2017_DR0p4")
        #if not self.bjetDeepCSVVeto20Loose_2017_DR0p4_branch and "bjetDeepCSVVeto20Loose_2017_DR0p4" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2017_DR0p4_branch and "bjetDeepCSVVeto20Loose_2017_DR0p4":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Loose_2017_DR0p4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2017_DR0p4")
        else:
            self.bjetDeepCSVVeto20Loose_2017_DR0p4_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2017_DR0p4_value)

        #print "making bjetDeepCSVVeto20Loose_2018_DR0p4"
        self.bjetDeepCSVVeto20Loose_2018_DR0p4_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2018_DR0p4")
        #if not self.bjetDeepCSVVeto20Loose_2018_DR0p4_branch and "bjetDeepCSVVeto20Loose_2018_DR0p4" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2018_DR0p4_branch and "bjetDeepCSVVeto20Loose_2018_DR0p4":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Loose_2018_DR0p4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2018_DR0p4")
        else:
            self.bjetDeepCSVVeto20Loose_2018_DR0p4_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2018_DR0p4_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0p4"
        self.bjetDeepCSVVeto20Medium_2016_DR0p4_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0p4")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0p4_branch and "bjetDeepCSVVeto20Medium_2016_DR0p4" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0p4_branch and "bjetDeepCSVVeto20Medium_2016_DR0p4":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0p4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0p4")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0p4_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0p4_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0p4"
        self.bjetDeepCSVVeto20Medium_2017_DR0p4_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0p4")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0p4_branch and "bjetDeepCSVVeto20Medium_2017_DR0p4" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0p4_branch and "bjetDeepCSVVeto20Medium_2017_DR0p4":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0p4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0p4")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0p4_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0p4_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0p4"
        self.bjetDeepCSVVeto20Medium_2018_DR0p4_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0p4")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0p4_branch and "bjetDeepCSVVeto20Medium_2018_DR0p4" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0p4_branch and "bjetDeepCSVVeto20Medium_2018_DR0p4":
            warnings.warn( "EMTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0p4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0p4")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0p4_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0p4_value)

        #print "making bjetDeepFlavourVeto20Loose_2016_DR0p4"
        self.bjetDeepFlavourVeto20Loose_2016_DR0p4_branch = the_tree.GetBranch("bjetDeepFlavourVeto20Loose_2016_DR0p4")
        #if not self.bjetDeepFlavourVeto20Loose_2016_DR0p4_branch and "bjetDeepFlavourVeto20Loose_2016_DR0p4" not in self.complained:
        if not self.bjetDeepFlavourVeto20Loose_2016_DR0p4_branch and "bjetDeepFlavourVeto20Loose_2016_DR0p4":
            warnings.warn( "EMTree: Expected branch bjetDeepFlavourVeto20Loose_2016_DR0p4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepFlavourVeto20Loose_2016_DR0p4")
        else:
            self.bjetDeepFlavourVeto20Loose_2016_DR0p4_branch.SetAddress(<void*>&self.bjetDeepFlavourVeto20Loose_2016_DR0p4_value)

        #print "making bjetDeepFlavourVeto20Loose_2017_DR0p4"
        self.bjetDeepFlavourVeto20Loose_2017_DR0p4_branch = the_tree.GetBranch("bjetDeepFlavourVeto20Loose_2017_DR0p4")
        #if not self.bjetDeepFlavourVeto20Loose_2017_DR0p4_branch and "bjetDeepFlavourVeto20Loose_2017_DR0p4" not in self.complained:
        if not self.bjetDeepFlavourVeto20Loose_2017_DR0p4_branch and "bjetDeepFlavourVeto20Loose_2017_DR0p4":
            warnings.warn( "EMTree: Expected branch bjetDeepFlavourVeto20Loose_2017_DR0p4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepFlavourVeto20Loose_2017_DR0p4")
        else:
            self.bjetDeepFlavourVeto20Loose_2017_DR0p4_branch.SetAddress(<void*>&self.bjetDeepFlavourVeto20Loose_2017_DR0p4_value)

        #print "making bjetDeepFlavourVeto20Loose_2018_DR0p4"
        self.bjetDeepFlavourVeto20Loose_2018_DR0p4_branch = the_tree.GetBranch("bjetDeepFlavourVeto20Loose_2018_DR0p4")
        #if not self.bjetDeepFlavourVeto20Loose_2018_DR0p4_branch and "bjetDeepFlavourVeto20Loose_2018_DR0p4" not in self.complained:
        if not self.bjetDeepFlavourVeto20Loose_2018_DR0p4_branch and "bjetDeepFlavourVeto20Loose_2018_DR0p4":
            warnings.warn( "EMTree: Expected branch bjetDeepFlavourVeto20Loose_2018_DR0p4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepFlavourVeto20Loose_2018_DR0p4")
        else:
            self.bjetDeepFlavourVeto20Loose_2018_DR0p4_branch.SetAddress(<void*>&self.bjetDeepFlavourVeto20Loose_2018_DR0p4_value)

        #print "making bjetDeepFlavourVeto20Medium_2016_DR0p4"
        self.bjetDeepFlavourVeto20Medium_2016_DR0p4_branch = the_tree.GetBranch("bjetDeepFlavourVeto20Medium_2016_DR0p4")
        #if not self.bjetDeepFlavourVeto20Medium_2016_DR0p4_branch and "bjetDeepFlavourVeto20Medium_2016_DR0p4" not in self.complained:
        if not self.bjetDeepFlavourVeto20Medium_2016_DR0p4_branch and "bjetDeepFlavourVeto20Medium_2016_DR0p4":
            warnings.warn( "EMTree: Expected branch bjetDeepFlavourVeto20Medium_2016_DR0p4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepFlavourVeto20Medium_2016_DR0p4")
        else:
            self.bjetDeepFlavourVeto20Medium_2016_DR0p4_branch.SetAddress(<void*>&self.bjetDeepFlavourVeto20Medium_2016_DR0p4_value)

        #print "making bjetDeepFlavourVeto20Medium_2017_DR0p4"
        self.bjetDeepFlavourVeto20Medium_2017_DR0p4_branch = the_tree.GetBranch("bjetDeepFlavourVeto20Medium_2017_DR0p4")
        #if not self.bjetDeepFlavourVeto20Medium_2017_DR0p4_branch and "bjetDeepFlavourVeto20Medium_2017_DR0p4" not in self.complained:
        if not self.bjetDeepFlavourVeto20Medium_2017_DR0p4_branch and "bjetDeepFlavourVeto20Medium_2017_DR0p4":
            warnings.warn( "EMTree: Expected branch bjetDeepFlavourVeto20Medium_2017_DR0p4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepFlavourVeto20Medium_2017_DR0p4")
        else:
            self.bjetDeepFlavourVeto20Medium_2017_DR0p4_branch.SetAddress(<void*>&self.bjetDeepFlavourVeto20Medium_2017_DR0p4_value)

        #print "making bjetDeepFlavourVeto20Medium_2018_DR0p4"
        self.bjetDeepFlavourVeto20Medium_2018_DR0p4_branch = the_tree.GetBranch("bjetDeepFlavourVeto20Medium_2018_DR0p4")
        #if not self.bjetDeepFlavourVeto20Medium_2018_DR0p4_branch and "bjetDeepFlavourVeto20Medium_2018_DR0p4" not in self.complained:
        if not self.bjetDeepFlavourVeto20Medium_2018_DR0p4_branch and "bjetDeepFlavourVeto20Medium_2018_DR0p4":
            warnings.warn( "EMTree: Expected branch bjetDeepFlavourVeto20Medium_2018_DR0p4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepFlavourVeto20Medium_2018_DR0p4")
        else:
            self.bjetDeepFlavourVeto20Medium_2018_DR0p4_branch.SetAddress(<void*>&self.bjetDeepFlavourVeto20Medium_2018_DR0p4_value)

        #print "making deepcsvb1Loose_btagscore_2017"
        self.deepcsvb1Loose_btagscore_2017_branch = the_tree.GetBranch("deepcsvb1Loose_btagscore_2017")
        #if not self.deepcsvb1Loose_btagscore_2017_branch and "deepcsvb1Loose_btagscore_2017" not in self.complained:
        if not self.deepcsvb1Loose_btagscore_2017_branch and "deepcsvb1Loose_btagscore_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb1Loose_btagscore_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Loose_btagscore_2017")
        else:
            self.deepcsvb1Loose_btagscore_2017_branch.SetAddress(<void*>&self.deepcsvb1Loose_btagscore_2017_value)

        #print "making deepcsvb1Loose_btagscore_2018"
        self.deepcsvb1Loose_btagscore_2018_branch = the_tree.GetBranch("deepcsvb1Loose_btagscore_2018")
        #if not self.deepcsvb1Loose_btagscore_2018_branch and "deepcsvb1Loose_btagscore_2018" not in self.complained:
        if not self.deepcsvb1Loose_btagscore_2018_branch and "deepcsvb1Loose_btagscore_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb1Loose_btagscore_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Loose_btagscore_2018")
        else:
            self.deepcsvb1Loose_btagscore_2018_branch.SetAddress(<void*>&self.deepcsvb1Loose_btagscore_2018_value)

        #print "making deepcsvb1Loose_eta_2017"
        self.deepcsvb1Loose_eta_2017_branch = the_tree.GetBranch("deepcsvb1Loose_eta_2017")
        #if not self.deepcsvb1Loose_eta_2017_branch and "deepcsvb1Loose_eta_2017" not in self.complained:
        if not self.deepcsvb1Loose_eta_2017_branch and "deepcsvb1Loose_eta_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb1Loose_eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Loose_eta_2017")
        else:
            self.deepcsvb1Loose_eta_2017_branch.SetAddress(<void*>&self.deepcsvb1Loose_eta_2017_value)

        #print "making deepcsvb1Loose_eta_2018"
        self.deepcsvb1Loose_eta_2018_branch = the_tree.GetBranch("deepcsvb1Loose_eta_2018")
        #if not self.deepcsvb1Loose_eta_2018_branch and "deepcsvb1Loose_eta_2018" not in self.complained:
        if not self.deepcsvb1Loose_eta_2018_branch and "deepcsvb1Loose_eta_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb1Loose_eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Loose_eta_2018")
        else:
            self.deepcsvb1Loose_eta_2018_branch.SetAddress(<void*>&self.deepcsvb1Loose_eta_2018_value)

        #print "making deepcsvb1Loose_hadronflavour_2017"
        self.deepcsvb1Loose_hadronflavour_2017_branch = the_tree.GetBranch("deepcsvb1Loose_hadronflavour_2017")
        #if not self.deepcsvb1Loose_hadronflavour_2017_branch and "deepcsvb1Loose_hadronflavour_2017" not in self.complained:
        if not self.deepcsvb1Loose_hadronflavour_2017_branch and "deepcsvb1Loose_hadronflavour_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb1Loose_hadronflavour_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Loose_hadronflavour_2017")
        else:
            self.deepcsvb1Loose_hadronflavour_2017_branch.SetAddress(<void*>&self.deepcsvb1Loose_hadronflavour_2017_value)

        #print "making deepcsvb1Loose_hadronflavour_2018"
        self.deepcsvb1Loose_hadronflavour_2018_branch = the_tree.GetBranch("deepcsvb1Loose_hadronflavour_2018")
        #if not self.deepcsvb1Loose_hadronflavour_2018_branch and "deepcsvb1Loose_hadronflavour_2018" not in self.complained:
        if not self.deepcsvb1Loose_hadronflavour_2018_branch and "deepcsvb1Loose_hadronflavour_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb1Loose_hadronflavour_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Loose_hadronflavour_2018")
        else:
            self.deepcsvb1Loose_hadronflavour_2018_branch.SetAddress(<void*>&self.deepcsvb1Loose_hadronflavour_2018_value)

        #print "making deepcsvb1Loose_m_2017"
        self.deepcsvb1Loose_m_2017_branch = the_tree.GetBranch("deepcsvb1Loose_m_2017")
        #if not self.deepcsvb1Loose_m_2017_branch and "deepcsvb1Loose_m_2017" not in self.complained:
        if not self.deepcsvb1Loose_m_2017_branch and "deepcsvb1Loose_m_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb1Loose_m_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Loose_m_2017")
        else:
            self.deepcsvb1Loose_m_2017_branch.SetAddress(<void*>&self.deepcsvb1Loose_m_2017_value)

        #print "making deepcsvb1Loose_m_2018"
        self.deepcsvb1Loose_m_2018_branch = the_tree.GetBranch("deepcsvb1Loose_m_2018")
        #if not self.deepcsvb1Loose_m_2018_branch and "deepcsvb1Loose_m_2018" not in self.complained:
        if not self.deepcsvb1Loose_m_2018_branch and "deepcsvb1Loose_m_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb1Loose_m_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Loose_m_2018")
        else:
            self.deepcsvb1Loose_m_2018_branch.SetAddress(<void*>&self.deepcsvb1Loose_m_2018_value)

        #print "making deepcsvb1Loose_phi_2017"
        self.deepcsvb1Loose_phi_2017_branch = the_tree.GetBranch("deepcsvb1Loose_phi_2017")
        #if not self.deepcsvb1Loose_phi_2017_branch and "deepcsvb1Loose_phi_2017" not in self.complained:
        if not self.deepcsvb1Loose_phi_2017_branch and "deepcsvb1Loose_phi_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb1Loose_phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Loose_phi_2017")
        else:
            self.deepcsvb1Loose_phi_2017_branch.SetAddress(<void*>&self.deepcsvb1Loose_phi_2017_value)

        #print "making deepcsvb1Loose_phi_2018"
        self.deepcsvb1Loose_phi_2018_branch = the_tree.GetBranch("deepcsvb1Loose_phi_2018")
        #if not self.deepcsvb1Loose_phi_2018_branch and "deepcsvb1Loose_phi_2018" not in self.complained:
        if not self.deepcsvb1Loose_phi_2018_branch and "deepcsvb1Loose_phi_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb1Loose_phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Loose_phi_2018")
        else:
            self.deepcsvb1Loose_phi_2018_branch.SetAddress(<void*>&self.deepcsvb1Loose_phi_2018_value)

        #print "making deepcsvb1Loose_pt_2017"
        self.deepcsvb1Loose_pt_2017_branch = the_tree.GetBranch("deepcsvb1Loose_pt_2017")
        #if not self.deepcsvb1Loose_pt_2017_branch and "deepcsvb1Loose_pt_2017" not in self.complained:
        if not self.deepcsvb1Loose_pt_2017_branch and "deepcsvb1Loose_pt_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb1Loose_pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Loose_pt_2017")
        else:
            self.deepcsvb1Loose_pt_2017_branch.SetAddress(<void*>&self.deepcsvb1Loose_pt_2017_value)

        #print "making deepcsvb1Loose_pt_2018"
        self.deepcsvb1Loose_pt_2018_branch = the_tree.GetBranch("deepcsvb1Loose_pt_2018")
        #if not self.deepcsvb1Loose_pt_2018_branch and "deepcsvb1Loose_pt_2018" not in self.complained:
        if not self.deepcsvb1Loose_pt_2018_branch and "deepcsvb1Loose_pt_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb1Loose_pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Loose_pt_2018")
        else:
            self.deepcsvb1Loose_pt_2018_branch.SetAddress(<void*>&self.deepcsvb1Loose_pt_2018_value)

        #print "making deepcsvb1Medium_btagscore_2017"
        self.deepcsvb1Medium_btagscore_2017_branch = the_tree.GetBranch("deepcsvb1Medium_btagscore_2017")
        #if not self.deepcsvb1Medium_btagscore_2017_branch and "deepcsvb1Medium_btagscore_2017" not in self.complained:
        if not self.deepcsvb1Medium_btagscore_2017_branch and "deepcsvb1Medium_btagscore_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb1Medium_btagscore_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Medium_btagscore_2017")
        else:
            self.deepcsvb1Medium_btagscore_2017_branch.SetAddress(<void*>&self.deepcsvb1Medium_btagscore_2017_value)

        #print "making deepcsvb1Medium_btagscore_2018"
        self.deepcsvb1Medium_btagscore_2018_branch = the_tree.GetBranch("deepcsvb1Medium_btagscore_2018")
        #if not self.deepcsvb1Medium_btagscore_2018_branch and "deepcsvb1Medium_btagscore_2018" not in self.complained:
        if not self.deepcsvb1Medium_btagscore_2018_branch and "deepcsvb1Medium_btagscore_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb1Medium_btagscore_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Medium_btagscore_2018")
        else:
            self.deepcsvb1Medium_btagscore_2018_branch.SetAddress(<void*>&self.deepcsvb1Medium_btagscore_2018_value)

        #print "making deepcsvb1Medium_eta_2017"
        self.deepcsvb1Medium_eta_2017_branch = the_tree.GetBranch("deepcsvb1Medium_eta_2017")
        #if not self.deepcsvb1Medium_eta_2017_branch and "deepcsvb1Medium_eta_2017" not in self.complained:
        if not self.deepcsvb1Medium_eta_2017_branch and "deepcsvb1Medium_eta_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb1Medium_eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Medium_eta_2017")
        else:
            self.deepcsvb1Medium_eta_2017_branch.SetAddress(<void*>&self.deepcsvb1Medium_eta_2017_value)

        #print "making deepcsvb1Medium_eta_2018"
        self.deepcsvb1Medium_eta_2018_branch = the_tree.GetBranch("deepcsvb1Medium_eta_2018")
        #if not self.deepcsvb1Medium_eta_2018_branch and "deepcsvb1Medium_eta_2018" not in self.complained:
        if not self.deepcsvb1Medium_eta_2018_branch and "deepcsvb1Medium_eta_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb1Medium_eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Medium_eta_2018")
        else:
            self.deepcsvb1Medium_eta_2018_branch.SetAddress(<void*>&self.deepcsvb1Medium_eta_2018_value)

        #print "making deepcsvb1Medium_hadronflavour_2017"
        self.deepcsvb1Medium_hadronflavour_2017_branch = the_tree.GetBranch("deepcsvb1Medium_hadronflavour_2017")
        #if not self.deepcsvb1Medium_hadronflavour_2017_branch and "deepcsvb1Medium_hadronflavour_2017" not in self.complained:
        if not self.deepcsvb1Medium_hadronflavour_2017_branch and "deepcsvb1Medium_hadronflavour_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb1Medium_hadronflavour_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Medium_hadronflavour_2017")
        else:
            self.deepcsvb1Medium_hadronflavour_2017_branch.SetAddress(<void*>&self.deepcsvb1Medium_hadronflavour_2017_value)

        #print "making deepcsvb1Medium_hadronflavour_2018"
        self.deepcsvb1Medium_hadronflavour_2018_branch = the_tree.GetBranch("deepcsvb1Medium_hadronflavour_2018")
        #if not self.deepcsvb1Medium_hadronflavour_2018_branch and "deepcsvb1Medium_hadronflavour_2018" not in self.complained:
        if not self.deepcsvb1Medium_hadronflavour_2018_branch and "deepcsvb1Medium_hadronflavour_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb1Medium_hadronflavour_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Medium_hadronflavour_2018")
        else:
            self.deepcsvb1Medium_hadronflavour_2018_branch.SetAddress(<void*>&self.deepcsvb1Medium_hadronflavour_2018_value)

        #print "making deepcsvb1Medium_m_2017"
        self.deepcsvb1Medium_m_2017_branch = the_tree.GetBranch("deepcsvb1Medium_m_2017")
        #if not self.deepcsvb1Medium_m_2017_branch and "deepcsvb1Medium_m_2017" not in self.complained:
        if not self.deepcsvb1Medium_m_2017_branch and "deepcsvb1Medium_m_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb1Medium_m_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Medium_m_2017")
        else:
            self.deepcsvb1Medium_m_2017_branch.SetAddress(<void*>&self.deepcsvb1Medium_m_2017_value)

        #print "making deepcsvb1Medium_m_2018"
        self.deepcsvb1Medium_m_2018_branch = the_tree.GetBranch("deepcsvb1Medium_m_2018")
        #if not self.deepcsvb1Medium_m_2018_branch and "deepcsvb1Medium_m_2018" not in self.complained:
        if not self.deepcsvb1Medium_m_2018_branch and "deepcsvb1Medium_m_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb1Medium_m_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Medium_m_2018")
        else:
            self.deepcsvb1Medium_m_2018_branch.SetAddress(<void*>&self.deepcsvb1Medium_m_2018_value)

        #print "making deepcsvb1Medium_phi_2017"
        self.deepcsvb1Medium_phi_2017_branch = the_tree.GetBranch("deepcsvb1Medium_phi_2017")
        #if not self.deepcsvb1Medium_phi_2017_branch and "deepcsvb1Medium_phi_2017" not in self.complained:
        if not self.deepcsvb1Medium_phi_2017_branch and "deepcsvb1Medium_phi_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb1Medium_phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Medium_phi_2017")
        else:
            self.deepcsvb1Medium_phi_2017_branch.SetAddress(<void*>&self.deepcsvb1Medium_phi_2017_value)

        #print "making deepcsvb1Medium_phi_2018"
        self.deepcsvb1Medium_phi_2018_branch = the_tree.GetBranch("deepcsvb1Medium_phi_2018")
        #if not self.deepcsvb1Medium_phi_2018_branch and "deepcsvb1Medium_phi_2018" not in self.complained:
        if not self.deepcsvb1Medium_phi_2018_branch and "deepcsvb1Medium_phi_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb1Medium_phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Medium_phi_2018")
        else:
            self.deepcsvb1Medium_phi_2018_branch.SetAddress(<void*>&self.deepcsvb1Medium_phi_2018_value)

        #print "making deepcsvb1Medium_pt_2017"
        self.deepcsvb1Medium_pt_2017_branch = the_tree.GetBranch("deepcsvb1Medium_pt_2017")
        #if not self.deepcsvb1Medium_pt_2017_branch and "deepcsvb1Medium_pt_2017" not in self.complained:
        if not self.deepcsvb1Medium_pt_2017_branch and "deepcsvb1Medium_pt_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb1Medium_pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Medium_pt_2017")
        else:
            self.deepcsvb1Medium_pt_2017_branch.SetAddress(<void*>&self.deepcsvb1Medium_pt_2017_value)

        #print "making deepcsvb1Medium_pt_2018"
        self.deepcsvb1Medium_pt_2018_branch = the_tree.GetBranch("deepcsvb1Medium_pt_2018")
        #if not self.deepcsvb1Medium_pt_2018_branch and "deepcsvb1Medium_pt_2018" not in self.complained:
        if not self.deepcsvb1Medium_pt_2018_branch and "deepcsvb1Medium_pt_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb1Medium_pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1Medium_pt_2018")
        else:
            self.deepcsvb1Medium_pt_2018_branch.SetAddress(<void*>&self.deepcsvb1Medium_pt_2018_value)

        #print "making deepcsvb2Loose_btagscore_2017"
        self.deepcsvb2Loose_btagscore_2017_branch = the_tree.GetBranch("deepcsvb2Loose_btagscore_2017")
        #if not self.deepcsvb2Loose_btagscore_2017_branch and "deepcsvb2Loose_btagscore_2017" not in self.complained:
        if not self.deepcsvb2Loose_btagscore_2017_branch and "deepcsvb2Loose_btagscore_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb2Loose_btagscore_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Loose_btagscore_2017")
        else:
            self.deepcsvb2Loose_btagscore_2017_branch.SetAddress(<void*>&self.deepcsvb2Loose_btagscore_2017_value)

        #print "making deepcsvb2Loose_btagscore_2018"
        self.deepcsvb2Loose_btagscore_2018_branch = the_tree.GetBranch("deepcsvb2Loose_btagscore_2018")
        #if not self.deepcsvb2Loose_btagscore_2018_branch and "deepcsvb2Loose_btagscore_2018" not in self.complained:
        if not self.deepcsvb2Loose_btagscore_2018_branch and "deepcsvb2Loose_btagscore_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb2Loose_btagscore_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Loose_btagscore_2018")
        else:
            self.deepcsvb2Loose_btagscore_2018_branch.SetAddress(<void*>&self.deepcsvb2Loose_btagscore_2018_value)

        #print "making deepcsvb2Loose_eta_2017"
        self.deepcsvb2Loose_eta_2017_branch = the_tree.GetBranch("deepcsvb2Loose_eta_2017")
        #if not self.deepcsvb2Loose_eta_2017_branch and "deepcsvb2Loose_eta_2017" not in self.complained:
        if not self.deepcsvb2Loose_eta_2017_branch and "deepcsvb2Loose_eta_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb2Loose_eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Loose_eta_2017")
        else:
            self.deepcsvb2Loose_eta_2017_branch.SetAddress(<void*>&self.deepcsvb2Loose_eta_2017_value)

        #print "making deepcsvb2Loose_eta_2018"
        self.deepcsvb2Loose_eta_2018_branch = the_tree.GetBranch("deepcsvb2Loose_eta_2018")
        #if not self.deepcsvb2Loose_eta_2018_branch and "deepcsvb2Loose_eta_2018" not in self.complained:
        if not self.deepcsvb2Loose_eta_2018_branch and "deepcsvb2Loose_eta_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb2Loose_eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Loose_eta_2018")
        else:
            self.deepcsvb2Loose_eta_2018_branch.SetAddress(<void*>&self.deepcsvb2Loose_eta_2018_value)

        #print "making deepcsvb2Loose_hadronflavour_2017"
        self.deepcsvb2Loose_hadronflavour_2017_branch = the_tree.GetBranch("deepcsvb2Loose_hadronflavour_2017")
        #if not self.deepcsvb2Loose_hadronflavour_2017_branch and "deepcsvb2Loose_hadronflavour_2017" not in self.complained:
        if not self.deepcsvb2Loose_hadronflavour_2017_branch and "deepcsvb2Loose_hadronflavour_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb2Loose_hadronflavour_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Loose_hadronflavour_2017")
        else:
            self.deepcsvb2Loose_hadronflavour_2017_branch.SetAddress(<void*>&self.deepcsvb2Loose_hadronflavour_2017_value)

        #print "making deepcsvb2Loose_hadronflavour_2018"
        self.deepcsvb2Loose_hadronflavour_2018_branch = the_tree.GetBranch("deepcsvb2Loose_hadronflavour_2018")
        #if not self.deepcsvb2Loose_hadronflavour_2018_branch and "deepcsvb2Loose_hadronflavour_2018" not in self.complained:
        if not self.deepcsvb2Loose_hadronflavour_2018_branch and "deepcsvb2Loose_hadronflavour_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb2Loose_hadronflavour_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Loose_hadronflavour_2018")
        else:
            self.deepcsvb2Loose_hadronflavour_2018_branch.SetAddress(<void*>&self.deepcsvb2Loose_hadronflavour_2018_value)

        #print "making deepcsvb2Loose_m_2017"
        self.deepcsvb2Loose_m_2017_branch = the_tree.GetBranch("deepcsvb2Loose_m_2017")
        #if not self.deepcsvb2Loose_m_2017_branch and "deepcsvb2Loose_m_2017" not in self.complained:
        if not self.deepcsvb2Loose_m_2017_branch and "deepcsvb2Loose_m_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb2Loose_m_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Loose_m_2017")
        else:
            self.deepcsvb2Loose_m_2017_branch.SetAddress(<void*>&self.deepcsvb2Loose_m_2017_value)

        #print "making deepcsvb2Loose_m_2018"
        self.deepcsvb2Loose_m_2018_branch = the_tree.GetBranch("deepcsvb2Loose_m_2018")
        #if not self.deepcsvb2Loose_m_2018_branch and "deepcsvb2Loose_m_2018" not in self.complained:
        if not self.deepcsvb2Loose_m_2018_branch and "deepcsvb2Loose_m_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb2Loose_m_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Loose_m_2018")
        else:
            self.deepcsvb2Loose_m_2018_branch.SetAddress(<void*>&self.deepcsvb2Loose_m_2018_value)

        #print "making deepcsvb2Loose_phi_2017"
        self.deepcsvb2Loose_phi_2017_branch = the_tree.GetBranch("deepcsvb2Loose_phi_2017")
        #if not self.deepcsvb2Loose_phi_2017_branch and "deepcsvb2Loose_phi_2017" not in self.complained:
        if not self.deepcsvb2Loose_phi_2017_branch and "deepcsvb2Loose_phi_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb2Loose_phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Loose_phi_2017")
        else:
            self.deepcsvb2Loose_phi_2017_branch.SetAddress(<void*>&self.deepcsvb2Loose_phi_2017_value)

        #print "making deepcsvb2Loose_phi_2018"
        self.deepcsvb2Loose_phi_2018_branch = the_tree.GetBranch("deepcsvb2Loose_phi_2018")
        #if not self.deepcsvb2Loose_phi_2018_branch and "deepcsvb2Loose_phi_2018" not in self.complained:
        if not self.deepcsvb2Loose_phi_2018_branch and "deepcsvb2Loose_phi_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb2Loose_phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Loose_phi_2018")
        else:
            self.deepcsvb2Loose_phi_2018_branch.SetAddress(<void*>&self.deepcsvb2Loose_phi_2018_value)

        #print "making deepcsvb2Loose_pt_2017"
        self.deepcsvb2Loose_pt_2017_branch = the_tree.GetBranch("deepcsvb2Loose_pt_2017")
        #if not self.deepcsvb2Loose_pt_2017_branch and "deepcsvb2Loose_pt_2017" not in self.complained:
        if not self.deepcsvb2Loose_pt_2017_branch and "deepcsvb2Loose_pt_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb2Loose_pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Loose_pt_2017")
        else:
            self.deepcsvb2Loose_pt_2017_branch.SetAddress(<void*>&self.deepcsvb2Loose_pt_2017_value)

        #print "making deepcsvb2Loose_pt_2018"
        self.deepcsvb2Loose_pt_2018_branch = the_tree.GetBranch("deepcsvb2Loose_pt_2018")
        #if not self.deepcsvb2Loose_pt_2018_branch and "deepcsvb2Loose_pt_2018" not in self.complained:
        if not self.deepcsvb2Loose_pt_2018_branch and "deepcsvb2Loose_pt_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb2Loose_pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Loose_pt_2018")
        else:
            self.deepcsvb2Loose_pt_2018_branch.SetAddress(<void*>&self.deepcsvb2Loose_pt_2018_value)

        #print "making deepcsvb2Medium_btagscore_2017"
        self.deepcsvb2Medium_btagscore_2017_branch = the_tree.GetBranch("deepcsvb2Medium_btagscore_2017")
        #if not self.deepcsvb2Medium_btagscore_2017_branch and "deepcsvb2Medium_btagscore_2017" not in self.complained:
        if not self.deepcsvb2Medium_btagscore_2017_branch and "deepcsvb2Medium_btagscore_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb2Medium_btagscore_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Medium_btagscore_2017")
        else:
            self.deepcsvb2Medium_btagscore_2017_branch.SetAddress(<void*>&self.deepcsvb2Medium_btagscore_2017_value)

        #print "making deepcsvb2Medium_btagscore_2018"
        self.deepcsvb2Medium_btagscore_2018_branch = the_tree.GetBranch("deepcsvb2Medium_btagscore_2018")
        #if not self.deepcsvb2Medium_btagscore_2018_branch and "deepcsvb2Medium_btagscore_2018" not in self.complained:
        if not self.deepcsvb2Medium_btagscore_2018_branch and "deepcsvb2Medium_btagscore_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb2Medium_btagscore_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Medium_btagscore_2018")
        else:
            self.deepcsvb2Medium_btagscore_2018_branch.SetAddress(<void*>&self.deepcsvb2Medium_btagscore_2018_value)

        #print "making deepcsvb2Medium_eta_2017"
        self.deepcsvb2Medium_eta_2017_branch = the_tree.GetBranch("deepcsvb2Medium_eta_2017")
        #if not self.deepcsvb2Medium_eta_2017_branch and "deepcsvb2Medium_eta_2017" not in self.complained:
        if not self.deepcsvb2Medium_eta_2017_branch and "deepcsvb2Medium_eta_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb2Medium_eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Medium_eta_2017")
        else:
            self.deepcsvb2Medium_eta_2017_branch.SetAddress(<void*>&self.deepcsvb2Medium_eta_2017_value)

        #print "making deepcsvb2Medium_eta_2018"
        self.deepcsvb2Medium_eta_2018_branch = the_tree.GetBranch("deepcsvb2Medium_eta_2018")
        #if not self.deepcsvb2Medium_eta_2018_branch and "deepcsvb2Medium_eta_2018" not in self.complained:
        if not self.deepcsvb2Medium_eta_2018_branch and "deepcsvb2Medium_eta_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb2Medium_eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Medium_eta_2018")
        else:
            self.deepcsvb2Medium_eta_2018_branch.SetAddress(<void*>&self.deepcsvb2Medium_eta_2018_value)

        #print "making deepcsvb2Medium_hadronflavour_2017"
        self.deepcsvb2Medium_hadronflavour_2017_branch = the_tree.GetBranch("deepcsvb2Medium_hadronflavour_2017")
        #if not self.deepcsvb2Medium_hadronflavour_2017_branch and "deepcsvb2Medium_hadronflavour_2017" not in self.complained:
        if not self.deepcsvb2Medium_hadronflavour_2017_branch and "deepcsvb2Medium_hadronflavour_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb2Medium_hadronflavour_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Medium_hadronflavour_2017")
        else:
            self.deepcsvb2Medium_hadronflavour_2017_branch.SetAddress(<void*>&self.deepcsvb2Medium_hadronflavour_2017_value)

        #print "making deepcsvb2Medium_hadronflavour_2018"
        self.deepcsvb2Medium_hadronflavour_2018_branch = the_tree.GetBranch("deepcsvb2Medium_hadronflavour_2018")
        #if not self.deepcsvb2Medium_hadronflavour_2018_branch and "deepcsvb2Medium_hadronflavour_2018" not in self.complained:
        if not self.deepcsvb2Medium_hadronflavour_2018_branch and "deepcsvb2Medium_hadronflavour_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb2Medium_hadronflavour_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Medium_hadronflavour_2018")
        else:
            self.deepcsvb2Medium_hadronflavour_2018_branch.SetAddress(<void*>&self.deepcsvb2Medium_hadronflavour_2018_value)

        #print "making deepcsvb2Medium_m_2017"
        self.deepcsvb2Medium_m_2017_branch = the_tree.GetBranch("deepcsvb2Medium_m_2017")
        #if not self.deepcsvb2Medium_m_2017_branch and "deepcsvb2Medium_m_2017" not in self.complained:
        if not self.deepcsvb2Medium_m_2017_branch and "deepcsvb2Medium_m_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb2Medium_m_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Medium_m_2017")
        else:
            self.deepcsvb2Medium_m_2017_branch.SetAddress(<void*>&self.deepcsvb2Medium_m_2017_value)

        #print "making deepcsvb2Medium_m_2018"
        self.deepcsvb2Medium_m_2018_branch = the_tree.GetBranch("deepcsvb2Medium_m_2018")
        #if not self.deepcsvb2Medium_m_2018_branch and "deepcsvb2Medium_m_2018" not in self.complained:
        if not self.deepcsvb2Medium_m_2018_branch and "deepcsvb2Medium_m_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb2Medium_m_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Medium_m_2018")
        else:
            self.deepcsvb2Medium_m_2018_branch.SetAddress(<void*>&self.deepcsvb2Medium_m_2018_value)

        #print "making deepcsvb2Medium_phi_2017"
        self.deepcsvb2Medium_phi_2017_branch = the_tree.GetBranch("deepcsvb2Medium_phi_2017")
        #if not self.deepcsvb2Medium_phi_2017_branch and "deepcsvb2Medium_phi_2017" not in self.complained:
        if not self.deepcsvb2Medium_phi_2017_branch and "deepcsvb2Medium_phi_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb2Medium_phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Medium_phi_2017")
        else:
            self.deepcsvb2Medium_phi_2017_branch.SetAddress(<void*>&self.deepcsvb2Medium_phi_2017_value)

        #print "making deepcsvb2Medium_phi_2018"
        self.deepcsvb2Medium_phi_2018_branch = the_tree.GetBranch("deepcsvb2Medium_phi_2018")
        #if not self.deepcsvb2Medium_phi_2018_branch and "deepcsvb2Medium_phi_2018" not in self.complained:
        if not self.deepcsvb2Medium_phi_2018_branch and "deepcsvb2Medium_phi_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb2Medium_phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Medium_phi_2018")
        else:
            self.deepcsvb2Medium_phi_2018_branch.SetAddress(<void*>&self.deepcsvb2Medium_phi_2018_value)

        #print "making deepcsvb2Medium_pt_2017"
        self.deepcsvb2Medium_pt_2017_branch = the_tree.GetBranch("deepcsvb2Medium_pt_2017")
        #if not self.deepcsvb2Medium_pt_2017_branch and "deepcsvb2Medium_pt_2017" not in self.complained:
        if not self.deepcsvb2Medium_pt_2017_branch and "deepcsvb2Medium_pt_2017":
            warnings.warn( "EMTree: Expected branch deepcsvb2Medium_pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Medium_pt_2017")
        else:
            self.deepcsvb2Medium_pt_2017_branch.SetAddress(<void*>&self.deepcsvb2Medium_pt_2017_value)

        #print "making deepcsvb2Medium_pt_2018"
        self.deepcsvb2Medium_pt_2018_branch = the_tree.GetBranch("deepcsvb2Medium_pt_2018")
        #if not self.deepcsvb2Medium_pt_2018_branch and "deepcsvb2Medium_pt_2018" not in self.complained:
        if not self.deepcsvb2Medium_pt_2018_branch and "deepcsvb2Medium_pt_2018":
            warnings.warn( "EMTree: Expected branch deepcsvb2Medium_pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2Medium_pt_2018")
        else:
            self.deepcsvb2Medium_pt_2018_branch.SetAddress(<void*>&self.deepcsvb2Medium_pt_2018_value)

        #print "making deepflavourLooseb1_btagscore_2017"
        self.deepflavourLooseb1_btagscore_2017_branch = the_tree.GetBranch("deepflavourLooseb1_btagscore_2017")
        #if not self.deepflavourLooseb1_btagscore_2017_branch and "deepflavourLooseb1_btagscore_2017" not in self.complained:
        if not self.deepflavourLooseb1_btagscore_2017_branch and "deepflavourLooseb1_btagscore_2017":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb1_btagscore_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb1_btagscore_2017")
        else:
            self.deepflavourLooseb1_btagscore_2017_branch.SetAddress(<void*>&self.deepflavourLooseb1_btagscore_2017_value)

        #print "making deepflavourLooseb1_btagscore_2018"
        self.deepflavourLooseb1_btagscore_2018_branch = the_tree.GetBranch("deepflavourLooseb1_btagscore_2018")
        #if not self.deepflavourLooseb1_btagscore_2018_branch and "deepflavourLooseb1_btagscore_2018" not in self.complained:
        if not self.deepflavourLooseb1_btagscore_2018_branch and "deepflavourLooseb1_btagscore_2018":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb1_btagscore_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb1_btagscore_2018")
        else:
            self.deepflavourLooseb1_btagscore_2018_branch.SetAddress(<void*>&self.deepflavourLooseb1_btagscore_2018_value)

        #print "making deepflavourLooseb1_eta_2017"
        self.deepflavourLooseb1_eta_2017_branch = the_tree.GetBranch("deepflavourLooseb1_eta_2017")
        #if not self.deepflavourLooseb1_eta_2017_branch and "deepflavourLooseb1_eta_2017" not in self.complained:
        if not self.deepflavourLooseb1_eta_2017_branch and "deepflavourLooseb1_eta_2017":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb1_eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb1_eta_2017")
        else:
            self.deepflavourLooseb1_eta_2017_branch.SetAddress(<void*>&self.deepflavourLooseb1_eta_2017_value)

        #print "making deepflavourLooseb1_eta_2018"
        self.deepflavourLooseb1_eta_2018_branch = the_tree.GetBranch("deepflavourLooseb1_eta_2018")
        #if not self.deepflavourLooseb1_eta_2018_branch and "deepflavourLooseb1_eta_2018" not in self.complained:
        if not self.deepflavourLooseb1_eta_2018_branch and "deepflavourLooseb1_eta_2018":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb1_eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb1_eta_2018")
        else:
            self.deepflavourLooseb1_eta_2018_branch.SetAddress(<void*>&self.deepflavourLooseb1_eta_2018_value)

        #print "making deepflavourLooseb1_hadronflavour_2017"
        self.deepflavourLooseb1_hadronflavour_2017_branch = the_tree.GetBranch("deepflavourLooseb1_hadronflavour_2017")
        #if not self.deepflavourLooseb1_hadronflavour_2017_branch and "deepflavourLooseb1_hadronflavour_2017" not in self.complained:
        if not self.deepflavourLooseb1_hadronflavour_2017_branch and "deepflavourLooseb1_hadronflavour_2017":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb1_hadronflavour_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb1_hadronflavour_2017")
        else:
            self.deepflavourLooseb1_hadronflavour_2017_branch.SetAddress(<void*>&self.deepflavourLooseb1_hadronflavour_2017_value)

        #print "making deepflavourLooseb1_hadronflavour_2018"
        self.deepflavourLooseb1_hadronflavour_2018_branch = the_tree.GetBranch("deepflavourLooseb1_hadronflavour_2018")
        #if not self.deepflavourLooseb1_hadronflavour_2018_branch and "deepflavourLooseb1_hadronflavour_2018" not in self.complained:
        if not self.deepflavourLooseb1_hadronflavour_2018_branch and "deepflavourLooseb1_hadronflavour_2018":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb1_hadronflavour_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb1_hadronflavour_2018")
        else:
            self.deepflavourLooseb1_hadronflavour_2018_branch.SetAddress(<void*>&self.deepflavourLooseb1_hadronflavour_2018_value)

        #print "making deepflavourLooseb1_m_2017"
        self.deepflavourLooseb1_m_2017_branch = the_tree.GetBranch("deepflavourLooseb1_m_2017")
        #if not self.deepflavourLooseb1_m_2017_branch and "deepflavourLooseb1_m_2017" not in self.complained:
        if not self.deepflavourLooseb1_m_2017_branch and "deepflavourLooseb1_m_2017":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb1_m_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb1_m_2017")
        else:
            self.deepflavourLooseb1_m_2017_branch.SetAddress(<void*>&self.deepflavourLooseb1_m_2017_value)

        #print "making deepflavourLooseb1_m_2018"
        self.deepflavourLooseb1_m_2018_branch = the_tree.GetBranch("deepflavourLooseb1_m_2018")
        #if not self.deepflavourLooseb1_m_2018_branch and "deepflavourLooseb1_m_2018" not in self.complained:
        if not self.deepflavourLooseb1_m_2018_branch and "deepflavourLooseb1_m_2018":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb1_m_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb1_m_2018")
        else:
            self.deepflavourLooseb1_m_2018_branch.SetAddress(<void*>&self.deepflavourLooseb1_m_2018_value)

        #print "making deepflavourLooseb1_phi_2017"
        self.deepflavourLooseb1_phi_2017_branch = the_tree.GetBranch("deepflavourLooseb1_phi_2017")
        #if not self.deepflavourLooseb1_phi_2017_branch and "deepflavourLooseb1_phi_2017" not in self.complained:
        if not self.deepflavourLooseb1_phi_2017_branch and "deepflavourLooseb1_phi_2017":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb1_phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb1_phi_2017")
        else:
            self.deepflavourLooseb1_phi_2017_branch.SetAddress(<void*>&self.deepflavourLooseb1_phi_2017_value)

        #print "making deepflavourLooseb1_phi_2018"
        self.deepflavourLooseb1_phi_2018_branch = the_tree.GetBranch("deepflavourLooseb1_phi_2018")
        #if not self.deepflavourLooseb1_phi_2018_branch and "deepflavourLooseb1_phi_2018" not in self.complained:
        if not self.deepflavourLooseb1_phi_2018_branch and "deepflavourLooseb1_phi_2018":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb1_phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb1_phi_2018")
        else:
            self.deepflavourLooseb1_phi_2018_branch.SetAddress(<void*>&self.deepflavourLooseb1_phi_2018_value)

        #print "making deepflavourLooseb1_pt_2017"
        self.deepflavourLooseb1_pt_2017_branch = the_tree.GetBranch("deepflavourLooseb1_pt_2017")
        #if not self.deepflavourLooseb1_pt_2017_branch and "deepflavourLooseb1_pt_2017" not in self.complained:
        if not self.deepflavourLooseb1_pt_2017_branch and "deepflavourLooseb1_pt_2017":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb1_pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb1_pt_2017")
        else:
            self.deepflavourLooseb1_pt_2017_branch.SetAddress(<void*>&self.deepflavourLooseb1_pt_2017_value)

        #print "making deepflavourLooseb1_pt_2018"
        self.deepflavourLooseb1_pt_2018_branch = the_tree.GetBranch("deepflavourLooseb1_pt_2018")
        #if not self.deepflavourLooseb1_pt_2018_branch and "deepflavourLooseb1_pt_2018" not in self.complained:
        if not self.deepflavourLooseb1_pt_2018_branch and "deepflavourLooseb1_pt_2018":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb1_pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb1_pt_2018")
        else:
            self.deepflavourLooseb1_pt_2018_branch.SetAddress(<void*>&self.deepflavourLooseb1_pt_2018_value)

        #print "making deepflavourLooseb2_btagscore_2017"
        self.deepflavourLooseb2_btagscore_2017_branch = the_tree.GetBranch("deepflavourLooseb2_btagscore_2017")
        #if not self.deepflavourLooseb2_btagscore_2017_branch and "deepflavourLooseb2_btagscore_2017" not in self.complained:
        if not self.deepflavourLooseb2_btagscore_2017_branch and "deepflavourLooseb2_btagscore_2017":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb2_btagscore_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb2_btagscore_2017")
        else:
            self.deepflavourLooseb2_btagscore_2017_branch.SetAddress(<void*>&self.deepflavourLooseb2_btagscore_2017_value)

        #print "making deepflavourLooseb2_btagscore_2018"
        self.deepflavourLooseb2_btagscore_2018_branch = the_tree.GetBranch("deepflavourLooseb2_btagscore_2018")
        #if not self.deepflavourLooseb2_btagscore_2018_branch and "deepflavourLooseb2_btagscore_2018" not in self.complained:
        if not self.deepflavourLooseb2_btagscore_2018_branch and "deepflavourLooseb2_btagscore_2018":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb2_btagscore_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb2_btagscore_2018")
        else:
            self.deepflavourLooseb2_btagscore_2018_branch.SetAddress(<void*>&self.deepflavourLooseb2_btagscore_2018_value)

        #print "making deepflavourLooseb2_eta_2017"
        self.deepflavourLooseb2_eta_2017_branch = the_tree.GetBranch("deepflavourLooseb2_eta_2017")
        #if not self.deepflavourLooseb2_eta_2017_branch and "deepflavourLooseb2_eta_2017" not in self.complained:
        if not self.deepflavourLooseb2_eta_2017_branch and "deepflavourLooseb2_eta_2017":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb2_eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb2_eta_2017")
        else:
            self.deepflavourLooseb2_eta_2017_branch.SetAddress(<void*>&self.deepflavourLooseb2_eta_2017_value)

        #print "making deepflavourLooseb2_eta_2018"
        self.deepflavourLooseb2_eta_2018_branch = the_tree.GetBranch("deepflavourLooseb2_eta_2018")
        #if not self.deepflavourLooseb2_eta_2018_branch and "deepflavourLooseb2_eta_2018" not in self.complained:
        if not self.deepflavourLooseb2_eta_2018_branch and "deepflavourLooseb2_eta_2018":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb2_eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb2_eta_2018")
        else:
            self.deepflavourLooseb2_eta_2018_branch.SetAddress(<void*>&self.deepflavourLooseb2_eta_2018_value)

        #print "making deepflavourLooseb2_hadronflavour_2017"
        self.deepflavourLooseb2_hadronflavour_2017_branch = the_tree.GetBranch("deepflavourLooseb2_hadronflavour_2017")
        #if not self.deepflavourLooseb2_hadronflavour_2017_branch and "deepflavourLooseb2_hadronflavour_2017" not in self.complained:
        if not self.deepflavourLooseb2_hadronflavour_2017_branch and "deepflavourLooseb2_hadronflavour_2017":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb2_hadronflavour_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb2_hadronflavour_2017")
        else:
            self.deepflavourLooseb2_hadronflavour_2017_branch.SetAddress(<void*>&self.deepflavourLooseb2_hadronflavour_2017_value)

        #print "making deepflavourLooseb2_hadronflavour_2018"
        self.deepflavourLooseb2_hadronflavour_2018_branch = the_tree.GetBranch("deepflavourLooseb2_hadronflavour_2018")
        #if not self.deepflavourLooseb2_hadronflavour_2018_branch and "deepflavourLooseb2_hadronflavour_2018" not in self.complained:
        if not self.deepflavourLooseb2_hadronflavour_2018_branch and "deepflavourLooseb2_hadronflavour_2018":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb2_hadronflavour_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb2_hadronflavour_2018")
        else:
            self.deepflavourLooseb2_hadronflavour_2018_branch.SetAddress(<void*>&self.deepflavourLooseb2_hadronflavour_2018_value)

        #print "making deepflavourLooseb2_m_2017"
        self.deepflavourLooseb2_m_2017_branch = the_tree.GetBranch("deepflavourLooseb2_m_2017")
        #if not self.deepflavourLooseb2_m_2017_branch and "deepflavourLooseb2_m_2017" not in self.complained:
        if not self.deepflavourLooseb2_m_2017_branch and "deepflavourLooseb2_m_2017":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb2_m_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb2_m_2017")
        else:
            self.deepflavourLooseb2_m_2017_branch.SetAddress(<void*>&self.deepflavourLooseb2_m_2017_value)

        #print "making deepflavourLooseb2_m_2018"
        self.deepflavourLooseb2_m_2018_branch = the_tree.GetBranch("deepflavourLooseb2_m_2018")
        #if not self.deepflavourLooseb2_m_2018_branch and "deepflavourLooseb2_m_2018" not in self.complained:
        if not self.deepflavourLooseb2_m_2018_branch and "deepflavourLooseb2_m_2018":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb2_m_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb2_m_2018")
        else:
            self.deepflavourLooseb2_m_2018_branch.SetAddress(<void*>&self.deepflavourLooseb2_m_2018_value)

        #print "making deepflavourLooseb2_phi_2017"
        self.deepflavourLooseb2_phi_2017_branch = the_tree.GetBranch("deepflavourLooseb2_phi_2017")
        #if not self.deepflavourLooseb2_phi_2017_branch and "deepflavourLooseb2_phi_2017" not in self.complained:
        if not self.deepflavourLooseb2_phi_2017_branch and "deepflavourLooseb2_phi_2017":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb2_phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb2_phi_2017")
        else:
            self.deepflavourLooseb2_phi_2017_branch.SetAddress(<void*>&self.deepflavourLooseb2_phi_2017_value)

        #print "making deepflavourLooseb2_phi_2018"
        self.deepflavourLooseb2_phi_2018_branch = the_tree.GetBranch("deepflavourLooseb2_phi_2018")
        #if not self.deepflavourLooseb2_phi_2018_branch and "deepflavourLooseb2_phi_2018" not in self.complained:
        if not self.deepflavourLooseb2_phi_2018_branch and "deepflavourLooseb2_phi_2018":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb2_phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb2_phi_2018")
        else:
            self.deepflavourLooseb2_phi_2018_branch.SetAddress(<void*>&self.deepflavourLooseb2_phi_2018_value)

        #print "making deepflavourLooseb2_pt_2017"
        self.deepflavourLooseb2_pt_2017_branch = the_tree.GetBranch("deepflavourLooseb2_pt_2017")
        #if not self.deepflavourLooseb2_pt_2017_branch and "deepflavourLooseb2_pt_2017" not in self.complained:
        if not self.deepflavourLooseb2_pt_2017_branch and "deepflavourLooseb2_pt_2017":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb2_pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb2_pt_2017")
        else:
            self.deepflavourLooseb2_pt_2017_branch.SetAddress(<void*>&self.deepflavourLooseb2_pt_2017_value)

        #print "making deepflavourLooseb2_pt_2018"
        self.deepflavourLooseb2_pt_2018_branch = the_tree.GetBranch("deepflavourLooseb2_pt_2018")
        #if not self.deepflavourLooseb2_pt_2018_branch and "deepflavourLooseb2_pt_2018" not in self.complained:
        if not self.deepflavourLooseb2_pt_2018_branch and "deepflavourLooseb2_pt_2018":
            warnings.warn( "EMTree: Expected branch deepflavourLooseb2_pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourLooseb2_pt_2018")
        else:
            self.deepflavourLooseb2_pt_2018_branch.SetAddress(<void*>&self.deepflavourLooseb2_pt_2018_value)

        #print "making deepflavourMediumb1_btagscore_2017"
        self.deepflavourMediumb1_btagscore_2017_branch = the_tree.GetBranch("deepflavourMediumb1_btagscore_2017")
        #if not self.deepflavourMediumb1_btagscore_2017_branch and "deepflavourMediumb1_btagscore_2017" not in self.complained:
        if not self.deepflavourMediumb1_btagscore_2017_branch and "deepflavourMediumb1_btagscore_2017":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb1_btagscore_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb1_btagscore_2017")
        else:
            self.deepflavourMediumb1_btagscore_2017_branch.SetAddress(<void*>&self.deepflavourMediumb1_btagscore_2017_value)

        #print "making deepflavourMediumb1_btagscore_2018"
        self.deepflavourMediumb1_btagscore_2018_branch = the_tree.GetBranch("deepflavourMediumb1_btagscore_2018")
        #if not self.deepflavourMediumb1_btagscore_2018_branch and "deepflavourMediumb1_btagscore_2018" not in self.complained:
        if not self.deepflavourMediumb1_btagscore_2018_branch and "deepflavourMediumb1_btagscore_2018":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb1_btagscore_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb1_btagscore_2018")
        else:
            self.deepflavourMediumb1_btagscore_2018_branch.SetAddress(<void*>&self.deepflavourMediumb1_btagscore_2018_value)

        #print "making deepflavourMediumb1_eta_2017"
        self.deepflavourMediumb1_eta_2017_branch = the_tree.GetBranch("deepflavourMediumb1_eta_2017")
        #if not self.deepflavourMediumb1_eta_2017_branch and "deepflavourMediumb1_eta_2017" not in self.complained:
        if not self.deepflavourMediumb1_eta_2017_branch and "deepflavourMediumb1_eta_2017":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb1_eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb1_eta_2017")
        else:
            self.deepflavourMediumb1_eta_2017_branch.SetAddress(<void*>&self.deepflavourMediumb1_eta_2017_value)

        #print "making deepflavourMediumb1_eta_2018"
        self.deepflavourMediumb1_eta_2018_branch = the_tree.GetBranch("deepflavourMediumb1_eta_2018")
        #if not self.deepflavourMediumb1_eta_2018_branch and "deepflavourMediumb1_eta_2018" not in self.complained:
        if not self.deepflavourMediumb1_eta_2018_branch and "deepflavourMediumb1_eta_2018":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb1_eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb1_eta_2018")
        else:
            self.deepflavourMediumb1_eta_2018_branch.SetAddress(<void*>&self.deepflavourMediumb1_eta_2018_value)

        #print "making deepflavourMediumb1_hadronflavour_2017"
        self.deepflavourMediumb1_hadronflavour_2017_branch = the_tree.GetBranch("deepflavourMediumb1_hadronflavour_2017")
        #if not self.deepflavourMediumb1_hadronflavour_2017_branch and "deepflavourMediumb1_hadronflavour_2017" not in self.complained:
        if not self.deepflavourMediumb1_hadronflavour_2017_branch and "deepflavourMediumb1_hadronflavour_2017":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb1_hadronflavour_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb1_hadronflavour_2017")
        else:
            self.deepflavourMediumb1_hadronflavour_2017_branch.SetAddress(<void*>&self.deepflavourMediumb1_hadronflavour_2017_value)

        #print "making deepflavourMediumb1_hadronflavour_2018"
        self.deepflavourMediumb1_hadronflavour_2018_branch = the_tree.GetBranch("deepflavourMediumb1_hadronflavour_2018")
        #if not self.deepflavourMediumb1_hadronflavour_2018_branch and "deepflavourMediumb1_hadronflavour_2018" not in self.complained:
        if not self.deepflavourMediumb1_hadronflavour_2018_branch and "deepflavourMediumb1_hadronflavour_2018":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb1_hadronflavour_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb1_hadronflavour_2018")
        else:
            self.deepflavourMediumb1_hadronflavour_2018_branch.SetAddress(<void*>&self.deepflavourMediumb1_hadronflavour_2018_value)

        #print "making deepflavourMediumb1_m_2017"
        self.deepflavourMediumb1_m_2017_branch = the_tree.GetBranch("deepflavourMediumb1_m_2017")
        #if not self.deepflavourMediumb1_m_2017_branch and "deepflavourMediumb1_m_2017" not in self.complained:
        if not self.deepflavourMediumb1_m_2017_branch and "deepflavourMediumb1_m_2017":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb1_m_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb1_m_2017")
        else:
            self.deepflavourMediumb1_m_2017_branch.SetAddress(<void*>&self.deepflavourMediumb1_m_2017_value)

        #print "making deepflavourMediumb1_m_2018"
        self.deepflavourMediumb1_m_2018_branch = the_tree.GetBranch("deepflavourMediumb1_m_2018")
        #if not self.deepflavourMediumb1_m_2018_branch and "deepflavourMediumb1_m_2018" not in self.complained:
        if not self.deepflavourMediumb1_m_2018_branch and "deepflavourMediumb1_m_2018":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb1_m_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb1_m_2018")
        else:
            self.deepflavourMediumb1_m_2018_branch.SetAddress(<void*>&self.deepflavourMediumb1_m_2018_value)

        #print "making deepflavourMediumb1_phi_2017"
        self.deepflavourMediumb1_phi_2017_branch = the_tree.GetBranch("deepflavourMediumb1_phi_2017")
        #if not self.deepflavourMediumb1_phi_2017_branch and "deepflavourMediumb1_phi_2017" not in self.complained:
        if not self.deepflavourMediumb1_phi_2017_branch and "deepflavourMediumb1_phi_2017":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb1_phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb1_phi_2017")
        else:
            self.deepflavourMediumb1_phi_2017_branch.SetAddress(<void*>&self.deepflavourMediumb1_phi_2017_value)

        #print "making deepflavourMediumb1_phi_2018"
        self.deepflavourMediumb1_phi_2018_branch = the_tree.GetBranch("deepflavourMediumb1_phi_2018")
        #if not self.deepflavourMediumb1_phi_2018_branch and "deepflavourMediumb1_phi_2018" not in self.complained:
        if not self.deepflavourMediumb1_phi_2018_branch and "deepflavourMediumb1_phi_2018":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb1_phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb1_phi_2018")
        else:
            self.deepflavourMediumb1_phi_2018_branch.SetAddress(<void*>&self.deepflavourMediumb1_phi_2018_value)

        #print "making deepflavourMediumb1_pt_2017"
        self.deepflavourMediumb1_pt_2017_branch = the_tree.GetBranch("deepflavourMediumb1_pt_2017")
        #if not self.deepflavourMediumb1_pt_2017_branch and "deepflavourMediumb1_pt_2017" not in self.complained:
        if not self.deepflavourMediumb1_pt_2017_branch and "deepflavourMediumb1_pt_2017":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb1_pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb1_pt_2017")
        else:
            self.deepflavourMediumb1_pt_2017_branch.SetAddress(<void*>&self.deepflavourMediumb1_pt_2017_value)

        #print "making deepflavourMediumb1_pt_2018"
        self.deepflavourMediumb1_pt_2018_branch = the_tree.GetBranch("deepflavourMediumb1_pt_2018")
        #if not self.deepflavourMediumb1_pt_2018_branch and "deepflavourMediumb1_pt_2018" not in self.complained:
        if not self.deepflavourMediumb1_pt_2018_branch and "deepflavourMediumb1_pt_2018":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb1_pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb1_pt_2018")
        else:
            self.deepflavourMediumb1_pt_2018_branch.SetAddress(<void*>&self.deepflavourMediumb1_pt_2018_value)

        #print "making deepflavourMediumb2_btagscore_2017"
        self.deepflavourMediumb2_btagscore_2017_branch = the_tree.GetBranch("deepflavourMediumb2_btagscore_2017")
        #if not self.deepflavourMediumb2_btagscore_2017_branch and "deepflavourMediumb2_btagscore_2017" not in self.complained:
        if not self.deepflavourMediumb2_btagscore_2017_branch and "deepflavourMediumb2_btagscore_2017":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb2_btagscore_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb2_btagscore_2017")
        else:
            self.deepflavourMediumb2_btagscore_2017_branch.SetAddress(<void*>&self.deepflavourMediumb2_btagscore_2017_value)

        #print "making deepflavourMediumb2_btagscore_2018"
        self.deepflavourMediumb2_btagscore_2018_branch = the_tree.GetBranch("deepflavourMediumb2_btagscore_2018")
        #if not self.deepflavourMediumb2_btagscore_2018_branch and "deepflavourMediumb2_btagscore_2018" not in self.complained:
        if not self.deepflavourMediumb2_btagscore_2018_branch and "deepflavourMediumb2_btagscore_2018":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb2_btagscore_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb2_btagscore_2018")
        else:
            self.deepflavourMediumb2_btagscore_2018_branch.SetAddress(<void*>&self.deepflavourMediumb2_btagscore_2018_value)

        #print "making deepflavourMediumb2_eta_2017"
        self.deepflavourMediumb2_eta_2017_branch = the_tree.GetBranch("deepflavourMediumb2_eta_2017")
        #if not self.deepflavourMediumb2_eta_2017_branch and "deepflavourMediumb2_eta_2017" not in self.complained:
        if not self.deepflavourMediumb2_eta_2017_branch and "deepflavourMediumb2_eta_2017":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb2_eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb2_eta_2017")
        else:
            self.deepflavourMediumb2_eta_2017_branch.SetAddress(<void*>&self.deepflavourMediumb2_eta_2017_value)

        #print "making deepflavourMediumb2_eta_2018"
        self.deepflavourMediumb2_eta_2018_branch = the_tree.GetBranch("deepflavourMediumb2_eta_2018")
        #if not self.deepflavourMediumb2_eta_2018_branch and "deepflavourMediumb2_eta_2018" not in self.complained:
        if not self.deepflavourMediumb2_eta_2018_branch and "deepflavourMediumb2_eta_2018":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb2_eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb2_eta_2018")
        else:
            self.deepflavourMediumb2_eta_2018_branch.SetAddress(<void*>&self.deepflavourMediumb2_eta_2018_value)

        #print "making deepflavourMediumb2_hadronflavour_2017"
        self.deepflavourMediumb2_hadronflavour_2017_branch = the_tree.GetBranch("deepflavourMediumb2_hadronflavour_2017")
        #if not self.deepflavourMediumb2_hadronflavour_2017_branch and "deepflavourMediumb2_hadronflavour_2017" not in self.complained:
        if not self.deepflavourMediumb2_hadronflavour_2017_branch and "deepflavourMediumb2_hadronflavour_2017":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb2_hadronflavour_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb2_hadronflavour_2017")
        else:
            self.deepflavourMediumb2_hadronflavour_2017_branch.SetAddress(<void*>&self.deepflavourMediumb2_hadronflavour_2017_value)

        #print "making deepflavourMediumb2_hadronflavour_2018"
        self.deepflavourMediumb2_hadronflavour_2018_branch = the_tree.GetBranch("deepflavourMediumb2_hadronflavour_2018")
        #if not self.deepflavourMediumb2_hadronflavour_2018_branch and "deepflavourMediumb2_hadronflavour_2018" not in self.complained:
        if not self.deepflavourMediumb2_hadronflavour_2018_branch and "deepflavourMediumb2_hadronflavour_2018":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb2_hadronflavour_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb2_hadronflavour_2018")
        else:
            self.deepflavourMediumb2_hadronflavour_2018_branch.SetAddress(<void*>&self.deepflavourMediumb2_hadronflavour_2018_value)

        #print "making deepflavourMediumb2_m_2017"
        self.deepflavourMediumb2_m_2017_branch = the_tree.GetBranch("deepflavourMediumb2_m_2017")
        #if not self.deepflavourMediumb2_m_2017_branch and "deepflavourMediumb2_m_2017" not in self.complained:
        if not self.deepflavourMediumb2_m_2017_branch and "deepflavourMediumb2_m_2017":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb2_m_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb2_m_2017")
        else:
            self.deepflavourMediumb2_m_2017_branch.SetAddress(<void*>&self.deepflavourMediumb2_m_2017_value)

        #print "making deepflavourMediumb2_m_2018"
        self.deepflavourMediumb2_m_2018_branch = the_tree.GetBranch("deepflavourMediumb2_m_2018")
        #if not self.deepflavourMediumb2_m_2018_branch and "deepflavourMediumb2_m_2018" not in self.complained:
        if not self.deepflavourMediumb2_m_2018_branch and "deepflavourMediumb2_m_2018":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb2_m_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb2_m_2018")
        else:
            self.deepflavourMediumb2_m_2018_branch.SetAddress(<void*>&self.deepflavourMediumb2_m_2018_value)

        #print "making deepflavourMediumb2_phi_2017"
        self.deepflavourMediumb2_phi_2017_branch = the_tree.GetBranch("deepflavourMediumb2_phi_2017")
        #if not self.deepflavourMediumb2_phi_2017_branch and "deepflavourMediumb2_phi_2017" not in self.complained:
        if not self.deepflavourMediumb2_phi_2017_branch and "deepflavourMediumb2_phi_2017":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb2_phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb2_phi_2017")
        else:
            self.deepflavourMediumb2_phi_2017_branch.SetAddress(<void*>&self.deepflavourMediumb2_phi_2017_value)

        #print "making deepflavourMediumb2_phi_2018"
        self.deepflavourMediumb2_phi_2018_branch = the_tree.GetBranch("deepflavourMediumb2_phi_2018")
        #if not self.deepflavourMediumb2_phi_2018_branch and "deepflavourMediumb2_phi_2018" not in self.complained:
        if not self.deepflavourMediumb2_phi_2018_branch and "deepflavourMediumb2_phi_2018":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb2_phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb2_phi_2018")
        else:
            self.deepflavourMediumb2_phi_2018_branch.SetAddress(<void*>&self.deepflavourMediumb2_phi_2018_value)

        #print "making deepflavourMediumb2_pt_2017"
        self.deepflavourMediumb2_pt_2017_branch = the_tree.GetBranch("deepflavourMediumb2_pt_2017")
        #if not self.deepflavourMediumb2_pt_2017_branch and "deepflavourMediumb2_pt_2017" not in self.complained:
        if not self.deepflavourMediumb2_pt_2017_branch and "deepflavourMediumb2_pt_2017":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb2_pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb2_pt_2017")
        else:
            self.deepflavourMediumb2_pt_2017_branch.SetAddress(<void*>&self.deepflavourMediumb2_pt_2017_value)

        #print "making deepflavourMediumb2_pt_2018"
        self.deepflavourMediumb2_pt_2018_branch = the_tree.GetBranch("deepflavourMediumb2_pt_2018")
        #if not self.deepflavourMediumb2_pt_2018_branch and "deepflavourMediumb2_pt_2018" not in self.complained:
        if not self.deepflavourMediumb2_pt_2018_branch and "deepflavourMediumb2_pt_2018":
            warnings.warn( "EMTree: Expected branch deepflavourMediumb2_pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepflavourMediumb2_pt_2018")
        else:
            self.deepflavourMediumb2_pt_2018_branch.SetAddress(<void*>&self.deepflavourMediumb2_pt_2018_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "EMTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

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

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "EMTree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

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

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "EMTree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

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

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "EMTree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

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

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "EMTree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

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

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "EMTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "EMTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

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

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EMTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making m1BestTrackType"
        self.m1BestTrackType_branch = the_tree.GetBranch("m1BestTrackType")
        #if not self.m1BestTrackType_branch and "m1BestTrackType" not in self.complained:
        if not self.m1BestTrackType_branch and "m1BestTrackType":
            warnings.warn( "EMTree: Expected branch m1BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1BestTrackType")
        else:
            self.m1BestTrackType_branch.SetAddress(<void*>&self.m1BestTrackType_value)

        #print "making m1Charge"
        self.m1Charge_branch = the_tree.GetBranch("m1Charge")
        #if not self.m1Charge_branch and "m1Charge" not in self.complained:
        if not self.m1Charge_branch and "m1Charge":
            warnings.warn( "EMTree: Expected branch m1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Charge")
        else:
            self.m1Charge_branch.SetAddress(<void*>&self.m1Charge_value)

        #print "making m1EcalIsoDR03"
        self.m1EcalIsoDR03_branch = the_tree.GetBranch("m1EcalIsoDR03")
        #if not self.m1EcalIsoDR03_branch and "m1EcalIsoDR03" not in self.complained:
        if not self.m1EcalIsoDR03_branch and "m1EcalIsoDR03":
            warnings.warn( "EMTree: Expected branch m1EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EcalIsoDR03")
        else:
            self.m1EcalIsoDR03_branch.SetAddress(<void*>&self.m1EcalIsoDR03_value)

        #print "making m1Eta"
        self.m1Eta_branch = the_tree.GetBranch("m1Eta")
        #if not self.m1Eta_branch and "m1Eta" not in self.complained:
        if not self.m1Eta_branch and "m1Eta":
            warnings.warn( "EMTree: Expected branch m1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta")
        else:
            self.m1Eta_branch.SetAddress(<void*>&self.m1Eta_value)

        #print "making m1GenCharge"
        self.m1GenCharge_branch = the_tree.GetBranch("m1GenCharge")
        #if not self.m1GenCharge_branch and "m1GenCharge" not in self.complained:
        if not self.m1GenCharge_branch and "m1GenCharge":
            warnings.warn( "EMTree: Expected branch m1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenCharge")
        else:
            self.m1GenCharge_branch.SetAddress(<void*>&self.m1GenCharge_value)

        #print "making m1GenEnergy"
        self.m1GenEnergy_branch = the_tree.GetBranch("m1GenEnergy")
        #if not self.m1GenEnergy_branch and "m1GenEnergy" not in self.complained:
        if not self.m1GenEnergy_branch and "m1GenEnergy":
            warnings.warn( "EMTree: Expected branch m1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEnergy")
        else:
            self.m1GenEnergy_branch.SetAddress(<void*>&self.m1GenEnergy_value)

        #print "making m1GenEta"
        self.m1GenEta_branch = the_tree.GetBranch("m1GenEta")
        #if not self.m1GenEta_branch and "m1GenEta" not in self.complained:
        if not self.m1GenEta_branch and "m1GenEta":
            warnings.warn( "EMTree: Expected branch m1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEta")
        else:
            self.m1GenEta_branch.SetAddress(<void*>&self.m1GenEta_value)

        #print "making m1GenMotherPdgId"
        self.m1GenMotherPdgId_branch = the_tree.GetBranch("m1GenMotherPdgId")
        #if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId" not in self.complained:
        if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId":
            warnings.warn( "EMTree: Expected branch m1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenMotherPdgId")
        else:
            self.m1GenMotherPdgId_branch.SetAddress(<void*>&self.m1GenMotherPdgId_value)

        #print "making m1GenParticle"
        self.m1GenParticle_branch = the_tree.GetBranch("m1GenParticle")
        #if not self.m1GenParticle_branch and "m1GenParticle" not in self.complained:
        if not self.m1GenParticle_branch and "m1GenParticle":
            warnings.warn( "EMTree: Expected branch m1GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenParticle")
        else:
            self.m1GenParticle_branch.SetAddress(<void*>&self.m1GenParticle_value)

        #print "making m1GenPdgId"
        self.m1GenPdgId_branch = the_tree.GetBranch("m1GenPdgId")
        #if not self.m1GenPdgId_branch and "m1GenPdgId" not in self.complained:
        if not self.m1GenPdgId_branch and "m1GenPdgId":
            warnings.warn( "EMTree: Expected branch m1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPdgId")
        else:
            self.m1GenPdgId_branch.SetAddress(<void*>&self.m1GenPdgId_value)

        #print "making m1GenPhi"
        self.m1GenPhi_branch = the_tree.GetBranch("m1GenPhi")
        #if not self.m1GenPhi_branch and "m1GenPhi" not in self.complained:
        if not self.m1GenPhi_branch and "m1GenPhi":
            warnings.warn( "EMTree: Expected branch m1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPhi")
        else:
            self.m1GenPhi_branch.SetAddress(<void*>&self.m1GenPhi_value)

        #print "making m1GenPt"
        self.m1GenPt_branch = the_tree.GetBranch("m1GenPt")
        #if not self.m1GenPt_branch and "m1GenPt" not in self.complained:
        if not self.m1GenPt_branch and "m1GenPt":
            warnings.warn( "EMTree: Expected branch m1GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPt")
        else:
            self.m1GenPt_branch.SetAddress(<void*>&self.m1GenPt_value)

        #print "making m1GenVZ"
        self.m1GenVZ_branch = the_tree.GetBranch("m1GenVZ")
        #if not self.m1GenVZ_branch and "m1GenVZ" not in self.complained:
        if not self.m1GenVZ_branch and "m1GenVZ":
            warnings.warn( "EMTree: Expected branch m1GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenVZ")
        else:
            self.m1GenVZ_branch.SetAddress(<void*>&self.m1GenVZ_value)

        #print "making m1HcalIsoDR03"
        self.m1HcalIsoDR03_branch = the_tree.GetBranch("m1HcalIsoDR03")
        #if not self.m1HcalIsoDR03_branch and "m1HcalIsoDR03" not in self.complained:
        if not self.m1HcalIsoDR03_branch and "m1HcalIsoDR03":
            warnings.warn( "EMTree: Expected branch m1HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1HcalIsoDR03")
        else:
            self.m1HcalIsoDR03_branch.SetAddress(<void*>&self.m1HcalIsoDR03_value)

        #print "making m1IP3D"
        self.m1IP3D_branch = the_tree.GetBranch("m1IP3D")
        #if not self.m1IP3D_branch and "m1IP3D" not in self.complained:
        if not self.m1IP3D_branch and "m1IP3D":
            warnings.warn( "EMTree: Expected branch m1IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3D")
        else:
            self.m1IP3D_branch.SetAddress(<void*>&self.m1IP3D_value)

        #print "making m1IP3DS"
        self.m1IP3DS_branch = the_tree.GetBranch("m1IP3DS")
        #if not self.m1IP3DS_branch and "m1IP3DS" not in self.complained:
        if not self.m1IP3DS_branch and "m1IP3DS":
            warnings.warn( "EMTree: Expected branch m1IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3DS")
        else:
            self.m1IP3DS_branch.SetAddress(<void*>&self.m1IP3DS_value)

        #print "making m1IPDXY"
        self.m1IPDXY_branch = the_tree.GetBranch("m1IPDXY")
        #if not self.m1IPDXY_branch and "m1IPDXY" not in self.complained:
        if not self.m1IPDXY_branch and "m1IPDXY":
            warnings.warn( "EMTree: Expected branch m1IPDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IPDXY")
        else:
            self.m1IPDXY_branch.SetAddress(<void*>&self.m1IPDXY_value)

        #print "making m1IsGlobal"
        self.m1IsGlobal_branch = the_tree.GetBranch("m1IsGlobal")
        #if not self.m1IsGlobal_branch and "m1IsGlobal" not in self.complained:
        if not self.m1IsGlobal_branch and "m1IsGlobal":
            warnings.warn( "EMTree: Expected branch m1IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsGlobal")
        else:
            self.m1IsGlobal_branch.SetAddress(<void*>&self.m1IsGlobal_value)

        #print "making m1IsPFMuon"
        self.m1IsPFMuon_branch = the_tree.GetBranch("m1IsPFMuon")
        #if not self.m1IsPFMuon_branch and "m1IsPFMuon" not in self.complained:
        if not self.m1IsPFMuon_branch and "m1IsPFMuon":
            warnings.warn( "EMTree: Expected branch m1IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsPFMuon")
        else:
            self.m1IsPFMuon_branch.SetAddress(<void*>&self.m1IsPFMuon_value)

        #print "making m1IsTracker"
        self.m1IsTracker_branch = the_tree.GetBranch("m1IsTracker")
        #if not self.m1IsTracker_branch and "m1IsTracker" not in self.complained:
        if not self.m1IsTracker_branch and "m1IsTracker":
            warnings.warn( "EMTree: Expected branch m1IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsTracker")
        else:
            self.m1IsTracker_branch.SetAddress(<void*>&self.m1IsTracker_value)

        #print "making m1IsoDB03"
        self.m1IsoDB03_branch = the_tree.GetBranch("m1IsoDB03")
        #if not self.m1IsoDB03_branch and "m1IsoDB03" not in self.complained:
        if not self.m1IsoDB03_branch and "m1IsoDB03":
            warnings.warn( "EMTree: Expected branch m1IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoDB03")
        else:
            self.m1IsoDB03_branch.SetAddress(<void*>&self.m1IsoDB03_value)

        #print "making m1IsoDB04"
        self.m1IsoDB04_branch = the_tree.GetBranch("m1IsoDB04")
        #if not self.m1IsoDB04_branch and "m1IsoDB04" not in self.complained:
        if not self.m1IsoDB04_branch and "m1IsoDB04":
            warnings.warn( "EMTree: Expected branch m1IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoDB04")
        else:
            self.m1IsoDB04_branch.SetAddress(<void*>&self.m1IsoDB04_value)

        #print "making m1Mass"
        self.m1Mass_branch = the_tree.GetBranch("m1Mass")
        #if not self.m1Mass_branch and "m1Mass" not in self.complained:
        if not self.m1Mass_branch and "m1Mass":
            warnings.warn( "EMTree: Expected branch m1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mass")
        else:
            self.m1Mass_branch.SetAddress(<void*>&self.m1Mass_value)

        #print "making m1MatchesIsoMu20Filter"
        self.m1MatchesIsoMu20Filter_branch = the_tree.GetBranch("m1MatchesIsoMu20Filter")
        #if not self.m1MatchesIsoMu20Filter_branch and "m1MatchesIsoMu20Filter" not in self.complained:
        if not self.m1MatchesIsoMu20Filter_branch and "m1MatchesIsoMu20Filter":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoMu20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu20Filter")
        else:
            self.m1MatchesIsoMu20Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu20Filter_value)

        #print "making m1MatchesIsoMu20Path"
        self.m1MatchesIsoMu20Path_branch = the_tree.GetBranch("m1MatchesIsoMu20Path")
        #if not self.m1MatchesIsoMu20Path_branch and "m1MatchesIsoMu20Path" not in self.complained:
        if not self.m1MatchesIsoMu20Path_branch and "m1MatchesIsoMu20Path":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoMu20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu20Path")
        else:
            self.m1MatchesIsoMu20Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu20Path_value)

        #print "making m1MatchesIsoMu22Filter"
        self.m1MatchesIsoMu22Filter_branch = the_tree.GetBranch("m1MatchesIsoMu22Filter")
        #if not self.m1MatchesIsoMu22Filter_branch and "m1MatchesIsoMu22Filter" not in self.complained:
        if not self.m1MatchesIsoMu22Filter_branch and "m1MatchesIsoMu22Filter":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu22Filter")
        else:
            self.m1MatchesIsoMu22Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu22Filter_value)

        #print "making m1MatchesIsoMu22Path"
        self.m1MatchesIsoMu22Path_branch = the_tree.GetBranch("m1MatchesIsoMu22Path")
        #if not self.m1MatchesIsoMu22Path_branch and "m1MatchesIsoMu22Path" not in self.complained:
        if not self.m1MatchesIsoMu22Path_branch and "m1MatchesIsoMu22Path":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu22Path")
        else:
            self.m1MatchesIsoMu22Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu22Path_value)

        #print "making m1MatchesIsoMu22eta2p1Filter"
        self.m1MatchesIsoMu22eta2p1Filter_branch = the_tree.GetBranch("m1MatchesIsoMu22eta2p1Filter")
        #if not self.m1MatchesIsoMu22eta2p1Filter_branch and "m1MatchesIsoMu22eta2p1Filter" not in self.complained:
        if not self.m1MatchesIsoMu22eta2p1Filter_branch and "m1MatchesIsoMu22eta2p1Filter":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu22eta2p1Filter")
        else:
            self.m1MatchesIsoMu22eta2p1Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu22eta2p1Filter_value)

        #print "making m1MatchesIsoMu22eta2p1Path"
        self.m1MatchesIsoMu22eta2p1Path_branch = the_tree.GetBranch("m1MatchesIsoMu22eta2p1Path")
        #if not self.m1MatchesIsoMu22eta2p1Path_branch and "m1MatchesIsoMu22eta2p1Path" not in self.complained:
        if not self.m1MatchesIsoMu22eta2p1Path_branch and "m1MatchesIsoMu22eta2p1Path":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu22eta2p1Path")
        else:
            self.m1MatchesIsoMu22eta2p1Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu22eta2p1Path_value)

        #print "making m1MatchesIsoMu24Filter"
        self.m1MatchesIsoMu24Filter_branch = the_tree.GetBranch("m1MatchesIsoMu24Filter")
        #if not self.m1MatchesIsoMu24Filter_branch and "m1MatchesIsoMu24Filter" not in self.complained:
        if not self.m1MatchesIsoMu24Filter_branch and "m1MatchesIsoMu24Filter":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24Filter")
        else:
            self.m1MatchesIsoMu24Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu24Filter_value)

        #print "making m1MatchesIsoMu24Path"
        self.m1MatchesIsoMu24Path_branch = the_tree.GetBranch("m1MatchesIsoMu24Path")
        #if not self.m1MatchesIsoMu24Path_branch and "m1MatchesIsoMu24Path" not in self.complained:
        if not self.m1MatchesIsoMu24Path_branch and "m1MatchesIsoMu24Path":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24Path")
        else:
            self.m1MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu24Path_value)

        #print "making m1MatchesIsoMu27Filter"
        self.m1MatchesIsoMu27Filter_branch = the_tree.GetBranch("m1MatchesIsoMu27Filter")
        #if not self.m1MatchesIsoMu27Filter_branch and "m1MatchesIsoMu27Filter" not in self.complained:
        if not self.m1MatchesIsoMu27Filter_branch and "m1MatchesIsoMu27Filter":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoMu27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu27Filter")
        else:
            self.m1MatchesIsoMu27Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu27Filter_value)

        #print "making m1MatchesIsoMu27Path"
        self.m1MatchesIsoMu27Path_branch = the_tree.GetBranch("m1MatchesIsoMu27Path")
        #if not self.m1MatchesIsoMu27Path_branch and "m1MatchesIsoMu27Path" not in self.complained:
        if not self.m1MatchesIsoMu27Path_branch and "m1MatchesIsoMu27Path":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoMu27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu27Path")
        else:
            self.m1MatchesIsoMu27Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu27Path_value)

        #print "making m1MatchesIsoTkMu22Filter"
        self.m1MatchesIsoTkMu22Filter_branch = the_tree.GetBranch("m1MatchesIsoTkMu22Filter")
        #if not self.m1MatchesIsoTkMu22Filter_branch and "m1MatchesIsoTkMu22Filter" not in self.complained:
        if not self.m1MatchesIsoTkMu22Filter_branch and "m1MatchesIsoTkMu22Filter":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoTkMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu22Filter")
        else:
            self.m1MatchesIsoTkMu22Filter_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu22Filter_value)

        #print "making m1MatchesIsoTkMu22Path"
        self.m1MatchesIsoTkMu22Path_branch = the_tree.GetBranch("m1MatchesIsoTkMu22Path")
        #if not self.m1MatchesIsoTkMu22Path_branch and "m1MatchesIsoTkMu22Path" not in self.complained:
        if not self.m1MatchesIsoTkMu22Path_branch and "m1MatchesIsoTkMu22Path":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoTkMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu22Path")
        else:
            self.m1MatchesIsoTkMu22Path_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu22Path_value)

        #print "making m1MatchesIsoTkMu22eta2p1Filter"
        self.m1MatchesIsoTkMu22eta2p1Filter_branch = the_tree.GetBranch("m1MatchesIsoTkMu22eta2p1Filter")
        #if not self.m1MatchesIsoTkMu22eta2p1Filter_branch and "m1MatchesIsoTkMu22eta2p1Filter" not in self.complained:
        if not self.m1MatchesIsoTkMu22eta2p1Filter_branch and "m1MatchesIsoTkMu22eta2p1Filter":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoTkMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu22eta2p1Filter")
        else:
            self.m1MatchesIsoTkMu22eta2p1Filter_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu22eta2p1Filter_value)

        #print "making m1MatchesIsoTkMu22eta2p1Path"
        self.m1MatchesIsoTkMu22eta2p1Path_branch = the_tree.GetBranch("m1MatchesIsoTkMu22eta2p1Path")
        #if not self.m1MatchesIsoTkMu22eta2p1Path_branch and "m1MatchesIsoTkMu22eta2p1Path" not in self.complained:
        if not self.m1MatchesIsoTkMu22eta2p1Path_branch and "m1MatchesIsoTkMu22eta2p1Path":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoTkMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu22eta2p1Path")
        else:
            self.m1MatchesIsoTkMu22eta2p1Path_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu22eta2p1Path_value)

        #print "making m1MatchesIsoTkMu24Filter"
        self.m1MatchesIsoTkMu24Filter_branch = the_tree.GetBranch("m1MatchesIsoTkMu24Filter")
        #if not self.m1MatchesIsoTkMu24Filter_branch and "m1MatchesIsoTkMu24Filter" not in self.complained:
        if not self.m1MatchesIsoTkMu24Filter_branch and "m1MatchesIsoTkMu24Filter":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoTkMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu24Filter")
        else:
            self.m1MatchesIsoTkMu24Filter_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu24Filter_value)

        #print "making m1MatchesIsoTkMu24Path"
        self.m1MatchesIsoTkMu24Path_branch = the_tree.GetBranch("m1MatchesIsoTkMu24Path")
        #if not self.m1MatchesIsoTkMu24Path_branch and "m1MatchesIsoTkMu24Path" not in self.complained:
        if not self.m1MatchesIsoTkMu24Path_branch and "m1MatchesIsoTkMu24Path":
            warnings.warn( "EMTree: Expected branch m1MatchesIsoTkMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu24Path")
        else:
            self.m1MatchesIsoTkMu24Path_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu24Path_value)

        #print "making m1MatchesMu23e12DZFilter"
        self.m1MatchesMu23e12DZFilter_branch = the_tree.GetBranch("m1MatchesMu23e12DZFilter")
        #if not self.m1MatchesMu23e12DZFilter_branch and "m1MatchesMu23e12DZFilter" not in self.complained:
        if not self.m1MatchesMu23e12DZFilter_branch and "m1MatchesMu23e12DZFilter":
            warnings.warn( "EMTree: Expected branch m1MatchesMu23e12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu23e12DZFilter")
        else:
            self.m1MatchesMu23e12DZFilter_branch.SetAddress(<void*>&self.m1MatchesMu23e12DZFilter_value)

        #print "making m1MatchesMu23e12DZPath"
        self.m1MatchesMu23e12DZPath_branch = the_tree.GetBranch("m1MatchesMu23e12DZPath")
        #if not self.m1MatchesMu23e12DZPath_branch and "m1MatchesMu23e12DZPath" not in self.complained:
        if not self.m1MatchesMu23e12DZPath_branch and "m1MatchesMu23e12DZPath":
            warnings.warn( "EMTree: Expected branch m1MatchesMu23e12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu23e12DZPath")
        else:
            self.m1MatchesMu23e12DZPath_branch.SetAddress(<void*>&self.m1MatchesMu23e12DZPath_value)

        #print "making m1MatchesMu23e12Filter"
        self.m1MatchesMu23e12Filter_branch = the_tree.GetBranch("m1MatchesMu23e12Filter")
        #if not self.m1MatchesMu23e12Filter_branch and "m1MatchesMu23e12Filter" not in self.complained:
        if not self.m1MatchesMu23e12Filter_branch and "m1MatchesMu23e12Filter":
            warnings.warn( "EMTree: Expected branch m1MatchesMu23e12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu23e12Filter")
        else:
            self.m1MatchesMu23e12Filter_branch.SetAddress(<void*>&self.m1MatchesMu23e12Filter_value)

        #print "making m1MatchesMu23e12Path"
        self.m1MatchesMu23e12Path_branch = the_tree.GetBranch("m1MatchesMu23e12Path")
        #if not self.m1MatchesMu23e12Path_branch and "m1MatchesMu23e12Path" not in self.complained:
        if not self.m1MatchesMu23e12Path_branch and "m1MatchesMu23e12Path":
            warnings.warn( "EMTree: Expected branch m1MatchesMu23e12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu23e12Path")
        else:
            self.m1MatchesMu23e12Path_branch.SetAddress(<void*>&self.m1MatchesMu23e12Path_value)

        #print "making m1MatchesMu8e23DZFilter"
        self.m1MatchesMu8e23DZFilter_branch = the_tree.GetBranch("m1MatchesMu8e23DZFilter")
        #if not self.m1MatchesMu8e23DZFilter_branch and "m1MatchesMu8e23DZFilter" not in self.complained:
        if not self.m1MatchesMu8e23DZFilter_branch and "m1MatchesMu8e23DZFilter":
            warnings.warn( "EMTree: Expected branch m1MatchesMu8e23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8e23DZFilter")
        else:
            self.m1MatchesMu8e23DZFilter_branch.SetAddress(<void*>&self.m1MatchesMu8e23DZFilter_value)

        #print "making m1MatchesMu8e23DZPath"
        self.m1MatchesMu8e23DZPath_branch = the_tree.GetBranch("m1MatchesMu8e23DZPath")
        #if not self.m1MatchesMu8e23DZPath_branch and "m1MatchesMu8e23DZPath" not in self.complained:
        if not self.m1MatchesMu8e23DZPath_branch and "m1MatchesMu8e23DZPath":
            warnings.warn( "EMTree: Expected branch m1MatchesMu8e23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8e23DZPath")
        else:
            self.m1MatchesMu8e23DZPath_branch.SetAddress(<void*>&self.m1MatchesMu8e23DZPath_value)

        #print "making m1MatchesMu8e23Filter"
        self.m1MatchesMu8e23Filter_branch = the_tree.GetBranch("m1MatchesMu8e23Filter")
        #if not self.m1MatchesMu8e23Filter_branch and "m1MatchesMu8e23Filter" not in self.complained:
        if not self.m1MatchesMu8e23Filter_branch and "m1MatchesMu8e23Filter":
            warnings.warn( "EMTree: Expected branch m1MatchesMu8e23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8e23Filter")
        else:
            self.m1MatchesMu8e23Filter_branch.SetAddress(<void*>&self.m1MatchesMu8e23Filter_value)

        #print "making m1MatchesMu8e23Path"
        self.m1MatchesMu8e23Path_branch = the_tree.GetBranch("m1MatchesMu8e23Path")
        #if not self.m1MatchesMu8e23Path_branch and "m1MatchesMu8e23Path" not in self.complained:
        if not self.m1MatchesMu8e23Path_branch and "m1MatchesMu8e23Path":
            warnings.warn( "EMTree: Expected branch m1MatchesMu8e23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8e23Path")
        else:
            self.m1MatchesMu8e23Path_branch.SetAddress(<void*>&self.m1MatchesMu8e23Path_value)

        #print "making m1MvaLoose"
        self.m1MvaLoose_branch = the_tree.GetBranch("m1MvaLoose")
        #if not self.m1MvaLoose_branch and "m1MvaLoose" not in self.complained:
        if not self.m1MvaLoose_branch and "m1MvaLoose":
            warnings.warn( "EMTree: Expected branch m1MvaLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MvaLoose")
        else:
            self.m1MvaLoose_branch.SetAddress(<void*>&self.m1MvaLoose_value)

        #print "making m1MvaMedium"
        self.m1MvaMedium_branch = the_tree.GetBranch("m1MvaMedium")
        #if not self.m1MvaMedium_branch and "m1MvaMedium" not in self.complained:
        if not self.m1MvaMedium_branch and "m1MvaMedium":
            warnings.warn( "EMTree: Expected branch m1MvaMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MvaMedium")
        else:
            self.m1MvaMedium_branch.SetAddress(<void*>&self.m1MvaMedium_value)

        #print "making m1MvaTight"
        self.m1MvaTight_branch = the_tree.GetBranch("m1MvaTight")
        #if not self.m1MvaTight_branch and "m1MvaTight" not in self.complained:
        if not self.m1MvaTight_branch and "m1MvaTight":
            warnings.warn( "EMTree: Expected branch m1MvaTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MvaTight")
        else:
            self.m1MvaTight_branch.SetAddress(<void*>&self.m1MvaTight_value)

        #print "making m1PFChargedHadronIsoR04"
        self.m1PFChargedHadronIsoR04_branch = the_tree.GetBranch("m1PFChargedHadronIsoR04")
        #if not self.m1PFChargedHadronIsoR04_branch and "m1PFChargedHadronIsoR04" not in self.complained:
        if not self.m1PFChargedHadronIsoR04_branch and "m1PFChargedHadronIsoR04":
            warnings.warn( "EMTree: Expected branch m1PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedHadronIsoR04")
        else:
            self.m1PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m1PFChargedHadronIsoR04_value)

        #print "making m1PFChargedIso"
        self.m1PFChargedIso_branch = the_tree.GetBranch("m1PFChargedIso")
        #if not self.m1PFChargedIso_branch and "m1PFChargedIso" not in self.complained:
        if not self.m1PFChargedIso_branch and "m1PFChargedIso":
            warnings.warn( "EMTree: Expected branch m1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedIso")
        else:
            self.m1PFChargedIso_branch.SetAddress(<void*>&self.m1PFChargedIso_value)

        #print "making m1PFIDLoose"
        self.m1PFIDLoose_branch = the_tree.GetBranch("m1PFIDLoose")
        #if not self.m1PFIDLoose_branch and "m1PFIDLoose" not in self.complained:
        if not self.m1PFIDLoose_branch and "m1PFIDLoose":
            warnings.warn( "EMTree: Expected branch m1PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDLoose")
        else:
            self.m1PFIDLoose_branch.SetAddress(<void*>&self.m1PFIDLoose_value)

        #print "making m1PFIDMedium"
        self.m1PFIDMedium_branch = the_tree.GetBranch("m1PFIDMedium")
        #if not self.m1PFIDMedium_branch and "m1PFIDMedium" not in self.complained:
        if not self.m1PFIDMedium_branch and "m1PFIDMedium":
            warnings.warn( "EMTree: Expected branch m1PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDMedium")
        else:
            self.m1PFIDMedium_branch.SetAddress(<void*>&self.m1PFIDMedium_value)

        #print "making m1PFIDTight"
        self.m1PFIDTight_branch = the_tree.GetBranch("m1PFIDTight")
        #if not self.m1PFIDTight_branch and "m1PFIDTight" not in self.complained:
        if not self.m1PFIDTight_branch and "m1PFIDTight":
            warnings.warn( "EMTree: Expected branch m1PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDTight")
        else:
            self.m1PFIDTight_branch.SetAddress(<void*>&self.m1PFIDTight_value)

        #print "making m1PFIsoLoose"
        self.m1PFIsoLoose_branch = the_tree.GetBranch("m1PFIsoLoose")
        #if not self.m1PFIsoLoose_branch and "m1PFIsoLoose" not in self.complained:
        if not self.m1PFIsoLoose_branch and "m1PFIsoLoose":
            warnings.warn( "EMTree: Expected branch m1PFIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoLoose")
        else:
            self.m1PFIsoLoose_branch.SetAddress(<void*>&self.m1PFIsoLoose_value)

        #print "making m1PFIsoMedium"
        self.m1PFIsoMedium_branch = the_tree.GetBranch("m1PFIsoMedium")
        #if not self.m1PFIsoMedium_branch and "m1PFIsoMedium" not in self.complained:
        if not self.m1PFIsoMedium_branch and "m1PFIsoMedium":
            warnings.warn( "EMTree: Expected branch m1PFIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoMedium")
        else:
            self.m1PFIsoMedium_branch.SetAddress(<void*>&self.m1PFIsoMedium_value)

        #print "making m1PFIsoTight"
        self.m1PFIsoTight_branch = the_tree.GetBranch("m1PFIsoTight")
        #if not self.m1PFIsoTight_branch and "m1PFIsoTight" not in self.complained:
        if not self.m1PFIsoTight_branch and "m1PFIsoTight":
            warnings.warn( "EMTree: Expected branch m1PFIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoTight")
        else:
            self.m1PFIsoTight_branch.SetAddress(<void*>&self.m1PFIsoTight_value)

        #print "making m1PFIsoVeryLoose"
        self.m1PFIsoVeryLoose_branch = the_tree.GetBranch("m1PFIsoVeryLoose")
        #if not self.m1PFIsoVeryLoose_branch and "m1PFIsoVeryLoose" not in self.complained:
        if not self.m1PFIsoVeryLoose_branch and "m1PFIsoVeryLoose":
            warnings.warn( "EMTree: Expected branch m1PFIsoVeryLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoVeryLoose")
        else:
            self.m1PFIsoVeryLoose_branch.SetAddress(<void*>&self.m1PFIsoVeryLoose_value)

        #print "making m1PFIsoVeryTight"
        self.m1PFIsoVeryTight_branch = the_tree.GetBranch("m1PFIsoVeryTight")
        #if not self.m1PFIsoVeryTight_branch and "m1PFIsoVeryTight" not in self.complained:
        if not self.m1PFIsoVeryTight_branch and "m1PFIsoVeryTight":
            warnings.warn( "EMTree: Expected branch m1PFIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoVeryTight")
        else:
            self.m1PFIsoVeryTight_branch.SetAddress(<void*>&self.m1PFIsoVeryTight_value)

        #print "making m1PFNeutralHadronIsoR04"
        self.m1PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m1PFNeutralHadronIsoR04")
        #if not self.m1PFNeutralHadronIsoR04_branch and "m1PFNeutralHadronIsoR04" not in self.complained:
        if not self.m1PFNeutralHadronIsoR04_branch and "m1PFNeutralHadronIsoR04":
            warnings.warn( "EMTree: Expected branch m1PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralHadronIsoR04")
        else:
            self.m1PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m1PFNeutralHadronIsoR04_value)

        #print "making m1PFNeutralIso"
        self.m1PFNeutralIso_branch = the_tree.GetBranch("m1PFNeutralIso")
        #if not self.m1PFNeutralIso_branch and "m1PFNeutralIso" not in self.complained:
        if not self.m1PFNeutralIso_branch and "m1PFNeutralIso":
            warnings.warn( "EMTree: Expected branch m1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralIso")
        else:
            self.m1PFNeutralIso_branch.SetAddress(<void*>&self.m1PFNeutralIso_value)

        #print "making m1PFPUChargedIso"
        self.m1PFPUChargedIso_branch = the_tree.GetBranch("m1PFPUChargedIso")
        #if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso" not in self.complained:
        if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso":
            warnings.warn( "EMTree: Expected branch m1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPUChargedIso")
        else:
            self.m1PFPUChargedIso_branch.SetAddress(<void*>&self.m1PFPUChargedIso_value)

        #print "making m1PFPhotonIso"
        self.m1PFPhotonIso_branch = the_tree.GetBranch("m1PFPhotonIso")
        #if not self.m1PFPhotonIso_branch and "m1PFPhotonIso" not in self.complained:
        if not self.m1PFPhotonIso_branch and "m1PFPhotonIso":
            warnings.warn( "EMTree: Expected branch m1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIso")
        else:
            self.m1PFPhotonIso_branch.SetAddress(<void*>&self.m1PFPhotonIso_value)

        #print "making m1PFPhotonIsoR04"
        self.m1PFPhotonIsoR04_branch = the_tree.GetBranch("m1PFPhotonIsoR04")
        #if not self.m1PFPhotonIsoR04_branch and "m1PFPhotonIsoR04" not in self.complained:
        if not self.m1PFPhotonIsoR04_branch and "m1PFPhotonIsoR04":
            warnings.warn( "EMTree: Expected branch m1PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIsoR04")
        else:
            self.m1PFPhotonIsoR04_branch.SetAddress(<void*>&self.m1PFPhotonIsoR04_value)

        #print "making m1PFPileupIsoR04"
        self.m1PFPileupIsoR04_branch = the_tree.GetBranch("m1PFPileupIsoR04")
        #if not self.m1PFPileupIsoR04_branch and "m1PFPileupIsoR04" not in self.complained:
        if not self.m1PFPileupIsoR04_branch and "m1PFPileupIsoR04":
            warnings.warn( "EMTree: Expected branch m1PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPileupIsoR04")
        else:
            self.m1PFPileupIsoR04_branch.SetAddress(<void*>&self.m1PFPileupIsoR04_value)

        #print "making m1PVDXY"
        self.m1PVDXY_branch = the_tree.GetBranch("m1PVDXY")
        #if not self.m1PVDXY_branch and "m1PVDXY" not in self.complained:
        if not self.m1PVDXY_branch and "m1PVDXY":
            warnings.warn( "EMTree: Expected branch m1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDXY")
        else:
            self.m1PVDXY_branch.SetAddress(<void*>&self.m1PVDXY_value)

        #print "making m1PVDZ"
        self.m1PVDZ_branch = the_tree.GetBranch("m1PVDZ")
        #if not self.m1PVDZ_branch and "m1PVDZ" not in self.complained:
        if not self.m1PVDZ_branch and "m1PVDZ":
            warnings.warn( "EMTree: Expected branch m1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDZ")
        else:
            self.m1PVDZ_branch.SetAddress(<void*>&self.m1PVDZ_value)

        #print "making m1Phi"
        self.m1Phi_branch = the_tree.GetBranch("m1Phi")
        #if not self.m1Phi_branch and "m1Phi" not in self.complained:
        if not self.m1Phi_branch and "m1Phi":
            warnings.warn( "EMTree: Expected branch m1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi")
        else:
            self.m1Phi_branch.SetAddress(<void*>&self.m1Phi_value)

        #print "making m1Pt"
        self.m1Pt_branch = the_tree.GetBranch("m1Pt")
        #if not self.m1Pt_branch and "m1Pt" not in self.complained:
        if not self.m1Pt_branch and "m1Pt":
            warnings.warn( "EMTree: Expected branch m1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt")
        else:
            self.m1Pt_branch.SetAddress(<void*>&self.m1Pt_value)

        #print "making m1RelPFIsoDBDefault"
        self.m1RelPFIsoDBDefault_branch = the_tree.GetBranch("m1RelPFIsoDBDefault")
        #if not self.m1RelPFIsoDBDefault_branch and "m1RelPFIsoDBDefault" not in self.complained:
        if not self.m1RelPFIsoDBDefault_branch and "m1RelPFIsoDBDefault":
            warnings.warn( "EMTree: Expected branch m1RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDBDefault")
        else:
            self.m1RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m1RelPFIsoDBDefault_value)

        #print "making m1RelPFIsoDBDefaultR04"
        self.m1RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m1RelPFIsoDBDefaultR04")
        #if not self.m1RelPFIsoDBDefaultR04_branch and "m1RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m1RelPFIsoDBDefaultR04_branch and "m1RelPFIsoDBDefaultR04":
            warnings.warn( "EMTree: Expected branch m1RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDBDefaultR04")
        else:
            self.m1RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m1RelPFIsoDBDefaultR04_value)

        #print "making m1SegmentCompatibility"
        self.m1SegmentCompatibility_branch = the_tree.GetBranch("m1SegmentCompatibility")
        #if not self.m1SegmentCompatibility_branch and "m1SegmentCompatibility" not in self.complained:
        if not self.m1SegmentCompatibility_branch and "m1SegmentCompatibility":
            warnings.warn( "EMTree: Expected branch m1SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SegmentCompatibility")
        else:
            self.m1SegmentCompatibility_branch.SetAddress(<void*>&self.m1SegmentCompatibility_value)

        #print "making m1TrkIsoDR03"
        self.m1TrkIsoDR03_branch = the_tree.GetBranch("m1TrkIsoDR03")
        #if not self.m1TrkIsoDR03_branch and "m1TrkIsoDR03" not in self.complained:
        if not self.m1TrkIsoDR03_branch and "m1TrkIsoDR03":
            warnings.warn( "EMTree: Expected branch m1TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TrkIsoDR03")
        else:
            self.m1TrkIsoDR03_branch.SetAddress(<void*>&self.m1TrkIsoDR03_value)

        #print "making m1TypeCode"
        self.m1TypeCode_branch = the_tree.GetBranch("m1TypeCode")
        #if not self.m1TypeCode_branch and "m1TypeCode" not in self.complained:
        if not self.m1TypeCode_branch and "m1TypeCode":
            warnings.warn( "EMTree: Expected branch m1TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TypeCode")
        else:
            self.m1TypeCode_branch.SetAddress(<void*>&self.m1TypeCode_value)

        #print "making m1ZTTGenMatching"
        self.m1ZTTGenMatching_branch = the_tree.GetBranch("m1ZTTGenMatching")
        #if not self.m1ZTTGenMatching_branch and "m1ZTTGenMatching" not in self.complained:
        if not self.m1ZTTGenMatching_branch and "m1ZTTGenMatching":
            warnings.warn( "EMTree: Expected branch m1ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ZTTGenMatching")
        else:
            self.m1ZTTGenMatching_branch.SetAddress(<void*>&self.m1ZTTGenMatching_value)

        #print "making m1_m2_DR"
        self.m1_m2_DR_branch = the_tree.GetBranch("m1_m2_DR")
        #if not self.m1_m2_DR_branch and "m1_m2_DR" not in self.complained:
        if not self.m1_m2_DR_branch and "m1_m2_DR":
            warnings.warn( "EMTree: Expected branch m1_m2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DR")
        else:
            self.m1_m2_DR_branch.SetAddress(<void*>&self.m1_m2_DR_value)

        #print "making m1_m2_Mass"
        self.m1_m2_Mass_branch = the_tree.GetBranch("m1_m2_Mass")
        #if not self.m1_m2_Mass_branch and "m1_m2_Mass" not in self.complained:
        if not self.m1_m2_Mass_branch and "m1_m2_Mass":
            warnings.warn( "EMTree: Expected branch m1_m2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass")
        else:
            self.m1_m2_Mass_branch.SetAddress(<void*>&self.m1_m2_Mass_value)

        #print "making m1_m2_PZeta"
        self.m1_m2_PZeta_branch = the_tree.GetBranch("m1_m2_PZeta")
        #if not self.m1_m2_PZeta_branch and "m1_m2_PZeta" not in self.complained:
        if not self.m1_m2_PZeta_branch and "m1_m2_PZeta":
            warnings.warn( "EMTree: Expected branch m1_m2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZeta")
        else:
            self.m1_m2_PZeta_branch.SetAddress(<void*>&self.m1_m2_PZeta_value)

        #print "making m1_m2_PZetaVis"
        self.m1_m2_PZetaVis_branch = the_tree.GetBranch("m1_m2_PZetaVis")
        #if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis" not in self.complained:
        if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis":
            warnings.warn( "EMTree: Expected branch m1_m2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZetaVis")
        else:
            self.m1_m2_PZetaVis_branch.SetAddress(<void*>&self.m1_m2_PZetaVis_value)

        #print "making m2BestTrackType"
        self.m2BestTrackType_branch = the_tree.GetBranch("m2BestTrackType")
        #if not self.m2BestTrackType_branch and "m2BestTrackType" not in self.complained:
        if not self.m2BestTrackType_branch and "m2BestTrackType":
            warnings.warn( "EMTree: Expected branch m2BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2BestTrackType")
        else:
            self.m2BestTrackType_branch.SetAddress(<void*>&self.m2BestTrackType_value)

        #print "making m2Charge"
        self.m2Charge_branch = the_tree.GetBranch("m2Charge")
        #if not self.m2Charge_branch and "m2Charge" not in self.complained:
        if not self.m2Charge_branch and "m2Charge":
            warnings.warn( "EMTree: Expected branch m2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Charge")
        else:
            self.m2Charge_branch.SetAddress(<void*>&self.m2Charge_value)

        #print "making m2EcalIsoDR03"
        self.m2EcalIsoDR03_branch = the_tree.GetBranch("m2EcalIsoDR03")
        #if not self.m2EcalIsoDR03_branch and "m2EcalIsoDR03" not in self.complained:
        if not self.m2EcalIsoDR03_branch and "m2EcalIsoDR03":
            warnings.warn( "EMTree: Expected branch m2EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EcalIsoDR03")
        else:
            self.m2EcalIsoDR03_branch.SetAddress(<void*>&self.m2EcalIsoDR03_value)

        #print "making m2Eta"
        self.m2Eta_branch = the_tree.GetBranch("m2Eta")
        #if not self.m2Eta_branch and "m2Eta" not in self.complained:
        if not self.m2Eta_branch and "m2Eta":
            warnings.warn( "EMTree: Expected branch m2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta")
        else:
            self.m2Eta_branch.SetAddress(<void*>&self.m2Eta_value)

        #print "making m2GenCharge"
        self.m2GenCharge_branch = the_tree.GetBranch("m2GenCharge")
        #if not self.m2GenCharge_branch and "m2GenCharge" not in self.complained:
        if not self.m2GenCharge_branch and "m2GenCharge":
            warnings.warn( "EMTree: Expected branch m2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenCharge")
        else:
            self.m2GenCharge_branch.SetAddress(<void*>&self.m2GenCharge_value)

        #print "making m2GenEnergy"
        self.m2GenEnergy_branch = the_tree.GetBranch("m2GenEnergy")
        #if not self.m2GenEnergy_branch and "m2GenEnergy" not in self.complained:
        if not self.m2GenEnergy_branch and "m2GenEnergy":
            warnings.warn( "EMTree: Expected branch m2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEnergy")
        else:
            self.m2GenEnergy_branch.SetAddress(<void*>&self.m2GenEnergy_value)

        #print "making m2GenEta"
        self.m2GenEta_branch = the_tree.GetBranch("m2GenEta")
        #if not self.m2GenEta_branch and "m2GenEta" not in self.complained:
        if not self.m2GenEta_branch and "m2GenEta":
            warnings.warn( "EMTree: Expected branch m2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEta")
        else:
            self.m2GenEta_branch.SetAddress(<void*>&self.m2GenEta_value)

        #print "making m2GenMotherPdgId"
        self.m2GenMotherPdgId_branch = the_tree.GetBranch("m2GenMotherPdgId")
        #if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId" not in self.complained:
        if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId":
            warnings.warn( "EMTree: Expected branch m2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenMotherPdgId")
        else:
            self.m2GenMotherPdgId_branch.SetAddress(<void*>&self.m2GenMotherPdgId_value)

        #print "making m2GenParticle"
        self.m2GenParticle_branch = the_tree.GetBranch("m2GenParticle")
        #if not self.m2GenParticle_branch and "m2GenParticle" not in self.complained:
        if not self.m2GenParticle_branch and "m2GenParticle":
            warnings.warn( "EMTree: Expected branch m2GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenParticle")
        else:
            self.m2GenParticle_branch.SetAddress(<void*>&self.m2GenParticle_value)

        #print "making m2GenPdgId"
        self.m2GenPdgId_branch = the_tree.GetBranch("m2GenPdgId")
        #if not self.m2GenPdgId_branch and "m2GenPdgId" not in self.complained:
        if not self.m2GenPdgId_branch and "m2GenPdgId":
            warnings.warn( "EMTree: Expected branch m2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPdgId")
        else:
            self.m2GenPdgId_branch.SetAddress(<void*>&self.m2GenPdgId_value)

        #print "making m2GenPhi"
        self.m2GenPhi_branch = the_tree.GetBranch("m2GenPhi")
        #if not self.m2GenPhi_branch and "m2GenPhi" not in self.complained:
        if not self.m2GenPhi_branch and "m2GenPhi":
            warnings.warn( "EMTree: Expected branch m2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPhi")
        else:
            self.m2GenPhi_branch.SetAddress(<void*>&self.m2GenPhi_value)

        #print "making m2GenPt"
        self.m2GenPt_branch = the_tree.GetBranch("m2GenPt")
        #if not self.m2GenPt_branch and "m2GenPt" not in self.complained:
        if not self.m2GenPt_branch and "m2GenPt":
            warnings.warn( "EMTree: Expected branch m2GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPt")
        else:
            self.m2GenPt_branch.SetAddress(<void*>&self.m2GenPt_value)

        #print "making m2GenVZ"
        self.m2GenVZ_branch = the_tree.GetBranch("m2GenVZ")
        #if not self.m2GenVZ_branch and "m2GenVZ" not in self.complained:
        if not self.m2GenVZ_branch and "m2GenVZ":
            warnings.warn( "EMTree: Expected branch m2GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenVZ")
        else:
            self.m2GenVZ_branch.SetAddress(<void*>&self.m2GenVZ_value)

        #print "making m2HcalIsoDR03"
        self.m2HcalIsoDR03_branch = the_tree.GetBranch("m2HcalIsoDR03")
        #if not self.m2HcalIsoDR03_branch and "m2HcalIsoDR03" not in self.complained:
        if not self.m2HcalIsoDR03_branch and "m2HcalIsoDR03":
            warnings.warn( "EMTree: Expected branch m2HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2HcalIsoDR03")
        else:
            self.m2HcalIsoDR03_branch.SetAddress(<void*>&self.m2HcalIsoDR03_value)

        #print "making m2IP3D"
        self.m2IP3D_branch = the_tree.GetBranch("m2IP3D")
        #if not self.m2IP3D_branch and "m2IP3D" not in self.complained:
        if not self.m2IP3D_branch and "m2IP3D":
            warnings.warn( "EMTree: Expected branch m2IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3D")
        else:
            self.m2IP3D_branch.SetAddress(<void*>&self.m2IP3D_value)

        #print "making m2IP3DS"
        self.m2IP3DS_branch = the_tree.GetBranch("m2IP3DS")
        #if not self.m2IP3DS_branch and "m2IP3DS" not in self.complained:
        if not self.m2IP3DS_branch and "m2IP3DS":
            warnings.warn( "EMTree: Expected branch m2IP3DS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3DS")
        else:
            self.m2IP3DS_branch.SetAddress(<void*>&self.m2IP3DS_value)

        #print "making m2IPDXY"
        self.m2IPDXY_branch = the_tree.GetBranch("m2IPDXY")
        #if not self.m2IPDXY_branch and "m2IPDXY" not in self.complained:
        if not self.m2IPDXY_branch and "m2IPDXY":
            warnings.warn( "EMTree: Expected branch m2IPDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IPDXY")
        else:
            self.m2IPDXY_branch.SetAddress(<void*>&self.m2IPDXY_value)

        #print "making m2IsGlobal"
        self.m2IsGlobal_branch = the_tree.GetBranch("m2IsGlobal")
        #if not self.m2IsGlobal_branch and "m2IsGlobal" not in self.complained:
        if not self.m2IsGlobal_branch and "m2IsGlobal":
            warnings.warn( "EMTree: Expected branch m2IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsGlobal")
        else:
            self.m2IsGlobal_branch.SetAddress(<void*>&self.m2IsGlobal_value)

        #print "making m2IsPFMuon"
        self.m2IsPFMuon_branch = the_tree.GetBranch("m2IsPFMuon")
        #if not self.m2IsPFMuon_branch and "m2IsPFMuon" not in self.complained:
        if not self.m2IsPFMuon_branch and "m2IsPFMuon":
            warnings.warn( "EMTree: Expected branch m2IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsPFMuon")
        else:
            self.m2IsPFMuon_branch.SetAddress(<void*>&self.m2IsPFMuon_value)

        #print "making m2IsTracker"
        self.m2IsTracker_branch = the_tree.GetBranch("m2IsTracker")
        #if not self.m2IsTracker_branch and "m2IsTracker" not in self.complained:
        if not self.m2IsTracker_branch and "m2IsTracker":
            warnings.warn( "EMTree: Expected branch m2IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsTracker")
        else:
            self.m2IsTracker_branch.SetAddress(<void*>&self.m2IsTracker_value)

        #print "making m2IsoDB03"
        self.m2IsoDB03_branch = the_tree.GetBranch("m2IsoDB03")
        #if not self.m2IsoDB03_branch and "m2IsoDB03" not in self.complained:
        if not self.m2IsoDB03_branch and "m2IsoDB03":
            warnings.warn( "EMTree: Expected branch m2IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoDB03")
        else:
            self.m2IsoDB03_branch.SetAddress(<void*>&self.m2IsoDB03_value)

        #print "making m2IsoDB04"
        self.m2IsoDB04_branch = the_tree.GetBranch("m2IsoDB04")
        #if not self.m2IsoDB04_branch and "m2IsoDB04" not in self.complained:
        if not self.m2IsoDB04_branch and "m2IsoDB04":
            warnings.warn( "EMTree: Expected branch m2IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoDB04")
        else:
            self.m2IsoDB04_branch.SetAddress(<void*>&self.m2IsoDB04_value)

        #print "making m2Mass"
        self.m2Mass_branch = the_tree.GetBranch("m2Mass")
        #if not self.m2Mass_branch and "m2Mass" not in self.complained:
        if not self.m2Mass_branch and "m2Mass":
            warnings.warn( "EMTree: Expected branch m2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mass")
        else:
            self.m2Mass_branch.SetAddress(<void*>&self.m2Mass_value)

        #print "making m2MatchesIsoMu20Filter"
        self.m2MatchesIsoMu20Filter_branch = the_tree.GetBranch("m2MatchesIsoMu20Filter")
        #if not self.m2MatchesIsoMu20Filter_branch and "m2MatchesIsoMu20Filter" not in self.complained:
        if not self.m2MatchesIsoMu20Filter_branch and "m2MatchesIsoMu20Filter":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoMu20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu20Filter")
        else:
            self.m2MatchesIsoMu20Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu20Filter_value)

        #print "making m2MatchesIsoMu20Path"
        self.m2MatchesIsoMu20Path_branch = the_tree.GetBranch("m2MatchesIsoMu20Path")
        #if not self.m2MatchesIsoMu20Path_branch and "m2MatchesIsoMu20Path" not in self.complained:
        if not self.m2MatchesIsoMu20Path_branch and "m2MatchesIsoMu20Path":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoMu20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu20Path")
        else:
            self.m2MatchesIsoMu20Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu20Path_value)

        #print "making m2MatchesIsoMu22Filter"
        self.m2MatchesIsoMu22Filter_branch = the_tree.GetBranch("m2MatchesIsoMu22Filter")
        #if not self.m2MatchesIsoMu22Filter_branch and "m2MatchesIsoMu22Filter" not in self.complained:
        if not self.m2MatchesIsoMu22Filter_branch and "m2MatchesIsoMu22Filter":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu22Filter")
        else:
            self.m2MatchesIsoMu22Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu22Filter_value)

        #print "making m2MatchesIsoMu22Path"
        self.m2MatchesIsoMu22Path_branch = the_tree.GetBranch("m2MatchesIsoMu22Path")
        #if not self.m2MatchesIsoMu22Path_branch and "m2MatchesIsoMu22Path" not in self.complained:
        if not self.m2MatchesIsoMu22Path_branch and "m2MatchesIsoMu22Path":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu22Path")
        else:
            self.m2MatchesIsoMu22Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu22Path_value)

        #print "making m2MatchesIsoMu22eta2p1Filter"
        self.m2MatchesIsoMu22eta2p1Filter_branch = the_tree.GetBranch("m2MatchesIsoMu22eta2p1Filter")
        #if not self.m2MatchesIsoMu22eta2p1Filter_branch and "m2MatchesIsoMu22eta2p1Filter" not in self.complained:
        if not self.m2MatchesIsoMu22eta2p1Filter_branch and "m2MatchesIsoMu22eta2p1Filter":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu22eta2p1Filter")
        else:
            self.m2MatchesIsoMu22eta2p1Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu22eta2p1Filter_value)

        #print "making m2MatchesIsoMu22eta2p1Path"
        self.m2MatchesIsoMu22eta2p1Path_branch = the_tree.GetBranch("m2MatchesIsoMu22eta2p1Path")
        #if not self.m2MatchesIsoMu22eta2p1Path_branch and "m2MatchesIsoMu22eta2p1Path" not in self.complained:
        if not self.m2MatchesIsoMu22eta2p1Path_branch and "m2MatchesIsoMu22eta2p1Path":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu22eta2p1Path")
        else:
            self.m2MatchesIsoMu22eta2p1Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu22eta2p1Path_value)

        #print "making m2MatchesIsoMu24Filter"
        self.m2MatchesIsoMu24Filter_branch = the_tree.GetBranch("m2MatchesIsoMu24Filter")
        #if not self.m2MatchesIsoMu24Filter_branch and "m2MatchesIsoMu24Filter" not in self.complained:
        if not self.m2MatchesIsoMu24Filter_branch and "m2MatchesIsoMu24Filter":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24Filter")
        else:
            self.m2MatchesIsoMu24Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu24Filter_value)

        #print "making m2MatchesIsoMu24Path"
        self.m2MatchesIsoMu24Path_branch = the_tree.GetBranch("m2MatchesIsoMu24Path")
        #if not self.m2MatchesIsoMu24Path_branch and "m2MatchesIsoMu24Path" not in self.complained:
        if not self.m2MatchesIsoMu24Path_branch and "m2MatchesIsoMu24Path":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24Path")
        else:
            self.m2MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu24Path_value)

        #print "making m2MatchesIsoMu27Filter"
        self.m2MatchesIsoMu27Filter_branch = the_tree.GetBranch("m2MatchesIsoMu27Filter")
        #if not self.m2MatchesIsoMu27Filter_branch and "m2MatchesIsoMu27Filter" not in self.complained:
        if not self.m2MatchesIsoMu27Filter_branch and "m2MatchesIsoMu27Filter":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoMu27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu27Filter")
        else:
            self.m2MatchesIsoMu27Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu27Filter_value)

        #print "making m2MatchesIsoMu27Path"
        self.m2MatchesIsoMu27Path_branch = the_tree.GetBranch("m2MatchesIsoMu27Path")
        #if not self.m2MatchesIsoMu27Path_branch and "m2MatchesIsoMu27Path" not in self.complained:
        if not self.m2MatchesIsoMu27Path_branch and "m2MatchesIsoMu27Path":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoMu27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu27Path")
        else:
            self.m2MatchesIsoMu27Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu27Path_value)

        #print "making m2MatchesIsoTkMu22Filter"
        self.m2MatchesIsoTkMu22Filter_branch = the_tree.GetBranch("m2MatchesIsoTkMu22Filter")
        #if not self.m2MatchesIsoTkMu22Filter_branch and "m2MatchesIsoTkMu22Filter" not in self.complained:
        if not self.m2MatchesIsoTkMu22Filter_branch and "m2MatchesIsoTkMu22Filter":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoTkMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu22Filter")
        else:
            self.m2MatchesIsoTkMu22Filter_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu22Filter_value)

        #print "making m2MatchesIsoTkMu22Path"
        self.m2MatchesIsoTkMu22Path_branch = the_tree.GetBranch("m2MatchesIsoTkMu22Path")
        #if not self.m2MatchesIsoTkMu22Path_branch and "m2MatchesIsoTkMu22Path" not in self.complained:
        if not self.m2MatchesIsoTkMu22Path_branch and "m2MatchesIsoTkMu22Path":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoTkMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu22Path")
        else:
            self.m2MatchesIsoTkMu22Path_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu22Path_value)

        #print "making m2MatchesIsoTkMu22eta2p1Filter"
        self.m2MatchesIsoTkMu22eta2p1Filter_branch = the_tree.GetBranch("m2MatchesIsoTkMu22eta2p1Filter")
        #if not self.m2MatchesIsoTkMu22eta2p1Filter_branch and "m2MatchesIsoTkMu22eta2p1Filter" not in self.complained:
        if not self.m2MatchesIsoTkMu22eta2p1Filter_branch and "m2MatchesIsoTkMu22eta2p1Filter":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoTkMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu22eta2p1Filter")
        else:
            self.m2MatchesIsoTkMu22eta2p1Filter_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu22eta2p1Filter_value)

        #print "making m2MatchesIsoTkMu22eta2p1Path"
        self.m2MatchesIsoTkMu22eta2p1Path_branch = the_tree.GetBranch("m2MatchesIsoTkMu22eta2p1Path")
        #if not self.m2MatchesIsoTkMu22eta2p1Path_branch and "m2MatchesIsoTkMu22eta2p1Path" not in self.complained:
        if not self.m2MatchesIsoTkMu22eta2p1Path_branch and "m2MatchesIsoTkMu22eta2p1Path":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoTkMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu22eta2p1Path")
        else:
            self.m2MatchesIsoTkMu22eta2p1Path_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu22eta2p1Path_value)

        #print "making m2MatchesIsoTkMu24Filter"
        self.m2MatchesIsoTkMu24Filter_branch = the_tree.GetBranch("m2MatchesIsoTkMu24Filter")
        #if not self.m2MatchesIsoTkMu24Filter_branch and "m2MatchesIsoTkMu24Filter" not in self.complained:
        if not self.m2MatchesIsoTkMu24Filter_branch and "m2MatchesIsoTkMu24Filter":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoTkMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu24Filter")
        else:
            self.m2MatchesIsoTkMu24Filter_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu24Filter_value)

        #print "making m2MatchesIsoTkMu24Path"
        self.m2MatchesIsoTkMu24Path_branch = the_tree.GetBranch("m2MatchesIsoTkMu24Path")
        #if not self.m2MatchesIsoTkMu24Path_branch and "m2MatchesIsoTkMu24Path" not in self.complained:
        if not self.m2MatchesIsoTkMu24Path_branch and "m2MatchesIsoTkMu24Path":
            warnings.warn( "EMTree: Expected branch m2MatchesIsoTkMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu24Path")
        else:
            self.m2MatchesIsoTkMu24Path_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu24Path_value)

        #print "making m2MatchesMu23e12DZFilter"
        self.m2MatchesMu23e12DZFilter_branch = the_tree.GetBranch("m2MatchesMu23e12DZFilter")
        #if not self.m2MatchesMu23e12DZFilter_branch and "m2MatchesMu23e12DZFilter" not in self.complained:
        if not self.m2MatchesMu23e12DZFilter_branch and "m2MatchesMu23e12DZFilter":
            warnings.warn( "EMTree: Expected branch m2MatchesMu23e12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu23e12DZFilter")
        else:
            self.m2MatchesMu23e12DZFilter_branch.SetAddress(<void*>&self.m2MatchesMu23e12DZFilter_value)

        #print "making m2MatchesMu23e12DZPath"
        self.m2MatchesMu23e12DZPath_branch = the_tree.GetBranch("m2MatchesMu23e12DZPath")
        #if not self.m2MatchesMu23e12DZPath_branch and "m2MatchesMu23e12DZPath" not in self.complained:
        if not self.m2MatchesMu23e12DZPath_branch and "m2MatchesMu23e12DZPath":
            warnings.warn( "EMTree: Expected branch m2MatchesMu23e12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu23e12DZPath")
        else:
            self.m2MatchesMu23e12DZPath_branch.SetAddress(<void*>&self.m2MatchesMu23e12DZPath_value)

        #print "making m2MatchesMu23e12Filter"
        self.m2MatchesMu23e12Filter_branch = the_tree.GetBranch("m2MatchesMu23e12Filter")
        #if not self.m2MatchesMu23e12Filter_branch and "m2MatchesMu23e12Filter" not in self.complained:
        if not self.m2MatchesMu23e12Filter_branch and "m2MatchesMu23e12Filter":
            warnings.warn( "EMTree: Expected branch m2MatchesMu23e12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu23e12Filter")
        else:
            self.m2MatchesMu23e12Filter_branch.SetAddress(<void*>&self.m2MatchesMu23e12Filter_value)

        #print "making m2MatchesMu23e12Path"
        self.m2MatchesMu23e12Path_branch = the_tree.GetBranch("m2MatchesMu23e12Path")
        #if not self.m2MatchesMu23e12Path_branch and "m2MatchesMu23e12Path" not in self.complained:
        if not self.m2MatchesMu23e12Path_branch and "m2MatchesMu23e12Path":
            warnings.warn( "EMTree: Expected branch m2MatchesMu23e12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu23e12Path")
        else:
            self.m2MatchesMu23e12Path_branch.SetAddress(<void*>&self.m2MatchesMu23e12Path_value)

        #print "making m2MatchesMu8e23DZFilter"
        self.m2MatchesMu8e23DZFilter_branch = the_tree.GetBranch("m2MatchesMu8e23DZFilter")
        #if not self.m2MatchesMu8e23DZFilter_branch and "m2MatchesMu8e23DZFilter" not in self.complained:
        if not self.m2MatchesMu8e23DZFilter_branch and "m2MatchesMu8e23DZFilter":
            warnings.warn( "EMTree: Expected branch m2MatchesMu8e23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8e23DZFilter")
        else:
            self.m2MatchesMu8e23DZFilter_branch.SetAddress(<void*>&self.m2MatchesMu8e23DZFilter_value)

        #print "making m2MatchesMu8e23DZPath"
        self.m2MatchesMu8e23DZPath_branch = the_tree.GetBranch("m2MatchesMu8e23DZPath")
        #if not self.m2MatchesMu8e23DZPath_branch and "m2MatchesMu8e23DZPath" not in self.complained:
        if not self.m2MatchesMu8e23DZPath_branch and "m2MatchesMu8e23DZPath":
            warnings.warn( "EMTree: Expected branch m2MatchesMu8e23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8e23DZPath")
        else:
            self.m2MatchesMu8e23DZPath_branch.SetAddress(<void*>&self.m2MatchesMu8e23DZPath_value)

        #print "making m2MatchesMu8e23Filter"
        self.m2MatchesMu8e23Filter_branch = the_tree.GetBranch("m2MatchesMu8e23Filter")
        #if not self.m2MatchesMu8e23Filter_branch and "m2MatchesMu8e23Filter" not in self.complained:
        if not self.m2MatchesMu8e23Filter_branch and "m2MatchesMu8e23Filter":
            warnings.warn( "EMTree: Expected branch m2MatchesMu8e23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8e23Filter")
        else:
            self.m2MatchesMu8e23Filter_branch.SetAddress(<void*>&self.m2MatchesMu8e23Filter_value)

        #print "making m2MatchesMu8e23Path"
        self.m2MatchesMu8e23Path_branch = the_tree.GetBranch("m2MatchesMu8e23Path")
        #if not self.m2MatchesMu8e23Path_branch and "m2MatchesMu8e23Path" not in self.complained:
        if not self.m2MatchesMu8e23Path_branch and "m2MatchesMu8e23Path":
            warnings.warn( "EMTree: Expected branch m2MatchesMu8e23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8e23Path")
        else:
            self.m2MatchesMu8e23Path_branch.SetAddress(<void*>&self.m2MatchesMu8e23Path_value)

        #print "making m2MvaLoose"
        self.m2MvaLoose_branch = the_tree.GetBranch("m2MvaLoose")
        #if not self.m2MvaLoose_branch and "m2MvaLoose" not in self.complained:
        if not self.m2MvaLoose_branch and "m2MvaLoose":
            warnings.warn( "EMTree: Expected branch m2MvaLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MvaLoose")
        else:
            self.m2MvaLoose_branch.SetAddress(<void*>&self.m2MvaLoose_value)

        #print "making m2MvaMedium"
        self.m2MvaMedium_branch = the_tree.GetBranch("m2MvaMedium")
        #if not self.m2MvaMedium_branch and "m2MvaMedium" not in self.complained:
        if not self.m2MvaMedium_branch and "m2MvaMedium":
            warnings.warn( "EMTree: Expected branch m2MvaMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MvaMedium")
        else:
            self.m2MvaMedium_branch.SetAddress(<void*>&self.m2MvaMedium_value)

        #print "making m2MvaTight"
        self.m2MvaTight_branch = the_tree.GetBranch("m2MvaTight")
        #if not self.m2MvaTight_branch and "m2MvaTight" not in self.complained:
        if not self.m2MvaTight_branch and "m2MvaTight":
            warnings.warn( "EMTree: Expected branch m2MvaTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MvaTight")
        else:
            self.m2MvaTight_branch.SetAddress(<void*>&self.m2MvaTight_value)

        #print "making m2PFChargedHadronIsoR04"
        self.m2PFChargedHadronIsoR04_branch = the_tree.GetBranch("m2PFChargedHadronIsoR04")
        #if not self.m2PFChargedHadronIsoR04_branch and "m2PFChargedHadronIsoR04" not in self.complained:
        if not self.m2PFChargedHadronIsoR04_branch and "m2PFChargedHadronIsoR04":
            warnings.warn( "EMTree: Expected branch m2PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedHadronIsoR04")
        else:
            self.m2PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m2PFChargedHadronIsoR04_value)

        #print "making m2PFChargedIso"
        self.m2PFChargedIso_branch = the_tree.GetBranch("m2PFChargedIso")
        #if not self.m2PFChargedIso_branch and "m2PFChargedIso" not in self.complained:
        if not self.m2PFChargedIso_branch and "m2PFChargedIso":
            warnings.warn( "EMTree: Expected branch m2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedIso")
        else:
            self.m2PFChargedIso_branch.SetAddress(<void*>&self.m2PFChargedIso_value)

        #print "making m2PFIDLoose"
        self.m2PFIDLoose_branch = the_tree.GetBranch("m2PFIDLoose")
        #if not self.m2PFIDLoose_branch and "m2PFIDLoose" not in self.complained:
        if not self.m2PFIDLoose_branch and "m2PFIDLoose":
            warnings.warn( "EMTree: Expected branch m2PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDLoose")
        else:
            self.m2PFIDLoose_branch.SetAddress(<void*>&self.m2PFIDLoose_value)

        #print "making m2PFIDMedium"
        self.m2PFIDMedium_branch = the_tree.GetBranch("m2PFIDMedium")
        #if not self.m2PFIDMedium_branch and "m2PFIDMedium" not in self.complained:
        if not self.m2PFIDMedium_branch and "m2PFIDMedium":
            warnings.warn( "EMTree: Expected branch m2PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDMedium")
        else:
            self.m2PFIDMedium_branch.SetAddress(<void*>&self.m2PFIDMedium_value)

        #print "making m2PFIDTight"
        self.m2PFIDTight_branch = the_tree.GetBranch("m2PFIDTight")
        #if not self.m2PFIDTight_branch and "m2PFIDTight" not in self.complained:
        if not self.m2PFIDTight_branch and "m2PFIDTight":
            warnings.warn( "EMTree: Expected branch m2PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDTight")
        else:
            self.m2PFIDTight_branch.SetAddress(<void*>&self.m2PFIDTight_value)

        #print "making m2PFIsoLoose"
        self.m2PFIsoLoose_branch = the_tree.GetBranch("m2PFIsoLoose")
        #if not self.m2PFIsoLoose_branch and "m2PFIsoLoose" not in self.complained:
        if not self.m2PFIsoLoose_branch and "m2PFIsoLoose":
            warnings.warn( "EMTree: Expected branch m2PFIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoLoose")
        else:
            self.m2PFIsoLoose_branch.SetAddress(<void*>&self.m2PFIsoLoose_value)

        #print "making m2PFIsoMedium"
        self.m2PFIsoMedium_branch = the_tree.GetBranch("m2PFIsoMedium")
        #if not self.m2PFIsoMedium_branch and "m2PFIsoMedium" not in self.complained:
        if not self.m2PFIsoMedium_branch and "m2PFIsoMedium":
            warnings.warn( "EMTree: Expected branch m2PFIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoMedium")
        else:
            self.m2PFIsoMedium_branch.SetAddress(<void*>&self.m2PFIsoMedium_value)

        #print "making m2PFIsoTight"
        self.m2PFIsoTight_branch = the_tree.GetBranch("m2PFIsoTight")
        #if not self.m2PFIsoTight_branch and "m2PFIsoTight" not in self.complained:
        if not self.m2PFIsoTight_branch and "m2PFIsoTight":
            warnings.warn( "EMTree: Expected branch m2PFIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoTight")
        else:
            self.m2PFIsoTight_branch.SetAddress(<void*>&self.m2PFIsoTight_value)

        #print "making m2PFIsoVeryLoose"
        self.m2PFIsoVeryLoose_branch = the_tree.GetBranch("m2PFIsoVeryLoose")
        #if not self.m2PFIsoVeryLoose_branch and "m2PFIsoVeryLoose" not in self.complained:
        if not self.m2PFIsoVeryLoose_branch and "m2PFIsoVeryLoose":
            warnings.warn( "EMTree: Expected branch m2PFIsoVeryLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoVeryLoose")
        else:
            self.m2PFIsoVeryLoose_branch.SetAddress(<void*>&self.m2PFIsoVeryLoose_value)

        #print "making m2PFIsoVeryTight"
        self.m2PFIsoVeryTight_branch = the_tree.GetBranch("m2PFIsoVeryTight")
        #if not self.m2PFIsoVeryTight_branch and "m2PFIsoVeryTight" not in self.complained:
        if not self.m2PFIsoVeryTight_branch and "m2PFIsoVeryTight":
            warnings.warn( "EMTree: Expected branch m2PFIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoVeryTight")
        else:
            self.m2PFIsoVeryTight_branch.SetAddress(<void*>&self.m2PFIsoVeryTight_value)

        #print "making m2PFNeutralHadronIsoR04"
        self.m2PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m2PFNeutralHadronIsoR04")
        #if not self.m2PFNeutralHadronIsoR04_branch and "m2PFNeutralHadronIsoR04" not in self.complained:
        if not self.m2PFNeutralHadronIsoR04_branch and "m2PFNeutralHadronIsoR04":
            warnings.warn( "EMTree: Expected branch m2PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralHadronIsoR04")
        else:
            self.m2PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m2PFNeutralHadronIsoR04_value)

        #print "making m2PFNeutralIso"
        self.m2PFNeutralIso_branch = the_tree.GetBranch("m2PFNeutralIso")
        #if not self.m2PFNeutralIso_branch and "m2PFNeutralIso" not in self.complained:
        if not self.m2PFNeutralIso_branch and "m2PFNeutralIso":
            warnings.warn( "EMTree: Expected branch m2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralIso")
        else:
            self.m2PFNeutralIso_branch.SetAddress(<void*>&self.m2PFNeutralIso_value)

        #print "making m2PFPUChargedIso"
        self.m2PFPUChargedIso_branch = the_tree.GetBranch("m2PFPUChargedIso")
        #if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso" not in self.complained:
        if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso":
            warnings.warn( "EMTree: Expected branch m2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPUChargedIso")
        else:
            self.m2PFPUChargedIso_branch.SetAddress(<void*>&self.m2PFPUChargedIso_value)

        #print "making m2PFPhotonIso"
        self.m2PFPhotonIso_branch = the_tree.GetBranch("m2PFPhotonIso")
        #if not self.m2PFPhotonIso_branch and "m2PFPhotonIso" not in self.complained:
        if not self.m2PFPhotonIso_branch and "m2PFPhotonIso":
            warnings.warn( "EMTree: Expected branch m2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIso")
        else:
            self.m2PFPhotonIso_branch.SetAddress(<void*>&self.m2PFPhotonIso_value)

        #print "making m2PFPhotonIsoR04"
        self.m2PFPhotonIsoR04_branch = the_tree.GetBranch("m2PFPhotonIsoR04")
        #if not self.m2PFPhotonIsoR04_branch and "m2PFPhotonIsoR04" not in self.complained:
        if not self.m2PFPhotonIsoR04_branch and "m2PFPhotonIsoR04":
            warnings.warn( "EMTree: Expected branch m2PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIsoR04")
        else:
            self.m2PFPhotonIsoR04_branch.SetAddress(<void*>&self.m2PFPhotonIsoR04_value)

        #print "making m2PFPileupIsoR04"
        self.m2PFPileupIsoR04_branch = the_tree.GetBranch("m2PFPileupIsoR04")
        #if not self.m2PFPileupIsoR04_branch and "m2PFPileupIsoR04" not in self.complained:
        if not self.m2PFPileupIsoR04_branch and "m2PFPileupIsoR04":
            warnings.warn( "EMTree: Expected branch m2PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPileupIsoR04")
        else:
            self.m2PFPileupIsoR04_branch.SetAddress(<void*>&self.m2PFPileupIsoR04_value)

        #print "making m2PVDXY"
        self.m2PVDXY_branch = the_tree.GetBranch("m2PVDXY")
        #if not self.m2PVDXY_branch and "m2PVDXY" not in self.complained:
        if not self.m2PVDXY_branch and "m2PVDXY":
            warnings.warn( "EMTree: Expected branch m2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDXY")
        else:
            self.m2PVDXY_branch.SetAddress(<void*>&self.m2PVDXY_value)

        #print "making m2PVDZ"
        self.m2PVDZ_branch = the_tree.GetBranch("m2PVDZ")
        #if not self.m2PVDZ_branch and "m2PVDZ" not in self.complained:
        if not self.m2PVDZ_branch and "m2PVDZ":
            warnings.warn( "EMTree: Expected branch m2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDZ")
        else:
            self.m2PVDZ_branch.SetAddress(<void*>&self.m2PVDZ_value)

        #print "making m2Phi"
        self.m2Phi_branch = the_tree.GetBranch("m2Phi")
        #if not self.m2Phi_branch and "m2Phi" not in self.complained:
        if not self.m2Phi_branch and "m2Phi":
            warnings.warn( "EMTree: Expected branch m2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi")
        else:
            self.m2Phi_branch.SetAddress(<void*>&self.m2Phi_value)

        #print "making m2Pt"
        self.m2Pt_branch = the_tree.GetBranch("m2Pt")
        #if not self.m2Pt_branch and "m2Pt" not in self.complained:
        if not self.m2Pt_branch and "m2Pt":
            warnings.warn( "EMTree: Expected branch m2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt")
        else:
            self.m2Pt_branch.SetAddress(<void*>&self.m2Pt_value)

        #print "making m2RelPFIsoDBDefault"
        self.m2RelPFIsoDBDefault_branch = the_tree.GetBranch("m2RelPFIsoDBDefault")
        #if not self.m2RelPFIsoDBDefault_branch and "m2RelPFIsoDBDefault" not in self.complained:
        if not self.m2RelPFIsoDBDefault_branch and "m2RelPFIsoDBDefault":
            warnings.warn( "EMTree: Expected branch m2RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDBDefault")
        else:
            self.m2RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m2RelPFIsoDBDefault_value)

        #print "making m2RelPFIsoDBDefaultR04"
        self.m2RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m2RelPFIsoDBDefaultR04")
        #if not self.m2RelPFIsoDBDefaultR04_branch and "m2RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m2RelPFIsoDBDefaultR04_branch and "m2RelPFIsoDBDefaultR04":
            warnings.warn( "EMTree: Expected branch m2RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDBDefaultR04")
        else:
            self.m2RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m2RelPFIsoDBDefaultR04_value)

        #print "making m2SegmentCompatibility"
        self.m2SegmentCompatibility_branch = the_tree.GetBranch("m2SegmentCompatibility")
        #if not self.m2SegmentCompatibility_branch and "m2SegmentCompatibility" not in self.complained:
        if not self.m2SegmentCompatibility_branch and "m2SegmentCompatibility":
            warnings.warn( "EMTree: Expected branch m2SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SegmentCompatibility")
        else:
            self.m2SegmentCompatibility_branch.SetAddress(<void*>&self.m2SegmentCompatibility_value)

        #print "making m2TrkIsoDR03"
        self.m2TrkIsoDR03_branch = the_tree.GetBranch("m2TrkIsoDR03")
        #if not self.m2TrkIsoDR03_branch and "m2TrkIsoDR03" not in self.complained:
        if not self.m2TrkIsoDR03_branch and "m2TrkIsoDR03":
            warnings.warn( "EMTree: Expected branch m2TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TrkIsoDR03")
        else:
            self.m2TrkIsoDR03_branch.SetAddress(<void*>&self.m2TrkIsoDR03_value)

        #print "making m2TypeCode"
        self.m2TypeCode_branch = the_tree.GetBranch("m2TypeCode")
        #if not self.m2TypeCode_branch and "m2TypeCode" not in self.complained:
        if not self.m2TypeCode_branch and "m2TypeCode":
            warnings.warn( "EMTree: Expected branch m2TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TypeCode")
        else:
            self.m2TypeCode_branch.SetAddress(<void*>&self.m2TypeCode_value)

        #print "making m2ZTTGenMatching"
        self.m2ZTTGenMatching_branch = the_tree.GetBranch("m2ZTTGenMatching")
        #if not self.m2ZTTGenMatching_branch and "m2ZTTGenMatching" not in self.complained:
        if not self.m2ZTTGenMatching_branch and "m2ZTTGenMatching":
            warnings.warn( "EMTree: Expected branch m2ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ZTTGenMatching")
        else:
            self.m2ZTTGenMatching_branch.SetAddress(<void*>&self.m2ZTTGenMatching_value)

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

        #print "making raw_pfMetEt"
        self.raw_pfMetEt_branch = the_tree.GetBranch("raw_pfMetEt")
        #if not self.raw_pfMetEt_branch and "raw_pfMetEt" not in self.complained:
        if not self.raw_pfMetEt_branch and "raw_pfMetEt":
            warnings.warn( "EMTree: Expected branch raw_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetEt")
        else:
            self.raw_pfMetEt_branch.SetAddress(<void*>&self.raw_pfMetEt_value)

        #print "making raw_pfMetPhi"
        self.raw_pfMetPhi_branch = the_tree.GetBranch("raw_pfMetPhi")
        #if not self.raw_pfMetPhi_branch and "raw_pfMetPhi" not in self.complained:
        if not self.raw_pfMetPhi_branch and "raw_pfMetPhi":
            warnings.warn( "EMTree: Expected branch raw_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetPhi")
        else:
            self.raw_pfMetPhi_branch.SetAddress(<void*>&self.raw_pfMetPhi_value)

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

        #print "making singleIsoTkMu24Pass"
        self.singleIsoTkMu24Pass_branch = the_tree.GetBranch("singleIsoTkMu24Pass")
        #if not self.singleIsoTkMu24Pass_branch and "singleIsoTkMu24Pass" not in self.complained:
        if not self.singleIsoTkMu24Pass_branch and "singleIsoTkMu24Pass":
            warnings.warn( "EMTree: Expected branch singleIsoTkMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu24Pass")
        else:
            self.singleIsoTkMu24Pass_branch.SetAddress(<void*>&self.singleIsoTkMu24Pass_value)

        #print "making tauVetoPtDeepVtx"
        self.tauVetoPtDeepVtx_branch = the_tree.GetBranch("tauVetoPtDeepVtx")
        #if not self.tauVetoPtDeepVtx_branch and "tauVetoPtDeepVtx" not in self.complained:
        if not self.tauVetoPtDeepVtx_branch and "tauVetoPtDeepVtx":
            warnings.warn( "EMTree: Expected branch tauVetoPtDeepVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPtDeepVtx")
        else:
            self.tauVetoPtDeepVtx_branch.SetAddress(<void*>&self.tauVetoPtDeepVtx_value)

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

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "EMTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

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

    property EmbPtWeight:
        def __get__(self):
            self.EmbPtWeight_branch.GetEntry(self.localentry, 0)
            return self.EmbPtWeight_value

    property Flag_BadChargedCandidateFilter:
        def __get__(self):
            self.Flag_BadChargedCandidateFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_BadChargedCandidateFilter_value

    property Flag_BadPFMuonDzFilter:
        def __get__(self):
            self.Flag_BadPFMuonDzFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_BadPFMuonDzFilter_value

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

    property IsoMu20Pass:
        def __get__(self):
            self.IsoMu20Pass_branch.GetEntry(self.localentry, 0)
            return self.IsoMu20Pass_value

    property IsoMu22Pass:
        def __get__(self):
            self.IsoMu22Pass_branch.GetEntry(self.localentry, 0)
            return self.IsoMu22Pass_value

    property IsoMu22eta2p1Pass:
        def __get__(self):
            self.IsoMu22eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.IsoMu22eta2p1Pass_value

    property IsoMu24Pass:
        def __get__(self):
            self.IsoMu24Pass_branch.GetEntry(self.localentry, 0)
            return self.IsoMu24Pass_value

    property IsoMu27Pass:
        def __get__(self):
            self.IsoMu27Pass_branch.GetEntry(self.localentry, 0)
            return self.IsoMu27Pass_value

    property NUP:
        def __get__(self):
            self.NUP_branch.GetEntry(self.localentry, 0)
            return self.NUP_value

    property bjetDeepCSVVeto20Loose_2016_DR0p4:
        def __get__(self):
            self.bjetDeepCSVVeto20Loose_2016_DR0p4_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Loose_2016_DR0p4_value

    property bjetDeepCSVVeto20Loose_2017_DR0p4:
        def __get__(self):
            self.bjetDeepCSVVeto20Loose_2017_DR0p4_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Loose_2017_DR0p4_value

    property bjetDeepCSVVeto20Loose_2018_DR0p4:
        def __get__(self):
            self.bjetDeepCSVVeto20Loose_2018_DR0p4_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Loose_2018_DR0p4_value

    property bjetDeepCSVVeto20Medium_2016_DR0p4:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2016_DR0p4_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2016_DR0p4_value

    property bjetDeepCSVVeto20Medium_2017_DR0p4:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2017_DR0p4_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2017_DR0p4_value

    property bjetDeepCSVVeto20Medium_2018_DR0p4:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2018_DR0p4_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2018_DR0p4_value

    property bjetDeepFlavourVeto20Loose_2016_DR0p4:
        def __get__(self):
            self.bjetDeepFlavourVeto20Loose_2016_DR0p4_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepFlavourVeto20Loose_2016_DR0p4_value

    property bjetDeepFlavourVeto20Loose_2017_DR0p4:
        def __get__(self):
            self.bjetDeepFlavourVeto20Loose_2017_DR0p4_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepFlavourVeto20Loose_2017_DR0p4_value

    property bjetDeepFlavourVeto20Loose_2018_DR0p4:
        def __get__(self):
            self.bjetDeepFlavourVeto20Loose_2018_DR0p4_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepFlavourVeto20Loose_2018_DR0p4_value

    property bjetDeepFlavourVeto20Medium_2016_DR0p4:
        def __get__(self):
            self.bjetDeepFlavourVeto20Medium_2016_DR0p4_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepFlavourVeto20Medium_2016_DR0p4_value

    property bjetDeepFlavourVeto20Medium_2017_DR0p4:
        def __get__(self):
            self.bjetDeepFlavourVeto20Medium_2017_DR0p4_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepFlavourVeto20Medium_2017_DR0p4_value

    property bjetDeepFlavourVeto20Medium_2018_DR0p4:
        def __get__(self):
            self.bjetDeepFlavourVeto20Medium_2018_DR0p4_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepFlavourVeto20Medium_2018_DR0p4_value

    property deepcsvb1Loose_btagscore_2017:
        def __get__(self):
            self.deepcsvb1Loose_btagscore_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Loose_btagscore_2017_value

    property deepcsvb1Loose_btagscore_2018:
        def __get__(self):
            self.deepcsvb1Loose_btagscore_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Loose_btagscore_2018_value

    property deepcsvb1Loose_eta_2017:
        def __get__(self):
            self.deepcsvb1Loose_eta_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Loose_eta_2017_value

    property deepcsvb1Loose_eta_2018:
        def __get__(self):
            self.deepcsvb1Loose_eta_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Loose_eta_2018_value

    property deepcsvb1Loose_hadronflavour_2017:
        def __get__(self):
            self.deepcsvb1Loose_hadronflavour_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Loose_hadronflavour_2017_value

    property deepcsvb1Loose_hadronflavour_2018:
        def __get__(self):
            self.deepcsvb1Loose_hadronflavour_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Loose_hadronflavour_2018_value

    property deepcsvb1Loose_m_2017:
        def __get__(self):
            self.deepcsvb1Loose_m_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Loose_m_2017_value

    property deepcsvb1Loose_m_2018:
        def __get__(self):
            self.deepcsvb1Loose_m_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Loose_m_2018_value

    property deepcsvb1Loose_phi_2017:
        def __get__(self):
            self.deepcsvb1Loose_phi_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Loose_phi_2017_value

    property deepcsvb1Loose_phi_2018:
        def __get__(self):
            self.deepcsvb1Loose_phi_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Loose_phi_2018_value

    property deepcsvb1Loose_pt_2017:
        def __get__(self):
            self.deepcsvb1Loose_pt_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Loose_pt_2017_value

    property deepcsvb1Loose_pt_2018:
        def __get__(self):
            self.deepcsvb1Loose_pt_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Loose_pt_2018_value

    property deepcsvb1Medium_btagscore_2017:
        def __get__(self):
            self.deepcsvb1Medium_btagscore_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Medium_btagscore_2017_value

    property deepcsvb1Medium_btagscore_2018:
        def __get__(self):
            self.deepcsvb1Medium_btagscore_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Medium_btagscore_2018_value

    property deepcsvb1Medium_eta_2017:
        def __get__(self):
            self.deepcsvb1Medium_eta_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Medium_eta_2017_value

    property deepcsvb1Medium_eta_2018:
        def __get__(self):
            self.deepcsvb1Medium_eta_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Medium_eta_2018_value

    property deepcsvb1Medium_hadronflavour_2017:
        def __get__(self):
            self.deepcsvb1Medium_hadronflavour_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Medium_hadronflavour_2017_value

    property deepcsvb1Medium_hadronflavour_2018:
        def __get__(self):
            self.deepcsvb1Medium_hadronflavour_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Medium_hadronflavour_2018_value

    property deepcsvb1Medium_m_2017:
        def __get__(self):
            self.deepcsvb1Medium_m_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Medium_m_2017_value

    property deepcsvb1Medium_m_2018:
        def __get__(self):
            self.deepcsvb1Medium_m_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Medium_m_2018_value

    property deepcsvb1Medium_phi_2017:
        def __get__(self):
            self.deepcsvb1Medium_phi_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Medium_phi_2017_value

    property deepcsvb1Medium_phi_2018:
        def __get__(self):
            self.deepcsvb1Medium_phi_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Medium_phi_2018_value

    property deepcsvb1Medium_pt_2017:
        def __get__(self):
            self.deepcsvb1Medium_pt_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Medium_pt_2017_value

    property deepcsvb1Medium_pt_2018:
        def __get__(self):
            self.deepcsvb1Medium_pt_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1Medium_pt_2018_value

    property deepcsvb2Loose_btagscore_2017:
        def __get__(self):
            self.deepcsvb2Loose_btagscore_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Loose_btagscore_2017_value

    property deepcsvb2Loose_btagscore_2018:
        def __get__(self):
            self.deepcsvb2Loose_btagscore_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Loose_btagscore_2018_value

    property deepcsvb2Loose_eta_2017:
        def __get__(self):
            self.deepcsvb2Loose_eta_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Loose_eta_2017_value

    property deepcsvb2Loose_eta_2018:
        def __get__(self):
            self.deepcsvb2Loose_eta_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Loose_eta_2018_value

    property deepcsvb2Loose_hadronflavour_2017:
        def __get__(self):
            self.deepcsvb2Loose_hadronflavour_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Loose_hadronflavour_2017_value

    property deepcsvb2Loose_hadronflavour_2018:
        def __get__(self):
            self.deepcsvb2Loose_hadronflavour_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Loose_hadronflavour_2018_value

    property deepcsvb2Loose_m_2017:
        def __get__(self):
            self.deepcsvb2Loose_m_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Loose_m_2017_value

    property deepcsvb2Loose_m_2018:
        def __get__(self):
            self.deepcsvb2Loose_m_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Loose_m_2018_value

    property deepcsvb2Loose_phi_2017:
        def __get__(self):
            self.deepcsvb2Loose_phi_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Loose_phi_2017_value

    property deepcsvb2Loose_phi_2018:
        def __get__(self):
            self.deepcsvb2Loose_phi_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Loose_phi_2018_value

    property deepcsvb2Loose_pt_2017:
        def __get__(self):
            self.deepcsvb2Loose_pt_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Loose_pt_2017_value

    property deepcsvb2Loose_pt_2018:
        def __get__(self):
            self.deepcsvb2Loose_pt_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Loose_pt_2018_value

    property deepcsvb2Medium_btagscore_2017:
        def __get__(self):
            self.deepcsvb2Medium_btagscore_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Medium_btagscore_2017_value

    property deepcsvb2Medium_btagscore_2018:
        def __get__(self):
            self.deepcsvb2Medium_btagscore_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Medium_btagscore_2018_value

    property deepcsvb2Medium_eta_2017:
        def __get__(self):
            self.deepcsvb2Medium_eta_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Medium_eta_2017_value

    property deepcsvb2Medium_eta_2018:
        def __get__(self):
            self.deepcsvb2Medium_eta_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Medium_eta_2018_value

    property deepcsvb2Medium_hadronflavour_2017:
        def __get__(self):
            self.deepcsvb2Medium_hadronflavour_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Medium_hadronflavour_2017_value

    property deepcsvb2Medium_hadronflavour_2018:
        def __get__(self):
            self.deepcsvb2Medium_hadronflavour_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Medium_hadronflavour_2018_value

    property deepcsvb2Medium_m_2017:
        def __get__(self):
            self.deepcsvb2Medium_m_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Medium_m_2017_value

    property deepcsvb2Medium_m_2018:
        def __get__(self):
            self.deepcsvb2Medium_m_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Medium_m_2018_value

    property deepcsvb2Medium_phi_2017:
        def __get__(self):
            self.deepcsvb2Medium_phi_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Medium_phi_2017_value

    property deepcsvb2Medium_phi_2018:
        def __get__(self):
            self.deepcsvb2Medium_phi_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Medium_phi_2018_value

    property deepcsvb2Medium_pt_2017:
        def __get__(self):
            self.deepcsvb2Medium_pt_2017_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Medium_pt_2017_value

    property deepcsvb2Medium_pt_2018:
        def __get__(self):
            self.deepcsvb2Medium_pt_2018_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2Medium_pt_2018_value

    property deepflavourLooseb1_btagscore_2017:
        def __get__(self):
            self.deepflavourLooseb1_btagscore_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb1_btagscore_2017_value

    property deepflavourLooseb1_btagscore_2018:
        def __get__(self):
            self.deepflavourLooseb1_btagscore_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb1_btagscore_2018_value

    property deepflavourLooseb1_eta_2017:
        def __get__(self):
            self.deepflavourLooseb1_eta_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb1_eta_2017_value

    property deepflavourLooseb1_eta_2018:
        def __get__(self):
            self.deepflavourLooseb1_eta_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb1_eta_2018_value

    property deepflavourLooseb1_hadronflavour_2017:
        def __get__(self):
            self.deepflavourLooseb1_hadronflavour_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb1_hadronflavour_2017_value

    property deepflavourLooseb1_hadronflavour_2018:
        def __get__(self):
            self.deepflavourLooseb1_hadronflavour_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb1_hadronflavour_2018_value

    property deepflavourLooseb1_m_2017:
        def __get__(self):
            self.deepflavourLooseb1_m_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb1_m_2017_value

    property deepflavourLooseb1_m_2018:
        def __get__(self):
            self.deepflavourLooseb1_m_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb1_m_2018_value

    property deepflavourLooseb1_phi_2017:
        def __get__(self):
            self.deepflavourLooseb1_phi_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb1_phi_2017_value

    property deepflavourLooseb1_phi_2018:
        def __get__(self):
            self.deepflavourLooseb1_phi_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb1_phi_2018_value

    property deepflavourLooseb1_pt_2017:
        def __get__(self):
            self.deepflavourLooseb1_pt_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb1_pt_2017_value

    property deepflavourLooseb1_pt_2018:
        def __get__(self):
            self.deepflavourLooseb1_pt_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb1_pt_2018_value

    property deepflavourLooseb2_btagscore_2017:
        def __get__(self):
            self.deepflavourLooseb2_btagscore_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb2_btagscore_2017_value

    property deepflavourLooseb2_btagscore_2018:
        def __get__(self):
            self.deepflavourLooseb2_btagscore_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb2_btagscore_2018_value

    property deepflavourLooseb2_eta_2017:
        def __get__(self):
            self.deepflavourLooseb2_eta_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb2_eta_2017_value

    property deepflavourLooseb2_eta_2018:
        def __get__(self):
            self.deepflavourLooseb2_eta_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb2_eta_2018_value

    property deepflavourLooseb2_hadronflavour_2017:
        def __get__(self):
            self.deepflavourLooseb2_hadronflavour_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb2_hadronflavour_2017_value

    property deepflavourLooseb2_hadronflavour_2018:
        def __get__(self):
            self.deepflavourLooseb2_hadronflavour_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb2_hadronflavour_2018_value

    property deepflavourLooseb2_m_2017:
        def __get__(self):
            self.deepflavourLooseb2_m_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb2_m_2017_value

    property deepflavourLooseb2_m_2018:
        def __get__(self):
            self.deepflavourLooseb2_m_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb2_m_2018_value

    property deepflavourLooseb2_phi_2017:
        def __get__(self):
            self.deepflavourLooseb2_phi_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb2_phi_2017_value

    property deepflavourLooseb2_phi_2018:
        def __get__(self):
            self.deepflavourLooseb2_phi_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb2_phi_2018_value

    property deepflavourLooseb2_pt_2017:
        def __get__(self):
            self.deepflavourLooseb2_pt_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb2_pt_2017_value

    property deepflavourLooseb2_pt_2018:
        def __get__(self):
            self.deepflavourLooseb2_pt_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourLooseb2_pt_2018_value

    property deepflavourMediumb1_btagscore_2017:
        def __get__(self):
            self.deepflavourMediumb1_btagscore_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb1_btagscore_2017_value

    property deepflavourMediumb1_btagscore_2018:
        def __get__(self):
            self.deepflavourMediumb1_btagscore_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb1_btagscore_2018_value

    property deepflavourMediumb1_eta_2017:
        def __get__(self):
            self.deepflavourMediumb1_eta_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb1_eta_2017_value

    property deepflavourMediumb1_eta_2018:
        def __get__(self):
            self.deepflavourMediumb1_eta_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb1_eta_2018_value

    property deepflavourMediumb1_hadronflavour_2017:
        def __get__(self):
            self.deepflavourMediumb1_hadronflavour_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb1_hadronflavour_2017_value

    property deepflavourMediumb1_hadronflavour_2018:
        def __get__(self):
            self.deepflavourMediumb1_hadronflavour_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb1_hadronflavour_2018_value

    property deepflavourMediumb1_m_2017:
        def __get__(self):
            self.deepflavourMediumb1_m_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb1_m_2017_value

    property deepflavourMediumb1_m_2018:
        def __get__(self):
            self.deepflavourMediumb1_m_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb1_m_2018_value

    property deepflavourMediumb1_phi_2017:
        def __get__(self):
            self.deepflavourMediumb1_phi_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb1_phi_2017_value

    property deepflavourMediumb1_phi_2018:
        def __get__(self):
            self.deepflavourMediumb1_phi_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb1_phi_2018_value

    property deepflavourMediumb1_pt_2017:
        def __get__(self):
            self.deepflavourMediumb1_pt_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb1_pt_2017_value

    property deepflavourMediumb1_pt_2018:
        def __get__(self):
            self.deepflavourMediumb1_pt_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb1_pt_2018_value

    property deepflavourMediumb2_btagscore_2017:
        def __get__(self):
            self.deepflavourMediumb2_btagscore_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb2_btagscore_2017_value

    property deepflavourMediumb2_btagscore_2018:
        def __get__(self):
            self.deepflavourMediumb2_btagscore_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb2_btagscore_2018_value

    property deepflavourMediumb2_eta_2017:
        def __get__(self):
            self.deepflavourMediumb2_eta_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb2_eta_2017_value

    property deepflavourMediumb2_eta_2018:
        def __get__(self):
            self.deepflavourMediumb2_eta_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb2_eta_2018_value

    property deepflavourMediumb2_hadronflavour_2017:
        def __get__(self):
            self.deepflavourMediumb2_hadronflavour_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb2_hadronflavour_2017_value

    property deepflavourMediumb2_hadronflavour_2018:
        def __get__(self):
            self.deepflavourMediumb2_hadronflavour_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb2_hadronflavour_2018_value

    property deepflavourMediumb2_m_2017:
        def __get__(self):
            self.deepflavourMediumb2_m_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb2_m_2017_value

    property deepflavourMediumb2_m_2018:
        def __get__(self):
            self.deepflavourMediumb2_m_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb2_m_2018_value

    property deepflavourMediumb2_phi_2017:
        def __get__(self):
            self.deepflavourMediumb2_phi_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb2_phi_2017_value

    property deepflavourMediumb2_phi_2018:
        def __get__(self):
            self.deepflavourMediumb2_phi_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb2_phi_2018_value

    property deepflavourMediumb2_pt_2017:
        def __get__(self):
            self.deepflavourMediumb2_pt_2017_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb2_pt_2017_value

    property deepflavourMediumb2_pt_2018:
        def __get__(self):
            self.deepflavourMediumb2_pt_2018_branch.GetEntry(self.localentry, 0)
            return self.deepflavourMediumb2_pt_2018_value

    property eVetoZTTp001dxyz:
        def __get__(self):
            self.eVetoZTTp001dxyz_branch.GetEntry(self.localentry, 0)
            return self.eVetoZTTp001dxyz_value

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

    property isZee:
        def __get__(self):
            self.isZee_branch.GetEntry(self.localentry, 0)
            return self.isZee_value

    property isZmumu:
        def __get__(self):
            self.isZmumu_branch.GetEntry(self.localentry, 0)
            return self.isZmumu_value

    property isdata:
        def __get__(self):
            self.isdata_branch.GetEntry(self.localentry, 0)
            return self.isdata_value

    property isembed:
        def __get__(self):
            self.isembed_branch.GetEntry(self.localentry, 0)
            return self.isembed_value

    property j1eta:
        def __get__(self):
            self.j1eta_branch.GetEntry(self.localentry, 0)
            return self.j1eta_value

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

    property j1phi:
        def __get__(self):
            self.j1phi_branch.GetEntry(self.localentry, 0)
            return self.j1phi_value

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

    property j2eta:
        def __get__(self):
            self.j2eta_branch.GetEntry(self.localentry, 0)
            return self.j2eta_value

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

    property j2phi:
        def __get__(self):
            self.j2phi_branch.GetEntry(self.localentry, 0)
            return self.j2phi_value

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

    property jetVeto20:
        def __get__(self):
            self.jetVeto20_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_value

    property jetVeto30:
        def __get__(self):
            self.jetVeto30_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_value

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

    property jetVeto30_JetEnDown:
        def __get__(self):
            self.jetVeto30_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnDown_value

    property jetVeto30_JetEnUp:
        def __get__(self):
            self.jetVeto30_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnUp_value

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

    property lumi:
        def __get__(self):
            self.lumi_branch.GetEntry(self.localentry, 0)
            return self.lumi_value

    property m1BestTrackType:
        def __get__(self):
            self.m1BestTrackType_branch.GetEntry(self.localentry, 0)
            return self.m1BestTrackType_value

    property m1Charge:
        def __get__(self):
            self.m1Charge_branch.GetEntry(self.localentry, 0)
            return self.m1Charge_value

    property m1EcalIsoDR03:
        def __get__(self):
            self.m1EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m1EcalIsoDR03_value

    property m1Eta:
        def __get__(self):
            self.m1Eta_branch.GetEntry(self.localentry, 0)
            return self.m1Eta_value

    property m1GenCharge:
        def __get__(self):
            self.m1GenCharge_branch.GetEntry(self.localentry, 0)
            return self.m1GenCharge_value

    property m1GenEnergy:
        def __get__(self):
            self.m1GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.m1GenEnergy_value

    property m1GenEta:
        def __get__(self):
            self.m1GenEta_branch.GetEntry(self.localentry, 0)
            return self.m1GenEta_value

    property m1GenMotherPdgId:
        def __get__(self):
            self.m1GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.m1GenMotherPdgId_value

    property m1GenParticle:
        def __get__(self):
            self.m1GenParticle_branch.GetEntry(self.localentry, 0)
            return self.m1GenParticle_value

    property m1GenPdgId:
        def __get__(self):
            self.m1GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.m1GenPdgId_value

    property m1GenPhi:
        def __get__(self):
            self.m1GenPhi_branch.GetEntry(self.localentry, 0)
            return self.m1GenPhi_value

    property m1GenPt:
        def __get__(self):
            self.m1GenPt_branch.GetEntry(self.localentry, 0)
            return self.m1GenPt_value

    property m1GenVZ:
        def __get__(self):
            self.m1GenVZ_branch.GetEntry(self.localentry, 0)
            return self.m1GenVZ_value

    property m1HcalIsoDR03:
        def __get__(self):
            self.m1HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m1HcalIsoDR03_value

    property m1IP3D:
        def __get__(self):
            self.m1IP3D_branch.GetEntry(self.localentry, 0)
            return self.m1IP3D_value

    property m1IP3DS:
        def __get__(self):
            self.m1IP3DS_branch.GetEntry(self.localentry, 0)
            return self.m1IP3DS_value

    property m1IPDXY:
        def __get__(self):
            self.m1IPDXY_branch.GetEntry(self.localentry, 0)
            return self.m1IPDXY_value

    property m1IsGlobal:
        def __get__(self):
            self.m1IsGlobal_branch.GetEntry(self.localentry, 0)
            return self.m1IsGlobal_value

    property m1IsPFMuon:
        def __get__(self):
            self.m1IsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.m1IsPFMuon_value

    property m1IsTracker:
        def __get__(self):
            self.m1IsTracker_branch.GetEntry(self.localentry, 0)
            return self.m1IsTracker_value

    property m1IsoDB03:
        def __get__(self):
            self.m1IsoDB03_branch.GetEntry(self.localentry, 0)
            return self.m1IsoDB03_value

    property m1IsoDB04:
        def __get__(self):
            self.m1IsoDB04_branch.GetEntry(self.localentry, 0)
            return self.m1IsoDB04_value

    property m1Mass:
        def __get__(self):
            self.m1Mass_branch.GetEntry(self.localentry, 0)
            return self.m1Mass_value

    property m1MatchesIsoMu20Filter:
        def __get__(self):
            self.m1MatchesIsoMu20Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu20Filter_value

    property m1MatchesIsoMu20Path:
        def __get__(self):
            self.m1MatchesIsoMu20Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu20Path_value

    property m1MatchesIsoMu22Filter:
        def __get__(self):
            self.m1MatchesIsoMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu22Filter_value

    property m1MatchesIsoMu22Path:
        def __get__(self):
            self.m1MatchesIsoMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu22Path_value

    property m1MatchesIsoMu22eta2p1Filter:
        def __get__(self):
            self.m1MatchesIsoMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu22eta2p1Filter_value

    property m1MatchesIsoMu22eta2p1Path:
        def __get__(self):
            self.m1MatchesIsoMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu22eta2p1Path_value

    property m1MatchesIsoMu24Filter:
        def __get__(self):
            self.m1MatchesIsoMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu24Filter_value

    property m1MatchesIsoMu24Path:
        def __get__(self):
            self.m1MatchesIsoMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu24Path_value

    property m1MatchesIsoMu27Filter:
        def __get__(self):
            self.m1MatchesIsoMu27Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu27Filter_value

    property m1MatchesIsoMu27Path:
        def __get__(self):
            self.m1MatchesIsoMu27Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu27Path_value

    property m1MatchesIsoTkMu22Filter:
        def __get__(self):
            self.m1MatchesIsoTkMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu22Filter_value

    property m1MatchesIsoTkMu22Path:
        def __get__(self):
            self.m1MatchesIsoTkMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu22Path_value

    property m1MatchesIsoTkMu22eta2p1Filter:
        def __get__(self):
            self.m1MatchesIsoTkMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu22eta2p1Filter_value

    property m1MatchesIsoTkMu22eta2p1Path:
        def __get__(self):
            self.m1MatchesIsoTkMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu22eta2p1Path_value

    property m1MatchesIsoTkMu24Filter:
        def __get__(self):
            self.m1MatchesIsoTkMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu24Filter_value

    property m1MatchesIsoTkMu24Path:
        def __get__(self):
            self.m1MatchesIsoTkMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu24Path_value

    property m1MatchesMu23e12DZFilter:
        def __get__(self):
            self.m1MatchesMu23e12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu23e12DZFilter_value

    property m1MatchesMu23e12DZPath:
        def __get__(self):
            self.m1MatchesMu23e12DZPath_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu23e12DZPath_value

    property m1MatchesMu23e12Filter:
        def __get__(self):
            self.m1MatchesMu23e12Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu23e12Filter_value

    property m1MatchesMu23e12Path:
        def __get__(self):
            self.m1MatchesMu23e12Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu23e12Path_value

    property m1MatchesMu8e23DZFilter:
        def __get__(self):
            self.m1MatchesMu8e23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu8e23DZFilter_value

    property m1MatchesMu8e23DZPath:
        def __get__(self):
            self.m1MatchesMu8e23DZPath_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu8e23DZPath_value

    property m1MatchesMu8e23Filter:
        def __get__(self):
            self.m1MatchesMu8e23Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu8e23Filter_value

    property m1MatchesMu8e23Path:
        def __get__(self):
            self.m1MatchesMu8e23Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu8e23Path_value

    property m1MvaLoose:
        def __get__(self):
            self.m1MvaLoose_branch.GetEntry(self.localentry, 0)
            return self.m1MvaLoose_value

    property m1MvaMedium:
        def __get__(self):
            self.m1MvaMedium_branch.GetEntry(self.localentry, 0)
            return self.m1MvaMedium_value

    property m1MvaTight:
        def __get__(self):
            self.m1MvaTight_branch.GetEntry(self.localentry, 0)
            return self.m1MvaTight_value

    property m1PFChargedHadronIsoR04:
        def __get__(self):
            self.m1PFChargedHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m1PFChargedHadronIsoR04_value

    property m1PFChargedIso:
        def __get__(self):
            self.m1PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFChargedIso_value

    property m1PFIDLoose:
        def __get__(self):
            self.m1PFIDLoose_branch.GetEntry(self.localentry, 0)
            return self.m1PFIDLoose_value

    property m1PFIDMedium:
        def __get__(self):
            self.m1PFIDMedium_branch.GetEntry(self.localentry, 0)
            return self.m1PFIDMedium_value

    property m1PFIDTight:
        def __get__(self):
            self.m1PFIDTight_branch.GetEntry(self.localentry, 0)
            return self.m1PFIDTight_value

    property m1PFIsoLoose:
        def __get__(self):
            self.m1PFIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.m1PFIsoLoose_value

    property m1PFIsoMedium:
        def __get__(self):
            self.m1PFIsoMedium_branch.GetEntry(self.localentry, 0)
            return self.m1PFIsoMedium_value

    property m1PFIsoTight:
        def __get__(self):
            self.m1PFIsoTight_branch.GetEntry(self.localentry, 0)
            return self.m1PFIsoTight_value

    property m1PFIsoVeryLoose:
        def __get__(self):
            self.m1PFIsoVeryLoose_branch.GetEntry(self.localentry, 0)
            return self.m1PFIsoVeryLoose_value

    property m1PFIsoVeryTight:
        def __get__(self):
            self.m1PFIsoVeryTight_branch.GetEntry(self.localentry, 0)
            return self.m1PFIsoVeryTight_value

    property m1PFNeutralHadronIsoR04:
        def __get__(self):
            self.m1PFNeutralHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m1PFNeutralHadronIsoR04_value

    property m1PFNeutralIso:
        def __get__(self):
            self.m1PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFNeutralIso_value

    property m1PFPUChargedIso:
        def __get__(self):
            self.m1PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFPUChargedIso_value

    property m1PFPhotonIso:
        def __get__(self):
            self.m1PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFPhotonIso_value

    property m1PFPhotonIsoR04:
        def __get__(self):
            self.m1PFPhotonIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m1PFPhotonIsoR04_value

    property m1PFPileupIsoR04:
        def __get__(self):
            self.m1PFPileupIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m1PFPileupIsoR04_value

    property m1PVDXY:
        def __get__(self):
            self.m1PVDXY_branch.GetEntry(self.localentry, 0)
            return self.m1PVDXY_value

    property m1PVDZ:
        def __get__(self):
            self.m1PVDZ_branch.GetEntry(self.localentry, 0)
            return self.m1PVDZ_value

    property m1Phi:
        def __get__(self):
            self.m1Phi_branch.GetEntry(self.localentry, 0)
            return self.m1Phi_value

    property m1Pt:
        def __get__(self):
            self.m1Pt_branch.GetEntry(self.localentry, 0)
            return self.m1Pt_value

    property m1RelPFIsoDBDefault:
        def __get__(self):
            self.m1RelPFIsoDBDefault_branch.GetEntry(self.localentry, 0)
            return self.m1RelPFIsoDBDefault_value

    property m1RelPFIsoDBDefaultR04:
        def __get__(self):
            self.m1RelPFIsoDBDefaultR04_branch.GetEntry(self.localentry, 0)
            return self.m1RelPFIsoDBDefaultR04_value

    property m1SegmentCompatibility:
        def __get__(self):
            self.m1SegmentCompatibility_branch.GetEntry(self.localentry, 0)
            return self.m1SegmentCompatibility_value

    property m1TrkIsoDR03:
        def __get__(self):
            self.m1TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m1TrkIsoDR03_value

    property m1TypeCode:
        def __get__(self):
            self.m1TypeCode_branch.GetEntry(self.localentry, 0)
            return self.m1TypeCode_value

    property m1ZTTGenMatching:
        def __get__(self):
            self.m1ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.m1ZTTGenMatching_value

    property m1_m2_DR:
        def __get__(self):
            self.m1_m2_DR_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_DR_value

    property m1_m2_Mass:
        def __get__(self):
            self.m1_m2_Mass_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mass_value

    property m1_m2_PZeta:
        def __get__(self):
            self.m1_m2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_PZeta_value

    property m1_m2_PZetaVis:
        def __get__(self):
            self.m1_m2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_PZetaVis_value

    property m2BestTrackType:
        def __get__(self):
            self.m2BestTrackType_branch.GetEntry(self.localentry, 0)
            return self.m2BestTrackType_value

    property m2Charge:
        def __get__(self):
            self.m2Charge_branch.GetEntry(self.localentry, 0)
            return self.m2Charge_value

    property m2EcalIsoDR03:
        def __get__(self):
            self.m2EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m2EcalIsoDR03_value

    property m2Eta:
        def __get__(self):
            self.m2Eta_branch.GetEntry(self.localentry, 0)
            return self.m2Eta_value

    property m2GenCharge:
        def __get__(self):
            self.m2GenCharge_branch.GetEntry(self.localentry, 0)
            return self.m2GenCharge_value

    property m2GenEnergy:
        def __get__(self):
            self.m2GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.m2GenEnergy_value

    property m2GenEta:
        def __get__(self):
            self.m2GenEta_branch.GetEntry(self.localentry, 0)
            return self.m2GenEta_value

    property m2GenMotherPdgId:
        def __get__(self):
            self.m2GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.m2GenMotherPdgId_value

    property m2GenParticle:
        def __get__(self):
            self.m2GenParticle_branch.GetEntry(self.localentry, 0)
            return self.m2GenParticle_value

    property m2GenPdgId:
        def __get__(self):
            self.m2GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.m2GenPdgId_value

    property m2GenPhi:
        def __get__(self):
            self.m2GenPhi_branch.GetEntry(self.localentry, 0)
            return self.m2GenPhi_value

    property m2GenPt:
        def __get__(self):
            self.m2GenPt_branch.GetEntry(self.localentry, 0)
            return self.m2GenPt_value

    property m2GenVZ:
        def __get__(self):
            self.m2GenVZ_branch.GetEntry(self.localentry, 0)
            return self.m2GenVZ_value

    property m2HcalIsoDR03:
        def __get__(self):
            self.m2HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m2HcalIsoDR03_value

    property m2IP3D:
        def __get__(self):
            self.m2IP3D_branch.GetEntry(self.localentry, 0)
            return self.m2IP3D_value

    property m2IP3DS:
        def __get__(self):
            self.m2IP3DS_branch.GetEntry(self.localentry, 0)
            return self.m2IP3DS_value

    property m2IPDXY:
        def __get__(self):
            self.m2IPDXY_branch.GetEntry(self.localentry, 0)
            return self.m2IPDXY_value

    property m2IsGlobal:
        def __get__(self):
            self.m2IsGlobal_branch.GetEntry(self.localentry, 0)
            return self.m2IsGlobal_value

    property m2IsPFMuon:
        def __get__(self):
            self.m2IsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.m2IsPFMuon_value

    property m2IsTracker:
        def __get__(self):
            self.m2IsTracker_branch.GetEntry(self.localentry, 0)
            return self.m2IsTracker_value

    property m2IsoDB03:
        def __get__(self):
            self.m2IsoDB03_branch.GetEntry(self.localentry, 0)
            return self.m2IsoDB03_value

    property m2IsoDB04:
        def __get__(self):
            self.m2IsoDB04_branch.GetEntry(self.localentry, 0)
            return self.m2IsoDB04_value

    property m2Mass:
        def __get__(self):
            self.m2Mass_branch.GetEntry(self.localentry, 0)
            return self.m2Mass_value

    property m2MatchesIsoMu20Filter:
        def __get__(self):
            self.m2MatchesIsoMu20Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu20Filter_value

    property m2MatchesIsoMu20Path:
        def __get__(self):
            self.m2MatchesIsoMu20Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu20Path_value

    property m2MatchesIsoMu22Filter:
        def __get__(self):
            self.m2MatchesIsoMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu22Filter_value

    property m2MatchesIsoMu22Path:
        def __get__(self):
            self.m2MatchesIsoMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu22Path_value

    property m2MatchesIsoMu22eta2p1Filter:
        def __get__(self):
            self.m2MatchesIsoMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu22eta2p1Filter_value

    property m2MatchesIsoMu22eta2p1Path:
        def __get__(self):
            self.m2MatchesIsoMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu22eta2p1Path_value

    property m2MatchesIsoMu24Filter:
        def __get__(self):
            self.m2MatchesIsoMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu24Filter_value

    property m2MatchesIsoMu24Path:
        def __get__(self):
            self.m2MatchesIsoMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu24Path_value

    property m2MatchesIsoMu27Filter:
        def __get__(self):
            self.m2MatchesIsoMu27Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu27Filter_value

    property m2MatchesIsoMu27Path:
        def __get__(self):
            self.m2MatchesIsoMu27Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu27Path_value

    property m2MatchesIsoTkMu22Filter:
        def __get__(self):
            self.m2MatchesIsoTkMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu22Filter_value

    property m2MatchesIsoTkMu22Path:
        def __get__(self):
            self.m2MatchesIsoTkMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu22Path_value

    property m2MatchesIsoTkMu22eta2p1Filter:
        def __get__(self):
            self.m2MatchesIsoTkMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu22eta2p1Filter_value

    property m2MatchesIsoTkMu22eta2p1Path:
        def __get__(self):
            self.m2MatchesIsoTkMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu22eta2p1Path_value

    property m2MatchesIsoTkMu24Filter:
        def __get__(self):
            self.m2MatchesIsoTkMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu24Filter_value

    property m2MatchesIsoTkMu24Path:
        def __get__(self):
            self.m2MatchesIsoTkMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu24Path_value

    property m2MatchesMu23e12DZFilter:
        def __get__(self):
            self.m2MatchesMu23e12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu23e12DZFilter_value

    property m2MatchesMu23e12DZPath:
        def __get__(self):
            self.m2MatchesMu23e12DZPath_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu23e12DZPath_value

    property m2MatchesMu23e12Filter:
        def __get__(self):
            self.m2MatchesMu23e12Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu23e12Filter_value

    property m2MatchesMu23e12Path:
        def __get__(self):
            self.m2MatchesMu23e12Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu23e12Path_value

    property m2MatchesMu8e23DZFilter:
        def __get__(self):
            self.m2MatchesMu8e23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu8e23DZFilter_value

    property m2MatchesMu8e23DZPath:
        def __get__(self):
            self.m2MatchesMu8e23DZPath_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu8e23DZPath_value

    property m2MatchesMu8e23Filter:
        def __get__(self):
            self.m2MatchesMu8e23Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu8e23Filter_value

    property m2MatchesMu8e23Path:
        def __get__(self):
            self.m2MatchesMu8e23Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu8e23Path_value

    property m2MvaLoose:
        def __get__(self):
            self.m2MvaLoose_branch.GetEntry(self.localentry, 0)
            return self.m2MvaLoose_value

    property m2MvaMedium:
        def __get__(self):
            self.m2MvaMedium_branch.GetEntry(self.localentry, 0)
            return self.m2MvaMedium_value

    property m2MvaTight:
        def __get__(self):
            self.m2MvaTight_branch.GetEntry(self.localentry, 0)
            return self.m2MvaTight_value

    property m2PFChargedHadronIsoR04:
        def __get__(self):
            self.m2PFChargedHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m2PFChargedHadronIsoR04_value

    property m2PFChargedIso:
        def __get__(self):
            self.m2PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFChargedIso_value

    property m2PFIDLoose:
        def __get__(self):
            self.m2PFIDLoose_branch.GetEntry(self.localentry, 0)
            return self.m2PFIDLoose_value

    property m2PFIDMedium:
        def __get__(self):
            self.m2PFIDMedium_branch.GetEntry(self.localentry, 0)
            return self.m2PFIDMedium_value

    property m2PFIDTight:
        def __get__(self):
            self.m2PFIDTight_branch.GetEntry(self.localentry, 0)
            return self.m2PFIDTight_value

    property m2PFIsoLoose:
        def __get__(self):
            self.m2PFIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.m2PFIsoLoose_value

    property m2PFIsoMedium:
        def __get__(self):
            self.m2PFIsoMedium_branch.GetEntry(self.localentry, 0)
            return self.m2PFIsoMedium_value

    property m2PFIsoTight:
        def __get__(self):
            self.m2PFIsoTight_branch.GetEntry(self.localentry, 0)
            return self.m2PFIsoTight_value

    property m2PFIsoVeryLoose:
        def __get__(self):
            self.m2PFIsoVeryLoose_branch.GetEntry(self.localentry, 0)
            return self.m2PFIsoVeryLoose_value

    property m2PFIsoVeryTight:
        def __get__(self):
            self.m2PFIsoVeryTight_branch.GetEntry(self.localentry, 0)
            return self.m2PFIsoVeryTight_value

    property m2PFNeutralHadronIsoR04:
        def __get__(self):
            self.m2PFNeutralHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m2PFNeutralHadronIsoR04_value

    property m2PFNeutralIso:
        def __get__(self):
            self.m2PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFNeutralIso_value

    property m2PFPUChargedIso:
        def __get__(self):
            self.m2PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFPUChargedIso_value

    property m2PFPhotonIso:
        def __get__(self):
            self.m2PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFPhotonIso_value

    property m2PFPhotonIsoR04:
        def __get__(self):
            self.m2PFPhotonIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m2PFPhotonIsoR04_value

    property m2PFPileupIsoR04:
        def __get__(self):
            self.m2PFPileupIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m2PFPileupIsoR04_value

    property m2PVDXY:
        def __get__(self):
            self.m2PVDXY_branch.GetEntry(self.localentry, 0)
            return self.m2PVDXY_value

    property m2PVDZ:
        def __get__(self):
            self.m2PVDZ_branch.GetEntry(self.localentry, 0)
            return self.m2PVDZ_value

    property m2Phi:
        def __get__(self):
            self.m2Phi_branch.GetEntry(self.localentry, 0)
            return self.m2Phi_value

    property m2Pt:
        def __get__(self):
            self.m2Pt_branch.GetEntry(self.localentry, 0)
            return self.m2Pt_value

    property m2RelPFIsoDBDefault:
        def __get__(self):
            self.m2RelPFIsoDBDefault_branch.GetEntry(self.localentry, 0)
            return self.m2RelPFIsoDBDefault_value

    property m2RelPFIsoDBDefaultR04:
        def __get__(self):
            self.m2RelPFIsoDBDefaultR04_branch.GetEntry(self.localentry, 0)
            return self.m2RelPFIsoDBDefaultR04_value

    property m2SegmentCompatibility:
        def __get__(self):
            self.m2SegmentCompatibility_branch.GetEntry(self.localentry, 0)
            return self.m2SegmentCompatibility_value

    property m2TrkIsoDR03:
        def __get__(self):
            self.m2TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m2TrkIsoDR03_value

    property m2TypeCode:
        def __get__(self):
            self.m2TypeCode_branch.GetEntry(self.localentry, 0)
            return self.m2TypeCode_value

    property m2ZTTGenMatching:
        def __get__(self):
            self.m2ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.m2ZTTGenMatching_value

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

    property raw_pfMetEt:
        def __get__(self):
            self.raw_pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.raw_pfMetEt_value

    property raw_pfMetPhi:
        def __get__(self):
            self.raw_pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.raw_pfMetPhi_value

    property rho:
        def __get__(self):
            self.rho_branch.GetEntry(self.localentry, 0)
            return self.rho_value

    property run:
        def __get__(self):
            self.run_branch.GetEntry(self.localentry, 0)
            return self.run_value

    property singleIsoTkMu22Pass:
        def __get__(self):
            self.singleIsoTkMu22Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu22Pass_value

    property singleIsoTkMu22eta2p1Pass:
        def __get__(self):
            self.singleIsoTkMu22eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu22eta2p1Pass_value

    property singleIsoTkMu24Pass:
        def __get__(self):
            self.singleIsoTkMu24Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu24Pass_value

    property tauVetoPtDeepVtx:
        def __get__(self):
            self.tauVetoPtDeepVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPtDeepVtx_value

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

    property vbfMass:
        def __get__(self):
            self.vbfMass_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_value

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


