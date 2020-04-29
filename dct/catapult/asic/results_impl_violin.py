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
        try:
            last_line = f.readlines()[-1]
            last_line=last_line.split()
            print(last_line)
            area=last_line[5].split('=')[1]
            slack=last_line[8].split('=')[1]
        except:
            area=0
            slack=0

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
    throughput=1.0/float(throughput)
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
	
        #if c[2]>c[0] or c[2]>c[1]:
            #copyit =False

        if copyit:
            finalList.append(c)

    return finalList


def main():

    finalCombinations = removeCombinations(allCombinations)
    file1=open('asic_catapult_dct_area_violin.csv','w')
    file1.write("Parameter"+","+"Throughput_Value"+","+"Tool"+","+"Parameter2"+","+"Area_Value"+","+"Parameter3"+","+"FF_Value"+","+"Flow"+"\n")
    for d in sorted(glob.glob('syn_reports/cycle*.rpt')):
        m = re.search('cycle(\d+)', d)
        num = m.group(1)
        log=os.path.join('syn_reports/concat_rtl.v.or'+num+'.log')
        if os.path.isfile(log):
            area,lat,ff=parse_xml(d,log)
            if area==0:
                pass
            else: 
                file1.write("Throughput"+","+str(lat)+","+"catapult"+","+"Area"+","+str(area)+","+"FF"+","+str(ff)+","+"catapult_asic_area"+"\n")
    file1.close()
if __name__ == "__main__":
    main()
        
