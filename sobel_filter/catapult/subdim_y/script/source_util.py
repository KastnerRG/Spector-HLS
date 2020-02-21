#! /usr/bin/env python3


f=open('impl_reports/sobely_utilization_routed0000.rpt','r')
a=f.readlines()
for line in f:
    print(line)
t=(a[76].split('|'))
if t[1].strip('  ')=='CLB':
    print(t[2].strip(' '))
f.close()

f=open('syn_reports/cycle0000.rpt','r')
b=f.readlines()
k=(b[23].split())
print(k)
f.close()

