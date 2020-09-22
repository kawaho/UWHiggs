from math import sqrt, pi, exp, cos
import xml.etree.ElementTree as ET
import os
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA

var_d_star_gg = ['mPt_Per_e_m_Mass','ePt_Per_e_m_Mass','emPt','emEta','j1Pt','DeltaEta_em_j1','DeltaPhi_em_j1','m_met_mT','e_met_mT','DeltaPhi_e_met','DeltaPhi_m_met','DeltaEta_e_met','DeltaEta_m_met','MetEt','e_m_PZeta']
#var_d_star_gg = ['mPt_Per_e_m_Mass','ePt_Per_e_m_Mass','emPt','emEta','j1Pt','j2Pt','DeltaEta_em_j1','DeltaPhi_em_j1','DeltaEta_j1_j2', 'DeltaPhi_j1_j2', 'DeltaEta_em_j2','DeltaPhi_em_j2','m_met_mT','e_met_mT','DeltaPhi_e_met','DeltaPhi_m_met','DeltaEta_e_met','DeltaEta_m_met','MetEt','e_m_PZeta']
xml_name_gg = os.path.join(os.getcwd(), "dataset/weights/TMVAClassification_BDT_ggV_full.weights.xml")
functor_gg = FunctorFromMVA('BDT method', xml_name_gg, *var_d_star_gg)

#var_d_star_vbf = ['mPt_Per_e_m_Mass','ePt_Per_e_m_Mass','emEta','j1Pt','DeltaEta_em_j1','DeltaPhi_em_j1','DeltaEta_em_j2','DeltaPhi_em_j2','DeltaEta_j1_j2','DeltaPhi_j1_j2','Zeppenfeld','DeltaPhi_e_met','DeltaPhi_m_met','DeltaEta_e_met','DeltaEta_m_met','MetEt','R_pT']
#xml_name_vbf = os.path.join(os.getcwd(), "dataset/weights/TMVAClassification_BDTG_vbf.weights.xml")
#functor_vbf = FunctorFromMVA('BDT method', xml_name_vbf, *var_d_star_vbf)

def var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta):
  return {'emEta' : (myEle + myMuon).Eta(), 'DeltaEta_m_met' : deltaEta(myMuon.Eta(), myMET.Eta()), 'DeltaEta_e_met' : deltaEta(myEle.Eta(), myMET.Eta()), 'MetEt' : myMET.Et(), 'DeltaPhi_e_met' : deltaPhi(myEle.Phi(), myMET.Phi()), 'emPt' : (myEle + myMuon).Pt(), 'DeltaPhi_em_j1' : -1, 'ePt_Per_e_m_Mass' :myEle.Pt()/visibleMass(myEle, myMuon) , 'e_met_mT' : transverseMass(myEle, myMET),'mPt_Per_e_m_Mass' :myMuon.Pt()/visibleMass(myEle, myMuon) ,'m_met_mT' :transverseMass(myMuon, myMET) ,'j1Pt' : -1,'DeltaEta_em_j1' : -1,'e_m_PZeta' :e_m_PZeta ,'DeltaPhi_m_met': deltaPhi(myMuon.Phi(), myMET.Phi())} 

def var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta):
  return {'emEta' : (myEle + myMuon).Eta(), 'DeltaEta_m_met' : deltaEta(myMuon.Eta(), myMET.Eta()), 'DeltaEta_e_met' : deltaEta(myEle.Eta(), myMET.Eta()), 'MetEt' : myMET.Et(), 'DeltaPhi_e_met' : deltaPhi(myEle.Phi(), myMET.Phi()), 'emPt' : (myEle + myMuon).Pt(), 'DeltaPhi_em_j1' : deltaPhi((myEle + myMuon).Phi(), myJet1.Phi()), 'ePt_Per_e_m_Mass' :myEle.Pt()/visibleMass(myEle, myMuon) , 'e_met_mT' : transverseMass(myEle, myMET),'mPt_Per_e_m_Mass' :myMuon.Pt()/visibleMass(myEle, myMuon) ,'m_met_mT' :transverseMass(myMuon, myMET) ,'j1Pt' : myJet1.Pt(),'DeltaEta_em_j1' : deltaEta((myEle + myMuon).Eta(), myJet1.Eta()),'e_m_PZeta' :e_m_PZeta ,'DeltaPhi_m_met' : deltaPhi(myMuon.Phi(), myMET.Phi())} 

