import ROOT
import math
import os.path
from os import path
ROOT.gSystem.Load("/afs/cern.ch/work/k/kaho/CMSSW_10_2_13/lib/slc7_amd64_gcc700/libHiggsAnalysisCombinedLimit.so");
ROOT.gROOT.SetBatch(True)
#bins_proj = [effl, effh]
def fit(bins, cat):
  effl, effh = bins[0], bins[1]
  allvars = []
  fitstatus = 0
  w = ROOT.RooWorkspace("w_13TeV","w_13TeV") 

  #Fit data
  rfile = ROOT.TFile('dataws.root')
  inWS = rfile.Get("CMS_emu_workspace")
  mass = inWS.var("CMS_emu_Mass")
  mass.setBins(50)
  mass.setRange("higgsRange",110.,160.)
  mass.setRange("higgsRange2",110.,160.)
  db = inWS.data("Data_13TeV_range%i"%effl)
  for i in range(effl+1, effh):
    db.append(inWS.data("Data_13TeV_range%i"%i))
  db.SetName("roohist_data_mass_{}".format(cat))
  numofeventb = db.sumEntries()
  neventb = ROOT.RooRealVar("pdf_{}_exp1_norm".format(cat), "pdf_{}_exp1_norm".format(cat), numofeventb, 0, 10*numofeventb)
  p0_exp1 = ROOT.RooRealVar("pdf_{}_exp1_p1".format(cat), "pdf_{}_exp1_p1".format(cat), -0.04, -5., 0.)
  pdfb = ROOT.RooExponential("pdf_{}_exp1".format(cat), "pdf_{}_exp1".format(cat), mass, p0_exp1)
#  coeffList = ROOT.RooArgList()
#  for i in range(3):
#    param = ROOT.RooRealVar("env_pdf_{}_bern3_p{}".format(cat,i), "env_pdf_{}_bern3_p{}".format(cat,i), 0.1*(i+1), -10., 10.)
#    form = ROOT.RooFormulaVar("env_pdf_{}_bern3_sq{}".format(cat,i), "env_pdf_{}_bern3_sq{}".format(cat,i), "@0*@0", ROOT.RooArgList(param))
#    coeffList.add(form)
#    allvars.append([param,form])  
#
#  pdfb = ROOT.RooBernstein("env_pdf_{}_exp1".format(cat), "env_pdf_{}_exp1".format(cat), mass, coeffList)

  fitResultb = pdfb.fitTo(db, ROOT.RooFit.Minimizer("Minuit2","minimize"), ROOT.RooFit.Save(1), ROOT.RooFit.SumW2Error(ROOT.kTRUE))
  dataBinned = ROOT.RooDataHist("roohist_data_mass_{}".format(cat), "roohist_data_mass_{}".format(cat), ROOT.RooArgSet(mass), db) 
  
#  allvars.append([db,neventb,pdfb])  
  allvars.append([db,p0_exp1,neventb,pdfb])  
#  fitstatus += fitResult.status()
#  neventb.setConstant(ROOT.kTRUE)
  fitstatus = fitstatus/math.sqrt(numofeventb)
  canvas = ROOT.TCanvas("canvas","",0,0,800,800)
#  frame = mass.frame(ROOT.RooFit.Range("higgsRange2"))
#  db.plotOn(frame, ROOT.RooFit.CutRange("higgsRange2"), ROOT.RooFit.DataError(ROOT.RooAbsData.SumW2))
#  pdfb.plotOn(frame, ROOT.RooFit.Normalization(db.sumEntries("1", "higgsRange2"), ROOT.RooAbsReal.NumEvent), ROOT.RooFit.NormRange("higgsRange2"), ROOT.RooFit.Range("higgsRange2"))
#  frame.Draw()
#  canvas.SaveAs(cat + '_' + "_"+str(effl) +"_"+str(effh)+"_bkg.png")
#  fitstatus += fitResult.status()
  
  getattr(w, 'import')(pdfb)
  getattr(w, 'import')(neventb)
  getattr(w, 'import')(db)
  getattr(w, 'import')(dataBinned)

  f = open('ShapeSys/Hem_shape_sys_%s.csv'%cat, 'w')
  f.write("Proc,Cat,Sys,Param,Value\n")
