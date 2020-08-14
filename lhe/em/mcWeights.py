class mcWeights:
    def __init__(self, target):
        self.is_data = target.startswith('data_')
        self.is_embed = target.startswith('embedded_')
        self.is_mc = not self.is_data and not self.is_embed
        self.is_DYlow = bool('DYJetsToLL_M-10to50' in target)
        self.is_DY = bool('DY' in target) and not self.is_DYlow
        self.is_GluGlu = bool('GluGlu_LFV' in target)
        self.is_VBF = bool('VBF_LFV' in target)
        self.is_W = bool('JetsToLNu' in target)
        self.is_WG = bool('WGToLNuG' in target)
        self.is_WW = bool('WW_TuneCP5' in target)
        self.is_WZ = bool('WZ_TuneCP5' in target)
        self.is_ZZ = bool('ZZ_TuneCP5' in target)
        self.is_EWKWMinus = bool('EWKWMinus' in target)
        self.is_EWKWPlus = bool('EWKWPlus' in target)
        self.is_EWKZToLL = bool('EWKZ2Jets_ZToLL' in target)
        self.is_EWKZToNuNu = bool('EWKZ2Jets_ZToNuNu' in target)
        self.is_EWK = bool(self.is_EWKWMinus or self.is_EWKWPlus or self.is_EWKZToLL or self.is_EWKZToNuNu)
        self.is_ZHTT = bool('ZHToTauTau' in target)
        self.is_ttH = bool('ttHToTauTau' in target)
        self.is_Wminus = bool('Wminus' in target)
        self.is_Wplus = bool('Wplus' in target)
        self.is_STtantitop = bool('ST_t-channel_antitop' in target)
        self.is_STttop = bool('ST_t-channel_top' in target)
        self.is_STtWantitop = bool('ST_tW_antitop' in target)
        self.is_STtWtop = bool('ST_tW_top' in target)
        self.is_TTTo2L2Nu = bool('TTTo2L2Nu' in target)
        self.is_TTToHadronic = bool('TTToHadronic' in target)
        self.is_TTToSemiLeptonic = bool('TTToSemiLeptonic' in target)
        self.is_TT = bool(self.is_TTTo2L2Nu or self.is_TTToHadronic or self.is_TTToSemiLeptonic)
        self.is_ST = bool(self.is_STtantitop or self.is_STttop or self.is_STtWantitop or self.is_STtWtop)
        self.is_VBFH = bool('VBFHToTauTau' in target)
        self.is_GluGluH = bool('GluGluHToTauTau' in target)
        self.is_VBFHWW = bool('VBFHToWW' in target)
        self.is_GluGluHWW = bool('GluGluHToWW' in target)
        self.is_recoilC = bool(self.is_DYlow or self.is_DY or self.is_GluGlu or self.is_VBF or self.is_EWK or self.is_VBFH or self.is_GluGluH or self.is_VBFHWW or self.is_GluGluHWW or self.is_W)
        self.MetCorrection = True
        self.DYweight = {
            0 : 2.666650438/1.165,
            1 : 0.827051318,
            2 : 0.964991189,
            3 : 1.719209702,
            4 : 0.992201532
        } 
        self.Wweight = {
            0 : 0.0,
            1 : 7.175098403,
            2 : 4.20230839,
            3 : 2.454717213,
            4 : 2.391121278
        } 

    def lumiWeight(self, target, weight): 
        if self.is_DYlow:
            weight = weight*22.95581643
        if self.is_WG:
            weight = weight*3.094
        if self.is_GluGlu:
            weight = weight*0.000501
        if self.is_VBF:
            weight = weight*0.000208
        if self.is_WW:
            weight = weight*0.638
        if self.is_WZ:
            weight = weight*0.503
        if self.is_ZZ:
            weight = weight*0.355
        if self.is_EWKWMinus:
            weight = weight*0.191
        if self.is_EWKWPlus:
            weight = weight*0.241
        if self.is_EWKZToLL:
            weight = weight*0.317
        if self.is_EWKZToNuNu:
            weight = weight*0.140
        if self.is_ZHTT:
            weight = weight*0.0006435
        if self.is_ttH:
            weight = weight*0.001276
        if self.is_Wminus:
            weight = weight*0.000786
        if self.is_Wplus:
            weight = weight*0.0007196
        if self.is_STtantitop:
            weight = weight*0.9217
        if self.is_STttop:
            weight = weight*0.9517
        if self.is_STtWantitop:
            weight = weight*0.005576
        if self.is_STtWtop:
            weight = weight*0.005565
        if self.is_TTTo2L2Nu:
            weight = weight*0.009427
        if self.is_TTToHadronic:
            weight = weight*0.3955
        if self.is_TTToSemiLeptonic:
            weight = weight*0.0012
        if self.is_VBFH:
            weight = weight*0.0008638
        if self.is_GluGluH:
            weight = weight*0.002032
        if self.is_VBFHWW:
            weight = weight*0.001853
        if self.is_GluGluHWW:
            weight = weight*0.001677
        return weight
