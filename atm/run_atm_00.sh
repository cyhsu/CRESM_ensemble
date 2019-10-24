#!/bin/bash
#-
#- Goals : Design a auto-processing program for ensemble run.
#-		1. call download.sh
#-		2. call data/*/wps/run_wps.sh
#-													by loops
#-
#- C.Y. Hsu @ 2017-10-24 TAMU
#--------------------------------------------
#--  B4 initial the code  --
source ~/.bashrc
##--  PARAMETERS from cpl_gom.sh  --
DEFU_DIR=`pwd`
WORK_DIR=$DEFU_DIR/atm
ytody=`date -d "$1 1 day ago" +%Y%m%d_%H%M%S`
today=`date -d "$1" +%Y%m%d`
tyear=`date -d "$1" +%Y`
thour=`date -d "$1" +%H`

cd $WORK_DIR
rm -rf time_calculation
touch time_calculation

echo "	ATM WORK_DIR" $WORK_DIR
echo "   ytody" $ytody
echo "	today" $today
echo "	tyear" $tyear
##-- DOWNLOAD GFS FORECAST : pre-process  --
for nruns in 00
do
	#--  to work directory  --
	cd $WORK_DIR
	echo "   ...  Initial the GEFS process  ..."; sleep 5
	echo "   ...  Download GEFS $nruns ensemble Forecast  ..."
	cp download_"$nruns".sh.sample download_"$nruns".sh
	#- change time period
	sed -i "s/20171023/$today/g" download_"$nruns".sh
	#- change forecast start hour
	sed -i "s/00\/pgrb2/$thour\/pgrb2/g" download_"$nruns".sh
	sed -i "s/t00z/t${thour}z/g" download_"$nruns".sh
	#- change run name
	if [ $nruns == '00' ]; then
		run_name='gec'$nruns
		run_dirc='central'
		echo '         ' $run_name
	else
		run_name='gep'$nruns
		run_dirc='ensemble'$nruns
		echo '         ' $run_name
	fi

 	mkdir -p $WORK_DIR/data/$run_dirc/old/$ytody
 	mv $WORK_DIR/data/$run_dirc/"$run_name"*pgrb2f* $WORK_DIR/data/$run_dirc/old/$ytody
 	zip -qr $WORK_DIR/data/$run_dirc/old/$ytody $WORK_DIR/data/$run_dirc/old/$ytody &

 	#--  DOWNLOAD GFS FORECAST : download data under ada-ftn1  --
	cp gefs_run.sh.sample gefs_run.sh
 	sed -i "s/download_00/download_$nruns/g" gefs_run.sh 
	./gefs_run.sh &
 
 	##--  Pre-WRF : WPS  --
 	echo "   ...  run wps  ..."
	WORK_WPS=$WORK_DIR/data/$run_dirc/wps
 	cd $WORK_WPS 
 	./run_wps.sh "$1" "$2" &
 	echo "   ... activate the wps ..." 
 	echo " "
done
