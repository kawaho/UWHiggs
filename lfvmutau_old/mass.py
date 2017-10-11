import os
from sys import argv, stdout, stderr
import ROOT
import sys
from FinalStateAnalysis.PlotTools.MegaBase import make_dirs

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)
ROOT.gStyle.SetOptTitle(0)
ROOT.gStyle.SetTitle("Visible Mass vs Collinear Mass")
ROOT.gStyle.SetOptTitle(1)
ROOT.TGaxis.SetMaxDigits(2)
 
canvas = ROOT.TCanvas("canvas","canvas",800,800)
legend = ROOT.TLegend(0.1,0.7,0.48,0.9)
fwhm = ROOT.TLegend(0.52,0.7,0.9,0.9)
#title = ROOT.TPaveLabel(.11,.95,.35,.99,"Vis M vs Col M","brndc")
   

lfvfilelist = ['results/LFV_mutau/LFVMuTauAnalyserGen/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8_v6-v1.root']# , 'results/LFV_mutau/LFVMuTauAnalyserGen/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8_v6-v1.root']

filepath = 'plots/LFV_mutau/LFVMuTauAnalyserGen/'

lumi = 514721.021207

fwhm1 = ''
fwhm2 = ''

for n, file in enumerate(lfvfilelist):

        MuTaufile = ROOT.TFile(file)
        gendir = MuTaufile.Get('fromHiggs')#('mt')
        hlist = gendir.GetListOfKeys()
	
        iter = ROOT.TIter(hlist)
        for i in iter:
		if i.GetName()=='m_t_Mass':
			lfv_histo_vis = MuTaufile.Get('fromHiggs/'+i.GetName())#('mt/'+i.GetName())
			if lfv_histo_vis.Integral() != 0:
#				lfv_histo_vis.Scale(1./lfv_histo_vis.Integral())
				bin1 = lfv_histo_vis.FindFirstBinAbove(lfv_histo_vis.GetMaximum()/2)
				bin2 = lfv_histo_vis.FindLastBinAbove(lfv_histo_vis.GetMaximum()/2)
				fwhm1 = str(lfv_histo_vis.GetBinCenter(bin2) - lfv_histo_vis.GetBinCenter(bin1))
				lfv_histo_vis.Scale(1/lumi)
				lfv_histo_vis.Rebin(5)
				lfv_histo_vis.SetLineWidth(2)
				lfv_histo_vis.SetLineColor(2)
				lfv_histo_vis.SetMaximum(2.0*lfv_histo_vis.GetMaximum())
				lfv_histo_vis.GetXaxis().SetTitle("Mass(GeV)")
				lfv_histo_vis.GetYaxis().SetTitle("Normalised to Luminosity")
				lfv_histo_vis.GetYaxis().SetTitleOffset(1.4)
				lfv_histo_vis.SetTitle("Visible Mass vs Collinear Mass")
				lfv_histo_vis.Draw('hist')
				print lfv_histo_vis.GetMaximum() 
				print lfv_histo_vis.GetBinContent(lfv_histo_vis.GetMaximumBin())
				
		if i.GetName()=='m_t_collinearmass':
			lfv_histo_col = MuTaufile.Get('fromHiggs/'+i.GetName())#('mt/'+i.GetName()) 
			if lfv_histo_col.Integral() != 0:
#                                lfv_histo_col.Scale(1./lfv_histo_col.Integral())
				bin3 = lfv_histo_col.FindFirstBinAbove(lfv_histo_col.GetMaximum()/2)
                                bin4 = lfv_histo_col.FindLastBinAbove(lfv_histo_col.GetMaximum()/2)
                                fwhm2 = str(lfv_histo_col.GetBinCenter(bin4) - lfv_histo_col.GetBinCenter(bin3))
				lfv_histo_col.Scale(1/lumi)
				lfv_histo_col.Rebin(5)
                                lfv_histo_col.SetLineWidth(2)
				lfv_histo_col.Draw("hist SAME")
	legend.AddEntry(lfv_histo_vis,"Visible Mass","l")
	legend.AddEntry(lfv_histo_col,"Collinear Mass","l")
	legend.Draw()
	fwhm.AddEntry(lfv_histo_vis,"FWHM of Visible Mass:"+fwhm1,"l")
        fwhm.AddEntry(lfv_histo_col,"FWHM of Collinear Mass:"+fwhm2,"l")
        fwhm.Draw()
	canvas.SaveAs(filepath+'mass_fromHiggs.png')
