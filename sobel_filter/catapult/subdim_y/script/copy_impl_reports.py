#!/usr/bin/env python

import os, sys
import glob
import shutil
import re

impl_dir = 'impl_reports'

try:
    os.mkdir(impl_dir)
except:
    pass

for d in sorted(glob.glob('impl/sobel_subdimy*')):
    m = re.search('sobel_subdimy(\d+)', d)
    num = m.group(1)
    try:
        for f in glob.glob(d + "/report/verilog/*.xml"):
            basename, ext = os.path.splitext(os.path.basename(f))
            shutil.copy(f, os.path.join(impl_dir, basename + num + ext))
    except:
        print("Error in #" + num)
    try:
        for f in glob.glob(d+"/sobely_ip/sobely_utilization_routed.rpt"):
            basename, ext = os.path.splitext(os.path.basename(f))
            shutil.copy(f, os.path.join(impl_dir, basename + num + ext))
    except:
        print("Error in #"+num)
            
