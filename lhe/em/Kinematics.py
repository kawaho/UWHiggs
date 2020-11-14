from math import sqrt, pi, exp, cos
import xml.etree.ElementTree as ET
import os
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA

var_d_star_gg = ['mPt_Per_e_m_Mass','ePt_Per_e_m_Mass','emPt','emEta','j1Pt','DeltaEta_em_j1','DeltaPhi_em_j1','m_met_mT','e_met_mT','DeltaPhi_e_met','DeltaPhi_m_met','DeltaEta_e_met','DeltaEta_m_met','MetEt','e_m_PZeta']

xml_name_gg = os.path.join(os.getcwd(), "../../em/dataset/weights/TMVAClassification_BDT_gg.weights.xml")
functor_gg = FunctorFromMVA('BDT method', xml_name_gg, *var_d_star_gg)

def var_d_gg_0(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta):
  return {'emEta' : (myEle + myMuon).Eta(), 'DeltaEta_m_met' : deltaEta(myMuon.Eta(), myMET.Eta()), 'DeltaEta_e_met' : deltaEta(myEle.Eta(), myMET.Eta()), 'MetEt' : myMET.Et(), 'DeltaPhi_e_met' : deltaPhi(myEle.Phi(), myMET.Phi()), 'emPt' : (myEle + myMuon).Pt(), 'DeltaPhi_em_j1' : -1, 'ePt_Per_e_m_Mass' :myEle.Pt()/visibleMass(myEle, myMuon) , 'e_met_mT' : transverseMass(myEle, myMET),'mPt_Per_e_m_Mass' :myMuon.Pt()/visibleMass(myEle, myMuon) ,'m_met_mT' :transverseMass(myMuon, myMET) ,'j1Pt' : -1,'DeltaEta_em_j1' : -1,'e_m_PZeta' :e_m_PZeta ,'DeltaPhi_m_met': deltaPhi(myMuon.Phi(), myMET.Phi())} 

def var_d_gg_1(myEle, myMuon, myMET, myJet1, myJet2, e_m_PZeta):
  return {'emEta' : (myEle + myMuon).Eta(), 'DeltaEta_m_met' : deltaEta(myMuon.Eta(), myMET.Eta()), 'DeltaEta_e_met' : deltaEta(myEle.Eta(), myMET.Eta()), 'MetEt' : myMET.Et(), 'DeltaPhi_e_met' : deltaPhi(myEle.Phi(), myMET.Phi()), 'emPt' : (myEle + myMuon).Pt(), 'DeltaPhi_em_j1' : deltaPhi((myEle + myMuon).Phi(), myJet1.Phi()), 'ePt_Per_e_m_Mass' :myEle.Pt()/visibleMass(myEle, myMuon) , 'e_met_mT' : transverseMass(myEle, myMET),'mPt_Per_e_m_Mass' :myMuon.Pt()/visibleMass(myEle, myMuon) ,'m_met_mT' :transverseMass(myMuon, myMET) ,'j1Pt' : myJet1.Pt(),'DeltaEta_em_j1' : deltaEta((myEle + myMuon).Eta(), myJet1.Eta()),'e_m_PZeta' :e_m_PZeta ,'DeltaPhi_m_met' : deltaPhi(myMuon.Phi(), myMET.Phi())} 

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

def visibleMass(vm, ve):
  return (vm+ve).M()

def collMass(myMuon, myMET, myEle):
  ptnu = abs(myMET.Et()*cos(deltaPhi(myMET.Phi(), myEle.Phi())))
  visfrac = myEle.Pt()/(myEle.Pt() + ptnu)
  m_e_Mass = visibleMass(myMuon, myEle)
  return (m_e_Mass/sqrt(visfrac))

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

names = ['TightOS', 'TightOSvbf', 'TightOSgg', 'TightOSggcat0', 'Tightggcat1', 'TightOSggcat2']

gennames = ['TightOSAll', 'TightOSvbfAll', 'TightOSggAll', 'TightOSggcat0All', 'Tightggcat1All', 'TightOSggcat2All']

