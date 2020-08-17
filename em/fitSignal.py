import ROOT
import glob

gcs = []
mhyp = 125
numGaussians = 2
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

files = []
files.extend(glob.glob('results_root/Data2017JEC/AnalyzeEM/VBF*.root')) 
for file in files:
  f = ROOT.TFile(file)
  proc = "gg" if bool('GluGlu_LFV' in file) else "vbf"
  hh = f.Get("TightOS/e_m_Mass")
  recoMassVar = ROOT.RooRealVar("Meu", "Meu", 110, 140)
  dh = ROOT.RooDataHist("dh", "dh", ROOT.RooArgList(recoMassVar), ROOT.RooFit.Import(hh))
  dmuvars = [ROOT.RooRealVar(makeGaussianVarname("dmu", proc, mhyp, 0, gaussIndex), "delta mu", gaussIndex, -1.5, +1.5) for gaussIndex in range(numGaussians)]
  sigmavars = [ ROOT.RooRealVar(makeGaussianVarname("sigma", proc, mhyp, 0, gaussIndex), "sigma", 1 + gaussIndex, 0.01, 10) for gaussIndex in range(numGaussians)]
  fractionvars = [ ROOT.RooRealVar(makeGaussianVarname("frac", proc, mhyp, 0, gaussIndex), "fraction variable for Gaussian sum", 0.5, 0, 1) for gaussIndex in range(numGaussians - 1)]
  suffix = "_".join([proc, "0",])
  pdf = makeSumOfGaussians("sigpdf_" + suffix, recoMassVar, mhyp, dmuvars, sigmavars, fractionvars)
  pdf.fitTo(dh, ROOT.RooFit.Minimizer("Minuit2"), ROOT.RooFit.Range(mhyp - 5,mhyp + 5), ROOT.RooFit.SumW2Error(False))

##Do single Gaussian Fit
#  mean = ROOT.RooRealVar("mean","Mean of Gaussian",mhyp,mhyp-1.5,mhyp+1.5)
#  sigma = ROOT.RooRealVar("sigma","Width of Gaussian",1,0.01,10) 
#  pdf = ROOT.RooGaussian("gauss","gauss(x,mean,sigma)",recoMassVar,mean,sigma)
#  pdf.fitTo(dh, ROOT.RooFit.Minimizer("Minuit2"), ROOT.RooFit.Range(mhyp - 5, mhyp + 5))

#  sumWeights = dh.sumEntries()
#  normVar = ROOT.RooRealVar(gauss.GetName() + "_norm", gauss.GetName() + "_norm", sumWeights, 0, sumWeights);
#  normVar.setConstant(True)

  frame = recoMassVar.frame()
  dh.plotOn(frame)
  gauss.plotOn(frame)
  frame.Draw()
  canvas.SaveAs(makeGaussianVarname("plot", proc, mhyp, 0, gaussIndex) + ".png")
