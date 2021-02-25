from math import sqrt, pi, exp, cos
import xml.etree.ElementTree as ET
import os
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA, FunctorFromMVACat

#var_d_star_gg = ["mPt_Per_e_m_Mass","ePt_Per_e_m_Mass","emEta","DeltaR_e_m","j1Pt","j1Eta","DeltaR_em_j1","j2Eta","DeltaR_em_j2","DeltaEta_j1_j2","R_pT","Nj"]
var_d_star_gg = ["mPt_Per_e_m_Mass","ePt_Per_e_m_Mass","emEta","DeltaR_e_m","m_met_mT_per_M","e_met_mT_per_M","MetEt","j1Pt","j1Eta","DeltaR_em_j1","j2Eta","DeltaR_em_j2","DeltaEta_j1_j2","R_pT","Nj"]
xml_name_gg = os.path.join(os.getcwd(), "../../UWHiggs2016/em/dataset/weights/TMVAClassification_BDTCat_allyear.weights.xml")
#xml_name_gg = os.path.join(os.getcwd(), "dataset/weights/TMVAClassification_BDTCat2.weights.xml")
functor_gg = FunctorFromMVACat('BDT method', xml_name_gg, *var_d_star_gg)

#var_d_star_vbf = ["mPt_Per_e_m_Mass","ePt_Per_e_m_Mass","emEta","DeltaR_e_m","m_met_mT_per_M","e_met_mT_per_M","MetEt","j1Pt","j1Eta","DeltaR_em_j1","j2Eta","DeltaR_em_j2","DeltaEta_j1_j2","R_pT","Ht"]
#xml_name_vbf = os.path.join(os.getcwd(), "dataset/weights/TMVAClassification_BDT_vbf_opt.weights.xml")
#functor_vbf = FunctorFromMVA('BDT method', xml_name_vbf, *var_d_star_vbf)

#def var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, Ht, mjj, nj):
#  return {"Nj":nj, "mPt_Per_e_m_Mass":myMuon.Pt()/visibleMass(myEle, myMuon),"ePt_Per_e_m_Mass":myEle.Pt()/visibleMass(myEle, myMuon),"emEta":(myEle + myMuon).Eta(),"DeltaR_e_m":deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()),"j1Pt":-1,"j1Eta":-10,"DeltaR_em_j1":-1,"j2Eta":-10,"DeltaR_em_j2":-1,"R_pT":0, "DeltaEta_j1_j2":-1}
#def var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, Ht, mjj, nj):
#  return {"Nj":nj, "mPt_Per_e_m_Mass":myMuon.Pt()/visibleMass(myEle, myMuon),"ePt_Per_e_m_Mass":myEle.Pt()/visibleMass(myEle, myMuon),"emEta":(myEle + myMuon).Eta(),"DeltaR_e_m":deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()),"j1Pt":myJet1.Pt(),"j1Eta":myJet1.Eta(),"DeltaR_em_j1":deltaR((myEle + myMuon).Phi(), myJet1.Phi(), (myEle + myMuon).Eta(), myJet1.Eta()),"j2Eta":-10,"DeltaR_em_j2":-1,"R_pT":0, "DeltaEta_j1_j2":-1}
#
#def var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, Ht,mjj,nj):
#  return {"Nj":nj, "mPt_Per_e_m_Mass":myMuon.Pt()/visibleMass(myEle, myMuon),"ePt_Per_e_m_Mass":myEle.Pt()/visibleMass(myEle, myMuon),"emEta":(myEle + myMuon).Eta(),"DeltaR_e_m":deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()),"j1Pt":myJet1.Pt(),"j1Eta":myJet1.Eta(),"DeltaR_em_j1":deltaR((myEle + myMuon).Phi(), myJet1.Phi(), (myEle + myMuon).Eta(), myJet1.Eta()),"j2Eta":myJet2.Eta(),"DeltaR_em_j2":deltaR((myEle + myMuon).Phi(), myJet2.Phi(),(myEle + myMuon).Eta(), myJet2.Eta()),"R_pT":abs((myMuon+myEle+myJet1+myJet2).Pt())/(myMuon.Pt()+myEle.Pt()+myJet1.Pt()+myJet2.Pt()), "DeltaEta_j1_j2":deltaEta(myJet1.Eta(), myJet2.Eta())}


