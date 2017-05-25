#!/usr/bin/env python
import numpy as np
import scipy.stats
import sys

try:
    filenames = sys.argv[1:]
except:
    sys.stderr.write("Usage: ./metap_counts.py file1 file2...\n")
    sys.exit(1)

loc_to_data = {} # loc -> pval, counts, frac
PVAL_CUTOFF = 0.01

for fname in filenames:
    with open(fname, "r") as f:
        for line in f:
            items = line.strip().split()
            pos = int(items[1])
            pval = float(items[6])
            frac = float(items[5])
            counts = items[4]
            if pos not in loc_to_data.keys(): loc_to_data[pos] = {"pval": [], "counts": [], "fracs": []}
            if frac == 0 and pos in [6941625,6942330,6942546]:
                loc_to_data[pos]["pval"].append(None)
                loc_to_data[pos]["counts"].append(None)
                loc_to_data[pos]["fracs"].append(None)
            else:
                loc_to_data[pos]["pval"].append(pval)
                loc_to_data[pos]["counts"].append(counts)
                loc_to_data[pos]["fracs"].append(frac)

def GetMetaP(pvals):
    pvals = [item for item in pvals if item is not None]
    x = -2*sum(np.log(np.array(pvals)))
    df = 2*len(pvals)
    return 1 - scipy.stats.chi2.cdf(x, df)

datanames = [item.split("_")[0] for item in filenames]
if "input" in filenames[0]: mark = "input"
else: mark = filenames[0].split("_")[2]
numtests = len([loc for loc in loc_to_data if len(loc_to_data[loc]["pval"]) == len(datanames)])

sys.stdout.write("\t".join(map(str, ["chrom","pos","mark"]+map(lambda x: x+"_counts", datanames) + \
                                   map(lambda x: x+"_pvals", datanames) + ["metap", "signif"]))+"\n")
for loc in loc_to_data:
    signif = False
    samedir = False
    if len(loc_to_data[loc]["pval"]) != len(datanames): continue
    metap = GetMetaP(loc_to_data[loc]["pval"])
    directions = [item>0.5 for item in loc_to_data[loc]["fracs"]]
    if directions.count(True) == len(directions) or directions.count(False) == len(directions):
        samedir = True
    if metap*numtests <= PVAL_CUTOFF and samedir: signif = True
    sys.stdout.write("\t".join(map(str, ["chr17", loc, mark] + \
                                       loc_to_data[loc]["counts"] + \
                                       loc_to_data[loc]["pval"] + \
                                       [metap, signif]))+"\n")


