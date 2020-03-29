#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
import numpy as np
import xml.etree.ElementTree as ET


no_size = [16, 256, 1024, 2048, 4096, 8192]
outer_unroll = [1,2,3,4]
inner_unroll1 = [1,2,3,4]
inner_unroll2 = [1,2,3,4]
merge_unroll = [1,2,3,4]
array_part = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192]
B=[0]
blockCombinations = list(itertools.product(
    no_size, #0
    outer_unroll, #1
    inner_unroll1, #2
    inner_unroll2, #3
    merge_unroll, #4
    array_part, #5
    B #6
    ))

# -----------------------------------------------------

def removeCombinations(combs):

    finalList = []

    for c in combs:
        copyit = True
        if c[0] % c[5] != 0:
            copyit = False
        if c[0] / c[5] > 128:
            copyit = False

        if copyit:
            finalList.append(c)

    return finalList

finalCombinations = removeCombinations(blockCombinations)
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
    #resources       = parse_resources(resources_node)
    #avail_resources = parse_resources(avail_resources_node)

    #resources_util = np.divide(resources, avail_resources)*100
    #for i in range(4):
        #resources_util[i]="{0:.2f}".format(resources_util[i])
    return slices,throughput,lut,ff,dsp,bram




def main():

    file1=open('catapult_mergesort_latency.csv','w')
    file1.write("n"+","+"knob_no_size"+","+"knob_outer_unroll"+","+"knob_inner_unroll1"+","+"knob_inner_unroll2"+","+"knob_merge_unroll"+","+"knob_array_part"+","+"knob_I_B"+","+"obj1"+","+"obj2"+","+"lut"+","+"ff"+","+"dsp"+","+"bram"+"\n")
    for d in sorted(glob.glob('impl_reports/timing_summary_routed*.rpt')):
        m = re.search('timing_summary_routed(\d+)', d)
        num = m.group(1)
        synth_path=os.path.join('syn_reports/cycle'+num+'.rpt')
        d2=os.path.join('impl_reports/utilization_placed'+num+'.rpt')
        slices,lat,lut,ff,dsp,bram=parse_xml(d,synth_path,d2)
        if slices==0:
            pass
        else:
            file1.write(num+",")
            for j in range(7):
                file1.write(str(finalCombinations[int(num)][j])+",")
            file1.write(str(lat)+","+str(slices)+","+str(lut)+","+str(ff)+","+str(dsp)+","+str(bram)+"\n")
    file1.close()
if __name__ == "__main__":
    main()
        
