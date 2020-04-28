#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
import numpy as np
import xml.etree.ElementTree as ET

B=[0]
no_size = [16, 256, 1024, 2048, 4096, 8192]
outer_unroll = [1,2,3,4]
inner_unroll1 = [1,2,3,4]
inner_unroll2 = [1,2,3,4]
merge_unroll = [1,2,3,4]
array_part = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192]

blockCombinations = list(itertools.product(
    no_size, #0
    outer_unroll, #1
    inner_unroll1, #2
    inner_unroll2, #3
    merge_unroll, #4
    array_part, #5
    B #6
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
    k=(b[23].split())
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
        if c[0] % c[5] != 0:
            copyit = False
        if c[0] / c[5] > 128:
            copyit = False

        if copyit:
            finalList.append(c)

    return finalList


finalCombinations=removeCombinations(finalCombinations)

def main():

    file1=open('asic_catapult_mergesort_area.csv','w')
    file1.write("n"+","+"knob_no_size"+","+"knob_outer_unroll"+","+"knob_inner_unroll1"+","+"knob_inner_unroll2"+","+"knob_merge_unroll"+","+"knob_array_part"+","+"knob_I_B"+","+"Latency"+","+"Area"+","+"FF"+"\n")
    for d in sorted(glob.glob('syn_reports/cycle*.rpt')):
        m = re.search('cycle(\d+)', d)
        num = m.group(1)
        print(num)
        log=os.path.join('syn_reports/concat_rtl.v.or'+num+'.log')
        if os.path.isfile(log):
            try:
                area,lat,ff=parse_xml(d,log)
                file1.write(num+",")
                for j in range(7):
                    file1.write(str(finalCombinations[int(num)][j])+",")
                file1.write(str(lat)+","+str(area)+","+str(ff)+"\n")
            except:
                pass
        else:
            pass
    file1.close()
if __name__ == "__main__":
    main()
        
