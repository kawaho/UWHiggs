import os
from ROOT import TCanvas, TF1, gROOT, TFile, gStyle, gPad, TLatex, TMath
import sys
import glob
import math
gROOT.SetStyle("Plain")
gStyle.SetOptFit()
gROOT.SetBatch(True)

files = []
files.extend(glob.glob('Reso_BDT.root')) 

canvas = TCanvas('canvas','canvas',800,800)


def CrystalballFunction(x, par):
  alpha_l = par[0] 
  n_l     = par[1] 
  mean	= par[2] 
  sigma	= par[3]
  N	= par[4]
  t = (x[0]-mean)/sigma
  fact1TLessMinosAlphaL = alpha_l/n_l
  fact2TLessMinosAlphaL = (n_l/alpha_l) - alpha_l - t
  if (-alpha_l <= t):
    result = TMath.Exp(-0.5*t*t)
  else:
    result = TMath.Exp(-0.5*alpha_l*alpha_l)*TMath.Power(fact1TLessMinosAlphaL*fact2TLessMinosAlphaL, -n_l)
    
  return N*result

def CrystalballplusGaussianFunction(x, par):
  alpha_l = par[0] 
  n_l     = par[1] 
  mean	= par[2] 
  sigma	= par[3]
  mean2 = par[4]
  sigma2 =par[5]
  f	= par[6]
  N = par[7]
  t = (x[0]-mean)/sigma
  t2 = (x[0]-mean2)/sigma2
  fact1TLessMinosAlphaL = alpha_l/n_l
  fact2TLessMinosAlphaL = (n_l/alpha_l) - alpha_l - t
  if (-alpha_l <= t):
    result = TMath.Exp(-0.5*t*t)+f*TMath.Exp(-0.5*t2*t2)/(sigma2*2.506628275)
  else:
    result = TMath.Exp(-0.5*alpha_l*alpha_l)*TMath.Power(fact1TLessMinosAlphaL*fact2TLessMinosAlphaL, -n_l)+f*TMath.Exp(-0.5*t2*t2)/(sigma2*2.506628275)
    
  return N*result

def DoubleSidedCrystalballplusGaussianFunction(x, par):
  alpha_l = par[0] 
  alpha_h = par[1] 
  n_l     = par[2] 
  n_h     = par[3] 
  mean	= par[4] 
  sigma	= par[5]
  mean1 = par[6]
  sigma1 = par[7]
  f = par[8]
  N = par[9]
  t = (x[0]-mean)/sigma
  t2 = (x[0]-mean)/sigma1
  fact1TLessMinosAlphaL = alpha_l/n_l
  fact2TLessMinosAlphaL = (n_l/alpha_l) - alpha_l - t
  fact1THigherAlphaH = alpha_h/n_h
  fact2THigherAlphaH = (n_h/alpha_h) - alpha_h + t
  if (-alpha_l <= t and alpha_h >= t):
    result = TMath.Exp(-0.5*t*t)+f*TMath.Exp(-0.5*t2*t2)
  elif t < -alpha_l:
    result = TMath.Exp(-0.5*alpha_l*alpha_l)*TMath.Power(fact1TLessMinosAlphaL*fact2TLessMinosAlphaL, -n_l)+f*TMath.Exp(-0.5*t2*t2)
  else:
    result = TMath.Exp(-0.5*alpha_h*alpha_h)*TMath.Power(fact1THigherAlphaH*fact2THigherAlphaH, -n_h)+f*TMath.Exp(-0.5*t2*t2)
    
  return N*result

def DoubleGaus(x, par): 
  mean	= par[0] 
  sigma	= par[1]
  mean1 = par[2]
  sigma1 = par[3]
  N	= par[4]
  f = par[5]
  t = (x[0]-mean)/sigma
  t1 = (x[0]-mean1)/sigma1
  result = f*TMath.Exp(-0.5*t*t)/sigma+TMath.Exp(-0.5*t1*t1)/sigma1
  return N*result

def TripleGaus(x, par): 
  mean	= par[0] 
  sigma	= par[1]
  mean1 = par[2]
  sigma1 = par[3]
  mean2 = par[4]
  sigma2 = par[5]
  N	= par[6]
  f = par[7]
  f1 = par[8]
  t = (x[0]-mean)/sigma
  t1 = (x[0]-mean1)/sigma1
  t2 = (x[0]-mean2)/sigma2
  result = f*TMath.Exp(-0.5*t*t)+TMath.Exp(-0.5*t1*t1)+f1*TMath.Exp(-0.5*t2*t2)
  return N*result

def DoubleSidedCrystalballFunction(x, par):
  alpha_l = par[0] 
  alpha_h = par[1] 
  n_l     = par[2] 
  n_h     = par[3] 
  mean	= par[4] 
  sigma	= par[5]
  N	= par[6]
  t = (x[0]-mean)/sigma
  fact1TLessMinosAlphaL = alpha_l/n_l
  fact2TLessMinosAlphaL = (n_l/alpha_l) - alpha_l - t
  fact1THigherAlphaH = alpha_h/n_h
  fact2THigherAlphaH = (n_h/alpha_h) - alpha_h + t
  if (-alpha_l <= t and alpha_h >= t):
    result = TMath.Exp(-0.5*t*t)
  elif t < -alpha_l:
    result = TMath.Exp(-0.5*alpha_l*alpha_l)*TMath.Power(fact1TLessMinosAlphaL*fact2TLessMinosAlphaL, -n_l)
  else:
    result = TMath.Exp(-0.5*alpha_h*alpha_h)*TMath.Power(fact1THigherAlphaH*fact2THigherAlphaH, -n_h)
    
  return N*result

for f in files:
  file = TFile(f)
  for i in range(5):
    hm = file.Get("e_m_Mass_%i"%i)
    f3 = TF1("fitDCB",DoubleSidedCrystalballFunction, 110, 140, 7)
    f3.SetParameters(1.5, 1.5, 3, 10, hm.GetMean(), hm.GetRMS(), 50)
    f3.SetParNames("a_{l}","a_{h}","n_{l}", "n_{h}", "mean", "sigma", "Norm")
    hm.GetXaxis().SetRangeUser(110, 140)
    hm.Fit(f3, "R") 
    print "Chi-square for DoubleSidedCrystalball", f3.GetChisquare(), "dof", f3.GetNDF()
    hm.Draw("P")
    canvas.SaveAs('tfit/' + str(i) +'DSCB.png')
