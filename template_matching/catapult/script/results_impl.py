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
    t=(a[117].split('|'))
    print(t)
    if t[1].strip('  ')=='DSPs':
        dsp=int(t[2].strip(' '))
    t=(a[102].split('|'))
    if t[1].strip('  ')=='Block RAM Tile':
        bram=float(t[2].strip(' '))
        bram=int(bram)
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

    file1=open('catapult_tempmatch_latency.csv','w')
    file1.write("n"+","+"knob_tmpdim"+","+"knob_indim"+","+"knob_UNROLL_FACTOR"+","+"knob_UNROLL_LOOP1"+","+"UNROLL_LOOP2"+","+"UNROLL_LOOP3"+","+"UNROLL_LOOP4"+","+"tmpsize"+","+"size"+","+"knob_I_B"+","+"obj1"+","+"obj2"+","+"lut"+","+"ff"+","+"dsp"+","+"bram"+"\n")
    for d in sorted(glob.glob('impl_reports/tempmatch_export*.xml')):
        m = re.search('tempmatch_export(\d+)', d)
        num = m.group(1)
        synth_path=os.path.join('syn_reports/cycle'+num+'.rpt')
        d2=os.path.join('impl_reports/tempmatch_utilization_routed'+num+'.rpt')
        slices,lat,lut,ff,dsp,bram=parse_xml(d,synth_path,d2)
        if slices==0:
            pass
        else:
            file1.write(num+",")
            for j in range(10):
                file1.write(str(finalCombinations[int(num)][j])+",")
            file1.write(str(lat)+","+str(slices)+","+str(lut)+","+str(ff)+","+str(dsp)+","+str(bram)+"\n")
    file1.close()
if __name__ == "__main__":
    main()
        
