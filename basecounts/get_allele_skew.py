#!/usr/bin/env python

import scipy.stats
import sys

try:
    infile = sys.argv[1]
except:
    sys.stderr.write("Usage: ./get_allele_skew.py <infile>\n")
    sys.exit(1)

if infile == "-":
    f = sys.stdin
else: f = open(infile, "r")

line = f.readline()
while line != "":
    items = line.strip().split()
    chrom = items[0]
    pos = items[1]
    ref = items[4]
    alt = items[5]
    bases = items[3]
    ref_count = bases.upper().count(ref) + bases.upper().count(".") + bases.upper().count(",")
    alt_count = bases.upper().count(alt)
    binom_p = scipy.stats.binom_test(alt_count, n=alt_count+ref_count, p=0.5)
    if ref_count + alt_count > 0:
        frac = alt_count*1.0/(ref_count+alt_count)
    else: frac = 0
    sys.stdout.write("\t".join(map(str, [chrom, pos, ref, alt, "%s,%s"%(ref_count, alt_count), frac, binom_p]))+"\n")
    line = f.readline()
