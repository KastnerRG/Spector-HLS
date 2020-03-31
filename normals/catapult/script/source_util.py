#! /usr/bin/env python3


f=open('impl_reports/normal_utilization_routed0000.rpt','r')
a=f.readlines()
t=(a[76].split('|'))
if t[1].strip('  ')=='CLB':
    print(t[2].strip(' '))
t=(a[79].split('|'))
if t[1].strip('  ')=='LUT as Logic':
     lut=int(t[2].strip(' '))
     print(lut)
t=(a[86].split('|'))
if t[1].strip('  ')=='CLB Registers':
    ff=int(t[2].strip(' '))
    print(ff)
t=(a[117].split('|'))
if t[1].strip('  ')=='DSPs':
    dsp=int(t[2].strip(' '))
    print(dsp)
t=(a[102].split('|'))
if t[1].strip('  ')=='Block RAM Tile':
    bram=int(t[2].strip(' '))
    print(bram)
f.close()

f=open('syn_reports/cycle0007.rpt','r')
b=f.readlines()
k=(b[29].split())
print(k)
f.close()

