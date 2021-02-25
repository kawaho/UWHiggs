from calmigration import calmigration
import theory
import collections
import ROOT
import re

procs = ['GGLFV', 'VBFLFV', 'bkg', 'data_obs']
datacard = []
ws = []
CMSnames = {
'JetAbsolute': 'CMS_scale_j_Absolute',
'JetAbsoluteyear2016': 'CMS_scale_j_Absolute_2016',
'JetAbsoluteyear2017': 'CMS_scale_j_Absolute_2017',
'JetAbsoluteyear2018': 'CMS_scale_j_Absolute_2018',
'JetBBEC1': 'CMS_scale_j_BBEC1',
'JetBBEC1year2016': 'CMS_scale_j_BBEC1_2016',
'JetBBEC1year2017': 'CMS_scale_j_BBEC1_2017',
'JetBBEC1year2018': 'CMS_scale_j_BBEC1_2018',
'JetEC2': 'CMS_scale_j_EC2',
'JetEC2year2016': 'CMS_scale_j_EC2_2016', 
'JetEC2year2017': 'CMS_scale_j_EC2_2017', 
'JetEC2year2018': 'CMS_scale_j_EC2_2018',
'JetFlavorQCD': 'CMS_scale_j_FlavorQCD',
'JetHF': 'CMS_scale_j_HF',
'JetHFyear2016': 'CMS_scale_j_HF_2016',
'JetHFyear2017': 'CMS_scale_j_HF_2017',
'JetHFyear2018': 'CMS_scale_j_HF_2018',
'JetRelativeBal': 'CMS_scale_j_RelativeBal',
'JetRelativeSample2016': 'CMS_scale_j_RelativeSample_2016',
'JetRelativeSample2017': 'CMS_scale_j_RelativeSample_2017',
'JetRelativeSample2018': 'CMS_scale_j_RelativeSample_2018',
'JER2016': 'CMS_res_j_2016',
'JER2017': 'CMS_res_j_2017',
'JER2018': 'CMS_res_j_2018',
'eer': 'CMS_res_e',
'ees': 'CMS_scale_e',
'me': 'CMS_scale_m',
'pu2016': 'CMS_pileup_2016',
'pu2017': 'CMS_pileup_2017',
'pu2018': 'CMS_pileup_2018',
'pf2016': 'CMS_prefiring_2016',
'pf2017': 'CMS_prefiring_2017',
'bTag2016': 'CMS_eff_btag_2016',
'bTag2017': 'CMS_eff_btag_2017',
'bTag2018': 'CMS_eff_btag_2018',
'UnclusteredEn2016': 'CMS_scale_met_2016',
'UnclusteredEn2017': 'CMS_scale_met_2017',
'UnclusteredEn2018': 'CMS_scale_met_2018',
}
  
def addSyst(l,v):
  if len(v) == 2:
    vstr = "%.3f/%.3f"%(v[0],v[1])
    l += "%-25s "%vstr
  else:
    l += "%-25s "%"-"
  return l

def calyratio(bins):
  f2016_gg = ROOT.TFile('2016/GG.root')
  f2017_gg = ROOT.TFile('2017/GG.root')
  f2018_gg = ROOT.TFile('2018/GG.root')
  f2016_vbf = ROOT.TFile('2016/VBF.root')
  f2017_vbf = ROOT.TFile('2017/VBF.root')
  f2018_vbf = ROOT.TFile('2018/VBF.root')
  h2016gg = f2016_gg.Get('TightOSgg/MVA').Integral(bins[0][0],bins[0][1])
  h2017gg = f2017_gg.Get('TightOSgg/MVA').Integral(bins[1][0],bins[1][1])
  h2018gg = f2018_gg.Get('TightOSgg/MVA').Integral(bins[2][0],bins[2][1])
  hgg = h2016gg+h2017gg+h2018gg
  h2016vbf = f2016_vbf.Get('TightOSgg/MVA').Integral(bins[0][0],bins[0][1])
  h2017vbf = f2017_vbf.Get('TightOSgg/MVA').Integral(bins[1][0],bins[1][1])
  h2018vbf = f2018_vbf.Get('TightOSgg/MVA').Integral(bins[2][0],bins[2][1])
  hvbf = h2016vbf+h2017vbf+h2018vbf
  return [[h2016gg/hgg, h2016vbf/hvbf, '-'], [h2017gg/hgg, h2017vbf/hvbf, '-'], [h2018gg/hgg, h2018vbf/hvbf, '-']]


