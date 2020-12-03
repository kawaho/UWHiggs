#include <string>
using namespace RooFit;

void makepdf(TH1F* hm, RooRealVar *mass, int mh, double result[]) {
     RooRealVar *a1_dcb = new RooRealVar("a1","a1", 1., 0.5, 2);   //.5, 2
     RooRealVar *a2_dcb = new RooRealVar("a2","a2", 1., 0.5, 2);   //.5, 2
     RooRealVar *dm_dcb = new RooRealVar("dm", "dm", -0.1,-.5,0.);  //0.5
     RooFormulaVar *mean_dcb = new RooFormulaVar("mean", "mean","(125+@0)",RooArgList(*dm_dcb));
     RooRealVar *n1_dcb = new RooRealVar("n1","n1", 3.5,2.,5.); //2,5
     RooRealVar *n2_dcb = new RooRealVar("n2","n2", 30., 10.,50.); //10,50
     RooRealVar *sigma_dcb = new RooRealVar("sigma","sigma", 2, 0.1, 2.5); //0.1,2.5
    RooAbsPdf *pdf = new RooDoubleCBFast("pdf", "pdf", *mass,*mean_dcb,*sigma_dcb, *a1_dcb, *n1_dcb, *a2_dcb, *n2_dcb);
     RooDataHist* dh = new RooDataHist("data", "data", RooArgList(*mass), Import(*hm));
     RooFitResult *fitResult = pdf->fitTo(*dh, Minimizer("Minuit2","minimize"), RooFit::Save(1), Range(mh - 15,mh + 15), SumW2Error(true));
     result[0] = a1_dcb->getVal();
     result[1] = a2_dcb->getVal();
     result[2] = mean_dcb->getVal();
     result[3] = n1_dcb->getVal();
     result[4] = n2_dcb->getVal();
     result[5] = sigma_dcb->getVal();
     result[8] = fitResult->minNll();
}
 

void fitDCB2() {
  gSystem->Load("/afs/hep.wisc.edu/user/kaho/CMSSW_10_2_16_UL/lib/slc7_amd64_gcc700/libHiggsAnalysisCombinedLimit.so");
  int mh = 125;
  RooRealVar *mass = new RooRealVar("CMS_emu_Mass", "m_{e#mu}", 110, 140, "GeV");
  TFile *file = new TFile("Reso_BDT.root");
  for (int i = 0; i < 10; i++){
    std::string h_name_base = "e_m_Mass_";
    std::string h_name = h_name_base + std::to_string(i);
    auto hm = static_cast<TH1F*> (file->Get(h_name.c_str()));
    double fitresult[9];
    makepdf(hm, mass, mh, fitresult);
  }
}
