import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView, PositiveView
from FinalStateAnalysis.MetaData.data_styles import data_styles
import os
import ROOT
import glob
import logging
import sys
import Lists
logging.basicConfig(stream=sys.stderr, level=logging.ERROR)

ROOT.gROOT.SetStyle('Plain')
ROOT.gROOT.SetBatch()
ROOT.gStyle.SetOptStat(0)

jobid = os.environ['jobid']
print jobid

for x in Lists.mc_samples:
    print x
    Lists.files.extend(glob.glob('../results/%s/AnalyzeETauDeep/%s' % (jobid, x)))
    Lists.lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

for j in Lists.jet:
    s1 = 'TightOS'+j
    s2 = 'TauLooseOS'+j
    s3 = 'EleLooseOS'+j
    s4 = 'EleLooseTauLooseOS'+j
    #s1 = 'TightSS'+j
    #s2 = 'TauLooseSS'+j
    #s3 = 'EleLooseSS'+j
    #s4 = 'EleLooseTauLooseSS'+j
    #s1 = 'TightWOS'+j
    #s2 = 'TauLooseWOS'+j
    #s3 = 'EleLooseWOS'+j
    #s4 = 'EleLooseTauLooseWOS'+j

    outputdir = 'plots/%s/AnalyzeETau/2016SelectionsEmbedDeepFake/%s/' % (jobid, s1)
    if not os.path.exists(outputdir):
        os.makedirs(outputdir)

    plotter = Plotter(Lists.files, Lists.lumifiles, outputdir)

    DYtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY'), Lists.mc_samples)])
    DYall = views.SubdirectoryView(DYtotal, s1)
    DY = views.StyleView(DYall, **Lists.remove_name_entry(data_styles['DY*']))
    DY = views.TitleView(DY, 'Z#rightarrow#mu#mu/ee')

    embedtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('Embed') , Lists.mc_samples)])
    embedall = views.SubdirectoryView(embedtotal, s1)
    embed = views.StyleView(embedall, **Lists.remove_name_entry(data_styles['DYTT*']))
    embed = views.TitleView(embed, 'Z#rightarrow#tau#tau')

    EWKtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('EWK') , Lists.mc_samples)])
    EWKall = views.SubdirectoryView(EWKtotal, s1)
    EWK = views.StyleView(EWKall, **Lists.remove_name_entry(data_styles['W*Jets*']))
    EWK = views.TitleView(EWK, 'EWKW/Z')

    SMHtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x or 'HToWW' in x , Lists.mc_samples)])
    SMHall = views.SubdirectoryView(SMHtotal, s1)
    SMH = views.StyleView(SMHall, **Lists.remove_name_entry(data_styles['*HToTauTau*']))
    SMH = views.TitleView(SMH, 'SM Higgs')

    TTtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT') or x.startswith('ST'), Lists.mc_samples)])
    TTall = views.SubdirectoryView(TTtotal, s1)
    TT = views.StyleView(TTall, **Lists.remove_name_entry(data_styles['TT*']))
    TT = views.TitleView(TT, 't#bar{t},t+jets')

    Dibosontotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), Lists.mc_samples)])
    Dibosonall = views.SubdirectoryView(Dibosontotal, s1)
    Diboson = views.StyleView(Dibosonall, **Lists.remove_name_entry(data_styles['WZ*']))
    Diboson = views.TitleView(Diboson, 'Diboson')

    data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
    fakesTau = views.SubdirectoryView(data_view, s2)
    fakesEle = views.SubdirectoryView(data_view, s3)
    fakesTauEle = views.SubdirectoryView(data_view, s4)
    fakesET = views.SumView(fakesTau, fakesEle)
    fakesData = SubtractionView(fakesET, fakesTauEle, restrict_positive=True)
    mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), Lists.mc_samples)])
    fakesMCTau = views.SubdirectoryView(mc_view, s2)
    fakesMCEle = views.SubdirectoryView(mc_view, s3)
    fakesMCTauEle = views.SubdirectoryView(mc_view, s4)
    fakesMCET = views.SumView(fakesMCTau, fakesMCEle)
    fakesMC = SubtractionView(fakesMCET, fakesMCTauEle, restrict_positive=True)
    QCD = views.StyleView(SubtractionView(fakesData, fakesMC, restrict_positive=True), **Lists.remove_name_entry(data_styles['QCD*']))
    QCD = views.TitleView(QCD, 'W/QCD')

    vbfHET = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToETau' in x , Lists.mc_samples)]), **Lists.remove_name_entry(data_styles['VBF_LFV*']))
    ggHET = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToETau' in x , Lists.mc_samples)]), **Lists.remove_name_entry(data_styles['GluGlu_LFV*']))

    plotter.views['vbfHET']={'view' : vbfHET }
    plotter.views['ggHET']={'view' : ggHET }
    plotter.views['DY']={'view' : DY }
    plotter.views['embed']={'view' : embed }
    plotter.views['EWK']={'view' : EWK }
    plotter.views['SMH']={'view' : SMH }
    plotter.views['TT']={'view' : TT }
    plotter.views['QCD']={'view' : QCD }
    plotter.views['Diboson']={'view' : Diboson }

    plotter.mc_samples = ['QCD', 'Diboson', 'TT', 'EWK', 'DY', 'embed', 'SMH']

    foldername = ['']

    for fn in foldername:
        if not os.path.exists(outputdir+'/'+fn):
            os.makedirs(outputdir+'/'+fn)
        for n,h in enumerate(Lists.histoname):
            #plotter.pad.SetLogy(True)
            plotter.plot_mc_vs_data(fn, ['VBF_LFV_HToETau_M125*', 'GluGlu_LFV_HToETau_M125*'], h[0], 1, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.5, sort=True, blind_region=True, control=s1, jets=j, year='2016', channel='etauh')
            plotter.save(h[0])
