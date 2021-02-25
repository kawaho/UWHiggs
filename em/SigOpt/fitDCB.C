#include <string>
using namespace RooFit;

void makepdf(bool is_sys, const char* proc, RooWorkspace *w, TH1F* hm, RooRealVar *mass, int mh, const char* cat, const char* sysname, double result[], double rangescale = 1, int buildcbpg = 0, bool saveplot = 0, double constr[] = NULL, std::string fixparm = "") {
  vector<string> fixparm_arr;
  stringstream ss(fixparm);
  bool nofit = 0; 
  while(ss.good())
  {
      string substr;
      getline(ss, substr, ',');
      fixparm_arr.push_back(substr);
  }

   hm->Rebin(25);
//   hm->Scale(0.01);
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
     RooRealVar *a1_dcb = new RooRealVar(Form("%s_%s_a1%s",cat,proc,sysname),Form("%s_%s_a1%s",cat,proc,sysname), 2.5, .1, 5); 
     RooRealVar *a2_dcb = new RooRealVar(Form("%s_%s_a2%s",cat,proc,sysname),Form("%s_%s_a2%s",cat,proc,sysname), 2.5, .1, 5);
     RooRealVar *dm_dcb = new RooRealVar(Form("%s_%s_dm%s",cat,proc,sysname),Form("%s_%s_dm%s",cat,proc,sysname), -0.1,-1,0.);
     RooRealVar *mean_err_e = new RooRealVar(Form("CMS_hem_nuisance_scale_e_%s",proc),Form("CMS_hem_nuisance_scale_e_%s",proc), 0., -1., 1.);
     RooRealVar *mean_err_m = new RooRealVar(Form("CMS_hem_nuisance_scale_m_%s",proc),Form("CMS_hem_nuisance_scale_m_%s",proc), 0., -1., 1.);
     mean_err_e->setConstant(kTRUE);
     mean_err_m->setConstant(kTRUE);

//     RooFormulaVar *mean_dcb = new RooFormulaVar(Form("%s_%s_mean%s",cat,proc,sysname),Form("%s_%s_mean%s",cat,proc,sysname),"(125+@0)*(1+@1+@2)",RooArgList(*dm_dcb,*mean_err_e, *mean_err_m));
     RooFormulaVar *mean_dcb = new RooFormulaVar(Form("%s_%s_mean%s",cat,proc,sysname),Form("%s_%s_mean%s",cat,proc,sysname),"(125+@0)*(1)",RooArgList(*dm_dcb));


     RooRealVar *n1_dcb = new RooRealVar(Form("%s_%s_n1%s",cat,proc,sysname),Form("%s_%s_n1%s",cat,proc,sysname), 3.5,2.,5.); //2,5
     RooRealVar *n2_dcb = new RooRealVar(Form("%s_%s_n2%s",cat,proc,sysname),Form("%s_%s_n2%s",cat,proc,sysname), 20., 0.,100.); //5,50
//     if (strstr(cat, "EC") != NULL and strstr(proc, "ggH") != NULL) {
//       n2_dcb->setRange(50,600);
//       n2_dcb->setVal(200); 
//     }
//     if (strstr(cat, "ggcat1EC") != NULL and strstr(proc, "qqH") != NULL) {
//       n2_dcb->setRange(0,100);
//       n2_dcb->setVal(20); 
//     }
     RooRealVar *sigma = new RooRealVar(Form("%s_%s_sigma%s",cat,proc,sysname),Form("%s_%s_sigma%s",cat,proc,sysname), 2, 1., 2.5); //0.1,2.5
     RooRealVar *sigma_err_e = new RooRealVar(Form("CMS_hem_nuisance_res_e_%s",proc), Form("CMS_hem_nuisance_res_e_%s",proc), 0., -1., 1.);
     RooRealVar *sigma_err_m = new RooRealVar(Form("CMS_hem_nuisance_res_m_%s",proc), Form("CMS_hem_nuisance_res_m_%s",proc), 0., -1., 1.);
     sigma_err_e->setConstant(kTRUE);
     sigma_err_m->setConstant(kTRUE);

//     RooFormulaVar *sigma_dcb = new RooFormulaVar(Form("%s_%s_sigma%s",cat,proc,sysname),Form("%s_%s_sigma%s",cat,proc,sysname),"@0*(1+@1+@2)",RooArgList(*sigma,*sigma_err_e,*sigma_err_m));
     RooFormulaVar *sigma_dcb = new RooFormulaVar(Form("%s_%s_sigma%s",cat,proc,sysname),Form("%s_%s_sigma%s",cat,proc,sysname),"@0*(1)",RooArgList(*sigma));
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
 
         if (parm == "a1") {
           a1_dcb->setVal(constr[0]);
           a1_dcb->setConstant(kTRUE);
         }
         else if (parm == "a2") {
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
         else if (parm == "default") {
             a1_dcb->setVal(constr[0]);
             a1_dcb->setConstant(kTRUE);
             a2_dcb->setVal(constr[1]);
             a2_dcb->setConstant(kTRUE);
             n1_dcb->setVal(constr[3]);
             n1_dcb->setConstant(kTRUE);
             n2_dcb->setVal(constr[4]);
             n2_dcb->setConstant(kTRUE);
           if (strstr(sysname, "ees") != NULL) {
             sigma->setVal(constr[5]);
             sigma->setConstant(kTRUE);
           }
           if (strstr(sysname, "eer") != NULL) {
             dm_dcb->setVal(constr[2]-125);
             dm_dcb->setConstant(kTRUE);
           }
         }
         else if (parm == "all") {
           nofit = 1;
         }
       } 
    }
     pdf = new RooDoubleCBFast(Form("%s_%s%s_pdf",cat, proc,sysname), Form("%s_%s%s_pdf",cat, proc,sysname), *mass,*mean_dcb,*sigma_dcb, *a1_dcb, *n1_dcb, *a2_dcb, *n2_dcb);
