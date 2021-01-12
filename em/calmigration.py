from ROOT import TFile, TH1
from Kinematics import sysnames2, catnames 
file_ = TFile("results/Data2017JEC/AnalyzeEMCatSys/Signal.root")
for cat in catnames:
  hnom = file_.Get(cat+"/e_m_Mass")
  nevents_nom = hnom.Integral()
  for n in sysnames2:
    cat_ = n.split('/')[0]
    if cat == cat_:
      h = file_.Get(n+"/e_m_Mass")
      nevents = h.Integral()
      print cat, n, nevents/nevents_nom


