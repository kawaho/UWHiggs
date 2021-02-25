import os
from sys import argv, stdout, stderr
from ROOT import TFile, gROOT, TCanvas, TLegend, TPad, TH1F
import sys
gROOT.SetStyle("Plain")                                                                                                    
gROOT.SetBatch(True)
def QCD_scale(proc,cats):
  QCD_s = {}
  f = TFile('Signal'+proc+'_or2_bin.root')
  for c in cats:
    h = f.Get('TightOS'+c+'/lhe0/e_m_Mass');hn = f.Get('TightOS/lhe0/e_m_Mass')
    h1 = f.Get('TightOS'+c+'/lhe1/e_m_Mass');h1n = f.Get('TightOS/lhe1/e_m_Mass')
    h2 = f.Get('TightOS'+c+'/lhe2/e_m_Mass');h2n = f.Get('TightOS/lhe2/e_m_Mass')
    h3 = f.Get('TightOS'+c+'/lhe3/e_m_Mass');h3n = f.Get('TightOS/lhe3/e_m_Mass')
    h4 = f.Get('TightOS'+c+'/lhe4/e_m_Mass');h4n = f.Get('TightOS/lhe4/e_m_Mass')
    h6 = f.Get('TightOS'+c+'/lhe6/e_m_Mass');h6n = f.Get('TightOS/lhe6/e_m_Mass')
    h8 = f.Get('TightOS'+c+'/lhe8/e_m_Mass');h8n = f.Get('TightOS/lhe8/e_m_Mass')
    h.Scale(1/(hn.Integral()));h1.Scale(1/(h1n.Integral()));h2.Scale(1/(h2n.Integral()));h3.Scale(1/(h3n.Integral()));h4.Scale(1/(h4n.Integral()));h6.Scale(1/(h6n.Integral()));h8.Scale(1/(h8n.Integral()))
    QCD_s[c] = 0.5*(h4.Integral()-h8.Integral())/h.Integral()
  return QCD_s

def acceptance_scale(proc,cats):
  acc_s = {}
  f = TFile('Signal'+proc+'_or2_bin.root')
  for c in cats:  
    h = f.Get('TightOS'+c+'/lhe0/e_m_Mass');hn = f.Get('TightOS/lhe0/e_m_Mass')
    h1 = f.Get('TightOS'+c+'/lhe116/e_m_Mass');h1n = f.Get('TightOS/lhe116/e_m_Mass')
    h2 = f.Get('TightOS'+c+'/lhe117/e_m_Mass');h2n = f.Get('TightOS/lhe117/e_m_Mass')
    h.Scale(1/(hn.Integral()));h1.Scale(1/(h1n.Integral()));h2.Scale(1/(h2n.Integral()))
    acc_s[c] =  0.75*(h2.Integral()-h1.Integral())/h.Integral()
  return acc_s

def acceptance_pdf(proc,cats):
  acc_pdf = {}
  f = TFile('Signal'+proc+'_or2_bin.root')
  for c in cats:
    pdfi = []
    hp = TH1F("hp", "GluGlu_LFV 2Jet & M_{jj} > 500GeV PDF Variation", 200, 0.95, 1.05)
    for i in range(9, 112):
#        print proc, c
        h = f.Get('TightOS'+c+'/lhe'+str(i)+'/e_m_Mass')
        hn = f.Get('TightOS/lhe'+str(i)+'/e_m_Mass')
        h.Scale(1/(hn.Integral()))
        pdfi.append(h.Integral())    
    for j in range(len(pdfi)):
        hp.Fill(pdfi[j]/pdfi[0])
    acc_pdf[c] = hp.GetStdDev()
  return acc_pdf
