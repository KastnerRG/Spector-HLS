#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
import numpy as np
import xml.etree.ElementTree as ET

B=[0]
tmpsize = [25, 100, 400]
size = [10000, 40000, 160000]
tmpdim =[5,10,20]
indim =[100,200,400]
UNROLL_FACTOR= [1,2,3,4]
UNROLL_LOOP1=[1,2,3,4]
UNROLL_LOOP2=[1,2,3,4]
UNROLL_LOOP3=[1,2,3,4]
UNROLL_LOOP4=[1,2,3,4]

blockCombinations = list(itertools.product(
    tmpdim, #0
    indim, #1
    UNROLL_FACTOR, #2
    UNROLL_LOOP1, #3
    UNROLL_LOOP2, #4
    UNROLL_LOOP3, #5
    UNROLL_LOOP4, #6
    tmpsize, #7
    size, #8
    B #9
    ))

finalCombinations = blockCombinations 
#print("HELLO")


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
        if c[7] != (c[0]*c[0]):
            copyit = False
        if c[8] != (c[1]*c[1]):
            copyit = False
        if copyit:
            finalList.append(c)

    return finalList


finalCombinations = removeCombinations(blockCombinations) 

def main():

    file1=open('asic_catapult_tempmatch_area.csv','w')
    file1.write("n"+","+"knob_tmpdim"+","+"knob_indim"+","+"knob_UNROLL_FACTOR"+","+"knob_UNROLL_LOOP1"+","+"knob_UNROLL_LOOP2"+","+"knob_UNROLL_LOOP3"+","+"knob_UNROLL_LOOP4"+","+"knob_tmpsize"+","+"knob_size"+","+"knob_I_B"+","+"obj1"+","+"obj2"+","+"FF"+"\n")
    for d in sorted(glob.glob('syn_reports/cycle*.rpt')):
        m = re.search('cycle(\d+)', d)
        num = m.group(1)
        print(num)
        log=os.path.join('syn_reports/concat_rtl.v.or'+num+'.log')
        if os.path.isfile(log):
            area,lat,ff=parse_xml(d,log)
            file1.write(num+",")
            for j in range(10):
                file1.write(str(finalCombinations[int(num)][j])+",")
            file1.write(str(lat)+","+str(area)+","+str(ff)+"\n")
    file1.close()
if __name__ == "__main__":
    main()
        
