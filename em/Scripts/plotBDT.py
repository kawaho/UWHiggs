import BasePlotterDY
import os
import Lists
import glob

jobid = os.environ['jobid']
basePlotter = BasePlotterDY.BasePlotterDY()

for x in Lists.mc_samples:
    print x
    Lists.files.extend(glob.glob('../results/%s/AnalyzeEMValid/%s' % (jobid, x)))
    Lists.lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

for j in Lists.procs:
    s1 = 'TightOS'+j
    s2 = 'TightSS'+j

    s = [s1, s2]

    outputdir = 'plots/%s/AnalyzeEMuValid/' % (jobid)
    if not os.path.exists(outputdir):
        os.makedirs(outputdir)

    plotter = basePlotter.mcInit(Lists.files, Lists.lumifiles, outputdir, s)

    for h in Lists.bdthisto:
        plotter.plot_mc_vs_data('', ['VBF_LFV_HToEMu_M125*', 'GluGlu_LFV_HToEMu_M125*'], h[0], 4, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=2, sort=True, blind_region=False, control=s1, jets=j, year='2017', channel='emu')
        plotter.save(h[0]+j)
