#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
import numpy as np
import xml.etree.ElementTree as ET


KNOB_MAT_SIZE = [1024] # 0
SUBDIM_X =[1,2,4,8,16] # 1 
SUBDIM_Y =[1,2,4,8,16] # 2
KNOB_UNROLL_L1  = [1, 2, 4, 8] # 3
KNOB_UNROLL_L2  = [1, 2, 4, 8] # 4
KNOB_UNROLL_L3  = [1, 2, 4, 8] # 5
KNOB_DATA_BLOCK = [1048576,524288,262144,131072,65536,32768] # 6
B=[0]

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


finalCombinations=blockCombinations


def parse_resources(resources_node):
    tags = ['BRAM_18K','DSP48E','FF','LUT']
    resources = [ resources_node.find(t).text for t in tags ]
    return list(map(int, resources))


def parse_xml(filename1,filename2):

    global ff 
    with open(filename2, 'r') as f:
        a=f.readlines()
    f.close() 
    li=[x.split() for x in a]
    for i in range(len(li)):
        try:
            if li[i][0]=='Number' and li[i][2]=='total':
                ff=li[i][5]
        except:
            pass
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
    return area,throughput,ff

def removeCombinations(combs):

    finalList = []

    for c in combs:
        copyit = True
        if c[3] > c[5]:
            copyit = False

        if copyit:
            finalList.append(c)

    return finalList

finalCombinations=removeCombinations(finalCombinations)

def main():

    file1=open('asic_catapult_matmul_area.csv','w')
    file1.write("n"+","+"knob_KNOB_MAT_SIZE"+","+"knob_KNOB_UNROLL_L1"+","+"knob_KNOB_UNROLL_L2"+","+"knob_KNOB_UNROLL_L3"+","+"SUBDIM_X"+","+"SUBDIM_Y"+","+"knob_I_B"+","+"knob_KNOB_DATA_BLOCK_INTERLEAVE"+","+"Latency"+","+"Area"+","+"FF"+"\n")
    for d in sorted(glob.glob('syn_reports/cycle*.rpt')):
        m = re.search('cycle(\d+)', d)
        num = m.group(1)
        print(num)
        log=os.path.join('syn_reports/concat_rtl.v.or'+num+'.log')
        if os.path.isfile(log):
            area,lat,ff=parse_xml(d,log)
            file1.write(num+",")
            for j in range(8):
                file1.write(str(finalCombinations[int(num)][j])+",")
            file1.write(str(lat)+","+str(area)+","+str(ff)+"\n")
        else:
            pass
    file1.close()
if __name__ == "__main__":
    main()
        
