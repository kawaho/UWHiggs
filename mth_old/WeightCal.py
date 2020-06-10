import pprint
#import json
import glob
from FinalStateAnalysis.MetaData.data_views import extract_sample, read_lumi
datalumi = 59261.706
lumifiles = []
lumifiles.extend(glob.glob('inputs/MC2018_Dec/*.lumicalc.sum'))
print(lumifiles)
weights = dict((x, datalumi/read_lumi(x)) for x in lumifiles)
pprint.pprint(weights)
#print(json.dumps(weights, indent=4, sort_keys=True))
