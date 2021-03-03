import ROOT
rfileGG = ROOT.TFile('GG_proj.root')
rfileVBF = ROOT.TFile('VBF_proj.root')
#hb = ROOT.TH1D("","",50,110,160 
hGG = rfileGG.Get("range%i"%i)
hVBF = rfileVBF.Get("range%i"%i)
for i in range(100):
  hb.Add(rfile.Get("range%i"%i))
print hb.Integral()