def var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, Ht, mjj, nj):
  return {"Nj":nj, "mPt_Per_e_m_Mass":myMuon.Pt()/visibleMass(myEle, myMuon),"ePt_Per_e_m_Mass":myEle.Pt()/visibleMass(myEle, myMuon),"emEta":(myEle + myMuon).Eta(),"DeltaR_e_m":deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()),"m_met_mT_per_M":transverseMass(myMuon, myMET)/visibleMass(myEle, myMuon),"e_met_mT_per_M":transverseMass(myEle, myMET)/visibleMass(myEle, myMuon),"MetEt":myMET.Et(),"j1Pt":-1,"j1Eta":-10,"DeltaR_em_j1":-1,"j2Eta":-10,"DeltaR_em_j2":-1,"R_pT":0, "DeltaEta_j1_j2":-1}

def var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, Ht, mjj, nj):
  return {"Nj":nj, "mPt_Per_e_m_Mass":myMuon.Pt()/visibleMass(myEle, myMuon),"ePt_Per_e_m_Mass":myEle.Pt()/visibleMass(myEle, myMuon),"emEta":(myEle + myMuon).Eta(),"DeltaR_e_m":deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()),"m_met_mT_per_M":transverseMass(myMuon, myMET)/visibleMass(myEle, myMuon),"e_met_mT_per_M":transverseMass(myEle, myMET)/visibleMass(myEle, myMuon),"MetEt":myMET.Et(),"j1Pt":myJet1.Pt(),"j1Eta":myJet1.Eta(),"DeltaR_em_j1":deltaR((myEle + myMuon).Phi(), myJet1.Phi(), (myEle + myMuon).Eta(), myJet1.Eta()),"j2Eta":-10,"DeltaR_em_j2":-1,"R_pT":0, "DeltaEta_j1_j2":-1}

def var_d_gg_2(myEle, myMuon, myMET, myJet1, myJet2, Ht,mjj,nj):
  return {"Nj":nj, "mPt_Per_e_m_Mass":myMuon.Pt()/visibleMass(myEle, myMuon),"ePt_Per_e_m_Mass":myEle.Pt()/visibleMass(myEle, myMuon),"emEta":(myEle + myMuon).Eta(),"DeltaR_e_m":deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()),"m_met_mT_per_M":transverseMass(myMuon, myMET)/visibleMass(myEle, myMuon),"e_met_mT_per_M":transverseMass(myEle, myMET)/visibleMass(myEle, myMuon),"MetEt":myMET.Et(),"j1Pt":myJet1.Pt(),"j1Eta":myJet1.Eta(),"DeltaR_em_j1":deltaR((myEle + myMuon).Phi(), myJet1.Phi(), (myEle + myMuon).Eta(), myJet1.Eta()),"j2Eta":myJet2.Eta(),"DeltaR_em_j2":deltaR((myEle + myMuon).Phi(), myJet2.Phi(),(myEle + myMuon).Eta(), myJet2.Eta()),"R_pT":abs((myMuon+myEle+myJet1+myJet2).Pt())/(myMuon.Pt()+myEle.Pt()+myJet1.Pt()+myJet2.Pt()), "DeltaEta_j1_j2":deltaEta(myJet1.Eta(), myJet2.Eta())}

