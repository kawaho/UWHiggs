from ROOT import TFile, TH1
import itertools
import os


def make2side(sysname, numberofcats):
  for key, value in sysname.items():
   for i in range(numberofcats):
     if value[i]['Up'] > 1 and value[i]['Down'] > 1:
       if value[i]['Down'] > value[i]['Up']:
         sysname[key][i]['Up'] = round(1./value[i]['Down'], 3)
       else:
         sysname[key][i]['Down'] = round(1./value[i]['Up'], 3)
     elif value[i]['Up'] < 1 and value[i]['Down'] < 1:
       if value[i]['Down'] > value[i]['Up']:
         sysname[key][i]['Down'] = round(1./value[i]['Up'], 3)
       else:
         sysname[key][i]['Up'] = round(1./value[i]['Down'], 3)

#def printmigration(sysname):
#  for key, value in sysname.items():
#    print key, ':'
#    print 'ggcat0: ', value[0]
#    print 'ggcat1: ', value[1]
#    print 'ggcat2: ', value[2]
#    print 'ggcat3: ', value[3]
#    print 'vbf: ', value[4]

def calmigration(filename, bins, cats):
  sys = ['', 'bTagUp2016', 'bTagDown2016', 'bTagUp2017', 'bTagDown2017', 'bTagUp2018', 'bTagDown2018', 'puUp2016', 'puDown2016', 'puUp2017', 'puDown2017', 'puUp2018', 'puDown2018', 'pfUp2016', 'pfDown2016',  'pfUp2017', 'pfDown2017', 'eesUp', 'eesDown', 'eerUp', 'eerDown', 'meUp', 'meDown', 'JetAbsoluteUp', 'JetAbsoluteDown', 'JetBBEC1Up', 'JetBBEC1Down', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetEC2Up', 'JetEC2Down', 'JetHFUp', 'JetHFDown', 'JetRelativeBalUp', 'JetRelativeBalDown']
  jues_yr = ['JetAbsoluteyearUp', 'JetAbsoluteyearDown', 'JetBBEC1yearUp', 'JetBBEC1yearDown', 'JetEC2yearUp', 'JetEC2yearDown', 'JetHFyearUp', 'JetHFyearDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown', 'JERUp', 'JERDown', 'UnclusteredEnUp', 'UnclusteredEnDown', 'UesCHARGEDUp', 'UesCHARGEDDown', 'UesECALUp', 'UesECALDown', 'UesHCALUp', 'UesHCALDown', 'UesHFUp', 'UesHFDown']
  file_ = [TFile('2016/'+filename), TFile('2017/'+filename), TFile('2018/'+filename)]
  numberofcats = len(cats)
  sysname = {}
  for s in sys:
   sysname[s.replace('Up', '').replace('Down', '')] = numberofcats*[{'Up':-1, 'Down':-1}]
  for u in jues_yr:
   sysname[u.replace('Up', '').replace('Down', '')+'2016'] = numberofcats*[{'Up':-1, 'Down':-1}]
   sysname[u.replace('Up', '').replace('Down', '')+'2017'] = numberofcats*[{'Up':-1, 'Down':-1}]
   sysname[u.replace('Up', '').replace('Down', '')+'2018'] = numberofcats*[{'Up':-1, 'Down':-1}]

  for s in sys:
    if s == '': continue  
    for cat in cats:
      catnum = cats.index(cat) 
      nevents_nom = 0
      nevents = 0
      for yr in range(3):
        hnom = file_[yr].Get('TightOSgg/MVA')
        hs = file_[yr].Get('TightOSgg/'+s+'/MVA')
        binl, binh = bins[catnum][yr][0], bins[catnum][yr][1] 
        nevents_nom += hnom.Integral(binl,binh)
        nevents += hs.Integral(binl,binh)
      if 'Up' in s:
        sysname[s.replace('Up', '')][catnum]['Up'] = round(nevents/nevents_nom, 3)
      elif 'Down' in s:
        sysname[s.replace('Down', '')][catnum]['Down'] = round(nevents/nevents_nom, 3)

  for s in jues_yr:
    for yrs in ['2016','2017','2018']:
      s2=s+yrs
      for cat in cats:
        catnum = cats.index(cat) 
        nevents_nom = 0
        nevents = 0
        for yr in range(3):
          hnom = file_[yr].Get('TightOSgg/MVA')
          hs = file_[yr].Get('TightOSgg/'+s2+'/MVA')
          binl, binh = bins[catnum][yr][0], bins[catnum][yr][1] 
          nevents_nom += hnom.Integral(binl,binh)
          nevents += hs.Integral(binl,binh)
        if 'Up' in s2:
          sysname[s2.replace('Up', '')][catnum]['Up'] = round(nevents/nevents_nom, 3)
        elif 'Down' in s2:
          sysname[s2.replace('Down', '')][catnum]['Down'] = round(nevents/nevents_nom, 3)

  make2side(sysname, len(cats)) 
  return sysname
