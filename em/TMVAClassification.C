#include <cstdlib>
#include <iostream>
#include <map>
#include <string>
#include "TChain.h"
#include "TFile.h"
#include "TTree.h"
#include "TString.h"
#include "TObjString.h"
#include "TSystem.h"
#include "TROOT.h"
#include "TMVA/Factory.h"
#include "TMVA/DataLoader.h"
#include "TMVA/Tools.h"
#include "TMVA/TMVAGui.h"
int TMVAClassification( TString myMethodList = "" )
{
  TMVA::Tools::Instance();
  std::map<std::string,int> Use;
  // Boosted Decision Trees
  Use["BDT"]             = 1; // uses Adaptive Boost
  Use["BDTG"]            = 0; // uses Gradient Boost
  Use["BDTB"]            = 0; // uses Bagging
  Use["BDTD"]            = 0; // decorrelation + Adaptive Boost
  Use["BDTF"]            = 0; // allow usage of fisher discriminant for node splitting
  // ---------------------------------------------------------------
  std::cout << std::endl;
  std::cout << "==> Start TMVAClassification" << std::endl;
  // Select methods (don't look at this code - not of interest)
  if (myMethodList != "") {
    for (std::map<std::string,int>::iterator it = Use.begin(); it != Use.end(); it++) it->second = 0;
    std::vector<TString> mlist = TMVA::gTools().SplitString( myMethodList, ',' );
    for (UInt_t i=0; i<mlist.size(); i++) {
      std::string regMethod(mlist[i]);
      if (Use.find(regMethod) == Use.end()) {
	std::cout << "Method \"" << regMethod << "\" not known in TMVA under this name. Choose among the following:" << std::endl;
	for (std::map<std::string,int>::iterator it = Use.begin(); it != Use.end(); it++) std::cout << it->first << " ";
	std::cout << std::endl;
	return 1;
      }
      Use[regMethod] = 1;
    }
  }
  // --------------------------------------------------------------------------------------------------
  TString fname = "BDT/BDT_single.root";
  if (gSystem->AccessPathName( fname ))  // file does not exist in local directory
    gSystem->Exec("curl -O http://root.cern.ch/files/tmva_class_example.root");
  TFile *input = TFile::Open( fname );
  std::cout << "--- TMVAClassification       : Using input file: " << input->GetName() << std::endl;
  // Register the training and test trees
  TTree *signalTree     = (TTree*)input->Get("TreeS");
  TTree *background     = (TTree*)input->Get("TreeB");
  // Create a ROOT output file where TMVA will store ntuples, histograms, etc.
  TString outfileName( "TMVA_gg_opt.root" );
  TFile* outputFile = TFile::Open( outfileName, "RECREATE" );

  TMVA::Factory *factory = new TMVA::Factory( "TMVAClassification", outputFile,
					      "!V:!Silent:Color:DrawProgressBar:Transformations=I;D;P;G,D:AnalysisType=Classification" );
  TMVA::DataLoader *dataloader=new TMVA::DataLoader("dataset");
/*
  dataloader->AddVariable("emPt", 'F');
  dataloader->AddVariable("emEta", 'F');
  dataloader->AddVariable("DeltaEta_e_m", 'F');
  dataloader->AddVariable("DeltaPhi_e_m", 'F');
  dataloader->AddVariable("absEta_e", 'F');
  dataloader->AddVariable("absEta_m", 'F');
  dataloader->AddVariable("m_met_mT_per_M", 'F');
  dataloader->AddVariable("e_met_mT_per_M", 'F');
  dataloader->AddVariable("DeltaPhi_e_met", 'F');
  dataloader->AddVariable("DeltaPhi_m_met", 'F');
  dataloader->AddVariable("MetEt", 'F');
  dataloader->AddVariable("e_m_PZeta", 'F');
  dataloader->AddVariable("j1Pt", 'F');
  dataloader->AddVariable("DeltaEta_em_j1", 'F');
  dataloader->AddVariable("DeltaPhi_em_j1", 'F');
  dataloader->AddVariable("j2Pt", 'F');
  dataloader->AddVariable("DeltaEta_em_j2", 'F');
  dataloader->AddVariable("DeltaPhi_em_j2", 'F');
  dataloader->AddVariable("DeltaEta_j1_j2", 'F');
  dataloader->AddVariable("DeltaPhi_j1_j2", 'F');
  dataloader->AddVariable("j1_j2_mass", 'F');
*/

//  dataloader->AddVariable("e_m_Mass", 'F');
  dataloader->AddVariable("mPt_Per_e_m_Mass", 'F');//
  dataloader->AddVariable("ePt_Per_e_m_Mass", 'F');//
//  dataloader->AddVariable("ePt_Per_mPt", 'F');
//  dataloader->AddVariable("emRapidity", 'F');
//  dataloader->AddVariable("emPt", 'F');
  dataloader->AddVariable("emEta", 'F');//
//  dataloader->AddVariable("mEta", 'F');
//  dataloader->AddVariable("eEta", 'F');
  dataloader->AddVariable("DeltaR_e_m", 'F');//
//  dataloader->AddVariable("DeltaEta_e_m", 'F');
//  dataloader->AddVariable("DeltaPhi_e_m", 'F');
//  dataloader->AddVariable("absEta_e", 'F');
//  dataloader->AddVariable("absEta_m", 'F');

//  dataloader->AddVariable("m_met_mT", 'F');
//  dataloader->AddVariable("e_met_mT", 'F');
  dataloader->AddVariable("m_met_mT_per_M", 'F');//
  dataloader->AddVariable("e_met_mT_per_M", 'F');//
//  dataloader->AddVariable("DeltaPhi_e_met", 'F');
//  dataloader->AddVariable("DeltaPhi_m_met", 'F');
  dataloader->AddVariable("MetEt", 'F');//
//  dataloader->AddVariable("e_m_PZeta", 'F');

  dataloader->AddVariable("j1Pt", 'F');//
  dataloader->AddVariable("j1Eta", 'F');//

//  dataloader->AddVariable("DeltaEta_em_j1", 'F');
//  dataloader->AddVariable("DeltaPhi_em_j1", 'F');
//  dataloader->AddVariable("DeltaEta_m_j1", 'F');
//  dataloader->AddVariable("DeltaPhi_m_j1", 'F');
//  dataloader->AddVariable("DeltaEta_e_j1", 'F');
//  dataloader->AddVariable("DeltaPhi_e_j1", 'F');

  dataloader->AddVariable("DeltaR_em_j1", 'F');//
//  dataloader->AddVariable("DeltaR_e_j1", 'F');
//  dataloader->AddVariable("DeltaR_m_j1", 'F');

  dataloader->AddVariable("j2Pt", 'F');//
  dataloader->AddVariable("j2Eta", 'F');//
//  dataloader->AddVariable("DeltaEta_em_j2", 'F');
//  dataloader->AddVariable("DeltaPhi_em_j2", 'F');
//  dataloader->AddVariable("DeltaEta_m_j2", 'F');
//  dataloader->AddVariable("DeltaPhi_m_j2", 'F');
//  dataloader->AddVariable("DeltaEta_e_j2", 'F');
//  dataloader->AddVariable("DeltaPhi_e_j2", 'F');
  dataloader->AddVariable("DeltaR_em_j2", 'F');//
//  dataloader->AddVariable("DeltaR_e_j2", 'F');
//  dataloader->AddVariable("DeltaR_m_j2", 'F');

//  dataloader->AddVariable("DeltaEta_j1_j2", 'F');
//  dataloader->AddVariable("DeltaPhi_j1_j2", 'F');
//  dataloader->AddVariable("DeltaR_j1_j2", 'F');

//  dataloader->AddVariable("DeltaR_em_j1j2", 'F');
//  dataloader->AddVariable("Zeppenfeld", 'F');
//  dataloader->AddVariable("j1_j2_mass", 'F');
//  dataloader->AddVariable("minDeltaPhi_em_j1j2", 'F');
//  dataloader->AddVariable("minDeltaEta_em_j1j2", 'F');
//  dataloader->AddVariable("Nj", 'I');

  dataloader->AddVariable("R_pT", 'F');//
//  dataloader->AddVariable("pT_cen", 'F');  
//  dataloader->AddVariable("cen", 'F');  
//  dataloader->AddVariable("Ht", 'F');  

  Double_t signalWeight     = 1.0;
  Double_t backgroundWeight = 1.0;

  dataloader->AddSignalTree    ( signalTree,     signalWeight );
  dataloader->AddBackgroundTree( background, backgroundWeight );

  dataloader->SetSignalWeightExpression( "weight" );
  dataloader->SetBackgroundWeightExpression( "weight" );

  // Apply additional cuts on the signal and background samples (can be different)
  TCut mycuts = "e_m_Mass<135 & e_m_Mass>115 & !(Nj==2. & j1_j2_mass>400 & DeltaEta_j1_j2 > 2.5)";
  TCut mycutb = "e_m_Mass<135 & e_m_Mass>115 & !(Nj==2. & j1_j2_mass>400 & DeltaEta_j1_j2 > 2.5)";
//  TCut mycuts = "e_m_Mass<135 & e_m_Mass>115 & (Nj==2 & j1_j2_mass>400)";
//  TCut mycutb = "e_m_Mass<135 & e_m_Mass>115 & (Nj==2 & j1_j2_mass>400)";
//  TCut mycuts = "e_m_Mass<135 & e_m_Mass>115 & Nj==2";
//  TCut mycutb = "e_m_Mass<135 & e_m_Mass>115 & Nj==2";



  dataloader->PrepareTrainingAndTestTree( mycuts, mycutb,
					  "SplitMode=Random:NormMode=NumEvents:!V"); //::nTrain_Signal=825171=:nTrain_Background=209339" ); //nTrain_Signal=166977:nTrain_Background=8767");//:nTrain_Signal=872122:nTrain_Background=224141" ); 

  // Boosted Decision Trees
  if (Use["BDTG"]) // Gradient Boost
    factory->BookMethod( dataloader, TMVA::Types::kBDT, "BDTG_vbf",
			 "!H:!V:NTrees=850:MinNodeSize=3%:BoostType=Grad:Shrinkage=0.1:UseBaggedBoost:BaggedSampleFraction=0.5:nCuts=30:MaxDepth=3"); //:IgnoreNegWeightsInTraining");  //InverseBoostNegWeights");
   // factory->BookMethod( dataloader, TMVA::Types::kBDT, "BDTG_vbf",
//			 "!H:!V:NTrees=850:MinNodeSize=3%:BoostType=Grad:Shrinkage=0.1:UseBaggedBoost:BaggedSampleFraction=0.5:nCuts=30:MaxDepth=3:NegWeightTreatment=IgnoreNegWeightsInTraining");
  if (Use["BDT"])  // Adaptive Boost
    factory->BookMethod( dataloader, TMVA::Types::kBDT, "BDT_gg_opt",
			 "!H:!V:NTrees=850:MinNodeSize=2.5%:MaxDepth=3:BoostType=AdaBoost:AdaBoostBeta=0.5:UseBaggedBoost:BaggedSampleFraction=0.5:SeparationType=GiniIndex:nCuts=20:PruneMethod=NoPruning" );
  if (Use["BDTB"]) // Bagging
    factory->BookMethod( dataloader, TMVA::Types::kBDT, "BDTB",
			 "!H:!V:NTrees=400:BoostType=Bagging:SeparationType=GiniIndex:nCuts=20" );
  if (Use["BDTD"]) // Decorrelation + Adaptive Boost
    factory->BookMethod( dataloader, TMVA::Types::kBDT, "BDTD",
			 "!H:!V:NTrees=400:MinNodeSize=5%:MaxDepth=3:BoostType=AdaBoost:SeparationType=GiniIndex:nCuts=20:VarTransform=Decorrelate" );
  if (Use["BDTF"])  // Allow Using Fisher discriminant in node splitting for (strong) linearly correlated variables
    factory->BookMethod( dataloader, TMVA::Types::kBDT, "BDTF",
			 "!H:!V:NTrees=100:MinNodeSize=2.5%:UseFisherCuts:MaxDepth=3:BoostType=AdaBoost:AdaBoostBeta=0.5:SeparationType=GiniIndex:nCuts=20:PruneMethod=NoPruning" );
  // Train MVAs using the set of training events
  factory->TrainAllMethods();
  // Evaluate all MVAs using the set of test events
  factory->TestAllMethods();
  // Evaluate and compare performance of all configured MVAs
  factory->EvaluateAllMethods();
  // --------------------------------------------------------------
  // Save the output
  outputFile->Close();
  std::cout << "==> Wrote root file: " << outputFile->GetName() << std::endl;
  std::cout << "==> TMVAClassification is done!" << std::endl;
  delete factory;
  delete dataloader;
  // Launch the GUI for the root macros
  if (!gROOT->IsBatch()) TMVA::TMVAGui( outfileName );
  return 0;
}
int main( int argc, char** argv )
{
  // Select methods (don't look at this code - not of interest)
  TString methodList;
  for (int i=1; i<argc; i++) {
    TString regMethod(argv[i]);
    if(regMethod=="-b" || regMethod=="--batch") continue;
    if (!methodList.IsNull()) methodList += TString(",");
    methodList += regMethod;
  }
  return TMVAClassification(methodList);
}
