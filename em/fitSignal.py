import ROOT
import glob

ROOT.gROOT.SetBatch(True)
wsname = "CMS_emu_workspace"
ws = ROOT.RooWorkspace(wsname, wsname)
gcs = []
mhyp = 125
numGaussians = 2
effsigma = 0.683
f_effsigma = open("f_effsigma.txt", "w")
canvas = ROOT.TCanvas('canvas','canvas',800,800)
canvas.SetLeftMargin(0.12)

def makeGaussianVarname(varname, proc, mhyp, catname, gaussIndex):

    if gaussIndex != None:
        gaussIndex = "g%d" % gaussIndex

    parts = [ str(item) for item in [
                varname,
                gaussIndex,
                proc,
                mhyp,
                catname,
              ]    

              if item != None
              ]

    return "_".join(parts)

def makeSumOfGaussians(pdfName, recoMassVar, mhypVar, deltaMuVars, sigmaVars, fractionVars,
                       massScaleNuisance = None, resolutionNuisance = None):

    numGaussians = len(deltaMuVars)
    assert numGaussians == len(sigmaVars)
    assert len(fractionVars) == numGaussians - 1

    pdfs = ROOT.RooArgList()

    for i in range(numGaussians):
        # massHypothesis + deltaM
        expr = "%f + @0" % mhypVar
        args = ROOT.RooArgList(deltaMuVars[i])

        meanVar = ROOT.RooFormulaVar(("mu_g%d_" % i) + pdfName,
                                     "mean Gaussian %d" % i,
                                     expr,
                                     args)
        gcs.append(meanVar)
        sigmaVar = sigmaVars[i]
        gcs.append(sigmaVar)
        pdf = ROOT.RooGaussian(pdfName + "_g%d" % i, "Gaussian %d" % i,
                               recoMassVar,
                               meanVar,
                               sigmaVar)

        gcs.append(pdf)
        pdfs.add(pdf)

    coeffs = ROOT.RooArgList()
    for fractionVar in fractionVars:
        coeffs.add(fractionVar)

    return ROOT.RooAddPdf(pdfName, pdfName, pdfs, coeffs, True)

def findEffSigma(cdf, recoMassVar, count = 1, sigRange = 0, dir_ = None):
  if dir_ == None:
    lower_sig = cdf.findRoot(recoMassVar, 110, 160, (1 - effsigma)/2)
    upper_sig = cdf.findRoot(recoMassVar, 110, 160, (1 + effsigma)/2)
    sigRange  = upper_sig - lower_sig
    if dir_ != "DOWN": 
      lower_sigU = cdf.findRoot(recoMassVar, 110, 160, (1 - effsigma)/2 + 0.1*count)
      upper_sigU = cdf.findRoot(recoMassVar, 110, 160, (1 + effsigma)/2 + 0.1*count)
      sigRangeUp  = upper_sigU - lower_sigU
    if dir_ != "UP":
      lower_sigD = cdf.findRoot(recoMassVar, 110, 160, (1 - effsigma)/2 - 0.1*count)
      upper_sigD = cdf.findRoot(recoMassVar, 110, 160, (1 + effsigma)/2 - 0.1*count)
      sigRangeDown  = upper_sigD - lower_sigD
   
    if sigRange > sigRangeUp:
      findEffSigma(cdf, recoMassVar, count+1 , sigRangeUp, "UP")
    elif sigRange > sigRangeDown:
      findEffSigma(cdf, recoMassVar, count+1, sigRangeDown, "DOWN")
    elif sigRange < sigRangeUp and sigRange < sigRangeDown:
      return sigRange
    else:
      return -9999
     
files = []
files.extend(glob.glob('results/Data2016JEC/AnalyzeEMBDTCat/Signal.root'))
recoMassVar = ROOT.RooRealVar("m_{e#mu}", "m_{e#mu}", 110, 160)
recoMassVar.setUnit("GeV") 
getattr(ws, 'import')(recoMassVar)
hists = {}
a_cb_d = {'ggcat0':1.66340,'ggcat1':1.3383,'ggcat2':1.41669,'vbf':9.52310e-01} 
n_cb_d = {'ggcat0':1.14830,'ggcat1':2.95468,'ggcat2':2.37918,'vbf':4.33335} 
mean_cb_d = {'ggcat0':1.23391e+02,'ggcat1':1.23797e+02,'ggcat2':1.23781e+02,'vbf':1.24682e+02} 
sigma_cb_d = {'ggcat0':3.44544,'ggcat1':2.86757,'ggcat2':2.75902,'vbf':1.52292} 
mean_gaus_d = {'ggcat0':1.24756e+02,'ggcat1':1.24775e+02,'ggcat2':1.24792e+02,'vbf':1.25020e+02} 
sigma_gaus_d = {'ggcat0':1.58110,'ggcat1':1.40025,'ggcat2':1.32489,'vbf':2.82785}
dof = {'ggcat0':52+8,'ggcat1':51+8,'ggcat2':48+8,'vbf':50+8} 

