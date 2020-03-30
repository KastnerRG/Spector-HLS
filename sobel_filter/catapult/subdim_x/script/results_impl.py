#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
import numpy as np
import xml.etree.ElementTree as ET

dimx_part_factor = [2073600 , 1036800 , 518400 , 259200 , 129600 , 64800 , 32400 , 16200 , 8100 , 4050 , 2025,414720,207360,138240,103680,82944]
unroll_factor = [1,2,3,4,5,6,7,8]
subdim_x = [1,2,4,8,16,32]
B = [0]

blockCombinations = list(itertools.product(
    dimx_part_factor, #0
    unroll_factor, #2
    subdim_x, #3
    B
    ))


finalCombinations = blockCombinations 


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
    avg_latency=int(k[4])
    f.close()
    
    throughput="{0:.4f}".format(((int(avg_latency)*float(est_clk_period))/1000000000))
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

        if c[4] > c[2]: copyit = False
        if c[5] > c[3]: copyit = False
        if c[6] == 1 and (c[3] > 1 or c[2] == 1): copyit = False
        if c[6] == 1 and c[4] > 1: copyit = False
        if c[2] * c[3] > 1 and c[1] == 256 and c[0] > 4: copyit = False

        if copyit:
            finalList.append(c)

    return finalList


def main():

    file1=open('catapult_sobelx.csv','w')
    file1.write("n"+","+"knob_dimx_part_factor"+","+"knob_unroll_factor"+","+"knob_subdim_x"+","+"knob_I_B"+","+"obj1"+","+"obj2"+","+"lut"+","+"ff"+","+"dsp"+","+"bram"+"\n")
    for d in sorted(glob.glob('impl_reports/sobelx_export*.xml')):
        m = re.search('sobelx_export(\d+)', d)
        num = m.group(1)
        synth_path=os.path.join('syn_reports/cycle'+num+'.rpt')
        d2=os.path.join('impl_reports/sobelx_utilization_routed'+num+'.rpt')
        slices,lat,lut,ff,dsp,bram = parse_xml(d, synth_path, d2)
        if slices==0:
            pass
        else:
            file1.write(num+",")
            for j in range(4):
                file1.write(str(finalCombinations[int(num)][j])+",")
            file1.write(str(lat)+","+str(slices)+","+str(lut)+","+str(ff)+","+str(dsp)+","+str(bram)+"\n")
    file1.close()
if __name__ == "__main__":
    main()
        
