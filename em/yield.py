import os
import glob
from ROOT import TFile
files = []
files.extend(glob.glob('results/Data2016JEC/AnalyzeEMYield/*.root'))
numofdata = 0
for f in files:
  tf = TFile(f)
  h = tf.Get('TightOS/e_m_Mass')
  hgg = tf.Get('TightOSgg/e_m_Mass')
  hvbf = tf.Get('TightOSvbf/e_m_Mass')
  if 'root' in f:
    events = h.Integral()
    eventsgg = hgg.Integral()
    eventsvbf = hvbf.Integral()
    print f, events#, eventsgg, eventsvbf



