from ROOT import TFile, TCanvas, TLegend, gStyle, gROOT
import json
import os
gStyle.SetOptStat(False)
gROOT.SetBatch(True)

unc = {'le':{},'b':{},'pu':{},'jetA':{},'jetB':{},'jetE':{},'jetF':{},'jetH':{},'jetR':{},'jr':{},'pf':{},'un':{}}
names = []
colorpool = [1,2,3,4,5,6,7,8,9]
Uncount = 0
bTagcount = 0
fGG = TFile('SignalGG.root')
fVBF = TFile('SignalVBF.root')
h1 = fGG.Get("TightOSggcat3/e_m_Mass")
h2 = fGG.Get("TightOSggcat3/eerUp/e_m_Mass")
#print h1.AndersonDarlingTest(h2)
#print h1.Chi2Test(h2,"WW")
for i in fGG.GetListOfKeys():
  dir_ = i.ReadObj()
#  if not os.path.exists('shape_'+dir_.GetName()):
#    os.makedirs('shape_'+dir_.GetName())
  if dir_.GetName() == 'TightOSvbf':
    for j in dir_.GetListOfKeys():
      dir_2 = j.ReadObj()
      name = dir_2.GetName()
      if name == 'e_m_Mass':
        hnomial = dir_2 #.Rebin(25)
#        hnomial.Scale( 1./hnomial.Integral())
      else:
        names.append(dir_2.GetName())
        h = dir_2.Get('e_m_Mass')  
#        h.Rebin(25) 
#        h.Scale( 1./h.Integral()) 
        if 'ees' in name or 'eer' in name or 'me' in name:
          unc['le'][name] = h
        elif 'bTag' in name:
          unc['b'][name] = h 
        elif 'pu' in name:
          unc['pu'][name] = h
        elif 'JetA' in name:
          unc['jetA'][name] = h
        elif 'JetB' in name:
          unc['jetB'][name] = h
        elif 'JetE' in name:
          unc['jetE'][name] = h
        elif 'JetF' in name:
          unc['jetF'][name] = h
        elif 'JetH' in name:
          unc['jetH'][name] = h
        elif 'JetR' in name:
          unc['jetR'][name] = h
        elif 'JER' in name:
          unc['jr'][name] = h
        elif 'pf' in name:
          unc['pf'][name] = h
        elif 'UnclusteredEn' in name:
          unc['un'][name] = h
for key,c in unc.items():
  canvas = TCanvas('canvas'+key,'canvas',850,800)
  legend = TLegend(0.65, 0.35, .85, .85)
  color = 1
  hnomial.SetLineColor(color)
  hnomial.GetXaxis().SetRangeUser(110, 140)
  legend.AddEntry(hnomial, "Nominal", "l")
  hnomial.Draw('c hist same')
  for key2,c2 in c.items():
    color+=1
    c2.SetLineColor(color)
    c2.GetXaxis().SetRangeUser(110, 140)
    print key2, hnomial.Chi2Test(c2,"WW")
#    print hnomial.AndersonDarlingTest(c2)
    legend.AddEntry(c2, key2, "l")
    c2.Draw('c hist same')
  legend.Draw()
  canvas.SaveAs('shapeA/%s.png'%key)
print len(names)
print json.dumps(names)