def var_d_vbf_2(myEle, myMuon, myMET, myJet1, myJet2, Ht,mjj,nj):
  return {"Ht":Ht, "mPt_Per_e_m_Mass":myMuon.Pt()/visibleMass(myEle, myMuon),"ePt_Per_e_m_Mass":myEle.Pt()/visibleMass(myEle, myMuon),"emEta":(myEle + myMuon).Eta(),"DeltaR_e_m":deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()),"m_met_mT_per_M":transverseMass(myMuon, myMET)/visibleMass(myEle, myMuon),"e_met_mT_per_M":transverseMass(myEle, myMET)/visibleMass(myEle, myMuon),"MetEt":myMET.Et(),"j1Eta":myJet1.Eta(),"DeltaR_em_j1":deltaR((myEle + myMuon).Phi(), myJet1.Phi(), (myEle + myMuon).Eta(), myJet1.Eta()),"j2Eta":myJet2.Eta(),"DeltaR_em_j2":deltaR((myEle + myMuon).Phi(), myJet2.Phi(),(myEle + myMuon).Eta(), myJet2.Eta()),"R_pT":abs((myMuon+myEle+myJet1+myJet2).Pt())/(myMuon.Pt()+myEle.Pt()+myJet1.Pt()+myJet2.Pt()), "DeltaEta_j1_j2":deltaEta(myJet1.Eta(), myJet2.Eta()), "j1Pt":myJet1.Pt()}

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
  return (myLep1+myLep2).Eta() - (myJet1.Eta() + myJet2.Eta())/2

def RpT(myLep1, myLep2, myJet1, myJet2):
  return abs((myLep1+myLep2+myJet1+myJet2).Pt())/(myLep1.Pt()+myLep2.Pt()+myJet1.Pt()+myJet2.Pt())

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

bdtcuts = [0.0475, 0.1025, 0.1225, 0.1555]

#bdtnames = ['TightOSgg', 'TightOShj', 'TightSSgg', 'TightSShj', 'TightOS', 'TightSS']
bdtnames = ['TightOSgg']


yieldnames = ['TightOSgg', 'TightSSgg', 'TightOSgg/puUp', 'TightOSgg/puDown', 'TightSSgg/puUp', 'TightSSgg/puDown', 'TightSSgg/UnclusteredEnUp2016', 'TightSSgg/UnclusteredEnUp2017', 'TightSSgg/UnclusteredEnUp2018', 'TightOSgg/UnclusteredEnUp2018', 'TightOSgg/UnclusteredEnUp2016', 'TightOSgg/UnclusteredEnUp2017', 'TightSSgg/UnclusteredEnDown2016', 'TightSSgg/UnclusteredEnDown2017', 'TightSSgg/UnclusteredEnDown2018', 'TightOSgg/UnclusteredEnDown2018', 'TightOSgg/UnclusteredEnDown2016', 'TightOSgg/UnclusteredEnDown2017', 'TightSSgg/UesCHARGEDUp2016', 'TightSSgg/UesCHARGEDUp2017', 'TightSSgg/UesCHARGEDUp2018', 'TightOSgg/UesCHARGEDUp2018', 'TightOSgg/UesCHARGEDUp2016', 'TightOSgg/UesCHARGEDUp2017', 'TightSSgg/UesCHARGEDDown2016', 'TightSSgg/UesCHARGEDDown2017', 'TightSSgg/UesCHARGEDDown2018', 'TightOSgg/UesCHARGEDDown2018', 'TightOSgg/UesCHARGEDDown2016', 'TightOSgg/UesCHARGEDDown2017', 'TightSSgg/UesECALUp2016', 'TightSSgg/UesECALUp2017', 'TightSSgg/UesECALUp2018', 'TightOSgg/UesECALUp2018', 'TightOSgg/UesECALUp2016', 'TightOSgg/UesECALUp2017', 'TightSSgg/UesECALDown2016', 'TightSSgg/UesECALDown2017', 'TightSSgg/UesECALDown2018', 'TightOSgg/UesECALDown2018', 'TightOSgg/UesECALDown2016', 'TightOSgg/UesECALDown2017', 'TightSSgg/UesHCALUp2016', 'TightSSgg/UesHCALUp2017', 'TightSSgg/UesHCALUp2018', 'TightOSgg/UesHCALUp2018', 'TightOSgg/UesHCALUp2016', 'TightOSgg/UesHCALUp2017', 'TightSSgg/UesHCALDown2016', 'TightSSgg/UesHCALDown2017', 'TightSSgg/UesHCALDown2018', 'TightOSgg/UesHCALDown2018', 'TightOSgg/UesHCALDown2016', 'TightOSgg/UesHCALDown2017', 'TightSSgg/UesHFUp2016', 'TightSSgg/UesHFUp2017', 'TightSSgg/UesHFUp2018', 'TightOSgg/UesHFUp2018', 'TightOSgg/UesHFUp2016', 'TightOSgg/UesHFUp2017', 'TightSSgg/UesHFDown2016', 'TightSSgg/UesHFDown2017', 'TightSSgg/UesHFDown2018', 'TightOSgg/UesHFDown2018', 'TightOSgg/UesHFDown2016', 'TightOSgg/UesHFDown2017']
#vbfnames = ['TightOSvbf', 'TightOSvbf500a', 'TightOSvbf500b', 'TightOSvbf510a', 'TightOSvbf510b', 'TightOSvbf520a', 'TightOSvbf520b', 'TightOSvbf530a', 'TightOSvbf530b', 'TightOSvbf540a', 'TightOSvbf540b', 'TightOSvbf550a', 'TightOSvbf550b', 'TightOSvbf560a', 'TightOSvbf560b', 'TightOSvbf570a', 'TightOSvbf570b', 'TightOSvbf580a', 'TightOSvbf580b', 'TightOSvbf590a', 'TightOSvbf590b', 'TightOSvbf600a', 'TightOSvbf600b', 'TightOSvbf610a', 'TightOSvbf610b', 'TightOSvbf620a', 'TightOSvbf620b', 'TightOSvbf630a', 'TightOSvbf630b', 'TightOSvbf640a', 'TightOSvbf640b', 'TightOSvbf650a', 'TightOSvbf650b', 'TightOSvbf660a', 'TightOSvbf660b', 'TightOSvbf670a', 'TightOSvbf670b', 'TightOSvbf680a', 'TightOSvbf680b', 'TightOSvbf690a', 'TightOSvbf690b', 'TightOSvbf700a', 'TightOSvbf700b']
vbfnames = ['TightOS', 'TightOSvbf', 'TightOSvbfcat0', 'TightOSvbfcat1', 'TightOSvbfcat2', 'TightOSvbfcat3', 'TightOSvbfcat4', 'TightOSvbfcat5', 'TightOSvbfcat6','TightOSvbfcat7','TightOSvbfcat8', 'TightOSvbfcat9', 'TightOSvbfcat10', 'TightOSvbfcat11', 'TightOSvbfcat12', 'TightOSvbfcat13', 'TightOSvbfcat14', 'TightOSvbfcat15']


