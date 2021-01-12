import ROOT
file = ROOT.TFile("dataws2.root")
canvas = ROOT.TCanvas('canvas','canvas',800,800)
ws = file.Get("CMS_emu_workspace")
ws.Print()
tbins =  ROOT.RooBinning(110,160)
tbins.addUniform(50,110,160)
for cat in ['gg0', 'gg1', 'gg2','vbf']:
  data = ws.obj("Data_13TeV_" + cat)
  mass = ws.obj("CMS_emu_Mass")
  frame = mass.frame()
  data.plotOn(frame, ROOT.RooFit.Binning(tbins))
  frame.Draw()
  canvas.SaveAs(cat + "trial1.png")
