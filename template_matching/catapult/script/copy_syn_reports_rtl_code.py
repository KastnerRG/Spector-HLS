#!/usr/bin/env python

import os, sys
import glob
import shutil
import re

syn_dir = 'syn_reports'
rtl='rtl_files'
try:
    os.mkdir(syn_dir)
    os.mkdir(rtl)
except:
    pass

for d in sorted(glob.glob('solutions/template_matching*')):
    m = re.search('template_matching(\d+)', d)
    num = m.group(1)
    try:
        for f in glob.glob(d + "/Catapult/SAD_MATCH.v1/cycle.rpt"):
            basename, ext = os.path.splitext(os.path.basename(f))
            shutil.copy(f, os.path.join(syn_dir,basename+num+ext))
    except:
        print("Error in #" + num)
    try:
        for f in glob.glob(d + "/Catapult/SAD_MATCH.v1/"):
            t=rtl+'/'+m.group(0)+'/'
            if os.path.isfile(f+'rtl.v') and os.path.isfile(f+'concat_rtl.v'):
                os.makedirs(t)
                shutil.copy(f+'rtl.v',t)
                shutil.copy(f+'concat_rtl.v',t)
            else:
                pass
    except:
        pass