#catnames = ['TightOS', 'TightOSvbf','TightOSggcat0', 'TightOSggcat1', 'TightOSggcat2', 'TightOSggcat1_EC', 'TightOSggcat2_EC', 'TightOSggcat1_B', 'TightOSggcat2_B', 'TightOSggcat3','TightOSgg']
#catnames = ['TightOS','TightOSvbf', 'TightOSvbf1a', 'TightOSvbf1b', 'TightOSvbf2a', 'TightOSvbf2b', 'TightOSvbf3a', 'TightOSvbf3b', 'TightOSvbf4a', 'TightOSvbf4b', 'TightOSvbf5a', 'TightOSvbf5b', 'TightOSvbf6a', 'TightOSvbf6b', 'TightOSvbf7a', 'TightOSvbf7b', 'TightOSvbf8a', 'TightOSvbf8b', 'TightOSvbf9a', 'TightOSvbf9b', 'TightOSvbf10a', 'TightOSvbf10b', 'TightOSvbf11a', 'TightOSvbf11b', 'TightOSvbf12a', 'TightOSvbf12b', 'TightOSvbf13a', 'TightOSvbf13b', 'TightOSvbf14a', 'TightOSvbf14b', 'TightOSvbf15a', 'TightOSvbf15b', 'TightOSvbf16a', 'TightOSvbf16b', 'TightOSvbf17a', 'TightOSvbf17b', 'TightOSvbf18a', 'TightOSvbf18b', 'TightOSvbf19a', 'TightOSvbf19b']
catnames = ['TightOS', 'TightOSvbf', 'TightOSgg', 'TightOSggcat0', 'TightOSggcat1', 'TightOSggcat2', 'TightOSggcat3', 'TightOSggcat4', 'TightOSggcat5', 'TightOSggcat6', 'TightOSvbfcat0', 'TightOSvbfcat1']
#catnames = ['TightOSggcat0', 'TightOSggcat1', 'TightOSggcat2', 'TightOSggcat3', 'TightOSggcat4', 'TightOShjcat0', 'TightOShjcat1', 'TightOShjcat2', 'TightOShjcat3', 'TightOShjcat4', 'TightSSggcat0', 'TightSSggcat1', 'TightSSggcat2', 'TightSSggcat3', 'TightSSggcat4', 'TightSShjcat0', 'TightSShjcat1', 'TightSShjcat2', 'TightSShjcat3', 'TightSShjcat4']
sys = ['', 'bTagUp2016', 'bTagDown2016', 'bTagUp2017', 'bTagDown2017', 'bTagUp2018', 'bTagDown2018', 'puUp2016', 'puDown2016', 'puUp2017', 'puDown2017', 'puUp2018', 'puDown2018', 'pfUp2016', 'pfDown2016',  'pfUp2017', 'pfDown2017', 'eesUp', 'eesDown', 'eerUp', 'eerDown', 'meUp', 'meDown']

