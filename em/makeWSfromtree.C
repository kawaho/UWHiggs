#include "RooRealVar.h"
#include "RooDataSet.h"
#include "RooConstVar.h"
#include "RooWorkspace.h"
#include "TCanvas.h"
#include "TFile.h"
#include<string>

void makeWSfromtree() {
  const int ncats = 5;
  RooRealVar mass("CMS_emu_Mass", "M_{e#mu}", 125, 110, 160, "GeV");
//  mass.setUnit("GeV/c^{2}");
  RooRealVar lumi("IntLumi", "Integrated luminosity", 35.87, "fb^{-1}");
  RooRealVar sqrts("SqrtS","Center of Mass Energy", 13, "TeV");
  RooDataSet * dataset[ncats] = {};
  string catname[ncats] = {"gg0","gg1","gg2","gg3","vbf"};
  for (int i = 0; i < ncats; i++){
    string temp = "Signal_13TeV_" + catname[i]; //std::to_string(i);
    char * histname = new char [temp.length()+1];
    strcpy (histname, temp.c_str());
    dataset[i] =  new RooDataSet(histname, histname,  RooArgList(mass));
  }
  TFile *file = new TFile("/afs/hep.wisc.edu/user/kaho/CMSSW_10_2_16_UL/src/UWHiggs2016/em/results/Data2016JEC/AnalyzeEMTree/Signal.root");
  TTree *tree = (TTree*)file->Get("opttree");
  float e_m_Mass;
  int cat;
  float weight;
  tree->SetBranchAddress("e_m_Mass", &e_m_Mass);
  tree->SetBranchAddress("cat", &cat);
  tree->SetBranchAddress("weight", &weight);
  int entries = tree->GetEntries();
  for (int i = 0; i < entries; i++){
    tree->GetEntry(i);
    if (weight == 0){ continue; }
    mass.setVal(e_m_Mass);
    dataset[cat]->add(RooArgList(mass), weight);
  }
  RooWorkspace *w = new RooWorkspace("CMS_emu_workspace", "CMS_emu_workspace");
  w->import(lumi);
  w->import(sqrts);
  for (int i = 0; i < ncats; i++){
    w->import(*dataset[i]);
  }
  w->writeToFile("signalws.root");
  w->Print();
}
