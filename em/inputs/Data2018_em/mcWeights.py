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
        self.is_WW = bool('WW_Tune' in target)
        self.is_WZ = bool('WZ_Tune' in target)
        self.is_ZZ = bool('ZZ_Tune' in target)
        self.is_VV = bool(self.is_WG or self.is_WW or self.is_WZ or self.is_ZZ)
        self.is_EWKWMinus = bool('EWKWMinus' in target)
        self.is_EWKWPlus = bool('EWKWPlus' in target)
        self.is_EWKZToLL = bool('EWKZ2Jets_ZToLL' in target)
        self.is_EWKZToNuNu = bool('EWKZ2Jets_ZToNuNu' in target)
        self.is_EWK = bool(self.is_EWKWMinus or self.is_EWKWPlus or self.is_EWKZToLL or self.is_EWKZToNuNu)
        self.is_ZHTT = bool('ZHToTauTau' in target)
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
            0 : 3.674610690,
            1 : 0.700706995,
            2 : 0.809136440,
            3 : 0.996023913,
            4 : 0.852902341
        }
        self.Wweight = {
            0 : 0.0,
            1 : 12.12546827,
            2 : 7.150271368,
            3 : 4.419363120,
            4 : 3.581266065
        }

    def lumiWeight(self, weight):
        if self.is_DYlow:
            weight = weight*28.3792
        if self.is_WG:
            weight = weight*4.51446
        if self.is_GluGlu:
            weight = weight*0.000677
        if self.is_VBF:
            weight = weight*0.000305
        if self.is_WW:
            weight = weight*(118.7/75.88)*0.575
        if self.is_WZ:
            weight = weight*(51.11/27.57)*0.421
        if self.is_ZZ:
            weight = weight*(16.91/12.14)*0.364
        if self.is_EWKWMinus:
            weight = weight*0.27446
        if self.is_EWKWPlus:
            weight = weight*0.34806
        if self.is_EWKZToLL:
            weight = weight*0.46599
        if self.is_EWKZToNuNu:
            weight = weight*0.20889
        if self.is_ZHTT:
            weight = weight*0.00088
        if self.is_Wminus:
            weight = weight*0.00155
        if self.is_Wplus:
            weight = weight*0.00095
        if self.is_STtantitop:
            weight = weight*0.00096
        if self.is_STttop:
            weight = weight*0.00998
        if self.is_STtWantitop:
            weight = weight*0.01201
        if self.is_STtWtop:
            weight = weight*0.00641
        if self.is_TTTo2L2Nu:
            weight = weight*0.00114
        if self.is_TTToHadronic:
            weight = weight*0.00024
        if self.is_TTToSemiLeptonic:
            weight = weight*0.00038
        if self.is_VBFH:
            weight = weight*0.00121
        if self.is_GluGluH:
            weight = weight*0.00067
        if self.is_VBFHWW:
            weight = weight*0.00131
        if self.is_GluGluHWW:
            weight = weight*0.00272
        return weight