jes = ['JetAbsoluteUp', 'JetAbsoluteDown', 'JetAbsoluteyearUp', 'JetAbsoluteyearDown', 'JetBBEC1Up', 'JetBBEC1Down', 'JetBBEC1yearUp', 'JetBBEC1yearDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetEC2Up', 'JetEC2Down', 'JetEC2yearUp', 'JetEC2yearDown', 'JetHFUp', 'JetHFDown', 'JetHFyearUp', 'JetHFyearDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown', 'JERUp', 'JERDown']

ues = ['UnclusteredEnUp', 'UnclusteredEnDown', 'UesCHARGEDUp', 'UesCHARGEDDown', 'UesECALUp', 'UesECALDown', 'UesHCALUp', 'UesHCALDown', 'UesHFUp', 'UesHFDown']

lhe = ['lhe0', 'lhe1', 'lhe2', 'lhe3', 'lhe4', 'lhe5', 'lhe6', 'lhe7', 'lhe8', 'lhe9', 'lhe10', 'lhe11', 'lhe12', 'lhe13', 'lhe14', 'lhe15', 'lhe16', 'lhe17', 'lhe18', 'lhe19', 'lhe20', 'lhe21', 'lhe22', 'lhe23', 'lhe24', 'lhe25', 'lhe26', 'lhe27', 'lhe28', 'lhe29', 'lhe30', 'lhe31', 'lhe32', 'lhe33', 'lhe34', 'lhe35', 'lhe36', 'lhe37', 'lhe38', 'lhe39', 'lhe40', 'lhe41', 'lhe42', 'lhe43', 'lhe44', 'lhe45', 'lhe46', 'lhe47', 'lhe48', 'lhe49', 'lhe50', 'lhe51', 'lhe52', 'lhe53', 'lhe54', 'lhe55', 'lhe56', 'lhe57', 'lhe58', 'lhe59', 'lhe60', 'lhe61', 'lhe62', 'lhe63', 'lhe64', 'lhe65', 'lhe66', 'lhe67', 'lhe68', 'lhe69', 'lhe70', 'lhe71', 'lhe72', 'lhe73', 'lhe74', 'lhe75', 'lhe76', 'lhe77', 'lhe78', 'lhe79', 'lhe80', 'lhe81', 'lhe82', 'lhe83', 'lhe84', 'lhe85', 'lhe86', 'lhe87', 'lhe88', 'lhe89', 'lhe90', 'lhe91', 'lhe92', 'lhe93', 'lhe94', 'lhe95', 'lhe96', 'lhe97', 'lhe98', 'lhe99', 'lhe100', 'lhe101', 'lhe102', 'lhe103', 'lhe104', 'lhe105', 'lhe106', 'lhe107', 'lhe108', 'lhe109', 'lhe110', 'lhe111', 'lhe112', 'lhe113', 'lhe114', 'lhe115', 'lhe116', 'lhe117', 'lhe118', 'lhe119']
