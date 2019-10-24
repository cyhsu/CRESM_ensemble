#!/bin/bash
#-
#- Routine to download the GFS 7 days forecast.
#-
#- C.Y. Hsu @ 2017-09-21 TAMU
#--------------------------------------------

#--  B4 initial the code  --
##--  PARAMETERS from cpl_gom.sh  --
DEFU_DIR=`pwd`
WORK_DIR=$DEFU_DIR/atm
WORK_WPS=$WORK_DIR/data/wps
today=`date -d "$1" +%Y%m%d`
tyear=`date -d "$1" +%Y`

##-- adding for crontab 2017-10-05 --###########
file_break=0
while [ $file_break -eq 0 ]
do
	if [ -f *f216.grib2 ]; then
		file_break=1
	else 
		sleep 120
	fi
done

##--  MOVE : old GFS data to its own directory  --
cd $WORK_DIR/data
ftim=`ls *.grib2 |head -1|sed 's/.*0p25.//' | sed 's/.f000.*//'`
mkdir -p "old/$ftim"; mv *grib2 "old/$ftim"; zip -r "old/$ftim" "old/$ftim" &

##--  MOVE : new GFS data to the "data directory"  --
mv ../*grib2 .

##--  Pre-WRF : WPS  --
echo "...  run wps  ..."
cd $WORK_WPS 
./run_wps.sh
echo "done" 
echo " "
echo " "
echo " "