#  f = open('Hem_shape_sys.csv', 'a')
#  if os.stat("Hem_shape_sys.csv").st_size == 0:
#    f.write("Proc,Cat,Sys,Param,Value\n")
  sysname = ["eesUp", "eesDown", "eerUp", "eerDown", "meUp", "meDown"]
  yrs = ['2016','2017','2018']
  
  #Fit signal
  for rfile, proc in zip([ROOT.TFile('GG_proj.root'),ROOT.TFile('VBF_proj.root')],['ggH','qqH']):
    h = ROOT.TH1D("%s_%s"%(cat,proc),"%s_%s"%(cat,proc),200,110,160) 
    for i in range(effl, effh):
      h.Add(rfile.Get("range%i"%i))
    dh = ROOT.RooDataHist("data_{}_{}".format(cat,proc), "data_{}_{}".format(cat,proc), ROOT.RooArgList(mass), ROOT.RooFit.Import(h))
    a1_dcb = ROOT.RooRealVar("{}_{}_a1".format(cat,proc), "{}_{}_a1".format(cat,proc), 2.5, .1, 5) 
    a2_dcb = ROOT.RooRealVar("{}_{}_a2".format(cat,proc), "{}_{}_a2".format(cat,proc), 2.5, .1, 5)
    dm_dcb = ROOT.RooRealVar("{}_{}_dm".format(cat,proc), "{}_{}_dm".format(cat,proc), -0.1, -1, 0.)
    mean_err_e = ROOT.RooRealVar("CMS_hem_nuisance_scale_e_{}_{}".format(cat,proc), "CMS_hem_nuisance_scale_e_{}_{}".format(cat,proc), 0., -1., 1.)
    mean_err_m = ROOT.RooRealVar("CMS_hem_nuisance_scale_m_{}_{}".format(cat,proc), "CMS_hem_nuisance_scale_m_{}_{}".format(cat,proc), 0., -1., 1.)
    mean_err_e.setConstant(ROOT.kTRUE)
    mean_err_m.setConstant(ROOT.kTRUE)
    mean_dcb = ROOT.RooFormulaVar("{}_{}_mean".format(cat,proc), "{}_{}_mean".format(cat,proc), "(125+@0)*(1+@1+@2)", ROOT.RooArgList(dm_dcb, mean_err_e, mean_err_m))
    
    n1_dcb = ROOT.RooRealVar("{}_{}_n1".format(cat,proc), "{}_{}_n1".format(cat,proc), 3.5, 2., 5.)
    n2_dcb = ROOT.RooRealVar("{}_{}_n2".format(cat,proc), "{}_{}_n2".format(cat,proc), 20., 0., 100.)

    sigma = ROOT.RooRealVar("{}_{}_sigma".format(cat,proc), "{}_{}_sigma".format(cat,proc), 2, 1., 2.5)
    sigma_err_e = ROOT.RooRealVar("CMS_hem_nuisance_res_e_{}_{}".format(cat,proc), "CMS_hem_nuisance_res_e_{}_{}".format(cat,proc), 0., -1., 1.)
    sigma_err_m = ROOT.RooRealVar("CMS_hem_nuisance_res_m_{}_{}".format(cat,proc), "CMS_hem_nuisance_res_m_{}_{}".format(cat,proc), 0., -1., 1.)
    sigma_err_e.setConstant(ROOT.kTRUE)
    sigma_err_m.setConstant(ROOT.kTRUE)

    sigma_dcb = ROOT.RooFormulaVar("{}_{}_sigma_dcb".format(cat,proc), "{}_{}_sigma_dcb".format(cat,proc), "@0*(1+@1+@2)", ROOT.RooArgList(sigma, sigma_err_e, sigma_err_m))
    
    pdf = ROOT.RooDoubleCBFast("{}_{}_pdf".format(cat,proc), "{}_{}_pdf".format(cat,proc), mass, mean_dcb, sigma_dcb, a1_dcb, n1_dcb, a2_dcb, n2_dcb)
    numofevent = dh.sumEntries("1", "higgsRange")
    nevent = ROOT.RooRealVar("{}_{}_pdf_norm".format(cat,proc), "{}_{}_pdf_norm".format(cat,proc), numofevent, 0, 10*numofevent)
    
    fitResult = pdf.fitTo(dh, ROOT.RooFit.Minimizer("Minuit2","minimize"), ROOT.RooFit.Save(1), ROOT.RooFit.Range("higgsRange"), ROOT.RooFit.SumW2Error(ROOT.kTRUE))
