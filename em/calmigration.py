from ROOT import TFile, TH1
import Kinematics 
import itertools
import os

def make2side(sysname):
  for key, value in sysname.items():
   for i in range(9):
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
    if cat == 'TightOSggcat0':
      catnum  = 0
    elif cat == 'TightOSggcat1':
      catnum  = 1
    elif cat == 'TightOSggcat2':
      catnum  = 2
    elif cat == 'TightOSggcat3':
      catnum  = 3
    elif cat == 'TightOSggcat4':
      catnum  = 4
    elif cat == 'TightOSvbfcat0':
      catnum  = 5
    elif cat == 'TightOSvbfcat1':
      catnum  = 6
#    elif cat == 'TightOSggcat2':
#      catnum  = 4
#    elif cat == 'TightOSggcat3':
#      catnum  = 5
#    elif cat == 'TightOSggcat4':
#      catnum  = 6
#    elif cat == 'TightOSggcat5':
#      catnum  = 7
#    elif cat == 'TightOSggcat6':
#      catnum  = 8
#    if cat == 'TightOSvbfcat0':
#      catnum  = 0
#    elif cat == 'TightOSvbfcat1':
#      catnum  = 1
#    elif cat == 'TightOSvbfcat2':
#      catnum  = 2
#    elif cat == 'TightOSvbfcat3':
#      catnum  = 3
#    elif cat == 'TightOSvbfcat4':
#      catnum  = 4
#    elif cat == 'TightOSvbfcat5':
#      catnum  = 5
#    elif cat == 'TightOSvbfcat6':
#      catnum  = 6
#    elif cat == 'TightOSvbfcat7':
#      catnum  = 7
#    elif cat == 'TightOSvbfcat8':
#      catnum  = 8
#    elif cat == 'TightOSvbfcat9':
#      catnum  = 9
#    elif cat == 'TightOSvbfcat10':
#      catnum  = 10
#    elif cat == 'TightOSvbfcat11':
#      catnum  = 11
#    elif cat == 'TightOSvbfcat12':
#      catnum  = 12
#    elif cat == 'TightOSvbfcat13':
#      catnum  = 13
#    elif cat == 'TightOSvbfcat14':
#      catnum  = 14
#    elif cat == 'TightOSvbfcat15':
#      catnum  = 15
#    elif cat == 'TightOSvbf':
#      catnum  = 16
    else:
      continue
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
