import xml.etree.ElementTree as ET
import math
import ROOT
import sys
root = ET.parse('dataset/weights/TMVA_Opt_Category_Cuts0.weights.xml').getroot()
file = ROOT.TFile('Input/Opt2.root')
tree = file.Get("opttree") 
for catname in root.findall('Weights/SubMethod'):
  cat = int(catname.attrib.get('Index'))
  print "Parsing cat %i" % cat
  s_temp = -1
  for bin_ in catname.findall('Weights/Bin'):
    effs = float(bin_.attrib.get('effS'))
    effb = float(bin_.attrib.get('effB'))
    if (effs < 0.5 or effs*10 % 1 != 0):
      continue
    print "Parsing effs %f" % effs  
    sys.stdout.flush()
    for cut in bin_.findall('Cuts'):
      mPtcut = float(cut.attrib.get('cutMin_0'))
      ePtcut = float(cut.attrib.get('cutMin_1'))
      metcut = float(cut.attrib.get('cutMax_2'))
      n_sig = 0
      n_bkg = 0
      for event in tree:
        if event.cat == cat+1 and event.mPt > mPtcut and event.ePt > ePtcut and event.type1_pfMetEt < metcut:
            if (event.itype == 0):
              n_bkg += event.weight
            else:
              n_sig += event.weight
      if n_bkg == 0:
        continue
      else:
        s = n_sig/math.sqrt(n_bkg)
        if s > s_temp:
          s_temp = s
          n_sig_temp = n_sig
          n_bkg_temp = n_bkg
          effs_temp = effs
          effb_temp = effb
          mPtcut_temp = mPtcut
          ePtcut_temp = ePtcut
          metcut_temp = metcut 
       
  print cat
  print "n_sig: %s" % n_sig_temp, " n_bkg: %s" % n_bkg_temp
  print "effsig: %s" % effs_temp, " effbkg: %s" % effb_temp
  print "Max Sensitivity: %f" % s_temp
  print "ePt cut: %s, mPt cut: %s, MET cut: %s \n" % (round(ePtcut), round(mPtcut), round(metcut))
