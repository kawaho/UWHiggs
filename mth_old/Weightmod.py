import glob
lumifiles = []
lumifiles.extend(glob.glob('inputs/MC2018_Dec/*.lumicalc.sum'))
for x in lumifiles:
  with open(x, 'w') as f:
    f.write("59261.706")
#print(json.dumps(weights, indent=4, sort_keys=True))
