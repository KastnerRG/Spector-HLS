#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
import numpy as np
import xml.etree.ElementTree as ET

B=[0]
UNROLL_F = [2, 4, 8, 16, 32] #0
outer_unroll = [1, 2, 3] #1
inner_unroll1 = [1, 2, 3, 4] #2
inner_unroll2 = [1, 2, 3, 4] #3
array_part1 = [512, 256, 128, 64, 32] #4
array_part2 = [1, 2, 4, 8, 16, 32] #5

blockCombinations = list(itertools.product(
    UNROLL_F, #0
    outer_unroll, #1
    inner_unroll1, #2
    inner_unroll2, #3
    array_part1, #4
    array_part2, #5
    B#6
    ))

#print("HELLO")
finalCombinations = blockCombinations 

def parse_resources(resources_node):
    tags = ['BRAM_18K','DSP48E','FF','LUT']
    resources = [ resources_node.find(t).text for t in tags ]
    return list(map(int, resources))


def parse_xml(filename1,filename2):

    with open(filename2, 'r') as f:
        last_line = f.readlines()[-1]
        last_line=last_line.split()
        print(last_line)
        area=last_line[5].split('=')[1]
        slack=last_line[8].split('=')[1]

    f.close()
    est_clk_period=10-float(slack)

    f=open(filename1,'r')
    print(filename1)
    b=f.readlines()
    k=(b[24].split())
    print(k)
    avg_latency=int(k[4])
    f.close()
    
    throughput="{0:.6f}".format(((int(avg_latency)*float(est_clk_period))/1000000000))
    #resources       = parse_resources(resources_node)
    #avail_resources = parse_resources(avail_resources_node)

    #resources_util = np.divide(resources, avail_resources)*100
    #for i in range(4):
        #resources_util[i]="{0:.2f}".format(resources_util[i])
    return area,throughput

def removeCombinations(combs):

    finalList = []

    for c in combs:
        copyit = True
        if c[5] > c[0]:
            copyit = False

        if copyit:
            finalList.append(c)

    return finalList


finalCombinations = removeCombinations(finalCombinations) 

def main():

    file1=open('asic_catapult_spmv_latency.csv','w')
    file1.write("n"+","+"knob_UNROLL_F"+","+"knob_outer_unroll"+","+"knob_inner_unroll1"+","+"knob_inner_unroll2"+","+"knob_array_part1"+","+"knob_array_part2"+","+"knob_I_B"+","+"Latency"+","+"Area"+"\n")
    for d in sorted(glob.glob('syn_reports/cycle*.rpt')):
        m = re.search('cycle(\d+)', d)
        num = m.group(1)
        log=os.path.join('syn_reports/concat_rtl.v.or'+num+'.log')
        if os.path.isfile(log):
            area,lat=parse_xml(d,log)
            file1.write(num+",")
            for j in range(6):
                file1.write(str(finalCombinations[int(num)][j])+",")
            file1.write(str(lat)+","+str(area)+"\n")
    file1.close()
if __name__ == "__main__":
    main()
        