for f in files:
#  proc = "gg" if bool('GluGlu_LFV' in f) else "vbf"
  file = ROOT.TFile(f)
  file.cd()
  for f in file.GetListOfKeys():
    f = f.ReadObj()
    f.cd()
    cat = f.GetName().replace('TightOS', '')
    if cat != "ggcat2": #"gg" or cat == "ggcat3":
      print "Skipping " + cat
      continue
    for h in f.GetListOfKeys(): 
      if h.GetName() == 'e_m_Mass':
        hh = h.ReadObj()  
        hh.Rebin(50)
        histmax = hh.GetMaximum()
        print "hello", cat
        dh = ROOT.RooDataHist("dh_" + cat, "dh_" + cat, ROOT.RooArgList(recoMassVar), ROOT.RooFit.Import(hh))
        hists[cat] = dh
#        dmuvars = [ROOT.RooRealVar(makeGaussianVarname("dmu", proc, mhyp, cat, gaussIndex), "delta mu", gaussIndex, -1.5, +1.5) for gaussIndex in range(numGaussians)]
#        sigmavars = [ ROOT.RooRealVar(makeGaussianVarname("sigma", proc, mhyp, cat, gaussIndex), "sigma", 1 + gaussIndex, 0.01, 10) for gaussIndex in range(numGaussians)]
#        fractionvars = [ ROOT.RooRealVar(makeGaussianVarname("frac", proc, mhyp, cat, gaussIndex), "fraction variable for Gaussian sum", 0.5, 0, 1) for gaussIndex in range(numGaussians - 1)]
    
        dm_cb_v = -125+mean_cb_d[cat]
        sigma_cb_v = sigma_cb_d[cat]
        a_cb_v = a_cb_d[cat]
        n_cb_v = n_cb_d[cat]
        dm_gaus_v = -125+mean_gaus_d[cat]
        sigma_gaus_v = sigma_gaus_d[cat]