//     TF1 *pdf_f = (TF1*) pdf->asTF(*mass, RooArgList(*mean_dcb,*sigma_dcb,*a1_dcb,*n1_dcb,*a2_dcb,*n2_dcb));

     a1_dcb->getVal();
     a2_dcb->getVal();
     mean_dcb->getVal();
     n1_dcb->getVal();
     n2_dcb->getVal();
     sigma_dcb->getVal();
     RooFitResult *fitResult = pdf->fitTo(*dh, Minimizer("Minuit2","minimize"), RooFit::Save(1), Range(mh - 15,mh + 15), SumW2Error(true));
//     double scale_factor = hm->Integral()*hm->GetBinWidth(1);
//     TString formula = TString::Format("%f * %s_%s%s_pdf",scale_factor,cat,proc,sysname);
//     RooFormulaVar scaled_pdf("scaled_pdf", formula, RooArgList(*pdf));
//     RooArgSet pars(*(pdf->getParameters(RooArgSet(*mass))));
////     TF1 *pdf_f = pdf->asTF(RooArgList(*mass), pars,RooArgList(*mass));
//     TF1 *pdf_f = scaled_pdf.asTF(RooArgList(*mass), pars, RooArgList(*mass));
//     TCanvas canvas2 = TCanvas("canvasB","canvas",800,800);
//     pdf_f->Draw();
////     hm->Scale(1/hm->Integral(), "width");
//     hm->Draw("same");
//     canvas2.SaveAs("Baker.png");
    
