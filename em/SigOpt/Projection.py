from ROOT import TLatex, gROOT, gPad, TFile, TH1F, TH2F, TGraph, TCanvas, TLine, gPad, TMultiGraph, TPaveText
import numpy as np
import argparse
parser = argparse.ArgumentParser(
    "Create pre/post-fit plots for LFV H analysis")
parser.add_argument(
    "--type",
    type=str,
    action="store",
    dest="type_",
    default="GG",
    help="Which variable")
parser.add_argument(
    "--year",
    type=str,
    action="store",
    dest="year_",
    default="2016",
    help="Which category")
args = parser.parse_args()
type_ = args.type_
year_ = args.year_
fFileS = TFile("%s/signal.root"%(year_))
fFileProj = TFile("%s/%s.root"%(year_,type_))
sysname = ["eesUp", "eesDown", "eerUp", "eerDown", "meUp", "meDown"]
n = 100
nyear = 3
xq = np.empty(n)
yq = np.empty(n)
for i in range(n):
  xq[i] = (i+1)/float(n)

hmvaS = fFileS.Get("TightOSgg/MVA")
SigStep = [1]
hmvaS.GetQuantiles(n,yq,xq)
for j in range(n):
  SigStep.append(hmvaS.FindBin(yq[j]))
file_proj = TFile("%s/%s_proj.root"%(year_,type_),"recreate")
for i in range(len(SigStep)-1):
  print "Scanning for year %s and range %i"%(year_,i)
  h = fFileProj.Get("TightOSgg/MVA_e_m_Mass").ProjectionY("range%i"%i, SigStep[i], SigStep[i+1])
  if type_ == "data":
    h.Rebin(100)
  else:
    h.Rebin(25)
  h.Write()
  if type_ == "data": continue
  for sys in sysname:
    h = fFileProj.Get("TightOSgg/"+sys+"/MVA_e_m_Mass").ProjectionY("%s_range%i"%(sys,i), SigStep[i], SigStep[i+1])
    h.Rebin(25)
    h.Write()
file_proj.Close()
