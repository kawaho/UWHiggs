#include <string>
using namespace RooFit;

void makepdf(bool is_sys, const char* proc, RooWorkspace *w, TH1F* hm, RooRealVar *mass, int mh, const char* cat, const char* sysname, double result[], double rangescale = 1, int buildcbpg = 0, bool saveplot = 0, double constr[] = NULL, std::string fixparm = "") {
  vector<string> fixparm_arr;
  stringstream ss(fixparm);
  while(ss.good())
  {
      string substr;
      getline(ss, substr, ',');
      fixparm_arr.push_back(substr);
  }

   hm->Rebin(50);
   RooDataHist* dh = new RooDataHist(Form("data_%s_%s%s",cat, proc,sysname), Form("data_%s_%s%s",cat, proc,sysname), RooArgList(*mass), Import(*hm));
   RooAbsPdf *pdf;
   if (buildcbpg == 0) {
     RooRealVar *dm_cb = new RooRealVar(Form("dm_mh_%s_cb_%s",cat,sysname),Form("dm_mh%d_cb",mh), -1, -2, 0.);
     RooFormulaVar *mean_cb = new RooFormulaVar(Form("mean_mh%s_cb_%s",cat,sysname),Form("mean_mh%d_cb",mh),"125+@0", RooArgList(*dm_cb));
     RooRealVar *sigma_cb = new RooRealVar(Form("sigma_mh_%s_cb_%s",cat,sysname),Form("sigma_mh%d_cb",mh),2.5,1,5);
     RooRealVar *a_cb = new RooRealVar(Form("a_mh_%s_cb_%s",cat,sysname),Form("a_mh%d_cb",mh), 1, 0.1 ,3);
     RooRealVar *n_cb = new RooRealVar(Form("n_mh_%s_cb_%s",cat,sysname),Form("n_mh%d_cb",mh), 1.5,0.,5);
     RooCBShape *pdf_cb = new RooCBShape(Form("cb_mh_%s_%s",cat,sysname),Form("cb_mh_%s_%s",cat,sysname), *mass,*mean_cb,*sigma_cb, *a_cb,*n_cb);

     RooRealVar *dm_gaus = new RooRealVar(Form("dm_mh_%s_gaus_%s",cat,sysname),Form("dm_mh%d_gaus",mh), -0.3,-0.5,0.);
     RooFormulaVar *mean_gaus = new RooFormulaVar(Form("mean_mh%s_gaus_%s",cat,sysname),Form("mean_mh%d_gaus",mh),"125+@0", RooArgList(*dm_gaus));
     RooRealVar *sigma_gaus = new RooRealVar(Form("sigma_mh_%s_gaus_%s",cat,sysname),Form("sigma_mh%d_gaus",mh), 1,0.1,3);
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
     RooFitResult *fitResult = pdf->fitTo(*dh, Minimizer("Minuit2","minimize"), RooFit::Save(1), Range(mh - 15,mh + 15),SumW2Error(true));
     fitResult->correlationMatrix().Print();
     result[0] = a_cb->getVal();
     result[1] = n_cb->getVal();
     result[2] = mean_cb->getVal();
     result[3] = sigma_cb->getVal();
     result[4] = mean_gaus->getVal();
     result[5] = sigma_gaus->getVal();
     result[6] = frac_gaus->getVal();
     result[8] = fitResult->minNll();
   }
   else if (buildcbpg == 1) {
     RooRealVar *a1_dcb = new RooRealVar(Form("%s_%s_a1%s",cat,proc,sysname),Form("%s_%s_a1%s",cat,proc,sysname), 1, 0.5, 2);   //.5, 2
     RooRealVar *a2_dcb = new RooRealVar(Form("%s_%s_a2%s",cat,proc,sysname),Form("%s_%s_a2%s",cat,proc,sysname), 1., 0.5, 2);   //.5, 2
     RooRealVar *dm_dcb = new RooRealVar(Form("%s_%s_dm%s",cat,proc,sysname),Form("%s_%s_dm%s",cat,proc,sysname), -0.1,-.5,0.);  //0.5
     RooRealVar *mean_err_e = new RooRealVar("CMS_hem_nuisance_scale_e","CMS_hem_nuisance_scale_e", 0., -1., 1.);
     RooRealVar *mean_err_m = new RooRealVar("CMS_hem_nuisance_scale_m","CMS_hem_nuisance_scale_m", 0., -1., 1.);
     mean_err_e->setConstant(kTRUE);
     mean_err_m->setConstant(kTRUE);
     RooFormulaVar *mean_dcb = new RooFormulaVar(Form("%s_%s_mean%s",cat,proc,sysname),Form("%s_%s_mean%s",cat,proc,sysname),"(125+@0)*(1+@1+@2)",RooArgList(*dm_dcb,*mean_err_e, *mean_err_m));
     RooRealVar *n1_dcb = new RooRealVar(Form("%s_%s_n1%s",cat,proc,sysname),Form("%s_%s_n1%s",cat,proc,sysname), 3.5,2.,5.); //2,5
//     RooRealVar *c2_dcb = new RooRealVar(Form("%s_%s_c2%s",cat,proc,sysname),Form("%s_%s_c2%s",cat,proc,sysname), 20,2.5,200); //2,5
     RooRealVar *n2_dcb = new RooRealVar(Form("%s_%s_n2%s",cat,proc,sysname),Form("%s_%s_n2%s",cat,proc,sysname), 30., 10.,60.); //10,50
//     RooFormulaVar *n2_dcb = new RooFormulaVar(Form("%s_%s_n2%s",cat,proc,sysname),Form("%s_%s_n2%s",cat,proc,sysname), "@0/(@1*@1)", RooArgList(*c2_dcb,*a2_dcb)); //10,50
     RooRealVar *sigma = new RooRealVar(Form("%s_%s_sigma%s",cat,proc,sysname),Form("%s_%s_sigma%s",cat,proc,sysname), 2, 0.1, 2.5); //0.1,2.5
     RooRealVar *sigma_err_e = new RooRealVar("CMS_hem_nuisance_res_e", "CMS_hem_nuisance_res_e", 0., -1., 1.);
     RooRealVar *sigma_err_m = new RooRealVar("CMS_hem_nuisance_res_m","CMS_hem_nuisance_res_m", 0., -1., 1.);
     sigma_err_e->setConstant(kTRUE);
     sigma_err_m->setConstant(kTRUE);
     RooFormulaVar *sigma_dcb = new RooFormulaVar(Form("%s_%s_sigma%s",cat,proc,sysname),Form("%s_%s_sigma%s",cat,proc,sysname),"@0*(1+@1+@2)",RooArgList(*sigma,*sigma_err_e,*sigma_err_m));
     if (constr != NULL) {
       double a1_dcb_low = ((constr[0] - constr[0]*rangescale) >= 0) ? (constr[0] - constr[0]*rangescale) : 0;
       double a2_dcb_low = ((constr[1] - constr[1]*rangescale) >= 0) ? (constr[1] - constr[1]*rangescale) : 0;
       double n1_dcb_low = ((constr[3] - constr[3]*rangescale) >= 0) ? (constr[3] - constr[3]*rangescale) : 0;
       double n2_dcb_low = ((constr[4] - constr[4]*rangescale) >= 0) ? (constr[4] - constr[4]*rangescale) : 0;
       double sigma_dcb_low = ((constr[5] - constr[5]*rangescale) >= 0) ? (constr[5] - constr[5]*rangescale) : 0;
       a1_dcb->setRange(a1_dcb_low, constr[0] + constr[0]*rangescale);
       a2_dcb->setRange(a2_dcb_low, constr[1] + constr[1]*rangescale);
       dm_dcb->setRange(constr[2] - 125 + (constr[2]-125)*rangescale, constr[2] - (constr[2]-125)*rangescale-125);
       n1_dcb->setRange(n1_dcb_low, constr[3] + constr[3]*rangescale);
       n2_dcb->setRange(n2_dcb_low, constr[4] + constr[4]*rangescale);
       sigma->setRange(sigma_dcb_low, constr[5] + constr[5]*rangescale);

    
       for(auto parm : fixparm_arr) {
 
         if (parm == "a2") {
           a2_dcb->setVal(constr[0]);
           a2_dcb->setConstant(kTRUE);
         }
         else if (parm == "a1") {
           a2_dcb->setVal(constr[1]);
           a2_dcb->setConstant(kTRUE);
         }
         else if (parm == "dm") {
           dm_dcb->setVal(constr[2]-125);
           dm_dcb->setConstant(kTRUE);
         }
         else if (parm == "n1") {
           n1_dcb->setVal(constr[3]);
           n1_dcb->setConstant(kTRUE);
         }
         else if (parm == "n2") {
           n2_dcb->setVal(constr[4]);
           n2_dcb->setConstant(kTRUE);
         }
         else if (parm == "sigma") {
           sigma->setVal(constr[5]);
           sigma->setConstant(kTRUE);
         }
       } 
    }
     pdf = new RooDoubleCBFast(Form("%s_%s%s_pdf",cat, proc,sysname), Form("%s_%s%s_pdf",cat, proc,sysname), *mass,*mean_dcb,*sigma_dcb, *a1_dcb, *n1_dcb, *a2_dcb, *n2_dcb);
     a1_dcb->getVal();
     a2_dcb->getVal();
     mean_dcb->getVal();
     n1_dcb->getVal();
     n2_dcb->getVal();
     sigma_dcb->getVal();
     RooFitResult *fitResult = pdf->fitTo(*dh, Minimizer("Minuit2","minimize"), RooFit::Save(1), Range(mh - 15,mh + 15), SumW2Error(true));
//     cout << "Hello " << fitResult->status() << endl;
     fitResult->correlationMatrix().Print();
     result[0] = a1_dcb->getVal();
     result[1] = a2_dcb->getVal();
     result[2] = mean_dcb->getVal();
     result[3] = n1_dcb->getVal();
     result[4] = n2_dcb->getVal();
     result[5] = sigma_dcb->getVal();
     result[8] = fitResult->minNll();
   }
   else if (buildcbpg == 3) {
     RooRealVar *dm1 = new RooRealVar(Form("%s_%s_dm1%s",cat,proc,sysname),Form("%s_%s_dm1%s",cat,proc,sysname), 0.,-5.,5.);  //0.5
     RooFormulaVar *mean1 = new RooFormulaVar(Form("%s_%s_mean1%s",cat,proc,sysname),Form("%s_%s_mean1%s",cat,proc,sysname),"125+@0",RooArgList(*dm1));
     RooRealVar *sigma1 = new RooRealVar(Form("%s_%s_sigma1%s",cat,proc,sysname),Form("%s_%s_sigma1%s",cat,proc,sysname), 2, 0.1, 10); //0.1,2.5
     RooRealVar *dm2 = new RooRealVar(Form("%s_%s_dm2%s",cat,proc,sysname),Form("%s_%s_dm2%s",cat,proc,sysname), -1,-5.,5.);  //0.5
     RooFormulaVar *mean2 = new RooFormulaVar(Form("%s_%s_mean2%s",cat,proc,sysname),Form("%s_%s_mean2%s",cat,proc,sysname),"125+@0",RooArgList(*dm2));
     RooRealVar *sigma2 = new RooRealVar(Form("%s_%s_sigma2%s",cat,proc,sysname),Form("%s_%s_sigma2%s",cat,proc,sysname), 2, 0.1, 10); //0.1,2.5
     RooRealVar *dm3 = new RooRealVar(Form("%s_%s_dm3%s",cat,proc,sysname),Form("%s_%s_dm3%s",cat,proc,sysname), -1,-5.,5.);  //0.5
     RooFormulaVar *mean3 = new RooFormulaVar(Form("%s_%s_mean3%s",cat,proc,sysname),Form("%s_%s_mean3%s",cat,proc,sysname),"125+@0",RooArgList(*dm3));
     RooRealVar *sigma3 = new RooRealVar(Form("%s_%s_sigma3%s",cat,proc,sysname),Form("%s_%s_sigma3%s",cat,proc,sysname), 2, 0.1, 10); //0.1,2.5
     RooGaussian *pdf_gaus1 = new RooGaussian(Form("gaus1_mh_%s_%s%s",cat,proc,sysname),Form("gaus1_mh_%s_%s%s",cat,proc,sysname),*mass,*mean1,*sigma1);
     RooGaussian *pdf_gaus2 = new RooGaussian(Form("gaus2_mh_%s_%s%s",cat,proc,sysname),Form("gaus2_mh_%s_%s%s",cat,proc,sysname),*mass,*mean2,*sigma2);
     RooGaussian *pdf_gaus3 = new RooGaussian(Form("gaus3_mh_%s_%s%s",cat,proc,sysname),Form("gaus3_mh_%s_%s%s",cat,proc,sysname),*mass,*mean3,*sigma3);
     RooRealVar *frac_gaus = new RooRealVar(Form("frac_mh_%s_%s%s",cat,proc,sysname),Form("frac_mh_%s_%s%s",cat,proc,sysname),0.5,0.01,0.99);
     RooRealVar *frac_gaus2 = new RooRealVar(Form("frac2_mh_%s_%s%s",cat,proc,sysname),Form("frac2_mh_%s_%s%s",cat,proc,sysname),0.5,0.01,0.99);
     pdf = new RooAddPdf(Form("%s_%s%s_pdf",cat, proc,sysname),Form("%s_%s%s_pdf",cat, proc,sysname),RooArgList(*pdf_gaus1,*pdf_gaus2,*pdf_gaus3), RooArgList(*frac_gaus, *frac_gaus2), true);
     RooFitResult *fitResult = pdf->fitTo(*dh, Minimizer("Minuit2","minimize"), RooFit::Save(1), Range(mh - 15,mh + 15), SumW2Error(true));
     dm1->setConstant(true);
     sigma1->setConstant(true);
     dm2->setConstant(true);
     sigma2->setConstant(true);
     dm3->setConstant(true);
     sigma3->setConstant(true);
     frac_gaus->setConstant(true);
     frac_gaus2->setConstant(true);
//     cout << "Hello " << fitResult->status() << endl;
     fitResult->correlationMatrix().Print();
     result[0] = mean1->getVal();
     result[1] = sigma1->getVal();
     result[2] = mean2->getVal();
     result[3] = sigma2->getVal();
     result[8] = fitResult->minNll();
   }
 
   
   RooPlot *frame = mass->frame(Range("higgsRange"), Title(" "));
   dh->plotOn(frame, CutRange("higgsRange"), DataError(RooAbsData::SumW2));
   double numofevent = dh->sumEntries("1", "higgsRange");
   cout << cat << " " << proc << "Hello" << numofevent << endl;
   RooRealVar* nevent = new RooRealVar(Form("%s_%s%s_pdf_norm",cat, proc,sysname), Form("%s_%s%s_pdf_norm",cat, proc,sysname), numofevent,0,20*numofevent);
   nevent->setConstant(true);
   RooExtendPdf* pdf2 = new RooExtendPdf(Form("%s_%s%s_pdf_ext",cat, proc,sysname),Form("%s_%s%s_pdf_ext",cat, proc,sysname),*pdf,*nevent);
   if (!is_sys) {
//     w->import(*pdf2);
     w->import(*pdf); 
     w->import(*nevent);
     w->import(*dh);
   }
   pdf->plotOn(frame,Normalization(dh->sumEntries("1", "higgsRange"), RooAbsReal::NumEvent), NormRange("higgsRange"), Range("higgsRange"));
   std::cout << "chi2/dof:" << frame->chiSquare(buildcbpg?6:7) << std::endl;
   result[7] = frame->chiSquare(buildcbpg?6:7);
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
     TString data_text("137 fb^{-1}");
     data_text += " (";
     data_text += "13 TeV)";
     TString jets_text("e#mu ");
     jets_text.Append(cat);
     TString txt("#chi^{2} / ndf = ");
     txt += Form("%.2f / %i",frame->chiSquare()*dh->numEntries(), dh->numEntries()-7);
     frame->Draw();
     gPad->SetLeftMargin(0.13);
     latex.DrawLatex(0.65, 0.80, txt);
     latex.DrawLatex(0.16, 0.84, label_text);
     latex.DrawLatex(0.7, 0.91, data_text);
     std::string pngname = cat;
     std::string sub = sysname;
     std::string label2 = cat;
     label2 = "cat " + label2 + ", " + proc + " mode";
     label2 += " " + sub;
     latex.DrawLatex(0.16, 0.80, label2.c_str());
     pngname = "SigSys/" + pngname + sub + '_' + proc + "_DCB.png"; 
     
     canvas.SaveAs(pngname.c_str());
   }
}



