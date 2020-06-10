import os
rootfiles = []
script = open("merge.sh", "w")
for files in os.listdir("../results/FakeData2018_ee/AnalyzeEEE/"):
  rootfiles.append(files)
for rootfile in rootfiles:
  Muonfile =  rootfile.replace("EGamma", "SingleMuon")
  Egammafile = "../results/FakeData2018_ee/AnalyzeEEE/" + rootfile
  Muonfile = "../../mme/results/FakeData2018/AnalyzeMME/" + Muonfile
  script.write("hadd " + rootfile + " " + Egammafile + " " + Muonfile +"\n")

