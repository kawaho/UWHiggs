import ROOT
file = ROOT.TFile("dataws.root")
#canvas = ROOT.TCanvas('canvas','canvas',800,800)
ws = file.Get("CMS_emu_workspace")
ws.Print()
#data = ws.obj("Signal_13TeV_gg0")

#mass = ws.obj("CMS_emu_Mass")
#frame = mass.frame()

#data.plotOn(frame, ROOT.RooFit.Name("data"))


#frame.Draw()
#canvas.SaveAs("trial1.png")
