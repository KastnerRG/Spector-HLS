#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
import numpy as np
import xml.etree.ElementTree as ET

KNOB_NUM_HIST  = [i for i in range(1, 16)]
KNOB_HIST_SIZE = [256]

KNOB_NUM_WORK_ITEMS  = [1, 2, 4, 8]
KNOB_NUM_WORK_GROUPS = [1, 2, 4, 8]
KNOB_UNROLL_FACTOR   = [i for i in range(1,16)]
PIPE_FACTOR          = [0, 1, 2]
KNOB_SIMD            = [1]
KNOB_COMPUTE_UNITS   = [1]

KNOB_ACCUM_SMEM      = [0]


allCombinations = list(itertools.product(
    KNOB_NUM_HIST,        # 0
    KNOB_HIST_SIZE,       # 1
    KNOB_NUM_WORK_ITEMS,  # 2
    KNOB_NUM_WORK_GROUPS, # 3
    KNOB_SIMD,            # 4
    KNOB_COMPUTE_UNITS,   # 5
    KNOB_ACCUM_SMEM,      # 6
    KNOB_UNROLL_FACTOR,    # 7
    PIPE_FACTOR		  # 8
    ))

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
    slices=root.find('AreaReport/Resources/SLICE').text
    slices=int(slices)
    tree=ET.parse(filename2)
    root=tree.getroot()
    avg_latency = root.find('PerformanceEstimates/SummaryOfOverallLatency/Average-caseLatency').text
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

    finalCombinations = removeCombinations(allCombinations)
    file1=open('final_result_impl.csv','w')
    file1.write("n"+","+"knob_NUM_HIST"+","+"knob_HIST_SIZE"+","+"knob_NUM_WORK_ITEMS"+","+"knob_NUM_WORK_GROUPS"+","+"knob_SIMD"+","+"knob_COMPUTE_UNITS"+","+"knob_ACCUM_SMEM"+","+"knob_UNROLL_FACTOR"+","+"knob_PIPE_FACTOR"+","+"obj1"+","+"obj2"+"\n")
    for d in sorted(glob.glob('impl_reports/histogram_main_export*.xml')):
        m = re.search('histogram_main_export(\d+)', d)
        num = m.group(1)
        synth_path=os.path.join('syn_reports/csynth'+num+'.xml')
        slices,lat=parse_xml(d,synth_path)
        file1.write(num+",")
        for j in range(9):
            file1.write(str(finalCombinations[int(num)][j])+",")
        file1.write(str(lat)+","+str(slices)+"\n")
    file1.close()
if __name__ == "__main__":
    main()
        
