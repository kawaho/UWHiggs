#include <string>
using namespace RooFit;

void makepdf(RooWorkspace *w, TH1F* hm, RooRealVar *mass, int mh, const char* cat, const char* sysname, double result[], double rangescale = 1, bool buildcbpg = 0, bool saveplot = 0, double constr[] = NULL, std::string fixparm = "") {
  vector<string> fixparm_arr;
  stringstream ss(fixparm);
  while(ss.good())
  {
      string substr;
      getline(ss, substr, ',');
      fixparm_arr.push_back(substr);
  }

   hm->Rebin(50);
   RooDataHist* dh = new RooDataHist("dh_", "dh_", RooArgList(*mass), Import(*hm));
   RooAbsPdf *pdf;
   if (buildcbpg) {
     RooRealVar *dm_cb = new RooRealVar(Form("dm_mh_%s_cb_%s",cat,sysname),Form("dm_mh%d_cb",mh), -1, -2, 0.);
     //-1, -2.4, 0. 2016
     RooFormulaVar *mean_cb = new RooFormulaVar(Form("mean_mh%s_cb_%s",cat,sysname),Form("mean_mh%d_cb",mh),"125+@0", RooArgList(*dm_cb));
     RooRealVar *sigma_cb = new RooRealVar(Form("sigma_mh_%s_cb_%s",cat,sysname),Form("sigma_mh%d_cb",mh),2.5,1,5);
     // 3,2,4 2016
     RooRealVar *a_cb = new RooRealVar(Form("a_mh_%s_cb_%s",cat,sysname),Form("a_mh%d_cb",mh), 1, 0.1 ,4);
     // 1, 0.8 ,2 2016
     RooRealVar *n_cb = new RooRealVar(Form("n_mh_%s_cb_%s",cat,sysname),Form("n_mh%d_cb",mh), 1.5,1,4);
     // 2,0.1,3 2016
     RooCBShape *pdf_cb = new RooCBShape(Form("cb_mh_%s_%s",cat,sysname),Form("cb_mh_%s_%s",cat,sysname), *mass,*mean_cb,*sigma_cb, *a_cb,*n_cb);

     RooRealVar *dm_gaus = new RooRealVar(Form("dm_mh_%s_gaus_%s",cat,sysname),Form("dm_mh%d_gaus",mh), -0.3,-0.8,0.);
     //  -0.3,-0.5,0. 2016
     RooFormulaVar *mean_gaus = new RooFormulaVar(Form("mean_mh%s_gaus_%s",cat,sysname),Form("mean_mh%d_gaus",mh),"125+@0", RooArgList(*dm_gaus));
     RooRealVar *sigma_gaus = new RooRealVar(Form("sigma_mh_%s_gaus_%s",cat,sysname),Form("sigma_mh%d_gaus",mh), 1,0.1,2);
     // 1.5,0.5,2 2016
     RooGaussian *pdf_gaus = new RooGaussian(Form("gaus_mh_%s_%s",cat,sysname),Form("gaus_mh_%s_%s",cat,sysname),*mass,*mean_gaus,*sigma_gaus);
     RooRealVar *frac_gaus = new RooRealVar(Form("frac_mh_%s_%s",cat,sysname),Form("frac_mh_%s_%s",cat,sysname),0.5,0.1,0.9);
    if (constr != NULL) {
      double a_cb_low = ((constr[0] - constr[0]*rangescale) >= 0) ? (constr[0] - constr[0]*rangescale) : 0;
      double n_cb_low = ((constr[1] - constr[1]*rangescale) >= 0) ? (constr[1] - constr[1]*rangescale) : 0;
      double sigma_cb_low = ((constr[3] - constr[3]*rangescale) >= 0) ? (constr[3] - constr[3]*rangescale) : 0;
      double sigma_gaus_low = ((constr[5] - constr[5]*rangescale) >= 0) ? (constr[5] - constr[5]*rangescale) : 0;
      a_cb->setRange(a_cb_low, constr[0] + constr[0]*rangescale);
      n_cb->setRange(n_cb_low, constr[1] + constr[1]*rangescale);
      dm_cb->setRange(constr[2] - 125 + (constr[2]-125)*rangescale, constr[2] - (constr[2]-125)*rangescale-125);
      sigma_cb->setRange(sigma_cb_low, constr[3] + constr[3]*rangescale);
      dm_gaus->setRange(constr[4] + (constr[4] - 125)*rangescale - 125, constr[4] - (constr[4] - 125)*rangescale - 125);
      sigma_gaus->setRange(sigma_gaus_low, constr[5] + constr[5]*rangescale);
//      frac_gaus->setRange(constr[6] - constr[6]*rangescale, constr[6] + constr[6]*rangescale);
    
   
      for(auto parm : fixparm_arr) {

        if (parm == "a") {
          a_cb->setVal(constr[0]);
          a_cb->setConstant(kTRUE);
        }
        else if (parm == "n") {
          n_cb->setVal(constr[1]);
          n_cb->setConstant(kTRUE);
        }
        else if (parm == "dmc") {
          dm_cb->setVal(constr[2]-125);
          dm_cb->setConstant(kTRUE);
        }
        else if (parm == "sigmac") {
          sigma_cb->setVal(constr[3]);
          sigma_cb->setConstant(kTRUE);
        }
        else if (parm == "dmg") {
          dm_gaus->setVal(constr[4]-125);
          dm_gaus->setConstant(kTRUE);
        }
        else if (parm =="sigmag") {
          sigma_gaus->setVal(constr[5]);
          sigma_gaus->setConstant(kTRUE);
        }
        else if (parm == "frac") {
          frac_gaus->setVal(constr[6]);
          frac_gaus->setConstant(kTRUE);
        }
      } 
   }

     pdf = new RooAddPdf(Form("cbpg_mh_%s%s",cat,sysname),Form("cbpg_mh_%s_%s",cat,sysname),*pdf_cb,*pdf_gaus,*frac_gaus);
     RooFitResult *fitResult = pdf->fitTo(*dh, Minimizer("Minuit2","minimize"), RooFit::Save(1), Range(mh - 15,mh + 15), SumW2Error(kTRUE));
     result[0] = a_cb->getVal();
     result[1] = n_cb->getVal();
     result[2] = mean_cb->getVal();
     result[3] = sigma_cb->getVal();
     result[4] = mean_gaus->getVal();
     result[5] = sigma_gaus->getVal();
     result[6] = frac_gaus->getVal();
     result[8] = fitResult->minNll();
   }
   else{
     RooRealVar *a1_dcb = new RooRealVar(Form("a1_mh_%s_dcb_%s",cat,sysname),Form("a1_mh%d_dcb",mh), 1, 0.1, 3);   
     RooRealVar *a2_dcb = new RooRealVar(Form("a2_mh_%s_dcb_%s",cat,sysname),Form("a2_mh%d_dcb",mh), 1, 0.1, 3);   
     RooRealVar *dm_dcb = new RooRealVar(Form("dm_mh_%s_dcb_%s",cat,sysname),Form("dm_mh%d_dcb",mh), -0.1,-1,0.1);
     RooFormulaVar *mean_dcb = new RooFormulaVar(Form("mean_mh%s_dcb_%s",cat,sysname),Form("mean_mh%d_dcb",mh),"125+@0",RooArgList(*dm_dcb));
     RooRealVar *n1_dcb = new RooRealVar(Form("n1_mh_%s_dcb_%s",cat,sysname),Form("n1_mh%d_dcb",mh), 3.,2,8);
     RooRealVar *n2_dcb = new RooRealVar(Form("n2_mh_%s_dcb_%s",cat,sysname),Form("n2_mh%d_dcb",mh), 10.,0.,50);
     RooRealVar *sigma_dcb = new RooRealVar(Form("sigma_mh_%s_dcb_%s",cat,sysname),Form("sigma_mh%d_dcb",mh), 2, 0, 5); 

     pdf = new RooDoubleCBFast(Form("dcb_mh_%s_%s",cat,sysname),Form("dcb_mh_%s_%s",cat,sysname), *mass,*mean_dcb,*sigma_dcb, *a1_dcb, *n1_dcb, *a2_dcb, *n2_dcb);
     RooFitResult *fitResult = pdf->fitTo(*dh, Minimizer("Minuit2","minimize"), RooFit::Save(1), Range(mh - 15,mh + 15), SumW2Error(kTRUE));
     result[0] = a1_dcb->getVal();
     result[1] = a2_dcb->getVal();
     result[2] = mean_dcb->getVal();
     result[3] = n1_dcb->getVal();
     result[4] = n2_dcb->getVal();
     result[5] = sigma_dcb->getVal();
     result[8] = fitResult->minNll();
   }
 
   
   RooPlot *frame = mass->frame(Range("higgsRange"), Title(" "));
   dh->plotOn(frame, CutRange("higgsRange"));
   double numofevent = dh->sumEntries("1", "higgsRange");
   RooRealVar* nevent = new RooRealVar(Form("nevent_%s",cat),"number of events", numofevent);
   RooExtendPdf* pdf2 = new RooExtendPdf(Form("dcb_mh_%s_ext%s",cat,sysname),Form("dcb_mh_%s_ext_%s",cat,sysname),*pdf,*nevent);
   w->import(*pdf2); 
   pdf->plotOn(frame,Normalization(dh->sumEntries("1", "higgsRange"), RooAbsReal::NumEvent), NormRange("higgsRange"), Range("higgsRange"));
   std::cout << "chi2/dof:" << frame->chiSquare(buildcbpg?7:6) << std::endl;
   result[7] = frame->chiSquare(buildcbpg?7:6);
   if (saveplot) {
     TCanvas canvas = TCanvas("canvas","canvas",800,800);
     TLatex latex = TLatex();
     latex.SetNDC();
     latex.SetTextFont(43);
     latex.SetTextSize(20);
     latex.SetTextAlign(31);
     latex.SetTextAlign(11);
     TString label_text("#bf{CMS Preliminary}");
     TString year("2016+2017");
     TString data_text("35.9 + 41.5 fb^{-1}");
     data_text += " (2016 + 2017,";
     data_text += " 13 TeV)";
     TString jets_text("e#mu ");
     jets_text.Append(cat);
     TString txt("#chi^{2} / ndf = ");
     txt += Form("%.2f / %i",frame->chiSquare()*dh->numEntries(), dh->numEntries()-7);
     frame->Draw();
     gPad->SetLeftMargin(0.13);
     latex.DrawLatex(0.65, 0.80, txt);
     latex.DrawLatex(0.16, 0.84, label_text);
     latex.DrawLatex(0.52, 0.91, data_text);
     std::string pngname = cat;
     std::string sub = sysname;
     std::string label2 = cat;
     label2 += " " + sub;
     latex.DrawLatex(0.16, 0.80, label2.c_str());
     pngname = "SigSys/" + pngname + sub + "_DCB.png"; 
     
     canvas.SaveAs(pngname.c_str());
   }
}



