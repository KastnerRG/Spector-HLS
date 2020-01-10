#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
import numpy as np
import xml.etree.ElementTree as ET

KNOB_MAT_SIZE = [32] # 0
KNOB_UNROLL_LMM = [i for i in range(1,16)] # 1

KNOB_UNROLL_L1  = [i for i in range(1,4)] # 2
KNOB_UNROLL_L2  = [i for i in range(1,4)] # 3
KNOB_UNROLL_L3  = [i for i in range(1,4)] # 4
B=[0]
I=[1]
KNOB_DATA_DIV = [True, False] # True for interleave, false for block # 5
KNOB_DATA_INTERLEAVE = [1, 2] # 6
KNOB_DATA_BLOCK = [1024,512,256,128,64,32,16] # 7

blockCombinations = list(itertools.product(
    KNOB_MAT_SIZE, #0
    KNOB_UNROLL_LMM, #1
    KNOB_UNROLL_L1, #2
    KNOB_UNROLL_L2, #3
    KNOB_UNROLL_L3, #4
    B, #5
    KNOB_DATA_BLOCK #6
    ))

interleaveCombinations = list(itertools.product(
    KNOB_MAT_SIZE, #0
    KNOB_UNROLL_LMM, #1
    KNOB_UNROLL_L1, #2
    KNOB_UNROLL_L2, #3
    KNOB_UNROLL_L3, #4
    I, #5
    KNOB_DATA_INTERLEAVE #6
    ))

#print("HELLO")
finalCombinations = blockCombinations + interleaveCombinations

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
    f.close()

    f=open(filename2,'r')
    print(filename2)
    b=f.readlines()
    k=(b[25].split())
    avg_latency=int(k[4])
    f.close()
    
    throughput="{0:.4f}".format(((int(avg_latency)*float(est_clk_period))/1000000000))
    #resources       = parse_resources(resources_node)
    #avail_resources = parse_resources(avail_resources_node)

    #resources_util = np.divide(resources, avail_resources)*100
    #for i in range(4):
        #resources_util[i]="{0:.2f}".format(resources_util[i])
    return slices,throughput


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

    file1=open('catapult_matmul.csv','w')
    file1.write("n"+","+"knob_KNOB_MAT_SIZE"+","+"knob_KNOB_UNROLL_LMM"+","+"knob_KNOB_UNROLL_L1"+","+"knob_KNOB_UNROLL_L2"+","+"knob_KNOB_UNROLL_L3"+","+"knob_I_B"+","+"knob_KNOB_DATA_BLOCK_INTERLEAVE"+","+"obj1"+","+"obj2"+"\n")
    for d in sorted(glob.glob('impl_reports/matmul_export*.xml')):
        m = re.search('matmul_export(\d+)', d)
        num = m.group(1)
        synth_path=os.path.join('syn_reports/cycle'+num+'.rpt')
        d2=os.path.join('impl_reports/matmul_utilization_routed'+num+'.rpt')
        slices,lat=parse_xml(d,synth_path,d2)
        file1.write(num+",")
        for j in range(7):
            file1.write(str(finalCombinations[int(num)][j])+",")
        file1.write(str(lat)+","+str(slices)+"\n")
    file1.close()
if __name__ == "__main__":
    main()
        
