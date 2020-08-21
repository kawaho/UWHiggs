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

plotnames = ['TightOS', 'TightOSEB-MB', 'TightOSEB-ME', 'TightOSEE-MB', 'TightOSEE-ME', 'TightOS0Jet', 'TightOS0JetEB-MB', 'TightOS0JetEB-ME', 'TightOS0JetEE-MB', 'TightOS0JetEE-ME', 'TightOS1Jet', 'TightOS1JetEB-MB', 'TightOS1JetEB-ME', 'TightOS1JetEE-MB', 'TightOS1JetEE-ME', 'TightOS2Jet', 'TightOS2JetEB-MB', 'TightOS2JetEB-ME', 'TightOS2JetEE-MB', 'TightOS2JetEE-ME', 'TightOS2JetVBF', 'TightOS2JetVBFEB-MB', 'TightOS2JetVBFEB-ME', 'TightOS2JetVBFEE-MB', 'TightOS2JetVBFEE-ME']

def SensitivityParser():
  root = ET.parse('/afs/hep.wisc.edu/user/kaho/CMSSW_10_2_16_UL/src/UWHiggs2017/em/dataset/weights/TMVA_Opt_Category_Cuts0.weights.xml').getroot()
  cutparms = {}
  for catname in root.findall('Weights/SubMethod'):
    cat = catname.attrib.get('Index')
    s_max = -1
    for bin_ in catname.findall('Weights/Bin'):
      effs = float(bin_.attrib.get('effS'))
      effb = float(bin_.attrib.get('effB'))
      if float(bin_.attrib.get('effB')) != 0:
        s = effs/sqrt(effb)
        if s > s_max:
          s_max = s
          effs_max = effs
          effb_max = effb
          for cut in bin_.findall('Cuts'):
            mPtcut = float(cut.attrib.get('cutMin_0'))
            ePtcut = float(cut.attrib.get('cutMin_1'))
            metcut = float(cut.attrib.get('cutMax_2'))
      else:
        s = 0
    cutparms[cat] = {}
    if (cat == '0' or cat == '4' or cat == '8' or cat == '12'):
      cutparms[cat]['geo'] = 'EB-MB'
    elif (cat == '1' or cat == '5' or cat == '9' or cat == '13'):
      cutparms[cat]['geo'] = 'EB-ME'
    elif (cat == '2' or cat == '6' or cat == '10' or cat == '14'):
      cutparms[cat]['geo'] = 'EE-MB'  
    elif (cat == '3' or cat == '7' or cat == '11' or cat == '15'):
      cutparms[cat]['geo'] = 'EE-ME'
    cutparms[cat]['cuts'] = {}
    cutparms[cat]['cuts']['ept_min'] = round(ePtcut)
    cutparms[cat]['cuts']['mpt_min'] = round(mPtcut)
    cutparms[cat]['cuts']['met_max'] = round(metcut)
  return cutparms