//     cout << "hahaha " << hm->Chisquare(pdf_f, "L") << endl;
     cout << "Hello " << cat <<  proc << " " << fitResult->status() << endl;



     mean_err_e->setConstant(kFALSE);
     mean_err_m->setConstant(kFALSE);
     sigma_err_e->setConstant(kFALSE);
     sigma_err_m->setConstant(kFALSE);
     a1_dcb->setConstant(kTRUE);
     a2_dcb->setConstant(kTRUE);
     dm_dcb->setConstant(kTRUE);
     n1_dcb->setConstant(kTRUE);
     n2_dcb->setConstant(kTRUE);
     sigma->setConstant(kTRUE);
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
     RooRealVar *dm1 = new RooRealVar(Form("%s_%s_dm1%s",cat,proc,sysname),Form("%s_%s_dm1%s",cat,proc,sysname), 0.,-10.,10.);  //0.5
     RooFormulaVar *mean1 = new RooFormulaVar(Form("%s_%s_mean1%s",cat,proc,sysname),Form("%s_%s_mean1%s",cat,proc,sysname),"125+@0",RooArgList(*dm1));
     RooRealVar *sigma1 = new RooRealVar(Form("%s_%s_sigma1%s",cat,proc,sysname),Form("%s_%s_sigma1%s",cat,proc,sysname), 2, 0.1, 15); //0.1,2.5
     RooRealVar *dm2 = new RooRealVar(Form("%s_%s_dm2%s",cat,proc,sysname),Form("%s_%s_dm2%s",cat,proc,sysname), -1,-10.,10.);  //0.5
     RooFormulaVar *mean2 = new RooFormulaVar(Form("%s_%s_mean2%s",cat,proc,sysname),Form("%s_%s_mean2%s",cat,proc,sysname),"125+@0",RooArgList(*dm2));
     RooRealVar *sigma2 = new RooRealVar(Form("%s_%s_sigma2%s",cat,proc,sysname),Form("%s_%s_sigma2%s",cat,proc,sysname), 2, 0.1, 15); //0.1,2.5
     RooRealVar *dm3 = new RooRealVar(Form("%s_%s_dm3%s",cat,proc,sysname),Form("%s_%s_dm3%s",cat,proc,sysname), -1,-10.,10.);  //0.5
     RooFormulaVar *mean3 = new RooFormulaVar(Form("%s_%s_mean3%s",cat,proc,sysname),Form("%s_%s_mean3%s",cat,proc,sysname),"125+@0",RooArgList(*dm3));
     RooRealVar *sigma3 = new RooRealVar(Form("%s_%s_sigma3%s",cat,proc,sysname),Form("%s_%s_sigma3%s",cat,proc,sysname), 2, 0.1, 15); //0.1,2.5
     RooRealVar *dm4 = new RooRealVar(Form("%s_%s_dm4%s",cat,proc,sysname),Form("%s_%s_dm4%s",cat,proc,sysname), -1,-10.,10.);  //0.5
     RooFormulaVar *mean4 = new RooFormulaVar(Form("%s_%s_mean4%s",cat,proc,sysname),Form("%s_%s_mean4%s",cat,proc,sysname),"125+@0",RooArgList(*dm3));
     RooRealVar *sigma4 = new RooRealVar(Form("%s_%s_sigma4%s",cat,proc,sysname),Form("%s_%s_sigma4%s",cat,proc,sysname), 2, 0.1, 15); //0.1,2.5
     RooGaussian *pdf_gaus1 = new RooGaussian(Form("gaus1_mh_%s_%s%s",cat,proc,sysname),Form("gaus1_mh_%s_%s%s",cat,proc,sysname),*mass,*mean1,*sigma1);
     RooGaussian *pdf_gaus2 = new RooGaussian(Form("gaus2_mh_%s_%s%s",cat,proc,sysname),Form("gaus2_mh_%s_%s%s",cat,proc,sysname),*mass,*mean2,*sigma2);
     RooGaussian *pdf_gaus3 = new RooGaussian(Form("gaus3_mh_%s_%s%s",cat,proc,sysname),Form("gaus3_mh_%s_%s%s",cat,proc,sysname),*mass,*mean3,*sigma3);
     RooGaussian *pdf_gaus4 = new RooGaussian(Form("gaus4_mh_%s_%s%s",cat,proc,sysname),Form("gaus4_mh_%s_%s%s",cat,proc,sysname),*mass,*mean4,*sigma4);
     RooRealVar *frac_gaus = new RooRealVar(Form("frac_mh_%s_%s%s",cat,proc,sysname),Form("frac_mh_%s_%s%s",cat,proc,sysname),0.5,0.01,0.99);
     RooRealVar *frac_gaus2 = new RooRealVar(Form("frac2_mh_%s_%s%s",cat,proc,sysname),Form("frac2_mh_%s_%s%s",cat,proc,sysname),0.5,0.01,0.99);
     RooRealVar *frac_gaus3 = new RooRealVar(Form("frac3_mh_%s_%s%s",cat,proc,sysname),Form("frac3_mh_%s_%s%s",cat,proc,sysname),0.5,0.01,0.99);
     if (constr != NULL) {
       for(auto parm : fixparm_arr) {
 
         if (parm == "dm1") {
           dm1->setVal(constr[0]);
           dm1->setConstant(kTRUE);
         }
         else if (parm == "sigma1") {
           sigma1->setVal(constr[1]);
           sigma1->setConstant(kTRUE);
         }
         else if (parm == "dm2") {
           dm2->setVal(constr[2]);
           dm2->setConstant(kTRUE);
         }
         else if (parm == "sigma2") {
           sigma2->setVal(constr[3]);
           sigma2->setConstant(kTRUE);
         }
         else if (parm == "dm3") {
           dm3->setVal(constr[4]);
           dm3->setConstant(kTRUE);
         }
         else if (parm == "sigma3") {
           sigma3->setVal(constr[5]);
           sigma3->setConstant(kTRUE);
         }
         else if (parm == "f1") {
           frac_gaus->setVal(constr[6]);
           frac_gaus->setConstant(kTRUE);
         }
         else if (parm == "f2") {
           frac_gaus2->setVal(constr[7]);
           frac_gaus2->setConstant(kTRUE);
         }
         else if (parm == "all") {
           nofit = 1;
           dm1->setVal(constr[0]);
           dm1->setConstant(kTRUE);
           sigma1->setVal(constr[1]);
           sigma1->setConstant(kTRUE);
           dm2->setVal(constr[2]);
           dm2->setConstant(kTRUE);
           sigma2->setVal(constr[3]);
           sigma2->setConstant(kTRUE);
           dm3->setVal(constr[4]);
           dm3->setConstant(kTRUE);
           sigma3->setVal(constr[5]);
           sigma3->setConstant(kTRUE);
           frac_gaus->setVal(constr[6]);
           frac_gaus->setConstant(kTRUE);
           frac_gaus2->setVal(constr[7]);
           frac_gaus2->setConstant(kTRUE);
         }
       }
     }  
     pdf = new RooAddPdf(Form("%s_%s%s_pdf",cat, proc,sysname),Form("%s_%s%s_pdf",cat, proc,sysname),RooArgList(*pdf_gaus1,*pdf_gaus2,*pdf_gaus3,*pdf_gaus4), RooArgList(*frac_gaus, *frac_gaus2, *frac_gaus3), true);
     if (!nofit) {
       RooFitResult *fitResult = pdf->fitTo(*dh, Minimizer("Minuit2","minimize"), RooFit::Save(1), Range(mh - 15,mh + 15), SumW2Error(true));
       fitResult->correlationMatrix().Print();
       result[8] = fitResult->minNll();
     }