#    canvas = ROOT.TCanvas("canvas","",0,0,800,800)
#    frame = mass.frame(ROOT.RooFit.Range("higgsRange"))
#    dh.plotOn(frame, ROOT.RooFit.CutRange("higgsRange"), ROOT.RooFit.DataError(ROOT.RooAbsData.SumW2))
#    pdf.plotOn(frame, ROOT.RooFit.Normalization(dh.sumEntries("1", "higgsRange"), ROOT.RooAbsReal.NumEvent), ROOT.RooFit.NormRange("higgsRange"), ROOT.RooFit.Range("higgsRange"))
#    frame.Draw()
#    canvas.SaveAs(cat + '_' + proc +"_"+str(effl) +"_"+str(effh)+"_DCB.png")
    fitstatus += fitResult.status()
    fitstatus += numofevent
    
    a1_dcb.setConstant(ROOT.kTRUE)
    a2_dcb.setConstant(ROOT.kTRUE)
    dm_dcb.setConstant(ROOT.kTRUE)
    n1_dcb.setConstant(ROOT.kTRUE)
    n2_dcb.setConstant(ROOT.kTRUE)
    sigma.setConstant(ROOT.kTRUE)
    nevent.setConstant(ROOT.kTRUE)
    mean_err_e.setConstant(ROOT.kFALSE)
    mean_err_m.setConstant(ROOT.kFALSE)
    sigma_err_e.setConstant(ROOT.kFALSE)
    sigma_err_m.setConstant(ROOT.kFALSE)
    allvars.append([a1_dcb,a2_dcb,dm_dcb,n1_dcb,n2_dcb,nevent,dh,sigma_dcb,pdf])  
    getattr(w, 'import')(pdf)
    getattr(w, 'import')(nevent)
    getattr(w, 'import')(dh)
  
    constr = [0,0,0,0,0,0]
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
      dh = ROOT.RooDataHist("data_{}_{}_{}".format(cat,proc,sys), "data_{}_{}_{}".format(cat,proc,sys), ROOT.RooArgList(mass), ROOT.RooFit.Import(h))
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
      #fitstatus += fitResult.status()
      
      changeindm = (mean_dcb.getVal() - constr[2])/constr[2]
      changeinsigma = (sigma_dcb.getVal() - constr[5])/constr[5]
      if "s" in sys:
        f.write("{},{},{},dm,{}\n".format(proc,cat,sys,changeindm))
      elif "r" in sys:
        f.write("{},{},{},sigma,{}\n".format(proc,cat,sys,changeinsigma))
      else:
        f.write("{},{},{},dm,{}\n".format(proc,cat,sys,changeindm))
        f.write("{},{},{},sigma,{}\n".format(proc,cat,sys,changeinsigma))
  
  filename = "Workspaces/workspace_sig_"+cat+".root"
#  ROOT.gDirectory.Add(w)
  w.Print()
  w.writeToFile(filename)
  f.close()
  return fitstatus