void fitDCB(bool dosys = 0, bool buildcbpg = 1, int whichcat = -1, std::string whichsys = "" , std::string fixparm = "", double rangescale = 1) {
  gSystem->Load("/afs/hep.wisc.edu/user/kaho/CMSSW_10_2_16_UL/lib/slc7_amd64_gcc700/libHiggsAnalysisCombinedLimit.so");
  RooWorkspace *w = new RooWorkspace("wsig_13TeV","wsig_13TeV");
  int mh = 125;
  RooRealVar *mass = new RooRealVar("CMS_emu_Mass", "m_{e#mu}", 110, 160, "GeV");
  mass->setRange("higgsRange",110.,140.);

  RooRealVar lumi("IntLumi", "Integrated luminosity", 35.87, "fb^{-1}");
  w->import(lumi);

  TFile *file = new TFile("results/Data2016JEC/AnalyzeEMSys/Signal.root");
  std::string catname[4] = {"TightOSggcat0/", "TightOSggcat1/", "TightOSggcat2/", "TightOSvbf/"};
  std::string cat[4] = {"gg0", "gg1", "gg2", "vbf"};
  std::string sysname[8] = {"eesUp", "eesDown", "mes1p2Up", "mes1p2Down", "mes2p1Up", "mes2p1Down", "mes2p4Up", "mes2p4Down"};
  std::string emstr = "/e_m_Mass";
  for (int i = 0; i < 4; i++) {
//    int i = 0;
    if (i != whichcat and whichcat != -1) { continue; }
    std::string dir_name = catname[i] + emstr;
    auto hm = static_cast<TH1F*> (file->Get(dir_name.c_str()));
    const char* empty = "\0";
    double fitresult[9];
    makepdf(w, hm, mass, mh, cat[i].c_str(), empty, fitresult, rangescale, buildcbpg, 1);
    int start_ = 0;
    int end_ = 8;
    if (dosys) {
      if (whichsys == "e") {
        start_ = 0;
        end_ = 2;
      }
      else if (whichsys == "m1") {
        start_ = 2;
        end_ = 4;
      }
      else if (whichsys == "m2") {
        start_ = 4;
        end_ = 6;
      }
      else if (whichsys == "m3") {
        start_ = 6;
        end_ = 8;
      }
     
      for (int j = start_; j < end_; j++) {
        std::string dir_name_sys = catname[i] + sysname[j] + emstr;
        auto hm = static_cast<TH1F*> (file->Get(dir_name_sys.c_str()));
        double fitresult_sys[9];
        makepdf(w, hm, mass, mh, cat[i].c_str(), sysname[j].c_str(), fitresult_sys, rangescale, buildcbpg, 1 , fitresult, fixparm);
        cout << "Changes in: " << sysname[j].c_str() << endl;

        if (buildcbpg) { 
          cout << "Changes in a: " << (fitresult_sys[0] - fitresult[0])*100/fitresult[0] << endl;
          cout << "Changes in n: " << (fitresult_sys[1] - fitresult[1])*100/fitresult[1] << endl;
          cout << "Changes in mean_cb: " << (fitresult_sys[2] - fitresult[2])*100/fitresult[2] << endl;
          cout << "Changes in sigma_cb: " << (fitresult_sys[3] - fitresult[3])*100/fitresult[3] << endl;
          cout << "Changes in mean_gaus: " << (fitresult_sys[4] - fitresult[4])*100/fitresult[4] << endl;
          cout << "Changes in sigma_gaus: " << (fitresult_sys[5] - fitresult[5])*100/fitresult[5] << endl;
          cout << "Changes in frac_gaus: " << (fitresult_sys[6] - fitresult[6])*100/fitresult[5] << endl;
          cout << "Changes in chi2: " << (fitresult_sys[7] - fitresult[7])*100/fitresult[7] << endl;
          cout << "Changes in NLL: " << (fitresult_sys[8] - fitresult[8])*100/fitresult[8] << endl;
        }
        else {
          cout << "Changes in a1: " << (fitresult_sys[0] - fitresult[0])*100/fitresult[0] << endl;
          cout << "Changes in a2: " << (fitresult_sys[1] - fitresult[1])*100/fitresult[1] << endl;
          cout << "Changes in mean: " << (fitresult_sys[2] - fitresult[2])*100/fitresult[2] << endl;
          cout << "Changes in n1: " << (fitresult_sys[3] - fitresult[3])*100/fitresult[3] << endl;
          cout << "Changes in n2: " << (fitresult_sys[4] - fitresult[4])*100/fitresult[4] << endl;
          cout << "Changes in sigma: " << (fitresult_sys[5] - fitresult[5])*100/fitresult[5] << endl;
          cout << "Changes in chi2: " << (fitresult_sys[7] - fitresult[7])*100/fitresult[7] << endl;
          cout << "Changes in NLL: " << (fitresult_sys[8] - fitresult[8])*100/fitresult[8] << endl;
        }
      }
    }
}

  
//  for (TObject* keyAsObj : *(file->GetListOfKeys())){
//    auto key = dynamic_cast<TKey*>(keyAsObj);
//    auto dir_ = (TDirectory*) key->ReadObj();
//    TString* cat = new TString(dir_->GetName());
//    cat->ReplaceAll("TightOS", "");
//    std::cout << *cat << std::endl;
//    for (TObject* keyAsObj2 : *(dir_->GetListOfKeys())){
//      auto key2 = dynamic_cast<TKey*>(keyAsObj2);
//      TString hname(key2->GetName());
//      if (not hname.CompareTo("e_m_Mass")){ // and not cat->CompareTo("ggcat2")){
//        auto *hm = static_cast<TH1F*> (key2->ReadObj());
//      }
//    }
//  }
//  w->writeToFile("FitSig.root");
//  w->Print();
}
