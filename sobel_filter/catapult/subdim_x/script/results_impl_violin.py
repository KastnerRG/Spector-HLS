#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
import numpy as np
import xml.etree.ElementTree as ET

# ***************************************************************************
# Knobs
# ***********
blockdim_x =[1,2,4,8]
blockdim_y =[1,2,4,8]
unroll_dct=[1,2,4,8]
unroll_width=[1,2,4,8]
unroll_height=[1,2,4,8]
array_partition=[1,2,4,8]


allCombinations = list(itertools.product(
    blockdim_x,
    blockdim_y,
    unroll_dct,
    unroll_width,
    unroll_height,
    array_partition))



# ***************************************************************************


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
    print("Latency: {}".format(k[4]))
    avg_latency=int(k[4])
    f.close()
    
    throughput="{0:.6f}".format(((int(avg_latency)*float(est_clk_period))/1000000000))
    throughput=1.0/float(throughput)
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
	
        #if c[2]>c[0] or c[2]>c[1]:
            #copyit =False

        if copyit:
            finalList.append(c)

    return finalList


def main():

    #finalCombinations = removeCombinations(allCombinations)
    file1=open('catapult_sobelx_area_violin.csv','w')
    file1.write("Parameter"+","+"Throughput_Value"+","+"Tool"+","+"Resource_Type"+","+"Resource_Value"+","+"Parameter3"+","+"FF_Value"+","+"Flow"+"\n")
    for d in sorted(glob.glob('impl_reports/sobelx_export*.xml')):
        m = re.search('sobelx_export(\d+)', d)
        num = m.group(1)
        synth_path=os.path.join('syn_reports/cycle'+num+'.rpt')
        d2=os.path.join('impl_reports/sobelx_utilization_routed'+num+'.rpt')
        slices,lat,lut,ff,dsp,bram = parse_xml(d, synth_path, d2)
        
        file1.write("Throughput"+","+str(lat)+","+"catapult"+","+"CLB"+","+str(slices)+","+"FF"+","+str(ff)+","+"catapult_fpga_area"+"\n")
        file1.write("Throughput"+","+str(lat)+","+"catapult"+","+"LUT"+","+str(lut)+","+"FF"+","+str(ff)+","+"catapult_fpga_area"+"\n")
        file1.write("Throughput"+","+str(lat)+","+"catapult"+","+"FF"+","+str(ff)+","+"FF"+","+str(ff)+","+"catapult_fpga_area"+"\n")
        file1.write("Throughput"+","+str(lat)+","+"catapult"+","+"DSP"+","+str(dsp)+","+"FF"+","+str(ff)+","+"catapult_fpga_area"+"\n")
        file1.write("Throughput"+","+str(lat)+","+"catapult"+","+"BRAM"+","+str(bram)+","+"FF"+","+str(ff)+","+"catapult_fpga_area"+"\n")
    file1.close()
if __name__ == "__main__":
    main()
        
