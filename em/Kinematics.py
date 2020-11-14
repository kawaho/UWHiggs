from math import sqrt, pi, exp, cos
import xml.etree.ElementTree as ET
import os
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA

#var_d_star_gg = ['e_m_Mass', 'emEta', 'j1Pt','DeltaEta_em_j1','DeltaPhi_em_j1','DeltaEta_e_m','DeltaPhi_e_m','DeltaPhi_e_met','DeltaPhi_m_met','DeltaEta_e_met','DeltaEta_m_met','MetEt']#'emPt','e_m_PZeta','m_met_mT','e_met_mT']

var_d_star_gg = ['emPt', 'emEta', 'j1Pt','DeltaEta_em_j1','DeltaPhi_em_j1','DeltaEta_e_m','DeltaPhi_e_m','m_met_mT_per_M','e_met_mT_per_M','DeltaPhi_e_met','DeltaPhi_m_met','DeltaEta_e_met','DeltaEta_m_met','MetEt']#'emPt','e_m_PZeta','m_met_mT','e_met_mT']

xml_name_gg = os.path.join(os.getcwd(), "dataset/weights/TMVAClassification_BDT_gg_per_M.weights.xml")
functor_gg = FunctorFromMVA('BDT method', xml_name_gg, *var_d_star_gg)
def var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta):
  return {'emPt' : (myEle + myMuon).Pt(), 'e_met_mT_per_M' : transverseMass(myEle, myMET)/visibleMass(myEle, myMuon),'m_met_mT_per_M' :transverseMass(myMuon, myMET)/visibleMass(myEle, myMuon),'DeltaEta_em_j1': -1, 'DeltaPhi_e_m':deltaPhi(myMuon.Phi(), myEle.Phi()), 'DeltaEta_e_m':deltaEta(myMuon.Eta(), myEle.Eta()), 'emEta' : (myEle + myMuon).Eta(), 'DeltaEta_m_met' : deltaEta(myMuon.Eta(), myMET.Eta()), 'DeltaEta_e_met' : deltaEta(myEle.Eta(), myMET.Eta()), 'MetEt' : myMET.Et(), 'DeltaPhi_e_met' : deltaPhi(myEle.Phi(), myMET.Phi()), 'DeltaPhi_em_j1' : -1 ,'j1Pt' : -1,'DeltaPhi_m_met': deltaPhi(myMuon.Phi(), myMET.Phi())} #,'e_m_PZeta' :e_m_PZeta, 'e_met_mT' : transverseMass(myEle, myMET),'m_met_mT' :transverseMass(myMuon, myMET), 'emPt' : (myEle + myMuon).Pt()

def var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta):
  return {'emPt' : (myEle + myMuon).Pt(), 'e_met_mT_per_M' : transverseMass(myEle, myMET)/visibleMass(myEle, myMuon),'m_met_mT_per_M' :transverseMass(myMuon, myMET)/visibleMass(myEle, myMuon), 'DeltaEta_em_j1':deltaEta((myEle + myMuon).Eta(), myJet1.Eta()) ,'DeltaPhi_e_m':deltaPhi(myMuon.Phi(), myEle.Phi()), 'DeltaEta_e_m':deltaEta(myMuon.Eta(), myEle.Eta()),'emEta' : (myEle + myMuon).Eta(), 'DeltaEta_m_met' : deltaEta(myMuon.Eta(), myMET.Eta()), 'DeltaEta_e_met' : deltaEta(myEle.Eta(), myMET.Eta()), 'MetEt' : myMET.Et(), 'DeltaPhi_e_met' : deltaPhi(myEle.Phi(), myMET.Phi()), 'DeltaPhi_em_j1' : deltaPhi((myEle + myMuon).Phi(), myJet1.Phi()) ,'j1Pt' : myJet1.Pt(),'DeltaPhi_m_met' : deltaPhi(myMuon.Phi(), myMET.Phi())} #,'e_m_PZeta' :e_m_PZeta, 'e_met_mT' : transverseMass(myEle, myMET),'m_met_mT' :transverseMass(myMuon, myMET), 'emPt' : (myEle + myMuon).Pt()

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