lhe = ['lhe0_2016', 'lhe0_2017', 'lhe0_2018', 'lhe1_2016', 'lhe1_2017', 'lhe1_2018', 'lhe2_2016', 'lhe2_2017', 'lhe2_2018', 'lhe3_2016', 'lhe3_2017', 'lhe3_2018', 'lhe4_2016', 'lhe4_2017', 'lhe4_2018', 'lhe5_2016', 'lhe5_2017', 'lhe5_2018', 'lhe6_2016', 'lhe6_2017', 'lhe6_2018', 'lhe7_2016', 'lhe7_2017', 'lhe7_2018', 'lhe8_2016', 'lhe8_2017', 'lhe8_2018', 'lhe9_2016', 'lhe9_2017', 'lhe9_2018', 'lhe10_2016', 'lhe10_2017', 'lhe10_2018', 'lhe11_2016', 'lhe11_2017', 'lhe11_2018', 'lhe12_2016', 'lhe12_2017', 'lhe12_2018', 'lhe13_2016', 'lhe13_2017', 'lhe13_2018', 'lhe14_2016', 'lhe14_2017', 'lhe14_2018', 'lhe15_2016', 'lhe15_2017', 'lhe15_2018', 'lhe16_2016', 'lhe16_2017', 'lhe16_2018', 'lhe17_2016', 'lhe17_2017', 'lhe17_2018', 'lhe18_2016', 'lhe18_2017', 'lhe18_2018', 'lhe19_2016', 'lhe19_2017', 'lhe19_2018', 'lhe20_2016', 'lhe20_2017', 'lhe20_2018', 'lhe21_2016', 'lhe21_2017', 'lhe21_2018', 'lhe22_2016', 'lhe22_2017', 'lhe22_2018', 'lhe23_2016', 'lhe23_2017', 'lhe23_2018', 'lhe24_2016', 'lhe24_2017', 'lhe24_2018', 'lhe25_2016', 'lhe25_2017', 'lhe25_2018', 'lhe26_2016', 'lhe26_2017', 'lhe26_2018', 'lhe27_2016', 'lhe27_2017', 'lhe27_2018', 'lhe28_2016', 'lhe28_2017', 'lhe28_2018', 'lhe29_2016', 'lhe29_2017', 'lhe29_2018', 'lhe30_2016', 'lhe30_2017', 'lhe30_2018', 'lhe31_2016', 'lhe31_2017', 'lhe31_2018', 'lhe32_2016', 'lhe32_2017', 'lhe32_2018', 'lhe33_2016', 'lhe33_2017', 'lhe33_2018', 'lhe34_2016', 'lhe34_2017', 'lhe34_2018', 'lhe35_2016', 'lhe35_2017', 'lhe35_2018', 'lhe36_2016', 'lhe36_2017', 'lhe36_2018', 'lhe37_2016', 'lhe37_2017', 'lhe37_2018', 'lhe38_2016', 'lhe38_2017', 'lhe38_2018', 'lhe39_2016', 'lhe39_2017', 'lhe39_2018', 'lhe40_2016', 'lhe40_2017', 'lhe40_2018', 'lhe41_2016', 'lhe41_2017', 'lhe41_2018', 'lhe42_2016', 'lhe42_2017', 'lhe42_2018', 'lhe43_2016', 'lhe43_2017', 'lhe43_2018', 'lhe44_2016', 'lhe44_2017', 'lhe44_2018', 'lhe45_2016', 'lhe45_2017', 'lhe45_2018', 'lhe46_2016', 'lhe46_2017', 'lhe46_2018', 'lhe47_2016', 'lhe47_2017', 'lhe47_2018', 'lhe48_2016', 'lhe48_2017', 'lhe48_2018', 'lhe49_2016', 'lhe49_2017', 'lhe49_2018', 'lhe50_2016', 'lhe50_2017', 'lhe50_2018', 'lhe51_2016', 'lhe51_2017', 'lhe51_2018', 'lhe52_2016', 'lhe52_2017', 'lhe52_2018', 'lhe53_2016', 'lhe53_2017', 'lhe53_2018', 'lhe54_2016', 'lhe54_2017', 'lhe54_2018', 'lhe55_2016', 'lhe55_2017', 'lhe55_2018', 'lhe56_2016', 'lhe56_2017', 'lhe56_2018', 'lhe57_2016', 'lhe57_2017', 'lhe57_2018', 'lhe58_2016', 'lhe58_2017', 'lhe58_2018', 'lhe59_2016', 'lhe59_2017', 'lhe59_2018', 'lhe60_2016', 'lhe60_2017', 'lhe60_2018', 'lhe61_2016', 'lhe61_2017', 'lhe61_2018', 'lhe62_2016', 'lhe62_2017', 'lhe62_2018', 'lhe63_2016', 'lhe63_2017', 'lhe63_2018', 'lhe64_2016', 'lhe64_2017', 'lhe64_2018', 'lhe65_2016', 'lhe65_2017', 'lhe65_2018', 'lhe66_2016', 'lhe66_2017', 'lhe66_2018', 'lhe67_2016', 'lhe67_2017', 'lhe67_2018', 'lhe68_2016', 'lhe68_2017', 'lhe68_2018', 'lhe69_2016', 'lhe69_2017', 'lhe69_2018', 'lhe70_2016', 'lhe70_2017', 'lhe70_2018', 'lhe71_2016', 'lhe71_2017', 'lhe71_2018', 'lhe72_2016', 'lhe72_2017', 'lhe72_2018', 'lhe73_2016', 'lhe73_2017', 'lhe73_2018', 'lhe74_2016', 'lhe74_2017', 'lhe74_2018', 'lhe75_2016', 'lhe75_2017', 'lhe75_2018', 'lhe76_2016', 'lhe76_2017', 'lhe76_2018', 'lhe77_2016', 'lhe77_2017', 'lhe77_2018', 'lhe78_2016', 'lhe78_2017', 'lhe78_2018', 'lhe79_2016', 'lhe79_2017', 'lhe79_2018', 'lhe80_2016', 'lhe80_2017', 'lhe80_2018', 'lhe81_2016', 'lhe81_2017', 'lhe81_2018', 'lhe82_2016', 'lhe82_2017', 'lhe82_2018', 'lhe83_2016', 'lhe83_2017', 'lhe83_2018', 'lhe84_2016', 'lhe84_2017', 'lhe84_2018', 'lhe85_2016', 'lhe85_2017', 'lhe85_2018', 'lhe86_2016', 'lhe86_2017', 'lhe86_2018', 'lhe87_2016', 'lhe87_2017', 'lhe87_2018', 'lhe88_2016', 'lhe88_2017', 'lhe88_2018', 'lhe89_2016', 'lhe89_2017', 'lhe89_2018', 'lhe90_2016', 'lhe90_2017', 'lhe90_2018', 'lhe91_2016', 'lhe91_2017', 'lhe91_2018', 'lhe92_2016', 'lhe92_2017', 'lhe92_2018', 'lhe93_2016', 'lhe93_2017', 'lhe93_2018', 'lhe94_2016', 'lhe94_2017', 'lhe94_2018', 'lhe95_2016', 'lhe95_2017', 'lhe95_2018', 'lhe96_2016', 'lhe96_2017', 'lhe96_2018', 'lhe97_2016', 'lhe97_2017', 'lhe97_2018', 'lhe98_2016', 'lhe98_2017', 'lhe98_2018', 'lhe99_2016', 'lhe99_2017', 'lhe99_2018', 'lhe100_2016', 'lhe100_2017', 'lhe100_2018', 'lhe101_2016', 'lhe101_2017', 'lhe101_2018', 'lhe102_2016', 'lhe102_2017', 'lhe102_2018', 'lhe103_2016', 'lhe103_2017', 'lhe103_2018', 'lhe104_2016', 'lhe104_2017', 'lhe104_2018', 'lhe105_2016', 'lhe105_2017', 'lhe105_2018', 'lhe106_2016', 'lhe106_2017', 'lhe106_2018', 'lhe107_2016', 'lhe107_2017', 'lhe107_2018', 'lhe108_2016', 'lhe108_2017', 'lhe108_2018', 'lhe109_2016', 'lhe109_2017', 'lhe109_2018', 'lhe110_2016', 'lhe110_2017', 'lhe110_2018', 'lhe111_2016', 'lhe111_2017', 'lhe111_2018', 'lhe112_2016', 'lhe112_2017', 'lhe112_2018', 'lhe113_2016', 'lhe113_2017', 'lhe113_2018', 'lhe114_2016', 'lhe114_2017', 'lhe114_2018', 'lhe115_2016', 'lhe115_2017', 'lhe115_2018', 'lhe116_2016', 'lhe116_2017', 'lhe116_2018', 'lhe117_2016', 'lhe117_2017', 'lhe117_2018', 'lhe118_2016', 'lhe118_2017', 'lhe118_2018', 'lhe119_2016', 'lhe119_2017', 'lhe119_2018']