#        dm_cb = ROOT.RooRealVar("dm_mh125_cb"+cat,"dm_mh125_cb"+cat,-1,-2, 2)
#        mean_cb = ROOT.RooFormulaVar("mean_mh125_cb"+cat,"mean_mh125_cb"+cat,"125+@0",ROOT.RooArgList(dm_cb))
#        sigma_cb = ROOT.RooRealVar("sigma_mh125_cb"+cat,"sigma_mh125_cb"+cat,2.5,0,10)
#        a_cb = ROOT.RooRealVar("a_mh125_cb"+cat,"a_mh125_cb"+cat, 1,0,10)   
#        n_cb = ROOT.RooRealVar("n_mh125_cb"+cat,"n_mh125_cb"+cat, 5,0,10)
#        pdf_cb = ROOT. RooCBShape("cb_mh125"+cat,"cb_mh125"+cat, recoMassVar,mean_cb,sigma_cb, a_cb, n_cb)
#
#        dm_gaus = ROOT.RooRealVar("dm_mh125_gaus"+cat,"dm_mh125_gaus"+cat, -0.5,-2,2)
#        mean_gaus = ROOT.RooFormulaVar("mean_mh125_gaus"+cat,"mean_mh125_gaus"+cat,"125+@0",ROOT.RooArgList(dm_gaus))
#        sigma_gaus = ROOT.RooRealVar("sigma_mh125_gaus"+cat,"sigma_mh125_gaus"+cat, 1,0,10) 
#        pdf_gaus = ROOT.RooGaussian("gaus_mh125"+cat,"gaus_mh125"+cat,recoMassVar,mean_gaus,sigma_gaus)
#        frac_gaus = ROOT.RooRealVar("frac_mh125"+cat,"frac_mh125"+cat,0.5,0,1)
#
        dm_cb = ROOT.RooRealVar("dm_mh125_cb"+cat,"dm_mh125_cb"+cat,-1,-2, 0.1)
        mean_cb = ROOT.RooFormulaVar("mean_mh125_cb"+cat,"mean_mh125_cb"+cat,"125+@0",ROOT.RooArgList(dm_cb))
        sigma_cb = ROOT.RooRealVar("sigma_mh125_cb"+cat,"sigma_mh125_cb"+cat,2.5,1,5)
        a_cb = ROOT.RooRealVar("a_mh125_cb"+cat,"a_mh125_cb"+cat, 1,0.1,4)   
        n_cb = ROOT.RooRealVar("n_mh125_cb"+cat,"n_mh125_cb"+cat, 2,0.1,4)
        pdf_cb = ROOT. RooCBShape("cb_mh125"+cat,"cb_mh125"+cat, recoMassVar,mean_cb,sigma_cb, a_cb, n_cb)

        dm_gaus = ROOT.RooRealVar("dm_mh125_gaus"+cat,"dm_mh125_gaus"+cat, -0.2,-0.8,0.1)
        mean_gaus = ROOT.RooFormulaVar("mean_mh125_gaus"+cat,"mean_mh125_gaus"+cat,"125+@0",ROOT.RooArgList(dm_gaus))
        sigma_gaus = ROOT.RooRealVar("sigma_mh125_gaus"+cat,"sigma_mh125_gaus"+cat, 1.5,0.1,4) 
        pdf_gaus = ROOT.RooGaussian("gaus_mh125"+cat,"gaus_mh125"+cat,recoMassVar,mean_gaus,sigma_gaus)
        frac_gaus = ROOT.RooRealVar("frac_mh125"+cat,"frac_mh125"+cat,0.5,0.1,0.9)

        pdf = ROOT.RooAddPdf("mh125"+cat,"mh125"+cat,pdf_cb,pdf_gaus,frac_gaus)

#        dm_cb = ROOT.RooRealVar("dm_mh125_cb"+cat,"dm_mh125_cb"+cat,dm_cb_v)
#        mean_cb = ROOT.RooFormulaVar("mean_mh125_cb"+cat,"mean_mh125_cb"+cat,"125+@0",ROOT.RooArgList(dm_cb))
#        sigma_cb = ROOT.RooRealVar("sigma_mh125_cb"+cat,"sigma_mh125_cb"+cat,sigma_cb_v)
#        a_cb = ROOT.RooRealVar("a_mh125_cb"+cat,"a_mh125_cb"+cat, a_cb_v)   
#        n_cb = ROOT.RooRealVar("n_mh125_cb"+cat,"n_mh125_cb"+cat, n_cb_v)
#        pdf_cb = ROOT. RooCBShape("cb_mh125"+cat,"cb_mh125"+cat, recoMassVar,mean_cb,sigma_cb, a_cb, n_cb)
#
#        dm_gaus = ROOT.RooRealVar("dm_mh125_gaus"+cat,"dm_mh125_gaus"+cat, dm_gaus_v)
#        mean_gaus = ROOT.RooFormulaVar("mean_mh125_gaus"+cat,"mean_mh125_gaus"+cat,"125+@0",ROOT.RooArgList(dm_gaus))
#        sigma_gaus = ROOT.RooRealVar("sigma_mh125_gaus"+cat,"sigma_mh125_gaus"+cat, sigma_gaus_v) 
#        pdf_gaus = ROOT.RooGaussian("gaus_mh125"+cat,"gaus_mh125"+cat,recoMassVar,mean_gaus,sigma_gaus)
#        frac_gaus = ROOT.RooRealVar("frac_mh125"+cat,"frac_mh125"+cat,0.5,0,1)
#
#        pdf = ROOT.RooAddPdf("mh125"+cat,"mh125"+cat,pdf_cb,pdf_gaus,frac_gaus)
#
#        dmuvars = ROOT.RooRealVar(makeGaussianVarname("dmu", proc, mhyp, cat, gaussIndex), "delta mu", gaussIndex, -1.5, +1.5)
#        sigmavars = ROOT.RooRealVar(makeGaussianVarname("sigma", proc, mhyp, cat, gaussIndex), "sigma", 1 + gaussIndex, 0.01, 10)
#
#        expr = "125 + @0" 
#        args = ROOT.RooArgList(dmuvars)
#        meanVar = ROOT.RooFormulaVar(("mu_g_"), "mean Gaussian", expr, args)
#        a1_cb = ROOT.RooRealVar("a1_mh_cb", "a1_mh_cb",  0.812478, 0, 10)  
#        n1_cb = ROOT.RooRealVar("n1_mh_cb", "n1_mh_cb", 3.90456, 0 ,500)  

