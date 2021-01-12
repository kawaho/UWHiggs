import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView
import argparse
import os
import ROOT
import glob
import array
import Lists

jobid = os.environ['jobid']

parser = argparse.ArgumentParser(
    "Create pre/post-fit plots for LFV H analysis")
parser.add_argument(
    "--i",
    action="store",
    dest="Var",
    default="emPt",
    help="Which variable")
parser.add_argument(
    "--f",
    action="store",
    dest="Folder",
    default="",
    help="Which folder")
args = parser.parse_args()

for x in Lists.mc_samples:
    Lists.files.extend(glob.glob('../results/%s/AnalyzeEMValid2/%s.root' % (jobid, x)))
    Lists.lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'InputPlots/'
plotter = Plotter(Lists.files, Lists.lumifiles, outputdir)

var = args.Var
fol = args.Folder

#binning = array.array('f', range(-0.4, 0.25, 7))

f = ROOT.TFile( outputdir+var+'.root', 'RECREATE')

v = [
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('DY'), Lists.mc_samples )]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WJ') or x.startswith('W1') or x.startswith('W2') or x.startswith('W3') or x.startswith('W4'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('EWK'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToTauTau'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToTauTau'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToWW'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToWW'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW') or x.startswith('WG') or x.startswith('Wm') or x.startswith('Wp') or x.startswith('ZH'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGlu_LFV'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBF_LFV'), Lists.mc_samples)])
]

# Observed
DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
data = Lists.positivize(DataTotal.Get('TightOSgg/'+var))
#data = data.Rebin(len(binning)-1, 'data_obs', binning)
if var == 'emEta':
  data = data.Rebin(5)
elif var == 'e_m_PZeta' or var == 'Mjj' or var == 'MetEt' or var == 'j2Pt' or var == 'j1Pt' or var == 'emPt':
  data = data.Rebin(10)
elif var == 'emPt':
  data = data.Rebin(10)
elif var == 'bdtDiscriminator':
  data = data.Rebin(10)
data.SetName('data_obs')
data.Write()

# QCD
data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), Lists.mc_samples)])
QCDData = views.SubdirectoryView(data_view, 'TightSSgg')
QCDMC = views.SubdirectoryView(mc_view, 'TightSSgg')
QCD = SubtractionView(QCDData, QCDMC, restrict_positive=True)
qcd = Lists.positivize(QCD.Get(var))
#qcd = qcd.Rebin(len(binning)-1, 'QCD', binning)
if var == 'emEta':
  qcd = qcd.Rebin(5)
elif var == 'e_m_PZeta' or var == 'Mjj' or var == 'MetEt' or var == 'j2Pt' or var == 'j1Pt' or var == 'emPt':
  qcd = qcd.Rebin(10)
elif var == 'emPt':
  qcd = qcd.Rebin(10)
elif var == 'bdtDiscriminator':
  qcd = qcd.Rebin(10)
qcd.SetName('QCD')
qcd.Write()

for i, sam in enumerate(Lists.samp):
    print sam
    DY = v[i]
    dy = Lists.positivize(DY.Get('TightOSgg/'+var))
    if var == 'emEta':
      dy = dy.Rebin(5)
    elif var == 'e_m_PZeta' or var == 'Mjj' or var == 'MetEt' or var == 'j2Pt' or var == 'j1Pt' or var == 'emPt':
      dy = dy.Rebin(10)
    elif var == 'emPt':
      dy = dy.Rebin(10)
    elif var == 'bdtDiscriminator':
      dy = dy.Rebin(10)
#    dy = dy.Rebin(len(binning)-1, sam, binning)
    dy.SetName(sam)
    dy.Write()
