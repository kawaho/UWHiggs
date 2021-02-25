#include "RooRealVar.h"
#include "RooDataSet.h"
#include "RooConstVar.h"
#include "RooWorkspace.h"
#include "TCanvas.h"
#include "TFile.h"
#include<string>

void makeWSfromtree2() {
  const int ncats = 8;
  RooRealVar mass("CMS_emu_Mass", "m_{e#mu}", 125, 110, 160, "GeV");
  RooRealVar lumi("IntLumi", "Integrated luminosity", 35.87, "fb^{-1}");
  RooRealVar sqrts("SqrtS","Center of Mass Energy", 13, "TeV");
  RooDataSet * dataset[ncats] = {};

  string catname[ncats] = {"ggcat0","ggcat1","ggcat2","ggcat3","ggcat4","vbfcat0","vbfcat1","vbf"};
//  string catname[ncats] = {"vbfcat0","vbfcat1","ggcat0","ggcat1","ggcat2","ggcat3","ggcat4","ggcat5","ggcat6"};
//  string catname[ncats] = {"vbfcat0","vbfcat1","vbfcat2","vbfcat3","vbfcat4","vbfcat5","vbfcat6","vbfcat7","vbfcat8","vbfcat9","vbfcat10","vbfcat11","vbfcat12","vbfcat13","vbfcat14","vbfcat15","vbf"};
  for (int i = 0; i < ncats; i++){
    string temp = "Data_13TeV_" + catname[i]; //std::to_string(i);
    char * histname = new char [temp.length()+1];
    strcpy (histname, temp.c_str());
    dataset[i] =  new RooDataSet(histname, histname,  RooArgList(mass));
  }
  TFile *file = new TFile("data_or2_stat.root");
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
  w->writeToFile("dataws_or2_stat.root");
  w->Print();
}