#        pdf = ROOT.RooCBShape("sigpdf_" + suffix,"sigpdf_" + suffix, recoMassVar, meanVar ,sigmavars, a1_cb, n1_cb)
#        pdf = makeSumOfGaussians("sigpdf_" + suffix, recoMassVar, mhyp, dmuvars, sigmavars, fractionvars)
        pdf.fitTo(dh, ROOT.RooFit.Minimizer("Minuit2","minimize"), ROOT.RooFit.Range(mhyp - 15,mhyp + 15), ROOT.RooFit.SumW2Error(True))
#        getattr(ws, 'import')(pdf, ROOT.RooFit.RecycleConflictNodes())
#        cdf = pdf.createCdf(ROOT.RooArgSet(recoMassVar))
#        eff_sig = str("%.3f" % round(findEffSigma(cdf, recoMassVar)/2,3))
#        result_effSigma = proc + "_" + cat + "\n" + eff_sig + "\n"
#        f_effsigma.write(result_effSigma)

        recoMassVar.setRange("higgsRange",110.,140.);
      ##Do single Gaussian Fit
      #  mean = ROOT.RooRealVar("mean","Mean of Gaussian",mhyp,mhyp-1.5,mhyp+1.5)
      #  sigma = ROOT.RooRealVar("sigma","Width of Gaussian",1,0.01,10) 
      #  pdf = ROOT.RooGaussian("gauss","gauss(x,mean,sigma)",recoMassVar,mean,sigma)
      #  pdf.fitTo(dh, ROOT.RooFit.Minimizer("Minuit2"), ROOT.RooFit.Range(mhyp - 5, mhyp + 5))
      
      #  sumWeights = dh.sumEntries()
      #  normVar = ROOT.RooRealVar(gauss.GetName() + "_norm", gauss.GetName() + "_norm", sumWeights, 0, sumWeights)
      #  normVar.setConstant(True)
      
        frame = recoMassVar.frame(ROOT.RooFit.Range("higgsRange"), ROOT.RooFit.Title(" "))
        numofevent = dh.sumEntries("1", "higgsRange")
        dh.plotOn(frame,ROOT.RooFit.CutRange("higgsRange"))
        latex = ROOT.TLatex()
        latex.SetNDC()
        latex.SetTextFont(43)
        latex.SetTextSize(20)
        latex.SetTextAlign(31)
        latex.SetTextAlign(11)
        label_text = "#bf{CMS Preliminary}"
        year ='2016+2017'
        data_text = ("35.9 + 41.5 fb^{-1}")
        data_text += " (2016 + 2017,"
        data_text += " %i TeV)" % 13
        jets_text = "e#mu"
        jets_text +=" "+ cat
        pdf.plotOn(frame, ROOT.RooFit.NormRange("higgsRange"),ROOT.RooFit.Range("higgsRange"))
        #pdf.plotOn(frame, ROOT.RooFit.Normalization(numofevent,ROOT.RooAbsReal.NumEvent),ROOT.RooFit.NormRange("higgsRange"),ROOT.RooFit.Range("higgsRange"))
        txt = "#chi^{2} / ndf = " + "%.2f"%(frame.chiSquare()*dh.numEntries()) + " / " + "%i"%(dh.numEntries()-7)
        frame.Draw()
        latex.DrawLatex(0.65, 0.80, txt)
        latex.DrawLatex(0.16, 0.84, label_text)
        latex.DrawLatex(0.52, 0.91, data_text)
        latex.DrawLatex(0.16, 0.80, cat)

        print "chi2/dof:", frame.chiSquare(7)
#        print "chi2/dof:", frame.chiSquare()*(dof[cat]+1)/(dof[cat]-7), dof[cat]-7
        canvas.SaveAs("SignalPlot/" + cat + ".png")
#    f_effsigma.write("\n")
#  f_effsigma.write("\n")
#f_effsigma.close()
#for hist in hists.values():
#getattr(ws, 'import')(hists['combined_2JetVBF'])
ws.Print()
ws.writeToFile("emu_ws.root")
