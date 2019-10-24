#!/bin/bash

for num in {01..20}; 
do 
	dirc='ensemble'$num; 
	mv $dirc/wrfinput_d01 $dirc/wrfinput_d01.central
	mv $dirc/wrflowinp_d01 $dirc/wrflowinp_d01.central
	cd $dirc 
	ln -s ../../atm/data/$dirc/wps/wrfinput_d01 . 
	ln -s ../../atm/data/$dirc/wps/wrflowinp_d01 . 
	cd .. 
done
