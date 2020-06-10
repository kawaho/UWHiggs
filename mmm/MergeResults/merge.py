import os
rootfiles = []
script = open("merge.sh", "w")
for files in os.listdir("../results/FakeData2018/AnalyzeMMM50/"):
  rootfiles.append(files)
for rootfile in rootfiles:
  Egammafile =  rootfile.replace("SingleMuon", "EGamma")
  Muonfile = "../results/FakeData2018/AnalyzeMMM50/" + rootfile
  Egammafile = "../../eem/results/FakeData2018_ee/AnalyzeEEM50/" + Egammafile
  script.write("hadd " + rootfile + " " + Egammafile + " " + Muonfile +"\n")

