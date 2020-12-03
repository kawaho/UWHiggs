from ROOT import TFile, TH1
import Kinematics 
import itertools
import os

def make2side(sysname):
  for key, value in sysname.items():
   for i in range(4):
     if (value[i]['Up'] > 1 and value[i]['Down'] > 1) or (value[i]['Up'] < 1 and value[i]['Down'] < 1):
#       print "One-sided: ", key
       if value[i]['Down'] > value[i]['Up']:
         sysname[key][i]['Up'] = round(1./value[i]['Down'], 3)
       else:
         sysname[key][i]['Down'] = round(1./value[i]['Up'], 3)

def printmigration(sysname):
  for key, value in sysname.items():
    print key, ':'
    print 'ggcat0: ', value[0]
    print 'ggcat1: ', value[1]
    print 'ggcat2: ', value[2]
    print 'ggcat3: ', value[3]
    print 'vbf: ', value[4]

def calmigration(filename):
  file_ = TFile(filename)
  sysname = {}
  for s in Kinematics.sys:
   sysname[s.replace('Up', '').replace('Down', '')] = 9*[{'Up':-1, 'Down':-1}]
  for j in Kinematics.jes:
    if 'year' in j or 'RelativeSample' in j or 'JER' in j:  
      sysname[j.replace('Up', '').replace('Down', '')+'2016'] = 9*[{'Up':-1, 'Down':-1}]
      sysname[j.replace('Up', '').replace('Down', '')+'2017'] = 9*[{'Up':-1, 'Down':-1}]
      sysname[j.replace('Up', '').replace('Down', '')+'2018'] = 9*[{'Up':-1, 'Down':-1}]
    else: 
      sysname[j.replace('Up', '').replace('Down', '')] = 9*[{'Up':-1, 'Down':-1}]
  for u in Kinematics.ues:
   sysname[u.replace('Up', '').replace('Down', '')+'2016'] = 9*[{'Up':-1, 'Down':-1}]
   sysname[u.replace('Up', '').replace('Down', '')+'2017'] = 9*[{'Up':-1, 'Down':-1}]
   sysname[u.replace('Up', '').replace('Down', '')+'2018'] = 9*[{'Up':-1, 'Down':-1}]
  
  for f in file_.GetListOfKeys():
    f = f.ReadObj()
    cat = f.GetName()
    if cat == 'TightOS' or cat == 'TightOSgg':
      continue
    if cat == 'TightOSggcat0':
      catnum  = 0
    elif cat == 'TightOSggcat1':
      catnum  = 1
    elif cat == 'TightOSggcat1_B':
      catnum  = 2
    elif cat == 'TightOSggcat2_EC':
      catnum  = 3
    elif cat == 'TightOSggcat2':
      catnum  = 4
    elif cat == 'TightOSggcat2_B':
      catnum  = 5
    elif cat == 'TightOSggcat2_EC':
      catnum  = 6
    elif cat == 'TightOSggcat3':
      catnum  = 7
    elif cat == 'TightOSvbf':
      catnum  = 8
    hnom = f.GetKey('e_m_Mass').ReadObj()
    nevents_nom = hnom.Integral()
    for sys in f.GetListOfKeys():
      if sys.GetName() != 'e_m_Mass':
        hs = sys.ReadObj().Get("e_m_Mass")
        nevents = hs.Integral()
        if sys.GetName() == 'bTagUp' or sys.GetName() == 'bTagDown':
          continue
        if 'Up' in sys.GetName():
          sysname[sys.GetName().replace('Up', '').replace('Down', '')][catnum]['Up'] = round(nevents/nevents_nom, 3)
        elif 'Down' in sys.GetName():
          sysname[sys.GetName().replace('Up', '').replace('Down', '')][catnum]['Down'] = round(nevents/nevents_nom, 3)
  make2side(sysname) 
#  printmigration(sysname)
  return sysname
