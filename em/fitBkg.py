import sys, re, math, glob

gcs = []


def makeBernstein(recoMassVar, prefix, order):

    coeffList = ROOT.RooArgList()
    
    for i in range(order):
        name = "%s_p%d" % (prefix ,i)

        if i < 3:
            # param = new RooRealVar(name.c_str(),name.c_str(),10., 0.,50.);
            # param = ROOT.RooRealVar(name, name, 5., 0.,20.)
            param1 = ROOT.RooRealVar(name + "_sqrt", name + "_sqrt", math.sqrt(5.), - math.sqrt(20.), + math.sqrt(20.))
        else:
            # param = new RooRealVar(name.c_str(),name.c_str(),10., 0.,50.);
            # param = ROOT.RooRealVar(name, name, 5., 0.,20.)
            param1 = ROOT.RooRealVar(name + "_sqrt", name + "_sqrt", math.sqrt(5.), - math.sqrt(20.), + math.sqrt(20.))

        gcs.append(param1)

        param = ROOT.RooFormulaVar(name, name, "@0 * @0", ROOT.RooArgList(param1))

        gcs.append(param)
        coeffList.add(param)

    return ROOT.RooBernstein(prefix, prefix, recoMassVar, coeffList)


def makeExponential(recoMassVar, prefix, order):

    if order % 2==0:
        raise Exception("only an odd number of parameters is allowed for exponential functions")

    nfracs = (order - 1) / 2
    nexps = order - nfracs

    assert nfracs == nexps-1
    
    fracs = ROOT.RooArgList()
    exps  = ROOT.RooArgList()

    for i in range(1, nfracs + 1):
        name =  "%s_f%d" % (prefix, i)
        param = ROOT.RooRealVar(name, name,
                                0.9 - float(i-1)*1./nfracs,
                                0.0001, 0.9999)
        fracs.add(param)
        gcs.append(param)

    for i in range(1, nexps + 1):

        name  = "%s_p%d" % (prefix, i)
        ename = "%s_e%d" % (prefix, i)
        param = ROOT.RooRealVar(name, name,
                                max(-2. , -0.04 * (i+1) ),
                                -2.,0.); gcs.append(param)

        func = ROOT.RooExponential(ename, ename, recoMassVar, param); gcs.append(func)
        
        exps.add(func);

    return ROOT.RooAddPdf(prefix, prefix, exps, fracs, True)


def makePowerLaw(recoMassVar, prefix, order):

    if order % 2==0:
        raise Exception("only an odd number of parameters is allowed for poewr law functions")

    nfracs = (order - 1) / 2
    npows  = order - nfracs
    assert nfracs == npows - 1
    
    fracs = ROOT.RooArgList()
    pows  = ROOT.RooArgList()

    for i in range(1, nfracs + 1):
        name =  "%s_f%d" % (prefix,i);
        param = ROOT.RooRealVar(name, name,
                                0.9 - float(i-1) * 1./ nfracs,
                                0.,1.); gcs.append(param)
        fracs.add(param)

    ROOT.gSystem.Load("$CMSSW_BASE/lib/$SCRAM_ARCH/libHiggsAnalysisCombinedLimit.so")
    
    for i in range(1, npows + 1):

        name  = "%s_p%d" % (prefix, i)
        ename = "%s_e%d" % (prefix, i)

        param = ROOT.RooRealVar(name, name,
                                max(-10., -1.0*(i+1) ), # initial value
                                # may work better but does it affect
                                # the generation of toys ?
                                # TMath::Max(-10.,-0.1*(i+1)), // initial value

                                -10.,0. # range
                                ); gcs.append(param)

        func = ROOT.RooPower(ename, ename, recoMassVar, param)
        gcs.append(func)
        pows.add(func);


    return ROOT.RooAddPdf(prefix, prefix, pows, fracs, True)


def addBackgroundFunction(recoMassVar, cat, bgfuncName, pdfName = None):

    mo = re.match("(\S+)(\d+)$", bgfuncName)
    name, order = mo.groups()
    order = int(order)

    if name == 'pol':
      bgfunc = makeBernstein(recoMassVar, pdfName, order)

    elif name == 'exp':
      bgfunc = makeExponential(recoMassVar, pdfName, order)

    elif name == 'pow':
      bgfunc = makePowerLaw(recoMassVar, pdfName, order)
        
    else:
      raise Exception("unsupported background function type '%s'" % name)

    gcs.append(bgfunc)

    return bgfunc


paramFname = 'parameters/bgfunc.py'
cat = '0'

import imp
parametersModule = imp.load_source('parameters', paramFname)
bgfuncs = parametersModule.bgfuncs
import ROOT
ROOT.gROOT.SetBatch(1)

recoMassVar = ROOT.RooRealVar("Meu", "Meu", 110, 140)
canvas = ROOT.TCanvas('canvas','canvas',800,800)

files = []
files.extend(glob.glob('results/Data2017JEC/AnalyzeEM/data_MuonEG_Run2017B-31Mar2018.root')) 
for file in files:
  f = ROOT.TFile(file)
  hh = f.Get("TightOS/e_m_Mass")
  dh = ROOT.RooDataHist("dh", "dh", ROOT.RooArgList(recoMassVar), ROOT.RooFit.Import(hh))
  pdfname = "pdf_bkg_" + cat
  bgpdf = addBackgroundFunction(recoMassVar, cat, bgfuncs['cat0'], "pdf_bkg_" + cat)
  numEvents = dh.sumEntries()
  normFunc = ROOT.RooRealVar(pdfname + "_norm", pdfname + "_norm", numEvents, 0, 10 * numEvents) 
  gcs.append(normFunc)
  extPdf = ROOT.RooExtendPdf(pdfname + "_ext", pdfname + "_ext", bgpdf, normFunc)
  extPdf.fitTo(dh, ROOT.RooFit.Minimizer("Minuit2")) 
  frame = recoMassVar.frame()
  dh.plotOn(frame)
  extPdf.plotOn(frame)
  frame.Draw()
  canvas.SaveAs(pdfname+"_plot.png")