def var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta):
  return {'emEta' : (myEle + myMuon).Eta(), 'DeltaEta_m_met' : deltaEta(myMuon.Eta(), myMET.Eta()), 'DeltaEta_e_met' : deltaEta(myEle.Eta(), myMET.Eta()), 'MetEt' : myMET.Et(), 'DeltaPhi_e_met' : deltaPhi(myEle.Phi(), myMET.Phi()), 'emPt' : (myEle + myMuon).Pt(), 'DeltaPhi_em_j1' : deltaPhi((myEle + myMuon).Phi(), myJet1.Phi()), 'ePt_Per_e_m_Mass' :myEle.Pt()/visibleMass(myEle, myMuon) , 'e_met_mT' : transverseMass(myEle, myMET),'mPt_Per_e_m_Mass' :myMuon.Pt()/visibleMass(myEle, myMuon) ,'m_met_mT' :transverseMass(myMuon, myMET) ,'j1Pt' : myJet1.Pt(),'DeltaEta_em_j1' : deltaEta((myEle + myMuon).Eta(), myJet1.Eta()),'e_m_PZeta' :e_m_PZeta ,'DeltaPhi_m_met' : deltaPhi(myMuon.Phi(), myMET.Phi())} 

#def var_d_vbf(myEle, myMuon, myMET, myJet1, myJet2): 
#  return {'emEta' : (myEle + myMuon).Eta(), 'R_pT': abs((myMuon+myEle+myJet1+myJet2).Pt())/(myMuon.Pt()+myEle.Pt()+myJet1.Pt()+myJet2.Pt()),'j1Pt' : myJet1.Pt(), 'MetEt' : myMET.Et(),'Zeppenfeld': Zeppenfeld(myEle, myMuon, myJet1, myJet2),  'DeltaPhi_j1_j2': deltaPhi(myJet1.Phi(), myJet2.Phi()), 'ePt_Per_e_m_Mass' :myEle.Pt()/visibleMass(myEle, myMuon) , 'DeltaEta_j1_j2': deltaEta(myJet1.Eta(), myJet2.Eta()), 'DeltaEta_m_met': deltaPhi(myMuon.Phi(), myMET.Phi()), 'DeltaEta_e_met': deltaPhi(myEle.Phi(), myMET.Phi()),'mPt_Per_e_m_Mass' :myMuon.Pt()/visibleMass(myEle, myMuon) , 'DeltaPhi_e_met': deltaPhi(myEle.Phi(), myMET.Phi()), 'DeltaPhi_em_j1': deltaPhi((myEle + myMuon).Phi(), myJet1.Phi()), 'DeltaEta_em_j1': deltaEta((myEle + myMuon).Eta(), myJet1.Eta()), 'DeltaEta_em_j2': deltaEta((myEle + myMuon).Eta(), myJet2.Eta()), 'DeltaPhi_m_met': deltaPhi(myMuon.Phi(), myMET.Phi()), 'DeltaPhi_em_j2': deltaPhi((myEle + myMuon).Phi(), myJet2.Phi())} 

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

def Zeppenfeld(myLep1, myLep2, myJet1, myJet2):
  return ((myLep1+myLep2).Eta() - (myJet1.Eta() + myJet2.Eta())/2)

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

plotnames = ['TightOSgg', 'TightOSvbf', 'TightSSgg', 'TightSSvbf']

#plotnames = ['TightOS', 'TightOSEB-MB', 'TightOSEB-ME', 'TightOSEE', 'TightOS0Jet', 'TightOS0JetEB-MB', 'TightOS0JetEB-ME', 'TightOS0JetEE', 'TightOS1Jet', 'TightOS1JetEB-MB', 'TightOS1JetEB-ME', 'TightOS1JetEE', 'TightOS2Jet','TightOS2JetGG', 'TightOS2JetGGEB-MB', 'TightOS2JetGGEB-ME', 'TightOS2JetGGEE', 'TightOS2JetVBF']

bdtnames = ['TightOSgg', 'TightOSvbf', 'TightSSgg', 'TightSSvbf']
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
