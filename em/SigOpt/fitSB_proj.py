import ROOT
import os.path
from os import path
ROOT.gSystem.Load("/afs/hep.wisc.edu/user/kaho/CMSSW_10_2_16_UL/lib/slc7_amd64_gcc700/libHiggsAnalysisCombinedLimit.so");
#bins_proj = [effl, effh]
def fit(bins, cat):
  effl, effh = bins[0], bins[1]
  allvars = []
  fitstatus = 0
  w = ROOT.RooWorkspace("w_13TeV","w_13TeV") 
  mass = ROOT.RooRealVar("CMS_emu_Mass", "m_{e#mu}", 110, 160, "GeV")
  mass.setRange("higgsRange",110.,140.)
  f = open('Hem_shape_sys.csv', 'a')
  if os.stat("Hem_shape_sys.csv").st_size == 0:
    f.write("Proc,Cat,Sys,Param,Value\n")
  sysname = ["eesUp", "eesDown", "eerUp", "eerDown", "meUp", "meDown"]
  yrs = ['2016','2017','2018']
  
  #Fit signal
  for rfile, proc in zip([ROOT.TFile('GG_proj.root'),ROOT.TFile('VBF_proj.root')],['ggH','qqH']):
    h = ROOT.TH1D("","",200,110,160) 
    for i in range(effl, effh):
      h.Add(rfile.Get("range%i"%i))
    dh = ROOT.RooDataHist("{}_{}_data".format(cat,proc), "{}_{}_data".format(cat,proc), ROOT.RooArgList(mass), ROOT.RooFit.Import(h))
    a1_dcb = ROOT.RooRealVar("{}_{}_a1".format(cat,proc), "{}_{}_a1".format(cat,proc), 2.5, .1, 5) 
    a2_dcb = ROOT.RooRealVar("{}_{}_a2".format(cat,proc), "{}_{}_a2".format(cat,proc), 2.5, .1, 5)
    dm_dcb = ROOT.RooRealVar("{}_{}_dm".format(cat,proc), "{}_{}_dm".format(cat,proc), -0.1, -1, 0.)
    mean_err_e = ROOT.RooRealVar("CMS_hem_nuisance_scale_e_{}".format(proc), "CMS_hem_nuisance_scale_e_{}".format(proc), 0., -1., 1.)
    mean_err_m = ROOT.RooRealVar("CMS_hem_nuisance_scale_m_{}".format(proc), "CMS_hem_nuisance_scale_m_{}".format(proc), 0., -1., 1.)
    mean_err_e.setConstant(ROOT.kTRUE)
    mean_err_m.setConstant(ROOT.kTRUE)
    mean_dcb = ROOT.RooFormulaVar("{}_{}_mean".format(cat,proc), "{}_{}_mean".format(cat,proc), "(125+@0)*(1+@1+@2)", ROOT.RooArgList(dm_dcb, mean_err_e, mean_err_m))
    
    n1_dcb = ROOT.RooRealVar("{}_{}_n1".format(cat,proc), "{}_{}_n1".format(cat,proc), 3.5, 2., 5.)
    n2_dcb = ROOT.RooRealVar("{}_{}_n2".format(cat,proc), "{}_{}_n2".format(cat,proc), 20., 0., 100.)

    sigma = ROOT.RooRealVar("{}_{}_sigma".format(cat,proc), "{}_{}_sigma".format(cat,proc), 2, 1., 2.5)
    sigma_err_e = ROOT.RooRealVar("CMS_hem_nuisance_res_e_{}".format(proc), "CMS_hem_nuisance_res_e_{}".format(proc), 0., -1., 1.)
    sigma_err_m = ROOT.RooRealVar("CMS_hem_nuisance_res_m_{}".format(proc), "CMS_hem_nuisance_res_m_{}".format(proc), 0., -1., 1.)
    sigma_err_e.setConstant(ROOT.kTRUE)
    sigma_err_m.setConstant(ROOT.kTRUE)

    sigma_dcb = ROOT.RooFormulaVar("{}_{}_sigma_dcb".format(cat,proc), "{}_{}_sigma_dcb".format(cat,proc), "@0*(1+@1+@2)", ROOT.RooArgList(sigma, sigma_err_e, sigma_err_m))
    
    pdf = ROOT.RooDoubleCBFast("{}_{}_pdf".format(cat,proc), "{}_{}_pdf".format(cat,proc), mass, mean_dcb, sigma_dcb, a1_dcb, n1_dcb, a2_dcb, n2_dcb)
    numofevent = dh.sumEntries("1", "higgsRange")
    nevent = ROOT.RooRealVar("{}_{}_pdf_norm".format(cat,proc), "{}_{}_pdf_norm".format(cat,proc), numofevent, 0, 10*numofevent)
    
    fitResult = pdf.fitTo(dh, ROOT.RooFit.Minimizer("Minuit2","minimize"), ROOT.RooFit.Save(1), ROOT.RooFit.Range("higgsRange"), ROOT.RooFit.SumW2Error(ROOT.kTRUE))
    canvas = ROOT.TCanvas("canvas","",0,0,800,800)
    frame = mass.frame(ROOT.RooFit.Range("higgsRange"))
    dh.plotOn(frame, ROOT.RooFit.CutRange("higgsRange"), ROOT.RooFit.DataError(ROOT.RooAbsData.SumW2))
    pdf.plotOn(frame, ROOT.RooFit.Normalization(dh.sumEntries("1", "higgsRange"), ROOT.RooAbsReal.NumEvent), ROOT.RooFit.NormRange("higgsRange"), ROOT.RooFit.Range("higgsRange"))
    frame.Draw()
    canvas.SaveAs(cat + '_' + proc +"_"+str(effl) +"_"+str(effh)+"_DCB.png")
    fitstatus += fitResult.status()
    
    a1_dcb.setConstant(ROOT.kTRUE)
    a2_dcb.setConstant(ROOT.kTRUE)
    dm_dcb.setConstant(ROOT.kTRUE)
    n1_dcb.setConstant(ROOT.kTRUE)
    n2_dcb.setConstant(ROOT.kTRUE)
    sigma.setConstant(ROOT.kTRUE)
    allvars.append([a1_dcb,a2_dcb,dm_dcb,n1_dcb,n2_dcb,nevent,dh,sigma_dcb,pdf])  
    getattr(w, 'import')(pdf)
    getattr(w, 'import')(nevent)
    getattr(w, 'import')(dh)
  
    constr = [0]*6
    constr[0] = a1_dcb.getVal()
    constr[1] = a2_dcb.getVal()
    constr[2] = mean_dcb.getVal()
    constr[3] = n1_dcb.getVal()
    constr[4] = n2_dcb.getVal()
    constr[5] = sigma_dcb.getVal()

