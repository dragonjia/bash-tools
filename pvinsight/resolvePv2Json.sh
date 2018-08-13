#!/usr/bin/env bash


tail -100f ../logs/pv_access.log |awk '{ip=$1;split($7,m,"=");for(i=1;i<10;i+=2){if(index(m[i],"pvInsightObj")>0){print m[i+1]}}}'