//     dm1->setConstant(true);
//     sigma1->setConstant(true);
//     dm2->setConstant(true);
//     sigma2->setConstant(true);
//     dm3->setConstant(true);
//     sigma3->setConstant(true);
//     frac_gaus->setConstant(true);
//     frac_gaus2->setConstant(true);
//     cout << "Hello " << fitResult->status() << endl;
     result[0] = dm1->getVal();
     result[1] = sigma1->getVal();
     result[2] = dm2->getVal();
     result[3] = sigma2->getVal();
     result[4] = dm3->getVal();
     result[5] = sigma3->getVal();
     result[6] = frac_gaus->getVal();
     result[7] = frac_gaus2->getVal();
   }
 
   
   RooPlot *frame = mass->frame(Range("higgsRange"), Title(" "));
   dh->plotOn(frame, CutRange("higgsRange"), DataError(RooAbsData::SumW2));
   double numofevent = dh->sumEntries("1", "higgsRange");
   cout << cat << " " << proc << "Hello" << numofevent << endl;
   RooRealVar* nevent = new RooRealVar(Form("%s_%s%s_pdf_norm",cat, proc,sysname), Form("%s_%s%s_pdf_norm",cat, proc,sysname), numofevent,0,10*numofevent);
   nevent->setConstant(true);
   RooExtendPdf* pdf2 = new RooExtendPdf(Form("%s_%s%s_pdf_ext",cat, proc,sysname),Form("%s_%s%s_pdf_ext",cat, proc,sysname),*pdf,*nevent);
   if (!is_sys) {
//     w->import(*pdf2);
     w->import(*pdf); 
     w->import(*nevent);
     w->import(*dh);
   }
   pdf->plotOn(frame,Normalization(dh->sumEntries("1", "higgsRange"), RooAbsReal::NumEvent), NormRange("higgsRange"), Range("higgsRange"));
   double chi2_p = frame->chiSquare(buildcbpg?6:7);
   std::cout << "chi2/dof:" << chi2_p << std::endl;
   double p_th = TMath::Prob(chi2_p*(120-buildcbpg?6:7),120-buildcbpg?6:7);
   std::cout << "Th. p-value:" << p_th << std::endl;
   result[9] = chi2_p;
   if (saveplot) {
     TCanvas canvas = TCanvas("canvas","",0,0,800,800);
gPad->SetFillColor(0);
gPad->SetBorderMode(0);
gPad->SetBorderSize(10);
gPad->SetTickx(1);
gPad->SetTicky(1);
gPad->SetFrameFillStyle(0);
gPad->SetFrameLineStyle(0);
gPad->SetFrameLineWidth(3);
gPad->SetFrameBorderMode(0);
gPad->SetFrameBorderSize(10);
     canvas.SetLeftMargin(0.16);
     canvas.SetRightMargin(0.05);
     canvas.SetBottomMargin(0.14);
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
     txt += Form("%.2f / %i",frame->chiSquare()*120, 120-6);
     frame->SetXTitle("m_{e#mu} [GeV]");
     
     frame->SetMinimum(0);
     frame->GetXaxis()->SetTitleFont(42);
     frame->GetYaxis()->SetTitleFont(42);
     frame->GetXaxis()->SetTitleSize(0.05);
     frame->GetYaxis()->SetTitleSize(0.05);
     frame->GetXaxis()->SetLabelSize(0.045);
     frame->GetYaxis()->SetLabelSize(0.045);
     
     frame->GetYaxis()->SetTitleOffset(1.4);
     frame->GetXaxis()->SetTitleOffset(1.2);
     frame->Draw();
//     gPad->SetLeftMargin(0.13);
//     latex.DrawLatex(0.65, 0.80, txt);
//     latex.DrawLatex(0.16, 0.84, label_text);
//     latex.DrawLatex(0.7, 0.91, data_text);
     std::string pngname_init = cat;
     std::string sub = sysname;
     std::string label2 = cat;
     label2 = "cat " + label2 + ", " + proc + " mode";
     label2 += " " + sub;
//     latex.DrawLatex(0.16, 0.80, label2.c_str());

     double lowX=0.65;
     double lowY=0.83;
     auto lumi  = TPaveText(lowX,lowY, lowX+0.30, lowY+0.2, "NDC");
     lumi.SetBorderSize(   0 );
     lumi.SetFillStyle(    0 );
     lumi.SetTextAlign(   12 );
     lumi.SetTextColor(    1 );
     lumi.SetTextSize(0.038);
     lumi.SetTextFont (   42 );
     lumi.AddText("137.2 fb^{-1} (13 TeV)");
     lumi.Draw("same");
 
     lowX=0.18;
     lowY=0.71;
     auto cmstxt  = TPaveText(lowX, lowY+0.06, lowX+0.15, lowY+0.16, "NDC");
     cmstxt.SetTextFont(61);
     cmstxt.SetTextSize(0.055);
     cmstxt.SetBorderSize(   0 );
     cmstxt.SetFillStyle(    0 );
     cmstxt.SetTextAlign(   12 );
     cmstxt.SetTextColor(    1 );
     cmstxt.AddText("CMS");
     cmstxt.Draw("same");
 
     lowX=0.18;
     lowY=0.64;
     auto cattxt  = TPaveText(lowX, lowY+0.06, lowX+0.3, lowY+0.16, "NDC");
     cattxt.SetTextFont(42);
     cattxt.SetTextSize(0.055*0.8*0.76);
     cattxt.SetBorderSize(   0 );
     cattxt.SetFillStyle(    0 );
     cattxt.SetTextAlign(   12 );
     cattxt.SetTextColor(    1 );
     cattxt.AddText(label2.c_str());
     cattxt.Draw("same");

     lowX=0.30;
     lowY=0.71;
     auto pretxt  = TPaveText(lowX, lowY+0.05, lowX+0.15, lowY+0.15, "NDC");
     pretxt.SetTextFont(52);
     pretxt.SetTextSize(0.055*0.8*0.76);
     pretxt.SetBorderSize(   0 );
     pretxt.SetFillStyle(    0 );
     pretxt.SetTextAlign(   12 );
     pretxt.SetTextColor(    1 );
     pretxt.AddText("Preliminary");
     pretxt.Draw("same");


     std::string pngname = "SigSys/" + pngname_init + sub + '_' + proc + "_DCB.png"; 
     std::string pngnameBC = "SigSys/" + pngname_init + sub + '_' + proc + "_BC.png";
     canvas.SaveAs(pngname.c_str());
     runToychi2(pdf, hm, mass, chi2_p, 6, cat,  proc, sysname, pngnameBC);
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
  const int numberofcat = 7; //6;
  std::string procs[2] = {"ggH", "qqH"};

std::string cat[numberofcat] = {"ggcat0", "ggcat1", "ggcat2", "ggcat3", "ggcat4", "vbfcat0", "vbfcat1"};
std::string catname[numberofcat] = {"TightOSggcat0/", "TightOSggcat1/", "TightOSggcat2/", "TightOSggcat3/", "TightOSggcat4/", "TightOSvbfcat0/", "TightOSvbfcat1/"};
//std::string cat[numberofcat] = {"ggcat0", "ggcat1", "ggcat2", "ggcat3", "ggcat4", "ggcat5", "ggcat6", "vbfcat0", "vbfcat1"};
//std::string catname[numberofcat] = {"TightOSggcat0/", "TightOSggcat1/", "TightOSggcat2/", "TightOSggcat3/", "TightOSggcat4/", "TightOSggcat5/", "TightOSggcat6/", "TightOSvbfcat0/", "TightOSvbfcat1/"};
//std::string catname[numberofcat] = {"TightOSvbfcat0/", "TightOSvbfcat1/", "TightOSvbfcat2/", "TightOSvbfcat3/", "TightOSvbfcat4/", "TightOSvbfcat5/", "TightOSvbfcat6/", "TightOSvbfcat7/", "TightOSvbfcat8/", "TightOSvbfcat9/", "TightOSvbfcat10/", "TightOSvbfcat11/", "TightOSvbfcat12/", "TightOSvbfcat13/", "TightOSvbfcat14/", "TightOSvbfcat15/", "TightOSvbf/"};
//std::string cat[numberofcat] = {"vbfcat0", "vbfcat1", "vbfcat2", "vbfcat3", "vbfcat4", "vbfcat5", "vbfcat6", "vbfcat7", "vbfcat8", "vbfcat9", "vbfcat10", "vbfcat11", "vbfcat12", "vbfcat13", "vbfcat14", "vbfcat15", "vbf"};
  std::string sysname[6] = { "eesUp", "eesDown", "eerUp", "eerDown", "meUp", "meDown"};
//  std::string sysname[] = {"bTagUp2016", "bTagDown2016", "bTagUp2017", "bTagDown2017", "bTagUp2018", "bTagDown2018", "puUp2016", "puDown2016", "puUp2017", "puDown2017", "puUp2018", "puDown2018", "pfUp2016", "pfDown2016", "pfUp2017", "pfDown2017", "eesUp", "eesDown", "eerUp", "eerDown", "meUp", "meDown", "JetAbsoluteUp", "JetAbsoluteDown", "JetAbsoluteyearUp2016", "JetAbsoluteyearUp2017", "JetAbsoluteyearUp2018", "JetAbsoluteyearDown2016", "JetAbsoluteyearDown2017", "JetAbsoluteyearDown2018", "JetBBEC1Up", "JetBBEC1Down", "JetBBEC1yearUp2016", "JetBBEC1yearUp2017", "JetBBEC1yearUp2018", "JetBBEC1yearDown2016", "JetBBEC1yearDown2017", "JetBBEC1yearDown2018", "JetFlavorQCDUp", "JetFlavorQCDDown", "JetEC2Up", "JetEC2Down", "JetEC2yearUp2016", "JetEC2yearUp2017", "JetEC2yearUp2018", "JetEC2yearDown2016", "JetEC2yearDown2017", "JetEC2yearDown2018", "JetHFUp", "JetHFDown", "JetHFyearUp2016", "JetHFyearUp2017", "JetHFyearUp2018", "JetHFyearDown2016", "JetHFyearDown2017", "JetHFyearDown2018", "JetRelativeBalUp", "JetRelativeBalDown", "JetRelativeSampleUp2016", "JetRelativeSampleUp2017", "JetRelativeSampleUp2018", "JetRelativeSampleDown2016", "JetRelativeSampleDown2017", "JetRelativeSampleDown2018", "JERUp2016", "JERUp2017", "JERUp2018", "JERDown2016", "JERDown2017", "JERDown2018", "UnclusteredEnUp2016", "UnclusteredEnUp2017", "UnclusteredEnUp2018", "UnclusteredEnDown2016", "UnclusteredEnDown2017", "UnclusteredEnDown2018", "UesCHARGEDUp2016", "UesCHARGEDUp2017", "UesCHARGEDUp2018", "UesCHARGEDDown2016", "UesCHARGEDDown2017", "UesCHARGEDDown2018", "UesECALUp2016", "UesECALUp2017", "UesECALUp2018", "UesECALDown2016", "UesECALDown2017", "UesECALDown2018", "UesHCALUp2016", "UesHCALUp2017", "UesHCALUp2018", "UesHCALDown2016", "UesHCALDown2017", "UesHCALDown2018", "UesHFUp2016", "UesHFUp2017", "UesHFUp2018", "UesHFDown2016", "UesHFDown2017", "UesHFDown2018"};
  std::string emstr1 = "e_m_Mass";
  std::string emstr = "/e_m_Mass";

  std::map<std::string, RooWorkspace*> WSLookupTable;
  for (int i = 0; i < numberofcat; i++){  
    WSLookupTable[cat[i]] = new RooWorkspace("w_13TeV","w_13TeV"); 
  }
  FILE *f = fopen("Hem_shape_sys.csv", "w");
  fprintf(f, "Proc,Cat,Sys,Param,Value\n");
  for (int p = 0; p < 2; p++) {
    TFile *file = new TFile();
    if (p == 0) {
      file = new TFile("SignalGG_or2_stat.root");
      cout << "Hellogg" << endl;
    }
    else {
      file = new TFile("SignalVBF_or2_stat.root");
      cout << "Hellovbf" << endl;
    }
    for (int i = 0; i < numberofcat; i++) {
      if (i != whichcat and whichcat != -1) { continue; }
      std::string dir_name = catname[i] + emstr1;
      cout << "HAYYY" << dir_name << endl;
      auto hm = static_cast<TH1F*> (file->Get(dir_name.c_str()));
      const char* empty = "\0";
      double fitresult[20];
      makepdf(0, procs[p].c_str(), WSLookupTable[cat[i].c_str()], hm, mass, mh, cat[i].c_str(), empty, fitresult, rangescale, buildcbpg, 1);
      int start_ = 0;
      int end_ = 6; //100;
      if (dosys) {

        vector<string> sys_arr;
        stringstream ss(whichsys);
        while(ss.good())
        {
            string substr;
            getline(ss, substr, ',');
            sys_arr.push_back(substr);
        }
        for (int j = start_; j < end_; j++) {
          bool run = false;
          for(auto whs : sys_arr) {
            if (sysname[j].find(whs) != std::string::npos) {run = true;}
          }
          if (!run) {continue; }
          std::string dir_name_sys = catname[i] + sysname[j] + emstr;
          auto hm = static_cast<TH1F*> (file->Get(dir_name_sys.c_str()));
          double fitresult_sys[20];
          cout <<"doing sys :" << sysname[j].c_str() << endl;
          makepdf(1, procs[p].c_str(), WSLookupTable[cat[i].c_str()], hm, mass, mh, cat[i].c_str(), sysname[j].c_str(), fitresult_sys, rangescale, buildcbpg, 1 , fitresult, fixparm);
          cout.precision(2);
          cout << "Changes in: " << sysname[j].c_str() << endl;
    
          if (buildcbpg == 0) { 
            cout << "Changes in a: " << (fitresult_sys[0] - fitresult[0])*100/fitresult[0] << endl;
            cout << "Changes in n: " << (fitresult_sys[1] - fitresult[1])*100/fitresult[1] << endl;
            cout << "Changes in mean_cb: " << (fitresult_sys[2] - fitresult[2])*100/fitresult[2] << endl;
            cout << "Changes in sigma_cb: " << (fitresult_sys[3] - fitresult[3])*100/fitresult[3] << endl;
            cout << "Changes in mean_gaus: " << (fitresult_sys[4] - fitresult[4])*100/fitresult[4] << endl;
            cout << "Changes in sigma_gaus: " << (fitresult_sys[5] - fitresult[5])*100/fitresult[5] << endl;
            cout << "Changes in frac_gaus: " << (fitresult_sys[6] - fitresult[6])*100/fitresult[5] << endl;
            cout << "Changes in chi2: " << (fitresult_sys[9] - fitresult[9])*100/fitresult[9] << endl;
            cout << "Changes in NLL: " << (fitresult_sys[8] - fitresult[8])*100/fitresult[8] << endl;
          }
          else if (buildcbpg == 1) {
            cout << "Changes in a1: " << (fitresult_sys[0] - fitresult[0])*100/fitresult[0] << endl;
            cout << "Changes in a2: " << (fitresult_sys[1] - fitresult[1])*100/fitresult[1] << endl;
            double changeindm = (fitresult_sys[2] - fitresult[2])/fitresult[2];
            double changeinsigma = (fitresult_sys[5] - fitresult[5])/fitresult[5];
            cout << "Changes in dm: " << changeindm  << endl;
            if (changeindm!=0.) {fprintf(f, "%s,%s,%s,dm,%f\n",procs[p].c_str(),cat[i].c_str(),sysname[j].c_str(),changeindm);}           
            cout << "Changes in n1: " << (fitresult_sys[3] - fitresult[3])*100/fitresult[3] << endl;
            cout << "Changes in n2: " << (fitresult_sys[4] - fitresult[4])*100/fitresult[4] << endl;
            cout << "Changes in sigma: " << changeinsigma << endl;
            if (changeinsigma!=0.) {fprintf(f, "%s,%s,%s,sigma,%f\n",procs[p].c_str(),cat[i].c_str(),sysname[j].c_str(),changeinsigma);}           
            cout << "Changes in chi2: " << (fitresult_sys[9] - fitresult[9])*100/fitresult[9] << endl;
            cout << "Changes in NLL: " << (fitresult_sys[8] - fitresult[8])*100/fitresult[8] << endl;
  
          } 
          else if (buildcbpg == 3) {
            cout << "Changes in dm1: " << (fitresult_sys[0] - fitresult[0])*100/fitresult[0] << endl;
            cout << "Changes in sigma1: " << (fitresult_sys[1] - fitresult[1])*100/fitresult[1] << endl;
            cout << "Changes in dm2: " << (fitresult_sys[2] - fitresult[2])*100/fitresult[2] << endl;
            cout << "Changes in sigma2: " << (fitresult_sys[3] - fitresult[3])*100/fitresult[3] << endl;
            cout << "Changes in dm3: " << (fitresult_sys[4] - fitresult[4])*100/fitresult[4] << endl;
            cout << "Changes in sigma3: " << (fitresult_sys[5] - fitresult[5])*100/fitresult[5] << endl;
            cout << "Changes in f1: " << (fitresult_sys[6] - fitresult[6])*100/fitresult[6] << endl;
            cout << "Changes in f2: " << (fitresult_sys[7] - fitresult[7])*100/fitresult[7] << endl;
            cout << "Changes in chi2: " << (fitresult_sys[9] - fitresult[9])*100/fitresult[9] << endl;
            cout << "Changes in NLL: " << (fitresult_sys[8] - fitresult[8])*100/fitresult[8] << endl;
  
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
//    ws.second->Print();
    std::string filename = "workspace_sig_" + ws.first  + ".root";
    ws.second->writeToFile(filename.c_str());
  }
//  w->writeToFile("FitSig.root");
//  w->Print();
}
        fclose(f);
}
