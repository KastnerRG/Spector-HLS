#!/usr/bin/env python3
import itertools
import os, sys
import glob
import re
import numpy as np
import xml.etree.ElementTree as ET

B=[0]
dimx_part_factor = [2073600 , 1036800 , 518400 , 259200 , 129600 , 64800 , 32400 , 16200 , 8100 , 4050 , 2025,414720,207360,138240,103680,82944]
unroll_factor = [1,2,3,4,5,6,7,8]
subdim_y = [1,2,4,8,16,32]

blockCombinations = list(itertools.product(
    dimx_part_factor, #0
    unroll_factor, #2
    subdim_y, #3
    B #4
    ))

finalCombinations = blockCombinations 

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
        try:
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
        if c[5] > c[0]:
            copyit = False

        if copyit:
            finalList.append(c)

    return finalList


#finalCombinations = removeCombinations(finalCombinations) 

def main():

    file1=open('asic_catapult_sobely_area.csv','w')
    file1.write("n"+","+"knob_dimx_part_factor"+","+"knob_unroll_factor"+","+"knob_subdim_y"+","+"knob_I_B"+","+"Latency"+","+"Area"+","+"FF"+"\n")
    for d in sorted(glob.glob('syn_reports/cycle*.rpt')):
        m = re.search('cycle(\d+)', d)
        num = m.group(1)
        print(num)
        log=os.path.join('syn_reports/concat_rtl.v.or'+num+'.log')
        if os.path.isfile(log):
            area,lat,ff=parse_xml(d,log)
            if area==0:
                pass
            else:
                file1.write(num+",")
                for j in range(4):
                    file1.write(str(finalCombinations[int(num)][j])+",")
                file1.write(str(lat)+","+str(area)+","+str(ff)+"\n")
    file1.close()
if __name__ == "__main__":
    main()
        
