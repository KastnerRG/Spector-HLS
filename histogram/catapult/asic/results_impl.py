#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
import numpy as np
import xml.etree.ElementTree as ET

KNOB_NUM_HIST = [i for i in range(1,16)] # 0
KNOB_HIST_SIZE = [256] # 1
B=[0]
KNOB_UNROLL_LMM = [i for i in range(1,8)] # 2 
KNOB_UNROLL_LP  = [i for i in range(1,4)] # 3
I=[1]
KNOB_DATA_DIV = [True, False] # True for interleave, false for block # 4
KNOB_DATA_INTERLEAVE = [1, 2] # 5
KNOB_DATA_BLOCK = [1024,2048,4096,8192,16384,32768,65536] # 5

blockCombinations = list(itertools.product(
    KNOB_HIST_SIZE, #0
    KNOB_NUM_HIST,  #1
    KNOB_UNROLL_LMM, #2
    KNOB_UNROLL_LP, #3
    B, #4
    KNOB_DATA_BLOCK #5
    ))

interleaveCombinations = list(itertools.product(
    KNOB_HIST_SIZE, #0
    KNOB_NUM_HIST,  #1
    KNOB_UNROLL_LMM, #2
    KNOB_UNROLL_LP, #3
    I, #4
    KNOB_DATA_INTERLEAVE #5
    ))

#print("HELLO")
finalCombinations = blockCombinations + interleaveCombinations

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
    k=(b[22].split())
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

        if c[4] > c[2]: copyit = False
        if c[5] > c[3]: copyit = False
        if c[6] == 1 and (c[3] > 1 or c[2] == 1): copyit = False
        if c[6] == 1 and c[4] > 1: copyit = False
        if c[2] * c[3] > 1 and c[1] == 256 and c[0] > 4: copyit = False

        if copyit:
            finalList.append(c)

    return finalList


def main():

    file1=open('asic_catapult_histogram_latency.csv','w')
    file1.write("n"+","+"knob_KNOB_HIST_SIZE"+","+"knob_KNOB_NUM_HIST"+","+"knob_KNOB_UNROLL_LLM"+","+"knob_KNOB_UNROLL_LP"+","+"knob_I_B"+","+"knob_KNOB_DATA_BLOCK_INTERLEAVE"+","+"obj1"+","+"obj2"+","+"FF"+"\n")
    for d in sorted(glob.glob('syn_reports/cycle*.rpt')):
        m = re.search('cycle(\d+)', d)
        num = m.group(1)
        log=os.path.join('syn_reports/concat_rtl.v.or'+num+'.log')
        area,lat,ff=parse_xml(d,log)
        file1.write(num+",")
        for j in range(6):
            file1.write(str(finalCombinations[int(num)][j])+",")
        file1.write(str(lat)+","+str(area)+","+str(ff)+"\n")
    file1.close()
if __name__ == "__main__":
    main()
        
