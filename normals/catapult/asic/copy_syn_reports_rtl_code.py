#!/usr/bin/env python

import os, sys
import glob
import shutil
import re

syn_dir = 'syn_reports'
try:
    os.mkdir(syn_dir)
except:
    pass

for d in sorted(glob.glob('solutions/normals*')):
    m = re.search('normals(\d+)', d)
    num = m.group(1)
    try:
        for f in glob.glob(d + "/Catapult/normals.v1/cycle.rpt"):
            basename, ext = os.path.splitext(os.path.basename(f))
            shutil.copy(f, os.path.join(syn_dir,basename+num+ext))
    except:
        print("Error in #" + num)
    try:
        for f in glob.glob(d + "/Catapult/normals.v1/concat_rtl.v.or.log"):
            basename, ext = os.path.splitext(os.path.basename(f))
            shutil.copy(f, os.path.join(syn_dir,basename+num+ext))
    except:
        pass