bdtnames = ['TightOSgg', 'TightOSvbf', 'TightSSgg', 'TightSSvbf', 'TightOS', 'TightSS']

catnames = ['TightOS', 'TightOSvbf','TightOSggcat0', 'TightOSggcat1', 'TightOSggcat2', 'TightOSggcat3','TightOSgg']

sys = ['', 'bTagUp2016', 'bTagDown2016', 'bTagUp2017', 'bTagDown2017', 'bTagUp2018', 'bTagDown2018', 'puUp2016', 'puDown2016', 'puUp2017', 'puDown2017', 'puUp2018', 'puDown2018', 'pfUp2016', 'pfDown2016',  'pfUp2017', 'pfDown2017', 'eesUp', 'eesDown', 'eerUp', 'eerDown', 'meUp', 'meDown']

jes = ['JetAbsoluteUp', 'JetAbsoluteDown', 'JetAbsoluteyearUp', 'JetAbsoluteyearDown', 'JetBBEC1Up', 'JetBBEC1Down', 'JetBBEC1yearUp', 'JetBBEC1yearDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetEC2Up', 'JetEC2Down', 'JetEC2yearUp', 'JetEC2yearDown', 'JetHFUp', 'JetHFDown', 'JetHFyearUp', 'JetHFyearDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown', 'JERUp', 'JERDown']

ues = ['UnclusteredEnUp', 'UnclusteredEnDown', 'UesCHARGEDUp', 'UesCHARGEDDown', 'UesECALUp', 'UesECALDown', 'UesHCALUp', 'UesHCALDown', 'UesHFUp', 'UesHFDown']

lhe = ['lhe0', 'lhe1', 'lhe2', 'lhe3', 'lhe4', 'lhe5', 'lhe6', 'lhe7', 'lhe8', 'lhe9', 'lhe10', 'lhe11', 'lhe12', 'lhe13', 'lhe14', 'lhe15', 'lhe16', 'lhe17', 'lhe18', 'lhe19', 'lhe20', 'lhe21', 'lhe22', 'lhe23', 'lhe24', 'lhe25', 'lhe26', 'lhe27', 'lhe28', 'lhe29', 'lhe30', 'lhe31', 'lhe32', 'lhe33', 'lhe34', 'lhe35', 'lhe36', 'lhe37', 'lhe38', 'lhe39', 'lhe40', 'lhe41', 'lhe42', 'lhe43', 'lhe44', 'lhe45', 'lhe46', 'lhe47', 'lhe48', 'lhe49', 'lhe50', 'lhe51', 'lhe52', 'lhe53', 'lhe54', 'lhe55', 'lhe56', 'lhe57', 'lhe58', 'lhe59', 'lhe60', 'lhe61', 'lhe62', 'lhe63', 'lhe64', 'lhe65', 'lhe66', 'lhe67', 'lhe68', 'lhe69', 'lhe70', 'lhe71', 'lhe72', 'lhe73', 'lhe74', 'lhe75', 'lhe76', 'lhe77', 'lhe78', 'lhe79', 'lhe80', 'lhe81', 'lhe82', 'lhe83', 'lhe84', 'lhe85', 'lhe86', 'lhe87', 'lhe88', 'lhe89', 'lhe90', 'lhe91', 'lhe92', 'lhe93', 'lhe94', 'lhe95', 'lhe96', 'lhe97', 'lhe98', 'lhe99', 'lhe100', 'lhe101', 'lhe102', 'lhe103', 'lhe104', 'lhe105', 'lhe106', 'lhe107', 'lhe108', 'lhe109', 'lhe110', 'lhe111', 'lhe112', 'lhe113', 'lhe114', 'lhe115', 'lhe116', 'lhe117', 'lhe118', 'lhe119']
