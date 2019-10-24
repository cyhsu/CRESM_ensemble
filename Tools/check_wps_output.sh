#!/bin/bash

num=0
echo " "

find ./* -name "wps_run.out*" |while read fid; do echo $((num+=1)); echo $fid; grep --colour "Successful" $fid | sed 's/.*Succ/Succ/';  echo " "; done
