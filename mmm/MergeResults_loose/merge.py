import os
rootfiles = []
script = open("merge.sh", "w")
for files in os.listdir("../results/FakeData2018/AnalyzeMMM_loose/"):
  rootfiles.append(files)
for rootfile in rootfiles:
  Egammafile =  rootfile.replace("SingleMuon", "EGamma")
  Muonfile = "../results/FakeData2018/AnalyzeMMM_loose/" + rootfile
  Egammafile = "../../eem/results/FakeData2018_ee/AnalyzeEEM_loose/" + Egammafile
  script.write("hadd " + rootfile + " " + Egammafile + " " + Muonfile +"\n")

