import ROOT
f1 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_v18_2.root")
w1 = f1.Get("w")
w1.Print()

