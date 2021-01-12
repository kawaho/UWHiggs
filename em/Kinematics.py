from math import sqrt, pi, exp, cos
import xml.etree.ElementTree as ET
import os
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA

var_d_star_gg = ["mPt_Per_e_m_Mass","ePt_Per_e_m_Mass","emEta","DeltaR_e_m","m_met_mT_per_M","e_met_mT_per_M","MetEt","j1Pt","j1Eta","DeltaR_em_j1","j2Pt","j2Eta","DeltaR_em_j2","R_pT"]

xml_name_gg = os.path.join(os.getcwd(), "dataset/weights/TMVAClassification_BDT_gg_opt.weights.xml")
functor_gg = FunctorFromMVA('BDT method', xml_name_gg, *var_d_star_gg)
def var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta, mjj):
  return {"mPt_Per_e_m_Mass":myMuon.Pt()/visibleMass(myEle, myMuon),"ePt_Per_e_m_Mass":myEle.Pt()/visibleMass(myEle, myMuon),"emEta":(myEle + myMuon).Eta(),"DeltaR_e_m":deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()),"m_met_mT_per_M":transverseMass(myMuon, myMET)/visibleMass(myEle, myMuon),"e_met_mT_per_M":transverseMass(myEle, myMET)/visibleMass(myEle, myMuon),"MetEt":myMET.Et(),"j1Pt":-1,"j1Eta":-10,"DeltaR_em_j1":-1,"j2Pt":-1,"j2Eta":-10,"DeltaR_em_j2":-1,"R_pT":0}

def var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta, mjj):
  return {"mPt_Per_e_m_Mass":myMuon.Pt()/visibleMass(myEle, myMuon),"ePt_Per_e_m_Mass":myEle.Pt()/visibleMass(myEle, myMuon),"emEta":(myEle + myMuon).Eta(),"DeltaR_e_m":deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()),"m_met_mT_per_M":transverseMass(myMuon, myMET)/visibleMass(myEle, myMuon),"e_met_mT_per_M":transverseMass(myEle, myMET)/visibleMass(myEle, myMuon),"MetEt":myMET.Et(),"j1Pt":myJet1.Pt(),"j1Eta":myJet1.Eta(),"DeltaR_em_j1":deltaR((myEle + myMuon).Phi(), myJet1.Phi(), (myEle + myMuon).Eta(), myJet1.Eta()),"j2Pt":-1,"j2Eta":-10,"DeltaR_em_j2":-1,"R_pT":0}

def var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta,mjj):
  return {"mPt_Per_e_m_Mass":myMuon.Pt()/visibleMass(myEle, myMuon),"ePt_Per_e_m_Mass":myEle.Pt()/visibleMass(myEle, myMuon),"emEta":(myEle + myMuon).Eta(),"DeltaR_e_m":deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()),"m_met_mT_per_M":transverseMass(myMuon, myMET)/visibleMass(myEle, myMuon),"e_met_mT_per_M":transverseMass(myEle, myMET)/visibleMass(myEle, myMuon),"MetEt":myMET.Et(),"j1Pt":myJet1.Pt(),"j1Eta":myJet1.Eta(),"DeltaR_em_j1":deltaR((myEle + myMuon).Phi(), myJet1.Phi(), (myEle + myMuon).Eta(), myJet1.Eta()),"j2Pt":myJet2.Pt(),"j2Eta":myJet2.Eta(),"DeltaR_em_j2":deltaR((myEle + myMuon).Phi(), myJet2.Phi(),(myEle + myMuon).Eta(), myJet2.Eta()),"R_pT":abs((myMuon+myEle+myJet1+myJet2).Pt())/(myMuon.Pt()+myEle.Pt()+myJet1.Pt()+myJet2.Pt())}

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

#catnames = ['TightOS', 'TightOSvbf','TightOSggcat0', 'TightOSggcat1', 'TightOSggcat2', 'TightOSggcat1_EC', 'TightOSggcat2_EC', 'TightOSggcat1_B', 'TightOSggcat2_B', 'TightOSggcat3','TightOSgg']
catnames = ['TightOS', 'TightOSvbf','TightOSggcat0', 'TightOSggcat1', 'TightOSggcat2', 'TightOSggcat3', 'TightOSggcat4', 'TightOSgg']

#catnames = ['TightOS', 'TightOSvbf','TightOSggcat0', 'TightOSggcat1_EB', 'TightOSggcat2_EB', 'TightOSggcat1_EE', 'TightOSggcat2_EE', 'TightOSggcat3','TightOSgg']

