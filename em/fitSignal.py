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
files.extend(glob.glob('results/Data2017JEC/AnalyzeEMCut/vbf_gg.root'))
recoMassVar = ROOT.RooRealVar("M_{e#mu}", "M_{e#mu}", 110, 160)
recoMassVar.setUnit("GeV/c^{2}") 
getattr(ws, 'import')(recoMassVar)
hists = {}
for f in files:
  proc = "combined"
#  proc = "gg" if bool('GluGlu_LFV' in f) else "vbf"
  file = ROOT.TFile(f)
  file.cd()
  for f in file.GetListOfKeys():
    f = f.ReadObj()
    f.cd()
    cat = f.GetName().replace('TightOS', '')
    for h in f.GetListOfKeys(): 
      if h.GetName() == 'e_m_Mass':
        hh = h.ReadObj()  
        histmax = hh.GetMaximum()
        suffix = "_".join([proc, cat,]) 
        print "hello", suffix
        dh = ROOT.RooDataHist("dh_" + suffix, "dh_" + suffix, ROOT.RooArgList(recoMassVar), ROOT.RooFit.Import(hh))
        hists[suffix] = dh
        dmuvars = [ROOT.RooRealVar(makeGaussianVarname("dmu", proc, mhyp, cat, gaussIndex), "delta mu", gaussIndex, -1.5, +1.5) for gaussIndex in range(numGaussians)]
        sigmavars = [ ROOT.RooRealVar(makeGaussianVarname("sigma", proc, mhyp, cat, gaussIndex), "sigma", 1 + gaussIndex, 0.01, 10) for gaussIndex in range(numGaussians)]
        fractionvars = [ ROOT.RooRealVar(makeGaussianVarname("frac", proc, mhyp, cat, gaussIndex), "fraction variable for Gaussian sum", 0.5, 0, 1) for gaussIndex in range(numGaussians - 1)]

        pdf = makeSumOfGaussians("sigpdf_" + suffix, recoMassVar, mhyp, dmuvars, sigmavars, fractionvars)
        pdf.fitTo(dh, ROOT.RooFit.Minimizer("Minuit2"), ROOT.RooFit.Range(mhyp - 15,mhyp + 35), ROOT.RooFit.SumW2Error(False))
#        getattr(ws, 'import')(pdf, ROOT.RooFit.RecycleConflictNodes())
        cdf = pdf.createCdf(ROOT.RooArgSet(recoMassVar))
        eff_sig = str("%.3f" % round(findEffSigma(cdf, recoMassVar)/2,3))
        result_effSigma = proc + "_" + cat + "\n" + eff_sig + "\n"
        f_effsigma.write(result_effSigma)

      ##Do single Gaussian Fit
      #  mean = ROOT.RooRealVar("mean","Mean of Gaussian",mhyp,mhyp-1.5,mhyp+1.5)
      #  sigma = ROOT.RooRealVar("sigma","Width of Gaussian",1,0.01,10) 
      #  pdf = ROOT.RooGaussian("gauss","gauss(x,mean,sigma)",recoMassVar,mean,sigma)
      #  pdf.fitTo(dh, ROOT.RooFit.Minimizer("Minuit2"), ROOT.RooFit.Range(mhyp - 5, mhyp + 5))
      
      #  sumWeights = dh.sumEntries()
      #  normVar = ROOT.RooRealVar(gauss.GetName() + "_norm", gauss.GetName() + "_norm", sumWeights, 0, sumWeights);
      #  normVar.setConstant(True)
      
        frame = recoMassVar.frame(ROOT.RooFit.Title(cat))
        dh.plotOn(frame)
        pdf.plotOn(frame)
        txt = ROOT.TLatex(140, histmax*.8, "#sigma_{eff} = " + eff_sig)
        txt.SetTextSize(0.05)
        frame.addObject(txt)
        frame.Draw()
        canvas.SaveAs("SignalPlot/" + makeGaussianVarname("plot", proc, mhyp, cat, gaussIndex) + ".png")
    f_effsigma.write("\n")
  f_effsigma.write("\n")
f_effsigma.close()
#for hist in hists.values():
getattr(ws, 'import')(hists['combined_2JetVBF'])
ws.writeToFile("emu_ws.root")
