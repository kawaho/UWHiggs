import ROOT
f = ROOT.TFile("try1.root")
h = f.Get("sen")
max_ = {}
max_v = 999999
for i in range(h.GetNbinsX()+1):
  for j in range(h.GetNbinsY()+1):
    string = str(i)+'/'+str(j)
    max_[string] = h.GetBinContent(i,j)
    if h.GetBinContent(i,j) < max_v and h.GetBinContent(i,j) !=0:
      max_v = h.GetBinContent(i,j) 

print h.GetMaximum()
print max_v
print max_
