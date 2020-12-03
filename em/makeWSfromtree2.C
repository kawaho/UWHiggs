#include "RooRealVar.h"
#include "RooDataSet.h"
#include "RooConstVar.h"
#include "RooWorkspace.h"
#include "TCanvas.h"
#include "TFile.h"
#include<string>

void makeWSfromtree2() {
  const int ncats = 6;
  RooRealVar mass("CMS_emu_Mass", "m_{e#mu}", 125, 110, 160, "GeV");
  RooRealVar lumi("IntLumi", "Integrated luminosity", 35.87, "fb^{-1}");
  RooRealVar sqrts("SqrtS","Center of Mass Energy", 13, "TeV");
  RooDataSet * dataset[ncats] = {};
//string catname[ncats] =  {"TightOSvbf00", "TightOSgg00", "TightOSvbf10", "TightOSgg10", "TightOSvbf20", "TightOSgg20", "TightOSvbf30", "TightOSgg30", "TightOSvbf01", "TightOSgg01", "TightOSvbf11", "TightOSgg11", "TightOSvbf21", "TightOSgg21", "TightOSvbf31", "TightOSgg31", "TightOSvbf02", "TightOSgg02", "TightOSvbf12", "TightOSgg12", "TightOSvbf22", "TightOSgg22", "TightOSvbf32", "TightOSgg32", "TightOSvbf03", "TightOSgg03", "TightOSvbf13", "TightOSgg13", "TightOSvbf23", "TightOSgg23", "TightOSvbf33", "TightOSgg33", "TightOSvbf04", "TightOSgg04", "TightOSvbf14", "TightOSgg14", "TightOSvbf24", "TightOSgg24", "TightOSvbf34", "TightOSgg34"};
  string catname[ncats] = {"ggcat0","ggcat1","ggcat2","ggcat3","ggcat4","vbf"};//, "0JetEE", "1JetEB-MB", "1JetEB-ME", "1JetEE", "2JetEB-MB", "2JetEB-ME", "2JetEE", "2JetVBF"};
  for (int i = 0; i < ncats; i++){
    string temp = "Data_13TeV_" + catname[i]; //std::to_string(i);
    char * histname = new char [temp.length()+1];
    strcpy (histname, temp.c_str());
    dataset[i] =  new RooDataSet(histname, histname,  RooArgList(mass));
  }
  TFile *file = new TFile("data.root");
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
    if (cat != ncats){
    dataset[cat]->add(RooArgList(mass), weight);
    }
  }
  RooWorkspace *w = new RooWorkspace("CMS_emu_workspace", "CMS_emu_workspace");
  w->import(lumi);
  w->import(sqrts);
  for (int i = 0; i < ncats; i++){
    w->import(*dataset[i]);
  }
  w->writeToFile("dataws.root");
  w->Print();
}
