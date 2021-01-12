from calmigration import calmigration
import theory
import collections
import ROOT
import re

import argparse
parser = argparse.ArgumentParser()
parser.add_argument('--NoSys', default=False, action='store_true', help='write datacard with no systematics')
args = parser.parse_args()
nosys = args.NoSys
pdfmap = {'ggcat0': 'bern3', 
'ggcat1': 'bern3', 
'ggcat2': 'bern3', 
'ggcat3': 'bern1',
'ggcat4': 'bern1',
'vbf': 'bern3'}

cats = ['TightOSvbf', 'TightOSvbf500a', 'TightOSvbf500b', 'TightOSvbf510a', 'TightOSvbf510b', 'TightOSvbf520a', 'TightOSvbf520b', 'TightOSvbf530a', 'TightOSvbf530b', 'TightOSvbf540a', 'TightOSvbf540b', 'TightOSvbf550a', 'TightOSvbf550b', 'TightOSvbf560a', 'TightOSvbf560b', 'TightOSvbf570a', 'TightOSvbf570b', 'TightOSvbf580a', 'TightOSvbf580b', 'TightOSvbf590a', 'TightOSvbf590b', 'TightOSvbf600a', 'TightOSvbf600b', 'TightOSvbf610a', 'TightOSvbf610b', 'TightOSvbf620a', 'TightOSvbf620b', 'TightOSvbf630a', 'TightOSvbf630b', 'TightOSvbf640a', 'TightOSvbf640b', 'TightOSvbf650a', 'TightOSvbf650b', 'TightOSvbf660a', 'TightOSvbf660b', 'TightOSvbf670a', 'TightOSvbf670b', 'TightOSvbf680a', 'TightOSvbf680b', 'TightOSvbf690a', 'TightOSvbf690b', 'TightOSvbf700a', 'TightOSvbf700b']

#cats = ['TightOSvbf00','TightOSgg00','TightOSvbf01','TightOSgg01','TightOSvbf02','TightOSgg02','TightOSvbf03','TightOSgg03','TightOSvbf04','TightOSgg04','TightOSvbf10','TightOSgg10','TightOSvbf11','TightOSgg11','TightOSvbf12','TightOSgg12','TightOSvbf13','TightOSgg13','TightOSvbf14','TightOSgg14','TightOSvbf20','TightOSgg20','TightOSvbf21','TightOSgg21','TightOSvbf22','TightOSgg22','TightOSvbf23','TightOSgg23','TightOSvbf24','TightOSgg24','TightOSvbf30','TightOSgg30','TightOSvbf31','TightOSgg31','TightOSvbf32','TightOSgg32','TightOSvbf33','TightOSgg33','TightOSvbf34','TightOSgg34']
#cats = ['ggcat0', 'ggcat1', 'ggcat2', 'ggcat3', 'vbf']

#cats = ['ggcat0', 'ggcat1', 'ggcat2', 'ggcat3', 'ggcat4','vbf']

def stupidnames(cat):
  if cat == 'ggcat1EC':
    return 'ggcat1_EC'
  elif cat == 'ggcat1B':
    return 'ggcat1_B'
  elif cat == 'ggcat2B':
    return 'ggcat2_B'
  elif cat == 'ggcat2EC':
    return 'ggcat2_EC'
  else:
    return cat 

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

#QCDscale_ggH = theory.QCD_scale("GG", cats) 
#QCDscale_qqH = theory.QCD_scale("VBF", cats)
#
#acceptance_scale_gg = theory.acceptance_scale("GG", cats)
#acceptance_scale_vbf = theory.acceptance_scale("VBF", cats)
#
#acceptance_pdf_gg = theory.acceptance_pdf("GG", cats)
#acceptance_pdf_vbf = theory.acceptance_pdf("VBF", cats)
  
def addSyst(l,v):
  if len(v) == 2:
    vstr = "%.3f/%.3f"%(v[0],v[1])
    l += "%-25s "%vstr
  else:
    l += "%-25s "%"-"
  return l