void fitDCB(bool dosys = 0, int buildcbpg = 1, int whichcat = -1, std::string whichsys = "" , std::string fixparm = "", double rangescale = 1) {
  gSystem->Load("/afs/hep.wisc.edu/user/kaho/CMSSW_10_2_16_UL/lib/slc7_amd64_gcc700/libHiggsAnalysisCombinedLimit.so");

//  RooWorkspace *w = new RooWorkspace("wsig_13TeV","wsig_13TeV");
  int mh = 125;
  RooRealVar *mass = new RooRealVar("CMS_emu_Mass", "m_{e#mu}", 110, 160, "GeV");
  mass->setRange("higgsRange",110.,140.);
//  RooRealVar lumi("IntLumi", "Integrated luminosity", 35.87, "fb^{-1}");
//  w->import(lumi);
  const int numberofcat = 5;
  std::string procs[2] = {"ggH", "qqH"};
  std::string catname[numberofcat] = {"TightOSggcat0/", "TightOSggcat1/", "TightOSggcat2/", "TightOSggcat3/", "TightOSvbf/"};
  std::string cat[numberofcat] = {"ggcat0", "ggcat1", "ggcat2", "ggcat3", "vbf"};
  std::string sysname[6] = {"ees", "me", "eer"};
  std::string updown[2] = {"Up" ,"Down"};
  std::string sysname2[] = {
    "JetAbsolute","JetAbsoluteyear2016","JetAbsoluteyear2017","JetAbsoluteyear2018",
    "JetBBEC1","JetBBEC1year2016","JetBBEC1year2017","JetBBEC1year2018",
    "JetEC2","JetEC2year2016", "JetEC2year2017","JetEC2year2018",
    "JetFlavorQCD",
    "JetHF","JetHFyear2016","JetHFyear2017","JetHFyear2018",
    "JetRelativeBal","JetRelativeSample2016","JetRelativeSample2017","JetRelativeSample2018",
    "JER2016","JER2017","JER2018",
    "eer","ees","me",
    "pu2016","pu2017","pu2018",
    "pf2016","pf2017",
    "bTag2016","bTag2017","bTag2018",
    "UnclusteredEn2016","UnclusteredEn2017","UnclusteredEn2018"
  };
  std::string emstr1 = "e_m_Mass";
  std::string emstr = "/e_m_Mass";

  std::map<std::string, RooWorkspace*> WSLookupTable;
  for (int i = 0; i < numberofcat; i++){  
    WSLookupTable[cat[i]] = new RooWorkspace("w_13TeV","w_13TeV"); 
  }
  for (int p = 0; p < 2; p++) {
    TFile *file = new TFile();
    if (p == 0) {
      file = new TFile("SignalGG.root");
      cout << "Hellogg" << endl;
    }
    else {
      file = new TFile("SignalVBF.root");
      cout << "Hellovbf" << endl;
    }
    for (int i = 0; i < numberofcat; i++) {
      if (i != whichcat and whichcat != -1) { continue; }
      std::string dir_name = catname[i] + emstr1;
      auto hm = static_cast<TH1F*> (file->Get(dir_name.c_str()));
      const char* empty = "\0";
      double fitresult[9];
      makepdf(0, procs[p].c_str(), WSLookupTable[cat[i].c_str()], hm, mass, mh, cat[i].c_str(), empty, fitresult, rangescale, buildcbpg, 1);
      int start_ = 0;
      int end_ = 6;
      if (dosys) {
        if (whichsys == "es") {
          start_ = 0;
          end_ = 2;
        }
        else if (whichsys == "m") {
          start_ = 2;
          end_ = 4;
        }
        else if (whichsys == "er") {
          start_ = 4;
          end_ = 6;
        }
       
        for (int j = start_; j < end_; j++) {
          for (int k = 0; k < 2; k++) {
            std::string dir_name_sys = catname[i] + sysname[j] + updown[k] + emstr;
            auto hm = static_cast<TH1F*> (file->Get(dir_name_sys.c_str()));
            double fitresult_sys[9];
            makepdf(1, procs[p].c_str(), WSLookupTable[cat[i].c_str()], hm, mass, mh, cat[i].c_str(), sysname[j].c_str(), fitresult_sys, rangescale, buildcbpg, 1 , fitresult, fixparm);
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
              cout << "Changes in dm: " << (fitresult_sys[2] - fitresult[2])*100/fitresult[2] << endl;
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
  }
  for (auto const& ws : WSLookupTable) {
    ws.second->Print();
    std::string filename = "workspace_sig_" + ws.first  + ".root";
    ws.second->writeToFile(filename.c_str());
  }
//  w->writeToFile("FitSig.root");
//  w->Print();
}
}
