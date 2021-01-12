import ROOT
file = ROOT.TFile("trial.root")
canvas = ROOT.TCanvas('canvas','canvas',800,800)
ws = file.Get("wsig_13TeV")
#ws = dir_.Get("CMS_emu_workspace")
ws.Print()
#pdf = ws.obj("0JetEB-ME")
pdf = ws.obj("dcb_0JetEB-ME")
data = ws.obj("Signal_13TeV_0JetEB-ME")
norm = ROOT.RooRealVar("norm","norm",data.sumEntries(),0,10E6)
fit = ROOT.RooExtendPdf("ext","ext",pdf,norm)

#a1 = ws.obj("a1_0JetEB-ME")
#a2 = ws.obj("a2_0JetEB-ME")  
#dm = ws.obj("dm_0JetEB-ME")
#n1 = ws.obj("n1_0JetEB-ME")
#n2 = ws.obj("n2_0JetEB-ME")
#sigma = ws.obj("#sigma_0JetEB-ME")

#set_ = ROOT.RooArgSet(a1, a2, dm, n1, n2, sigma)

numofevent = data.sumEntries()
mass = ws.obj("CMS_emu_Mass")
frame = mass.frame()

print "mean", data.mean(mass)
print "sigma", data.sigma(mass)

#frame = pdf.paramOn(frame, ROOT.RooFit.Parameters(set_), ROOT.RooFit.Layout(0.57,0.87,0.88))
#frame.getAttText().SetTextSize(0.02)
fit.plotOn(frame, ROOT.RooFit.Normalization(numofevent, ROOT.RooAbsReal.NumEvent), ROOT.RooFit.Name("fit"))
data.plotOn(frame, ROOT.RooFit.Name("data"))

np = pdf.getParameters(data).getSize()
chi2 = frame.chiSquare("fit","data",np);
print np
print chi2


frame.Draw()
canvas.SaveAs("trial1.png")