#Fit Systematics
    for sys in sysname:
      h = ROOT.TH1D("","",200,110,160) 
      for i in range(effl, effh):
        h.Add(rfile.Get("%s_range%i"%(sys,i)))
      dh = ROOT.RooDataHist("{}_{}_data_{}".format(cat,proc,sys), "{}_{}_data_{}".format(cat,proc,sys), ROOT.RooArgList(mass), ROOT.RooFit.Import(h))
      a1_dcb = ROOT.RooRealVar("{}_{}_a1_{}".format(cat,proc,sys), "{}_{}_a1_{}".format(cat,proc,sys), 2.5, .1, 5) 
      a2_dcb = ROOT.RooRealVar("{}_{}_a2_{}".format(cat,proc,sys), "{}_{}_a2_{}".format(cat,proc,sys), 2.5, .1, 5)
      dm_dcb = ROOT.RooRealVar("{}_{}_dm_{}".format(cat,proc,sys), "{}_{}_dm_{}".format(cat,proc,sys), -0.1, -1, 0.)
      mean_err_e = ROOT.RooRealVar("CMS_hem_nuisance_scale_e_{}_{}".format(proc,sys), "CMS_hem_nuisance_scale_e_{}_{}".format(proc,sys), 0., -1., 1.)
      ean_err_m = ROOT.RooRealVar("CMS_hem_nuisance_scale_m_{}_{}".format(proc,sys), "CMS_hem_nuisance_scale_m_{}_{}".format(proc,sys), 0., -1., 1.)
      mean_err_e.setConstant(ROOT.kTRUE)
      mean_err_m.setConstant(ROOT.kTRUE)
      mean_dcb = ROOT.RooFormulaVar("{}_{}_mean_{}".format(cat,proc,sys), "{}_{}_mean_{}".format(cat,proc,sys), "(125+@0)*(1+@1+@2)", ROOT.RooArgList(dm_dcb, mean_err_e, mean_err_m))
      
      n1_dcb = ROOT.RooRealVar("{}_{}_n1_{}".format(cat,proc,sys), "{}_{}_n1_{}".format(cat,proc,sys), 3.5, 2., 5.)
      n2_dcb = ROOT.RooRealVar("{}_{}_n2_{}".format(cat,proc,sys), "{}_{}_n2_{}".format(cat,proc,sys), 20., 0., 100.)

      sigma = ROOT.RooRealVar("{}_{}_sigma_{}".format(cat,proc,sys), "{}_{}_sigma_{}".format(cat,proc,sys), 2, 1., 2.5)
      sigma_err_e = ROOT.RooRealVar("CMS_hem_nuisance_res_e_{}_{}".format(proc,sys), "CMS_hem_nuisance_res_e_{}_{}".format(proc,sys), 0., -1., 1.)
      sigma_err_m = ROOT.RooRealVar("CMS_hem_nuisance_res_m_{}_{}".format(proc,sys), "CMS_hem_nuisance_res_m_{}_{}".format(proc,sys), 0., -1., 1.)
      sigma_err_e.setConstant(ROOT.kTRUE)
      sigma_err_m.setConstant(ROOT.kTRUE)

      sigma_dcb = ROOT.RooFormulaVar("{}_{}_sigma_dcb_{}".format(cat,proc,sys), "{}_{}_sigma_dcb_{}".format(cat,proc,sys), "@0*(1+@1+@2)", ROOT.RooArgList(sigma, sigma_err_e, sigma_err_m))
      
      pdf = ROOT.RooDoubleCBFast("{}_{}_pdf_{}".format(cat,proc,sys), "{}_{}_pdf_{}".format(cat,proc,sys), mass, mean_dcb, sigma_dcb, a1_dcb, n1_dcb, a2_dcb, n2_dcb)
      
      a1_dcb.setVal(constr[0])
      a2_dcb.setVal(constr[1])
      n1_dcb.setVal(constr[3])
      n2_dcb.setVal(constr[4])
      a1_dcb.setConstant(ROOT.kTRUE)
      a2_dcb.setConstant(ROOT.kTRUE)
      n1_dcb.setConstant(ROOT.kTRUE)
      n2_dcb.setConstant(ROOT.kTRUE)
      if "ees" in sys:
        sigma.setVal(constr[5])
        sigma.setConstant(ROOT.kTRUE)
      elif "eer" in sys:
        dm_dcb.setVal(constr[2]-125)
        dm_dcb.setConstant(ROOT.kTRUE)

      fitResult = pdf.fitTo(dh, ROOT.RooFit.Minimizer("Minuit2","minimize"), ROOT.RooFit.Save(1), ROOT.RooFit.Range("higgsRange"), ROOT.RooFit.SumW2Error(ROOT.kTRUE))
      fitstatus += fitResult.status()
      
      changeindm = (mean_dcb.getVal() - constr[2])/constr[2]
      changeinsigma = (sigma_dcb.getVal() - constr[5])/constr[5]
      if "s" in sys:
        f.write("{},{},{},dm,{}\n".format(proc,cat,sys,changeindm))
      elif "r" in sys:
        f.write("{},{},{},sigma,{}\n".format(proc,cat,sys,changeinsigma))
      else:
        f.write("{},{},{},dm,{}\n".format(proc,cat,sys,changeindm))
        f.write("{},{},{},sigma,{}\n".format(proc,cat,sys,changeinsigma))

  #Fit data
  rfile = ROOT.TFile('data_proj.root')
  hb = ROOT.TH1D("","",50,110,160) 
  for i in range(effl, effh):
    hb.Add(rfile.Get("range%i"%i))
  db = ROOT.RooDataHist("roohist_data_mass_{}".format(cat), "roohist_data_mass_{}".format(cat), ROOT.RooArgList(mass), ROOT.RooFit.Import(hb))
  numofeventb = db.sumEntries()
  neventb = ROOT.RooRealVar("roohist_data_mass_{}_norm".format(cat), "roohist_data_mass_{}_norm".format(cat), numofeventb, 0, 10*numofeventb)
  
  p0_exp1 = ROOT.RooRealVar("env_pdf_{}_exp1_p1".format(cat), "env_pdf_{}_exp1_p1".format(cat), -0.04, -5., 0.)
  pdfb = ROOT.RooExponential("env_pdf_{}_exp1".format(cat), "env_pdf_{}_exp1".format(cat), mass, p0_exp1)
  fitResultb = pdfb.fitTo(db, ROOT.RooFit.Minimizer("Minuit2","minimize"), ROOT.RooFit.Save(1), ROOT.RooFit.SumW2Error(ROOT.kTRUE))
  
  allvars.append([db,p0_exp1,neventb,pdfb])  
  fitstatus += fitResult.status()
  
  getattr(w, 'import')(pdfb)
  getattr(w, 'import')(neventb)
  getattr(w, 'import')(db)
  
  filename = "workspace_sig_"+cat+".root"
#  ROOT.gDirectory.Add(w)
  w.Print()
  w.writeToFile(filename)
  f.close()
  return fitstatus
