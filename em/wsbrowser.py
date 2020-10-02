import ROOT
file = ROOT.TFile("trial.root")
canvas = ROOT.TCanvas('canvas','canvas',800,800)
ws = file.Get("wsig_13TeV")
#ws = dir_.Get("CMS_emu_workspace")
ws.Print()
#pdf = ws.obj("0JetEB-ME")
pdf = ws.obj("gg1")
data = ws.obj("Signal_13TeV_gg1")
norm = ROOT.RooRealVar("norm","norm",data.sumEntries(),0,10E6)
fit = ROOT.RooExtendPdf("ext","ext",pdf,norm)

#a1 = ws.obj("a1_0JetEB-ME")
#a2 = ws.obj("a2_0JetEB-ME")  
#dm = ws.obj("dm_0JetEB-ME")
#n1 = ws.obj("n1_0JetEB-ME")
#n2 = ws.obj("n2_0JetEB-ME")
#sigma = ws.obj("#sigma_0JetEB-ME")

#set_ = ROOT.RooArgSet(a1, a2, dm, n1, n2, sigma)

mass = ws.obj("CMS_emu_Mass")
mass.setRange("higgsRange",115.,135.);
numofevent = data.sumEntries("1", "higgsRange")
frame = mass.frame(ROOT.RooFit.Range("higgsRange"))

#print "mean", data.mean(mass)
#print "sigma", data.sigma(mass)

#frame = pdf.paramOn(frame, ROOT.RooFit.Parameters(set_), ROOT.RooFit.Layout(0.57,0.87,0.88))
#frame.getAttText().SetTextSize(0.02)
#h->Integral(),RooAbsReal::NumEvent),NormRange("higgsRange"),Range("higgsRange")
fit.plotOn(frame, ROOT.RooFit.Normalization(numofevent,ROOT.RooAbsReal.NumEvent),ROOT.RooFit.NormRange("higgsRange"),ROOT.RooFit.Range("higgsRange"),ROOT.RooFit.Name("fit"))

#data.Integral(), RooAbsReal::NumEvent),NormRange("higgsRange"),Range("higgsRange")


#ROOT.RooFit.Normalization(numofevent, ROOT.RooAbsReal.NumEvent), ROOT.RooFit.Name("fit"))
data.plotOn(frame,ROOT.RooFit.CutRange("higgsRange"), ROOT.RooFit.Name("data"))

np = pdf.getParameters(data).getSize()
chi2 = frame.chiSquare("fit","data",np);
print np
print chi2


frame.Draw()
canvas.SaveAs("trial1.png")
