#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
#import numpy as np
import xml.etree.ElementTree as ET

# ***************************************************************************
# Knobs
# ***********

tmpdim =[5,10,20]
indim =[100,200,400]
UNROLL_FACTOR= [1,2,3,4]
UNROLL_LOOP1=[1,2,3,4]
UNROLL_LOOP2=[1,2,3,4]
UNROLL_LOOP3=[1,2,3,4]
UNROLL_LOOP4=[1,2,3,4]

allCombinations = list(itertools.product(
    tmpdim,        # 0
    indim,       # 1
    UNROLL_FACTOR,UNROLL_LOOP1,UNROLL_LOOP2,UNROLL_LOOP3,UNROLL_LOOP4    ))
# ***************************************************************************


def parse_resources(resources_node):
    tags = ['BRAM_18K','DSP48E','FF','LUT']
    resources = [ resources_node.find(t).text for t in tags ]
    return list(map(int, resources))


def parse_xml(filename1,filename2):
    tree = ET.parse(filename1)
    root = tree.getroot()

    #resources_node       = root.find('AreaEstimates/Resources')
    #avail_resources_node = root.find('AreaEstimates/AvailableResources')
    est_clk_period = root.find('TimingReport/AchievedClockPeriod').text
    slices = root.find('AreaReport/Resources/SLICE').text
    slices=int(slices)
    tree=ET.parse(filename2)
    root=tree.getroot()
    avg_latency = root.find('PerformanceEstimates/SummaryOfOverallLatency/Average-caseLatency').text
    throughput="{0:.3f}".format(((int(avg_latency)*float(est_clk_period))/1000000000))

    #avail_resources = parse_resources(avail_resources_node)

    #resources_util = np.divide(resources, avail_resources)*100
    #for i in range(4):
        #resources_util[i]="{0:.2f}".format(resources_util[i])
    return slices,throughput



def removeCombinations(combs):

    finalList = []

    for c in combs:
        copyit = True

        #if c[2]>c[0] or c[2]>c[1]:
            #copyit =False

        if copyit:
            finalList.append(c)

    return finalList


def main():
    ct=0
    max_thru=0
    finalCombinations = removeCombinations(allCombinations)
    file1=open('final_result_impl_tempmatch.csv','w')
    file1.write("n"+","+"knob_tmpdim"+","+"knob_indim"+","+"knob_UNROLL_FACTOR"+","+"knob_UNROLL_LOOP1"+","+"knob_UNROLL_LOOP2"+","+"knob_UNROLL_LOOP3"+","+"knob_UNROLL_LOOP4"+","+"obj1"+","+"obj2\n")
    for d in sorted(glob.glob('impl_reports/SAD_MATCH_export*.xml')):
        m = re.search('SAD_MATCH_export(\d+)', d)
        num = m.group(1)
        synth_path=os.path.join('syn_reports/SAD_MATCH_csynth'+num+'.xml')
        if os.path.isfile(synth_path)and os.path.isfile(d):
            ct=ct+1
        print(ct)
        slices,lat=parse_xml(d,synth_path)
        if float(lat)>float(max_thru):
            max_thru=float(lat)

        file1.write(num+",")
        for j in range(7):
            file1.write(str(finalCombinations[int(num)][j])+",")
        file1.write(str(lat)+","+str(slices)+"\n")
    print(max_thru)
if __name__ == "__main__":
    main()
