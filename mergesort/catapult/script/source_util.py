#! /usr/bin/env python3

f=open('impl_reports/timing_summary_routed0000.rpt','r')
a=f.readlines()
t=str(a[129].strip(' '))
t=float(t[:5])
lat="{0:.3f}".format(float(10-t))
print(lat)
f.close()

f=open('impl_reports/utilization_placed0000.rpt','r')
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
if t[1].strip('  ')=='DSPs':
    dsp=int(t[2].strip(' '))
t=(a[102].split('|'))
if t[1].strip('  ')=='Block RAM Tile':
    bram=int(t[2].strip(' '))
f.close()

print(slices,lut,ff,dsp,bram)

f=open('syn_reports/cycle0000.rpt','r')
b=f.readlines()
k=(b[23].split())
print(k)
f.close()

