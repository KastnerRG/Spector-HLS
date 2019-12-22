#!/usr/bin/env python3

import os, sys
import glob
import shutil
import re
import subprocess
import multiprocessing as mp
import time
import datetime

logName = "pnr.log"
file_list=[]

file_list=glob.glob('rtl_files/histogram*')
print(file_list)
compiled = []
try:
    os.mkdir('impl')
except:
    pass
def run_script(path):
    print(path, "started at", datetime.datetime.now())
    try:
        m = re.search('histogram(\d+)', path)
        os.makedirs('impl/'+m[0])
        shutil.copy(path+'/'+'rtl.v','impl/'+m[0]+'/')
        shutil.copy(path+'/'+'concat_rtl.v','impl/'+m[0]+'/')
        shutil.copy('vivado_mentor.tcl','impl/'+m[0]+'/')
        shutil.copy('extraction.tcl','impl/'+m[0]+'/')
        shutil.copy('constr.xdc','impl/'+m[0]+'/')
        '''
        with open('impl/'+m[0]+'/'+'vivado_mentor.tcl', "r") as fin:
            text=''
            for line in fin:
                newline=line
                newline=line.replace("%1",'impl/'+m[0])
                text=text+newline
        with open('impl/'+m[0]+'/'+'vivado_mentor.tcl', "w") as fin:
                fin.writelines(text)
        '''
        start = time.time()
        command = " ".join(["timeout 3600","vivado","-mode","batch","-source","./vivado_mentor.tcl"])
        subprocess.check_output(command, cwd='impl/'+m[0], shell=True)
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
        outfile.close()

    except:
        raise



if os.path.isfile(logName):
    print("Reading processed folders from log file")
    logFile = open(logName, 'rt')
    for line in logFile:
        name = line.split('\n')
        compiled.append(name[0])
    logFile.close()
for f in compiled:
    file_list.remove(f)

print(file_list)
pool = mp.Pool()
result = pool.map_async(run_script, file_list).get(31536000)
