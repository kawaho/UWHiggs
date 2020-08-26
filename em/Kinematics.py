from math import sqrt, pi, exp, cos
import xml.etree.ElementTree as ET
import os

def invert_case(letter):
  if letter.upper() == letter:
    return letter.lower()
  else:
    return letter.upper()

def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
    return PHI
  else:
    return 2*pi-PHI

def deltaEta(eta1, eta2):
  return abs(eta1 - eta2)

def Zeppenfeld(lEta1, lEta2, jEta1, jEta2):
  return abs((lEta1 + lEta2) - (jEta1 + jEta2)/2)

def deltaR(phi1, phi2, eta1, eta2):
  deta = eta1 - eta2
  dphi = abs(phi1-phi2)
  if (dphi>pi) : dphi = 2*pi-dphi
  return sqrt(deta*deta + dphi*dphi)

def visibleMass(v1, v2):
  return (v1+v2).M()

def collMass(myLep1, myMET, myLep2):
  ptnu = abs(myMET.Et()*cos(deltaPhi(myMET.Phi(), myLep2.Phi())))
  visfrac = myLep2.Pt()/(myLep2.Pt() + ptnu)
  l1_l2_Mass = visibleMass(myLep1, myLep2)
  return (l1_l2_Mass/sqrt(visfrac))

def transverseMass(vobj, vmet):
  totalEt = vobj.Et() + vmet.Et()
  totalPt = (vobj + vmet).Pt()
  mt2 = totalEt*totalEt - totalPt*totalPt;
  return sqrt(abs(mt2))

def topPtreweight(pt1, pt2):
  if pt1 > 400 : pt1 = 400
  if pt2 > 400 : pt2 = 400
  a = 0.0615
  b = -0.0005
  wt1 = exp(a + b * pt1)
  wt2 = exp(a + b * pt2)
  wt = sqrt(wt1 * wt2)
  return wt

plotnames = ['TightOS', 'TightOSEB-MB', 'TightOSEB-ME', 'TightOSEE', 'TightOS0JetEB-MB', 'TightOS0JetEB-ME', 'TightOS0JetEE', 'TightOS1JetEB-MB', 'TightOS1JetEB-ME', 'TightOS1JetEE', 'TightOS2JetEB-MB', 'TightOS2JetEB-ME', 'TightOS2JetEE', 'TightOS2JetVBF']

#plotnames = ['TightOS', 'TightOSEB-MB', 'TightOSEB-ME', 'TightOSEE-MB', 'TightOSEE-ME', 'TightOS0Jet', 'TightOS0JetEB-MB', 'TightOS0JetEB-ME', 'TightOS0JetEE-MB', 'TightOS0JetEE-ME', 'TightOS1Jet', 'TightOS1JetEB-MB', 'TightOS1JetEB-ME', 'TightOS1JetEE-MB', 'TightOS1JetEE-ME', 'TightOS2Jet', 'TightOS2JetEB-MB', 'TightOS2JetEB-ME', 'TightOS2JetEE-MB', 'TightOS2JetEE-ME', 'TightOS2JetVBF', 'TightOS2JetVBFEB-MB', 'TightOS2JetVBFEB-ME', 'TightOS2JetVBFEE-MB', 'TightOS2JetVBFEE-ME']

def SensitivityParser():
  cutparms = {}
  for cat in range(10):
    catname = str(cat)
    cutparms[catname] = {}
    if (catname == '0'):
      cutparms[catname]['geo'] = 'EB-MB'
      cutparms[catname]['cuts'] = {}
      cutparms[catname]['cuts']['ept_min'] = 36 
      cutparms[catname]['cuts']['mpt_min'] = 30
      cutparms[catname]['cuts']['met_max'] = 62
    elif (catname == '1'):
      cutparms[catname]['geo'] = 'EB-ME'
      cutparms[catname]['cuts'] = {}
      cutparms[catname]['cuts']['ept_min'] = 25
      cutparms[catname]['cuts']['mpt_min'] = 27
      cutparms[catname]['cuts']['met_max'] = 61
    elif (catname == '2'):
      cutparms[catname]['geo'] = 'EE'
      cutparms[catname]['cuts'] = {}
      cutparms[catname]['cuts']['ept_min'] = 25
      cutparms[catname]['cuts']['mpt_min'] = 30
      cutparms[catname]['cuts']['met_max'] = 65
    elif (catname == '3'):
      cutparms[catname]['geo'] = 'EB-MB'
      cutparms[catname]['cuts'] = {}
      cutparms[catname]['cuts']['ept_min'] = 18
      cutparms[catname]['cuts']['mpt_min'] = 21
      cutparms[catname]['cuts']['met_max'] = 64
    elif (catname == '4'):
      cutparms[catname]['geo'] = 'EB-ME'
      cutparms[catname]['cuts'] = {}
      cutparms[catname]['cuts']['ept_min'] = 25
      cutparms[catname]['cuts']['mpt_min'] = 22
      cutparms[catname]['cuts']['met_max'] = 65
    elif (catname == '5'):
      cutparms[catname]['geo'] = 'EE'
      cutparms[catname]['cuts'] = {}
      cutparms[catname]['cuts']['ept_min'] = 20
      cutparms[catname]['cuts']['mpt_min'] = 24
      cutparms[catname]['cuts']['met_max'] = 64
    elif (catname == '6'):
      cutparms[catname]['geo'] = 'EB-MB'
      cutparms[catname]['cuts'] = {}
      cutparms[catname]['cuts']['ept_min'] = 20
      cutparms[catname]['cuts']['mpt_min'] = 21
      cutparms[catname]['cuts']['met_max'] = 68
    elif (catname == '7'):
      cutparms[catname]['geo'] = 'EB-ME'
      cutparms[catname]['cuts'] = {}
      cutparms[catname]['cuts']['ept_min'] = 20
      cutparms[catname]['cuts']['mpt_min'] = 18
      cutparms[catname]['cuts']['met_max'] = 68
    elif (catname == '8'):
      cutparms[catname]['geo'] = 'EE'
      cutparms[catname]['cuts'] = {}
      cutparms[catname]['cuts']['ept_min'] = 20
      cutparms[catname]['cuts']['mpt_min'] = 23
      cutparms[catname]['cuts']['met_max'] = 69
    elif (catname == '9'):
      cutparms[catname]['geo'] = None
      cutparms[catname]['cuts'] = {}
      cutparms[catname]['cuts']['ept_min'] = 21
      cutparms[catname]['cuts']['mpt_min'] = 22
      cutparms[catname]['cuts']['met_max'] = 69
  
  return cutparms
