import xml.etree.ElementTree as ET
import math
root = ET.parse('dataset/weights/TMVA_Opt_Category_Cuts0.weights.xml').getroot()
for cat in root.findall('Weights/SubMethod'):
  print cat.attrib
  s_max = -1
  for bin_ in cat.findall('Weights/Bin'):
    effs = float(bin_.attrib.get('effS'))
    effb = float(bin_.attrib.get('effB'))
    if float(bin_.attrib.get('effB')) != 0:
      s = effs/math.sqrt(effb)
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
  print "effS: %s"% effs_max, " effB: %s" % effb_max
  print "Max Sensitivity: %f" % s_max
  print "mPt cut: %s, ePt cut: %s, MET cut: %s \n" % (round(mPtcut), round(ePtcut), round(metcut))