#cats = [ggcat0,ggcat1]
#bins = [[[],[],[]], [[],[],[]]]
def writedatacard(cats, bins):
  QCDscale_ggH = theory.QCD_scale('GG.root', cats, bins) 
  QCDscale_qqH = theory.QCD_scale('VBF.root', cats, bins)
  print "Finished QCDscale" 
  acceptance_scale_gg = theory.acceptance_scale('GG.root', cats, bins)
  acceptance_scale_vbf = theory.acceptance_scale('VBF.root', cats, bins)
  print "Finished scale acceptance" 
  
  acceptance_pdf_gg = theory.acceptance_pdf('GG.root', cats, bins)
  acceptance_pdf_vbf = theory.acceptance_pdf('VBF.root', cats, bins)
  print "Finished pdf acceptance" 

  for cat in cats:
    catnum = cats.index(cat)
    f = open('datacard_'+cat+'.txt','w')
    f.write("imax *\n")
    f.write("jmax *\n")
    f.write("kmax *\n")
    f.write("---------------------------------------------\n")
    ws = 'workspace_sig_'+cat+'.root'
    for proc in procs:
      if proc == 'bkg':
        f.write("shapes      %-10s %-10s %-20s %s\n"%(proc,cat,ws,'multipdf:env_pdf_'+cat+'_exp1'))
      elif proc == 'data_obs':
        f.write("shapes      %-10s %-10s %-20s %s\n"%(proc,cat,ws,'multipdf:roohist_data_mass_'+cat))
      else:
        if proc == 'GGLFV':
          proc2 = 'ggH'  
        if proc == 'VBFLFV':
          proc2 = 'qqH'
        f.write("shapes      %-10s %-10s %-20s %s\n"%(proc,cat,ws,'w_13TeV:'+cat+'_'+proc2+'_pdf'))
  
    lbreak = '---------------------------------------------'
    lbin_cat = '%-25s'%"bin"
    lobs_cat = '%-25s'%"observation"
    lbin_procXcat = '%-61s'%"bin"
    lproc = '%-61s'%"process"
    lprocid = '%-61s'%"process"
    lrate = '%-61s'%"rate"        
    lbin_cat += "%-30s "%cat
    lobs_cat += "%-30s "%"-1"
    sigID = 0
    for proc in procs:
      if proc == 'data_obs': continue  
      lbin_procXcat += "%-25s "%cat
      lproc += "%-25s "%proc
      if proc == "bkg": 
        lprocid += "%-25s "%"1"
        lrate += "%-25s "%"1"
      else:
        lprocid += "%-25s "%sigID
        sigID -= 1
        lrate += "%-25s "%"1"
    f.write("\n")
    for l in [lbreak,lbin_cat,lobs_cat,lbreak,lbin_procXcat,lproc,lprocid,lrate,lbreak]: 
      l = l[:-1]
      f.write("%s\n"%l)
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('CMS_Trigger_emu_13TeV','lnN','1.02','1.02','-'))
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('CMS_eff_e','lnN','1.02','1.02','-'))
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('CMS_eff_m','lnN','1.02','1.02','-'))
    yrratio = calyratio(bins[catnum])
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('CMS_lumi_2016_13TeV','lnN', str(round(1+.025*yrratio[0][0],4)), str(round(1+.025*yrratio[0][1],3)),'-'))
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('CMS_lumi_2017_13TeV','lnN', str(round(1+.023*yrratio[1][0],4)), str(round(1+.023*yrratio[1][1],3)),'-'))
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('CMS_lumi_2018_13TeV','lnN', str(round(1+.025*yrratio[2][0],4)), str(round(1+.025*yrratio[2][1],3)),'-'))
    
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('QCDscale_ggH','lnN', str(round(1+QCDscale_ggH[cat],4)),'-','-'))
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('QCDscale_qqH','lnN','-',str(round(1+QCDscale_qqH[cat],4)),'-'))
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('acceptance_pdf_gg','lnN',str(round(1+acceptance_pdf_gg[cat],4)),'-','-'))
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('acceptance_pdf_vbf','lnN','-',str(round(1+acceptance_pdf_vbf[cat],4)),'-'))
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('acceptance_scale_gg','lnN',str(round(1+acceptance_scale_gg[cat],4)),'-','-'))
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('acceptance_scale_vbf','lnN','-',str(round(1+acceptance_scale_vbf[cat],4)),'-'))
    
    sys = {'GGLFV':{}, 'VBLFV':{}}
    sys['GGLFV'] = collections.OrderedDict(sorted(calmigration('GG.root', bins, cats).items()))
    sys['VBLFV'] = calmigration('VBF.root', bins, cats)
    for key, value in sys['GGLFV'].items():
      if key == '' or 'Ues' in key: continue
      lsyst = '%-35s  %-20s    '%(CMSnames[key],'lnN')
      sval = addSyst(lsyst, [value[catnum]['Down'],value[catnum]['Up']])
      sval = addSyst(sval, [sys['VBLFV'][key][catnum]['Down'], sys['VBLFV'][key][catnum]['Up']])
      sval = addSyst(sval, [])
      f.write("%s\n"%sval)
  
    import csv
    shapeSys = {}
    with open('Hem_shape_sys.csv', mode='r') as csv_file:
      csv_reader = csv.DictReader(csv_file)
      line_count = 0
      for row in csv_reader:
        shapeSys[row['Proc']+'_'+row['Cat']+'_'+row['Param']+'_'+row['Sys']] = row['Value'] 
  
    f.write("---------------------------------------------\n")
    for proc in procs:
      if proc == 'bkg' or proc == 'data_obs': continue      
      else:
        if proc == 'GGLFV':
          proccatMER = 'ggH_'+cat+'_sigma_me'
          proccatMES = 'ggH_'+cat+'_dm_me'
          proccatEER = 'ggH_'+cat+'_sigma_eer'
          proccatEES = 'ggH_'+cat+'_dm_ees'
          proc2 = 'ggH'
        if proc == 'VBFLFV':
          proccatMER = 'qqH_'+cat+'_sigma_me'
          proccatMES = 'qqH_'+cat+'_dm_me'
          proccatEER = 'qqH_'+cat+'_sigma_eer'
          proccatEES = 'qqH_'+cat+'_dm_ees'
          proc2 = 'qqH'
      f.write('CMS_hem_nuisance_scale_e_%s    param  0  %.4f\n'%(proc2, max(abs(float(shapeSys[proccatEES+'Up'])), abs(float(shapeSys[proccatEES+'Down'])))))
      f.write('CMS_hem_nuisance_scale_m_%s    param  0  %.4f\n'%(proc2, max(abs(float(shapeSys[proccatMES+'Up'])), abs(float(shapeSys[proccatMES+'Down'])))))
      f.write('CMS_hem_nuisance_res_e_%s      param  0  %.4f\n'%(proc2, max(abs(float(shapeSys[proccatEER+'Up'])), abs(float(shapeSys[proccatEER+'Down'])))))
      f.write('CMS_hem_nuisance_res_m_%s      param  0  %.4f\n'%(proc2, max(abs(float(shapeSys[proccatMER+'Up'])), abs(float(shapeSys[proccatMER+'Down'])))))
