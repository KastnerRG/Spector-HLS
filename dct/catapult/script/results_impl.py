#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
import numpy as np
import xml.etree.ElementTree as ET

B = [0]


blockdim_x =[1,2,4,8]
blockdim_y =[1,2,4,8]
unroll_dct=[1,2,4,8]
unroll_width=[1,2,4,8]
unroll_height=[1,2,4,8]
array_partition1=[1,2,4,8]
array_partition2=[4194304,2097152,1048576,524288]

blockCombinations = list(itertools.product(
    blockdim_x, #0
    blockdim_y, #1
    unroll_dct, #2
    unroll_width, #3
    unroll_height, #4
    array_partition1, #5
    array_partition2,#6
    B #7
    ))

def parse_resources(resources_node):
    tags = ['BRAM_18K','DSP48E','FF','LUT']
    resources = [ resources_node.find(t).text for t in tags ]
    return list(map(int, resources))


def parse_xml(filename1,filename2,filename3):
    tree = ET.parse(filename1)
    root = tree.getroot()

    #resources_node       = root.find('AreaEstimates/Resources')
    #avail_resources_node = root.find('AreaEstimates/AvailableResources')
    est_clk_period = root.find('TimingReport/AchievedClockPeriod').text
    f=open(filename3,'r')
    a=f.readlines()
    t=(a[76].split('|'))
    if t[1].strip('  ')=='CLB':
        slices=int(t[2].strip(' '))
    t=(a[79].split('|'))
    if t[1].strip('  ')=='LUT as Logic':
        lut=int(t[2].strip(' '))
    t=(a[86].split('|'))
    if t[1].strip('  ')=='CLB Registers':
        ff=int(t[2].strip(' '))
    t=(a[116].split('|'))
    print(t)
    if t[1].strip('  ')=='DSPs':
        dsp=int(t[2].strip(' '))
    t=(a[102].split('|'))
    if t[1].strip('  ')=='Block RAM Tile':
        bram=int(t[2].strip(' '))

    f.close()

    f=open(filename2,'r')
    print(filename2)
    b=f.readlines()
    k=(b[23].split())
    print("Latency: {}".format(k[4]))
    avg_latency=int(k[4])
    f.close()
    
    throughput="{0:.6f}".format(((int(avg_latency)*float(est_clk_period))/1000000000))
    #resources       = parse_resources(resources_node)
    #avail_resources = parse_resources(avail_resources_node)

    #resources_util = np.divide(resources, avail_resources)*100
    #for i in range(4):
        #resources_util[i]="{0:.2f}".format(resources_util[i])
    return slices,throughput,lut,ff,dsp,bram


def removeCombinations(combs):

    finalList = []

    for c in combs:
        copyit = True
        if c[5] == 1 and c[6] != 4194304:
            copyit = False
        if c[5] == 2 and c[6] != 2097152:
            copyit = False
        if c[5] == 4 and c[6] != 1048576:
            copyit = False
        if c[5] == 8 and c[6] != 54288:
            copyit = False
        if copyit:
            finalList.append(c)
#
    return finalList

finalCombinations = removeCombinations(blockCombinations)

def main():

    file1=open('catapult_dct_latency.csv','w')
    file1.write("n"+","+"knob_blockdim_x"+","+"knob_blockdim_y"+","+"knob_unroll_dct"+","+"knob_unroll_width"+","+"knob_unroll_height"+","+"knob_array_partition1"+","+"knob_array_partition2"+","+"knob_I_B"+","+"obj1"+","+"obj2"+","+"lut"+","+"ff"+","+"dsp"+","+"bram"+"\n")
    for d in sorted(glob.glob('impl_reports/dct_export*.xml')):
        m = re.search('dct_export(\d+)', d)
        num = m.group(1)
        synth_path=os.path.join('syn_reports/cycle'+num+'.rpt')
        d2=os.path.join('impl_reports/dct_utilization_routed'+num+'.rpt')
        slices,lat,lut,ff,dsp,bram = parse_xml(d, synth_path, d2)
        if slices==0:
            pass
        else:
            file1.write(num+",")
            for j in range(8):
                file1.write(str(finalCombinations[int(num)][j])+",")
            file1.write(str(lat)+","+str(slices)+","+str(lut)+","+str(ff)+","+str(dsp)+","+str(bram)+"\n")
    file1.close()
if __name__ == "__main__":
    main()
        
