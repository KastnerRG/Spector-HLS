#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
import numpy as np
import xml.etree.ElementTree as ET

# ***************************************************************************
# Knobs
# ***********

B=[0]
KNOB_MAT_SIZE = [1024] # 0
SUBDIM_X =[1,2,4,8,16] # 1 
SUBDIM_Y =[1,2,4,8,16] # 2
KNOB_UNROLL_L1  = [1, 2, 4, 8] # 3
KNOB_UNROLL_L2  = [1, 2, 4, 8] # 4
KNOB_UNROLL_L3  = [1, 2, 4, 8] # 5
KNOB_DATA_BLOCK = [1024,512,256,128,64,32] # 6

blockCombinations = list(itertools.product(
    KNOB_MAT_SIZE, #0
    KNOB_UNROLL_L1, #1
    KNOB_UNROLL_L2, #2
    KNOB_UNROLL_L3, #3
    SUBDIM_X, #4
    SUBDIM_Y, #5
    B, #6
    KNOB_DATA_BLOCK #7
    ))

finalCombinations = blockCombinations

def parse_resources(resources_node):
    tags = ['BRAM_18K','DSP48E','FF','LUT']
    resources = [ resources_node.find(t).text for t in tags ]
    return list(map(int, resources))


def parse_xml(filename1,filename2,filename3):
    f=open(filename1,'r')
    a=f.readlines()
    t=str(a[129].strip(' '))
    t=float(t[:5])
    est_clk_period="{0:.3f}".format(float(10-t))

    f.close()
    
    f=open(filename3,'r')
    a=f.readlines()
    t=(a[76].split('|'))
    if t[1].strip('  ')=='CLB':
        slices=int(t[2].strip(' '))
    t=(a[79].split('|'))
    if t[1].strip('  ')=='LUT as Logic':
        lut=int(t[2].strip(' '))
    t=(a[116].split('|'))
    if t[1].strip('  ')=='DSPs':
        dsp=int(t[2].strip(' '))
    t=(a[86].split('|'))
    if t[1].strip('  ')=='CLB Registers':
        ff=int(t[2].strip(' '))
    t=(a[102].split('|'))
    if t[1].strip('  ')=='Block RAM Tile':
        bram=int(t[2].strip(' '))

    f.close()

    f=open(filename2,'r')
    print(filename2)
    b=f.readlines()
    k=(b[23].split())
    avg_latency=int(k[4])
    f.close()
    
    throughput="{0:.6f}".format(((int(avg_latency)*float(est_clk_period))/1000000000))
    throughput=1.0/float(throughput)
    #resources       = parse_resources(resources_node)
    #avail_resources = parse_resources(avail_resources_node)

    #resources_util = np.divide(resources, avail_resources)*100
    #for i in range(4):
        #resources_util[i]="{0:.2f}".format(resources_util[i])
    return slices,throughput,lut,ff,dsp,bram


def main():

    
    file1=open('catapult_mergesort_area_violin.csv','w')
    file1.write("Parameter"+","+"Throughput_Value"+","+"Tool"+","+"Resource_Type"+","+"Resource_Value"+","+"Flow"+"\n")
    for d in sorted(glob.glob('impl_reports/timing_summary_routed*.rpt')):
        m = re.search('timing_summary_routed(\d+)', d)
        num = m.group(1)
        print(num)
        synth_path=os.path.join('syn_reports/cycle'+num+'.rpt')
        d2=os.path.join('impl_reports/utilization_placed'+num+'.rpt')
        try:
            slices,lat,lut,ff,dsp,bram = parse_xml(d, synth_path, d2)
            if slices==0:
                pass
            else:
                file1.write("Throughput"+","+str(lat)+","+"catapult"+","+"CLB"+","+str(slices)+","+"area"+"\n")
                file1.write("Throughput"+","+str(lat)+","+"catapult"+","+"LUT"+","+str(lut)+","+"area"+"\n")
                file1.write("Throughput"+","+str(lat)+","+"catapult"+","+"FF"+","+str(ff)+","+"area"+"\n")
                file1.write("Throughput"+","+str(lat)+","+"catapult"+","+"DSP"+","+str(dsp)+","+"area"+"\n")
                file1.write("Throughput"+","+str(lat)+","+"catapult"+","+"BRAM"+","+str(bram)+","+"area"+"\n")
        except:
            pass
    file1.close()
if __name__ == "__main__":
    main()
        