vbfnames = ['TightOSvbf', 'TightOSvbf500a', 'TightOSvbf500b', 'TightOSvbf510a', 'TightOSvbf510b', 'TightOSvbf520a', 'TightOSvbf520b', 'TightOSvbf530a', 'TightOSvbf530b', 'TightOSvbf540a', 'TightOSvbf540b', 'TightOSvbf550a', 'TightOSvbf550b', 'TightOSvbf560a', 'TightOSvbf560b', 'TightOSvbf570a', 'TightOSvbf570b', 'TightOSvbf580a', 'TightOSvbf580b', 'TightOSvbf590a', 'TightOSvbf590b', 'TightOSvbf600a', 'TightOSvbf600b', 'TightOSvbf610a', 'TightOSvbf610b', 'TightOSvbf620a', 'TightOSvbf620b', 'TightOSvbf630a', 'TightOSvbf630b', 'TightOSvbf640a', 'TightOSvbf640b', 'TightOSvbf650a', 'TightOSvbf650b', 'TightOSvbf660a', 'TightOSvbf660b', 'TightOSvbf670a', 'TightOSvbf670b', 'TightOSvbf680a', 'TightOSvbf680b', 'TightOSvbf690a', 'TightOSvbf690b', 'TightOSvbf700a', 'TightOSvbf700b']

sys = ['', 'bTagUp2016', 'bTagDown2016', 'bTagUp2017', 'bTagDown2017', 'bTagUp2018', 'bTagDown2018', 'puUp2016', 'puDown2016', 'puUp2017', 'puDown2017', 'puUp2018', 'puDown2018', 'pfUp2016', 'pfDown2016',  'pfUp2017', 'pfDown2017', 'eesUp', 'eesDown', 'eerUp', 'eerDown', 'meUp', 'meDown']

jes = ['JetAbsoluteUp', 'JetAbsoluteDown', 'JetAbsoluteyearUp', 'JetAbsoluteyearDown', 'JetBBEC1Up', 'JetBBEC1Down', 'JetBBEC1yearUp', 'JetBBEC1yearDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetEC2Up', 'JetEC2Down', 'JetEC2yearUp', 'JetEC2yearDown', 'JetHFUp', 'JetHFDown', 'JetHFyearUp', 'JetHFyearDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown', 'JERUp', 'JERDown']

ues = ['UnclusteredEnUp', 'UnclusteredEnDown', 'UesCHARGEDUp', 'UesCHARGEDDown', 'UesECALUp', 'UesECALDown', 'UesHCALUp', 'UesHCALDown', 'UesHFUp', 'UesHFDown']

bdtnames = ['TightOS', 'TightOSgg', 'TightOSvbf', 'TightSSgg', 'TightSSvbf']
mesSys = ['/mes1p2Up', '/mes1p2Down', '/mes2p1Up', '/mes2p1Down', '/mes2p4Up', '/mes2p4Down']

lhe = ['lhe0', 'lhe1', 'lhe2', 'lhe3', 'lhe4', 'lhe5', 'lhe6', 'lhe7', 'lhe8', 'lhe9', 'lhe10', 'lhe11', 'lhe12', 'lhe13', 'lhe14', 'lhe15', 'lhe16', 'lhe17', 'lhe18', 'lhe19', 'lhe20', 'lhe21', 'lhe22', 'lhe23', 'lhe24', 'lhe25', 'lhe26', 'lhe27', 'lhe28', 'lhe29', 'lhe30', 'lhe31', 'lhe32', 'lhe33', 'lhe34', 'lhe35', 'lhe36', 'lhe37', 'lhe38', 'lhe39', 'lhe40', 'lhe41', 'lhe42', 'lhe43', 'lhe44', 'lhe45', 'lhe46', 'lhe47', 'lhe48', 'lhe49', 'lhe50', 'lhe51', 'lhe52', 'lhe53', 'lhe54', 'lhe55', 'lhe56', 'lhe57', 'lhe58', 'lhe59', 'lhe60', 'lhe61', 'lhe62', 'lhe63', 'lhe64', 'lhe65', 'lhe66', 'lhe67', 'lhe68', 'lhe69', 'lhe70', 'lhe71', 'lhe72', 'lhe73', 'lhe74', 'lhe75', 'lhe76', 'lhe77', 'lhe78', 'lhe79', 'lhe80', 'lhe81', 'lhe82', 'lhe83', 'lhe84', 'lhe85', 'lhe86', 'lhe87', 'lhe88', 'lhe89', 'lhe90', 'lhe91', 'lhe92', 'lhe93', 'lhe94', 'lhe95', 'lhe96', 'lhe97', 'lhe98', 'lhe99', 'lhe100', 'lhe101', 'lhe102', 'lhe103', 'lhe104', 'lhe105', 'lhe106', 'lhe107', 'lhe108', 'lhe109', 'lhe110', 'lhe111', 'lhe112', 'lhe113', 'lhe114', 'lhe115', 'lhe116', 'lhe117', 'lhe118', 'lhe119']
