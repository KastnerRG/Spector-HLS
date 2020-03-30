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
logNamePnr = "pnr.log"


tparamFilepath = "./src/params.h.template"
tdirectiveFilepath = "./src/directives.tcl.template"

outRootPath = "./solutions"
benchmark_name = "dct"

files_to_copy = ["./src/dct.cpp", "./src/dct.h"]

run_place_route = False

def run_script(path):
    print(path, "started at", datetime.datetime.now())

    try:
        start = time.time()
        if run_place_route:
            command = " ".join(["timeout 7200", "vivado_hls","-f","../../gen_pnr.tcl"])
        else:
            command = " ".join(["timeout 7200", "/home/ubuntu/catapult/Mgc_home/bin/catapult","-shell" ,"-f", "directives.tcl"])
        subprocess.check_output(command, cwd=path, shell=True)
        end = time.time()

        outFile = open(logName, 'at')
        outFile.write(path + "\n")
        outFile.close()

        outFile = open(logName + ".time", 'at')
        outFile.write(path + ',' + str(end-start) + '\n')
        outFile.close()

        print(path, "end at", datetime.datetime.now(), " elapsed", end-start)

    except subprocess.CalledProcessError:
        print(path, "Timeout at", datetime.datetime.now())

        outFile = open(logName + '.timeout', 'at')
        outFile.write(path + '\n')
        outFile.close()

    except:
        raise

def write_params(finalCombinations, tparamFilepath, tdirectiveFilepath):
    dirlist = []
    
    for (num, values) in enumerate(finalCombinations):

        # Progress bar
        if(num % 1000) == 0:
            percent = float(num) / len(finalCombinations) * 100.0
            print("[" + str(int(percent)) + "%]")

        strValues = [' ' if v==FULL_UNROLL else str(v) for v in values]
        
        # Read template file and set the knob values
        directives_text = ""
        params_text = ""
        with open(tparamFilepath, "rt") as fin:
            for line in fin:

                newline = line

                for (i, replace) in reversed(list(enumerate(strValues))):
                    text = '%' + str(i)
                    newline = newline.replace(text, replace)

                params_text += newline
        
        with open(tdirectiveFilepath, "rt") as fin:
            for line in fin:

                newline = line

                for (i, replace) in reversed(list(enumerate(strValues))):
                    if replace == 'I' or replace == 'B':
                        if replace == 'I':
                            replace = "INTERLEAVE"
                        else:
                            replace = "BLOCK_SIZE"
                    text = '%' + str(i)
                    newline = newline.replace(text, replace)

                directives_text += newline


        # Write the params.h file
        dirname = os.path.join(outRootPath, benchmark_name + str(num).zfill(4))
        if not os.path.exists(dirname):
            os.makedirs(dirname)
        dirlist.append(dirname)
        with open(os.path.join(dirname, "params.h"), "wt") as fout:
            fout.write(params_text)
        with open(os.path.join(dirname, "directives.tcl"), "wt") as fout:
            fout.write(directives_text)
        # Copy source files
        for f in files_to_copy:
            shutil.copy(f, dirname)

    return dirlist

# *****************
# knobs 
# *****************

blockdim_x =[1,2,4,8]
blockdim_y =[1,2,4,8]
unroll_dct=[1,2,4,8]
unroll_width=[1,2,4,8]
unroll_height=[1,2,4,8]
array_partition1=[1,2,4,8]
array_partition2=[4194304,2097152,1048576,524288]

blockCombinations = list(itertools.product(
    blockdim_x, #0
    blockdim_y, #1
    unroll_dct, #2
    unroll_width, #3
    unroll_height, #4
    array_partition1, #5
    array_partition2,#6
    "B" #7
    ))

# -----------------------------------------------------

def removeCombinations(combs):

    finalList = []

    for c in combs:
        copyit = True
        if c[5] == 1 and c[6] != 4194304:
            copyit = False
        if c[5] == 2 and c[6] != 2097152:
            copyit = False
        if c[5] == 4 and c[6] != 1048576:
            copyit = False
        if c[5] == 8 and c[6] != 54288:
            copyit = False
        if copyit:
            finalList.append(c)
#
    return finalList

finalCombinations = removeCombinations(blockCombinations)
print("final combinations are " + str(len(finalCombinations)))
def main():

    global logName
    global run_place_route

    parser = argparse.ArgumentParser(description='Generate HLS RTL set.')
    parser.add_argument('-np', '--num-processes', metavar='N', type=int, default=-1, help='Number of parallel processes (default: all)')
    parser.add_argument('-pnr', '--place-route', action='store_true', help='Run the place-and-route implementation instead of only the synthesis.')
    parser.add_argument('-dl', '--dir-list', help='Get directories to compile from a file.')
    parser.add_argument('-g', '--generate-only', action='store_true', help='Only generate solution folders.')
    parser.add_argument('-onc', '--output-not-compiled', help='Output list of folders not synthesized.')

    args = parser.parse_args()

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
    
    #finalCombinations = removeCombinations(finalCombinations)
    fCombinations = finalCombinations
    print("Num combinations: " + str(len(fCombinations)))
 
    dirlist = write_params(fCombinations, tparamFilepath, tdirectiveFilepath)

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
