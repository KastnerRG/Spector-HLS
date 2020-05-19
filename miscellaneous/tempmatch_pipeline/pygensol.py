#!/usr/bin/env python3

import subprocess
import itertools
import sys
import os
import multiprocessing as mp
import argparse
import shutil
import time
import datetime


FULL_UNROLL = -1

logName = ""
logNameSynth = "synth.log"
logNamePnr   = "pnr.log"
logNameSynthTimeout = "synth.log.timeout_ols"

templateFilepath = "./src/params.h.template" # Knobs template file

outRootPath    = "./solutions"            # Name of output directory where all folders are generated
benchmark_name = "template_match"

files_to_copy = ["./src/fpga_temp_match.cpp", "./src/fpga_temp_matching.h", "./src/testbench.cpp"]

run_place_route = False



def run_script(path):
    print(path, "started at", datetime.datetime.now())
    
    try:
        start = time.time()
        if run_place_route:
            command = " ".join(["timeout 3600", "vivado_hls","-f","../../gen_pnr.tcl"])
        else:
            command = " ".join(["timeout 600", "vivado_hls","-f","../../gen_synth.tcl"])
        subprocess.check_output(command, cwd=path, shell=True)
        end = time.time()

        outFile = open(logName, 'at')
        outFile.write(path + '\n')
        outFile.close()
        
        outFile = open(logName + '.time', 'at')
        outFile.write(path + ',' + str(end-start) + '\n')
        outFile.close()

        print(path, "end at", datetime.datetime.now(), "  elapsed", end-start)

    except subprocess.CalledProcessError:
        print(path, "Timeout at", datetime.datetime.now())

        outFile = open(logName + '.timeout', 'at')
        outFile.write(path + '\n')
        outFile.close()

    except:
        raise


def write_params(finalCombinations, templateFilepath):
    dirlist = []
    
    for (num, values) in enumerate(finalCombinations):

        # Progress bar
        if(num % 1000) == 0:
            percent = float(num) / len(finalCombinations) * 100.0
            print("[" + str(int(percent)) + "%]")

        strValues = [' ' if v==FULL_UNROLL else str(v) for v in values]
        
        # Read template file and set the knob values
        knobs_text = ""
        with open(templateFilepath, "rt") as fin:
            for line in fin:

                newline = line

                for (i, replace) in reversed(list(enumerate(strValues))):
                    text = '%' + str(i+1)
                    newline = newline.replace(text, replace)

                knobs_text += newline


        # Write the knob file
        dirname = os.path.join(outRootPath, benchmark_name + str(num).zfill(4))
        if not os.path.exists(dirname):
            os.makedirs(dirname)
        dirlist.append(dirname)
        with open(os.path.join(dirname, "params.h"), "wt") as fout:
            fout.write(knobs_text)

        # Copy source files
        for f in files_to_copy:
            shutil.copy(f, dirname)

    return dirlist


# ***************************************************************************
# Knobs
# ***********

tmpdim =[5,10,20]
indim =[100,200,400]
UNROLL_FACTOR= [1,2,3,4]
II_LOOP1=[i for i in range(1,4)]
II_LOOP2=[i for i in range(1,4)]
II_LOOP3=[i for i in range(1,4)]
II_LOOP4=[i for i in range(1,4)]

allCombinations = list(itertools.product(
    tmpdim,        # 0
    indim,       # 1
    UNROLL_FACTOR,II_LOOP1,II_LOOP2,II_LOOP3,II_LOOP4    ))
# ***************************************************************************


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

    global logName
    global run_place_route
    global logNamePnrTimeout
    parser = argparse.ArgumentParser(description='Generate HLS solution set.')
    parser.add_argument('-np', '--num-processes', metavar='N', type=int, default=-1, help='Number of parallel processes (default: all)')
    parser.add_argument('-pnr', '--place-route', action='store_true', help='Run the place-and-route implementation instead of only the synthesis.')
    parser.add_argument('-dl', '--dir-list', help='Get directories to compile from a file.')
    parser.add_argument('-g', '--generate-only', action='store_true', help='Only generate solution folders.')
    parser.add_argument('-onc', '--output-not-compiled', help='Output list of folders not synthesized.')

    args = parser.parse_args()

    # Get number of processors
    num_processes = args.num_processes
    
    if num_processes > 0:
    	print("Using " + str(num_processes) + " processes")
    else:
    	print("Using all available processes")
   

    run_place_route = args.place_route

    if run_place_route:
        logName = logNamePnr
    else:
        logName = logNameSynth


    # Create combinations of knobs
    finalCombinations = removeCombinations(allCombinations)

    print("Num combinations: " + str(len(finalCombinations)))
    print("vs " + str(len(allCombinations)))


    dirlist = write_params(finalCombinations, templateFilepath)
    
    if args.dir_list:
        dirlist = [line.strip() for line in open(args.dir_list)]


    # Get folders already compiled from previous log file
    compiled = []

    if os.path.isfile(logName):
        print("Reading processed folders from log file")
        logFile = open(logName, 'rt')
        for line in logFile:
            name = line.split('\n')
            compiled.append(name[0])
        logFile.close()


    for f in compiled:
        dirlist.remove(f)
    


    if args.output_not_compiled:
        with open(args.output_not_compiled, 'wt') as f:
            for d in dirlist:
                f.write(d + '\n')


    if not args.generate_only:

        # Start processes 
        print("Processing " + str(len(dirlist)) + " folders")



        if num_processes > 0:
        	pool = mp.Pool(num_processes)
        else:
        	pool = mp.Pool()
        #pool.map(run_script, dirlist)
        result = pool.map_async(run_script, dirlist).get(31536000) # timeout of 365 days





if __name__ == "__main__":
    main()