def calyratio(cat):
  f_gg = ROOT.TFile('SignalGG.root')
  f2016_gg = ROOT.TFile('results/Data2016JEC/AnalyzeEMSys/GluGlu_LFV_HToEMu_M125_13TeV_powheg_pythia8_v3-PUMoriond17_94X_mcRun2_asymptotic_v3-v2.root')
  f2017_gg = ROOT.TFile('../../UWHiggs2017/em/results/Data2017JEC/AnalyzeEMSys/GluGlu_LFV_HToEMu_M125_13TeV_powheg_pythia8_v2-PU2017_12Apr2018_94X_mc2017_realistic_v14-v1.root')
  f2018_gg = ROOT.TFile('../../UWHiggs/em/results/Data2018_em/AnalyzeEMSys/GluGlu_LFV_HToEMu_M125_TuneCP5_PSweights_13TeV_powheg_pythia8_-102X_upgrade2018_realistic_v15-v2.root')
  f_vbf = ROOT.TFile('SignalVBF.root')
  f2016_vbf = ROOT.TFile('results/Data2016JEC/AnalyzeEMSys/VBF_LFV_HToEMu_M125_13TeV_powheg_pythia8_v3-PUMoriond17_94X_mcRun2_asymptotic_v3-v2.root')
  f2017_vbf = ROOT.TFile('../../UWHiggs2017/em/results/Data2017JEC/AnalyzeEMSys/VBF_LFV_HToEMu_M125_13TeV_powheg_pythia8_v2-PU2017_12Apr2018_94X_mc2017_realistic_v14-v1.root')
  f2018_vbf = ROOT.TFile('../../UWHiggs/em/results/Data2018_em/AnalyzeEMSys/VBF_LFV_HToEMu_M125_TuneCP5_PSweights_13TeV_powheg_pythia8_-102X_upgrade2018_realistic_v15-v1.root')
  hgg = f_gg.Get('TightOS'+cat+'/e_m_Mass').Integral()
  print "Cat: ", cat, "Number of GG: ", round(hgg)
  h2016gg = f2016_gg.Get('TightOS'+cat+'/e_m_Mass').Integral()
  h2017gg = f2017_gg.Get('TightOS'+cat+'/e_m_Mass').Integral()
  h2018gg = f2018_gg.Get('TightOS'+cat+'/e_m_Mass').Integral()
  hvbf = f_vbf.Get('TightOS'+cat+'/e_m_Mass').Integral()
  print "Cat: ", cat, "Number of VBF: ", round(hvbf)
  h2016vbf = f2016_vbf.Get('TightOS'+cat+'/e_m_Mass').Integral()
  h2017vbf = f2017_vbf.Get('TightOS'+cat+'/e_m_Mass').Integral()
  h2018vbf = f2018_vbf.Get('TightOS'+cat+'/e_m_Mass').Integral()
  return [[h2016gg/hgg, h2016vbf/hvbf, '-'], [h2017gg/hgg, h2017vbf/hvbf, '-'], [h2018gg/hgg, h2018vbf/hvbf, '-']]

for cat in cats:
  catnum = cats.index(cat)
  if nosys:
    f = open('datacard_'+cat+'_NoSys.txt','w')
  else:
    f = open('datacard_'+cat+'.txt','w')
  f.write("imax *\n")
  f.write("jmax *\n")
  f.write("kmax *\n")
  f.write("---------------------------------------------\n")
  ws = 'workspace_sig_'+cat+'.root'
#  CMS_Hemu_13TeV_multipdf.root
  for proc in procs:
    if proc == 'bkg' or proc == 'data_obs':
      ws = 'CMS_Hemu_13TeV_multipdf.root'
      if proc == 'bkg':
        if nosys:
          f.write("shapes      %-10s %-10s %-20s %s\n"%(proc,cat,ws,'multipdf:env_pdf_'+cat+'_'+'bern3'))
          #f.write("shapes      %-10s %-10s %-20s %s\n"%(proc,cat,ws,'multipdf:CMS_hemu_'+cat+'_13TeV_bkgshape'))
        else:
          f.write("shapes      %-10s %-10s %-20s %s\n"%(proc,cat,ws,'multipdf:env_pdf_'+cat+'_'+pdfmap[cat]))
          #f.write("shapes      %-10s %-10s %-20s %s\n"%(proc,cat,ws,'multipdf:env_pdf_'+cat+'_'+'bern3'))
      else:
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
  if not nosys: 
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('CMS_Trigger_emu_13TeV','lnN','1.02','1.02','-'))
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('CMS_eff_e','lnN','1.02','1.02','-'))
    f.write('%-35s  %-20s    %-25s %-25s %-25s\n'%('CMS_eff_m','lnN','1.02','1.02','-'))
    yrratio = calyratio(stupidnames(cat))
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
    sys['GGLFV'] = collections.OrderedDict(sorted(calmigration('SignalGG.root').items()))
    sys['VBLFV'] = calmigration('SignalVBF.root')
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
 #   ees_gg = {'ggcat0':0.0003, 'ggcat1':0.0003, 'ggcat2':0.0003, 'ggcat3':0.0003, 'vbf':0.0004}
 #   ees_vbf = {'ggcat0':0.0003, 'ggcat1':0.0003, 'ggcat2':0.0003, 'ggcat3':0.0003, 'vbf':0.0004}

 #   eer_gg = {'ggcat0':0.0018, 'ggcat1':0.0018, 'ggcat2':0.0021, 'ggcat3':0.0019, 'vbf':0.002}
 #   eer_vbf = {'ggcat0':0.0025, 'ggcat1':0.0021, 'ggcat2':0.002, 'ggcat3':0.0021, 'vbf':0.002}

 #   mes_gg = {'ggcat0':0.0003, 'ggcat1':0.0003, 'ggcat2':0.0003, 'ggcat3':0.0003, 'vbf':0.0003}
 #   mes_vbf = {'ggcat0':0.0003, 'ggcat1':0.0003, 'ggcat2':0.0003, 'ggcat3':0.0003, 'vbf':0.0003}

 #   mer_gg = {'ggcat0':0.002, 'ggcat1':0.0013, 'ggcat2':0.0020, 'ggcat3':0.0015, 'vbf':0.0014}
 #   mer_vbf = {'ggcat0':0.0014, 'ggcat1':0.0024, 'ggcat2':0.0012, 'ggcat3':0.0027, 'vbf':0.0015}

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
      f.write('CMS_hem_nuisance_res_e_%s      param  0  %.4f\n'%(proc2, max(abs(float(shapeSys[proccatEER+'Up'])), abs(float(shapeSys[proccatEER+'Down']))))) #eer[cat]
      f.write('CMS_hem_nuisance_res_m_%s      param  0  %.4f\n'%(proc2, max(abs(float(shapeSys[proccatMER+'Up'])), abs(float(shapeSys[proccatMER+'Down'])))))
  else:
    f.write('pdfindex_' +cat+'_13TeV    discrete\n')
