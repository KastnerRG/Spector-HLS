#! /usr/bin/env python3


f=open('impl_reports/tempmatch_utilization_routed0000.rpt','r')
a=f.readlines()
t=(a[122].split('|'))
#if t[4].strip('  ')=='DSPs':
#    print(t[2].strip(' '))

f.close()
for line,val in enumerate(a):
    print(line,val)
#print(a)

f=open('syn_reports/cycle0007.rpt','r')
b=f.readlines()
k=(b[23].split())
print(k)
f.close()

