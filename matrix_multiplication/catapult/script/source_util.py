#! /usr/bin/env python3


f=open('impl_reports/matmul_utilization_routed0000.rpt','r')
a=f.readlines()
t=(a[76].split('|'))
if t[1].strip('  ')=='CLB':
    print(t[2].strip(' '))
f.close()

f=open('syn_reports/cycle0007.rpt','r')
b=f.readlines()
k=(b[25].split())
print(k)
k=k.remove("' '")
li=[]
print(k)
f.close()

