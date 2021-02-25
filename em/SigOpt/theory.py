import os
from sys import argv, stdout, stderr
from ROOT import TFile, gROOT, TCanvas, TLegend, TPad, TH1F
import sys
gROOT.SetStyle("Plain")                                                                                                    
gROOT.SetBatch(True)

#cats = [ggcat0,ggcat1]
#bins = [[[],[],[]], [[],[],[]]]
def QCD_scale(proc,cats,bins):
  QCD_s = {}
  f = [TFile('2016/'+proc), TFile('2017/'+proc), TFile('2018/'+proc)] 
  f_ = TFile(proc.replace('.root','_lhe.root'))
  for c in cats:
    hsum = 0
    h4sum = 0
    h8sum = 0
    catnum = cats.index(c)
    hn = f_.Get('TightOS/lhe0/e_m_Mass')
    h4n = f_.Get('TightOS/lhe4/e_m_Mass')
    h8n = f_.Get('TightOS/lhe8/e_m_Mass')
    for i in range(3):
      h = f[i].Get('TightOSgg/lhe0/MVA')
      h4 = f[i].Get('TightOSgg/lhe4/MVA')
      h8 = f[i].Get('TightOSgg/lhe8/MVA')
      h.Scale(1/(hn.Integral()))
      h4.Scale(1/(h4n.Integral()))
      h8.Scale(1/(h8n.Integral()))

      hsum+=h.Integral(bins[catnum][i][0],bins[catnum][i][1])
      h4sum+=h4.Integral(bins[catnum][i][0],bins[catnum][i][1])
      h8sum+=h8.Integral(bins[catnum][i][0],bins[catnum][i][1])

    QCD_s[c] = 0.5*(h4sum-h8sum)/hsum
  return QCD_s

def acceptance_scale(proc,cats,bins):
  acc_s = {}
  f = [TFile('2016/'+proc), TFile('2017/'+proc), TFile('2018/'+proc)] 
  f_ = TFile(proc.replace('.root','_lhe.root'))
  for c in cats:  
    catnum = cats.index(c)
    hsum = 0
    h1sum = 0
    h2sum = 0
    hn = f_.Get('TightOS/lhe0/e_m_Mass')
    h1n = f_.Get('TightOS/lhe116/e_m_Mass')
    h2n = f_.Get('TightOS/lhe117/e_m_Mass')
    for i in range(3):
      h = f[i].Get('TightOSgg/lhe0/MVA')
      h1 = f[i].Get('TightOSgg/lhe116/MVA')
      h2 = f[i].Get('TightOSgg/lhe117/MVA')
      h.Scale(1/(hn.Integral()))
      h1.Scale(1/(h1n.Integral()))
      h2.Scale(1/(h2n.Integral()))

      hsum+=h.Integral(bins[catnum][i][0],bins[catnum][i][1])
      h1sum+=h1.Integral(bins[catnum][i][0],bins[catnum][i][1])
      h2sum+=h2.Integral(bins[catnum][i][0],bins[catnum][i][1])

    acc_s[c] =  0.75*(h2sum-h1sum)/hsum
  return acc_s

def acceptance_pdf(proc,cats,bins):
  acc_pdf = {}
  f = [TFile('2016/'+proc), TFile('2017/'+proc), TFile('2018/'+proc)] 
  f_ = TFile(proc.replace('.root','_lhe.root'))
  for c in cats:
    catnum = cats.index(c)
    pdfi = []
    hp = TH1F("hp", "GluGlu_LFV 2Jet & M_{jj} > 500GeV PDF Variation", 200, 0.95, 1.05)
    for i in range(9, 112):
      hsum = 0
      hn = f_.Get('TightOS/lhe'+str(i)+'/e_m_Mass')
      for k in range(3):
        h = f[k].Get('TightOSgg/lhe'+str(i)+'/MVA')
        h.Scale(1/(hn.Integral()))
        hsum+=h.Integral(bins[catnum][k][0],bins[catnum][k][1]) 
      pdfi.append(hsum)    
    for j in range(len(pdfi)):
        hp.Fill(pdfi[j]/pdfi[0])
    acc_pdf[c] = hp.GetStdDev()
  return acc_pdf
