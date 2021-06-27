class mcWeights:
    def __init__(self, target, dataset='SingleMu'):
        self.is_data = target.startswith('data_')
        self.is_mc = not self.is_data
        self.sample = target.replace('.root','')
        self.is_DY = bool('DY' in target) and not bool('DYJetsToLL_M-10to50' in target)
        f = open(ENV['CMSSW_BASE'] + "/UWHiggs2017/mm/weights.json", "r")
        self.weight_dict = json.load(f)[dataset]

    def lumiWeight(self, weight):
      return weight*self.weight_dict[self.sample]
